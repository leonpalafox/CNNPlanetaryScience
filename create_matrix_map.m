function out_matrix = create_matrix_map(classif_array, in_matrix, step, ar_size)
img_ind = 1;
for window_row_idx = 1:step:(size(in_matrix(:,:,1),1)-ar_size)
    for window_col_idx = 1:step:(size(in_matrix(:,:,1),2)-ar_size)
        pred_class = classif_array(img_ind);
        in_matrix(window_row_idx:window_row_idx+ar_size, window_col_idx:window_col_idx+ar_size, pred_class) = in_matrix (window_row_idx:window_row_idx+ar_size, window_col_idx:window_col_idx+ar_size,pred_class) + 1;
        img_ind = img_ind + 1;
    end
end
out_matrix = in_matrix;