%filter creation
size = 40;
filter = rand(size);
b = conv2(double(im), filter, 'valid');
imwrite(mat2gray(b), 'random_filter_im.png')
imwrite(mat2gray(filter), 'random_filter.png')

filter = eye(size);
b = conv2(double(im), filter, 'valid');
imwrite(mat2gray(b), 'eye_filter_im.png')
imwrite(mat2gray(filter), 'eye_filter.png')

filter = flip(eye(size));
b = conv2(double(im), filter, 'valid');
imwrite(mat2gray(b), 'flip_eye_filter_im.png')
imwrite(mat2gray(filter), 'flip_eye_filter.png')
