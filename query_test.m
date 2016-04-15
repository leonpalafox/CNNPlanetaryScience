function num_files = query_test(image_map, step, pixel_size)
%get only the number of windows
%This function is going to load all the images in a matrix
ar_size = pixel_size;
map_idx = 1;
for window_row_idx = 1:step:(size(image_map,1)-ar_size)
    for window_col_idx = 1:step:(size(image_map,2)-ar_size)
        map_idx = map_idx + 1;
    end
end
num_files = map_idx - 1;
