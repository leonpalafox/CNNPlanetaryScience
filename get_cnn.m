function [cnn_cell, map_cell, trained_flag] = get_cnn(config)
%This function checks in the main path if there is a trained cnn.
%Asks if you want to train a new one or use the existing one
path = config.data{1};
cnn_filename = 'cnn_session.mat';
%first we check if there is a cnn_session.mat file in the main path
if exist(fullfile(path, cnn_filename), 'file')
    message = ['There is already a trained CNN file in your main file, do you want to create a new one?'];
    choice = questdlg(message, 'SkyNet Interface', 'Yes', 'No', 'No');
    if strcmp(choice, 'Yes')
        cnn_cell = cell(1,numel(config.data{7}));%create a cell for each pixel window
        map_cell = cell(1,numel(config.data{7}));
        trained_flag = 0; %The cnn's are not trained
    else
        load(fullfile(path, cnn_filename))
        trained_flag = 1;
    end
else %There is no file, so create a new one
    cnn_cell = cell(1,numel(config.data{7}));%create a cell for each pixel window
    map_cell = cell(1,numel(config.data{7}));
    trained_flag = 0; %The cnn's are not trained
end
    
    

