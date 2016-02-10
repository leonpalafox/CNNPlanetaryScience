function coord_array = generate_datapoints(y_coord_list, x_coord_list, num_array, size_val)%creates de datapoints
%%
%This creates a NUM_ARRAY set of images from a single click, to generate
%training data
%first, the click is the lower left corner
point_number = size(y_coord_list,2);
coord_array = zeros(2,2,num_array*point_number);
%Upper Right
for point_idx = 1:point_number
    y_coord = y_coord_list(point_idx);
    x_coord = x_coord_list(point_idx);
    idx = (point_idx-1)*(num_array)+1;
    %Upper Right
    coord_array(1,:,idx) = [y_coord - size_val+1, y_coord];
    coord_array(2,:,idx) = [x_coord, x_coord+size_val-1];
    %Upper Left
    coord_array(1, :, idx+1) = [y_coord - size_val+1, y_coord];
    coord_array(2, :, idx+1) = [x_coord-size_val+1, x_coord];
    %Lower Right
    coord_array(1, :, idx+2) = [y_coord, y_coord+size_val-1];
    coord_array(2,:, idx+2) = [x_coord, x_coord+size_val-1];
    %Lower Left
    coord_array(1,:, idx+3) = [y_coord, y_coord+size_val-1];
    coord_array(2,:, idx+3) = [x_coord-size_val+1, x_coord];
end
end

