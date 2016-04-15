function read_reshape_dataset_labeled(config, pixel_size, resize_scale)
%In this script, we take all the images and make them the same size
%as well as we flatten them to input in a classifier
%We also transform it, so it works with different scales
%%First we load the data matrix
folder  = '..\Data\';
filename = config.data{2};
strfilename = strsplit(filename, '.');
strfilename = strfilename{1};
% cell_size=config.data{8};
% cell_size=double(cell_size);


%%First we need to find alll of the mat files

%%
%%Check if the pixel size is within the range
if ~ismember(pixel_size, config.data{7})
    error('myApp:argChk', 'The pixel size is not within the range') 
end

mat_files = dir(['window_size' num2str(pixel_size) '_*_' strfilename '.mat']); %finds all the files that have widnows of the pixel size
%%
%Now we concatenate all of the data files in them
TransMatrix = [resize_scale, 0; 0, resize_scale]; %This matrix controls the transformation of the points
master_data=[];
master_label = {};
file_number = size(mat_files,1);
for file_idx = 1:file_number
    load(mat_files(file_idx).name)
    file_feat = strsplit(mat_files(file_idx).name, '_'); %we get the feature of this file
    file_feat = file_feat(3); 
    datap = size(data,3); %get the number of datapoints
    label_file=repmat(file_feat,1,datap);
    master_label = cat(2,master_label, label_file);%concatenate all the labels for this dataset
    master_data = cat(3,data,master_data);
end
   
%data = [y_coord(1):y_coord(2)
%        x_coord(2):x_coord(2)]
%Now we need to load all the the JP2 images
image_files = dir([folder, '*.png']);
number_files = size(image_files,1);
number_mat_files = size(mat_files,1);
image_array = [];
master_im_idx = 1;
feature_array{2}=[];
feature_array{4}=[];
feature_array{6}=[];
feature_array{8}=[];
for  file_idx= 1:number_files
    strfilename = strsplit(image_files(file_idx).name, '.');
    strfilename = strfilename{1};
    %Check if the file image has a correspondet mat file
    for mat_idx = 1:number_mat_files
        str = mat_files(mat_idx).name;
        if ~isempty(regexp(str, strfilename, 'match'))
            load(str)
            hirise_img = imread([folder image_files(file_idx).name]);%Load the file image
            hirise_img = imresize(hirise_img, resize_scale);%here we control the scale
            hirise_img = double(hirise_img)/255;
            for im_idx = 1:size(data,3)
                row_low = data(2,1,im_idx);
                col_low = data(1,1,im_idx);                
                %Transform using the matrix, only the low set of
                %coordinates
                new_low = floor(TransMatrix*[row_low;col_low]);
                row_low = new_low(1);
                col_low = new_low(2);
                test_img = hirise_img(row_low:row_low + pixel_size - 1,col_low:col_low + pixel_size-1,:); %extract the imgaages
                image_array(:,:,master_im_idx) = test_img;
                for cell_size=2:2:8
                    features(1,:,master_im_idx)={extractHOGFeatures(test_img,'CellSize',[cell_size cell_size])}; 
                    feature_array{cell_size}=[feature_array{cell_size} features(1,:,master_im_idx)];
                    clear features
                end
                master_im_idx = master_im_idx+1;
            end
        end
    end
end
data_folder = '..\Data\';
name = 'all_images_';
samples = num2str(size(master_label,2));
savename = [data_folder name,num2str(pixel_size),'_' samples,'_', strfilename '.mat'];
save(savename,'image_array')
savename_feat = [data_folder name, samples, '_', strfilename '.mat'];
%save(savename_feat,'feature_array')
[n,m,samples]= size(image_array);
image_flat = reshape(permute(image_array,[3 2 1]),samples,n*m);
pcacoeff={pca(image_flat')};
images = image_flat;
labels = master_label;
image_structure=struct('Original_Images',{images},'HoG_Features_2x2',{feature_array{2}},'HoG_Features_4x4',{feature_array{4}},'HoG_Features_6x6',{feature_array{6}},'HoG_Features_8x8',{feature_array{8}},'PCA_Coefficients',{pcacoeff},'Labels',{labels});
end