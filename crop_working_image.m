function crop_working_image(config)

%Now we load the image before the slump
folder = config.data{1};
filename = config.data{2};
strfilename = strsplit(filename, '.');
strfilename = strfilename{1};
choice = questdlg('Would you like to create a new subfigure', 'SkyNet Interface', 'Yes', 'No', 'No');
switch choice
    case 'Yes'
        [img_file, path] = uigetfile(fullfile(config.data{1}, '*'));
    case 'No'
        return
        
end
filename = fullfile(path, img_file);
if strcmp(config.data{10},'CTX')
    red_level = 0;
else
    red_level = 2;
end
red_level
choice_image = questdlg('Is the source PNG or JP2', 'SkyNet Interface', 'PNG', 'JP2', 'JP2');
switch choice_image
    case 'PNG'
        img = imread(filename);
    case 'JP2'
        img = imread(filename, 'ReductionLevel', red_level);
end
%Next we choose the points that will serve as our upper left corner and
%lower right corner in the cropped image (i.e. that part of the image with
%rootless cones)
points = readPoints_v2(img, 2);
%readPoints_v2 comes out with an 2xn matrix with n being the number of points
%specified. Thus, the top left corner is in points(:,1) and the bottom
%right corner is in points(:,2)
cropped_image = img(points(2,1):points(2,2),points(1,1):points(1,2));
cropped_image = uint8(255*mat2gray(cropped_image));

%First we save the files for analysis, these files have no scale image
[path, filename, extension] = fileparts(fullfile(path,img_file));
if ~exist(fullfile(path,img_file), 'dir')
    mkdir(path, filename); %create the directory to hold the image
path = fullfile(path, filename); %move one directory down
list_files = dir(fullfile(path,'*.png'));
crop_list = [];
if isempty(list_files)
    counter = '1';
else
    for list_idx = 1:numel(list_files)
        splited_name = strsplit(list_files(list_idx).name, '.');
        splited_name = strsplit(splited_name{end-1},'_');
        crop_list(end+1) = str2num(splited_name{end});

    end
    crop_list = sort(crop_list);
    counter = num2str(crop_list(end) + 1);
end
mkdir(path,[filename, '_crop_', counter])
img_filename = filename;
crop_filename_path = fullfile(path, [filename, '_crop_', counter]);
A1 = [points(1,1), points(2,1)];
A2 = [points(1,2), points(2,2)];
formatSpec = 'Upper Left X is %4.2f and Y is %8.3f \n';
formatSpec2 = 'Lower Right X is %4.2f and Y is %8.3f \n';

filename = strcat(fullfile(path, filename), '_crop_', counter, '.png');
text_filename = strcat(crop_filename_path, '\', img_filename, '_crop_', counter, '.txt');
fileID = fopen(text_filename,'w');
fprintf(fileID,formatSpec,A1);
fprintf(fileID,formatSpec2,A2);
fclose(fileID);
imwrite(cropped_image,filename)
image_zscore(filename, config.data{7}, config.data{9}, 1)%calculate mean and std for different window sizes and given step
end

