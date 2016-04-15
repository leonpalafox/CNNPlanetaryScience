function generate_training_images(num_images, pixel_size, feature, nrows, ncols)
path = 'C:\Users\leon\Documents\Data\HiRISEDATA\hirise_data';
%path = 'D:\matlab_dune_workshop\Leon_TAR_Training';
filename_labels = ['labels_', num2str(pixel_size), '.mat'];
filename_data = ['all_images_', num2str(pixel_size), '.mat'];
if ~(nrows*ncols == num_images)
    error('myApp:argChk', 'The rows and columns are not consistent') 
end

if ~exist(fullfile(path, filename_data))
    error('myApp:argChk', 'The pixel size is invalid') 
end
load(fullfile(path, filename_labels))
load(fullfile(path, filename_data))
if ~ismember(feature, unique(label_file_out))
    error('myApp:argChk', 'The feature is invalid')
end
index = find(strcmp(label_file_out, feature)); %get the indexes for the feature of interest
index = datasample(index, num_images, 'Replace', false);
%ha = tight_subplot(nrows, ncols, [.001 .001],[.001 .001],[.001 .001]);
ha = tight_subplot(nrows, ncols);
for idx=1:size(index,2)
    axes(ha(idx))
    imshow(image_array(:,:, index(idx)))
    %imwrite(image_array(:,:, idx), ['image_', num2str(idx), '.png']);
end