
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
message_imagery = ['Please choose beetwen HiRISE and CTX images?'];
choice_imagery = questdlg(message_imagery, 'SkyNet Interface', 'HiRISE', 'CTX', 'CTX');
if strcmp(choice_imagery, 'HiRISE')
    main_path = 'C:\Users\leon\Documents\Data\HiRISEDATA\';
else
    main_path = 'C:\Users\leon\Documents\Data\CTXDATA\';
end
config.labels = {'Data Folder', 'File to use', 'Features to classify', 'Positive Examples', 'Negative Examples', 'Hidden Neurons', 'Minimum image size'};
config.data{1} = main_path;
%config.data{1} = 'D:\matlab_dune_workshop\HiRISE_DATA\';
config.data{2} = 'PSP_002292_1875_RED.QLOOK.JP2';
config.data{3} = 'cones, crater';
config.data{4} = 80;%positive examples (craters, cones, etc)
config.data{5} = 80; %negative examples
config.data{6} = 5; %hidden neurons
config.data{7} = [16, 20, 32, 40, 52, 100]; %different sizes
config.data{8} = [8 8]; %Cell size for the HOG
config.data{9} = [0.2:0.1:0.9]; %step_sizes for the analysis
config.data{10} = choice_imagery; %To have access to the decission
%run('C:\Users\leon\Documents\MATLAB\vlfeat-matconvnet\matlab\vl_setupnn.m') ;
%%
%Now that we have all the values, store all of them in an structure and
%save them in our config file
%
create_config_file(config, 'config.lpd');% For the moment, the config file
%is only to see in a text file all the variables
message = ['Do you want to create new examples?'];
choice = questdlg(message, 'SkyNet Interface', 'Yes', 'No', 'No');
purge_flag = 1;

while strcmp(choice, 'Yes')
    crop_working_image(config)
    purge_flag = 1;
    
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
[im_to_classify, im_path] = get_image_to_classify(config, resize_factor);
%TODO A Function that reads a trained SVM
[svm_cell, map_cell, trained_flag] = get_svm(config);%check if there is a file
tic
break
for pixel_idx = 1:6
        generate_image_database(config, config.data{7}(pixel_idx), 1);%BUG
        if trained_flag == 0; %if the cnn is not trained
                svm_model = svm_hirise_Data(config, config.data{7}(pixel_idx));
                svm_cell{pixel_idx} = svm_model;
        end
        [classified_map, prob_plot] = run_classification_svm_running(config, svm_cell{pixel_idx}, config.data{7}(pixel_idx), resize_factor, batch_size, im_to_classify, im_path);
        map_cell{pixel_idx} = classified_map;
        disp_msg =  ['Im done with pixel size ', num2str(config.data{7}(pixel_idx))];
        disp(disp_msg);
end
if trained_flag == 0 
    save(fullfile(config.data{1},'svm_session.mat'), 'svm_cell', 'config', 'map_cell') %here we save the tranied network
end
toc
close all
%show_figures_merit(config, cnn_cell, resize_factor);
%%
smooth_flag = 1;
[im_path_full, im_name_full, exte] = fileparts(im_path);
output_map = consolidate_maps(map_cell, 1, smooth_flag);
geo_map = greate_geologic_map(output_map);%This is a color map, where each color defines a feature.
%plot_image_tiff(output_map(:,:,1), ['class_', im_name_full], config)
plot_image_png(output_map(:,:,1), ['coneclass_', im_name_full], config, 0)
plot_image_png(output_map(:,:,1)<0.5, ['conemap_', im_name_full], config, 1)
plot_image_png(output_map(:,:,3), ['craterclass_', im_name_full], config, 0)
plot_image_png(geo_map, ['geo_map_', im_name_full], config, 0)
clearvars -global drawing_map
create_interactive_map(output_map, im_to_classify)
%plot_learning_rates(learning_plot_cell, config);
%plot_image(config, output_map, resize_factor);
%save('cnn_session.mat', 'cnn_cell', 'learning_plot_cell', 'config', 'map_cell', 'resize_factor')
%test_new_image(cnn_cell, config)
%%
%%Evaluations
for pixel_idx = 1:6
    run_evaluations(config, svm_cell{pixel_idx}, config.data{7}(pixel_idx));
end