function purge_database_file(config)
%This files purges all the database files created by the cnn function
%This is needed, since the CNN function only cretes the database once
%If it is not purged, it won't update the training examples with the new
%ones.
path  = config.data{1};
remove_dirs = dir(fullfile(path,'*-baseline-*')); %look for all baseline dirs

for dir_name = {remove_dirs.name}
   rmdir(fullfile(path,dir_name{1}),'s') 
end
%Now look for all the hirise baselines

end