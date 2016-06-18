function plot_image_png(map_image, image_name, config, custom_map_flag)
%This is going to save a tiff file in the main location where all the
%images are
path = config.data{1};
timg = map_image;
if custom_map_flag == 1
    colorma = zeros(256,3);
    colorma(1,:) = [1,0,0];
    colorma(end,:) = [1, 1, 1];
else
    colorma = jet(256);
end
disp(['Saving in ', fullfile(path,[image_name, '.png'])])
imwrite(256*timg, colorma, fullfile(path,[image_name, '.png']))