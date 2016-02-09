
%%
%%This script generates two datasets, one is a dataset with positive
%%samples of the feature to classify, and another are negative samples.
%%this is a two class classifier
%Also, this file uses the matlab functionalities to run in parallel for
%different window sizes in the trining patters.

%First, we need to call a dialog to generate the settings file
%TODO generate GUI
%Here we do all by ourselves
%delete '*.mat'as
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
run('C:\Users\leon\Documents\MATLAB\vlfeat-matconvnet\matlab\vl_setupnn.m') ;
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
