function view_av2(lab1,re3) % autogenerated function wrapper
    % subroutine to plot a-value and others run by calc_across
    % This subroutine is based on view_bv2.m and
    % was created by Thomas van Stiphout 3/04
    % turned into function by Celso G Reyes 2017
    
    ZG=ZmapGlobal.Data; % used by get_zmap_globals
    if isempty(name)
        name = '  '
    end
    think
    report_this_filefun(mfilename('fullpath'));
    co = 'k';
    
    bmapc=findobj('Type','Figure','-and','Name','a-value cross-section');
    
    % Set up the Seismicity Map window Enviroment
    %
    if isempty(bmapc)
        bmapc = figure_w_normalized_uicontrolunits( ...
            'Name','a-value cross-section',...
            'NumberTitle','off', ...
            'backingstore','on',...
            'Visible','off', ...
            'Position',[ (fipo(3:4) - [600 400]) ZmapGlobal.Data.map_len]);
        
        lab1 = 'a-value';
        create_my_menu();
        colormap(jet)
        bOverlayTransparentStdDev = 0;
    end   % This is the end of the figure setup
    
    % plot the color-map of the z-value
    %
    figure(bmapc);
    delete(findobj(bmapc,'Type','axes'));
    reset(gca)
    cla
    hold off
    watchon;
    set(gca,'visible','off','FontSize',ZmapGlobal.Data.fontsz.m,'FontWeight','bold',...
        'FontWeight','bold','LineWidth',1.5,...
        'Box','on','SortMethod','childorder')
    
    rect = [0.15,  0.10, 0.8, 0.75];
    rect1 = rect;
    
    % set values greater tresh = nan
    %
    re4 = re3;
    l = r > tresh;
    re4(l) = nan(1,length(find(l)));
    
    % plot image
    %
    orient portrait
    %set(gcf,'PaperPosition', [2. 1 7.0 5.0])
    
    axes('position',rect)
    hold on
    pco1 = pcolor(gx,gy,re4);
    
    axis([ min(gx) max(gx) min(gy) max(gy)])
    axis image
    
    if bOverlayTransparentStdDev
        mTransparentStdDev = mAverageStdDev;
        vSelection = mAverageStdDev <= 0.05;
        mTransparentStdDev(vSelection) = 1;
        vSelection = (mAverageStdDev > 0.05) & (mAverageStdDev <= 0.1);
        mTransparentStdDev(vSelection) = 0.75;
        vSelection = (mAverageStdDev > 0.1) & (mAverageStdDev <= 0.15);
        mTransparentStdDev(vSelection) = 0.5;
        vSelection = (mAverageStdDev > 0.15) & (mAverageStdDev <= 0.2);
        mTransparentStdDev(vSelection) = 0.25;
        vSelection = mAverageStdDev > 0.2;
        mTransparentStdDev(vSelection) = 0;
        set(pco1, 'FaceALpha', 'flat', 'AlphaData', mTransparentStdDev, 'AlphaDataMapping', 'none');
    end
    bOverlayTransparentStdDev = 0;
    
    hold on
    if sha == 'fl'
        shading flat
    else
        shading interp
    end
    
    % make the scaling for the recurrence time map reasonable
    if lab1(1) =='T'
        fre = 0;
        l = isnan(re3);
        re = re3;
        re(l) = [];
        caxis([min(re) 5*min(re)]);
    end
    if fre == 1
        caxis([fix1 fix2])
    end
    
    title([name ';  '   num2str(t0b,4) ' to ' num2str(teb,4) ],'FontSize',ZmapGlobal.Data.fontsz.m,...
        'Color','w','FontWeight','bold')
    
    xlabel('Distance [km]','FontWeight','normal','FontSize',ZmapGlobal.Data.fontsz.s)
    ylabel('Depth [km]','FontWeight','normal','FontSize',ZmapGlobal.Data.fontsz.s)
    
    % plot overlay
    %
    ploeqc = plot(newa(:,length(newa(1,:))),-newa(:,7),'.k');
    set(ploeqc,'Tag','eqc_plot','MarkerSize',ZG.ms6,'Marker',ty,'Color',co,'Visible',vi)
    
    try
        
        if exist('vox', 'var')
            plovo = plot(vox,voy,'^r');
            set(plovo,'MarkerSize',8,'LineWidth',1,'Markerfacecolor','w','Markeredgecolor','r')
            axis([ min(gx) max(gx) min(gy) max([ 1 max(gy)]) ])
            
        end
        
        if exist('maix', 'var')
            pl = plot(maix,maiy,'*k');
            set(pl,'MarkerSize',12,'LineWidth',2)
        end
        
        if exist('maex', 'var')
            pl = plot(maex,-maey,'hm');
            set(pl,'LineWidth',1.,'MarkerSize',12,...
                'MarkerFaceColor','w','MarkerEdgeColor','k')
            
        end
        
        if exist('wellx', 'var')
            hold on
            plwe = plot(wellx,-welly,'w')
            set(plwe,'LineWidth',2);
        end
        
    catch
    end
    
    h1 = gca;
    hzma = gca;
    
    % Create a colorbar
    %
    
    h5 = colorbar('horz');
    apo = get(h1,'pos');
    set(h5,'Pos',[0.35 0.07 0.4 0.02],...
        'FontWeight','normal','FontSize',ZmapGlobal.Data.fontsz.s,'TickDir','out')
    
    rect = [0.00,  0.0, 1 1];
    axes('position',rect)
    axis('off')
    %  Text Object Creation
    txt1 = text(...
        'Position',[ 0.2 0.07 ],...
        'HorizontalAlignment','right',...
        'FontSize',ZmapGlobal.Data.fontsz.s,....
        'FontWeight','normal',...
        'String',lab1);
    
    
    % Make the figure visible
    %
    axes(h1)
    set(gca,'visible','on','FontSize',ZmapGlobal.Data.fontsz.s,'FontWeight','normal',...
        'FontWeight','normal','LineWidth',1.,...
        'Box','on','TickDir','out','Ticklength',[0.02 0.02])
    %whitebg(gcf,[0 0 0])
    set(gcf,'Color',[ 1 1 1 ])
    figure(bmapc);
    watchoff(bmapc)
    done
    
    %% ui functions
    function create_my_menu()
        add_menu_divider();
        
        add_symbol_menu('eqc_plot');
        
        options = uimenu('Label',' Select ');
        uimenu(options,'Label','Refresh ', 'callback',@callbackfun_001)
        uimenu(options,'Label','Select EQ in Circle (const N)',...
            'callback',@callbackfun_002)
        uimenu(options,'Label','Select EQ in Circle (const R)',...
            'callback',@callbackfun_003)
        uimenu(options,'Label','Select EQ in Circle - Overlay existing plot',...
            'callback',@callbackfun_004)
        uimenu(options,'Label','Select Eqs in Polygon - new',...
            'callback',@callbackfun_005);
        uimenu(options,'Label','Select Eqs in Polygon - hold',...
            'callback',@callbackfun_006);
        
        % Menu 'Maps'
        op1 = uimenu('Label',' Maps ');
        % A-Value map calculated by the MaxLikelihoodA...
        uimenu(op1,'Label','a-value map ',...
            'callback',@callbackfun_007)
        % B-Value map (fixed b-value by input from calc_avalgrid.m
        uimenu(op1,'Label','b-value map ',...
            'callback',@callbackfun_008)
        % Magnitude of completeness calculated by MaxCurvature
        uimenu(op1,'Label','Magnitude of completness map ',...
            'callback',@callbackfun_009)
        % Resolution estimation by mapping the needed radius to cover ni
        % earthquakes
        uimenu(op1,'Label','Resolution map',...
            'callback',@callbackfun_010)
        % Earthquake density map
        uimenu(op1,'Label','Earthquake density map',...
            'callback',@callbackfun_011)
        % Mu-value of the normal CDF
        uimenu(op1,'Label','Mu-value of the normal CDF',...
            'callback',@callbackfun_012)
        %  Sigma-value of the normal CDF
        uimenu(op1,'Label','Sigma-value of the normal CDF',...
            'callback',@callbackfun_013)
        
        
        add_display_menu(3)
    end
    
    %% callback functions
    
    function callbackfun_001(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        view_av2;
    end
    
    function callbackfun_002(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        h1 = gca;
        ZG=ZmapGlobal.Data;
        ZG.hold_state=false;
        cicros(1);
    end
    
    function callbackfun_003(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        h1 = gca;
        ZG=ZmapGlobal.Data;
        ZG.hold_state=false;
        cicros(2);
    end
    
    function callbackfun_004(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        h1 = gca;
        ZG=ZmapGlobal.Data;
        ZG.hold_state=true;
        cicros(0);
    end
    
    function callbackfun_005(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        ZG=ZmapGlobal.Data;
        ZG.hold_state=false;
        polyb;
    end
    
    function callbackfun_006(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        ZG=ZmapGlobal.Data;
        ZG.hold_state=true;
        polyb;
    end
    
    function callbackfun_007(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        lab1 ='a-value';
        re3 = aValueMap;
        view_av2(lab1,re3);
    end
    
    function callbackfun_008(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        lab1='b-value';
        re3 = bValueMap;
        view_av2(lab1,re3);
    end
    
    function callbackfun_009(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        lab1 = 'Mcomp';
        re3 = MaxCMap;
        view_av2(lab1,re3);
    end
    
    function callbackfun_010(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        lab1='Radius in [km]';
        re3 = reso;
        view_av2(lab1,re3);
    end
    
    function callbackfun_011(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        lab1='log(EQ per km^2)';
        re3 = log10(ni./(reso.^2*pi));
        view_av2(lab1,re3);
    end
    
    function callbackfun_012(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        lab1='Mu-Value';
        re3 = MuMap;
        view_av2(lab1,re3);
    end
    
    function callbackfun_013(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        lab1='Sigma-Value';
        re3 = SigmaMap;
        view_av2(lab1,re3);
    end
    
end

