%this script extract the numbers
clear
imfile = 'C:\Users\leon\Dropbox\Code\Octave\MoonUtilitites\V_07_0010_c.jpg';
imfile = 'C:\Users\leon\Dropbox\Code\Octave\MoonUtilitites\I_04_0027_c.jpg';
imfile = 'C:\Users\leon\Dropbox\Code\Octave\MoonUtilitites\I_04_0013_c.jpg';
I = imread(imfile);
I = rgb2gray(I);
[n_rows, n_cols] = size(I);
J = wiener2(I,[10 10]);

contrastAdjusted = imadjust(gather(J));
%now we crop the part with the text
x_ts = 251;
y_tx = 304;
height_box = 1000;
width_box = 64;
new_im = imcrop(contrastAdjusted, [x_ts, y_tx, height_box, width_box]);
%%
H = fspecial('disk',5);
blurred = imfilter(new_im,H,'replicate');
level = graythresh(blurred);
BW = im2bw(blurred,level);
imshow(BW);
results = ocr(BW, 'TextLayout', 'Line', 'CharacterSet', '.0123456789');
result_string = sscanf(results.Text, '%s');
