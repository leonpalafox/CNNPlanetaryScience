%Example and figure for histogram of oriented gradients
crater_image = I3;
%crater_image = rgb2gray(cdata);
[hog1, visualization] = extractHOGFeatures(crater_image,'CellSize',[8 8]);
corners   = detectFASTFeatures(crater_image);
strongest = selectStrongest(corners,10);
[hog2, validPoints, ptVis] = extractHOGFeatures(crater_image,strongest);
imshow(crater_image,[]);
hold on
%plot(ptVis,'Color','green');
f = plot(visualization,'Color','black');
set(gca,'xtick',[])
set(gca,'xticklabel',[])
set(gca,'ytick',[])
set(gca,'yticklabel',[])
set(gca, 'visible', 'off') ;