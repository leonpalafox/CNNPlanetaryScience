
%%
%%This script generates two datasets, one is a dataset with positive
%%samples of the feature to classify, and another are negative samples.
%%this is a two class classifier
%Also, this file uses the matlab functionalities to run in parallel for
%different window sizes in the trining patters.

%First, we need to call a dialog to generate the settings file
%TODO generate GUI
%Here we do all by ourselves
%delete '*.mat'
config.labels = {'Data Folder', 'File to use', 'Features to classify', 'Positive Examples', 'Negative Examples', 'Hidden Neurons', 'Minimum image size'};
config.data{1} = 'C:\Users\leon\Documents\Data\HiRISEDATA\';
%config.data{1} = 'D:\matlab_dune_workshop\HiRISE_DATA\';
config.data{2} = 'PSP_002292_1875_RED.QLOOK.JP2';
config.data{3} = 'cones, crater';
config.data{4} = 20;%positive examples (craters, cones, etc)
config.data{5} = 20; %negative examples
config.data{6} = 5; %hidden neurons
config.data{7} = [16, 20, 32, 40, 52, 100]; %different sizes
config.data{8} = [8 8]; %Cell size for the HOG

%%
%Now that we have all the values, store all of them in an structure and
%save them in our config file
choice = questdlg(message, 'This is the terrestrial script, be sure that you erase previous runs', 'Ok', 'Cancel', 'Cancel');
if strcmp(choice, 'Cancel')
    break
end
create_config_file(config, 'config.lpd');% For the moment, the config file
%is only to see in a text file all the variables
message = ['Do you want to create new examples?'];
choice = questdlg(message, 'SkyNet Interface', 'Yes', 'No', 'No');
purge_flag = 0;
while strcmp(choice, 'Yes')

    purge_flag = 1;
    crop_working_image(config)
    feature_list = strtrim(strsplit(config.data{3},',')); %get all of the features list
    for feature_idx = feature_list
        create_dataset(feature_idx{1}, config)
        generate_windows(feature_idx{1}, config)
    end
    create_dataset('negative', config)
    generate_windows('negative', config)
    message = ['Do you want to keep creating examples?'];
    choice = questdlg(message, 'SkyNet Interface', 'Yes', 'No', 'No');
    

end
if purge_flag == 1
    purge_database_files(config); %Looks for the files and purges them
end
%%

resize_factor = 1;
batch_size = 50;
im_to_classify = get_image_to_classify(config, resize_factor);
[cnn_cell, map_cell, trained_flag] = get_cnn(config);%check if there is a file
tic
parfor pixel_idx = 1:6
        generate_image_database_terrestrial(config, config.data{7}(pixel_idx), 1);
        if trained_flag == 0; %if the cnn is not trained
                [net, info] = cnn_hirise_Data(config.data{7}(pixel_idx), batch_size);
                net.layers{end} = struct('type', 'softmax') ;
                cnn_cell{pixel_idx} = net;
        end
        [classified_map, prob_plot] = run_classification_cuda(config, cnn_cell{pixel_idx}, config.data{7}(pixel_idx), resize_factor, batch_size, im_to_classify);
        map_cell{pixel_idx} = classified_map;
        disp_msg =  ['Im done with pixel size ', num2str(config.data{7}(pixel_idx))];
        disp(disp_msg);
end
if trained_flag == 0 
    save(fullfile(config.data{1},'cnn_session.mat'), 'cnn_cell', 'config', 'map_cell') %here we save the tranied network
end
toc
break
close all
%show_figures_merit(config, cnn_cell, resize_factor);
smooth_flag = 1;
output_map = consolidate_maps(map_cell, 1:1, smooth_flag);
geo_map = greate_geologic_map(output_map);%This is a color map, where each color defines a feature.
plot_image_tiff(output_map(:,:,1), 'test_file')

%plot_learning_rates(learning_plot_cell, config);
%plot_image(config, output_map, resize_factor);
%save('cnn_session.mat', 'cnn_cell', 'learning_plot_cell', 'config', 'map_cell', 'resize_factor')
%test_new_image(cnn_cell, config)