function plotmap(fig)
    % PLOTMAP plot a lambert map,  based on current axes
    %  adds earthquakes from main map, and adds some features.
    %
    %
    % plot a lambert map,  based on current axes
    ax=gca;
    if exist('fig','var') && isnumeric(fig) && ~isempty(fig)
        figure(fig)
    else
        figure
    end
    
    lonlims=get(ax,'XLim'); lonrange=lonlims(2)-lonlims(1);
    latlims=get(ax,'YLim'); latrange=latlims(2)-latlims(1);
    ax2=axesm('MapProjection','lambert','MapLatLimit',latlims,'MapLonLimit',lonlims);
    framem
    
    if lonrange < 5
        lonbasis=.5; % example.
    elseif lonrange < 30
        lonbasis=ceil(lonrange/10);
    else
        lonbasis=10;
    end
     if latrange < 5
        latbasis=.5; % example.
    elseif latrange < 30
        latbasis=ceil(latrange/10);
    else
        latbasis=10;
    end
    
    setm(ax2,'MLineLocation',lonbasis/2, 'PLineLocation',latbasis/2); % degrees for grid lines
    setm(ax2,'Grid','on')
    setm(ax2,'MeridianLabel','on','ParallelLabel','on');
    setm(ax2,'PLabelLocation',lonbasis,'MLabelLocation',latbasis);  % degrees for labeling
    setm(ax2,'LabelFormat','signed','LabelUnits','degrees'); % 'dm','dms'
    setm(ax2,'MLabelRound',-1,'PLabelRound',-1);
    ZG=ZmapGlobal.Data;
    copyobj(ZG.features('coastline'),ax2);
    copyobj(ZG.features('borders'),ax2);
    copyobj(ZG.features('faults'),ax2);
    copyobj(ZG.features('lakes'),ax2);
    %copyobj(ZG.features('rivers'),ax2);
    
    
    % add earthquakes from main map
    qs=findobj(findobj(gcf,'Tag','mainmap_ax'),'-regexp','Tag','mapax_part.+');
    %symbs=['+o*v^><s'];
    for n=1:numel(qs)
        h=plotm(qs(n).YData,qs(n).XData,'.','Color',qs(n).Color .* [.6],...
            'DisplayName',qs(n).DisplayName,...
            'ZData',qs(n).ZData);
        set(h,'MarkerSize',get(h,'MarkerSize')/1.5);
    end
    set(gca,'ZDir','reverse');
    
    % add the overlay
    srf=findobj(ax,'Type','Surface');
    if ~isempty(srf)
        cm=colormap(ax);
        pcolorm(srf.YData,srf.XData,srf.ZData,'CData',srf.CData)
        colormap(cm);
        colorbar;
    end
    title(ax.Title.String,'Interpreter','none');
    
end