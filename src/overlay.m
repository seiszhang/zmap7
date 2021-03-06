function overlay() 
    % overlay plots an overlay of coastlines, faults, earthquakes etc on a map.
    % This file should be customized for each region
    % turned into function by Celso G Reyes 2017
    
    ZG=ZmapGlobal.Data; % used by get_zmap_globals
    
    %  Stefan Wiemer   11/94
    
    
    
    report_this_filefun();
    
    global main mainfault faults coastline vo
    %plot earthquakes
    %
    set(gca,'NextPlot','add')
    ploeq = plot(ZG.primeCatalog.Longitude,ZG.primeCatalog.Latitude,'.k');
    set(ploeq,'Markersize',2);
    set(gca,'NextPlot','add')
    set(gca,'Clipping','on')
    set(gca,'NextPlot','add')
    if ~isempty(faults)
        plo4 = plot(faults(:,1),faults(:,2),'w');
        set(plo4,'LineWidth',0.2,'Clipping','on')
    end  % if exist faults
    
    
    if ~isempty(coastline)
        mapplot = plot(coastline(:,1),coastline(:,2),'w');
    end
    
    %
    % plot big earthquake epicenters with a 'x' and the data/magnitude
    %
    if ~isempty(ZG.maepi)
        epimax = plot(ZG.maepi.Longitude,ZG.maepi.Latitude,'hm');
        set(epimax,'LineWidth',1.5,'MarkerSize',12,...
            'MarkerFaceColor','w','MarkerEdgeColor','k')
    end
    
    if exist('vo', 'var')
        if ~isempty(vo)
            plovo = plot(vo.Longitude,vo.Latitude,'^r');
            set(plovo,'LineWidth',1.5,'MarkerSize',6,...
                'MarkerFaceColor','w','MarkerEdgeColor','r');
        end
    end
    
    
    %plot mainshock(s)
    %
    if ~isempty(main)
        plo1 = plot(main(:,1),main(:,2),'hm');
        set(plo1,'LineWidth',1.5,'MarkerSize',12,...
            'MarkerFaceColor','w','MarkerEdgeColor','k')
        
    end  % if main
    
    %plot main faultline
    
    if ~isempty(mainfault)
        plo3 = plot(mainfault(:,1),mainfault(:,2),'k');
        set(plo3,'LineWidth',1.0,'Clipping','on')
    end  % if exist mainfault
    
    
end
