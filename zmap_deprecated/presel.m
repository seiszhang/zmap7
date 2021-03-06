function presel(call, vals) 
    %  This scriptfile ask for several input parameters that can be setup
    %  at the beginning of each session. The default values are the
    %  extrema in the catalog
    %
    %a = org;        % resets the main catalogue "primeCatalog" to initial state
    % turned into function by Celso G Reyes 2017
    
    ZG=ZmapGlobal.Data; % used by get_zmap_globals
    report_this_filefun();
    
    %
    % make the interface
    latmin=0;latmax=0;lonmin=0;lonmax=0;tmin=0;tmax=0;Mmin=0;Mmax=0;mindep=0;maxdep=0;
    %zdlg = ZmapDialog();
    %zdlg.AddEdit('latmin','min Lat:');
    %
    figure_w_normalized_uicontrolunits(...
        'Units','pixel','pos',[ZG.welcome_pos 380 500 ],...
        'Name','Pre-selection Parameters!',...
        'visible','off',...
        'NumberTitle','off',...
        ...'Color',color_fbg,...
        'NextPlot','new');
    axis off
    
    inp1A=uicontrol('Style','edit','Position',[.30 .80 .15 .05],...
        'Units','normalized','String',num2str(latmin,6),...
        'callback',@callbackfun_001);
    
    inp2A=uicontrol('Style','edit','Position',[.30 .70 .15 .05],...
        'Units','normalized','String',num2str(latmax,6),...
        'callback',@callbackfun_002);
    
    inp1=uicontrol('Style','edit','Position',[.70 .80 .15 .05],...
        'Units','normalized','String',num2str(lonmin,6),...
        'callback',@callbackfun_003);
    
    inp2=uicontrol('Style','edit','Position',[.70 .70 .15 .05],...
        'Units','normalized','String',num2str(lonmax,6),...
        'callback',@callbackfun_004);
    
    inp3=uicontrol('Style','edit','Position',[.70 .60 .22 .05],...
        'Units','normalized','String',num2str(tmin),...
        'callback',@callbackfun_005);
    
    inp4=uicontrol('Style','edit','Position',[.70 .50 .22 .05],...
        'Units','normalized','String',num2str(tmax),...
        'callback',@callbackfun_006);
    
    inp5=uicontrol('Style','edit','Position',[.70 .40 .22 .05],...
        'Units','normalized','String',num2str(Mmin),...
        'callback',@callbackfun_007);
    
    inp6=uicontrol('Style','edit','Position',[.70 .30 .22 .05],...
        'Units','normalized','String',num2str(Mmax),...
        'callback',@callbackfun_008);
    
    inp7=uicontrol('Style','edit','Position',[.30 .15 .15 .05],...
        'Units','normalized','String',num2str(mindep),...
        'callback',@callbackfun_009);
    
    inp8=uicontrol('Style','edit','Position',[.50 .15 .15 .05],...
        'Units','normalized','String',num2str(maxdep),...
        'callback',@callbackfun_010);
    
    
    
    close_button=uicontrol('Style','Pushbutton',...
        'Position',[.65 .02 .20 .10 ],...
        'Units','normalized','callback',@callbackfun_011,'String','Cancel');
    
    go_button=uicontrol('Style','Pushbutton',...
        'Position',[.35 .02 .20 .10 ],...
        'Units','normalized',...
        'callback',@callbackfun_012,...
        'String','Go');
    
    info_button=uicontrol('Style','Pushbutton',...
        'Position',[.05 .02 .20 .10 ],...
        'Units','normalized',...
        'callback',@callbackfun_013,...
        'String','Info');
    titstr = 'General Parameters';
    hlpStr = ...
        ['This window allows you to select earthquakes '
        'from a catalog. You can select a subset in   '
        'time, magnitude and depth.                   '
        '                                             '
        'The top frame displays the number of         '
        'earthquakes in the catalog - no selection is '
        'possible.                                    '
        '                                             '
        'Two more parameters can be adjusted: The Bin '
        'length in days that is used to sample the    '
        'seismicity and the minimum magnitude of      '
        'quakes displayed with a larger symbol in the '
        'map.                                         '];
    
    
    
    
    text(...
        'Position',[0.55 0.75 0 ],...
        'FontSize',ZmapGlobal.Data.fontsz.m ,...
        'FontWeight','bold' ,...
        'String','max Lon:');
    
    text(...
        'Position',[0.55 0.87 0 ],...
        'FontSize',ZmapGlobal.Data.fontsz.m ,...
        'FontWeight','bold' ,...
        'String','min Lon: ');
    
    
    text(...
        'Position',[0.02 0.75 0 ],...
        'FontSize',ZmapGlobal.Data.fontsz.m ,...
        'FontWeight','bold' ,...
        'String','max Lat:');
    
    text(...
        'Position',[0.02 0.87 0 ],...
        'FontSize',ZmapGlobal.Data.fontsz.m ,...
        'FontWeight','bold' ,...
        'String','min Lat: ');
    
    txt4 = text(...
        'Position',[0.02 0.63 0 ],...
        'FontSize',ZmapGlobal.Data.fontsz.m ,...
        'FontWeight','bold' ,...
        'String','Beginning year: ');
    
    txt5 = text(...
        'Position',[0.02 0.51 0 ],...
        'FontSize',ZmapGlobal.Data.fontsz.m ,...
        'FontWeight','bold' ,...
        'String','Ending year: ');
    
    txt6 = text(...
        'Position',[0.02 0.38 0 ],...
        'FontSize',ZmapGlobal.Data.fontsz.m ,...
        'FontWeight','bold' ,...
        'String','Minimum Magnitude: ');
    
    txt6 = text(...
        'Position',[0.02 0.25 0 ],...
        'FontSize',ZmapGlobal.Data.fontsz.m ,...
        'FontWeight','bold' ,...
        'String','Maximum Magnitude: ');
    
    txt7 = text(...
        'Position',[0.02 0.15 0 ],...
        'FontSize',ZmapGlobal.Data.fontsz.m ,...
        'FontWeight','bold' ,...
        'String','       Min Depth                Max Depth  ');
    
    
    %clear txt1 txt2 txt3 txt4 txt5 txt6 txt7 inp1 inp1B inp3 inp3 inp4 inp5 inp6 inp7
    set(gcf,'visible','on')
    watchoff
    str = [ 'Please Select a subset of earthquakes'
        ' and press Go                        '];
    ZmapMessageCenter.set_message('Message',str);
    
    
    
    function callbackfun_001(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        latmin=str2double(inp1A.String);
        inp1A.String=num2str(latmin,6);
    end
    
    function callbackfun_002(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        latmax=str2double(inp2A.String);
        inp2A.String=num2str(latmax,6);
    end
    
    function callbackfun_003(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        lonmin=str2double(inp1.String);
        inp1.String=num2str(lonmin,6);
    end
    
    function callbackfun_004(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        lonmax=str2double(inp2.String);
        inp2.String=num2str(lonmax,6);
    end
    
    function callbackfun_005(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        tmin=str2double(inp3.String);
        inp3.String=num2str(tmin);
    end
    
    function callbackfun_006(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        tmax=str2double(inp4.String);
        inp4.String=num2str(tmax);
    end
    
    function callbackfun_007(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        Mmin=str2double(inp5.String);
        inp5.String=num2str(Mmin);
    end
    
    function callbackfun_008(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        Mmax=str2double(inp6.String);
        inp6.String=num2str(Mmax);
    end
    
    function callbackfun_009(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        mindep=str2double(inp7.String);
        inp7.String=num2str(mindep);
    end
    
    function callbackfun_010(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        maxdep=str2double(inp8.String);
        inp8.String=num2str(maxdep);
    end
    
    function callbackfun_011(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        close;
        ZmapMessageCenter.set_info(' ',' ');
        
    end
    
    function callbackfun_012(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        close;
        
        inda = 2 ;
        call();
    end
    
    function callbackfun_013(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        zmaphelp(titstr,hlpStr);
    end
    
end
