function doinvers_michael(mycat) 
    % doinvers_michael calculates orientation of the stress tensor based on Gephard's algorithm.
    % stress tensor orientation. The actual calculation is done using a call to a fortran program.
    %
    % Stefan Wiemer 03/96
    
    % todo: HOW DOES THIS DIFFER FRON DOINVERSE?
    
    global mif1 mif2
    global tmpi cumu2
    % Save path to current folder
    sPath = pwd;
    ZG = ZmapGlobal.Data;
    fs = filesep;
    
    report_this_filefun();
    
    
    % Number of bootstraps
    rep = 2000;
    %if isunix ~= 1
    % errordlg('Misfit calculation only implemented for UNIX version! ');
    % return
    %end
    
    % making assumption that columns 10-12 were dip, dip idirection, etc.
    if isempty(mycat.Dip) || isempty(mycat.DipDirection) || isempty(mycat.Rake)
        errordlg('You do not have the required fields to calculate misfit');
        return
    end
    
    
    hodis = fullfile(hodi, 'external');
    
    tmpi = [ZG.mycat.Dip , ZG.mycat.DipDirection , ZG.mycat.Rake];
    
    cd(hodis);
    
    fid = fopen('data2','w');
    str = ['Inversion data'];
    str = str';
    
    fprintf(fid,'%s  \n',str');
    fprintf(fid,'%7.3f  %7.3f  %7.3f \n',tmpi');
    
    fclose(fid);
    
    
    delete data2.slboot Xtemp.slboot
    disp('Now doing inversion ... ')
    watchon
    helpdlg('The inversion is running right now ... it will take a few seconds ... please wait until results appear ');
    
    % slfast calculates the best solution for the stress tensor according to
    % Michael(1987): creates data2.slboot for bootslickw
    %[stat, res] = unix(['.' fs 'slfast data2 ']);
    
    switch computer
        case 'GLNX86'
            [stat, res] = unix(['".' fs 'slfast_linux" data2 ']);
        case 'MAC'
            [stat, res] = unix(['".' fs 'slfast_macppc" data2 ']);
        case 'MACI'
            [stat, res] = unix(['".' fs 'slfast_maci" data2 ']);
        case 'MACI64'
            [stat, res] = unix(['".' fs 'slfast_maci" data2 ']);
        otherwise
            [stat, res] = dos(['".' fs 'slfast.exe" data2 ']);
    end
    
    if strcmp(res,'') == 0
        helpdlg('It seems that the inversion did not run, because the command slick_* data2 could not be executed. Is the executebale slick in the directory extrenal? ','error inverting');
        return
    end
    % slick calculates the best solution for the stress tensor according to
    % Michael(1987): creates data2.oput
    
    switch computer
        case 'GLNX86'
            unix(['".' fs 'slick_linux" data2 ']);
        case 'MAC'
            unix(['".' fs 'slick_macppc" data2 ']);
        case 'MACI'
            unix(['".' fs 'slick_maci" data2 ']);
        case 'MACI64'
            unix(['".' fs 'slick_maci" data2 ']);
        otherwise
            dos(['".' fs 'slick.exe" data2 ']);
    end
    % Get data from data2.oput
    sFilename = ['data2.oput'];
    [fBeta, fStdBeta, fTauFit, fAvgTau, fStdTau] = import_slickoput(sFilename);
    
    load data2.slboot
    % d0: Best solution for stress tensor
    d0 = data2;
    
    % bootslickw resamples the data and uses slfast to calculate the best fitting stress tensor
    switch computer
        case 'GLNX86'
            unix(['".' fs 'bootslickw_linux" data2 ' num2str(rep) ' 0.5' ]);
        case 'MAC'
            unix(['".' fs 'bootslickw_macppc" data2 ' num2str(rep) ' 0.5' ]);
        case 'MACI'
            unix(['".' fs 'bootslickw_maci" data2 ' num2str(rep) ' 0.5' ]);
        case 'MACI64'
            unix(['".' fs 'bootslickw_maci" data2 ' num2str(rep) ' 0.5' ]);
        otherwise
            dos(['".' fs 'bootslickw.exe" data2 ' num2str(rep) ' 0.5' ]);
    end
    
    disp(' Done !  ')
    watchoff
    
    
    load Xtemp.slboot
    l = 2:2:2*rep;
    % d1: Bootstrap stress tensor solutions
    d1 = Xtemp(l,:);
    
    % Back to the original folder
    cd(sPath);
    
    % Now plot the results
    figure
    wulff
    set(gca,'NextPlot','add')
    
    %gridsize
    radius=0.05;
    
    % Plotting the bootstrap solutions of S1
    X = [d1(:,3) d1(:,2) ];
    theta = pi*(90-X(:,2))/180;      %az converted to MATLAB angle
    rho = tan(pi*(90-X(:,1))/360);   %projected distance from origin
    
    colormap(hot);
    brighten(0.5);
    densiter=denserfocalv2(rho,theta,radius);
    [xvec, yvec] =meshgrid(-1:0.01:1,-1:0.01:1);
    zvec=griddata(densiter(:,1),densiter(:,2),densiter(:,3),xvec,yvec);
    p11=contourf(xvec,yvec,zvec);
    
    %calculate 95% confidence interval
    bpoints(:,1)= rho .* cos(theta); %xval bootstrap
    bpoints(:,2)= rho .* sin(theta); %yval bootstrap
    
    X = [d0(2,3) d0(2,2) ];
    theta = pi*(90-X(:,2))/180;      %az converted to MATLAB angle
    rho = tan(pi*(90-X(:,1))/360);   %projected distance from origin
    solpoint(:,1)= rho .* cos(theta); %xval solution
    solpoint(:,2)= rho .* sin(theta); %yval solution
    
    cline = contour_dense(bpoints, solpoint, 0.95, 36);
    plot(cline(:,1),cline(:,2),'k', 'LineWidth',3,'LineStyle','--',...
        'DisplayName','95%');
    
    
    
    % Plotting the bootstrap solutions of S2
    X = [d1(:,5) d1(:,4) ];
    theta = pi*(90-X(:,2))/180;      %az converted to MATLAB angle
    rho = tan(pi*(90-X(:,1))/360);   %projected distance from origin
    
    densiter=denserfocalv2(rho,theta,radius);
    [xvec, yvec] =meshgrid(-1:0.01:1,-1:0.01:1);
    zvec=griddata(densiter(:,1),densiter(:,2),densiter(:,3),xvec,yvec);
    p12=contourf(xvec,yvec,zvec);
    
    %calculate 95% confidence interval
    bpoints(:,1)= rho .* cos(theta); %xval bootstrap
    bpoints(:,2)= rho .* sin(theta); %yval bootstrap
    
    X = [d0(2,5) d0(2,4) ];
    theta = pi*(90-X(:,2))/180;      %az converted to MATLAB angle
    rho = tan(pi*(90-X(:,1))/360);   %projected distance from origin
    solpoint(:,1)= rho .* cos(theta); %xval solution
    solpoint(:,2)= rho .* sin(theta); %yval solution
    
    cline = contour_dense(bpoints, solpoint, 0.95, 36);
    plot(cline(:,1),cline(:,2),'k', 'LineWidth',3,'LineStyle','--',...
        'DisplayName','95%');
    
    
    
    
    % Plotting the bootstrap solutions of S3
    X = [d1(:,7) d1(:,6) ];
    theta = pi*(90-X(:,2))/180;      %az converted to MATLAB angle
    rho = tan(pi*(90-X(:,1))/360);   %projected distance from origin
    
    densiter=denserfocalv2(rho,theta,radius);
    [xvec, yvec] =meshgrid(-1:0.01:1,-1:0.01:1);
    zvec=griddata(densiter(:,1),densiter(:,2),densiter(:,3),xvec,yvec);
    p13=contourf(xvec,yvec,zvec);
    
    %calculate 95% confidence interval
    bpoints(:,1)= rho .* cos(theta); %xval bootstrap
    bpoints(:,2)= rho .* sin(theta); %yval bootstrap
    
    X = [d0(2,7) d0(2,6) ];
    theta = pi*(90-X(:,2))/180;      %az converted to MATLAB angle
    rho = tan(pi*(90-X(:,1))/360);   %projected distance from origin
    solpoint(:,1)= rho .* cos(theta); %xval solution
    solpoint(:,2)= rho .* sin(theta); %yval solution
    
    cline = contour_dense(bpoints, solpoint, 0.95, 36);
    plot(cline(:,1),cline(:,2),'k', 'LineWidth',3,'LineStyle','--',...
        'DisplayName','95%');
    
    
    % Plot the best solution
    % Replaced d1 with d0, JW
    X = [d0(2,3) d0(2,2) ];
    theta = pi*(90-X(:,2))/180;      %az converted to MATLAB angle
    rho = tan(pi*(90-X(:,1))/360);   %projected distance from origin
    xp = rho .* cos(theta);
    yp = rho .* sin(theta);
    pl1a = plot(xp,yp,'ks'); %s
    set(pl1a,'LineWidth',2,'MarkerSize',12,'Markerfacecolor','w')
    set(gca,'NextPlot','add')
    
    X = [d0(2,5) d0(2,4) ];
    theta = pi*(90-X(:,2))/180;      %az converted to MATLAB angle
    rho = tan(pi*(90-X(:,1))/360);   %projected distance from origin
    xp = rho .* cos(theta);
    yp = rho .* sin(theta);
    pl2a = plot(xp,yp,'k^'); %^
    set(pl2a,'LineWidth',2,'MarkerSize',12,'Markerfacecolor','w')
    
    X = [d0(2,7) d0(2,6) ];
    theta = pi*(90-X(:,2))/180;      %az converted to MATLAB angle
    rho = tan(pi*(90-X(:,1))/360);   %projected distance from origin
    xp = rho .* cos(theta);
    yp = rho .* sin(theta);
    pl3a = plot(xp,yp,'ok'); %o
    set(pl3a,'LineWidth',2,'MarkerSize',12,'Markerfacecolor','w')
    set(gcf,'color','w');
    
    %doing the legend
    le = legend([pl1a pl2a pl3a],'S1','S2','S3');
    set(le,'pos',[0.1 0.8 0.15 0.1]);
    set(le,'Xcolor','w','ycolor','w','box','off');
    
    % Compute standard deviation of phi
    fStdPhi = std(d1(:,1),1,'omitnan');
    
    axes('pos',[0 0 1 1 ]);
    axis off
    text(0.01,0.22,['Variance: ' num2str(d0(1,1),2) ]);
    text(0.01,0.18,['Phi: ' num2str(d0(2,1),2) ' \pm ' num2str(fStdPhi)]);
    text(0.01,0.14,['S1: trend: ' num2str(d0(2,2),4) '; plunge: '  num2str(d0(2,3),4) ]);
    text(0.01,0.1,['S2: trend: ' num2str(d0(2,4),4) '; plunge: '  num2str(d0(2,5),4) ]);
    text(0.01,0.06,['S3: trend: ' num2str(d0(2,6),4) '; plunge: '  num2str(d0(2,7),4) ]);
    text(0.78,0.22,['Tau: ' num2str(fAvgTau,4) ' \pm ' num2str(fStdTau,4)]);
    text(0.78,0.18,['Ratio: ' num2str(fTauFit,4)]);
    text(0.78,0.14,['Beta: ' num2str(fBeta,4) ' \pm ' num2str(fStdBeta,4)]);
    
    % Determine the faulting style based on Zoback, 1992
    ste = [d0(2,3) d0(2,2)+180 d0(2,5) d0(2,4)+180 d0(2,7) d0(2,6)+180];
    
    faulting_type = faultType(ste(1),ste(3),ste(5));
    if strcmpi(faulting_type,'Thrust to Strike Slip')
        l4 = pl; %?
    end
    
    text(0.01,0.02,['Faulting style: ' faulting_type]);
    % Link to World stress map
    uicontrol('Units','normal',...
        'Position',[.4 .0 .1 .04],'String','Info ',...
        'callback',@callbackfun_001);
    
    % Plot CDF and histogram of phi-values
    figure_w_normalized_uicontrolunits('Name','Phi - ratio of relative stress magnitude','Position',[700   700   472   232])
    % CDF
    subplot(1,2,1)
    vDistribution = d1(:,1);
    % Remove NaN-values
    vSel = ~isnan(vDistribution);
    vPlotDist = vDistribution(vSel,:);
    % Plot the cumulative density function
    nLen = length(vPlotDist);
    vIndices = [1:nLen]/nLen;
    vDist = sort(vPlotDist);
    plot(vDist, vIndices,'Linewidth',1.5,'Color',[0 0 0]);
    set(gca,'NextPlot','add')
    xlabel('\phi','FontSize',12,'Fontweight','bold')
    ylabel('Fraction of cases','FontSize',12,'Fontweight','bold')
    set(gca,'Box','on','Linewidth',1.5,'Xlim',[0 1])
    plot([d0(2,1) d0(2,1)],[0 1],'Color',[0.8 0 0],'Linewidth',1.5)
    legend(' \phi CDF bootstrap','\phi org. data')
    % Histogram
    subplot(1,2,2)
    histogram(vDistribution,0:0.05:1)
    set(gca,'Xlim',[0 1]);
    xlabel('\phi','FontSize',12,'Fontweight','bold')
    ylabel('Frequency','FontSize',12,'Fontweight','bold')
    
    function callbackfun_001(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        web http://www.world-stress-map.org/;
    end
    
    function ftype = faultType(s1_east, s2_west, s3_north)
        % faultTypes determine faulting ftype from the s1_east,s2_west,s3_north plunge values
        % returns a string description
        ftype = 'Unknow';
        
        if s1_east>52                         && s3_north<35
            ftype = 'Normal';
        end
        
        if 40<s1_east  && s1_east<52               && s3_north<20
            ftype = 'Normal to Strike Slip';
        end
        
        if s1_east<40            && s2_west>45     && s3_north<20
            ftype = 'Strike Slip';
        end
        
        if s1_east<20            && s2_west>45     && s3_north<40
            ftype = 'Strike Slip';
        end
        
        if s1_east<20                         && 40<s3_north && s3_north<52
            ftype = 'Thrust to Strike Slip';
        end
        
        if s1_east<35                         && s3_north>52
            ftype = 'Thrust';
        end
    end
    
end
