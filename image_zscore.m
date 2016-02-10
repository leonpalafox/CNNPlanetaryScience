function [run_mean, run_sigma] = image_zscore(image_filename, pixel_size, step_size, id_flag)
%%
%This file takes the input image and pixel size, and calculates its mean
%and standard deviation using running mean and variance methods.
%This allows gfor the processing of large hirise images
%The method creates a file in the respective figure folder that holds the
%mean and standard deviation
%image_filename: Name of the file to process, must be the png file, with
%complete path
%pixel_size: window pixel size, if is an array, it will calculate means for
%all of those pixel sizes
%step_size : size of step used to calculate the running mean, given en
%percentage, if it's a list, it generates a list of files for different
%step sizes
%id_flag: 1 is for claculating the mean, and 0 is for retreiving them
%Output,
%run__mean: is the running mean for the given parameters, in this case both
%pixel_size and step_size must be single values
%%
%get path parameters
[image_path, filename, extension] = fileparts(image_filename);
if id_flag == 1 %means we are going to calculate the values
    working_file = image_filename; %working image
    image_map = imread(working_file); %load the image in memory
    image_map = single(image_map)/255; %transform for latter processing
    %%
    for step_idx = step_size
        for pixel_idx = pixel_size
            ar_size = pixel_idx;
            window_overlap = step_idx; %Overlap is 10%
            step = round(ar_size*(1-window_overlap))+1;
            map_idx = 0;
            for window_row_idx = 1:step:(size(image_map,1)-ar_size)
                for window_col_idx = 1:step:(size(image_map,2)-ar_size)
                    current_image = double(image_map(window_row_idx:window_row_idx+ar_size-1, window_col_idx:window_col_idx+ar_size-1));%point to classify
                    map_idx = map_idx + 1;
                    if map_idx == 1
                        test_mean = current_image;
                        test_std = zeros(pixel_idx, pixel_idx);
                    else
                        test_mean = past_mean+(current_image-past_mean)/double(map_idx);
                        test_std = past_std+(current_image - past_mean).*(current_image - test_mean);
                    end
                    past_mean = test_mean;
                    past_std = test_std;
                end
            end
            test_sigma = sqrt(test_std/(map_idx-1));
            savefile = fullfile(image_path,filename,[filename,'_step_',num2str(step_idx),'_window_',num2str(pixel_idx),'.mat']);
            save(savefile, 'test_mean', 'test_sigma');
        end
    end
    %%
else
    if length(pixel_size)>1 || length(step_size)>1
        error('Don''t be greedy, we still don''t offer that functionality for retreiving data, steps and pixels must be a single value')
    end
    readfile = fullfile(image_path,filename,[filename,'_step_',num2str(step_size),'_window_',num2str(pixel_size),'.mat']);
    load(readfile)
    run_mean = test_mean;
    run_sigma = test_sigma;
    
end