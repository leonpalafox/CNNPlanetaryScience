function geo_map = greate_geologic_map(output_map)
%%
%This function creates a colored geological map of the diferent classes in
%the image
[rows, cols, num_classes] = size(output_map);%we get the number of classes
geo_colors = flag(num_classes);%we get colors for each layer
[~,indexes]=max(output_map,[],3);%This determines the class for each pixel
%We need to create a whole new image t store the regb
geo_map_r = zeros(rows, cols); %This stores the RGB
geo_map_g = zeros(rows, cols); %This stores the RGB
geo_map_b = zeros(rows, cols); %This stores the RGB
for class_idx = unique(indexes)'
    geo_map_r(indexes==class_idx)=geo_colors(class_idx,1);
    geo_map_g(indexes==class_idx)=geo_colors(class_idx,2);
    geo_map_b(indexes==class_idx)=geo_colors(class_idx,3);
end
geo_map = cat(3, geo_map_r, geo_map_g, geo_map_b);