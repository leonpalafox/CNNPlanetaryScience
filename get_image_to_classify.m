function [hirise_img, im_path] = get_image_to_classify(config, scale_factor);
waitfor(msgbox('Please select the image you want to use to run the classifier')); %waits for user click 
[hirise_img, path] = uigetfile(fullfile(config.data{1}, '*')); %here we select the image that we wish to use for the tagging
im_path = fullfile(path, hirise_img);
hirise_img = imread(fullfile(path, hirise_img));
hirise_img = imresize(hirise_img, scale_factor);
hirise_img = single(hirise_img)/255;
end