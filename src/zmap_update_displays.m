function zmap_update_displays(opt)
    % zmap_update updates the various likely open dialogs & figures

    persistent ZG
    if isempty(ZG)
        ZG=ZmapGlobal.Data;
    end
    if ~exist('opt','var')
        opt='';
    end
    m=findobj(gcf,'Tag','mainmap_ax');
    
    if ~isempty(m)
        if opt == "showmap"
            m.update('show');
        else
            m.update();
        end
    end
    sh=ShapeGeneral.ShapeStash;
    sh.plot(findobj(gcf,'Tag','mainmap_ax'));
        
end