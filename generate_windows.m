function generate_windows(feature, config)
%This function generates the windows given different windows, sizes, it
%only creates coordinates, not actual windows from the image
%it will crawl the given folder in filename to find the windows for
%respective existing png files (if there is no png file, it won't look for
%windows)
feature_list = strtrim(strsplit(config.data{3},',')); %get all of the features list
if isempty(strmatch(feature, feature_list, 'exact'))&&~strcmp(feature, 'negative')
    error('This is an unvalid feature')
end
path = config.data{1};
d = dir(path);%This lists all the folders
isub = [d(:).isdir]; %# returns logical vector indicating if it is a folder
nameFolds = {d(isub).name}'; %get the names of the folders
nameFolds(ismember(nameFolds,{'.','..'})) = []; %remove .. and .
windows_size = config.data{7};
for fold_idx = nameFolds' %now we crawl each folder
    folderpath = fullfile(path, fold_idx);
    png_files = dir(fullfile(folderpath{1},'*.png')); %get only the png files
    png_files = {png_files.name}; %get a list of the names
    for png_idx = png_files
        single_file = fullfile(folderpath,png_idx);
        [single_path, folder_name] = fileparts(single_file{1});
        if exist(fullfile(single_path, folder_name)) == 7 %there is a folder for this image
            coordinate_path = fullfile(single_path, folder_name);
            mat_file = fullfile(coordinate_path, [feature '_coordinates_' folder_name '.mat']); %mat file in the folder
            if exist(mat_file)
                load(mat_file);              
                    for size_idx = 1:length(windows_size)
                        data = generate_datapoints(y_coord, x_coord, 4, windows_size(size_idx));%creates de datapoints with a given size
                        %We will generate a file that has all the coordinates of the data sets.
                        %structure is 
                        %data = [y_coord(1):y_coord(2)
                        %        x_coord(1):x_coord(2)]

                        close all
                        %Double check for size consistency
                        name = ['window_size' num2str(windows_size(size_idx)) '_' feature '_data_'];
                        savename = [name, folder_name '.mat'];
                        save(fullfile(coordinate_path,savename),'data')
                    end
            end
        end
            
            
        
        
        
        
    end
    
    
end



