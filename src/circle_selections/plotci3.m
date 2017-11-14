function plotci3() % autogenerated function wrapper
    %  plot a circle containing ni events
    %  around each grid point
    % turned into function by Celso G Reyes 2017
    
    ZG=ZmapGlobal.Data; % used by get_zmap_globals
    
    report_this_filefun(mfilename('fullpath'));
    
    figure
    orient landscape
    axes('position',[ 0.1 0.1 0.8 0.8])
    hold on
    axis([ min(gx) max(gx) min(gy) max(gy)])
    axis image
    xlabel('Distance in [km]','FontWeight','bold','FontSize',ZmapGlobal.Data.fontsz.s)
    ylabel('Depth in [km]','FontWeight','bold','FontSize',ZmapGlobal.Data.fontsz.s)
    
    if exist('maex', 'var')
        pl = plot(maex,-maey,'xw');
        set(pl,'MarkerSize',10,'LineWidth',2)
    end
    set(gca,'visible','on','FontSize',ZmapGlobal.Data.fontsz.s,'FontWeight','bold',...
        'FontWeight','bold','LineWidth',1.5,...
        'Box','on','TickDir','out')
    h1 = gca;
    
    hold on;
    pl = plot(newgri(:,1),newgri(:,2),'+k','Markersize',3)
    st = 3;
    [X,Y] = meshgrid(gx,gy);
    [m,n]= size(r);
    hold on
    x = -pi-0.1:0.1:pi;
    for i = 1:st:m
        for k = 1:st:n
            if r(i,k) <= ZG.tresh_km;
                plot(X(i,k)+r(i,k)*1*sin(x),Y(i,k)+r(i,k)*1*cos(x),'color',[0.5 0.5 0.5])
                %   plot(X(i,k)+4.0*sin(x),Y(i,k)+4.0*cos(x),'r')
                hold on
                plovo = plot(X(i,k),Y(i,k),'^k','Markersize',5)
                set(plovo,'LineWidth',1.,'MarkerSize',5,...
                    'MarkerFaceColor','w','MarkerEdgeColor','k');
                
            end
        end
    end
    
    
    set(gca,'Color',color_bg)
    
    
    
end