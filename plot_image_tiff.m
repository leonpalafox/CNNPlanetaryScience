function plot_image_tiff(map_image, image_name, config)
%This is going to save a tiff file in the main location where all the
%images are
path = config.data{1};
timg = map_image;
fullfile(path, [image_name, '.tiff'])
t = Tiff(fullfile(path, [image_name, '.tiff']), 'w'); 
tagstruct.ImageLength = size(timg, 1); 
tagstruct.ImageWidth = size(timg, 2); 
tagstruct.Compression = Tiff.Compression.None; 
tagstruct.SampleFormat = Tiff.SampleFormat.IEEEFP; 
tagstruct.Photometric = Tiff.Photometric.MinIsBlack; 
tagstruct.BitsPerSample = 32; % 32; 
tagstruct.SamplesPerPixel = 1; % 1; 
tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky; 
t.setTag(tagstruct); 
t.write(single(timg)); 
t.close();
