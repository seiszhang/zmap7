% This subroutine assigns creates a grid with
% spacing dx,dy (in degreees). The size will
% be selected interactiVELY. The bvalue in each
% volume around a grid point containing ni earthquakes
% will be calculated as well as the magnitude
% of completness
%   Stefan Wiemer 1/95

report_this_filefun(mfilename('fullpath'));

global no1 bo1

if sel == 'in'
    % get the grid parameter
    % initial values
    %
    dd = 1.00;
    dx = 1.00 ;
    ni = 100;

    % make the interface
    %
    figure_w_normalized_uicontrolunits(...
        'Name','Grid Input Parameter',...
        'NumberTitle','off', ...
        'MenuBar','none', ...
        'units','points',...
        'Visible','off', ...
        'Position',[ wex+200 wey-200 450 250]);
    axis off

    % creates a dialog box to input grid parameters
    %
    freq_field=uicontrol('Style','edit',...
        'Position',[.60 .50 .22 .10],...
        'Units','normalized','String',num2str(ni),...
        'Callback','ni=str2double(get(freq_field,''String'')); set(freq_field,''String'',num2str(ni));');

    freq_field2=uicontrol('Style','edit',...
        'Position',[.60 .40 .22 .10],...
        'Units','normalized','String',num2str(dx),...
        'Callback','dx=str2double(get(freq_field2,''String'')); set(freq_field2,''String'',num2str(dx));');

    freq_field3=uicontrol('Style','edit',...
        'Position',[.60 .30 .22 .10],...
        'Units','normalized','String',num2str(dd),...
        'Callback','dd=str2double(get(freq_field3,''String'')); set(freq_field3,''String'',num2str(dd));');

    close_button=uicontrol('Style','Pushbutton',...
        'Position',[.60 .05 .15 .12 ],...
        'Units','normalized','Callback','close;done','String','Cancel');

    go_button1=uicontrol('Style','Pushbutton',...
        'Position',[.20 .05 .15 .12 ],...
        'Units','normalized',...
        'Callback','close,sel =''ca'', selgpc',...
        'String','Go');

    txt3 = text(...
        'Color',[0 0 0 ],...
        'EraseMode','normal',...
        'Position',[0.30 0.74 0 ],...
        'Rotation',0 ,...
        'FontSize',fontsz.l ,...
        'FontWeight','bold',...
        'String',' Grid Parameter');
    txt5 = text(...
        'Color',[0 0 0 ],...
        'EraseMode','normal',...
        'Position',[0. 0.42 0 ],...
        'Rotation',0 ,...
        'FontSize',fontsz.m ,...
        'FontWeight','bold',...
        'String','Spacing along projection [km]');

    txt6 = text(...
        'Color',[0 0 0 ],...
        'EraseMode','normal',...
        'Position',[0. 0.32 0 ],...
        'Rotation',0 ,...
        'FontSize',fontsz.m ,...
        'FontWeight','bold',...
        'String','Spacing in depth in km:');

    txt1 = text(...
        'Color',[0 0 0 ],...
        'EraseMode','normal',...
        'Position',[0. 0.53 0 ],...
        'Rotation',0 ,...
        'FontSize',fontsz.m,...
        'FontWeight','bold',...
        'String','Number of Events (Ni):');
    if term == 1 ; whitebg(gcf,[1 1 1 ]);end
    set(gcf,'visible','on');
    watchoff

end   % if sel == in

% get the grid-size interactively and
% calculate the b-value in the grid by sorting
% thge seimicity and selectiong the ni neighbors
% to each grid point

if sel == 'ca'

    figure_w_normalized_uicontrolunits(xsec_fig)
    hold on

    messtext=...
        ['To select a polygon for a grid.       '
        'Please use the LEFT mouse button of   '
        'or the cursor to the select the poly- '
        'gon. Use the RIGTH mouse button for   '
        'the final point.                      '
        'Mac Users: Use the keyboard "p" more  '
        'point to select, "l" last point.      '
        '                                      '];

    welcome('Select Polygon for a grid',messtext);
    ax = findobj('Tag','main_map_ax');
    [x,y, mouse_points_overlay] = select_polygon(ax);
    welcome('Message',' Thank you .... ')

    plos2 = plot(x,y,'b-','era','xor');        % plot outline
    sum3 = 0.;
    pause(0.3)

    %create a rectangular grid
    xvect=[min(x):dx:max(x)];
    yvect=[min(y):dd:max(y)];
    gx = xvect;gy = yvect;
    tmpgri=zeros((length(xvect)*length(yvect)),2);
    n=0;
    for i=1:length(xvect)
        for j=1:length(yvect)
            n=n+1;
            tmpgri(n,:)=[xvect(i) yvect(j)];
        end
    end
    %extract all gridpoints in chosen polygon
    XI=tmpgri(:,1);
    YI=tmpgri(:,2);

    ll = polygon_filter(x,y, XI, YI, 'inside');
    %grid points in polygon
    newgri=tmpgri(ll,:);

    % Plot all grid points
    plot(newgri(:,1),newgri(:,2),'+k')

    if length(xvect) < 2  ||  length(yvect) < 2
        errordlg('Selection too small! (not a matrix)');
        return
    end

    itotal = length(newgri(:,1));

    welcome(' ','Running... ');think
    %  make grid, calculate start- endtime etc.  ...
    %
    t0b = newa(1,3)  ;
    n = length(newa(:,1));
    teb = newa(n,3) ;
    tdiff = round((teb - t0b)*365/par1);
    loc = zeros(3,length(gx)*length(gy));

end  % if sel = 'ca'
