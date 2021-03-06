function dcparain() 
    % Creates the input window for the parameters needed in order to compute the spatial variation of the correlation dimension.
    % Called from startfd.m (org=10).
    %
    %
    % turned into function by Celso G Reyes 2017
    
    ZG=ZmapGlobal.Data; % used by get_zmap_globals
    figure_w_normalized_uicontrolunits('Units','pixel','pos',[200 400 550 300 ],'Name','Parameters','visible','off',...
        'NumberTitle','off','Color',color_fbg,'NextPlot','new');
    axis off;
    
    input1 = uicontrol('Style','edit','Position',[.75 .85 .19 .06],...
        'Units','normalized','String',num2str(dim),...
        'callback',@callbackfun_001);
    
    input2 = uicontrol('Style','popupmenu','Position',[.75 .70 .23 .06],...
        'Units','normalized','String','Automatic Range|Manual Fixed Range|Manual',...
        'Value',1, 'Callback', @callbackfun_002);
    
    input3 = uicontrol('Style','edit','Position',[.34 .45 .10 .06],...
        'Units','normalized','String',num2str(radm), 'enable', 'off',...
        'Value',1, 'Callback', @callbackfun_003);
    
    input4 = uicontrol('Style','edit','Position',[.75 .45 .10 .06],...
        'Units','normalized','String',num2str(rasm), 'enable', 'off',...
        'Value',1, 'Callback', @callbackfun_004);
    
    %input5 = uicontrol('Style','popupmenu','Position',[.75 .30 .23 .06],...
    %   'Units','normalized','String','Earthquake Catalog|Random Catalog',...
    %   'Value',1, 'Callback', @callbackfun_005);
    
    
    tx1 = text('Position',[0 .95 0 ], ...
        'FontSize',ZmapGlobal.Data.fontsz.m , 'FontWeight','bold' , 'String',' Dimension of the Interevent Distances (2 or 3): ');
    
    tx2 = text('Position',[0 .75 0 ], ...
        'FontSize',ZmapGlobal.Data.fontsz.m , 'FontWeight','bold' , 'String',' Distance Range within which D is computed: ');
    
    tx3 = text('Position',[0 .45 0], ...
        'FontSize',ZmapGlobal.Data.fontsz.m , 'FontWeight','bold' , 'String','Minimum value: ', 'color', 'w');
    
    tx4 = text('Position',[.52 .45 0], ...
        'FontSize',ZmapGlobal.Data.fontsz.m , 'FontWeight','bold' , 'String','Maximum value: ', 'color', 'w');
    
    tx5 = text('Position',[.41 .45 0], ...
        'FontSize',ZmapGlobal.Data.fontsz.m , 'FontWeight','bold' , 'String','km', 'color', 'w');
    
    tx6 = text('Position',[.94 .45 0], ...
        'FontSize',ZmapGlobal.Data.fontsz.m , 'FontWeight','bold' , 'String','km', 'color', 'w');
    
    %tx7 = text('Position',[0 .25 0 ], ...
    %   'FontSize',ZmapGlobal.Data.fontsz.m , 'FontWeight','bold' , 'String',' Nature of Catalog  ');
    
    close_button=uicontrol('Style','Pushbutton',...
        'Position',[.60 .05 .20 .12 ],...
        'Units','normalized', 'Callback', @callbackfun_006,'String','Cancel');
    
    go_button=uicontrol('Style','Pushbutton',...
        'Position',[.20 .05 .20 .12 ],...
        'Units','normalized',...
        'callback',@callbackfun_007,...
        'String','Go');
    
    
    set(gcf,'visible','on');
    watchoff;
    
    function callbackfun_001(mysrc,myevt)
        
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        dim=str2double(input1.String);
        input1.String=num2str(dim);
    end
    
    function callbackfun_002(mysrc,myevt)
        
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        range=(get(input2,'Value'));
        input2.Value=range;
        actrange(range);
    end
    
    function callbackfun_003(mysrc,myevt)
        
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        radm=str2double(input3.String);
        input3.String= num2str(radm);
    end
    
    function callbackfun_004(mysrc,myevt)
        
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        rasm=str2double(input4.String);
        input4.String= num2str(rasm);
    end
    
    function callbackfun_005(mysrc,myevt)
        
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        cat=(get(input5,'Value'));
        input5.Value=cat;
    end
    
    function callbackfun_006(mysrc,myevt)
        
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        close;
        
    end
    function callbackfun_007(mysrc,myevt)
        
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        close;
        
        sel = 'ca';
        Dcross('ca');
    end
end
