function plot_contour(original_image, heatmap)
f = figure();
imshow(original_image)
hold on
[~,hContour] = contourf(heatmap, [0.5, 0.5], 'LineColor', 'red');

%first we need to create a mask for the transparency
% Get contour for the top-layer patch and close the figure
%drawnow;
% hFills = hContour.FacePrims;
% [hFills.ColorType] = deal('truecoloralpha');  % default = 'truecolor'
% for idx = 1 : numel(hFills)
%    hFills(idx).ColorData(1) = 255;   % default=255
%    hFills(idx).ColorData(4) = 150;   % default=255
% end
%print('SurfacePlot', '-depsc','-tiff')
plot2svg('myfile.svg', f, 'png'); 