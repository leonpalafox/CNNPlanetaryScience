function data_map = generate_test(image_map, step, pixel_size)
%%
%This function is going to load all the images in a matrix
ar_size = pixel_size;
size_rows = size(1:step:size(image_map,1)-pixel_size, 2);
size_cols = size(1:step:size(image_map,2)-pixel_size, 2);
size_of_map = size_rows * size_cols;
data_map = zeros(pixel_size, pixel_size, size_of_map);
map_idx = 1;
for window_row_idx = 1:step:(size(image_map,1)-ar_size)
    for window_col_idx = 1:step:(size(image_map,2)-ar_size)
        data_map(:,:,map_idx) = image_map(window_row_idx:window_row_idx+ar_size-1, window_col_idx:window_col_idx+ar_size-1);%point to classify
        map_idx = map_idx + 1;
    end
end
data_map = zscore(data_map, [] ,3);
