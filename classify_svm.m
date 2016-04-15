images = zscore(images);
unique_labels = unique(labels);
num_labels = ismember(labels, unique_labels{1})+1;
c = cvpartition(labels,'k',2); %create two a training and a testing dataset
%testData = images(c.test(1),:)';
%trainData = images(c.training(1),:)';
%testLabels = num_labels(c.test(1));
%trainLabels = num_labels(c.training(1));
trainLabels = num_labels;
testLabels = num_labels;
testData = images';
trainData = images';

SVMModel = fitcsvm(testData',testLabels,'KernelFunction','RBF', 'KernelScale','auto');
[pred,score] = predict(SVMModel,patches);
pred = pred';
generate_image(config, upper_x, upper_y, pred')