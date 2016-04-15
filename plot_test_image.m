function [y, f,lab] = plot_test_image(config, map, scale_factor)
strfilename = 'test_image';
folder = config.data{1};
filename = strcat(strfilename, '.png');
filename = [folder filename];
hirise_img = imread(filename);
hirise_img = imresize(hirise_img, scale_factor);
hirise_img = double(hirise_img)/255;
f =figure;
%first_img = imshow(hirise_img);
hold on
patches_img = imshow(map);
set(patches_img, 'AlphaData', 1)
y = colorbar('peer', gca);
lab = ylabel(y, 'Probability of VCR', 'rot', -90);
set(f, 'Position' , [524, 24,1195,1440]);
set(y, 'Position', [0.8825,0.0891,0.0283,0.8194]);
set(lab, 'Position', [4.9545, 0.4987, 1.0001]);
colormap jet
set(gca,'FontSize',15,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',15,'fontWeight','bold')
saveas(gcf, 'test_image.png')


%set(patches_img, 'AlphaData', 0.5)