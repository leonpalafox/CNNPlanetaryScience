function [net, info] = cnn_hirise_Data(config, pixel_size, batch_size, varargin)
% CNN_MNIST  Demonstrated MatConNet on MNIST

%run(fullfile(fileparts(mfilename('fullpath')),...
%  '..', 'matlab', 'vl_setupnn.m')) ;
hi_path = config.data{1};
opts.dataDir = fullfile(hi_path,'hirise_data') ;
opts.expDir = fullfile(hi_path,['hirise-baseline-', num2str(pixel_size)]) ;
opts.imdbPath = fullfile(opts.expDir, 'imdb.mat');
opts.pixel_size = pixel_size;
opts.train.batchSize = batch_size ;
opts.train.numEpochs = 100 ;
opts.train.continue = false ;
opts.train.useGpu = true ;
opts.train.learningRate = 0.01 ;
opts.weightDecay = 0.001 ;
opts.momentum = 0.2 ;
opts.train.expDir = opts.expDir ;
opts.errorType = 'multiclass' ;
opts = vl_argparse(opts, varargin) ;
num_classes = 3;
% --------------------------------------------------------------------
%                                                         Prepare data
% --------------------------------------------------------------------

if exist(opts.imdbPath, 'file')
  imdb = load(opts.imdbPath) ;
else
  %imdb = getMnistImdb(opts) ;
  imdb = getHiRISEImdb(opts);
  mkdir(opts.expDir) ;
  save(opts.imdbPath, '-struct', 'imdb') ;
end

% Define a network similar to LeNet
net = getNetwork(pixel_size, num_classes);
net.classes = imdb.meta.classes;
% --------------------------------------------------------------------
%                                                                Train
% --------------------------------------------------------------------

% Take the mean out and make GPU if needed
%if opts.train.useGpu
%  imdb.images.data = gpuArray(imdb.images.data) ;
%end

[net, info] = cnn_train(net, imdb, @getBatch, ...
    opts.train, ...
    'val', find(imdb.images.set == 3)) ;

% --------------------------------------------------------------------
function [im, labels] = getBatch(imdb, batch)
% --------------------------------------------------------------------
im = imdb.images.data(:,:,:,batch) ;
labels = imdb.images.labels(1,batch) ;

% --------------------------------------------------------------------
function imdb = getHiRISEImdb(opts)
% --------------------------------------------------------------------
% Preapre the imdb structure, returns image data with mean image subtracted
if ~exist(opts.dataDir, 'dir')
  mkdir(opts.dataDir) ;
  disp 'You need to put some data in the dataDir'
end

mat_to_load = ['all_images_', num2str(opts.pixel_size), '.mat'];
labels_to_load = ['labels_', num2str(opts.pixel_size), '.mat'];
load(fullfile(opts.dataDir, mat_to_load))
load(fullfile(opts.dataDir, labels_to_load))
[n,m,samples] = size(image_array);
[labels, label_text] = grp2idx(label_file_out);

subset_pct = 90;%percentage of training data
subset = floor(size(image_array, 3)*subset_pct/100);
disp(['Subset size is ', num2str(subset)])
[trainLabels, idx] = datasample(labels, subset, 'Replace', false);
trainData = image_array(:,:,idx);
testData = image_array;
testData(:,:,idx) = [];
testLabels = labels;
testLabels(idx) = [];
%%
%Save the test and training data
mat_to_save_test = ['test_all_images_', num2str(opts.pixel_size), '.mat'];
labels_to_save_test = ['test_labels_', num2str(opts.pixel_size), '.mat'];
save(fullfile(opts.dataDir, mat_to_save_test), 'testData')
save(fullfile(opts.dataDir, labels_to_save_test), 'testLabels')
mat_to_save_train = ['train_all_images_', num2str(opts.pixel_size), '.mat'];
labels_to_save_train = ['train_labels_', num2str(opts.pixel_size), '.mat'];
save(fullfile(opts.dataDir, mat_to_save_train), 'trainData')
save(fullfile(opts.dataDir, labels_to_save_train), 'trainLabels')

%%
data = cat(3, trainData, testData);
data = single(reshape(data,n,m,1,samples))/255; %add an extra singleton dimension
set = [ones(1,numel(trainLabels)) 3*ones(1,numel(testLabels))];
dataMean = mean(data(:,:,:,set == 1), 4);
data = zscore(data, [], 4);
%data = zscore(data);
%data = bsxfun(@minus, data, dataMean) ;

imdb.images.data = data ;
imdb.images.data_mean = dataMean;
imdb.images.labels = cat(2, trainLabels', testLabels');%Labels need to start form 1
imdb.images.set = set ;
imdb.meta.sets = {'train', 'val', 'test'} ;
%imdb.meta.classes = arrayfun(@(x)sprintf('%d',x),0:1,'uniformoutput',false) ;
imdb.meta.classes = label_text';

