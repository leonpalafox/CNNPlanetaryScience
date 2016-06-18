function [image_matrix_class, prob_plot] = run_classification_svm_running(config, svm_model, ar_size, scale_factor, batch_size, hirise_img, img_path)
%%This function creates the pooled image
%%ar_size: The iwndow size so the classification works
%%mu and sigma train come from calculating the zscore in the classifier
%%Create the matrix
%%This uses the cuda files and matlab ackage conv net

image_matrix_class = create_matrix(hirise_img, 2);


%%
prob_plot(1) = 0;
window_overlap = 0.9; %Overlap is 10%
[run_mean, run_sigma] = image_zscore(img_path,ar_size, window_overlap, 0);
step = round(ar_size*(1-window_overlap))+1;
batch_count = 1;
batch_array = single(zeros(ar_size, ar_size, batch_size));%This array holds the classification sample
%testing_data = generate_test(hirise_img, step, ar_size);
num_testing_windows = query_test(hirise_img, step, ar_size);
prediction_array = zeros(num_testing_windows, 1); %get a label per testing window
img_idx = 1;
pred_count = 0; %counter to control the prediction array to then reshape
for window_row_idx = 1:step:(size(image_matrix_class(:,:,1),1)-ar_size)
    for window_col_idx = 1:step:(size(image_matrix_class(:,:,1),2)-ar_size)
          %data_temp = testing_data(:,:,img_idx);
          data_temp = double(hirise_img(window_row_idx:window_row_idx+ar_size-1, window_col_idx:window_col_idx+ar_size-1));
          data_temp = (data_temp - run_mean)./run_sigma; %normalization of the patch
          batch_array(:,:,batch_count) = single(data_temp);
          batch_count = batch_count + 1; %has to be here, otherwise it jumps over the last iterations
          if batch_count-1 == batch_size
              %We do the classification
              %batch_array = gpuArray(batch_array) ; %we go to GPU
              flatBatch = permute(batch_array,[3 1 2]);
              flatBatch = reshape(flatBatch, size(batch_array,3), size(batch_array,1)*size(batch_array,1));
              [predictions,score_acc]=predict(svm_model,flatBatch);
              batch_count = 1;
              prediction_array((img_idx-50)+1:img_idx,1) = predictions;
              pred_count = pred_count + 1;
          end
  
          %image_matrix_class(window_row_idx:window_row_idx+ar_size, window_col_idx:window_col_idx+ar_size,pred_class) = image_matrix_class (window_row_idx:window_row_idx+ar_size, window_col_idx:window_col_idx+ar_size,pred_class)+unique(net.o(pred_class,:));
          img_idx = img_idx + 1;
    end
end
if batch_count~=1
    flatBatch = permute(batch_array,[3 1 2]);
    flatBatch = reshape(flatBatch, size(batch_array,3), size(batch_array,1)*size(batch_array,1));
    [predictions,score_acc]=predict(svm_model,flatBatch);
    prediction_array(end-batch_count+2:end,1) = predictions(1:batch_count-1); %to adjust for the last guys who were not part of a full batch
end
image_matrix_class = create_matrix_map(prediction_array, image_matrix_class, step, ar_size);

image_matrix_class = imresize(image_matrix_class, 1.0/scale_factor);
end