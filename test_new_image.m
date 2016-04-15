function test_new_image(cnn_cell, config, batch_size)
%Will test an entirely new hirise image with the trained cnn
name = 'test_image';
folder = config.data{1};
filename = config.data{2};
filename = [folder filename];
img = imread(filename, 'ReductionLevel', 2);
%Next we choose the points that will serve as our upper left corner and
%lower right corner in the cropped image (i.e. that part of the image with
%rootless cones)
points = readPoints_v2(img, 2);
%readPoints_v2 comes out with an 2xn matrix with n being the number of points
%specified. Thus, the top left corner is in points(:,1) and the bottom
%right corner is in points(:,2)te
cropped_image = img(points(2,1):points(2,2),points(1,1):points(1,2));

%First we save the files for analysis, these files have no scale image
folder = config.data{1};; %Is going to save it one level up
filename = strcat(name, '.png');
filename = [folder filename];
imwrite(cropped_image,filename)
resize_factor = 1;
map_cell = cell(1,5);
tic
parfor pixel_idx = 1:5
        [classified_map, prob_plot] = run_classification_test(config, cnn_cell{pixel_idx}, config.data{7}(pixel_idx), resize_factor, batch_size);
        map_cell{pixel_idx} = classified_map;
end
output_map = consolidate_maps(map_cell, 1:5);
plot_test_image(config, output_map, resize_factor);
toc