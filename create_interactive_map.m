function create_interactive_map(fig_map, orig_image)
    % Create a figure and axes
    f = figure('Visible','on', 'Position',[230 250 1000 1000]);
    ax = axes('Units','pixels');
    h = imshow(fig_map(:,:,1));
    colormap jet
    hold on
    mhp=imshow(orig_image);
    set(h, 'AlphaData',0.5)
    global drawing_map

    
    
    % Create pop-up menu
    popup = uicontrol('Style', 'popup',...
           'String', {'Cones','Null','Other'},...
           'Value',1,...
           'Position', [20 880 100 50],...
           'Callback', @setmap);    
    
   % Create push button
    btn = uicontrol('Style', 'pushbutton', 'String', 'Clear',...
        'Position', [20 20 50 20],...
        'Callback', 'cla');      
    % Create push button to redraw
    btn = uicontrol('Style', 'pushbutton', 'String', 'Redraw',...
        'Position', [100 20 50 20],...
        'Callback', @redraw);
    popup.Value
   % Create slider
    sld = uicontrol('Style', 'slider',...
        'Min',0.1,'Max',0.9,'Value',0.5,...
        'Position', [880 480 20 420],...
        'Callback', {@surfzlim, popup.Value}); 
					
    % Add a text uicontrol to label the slider.
    txt = uicontrol('Style','text',...
        'FontSize', 12,...
        'Position',[840 960 120 20],...
        'String','Set Threshold');
    txt = uicontrol('Style','text',...
        'FontSize', 21,...
        'Position',[250 960 500 40],...
        'String','MarsNet Interface');
   
    % Make figure visble after adding all components
    f.Visible = 'on';
    % This code uses dot notation to set properties. 
    % Dot notation runs in R2014b and later.
    % For R2014a and earlier: set(f,'Visible','on');
    
    function setmap(source,callbackdata)

        drawing_map = fig_map(:,:, source.Value);
        mhp=imshow(orig_image);
        hold on
        h = imshow(drawing_map<0.5);
        set(h, 'AlphaData',0.3)
        
        % For R2014a and earlier: 
        % val = get(source,'Value');
        % maps = get(source,'String'); 


    end

    function surfzlim(source,callbackdata, value_feat)
        mhp=imshow(orig_image);
        hold on
        h = imshow(drawing_map<source.Value);
        
        set(h, 'AlphaData',0.3)
        hold on
        text_str = ['Threshold = ', num2str(source.Value,'%.2f')]
        txt = uicontrol('Style','text',...
            'FontSize', 12,...
        'Position',[400 45 220 20],...
        'String',text_str);
        
        
    end
    function redraw(source, callbackdata)
        h = imshow(orig_image);
    
        
    end
end