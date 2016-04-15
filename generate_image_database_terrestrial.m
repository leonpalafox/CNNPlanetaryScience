function generate_image_database_terrestrial(config, pixel_size, resize_scale)
%In this script, we take all the images and make them the same size
%as well as we flatten them to input in a classifier
%We also transform it, so it works with different scales
%%First we load the data matrix

%%First we need to find alll of the mat files

%%
%%Check if the pixel size is within the range
if ~ismember(pixel_size, config.data{7})
    error('myApp:argChk', 'The pixel size is not within the range') 
end
TransMatrix = [resize_scale, 0; 0, resize_scale]; %This matrix controls the transformation of the points
%first we find all the foldersin the data folder
path = config.data{1};
d = dir(path);%This lists all the folders
isub = [d(:).isdir]; %# returns logical vector indicating if it is a folder
nameFolds = {d(isub).name}; %get the names of the folders
nameFolds(ismember(nameFolds,{'.','..'})) = []; %remove .. and .
master_im_idx = 1; %this way we gather all the training examples
label_file_out = {};
image_array = [];
for hirise_img_idx = nameFolds %start crawling the folders
    hirise_folder_path = fullfile(path, hirise_img_idx);
    d = dir(hirise_folder_path{1});%This lists all the folders
    isub = [d(:).isdir]; %# returns logical vector indicating if it is a folder
    name_crop_folders = {d(isub).name}; %get the names of the folders
    name_crop_folders(ismember(name_crop_folders,{'.','..'})) = []; %remove .. and .
    %now we crawl the cropped folders

    for crop_file_idx = name_crop_folders
        mat_files = dir(fullfile(hirise_folder_path{1},crop_file_idx{1},['window_size' num2str(pixel_size) '_*_' crop_file_idx{1} '.mat'])); %finds all the files that have widnows of the pixel size
        mat_file_path = fullfile(hirise_folder_path{1}, crop_file_idx{1});
        
        if ~isempty(mat_files)
           
            mat_files_cell = {mat_files.name};
            master_label = {};
            master_data = [];
            for mat_file_idx = mat_files_cell
                load(fullfile(mat_file_path, mat_file_idx{1}));
                file_feat = strsplit(mat_file_idx{1}, '_'); %we get the feature of this file
                file_feat = file_feat(3); 
                datap = size(data,3); %get the number of datapoints
                label_file=repmat(file_feat,1,datap);
                master_label = cat(2,master_label, label_file);%concatenate all the labels for this dataset
                master_data = cat(3,data,master_data);
            end
            label_file_out = cat(2, label_file_out, master_label);
            for mat_file_idx = mat_files_cell
                load(fullfile(mat_file_path, mat_file_idx{1}));
                cropped_img = imread(fullfile(hirise_folder_path{1},[crop_file_idx{1},'.png']));
                cropped_img = imresize(cropped_img, resize_scale);%here we control the scale
                cropped_img = double(cropped_img)/255;
                for im_idx = 1:size(data,3)
                    row_low = data(2,1,im_idx);
                    col_low = data(1,1,im_idx);                
                    %Transform using the matrix, only the low set of
                    %coordinates
                    new_low = floor(TransMatrix*[row_low;col_low]);
                    row_low = new_low(1);
                    col_low = new_low(2);
                    test_img = cropped_img(row_low:row_low + pixel_size - 1,col_low:col_low + pixel_size-1,:); %extract the imgaages
                    image_array(:,:,master_im_idx) = test_img;
                    master_im_idx = master_im_idx+1;
                end
            end

        end
       
    end
end
%create folder with the data
data_folder_name = 'hirise_data';
if ~exist(fullfile(path, data_folder_name))
    mkdir(path, data_folder_name)
end
%%
%Now we read the terrestrial images
index_tars = find(strcmp(label_file_out,'TARS')); %Find the current positive examples
image_array(:,:,index_tars) = []; %erase tar examples
label_file_out(index_tars) = [];
image_tars = read_terr_data(pixel_size); %we get the tar data
terr_labels = repmat({'TARS'}, [1,size(image_tars, 3)]); %Create new set of labels
label_file_out = [label_file_out, terr_labels]; %create the set of labels;
image_array = cat(3,image_array, image_tars); %postappend the terrestrial data
%%
%Here we save to file
data_folder_path = fullfile(path, data_folder_name);
name = 'all_images_';
savename = [name,num2str(pixel_size),'.mat'];
savename_labels = ['labels_', num2str(pixel_size),'.mat'];
save(fullfile(data_folder_path, savename),'image_array')
save(fullfile(data_folder_path, savename_labels),'label_file_out')

