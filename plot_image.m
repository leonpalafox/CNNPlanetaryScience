function [y, f,lab] = plot_image(config, map, scale_factor)
filename = config.data{2};
strfilename = strsplit(filename, '.');
strfilename = strfilename{1};
folder = 'Data\';
filename = strcat(strfilename, '.png');
filename = [folder filename];
hirise_img = imread(filename);
hirise_img = imresize(hirise_img, scale_factor);
hirise_img = double(hirise_img)/255;
f =figure;
%first_img = imshow(hirise_img);
hold on
patches_img = imshow(map);
%set(patches_img, 'AlphaData', 1)
imwrite(map*255, jet, 'map.png')
set(gca,'position',[0 0 1 1],'units','normalized')
%y = colorbar('peer', gca);
%lab = ylabel(y, 'Probability of VCR', 'rot', -90);
%set(f, 'Position' , [524, 24,1195,1440]);
%set(gca, 'Position', [0 0 1 1])
%set(y, 'Position', [0.8825,0.0891,0.0283,0.8194]);
%set(lab, 'Position', [4.9545, 0.4987, 1.0001]);
colormap jet

%set(gca,'FontSize',15,'fontWeight','bold')
%set(findall(gcf,'type','text'),'FontSize',15,'fontWeight','bold')

%set(patches_img, 'AlphaData', 0.5)
tunning = 0.9;
f =  figure; %Now we plot the actual values
map = map/5; %convert to real probabilities (this is hard coded)
map_t = zeros(size(map));
map_t(map>=tunning) = 0;
map_t(map<tunning) = 1;
imshow(map_t);
imwrite(map_t*255, 'classmap.png')
f = figure;
h = fspecial('gaussian', 10, 10);
filteredRGB = imfilter(map, h);
imshow(hirise_img)
hold on
filteredRGB = filteredRGB/max(max(filteredRGB));


[C, h] = contourf(filteredRGB, [0.1 0.9]);

%colormap parula
%clabel(C,h,'LabelSpacing',300)
%set(h,'ShowText','on','TextStep',get(h,'LevelStep')*2)

%begin code to change specific line colors

%get a handle to all the children of the contourgroup object

a=get(h,'Children');

for k=1:length(a)

      %only consider the children that are patch objects

      %STRCMP compares two strings and return true if they are the same
      thiscol = get(a(k), 'FaceColor');
      flag_k = 0;
      if all(thiscol == 1) 
           set(a(k), 'FaceColor', 'k');
           set(a(k),'EdgeColor','None');
           
           flag_k = 1;
      end
      if strcmp(get(a(k),'Type'),'patch')

          %'UserData' indicates the elevation associated with a patch

          switch get(a(k),'UserData')

              case 0.1

                  set(a(k),'EdgeColor',[0,0,128]/255);
                  set(a(k),'facecolor',[0,0,128]/255);

                  %set the 'EdgeColor' for the line at elevation 0.4 to blue

              case 0.4

                  set(a(k),'EdgeColor',[0,15,255]/255);
                  set(a(k),'facecolor',[0,15,255]/255);
              case 0.5
                    if flag_k ~= 1
                        set(a(k),'EdgeColor','r');
                        set(a(k),'facecolor','r');
                    end
              case 0.6

                  set(a(k),'EdgeColor',[153,153,255]/255);
                  set(a(k),'facecolor',[153,153,255]/255);

                  %set the 'EdgeColor' for the line at elevation -0.4 to red

          end

      end

end
a=get(h,'Children');
alpha(a,0.2)
%loop through all the children of the contourgroup object
for ii = 1:length(a)
    cont_level(ii) = get(a(ii),'userdata'); % level of i-th cont.
    thiscol = get(a(ii), 'FaceColor')
end

cl2=sort(unique(cont_level),'descend'); % find unique cont levels
cl2=cl2(1:end); % exclude last value which tends to not exist in plot
hc2=zeros(size(cl2)); legend_entries=cell(size(cl2));
for ii=1:length(cl2) % find unique handle list & make corresponding legend
    hc2(ii)=a(find(cont_level==cl2(ii),1));
    legend_entries{ii} = num2str(cl2(ii));
end
%lgnd = legend(a,legend_entries,'Location', 'SouthEast');
%set(lgnd,'color','none');
%legend boxoff
set(gca,'FontSize',30,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',30,'fontWeight','bold')
plot2svg('Map.svg')
%set(allH,'FaceAlpha',0.25);
