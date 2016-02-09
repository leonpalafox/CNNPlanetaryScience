function create_dataset(feature, config)
%%
%%This functions opens a given image and allows to create a dataset of
%%the indicated feature
%%Each image is saved using the descriptior of the hirise image as well as
%%the upper and lower coordinates in a mat file
%check if feature is in feature list
feature_list = strtrim(strsplit(config.data{3},',')); %get all of the features list
if isempty(strmatch(feature, feature_list, 'exact'))&&~strcmp(feature, 'negative')
    error('This is an unvalid feature')
end
message = ['Would you like to tag a few more examples of ' feature '?'];
choice = questdlg(message, 'SkyNet Interface', 'Yes', 'No', 'No');
switch choice
    case 'Yes'
        waitfor(msgbox('Please select the image you want to use to tag')); %waits for user click 
        
    case 'No'
        return
        
end
[img_file, path] = uigetfile(fullfile(config.data{1}, '*')); %here we select the image that we wish to use for the tagging
[path, filename, extension] = fileparts(fullfile(path,img_file)); %get the different parts of the filename
hirise_img = imread(fullfile(path, img_file));
%Check if the filename exists in the workspace and if it does,it marks with
%a red dote the points already labeled
[old_coord, hirise_img] = analyse_image(path, filename, hirise_img, feature); %MODIFY

waitfor(msgbox(['You will be tagging ' feature]));
if ~strcmp(feature, 'negative')
    n = config.data{4}; %Same number of positive examples for all features
else
    n = config.data{5};
end
maxim=cell2mat(config.data(7));
max_size=max(maxim);
coordinates = round(readPoints_v3(hirise_img, max_size, n));%First we read the two points for the image
coordinates = [old_coord, coordinates];
y_coord = coordinates(1,:); %careful with the orientation
x_coord = coordinates(2,:);
name = [feature,'_','coordinates_',filename, '.mat'];
path = fullfile(path, filename); %navigate inside its respective folder
save(fullfile(path,name),'y_coord', 'x_coord') %Here we save only the coordinates, not the windows




%save('hiriseTrainSubset.mat', 'numTrainImages', 'trainImages', 'trainLabels');