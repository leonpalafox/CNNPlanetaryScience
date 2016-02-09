function create_config_file(config_struct, config_filename)
%%This function creates a text file that contains all of the pertinet
%%variables with the current implementation, like tthe image to analyze, as
%%well as the aprameters of the network. This is a free file, in the sense
%%that there is not a defined set of variables, they are all in the config
%%file labels, so is pretty generic
%%
%% Variables
%Input:
%config_struct: structure that needs to attributes, labels and data
%labels contain the labels for each of the data entries in config.data
%config_filename: filename to store the config file

%open file
[trash, elements] = size(config_struct.labels);
fileID = fopen(config_filename, 'w');
formatSpec = '%s : %s \n';
for element_idx = 1:elements
    label = config_struct.labels{element_idx};
    datum = config_struct.data{element_idx};
    fprintf(fileID,formatSpec,label, num2str(datum));
end
fclose(fileID)
