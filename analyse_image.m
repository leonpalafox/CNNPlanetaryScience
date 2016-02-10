function [coord, jp_image] = analyse_image(path, filename, jp_image_org, feature)
%%This function checks whether the current filename has already been
%%analyzed, if it has, it marks the coordinates, and
%%populates the data vector with the existent coordinates from before.
%%
%% This way, we can work in a systematic fashion tagging features
%Input:
%strfilneame: Is the name of the HiRise image, already stripped from the
%QLOOOK and extension strings
%jp_image_org: Is the original image that has already been loaded
%Output:
%coord: is the vector that already has all of the points that we have already
%selected, is an empty array if nothing has been done
%jp_image: Image with the balckout spots

files = dir(fullfile(path,filename,'*.mat'));
%Now we iterate over all the mat files to check for existing data
file_number = size(files,1);
data_file = 'None';
file_to_search = [feature '_coordinates_' filename]; %search for the file that has those features

for file_idx = 1:file_number
    str = files(file_idx).name; %get the pattern
    if ~isempty(regexp(str, file_to_search, 'match'))
        data_file = str;
    end
end

if strcmp(data_file, 'None')
    coord = [];
    jp_image = jp_image_org;
    return
else
    load(fullfile(path,filename,data_file))
    jp_image = jp_image_org;
end
%Now we have a file that has the coordinates
%is one that has x and y coordinates

num_points =length(y_coord); %get number of points already tagged


for data_idx = 1:num_points
    upper_y = y_coord(data_idx)-60; %is hardcoded to 60 pixels
    lower_y = y_coord(data_idx)+60; %is hardcoded to 60 pixels
    upper_x = x_coord(data_idx)-60; %is hardcoded to 60 pixels
    lower_x = x_coord(data_idx)+60; %is hardcoded to 60 pixels
    jp_image(upper_x:lower_x,upper_y:lower_y) = 0;
end

coord=[y_coord;x_coord];
