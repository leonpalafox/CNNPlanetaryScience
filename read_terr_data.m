function data = read_terr_data(pixel_size)
%foldername = 'D:\matlab_dune_workshop\Leon_TAR_Training';
foldername = 'C:\Users\leon\Documents\Data\Leon_TAR_Training';
filenames = dir([foldername, '\*.jpg']); % get only the jpg
img_array = zeros(pixel_size, pixel_size, size(filenames,1));
for file_idx=1:size(filenames,1)
    temp_image = imresize(rgb2gray(imread([foldername '\' filenames(file_idx).name])),[pixel_size, pixel_size]);
    img_array(:,:,file_idx) = double(temp_image)/255;
end
%image_flat = reshape(permute(img_array,[3 2 1]),size(filenames,1),pixel_size*pixel_size);
data =  img_array;

