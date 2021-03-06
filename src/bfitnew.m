function bfitnew(mycat)
    %Calculates Freq-Mag functions (b-value) for a catalog
    %  A.Allmann  10/94
    %  modified  Stefan Wiemer 12/94
    %
    %  originally, "mycat" was "newcat"
    global  cluscat mess bfig backcat
    global magsteps_desc bvalsum3
    report_this_filefun();
    ZG = ZmapGlobal.Data;
    
    bfig=findobj('Type','Figure','-and','Name','frequency-magnitude distribution - 2');
    if isempty(bfig)
        bfig=figure_w_normalized_uicontrolunits(...                  %build figure for plot
            'Units','normalized','NumberTitle','off',...
            'Name','frequency-magnitude distribution - 1',...
            'visible','on',...
            'pos',[ 0.300  0.4 0.5 0.5]);
        
        uicontrol('Units','normal',...
            'Position',[.0 .65 .08 .06],'String','Save ',...
            'Callback',{@calSave9,magsteps_desc, bvalsum3})
        
        
        
    end
    
    figure(bfig);
    delete(findobj(bfig,'Type','axes'));
    set(gca,'NextPlot','add'); axis off
    uicontrol('Style','Pushbutton',...
        'callback',@callbackfun_001,...
        'Units','normalized',...
        'String','Print','Position',[0.02 .93 .08 .05]);
    
    uicontrol('Style','Pushbutton',...
        'callback',@callbackfun_002,...
        'Units','normalized',...
        'String','Close','Position',[0.02 .73 .08 .05]);
    uicontrol('Style','Pushbutton',...
        'callback',@(~,~)clinfo("fromBvalPlot"),...
        'Units','normalized',...
        'String','Info','Position',[0.02 .83 .08 .05]);
    
    uicontrol('Units','normal',...
        'Position',[.0 .55 .10 .06],'String','Automatic',...
        'callback',@(~,~)bdiff(mycat));
    
    maxmag = max(mycat.Magnitude);
    mima = min(mycat.Magnitude);
    if mima > 0 mima = 0;end
    
    % number of mag units
    nmagu = (maxmag*10)+1;
    
    [bval,xt2] = hist(mycat.Magnitude,(mima:0.1:maxmag));
    bvalsum = cumsum(bval);                        % N for M <=
    bvalsum3 = cumsum(bval(end:-1:1));    % N for M >= (counted backwards)
    magsteps_desc = (maxmag:-0.1:mima);
    
    
    backg_be = log10(bvalsum);
    backg_ab = log10(bvalsum3);
    orient tall
    rect = [0.2,  0.3, 0.70, 0.6];           % plot Freq-Mag curves
    axes('position',rect);
    
    semilogy(magsteps_desc,bvalsum3,'-.m')
    set(gca,'NextPlot','add')
    semilogy(magsteps_desc,bvalsum3,'om')
    grid
    xlabel('Magnitude','FontWeight','bold','FontSize',ZmapGlobal.Data.fontsz.m)
    ylabel('Cumulative Number','FontWeight','bold','FontSize',ZmapGlobal.Data.fontsz.m)
    set(gca,'Color',ZG.color_bg)
    set(gca,'XLim',[min(mycat.Magnitude)-0.5  max(mycat.Magnitude)+0.3])
    set(gca,'visible','on','FontSize',ZmapGlobal.Data.fontsz.m,'FontWeight','bold',...
        'FontWeight','bold','LineWidth',1.5,...
        'Box','on')
    
    set(gcf,'visible','on');
    
    str=['Please select two magnitudes for a the straight line fit.',...
        ' Wait until after the selection before pressing Info or Close. '];
    
    
    figure(bfig);
    seti = uicontrol('Style','text','Units','normal',...
        'Position',[.4 .01 .3 .05],'String','Select First Magnitude ');
    
    pause(1)
    
    M1b = ginput(1);
    tt3=num2str(fix(100*M1b(1))/100);
    text( M1b(1),M1b(2),['|: M1=',tt3] )
    set(seti,'String','Select Second Magnitude');
    
    pause(0.1)
    
    M2b = ginput(1);
    tt4=num2str(fix(100*M2b(1))/100);
    text( M2b(1),M2b(2),['|: M2=',tt4] )
    
    pause(0.1)
    delete(seti)
    
    ll = magsteps_desc > M1b(1) & magsteps_desc < M2b(1);
    x = magsteps_desc(ll);
    y = backg_ab(ll);
    [p,s] = polyfit(x,y,1);                   % fit a line to background
    f = polyval(p,x);
    f = 10.^f;
    set(gca,'NextPlot','add')
    ttm= semilogy(x,f,'b');                         % plot linear fit to backg
    set(ttm,'LineWidth',2)
    r = corrcoef(x,y);
    r = r(1,2);
    std_backg = std(y - polyval(p,x));      % standard deviation of fit
    
    hh = gca;
    p=-p(1,1);
    p=fix(100*p)/100;
    std_backg=fix(100*std_backg)/100;
    tt2=num2str(std_backg);
    tt1=num2str(p);
    
    rect=[0 0 1 1];
    h2=axes('position',rect);
    set(h2,'visible','off');
    
    txt1=text(.16, .18,['B-Value: ',tt1]);
    set(txt1,'FontWeight','bold','FontSize',ZmapGlobal.Data.fontsz.m)
    txt1=text(.16, .1,['Standard Deviation: ',tt2]);
    set(txt1,'FontWeight','bold','FontSize',ZmapGlobal.Data.fontsz.m)
    
    uicontrol('Style','Pushbutton',...
        'callback',@(~,~)bfitnew(mycat),...
        'Units','normalized',...
        'String','Repeat','Position',[0.85 .02 .12 .08]);
    
    axes(hh)
    disp('B-value fit instructions')
    disp(str)
    
    function callbackfun_001(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        printdlg;
    end
    
    function callbackfun_002(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        close;
        
    end
    
    
end
