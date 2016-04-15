function out_map = consolidate_maps(map_cell, range, smooth_flag)
%map_cell is a cell thatc ontains all the maps that we need, we will only
%be using the one for the first index right now
%first we need to normalize each of th maps so they are ina comparabel
%dimension
h = fspecial('gaussian', 10, 10); %Smoother
cell_numb = size(map_cell, 2);%get the number of cells
cell_numb = range(end);
cell_start  = range(1);
final_map = zeros(size(map_cell{cell_start}));
for map_idx = cell_start:cell_numb
    for class_idx = 1:size(map_cell{cell_start}, 3)
        max_value = max(max(map_cell{map_idx}(:,:,class_idx))); %get the max probability
        map_cell{map_idx}(:,:,class_idx) = map_cell{map_idx}(:,:,class_idx)/max_value; %normalize to the max
        final_map(:,:, class_idx) = final_map(:,:, class_idx) + map_cell{map_idx}(:,:,class_idx);
        max_value = max(max(final_map(:,:,class_idx))); %get the max probability
        final_map(:,:,class_idx) = final_map(:,:,class_idx)/max_value;
        if smooth_flag
            final_map(:,:, class_idx) = imfilter(final_map(:,:, class_idx), h);
        end
    end
end


out_map = final_map;
  
