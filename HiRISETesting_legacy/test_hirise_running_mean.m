%This series of scripts are tests to see if we can extract means and
%variances from hirise images
config.labels = {'Data Folder', 'File to use', 'Features to classify', 'Positive Examples', 'Negative Examples', 'Hidden Neurons', 'Minimum image size'};
config.data{1} = 'C:\Users\leon\Documents\Data\DummyData\';
%config.data{1} = 'D:\matlab_dune_workshop\HiRISE_DATA\';
config.data{2} = 'PSP_002292_1875_RED.QLOOK.JP2';
config.data{3} = 'cones, crater';
config.data{4} = 20;%positive examples (craters, cones, etc)
config.data{5} = 20; %negative examples
config.data{6} = 5; %hidden neurons
config.data{7} = [16, 20, 32, 40, 52, 100]; %different sizes
config.data{8} = [8 8]; %Cell size for the HOG
%clear
close all
%crop_working_image(config)

working_file = 'C:\Users\leon\Documents\Data\DummyData\P03_002147_1865_XI_06N208W_crop_5.png'; %working image (700 MB)
image_map = imread(working_file);
image_map = single(image_map)/255;
%%
pixel_size = config.data{7}(3);
for pixel_size = config.data{7}
ar_size = pixel_size;
window_overlap = 0.9; %Overlap is 10%
step = round(ar_size*(1-window_overlap))+1;
size_rows = size(1:step:size(image_map,1)-pixel_size, 2);
size_cols = size(1:step:size(image_map,2)-pixel_size, 2);
size_of_map = size_rows * size_cols;


%%
map_idx = 0;
cum_sum_images = zeros(pixel_size, pixel_size);
sq_cum_sum_images = zeros(pixel_size, pixel_size);
%image_array = zeros(pixel_size, pixel_size, size_of_map);

%%

for window_row_idx = 1:step:(size(image_map,1)-ar_size)
    for window_col_idx = 1:step:(size(image_map,2)-ar_size)
        current_image = double(image_map(window_row_idx:window_row_idx+ar_size-1, window_col_idx:window_col_idx+ar_size-1));%point to classify
        %image_array(:,:,map_idx+1) = current_image;
        map_idx = map_idx + 1;
        if map_idx == 1
            test_mean = current_image;
            test_std = zeros(pixel_size, pixel_size);
        else
            test_mean = past_mean+(current_image-past_mean)/double(map_idx);
            test_std = past_std+(current_image - past_mean).*(current_image - test_mean);
        end
        past_mean = test_mean;
        past_std = test_std;
    end
end
map_idx
end
%%
[z, mu, sigma] = zscore(image_array, [], 3);
test_sigma = sqrt(test_std/(map_idx-1));