function add_display_menu(version)
    % adds a display menu to the current figure
    %
    % appently mostly used by the view_  functions
    
    % when called, hzma is the current axes;
    ZG=ZmapGlobal.Data;
    
    op2e = uimenu('Label','Display');
    switch version
        case 1
            circlefun=@plotci2;
            fixscalefun=@(data)fix_caxis(data,'horiz');
            uimenu(op2e,'Label','Plot Map in lambert projection',MenuSelectedField(),@(~,~)plotmap);
            %overlayfun=@overlay;
        case 2
            circlefun=@plotci2;
            fixscalefun=@(data)fix_caxis(data,'');
            uimenu(op2e,'Label','Plot Map in lambert projection',MenuSelectedField(),@(~,~)plotmap);
            %overlayfun=@overlay;
        case 3
            circlefun=@plotci3;
            fixscalefun=@(data)fix_caxis(data,'horiz');
            %overlayfun=@()zmap_update_displays();
        case 4
            circlefun=@plotci2;
            fixscalefun=@(data)fix_caxis(data,'horiz');
            uimenu(op2e,'Label','Plot Map in lambert projection',MenuSelectedField(),@(~,~)plotmap)
            uimenu(op2e,'Label','Plot map on top of topography (white background)',...
                MenuSelectedField(), @(~,~) dramap_z('dramap2_z','w', valueMap)); % this is different from case
            uimenu(op2e,'Label','Plot map on top of topography (black background)',...
                MenuSelectedField(), @(~,~)dramap_z('dramap2_z','k', valueMap)); % this is different from case #1 
            %overlayfun=@overlay;
        case 5
            circlefun=@plotci2;
            fixscalefun=@(data)fix_caxis(data,'horiz');
            add_colormap_section(op2e);
            add_shading_section(op2e);
            add_brighten_section(op2e);
            %overlayfun=@overlay;
    end
    
    uimenu(op2e,'Label','Fix color (z) scale',MenuSelectedField(),@(~,~)fixscalefun(ZGvalueMap));
    uimenu(op2e,'Label','Show Grid',MenuSelectedField(),@cb_showgrid);
    uimenu(op2e,'Label','Show Circles',MenuSelectedField(),@(~,~)circlefun);
    add_colormap_section(op2e);
    add_shading_section(op2e);
    add_brighten_section(op2e);
    uimenu(op2e,'Label','Redraw Overlay',...
        MenuSelectedField(), "set(gca,'NextPlot','add');zmap_update_displays();"); % this is different from case #1
    
    function cb_shader(style)
        % set default shading style and apply to current axes
        axes(gca);
        ZG.shading_style=style;
        shading(ZG.shading_style);
    end
    
    function cb_showgrid(src,~)
        set(gca,'NextPlot','add');
        plot(newgri(:,1),newgri(:,2),'+k')
    end
    function add_brighten_section(parent)
        uimenu(parent,'Label','Brighten +0.4',MenuSelectedField(), @(~,~)brighten(0.4));
        uimenu(parent,'Label','Brighten -0.4',MenuSelectedField(), @(~,~)brighten(-0.4))
    end
    function add_colormap_section(parent)
        uimenu(parent,'Label','Colormap InvertGray',...
            MenuSelectedField(),@(~,~)flip_and_brighten(@gray,0.4));
        uimenu(parent,'Label','Colormap Invertjet',...
            MenuSelectedField(),@(~,~)flip_and_brighten(@jet,0));

        function flip_and_brighten(colorfn,brightenamount)
            colormap(flipud(colorfn(64)));
            if brightenamount; brighten(brightenamount); end
        end
    end

    function add_shading_section(parent)
        %TODO make this 1 option, simple inputdlg box, or flip the names
        uimenu(parent,'Label','shading flat',...
            MenuSelectedField(),@(~,~)cb_shader('flat'))
        uimenu(parent,'Label','shading interpolated',...
            MenuSelectedField(),@(~,~)cb_shader('interp'))
    end
    
end