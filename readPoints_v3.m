function pts = readPoints_v3(image_in, max_size, n)
%readPoints  This function creates black stripes on the image.
if nargin < 2
    n = Inf;
    pts = zeros(2, 0);
else
    pts = zeros(2, n);
end

%image_display=image_in(1:max_size(1),1:max_size(2));
image_display = addborder(image_in, max_size, 62, 'inner');

imshow(image_display, 'InitialMagnification', 100);     % display image
set(gcf,'position',get(0,'ScreenSize'));%Maximize
xold = 0;
yold = 0;
k = 0;
hold on;           % and keep it there while we plot
%We create the counter
h=msgbox({'Number of tagged features' num2str(0)});
set(findobj(h,'style','pushbutton'),'Visible','off')
set(h, 'Position', [20 40 120 50])
while 1
    %k
    %zoom on;
    %waitfor(gcf,'CurrentCharacter',char(13))
    [xi, yi, but] = ginput(1)      % get a point
    zoom off
    zoom(1/100)
    if ~isequal(but, 1)             % stop if not button 1
        break
    end
    set(findobj(h,'Tag','MessageBox'),'String',{'Number of tagged features' num2str(k)})
    k = k + 1;
    pts(1,k) = xi;
    pts(2,k) = yi;
      if xold
          plot([xold xi], [yold yi], 'go-');  % draw as we go
      else
          plot(xi, yi, 'go');         % first point on its own
      end
      if isequal(k, n)
          delete(h);
          break
      end
      xold = xi;
      yold = yi;
end
hold off;
if k < size(pts,2)
    pts = pts(:, 1:k);
end

end