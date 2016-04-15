function run_evaluations(config, cnn, pixel_size)
%%
%variables
hi_path = config.data{1};
opts.dataDir = fullfile(hi_path,'hirise_data') ;
opts.pixel_size = pixel_size;
class_to_evaluate = 1;
%This file generates the error metrics
%Test images
disp(['Pixel size evaluation ' num2str(pixel_size)])
mat_to_load = ['test_all_images_', num2str(opts.pixel_size), '.mat'];
labels_to_load = ['test_labels_', num2str(opts.pixel_size), '.mat'];
load(fullfile(opts.dataDir, mat_to_load))
load(fullfile(opts.dataDir, labels_to_load))
mat_to_load = ['train_all_images_', num2str(opts.pixel_size), '.mat'];
labels_to_load = ['train_labels_', num2str(opts.pixel_size), '.mat'];
load(fullfile(opts.dataDir, mat_to_load))
load(fullfile(opts.dataDir, labels_to_load))

data = cat(3, trainData, testData);
data = single(reshape(data,pixel_size,pixel_size,1,size(testData,3)+size(trainData,3)))/255; %add an extra singleton dimension
set = [ones(1,numel(trainLabels)) 3*ones(1,numel(testLabels))];
data = zscore(data, [], 4);
test_data = data(:,:,1,end-size(testData, 3)+1:end);
train_data = data(:,:,1,1:size(trainData, 3));
%%
%Train
batch_array = reshape(test_data, opts.pixel_size, opts.pixel_size,1,size(testData,3));
cnn = vl_simplenn_move(cnn, 'gpu');
batch_array = gpuArray(batch_array(:,:,1,:)) ; %we go to GPU
res = vl_simplenn(cnn, batch_array);
opts.pixel_size = pixel_size;
predictions = gather(res(end-1).x) ;
[~,predictions] = sort(predictions, 3, 'descend') ;
predictions = squeeze(predictions(:,:,1,:));
disp(['Test Data ' num2str(pixel_size)])
[recall, specificity, accuracy] = calculate_metrics(predictions, testLabels, class_to_evaluate)

batch_array = reshape(train_data, opts.pixel_size, opts.pixel_size,1,size(trainData,3));
cnn = vl_simplenn_move(cnn, 'gpu');
batch_array = gpuArray(batch_array(:,:,1,:)) ; %we go to GPU
res = vl_simplenn(cnn, batch_array);
opts.pixel_size = pixel_size;
predictions = gather(res(end-1).x) ;
[~,predictions] = sort(predictions, 3, 'descend') ;
predictions = squeeze(predictions(:,:,1,:));
disp(['Train Data ' num2str(pixel_size)])
[recall, specificity, accuracy] = calculate_metrics(predictions, trainLabels, class_to_evaluate)

disp 'tadaaa'