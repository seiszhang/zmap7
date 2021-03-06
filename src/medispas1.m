function medispas1(sta, xt2) 
    % medispas1 calculates A as(t) fora given mean depth curve and displayed in the plot.
    %  Overlapping mean depth windows are avoided
    %  Operates on catalogue ZG.newcat                          A.Allmann
    % turned into function by Celso G Reyes 2017
    
    ZG=ZmapGlobal.Data; % used by get_zmap_globals
    
    report_this_filefun();
    
    %
    % calculate mean and z value
    %
    ncu = length(xt2);    %number of all mean depth windows
    af = iwln/step;     %to avoid resampling because of overlapping windows
    m = 0;            %counter of independent mean depth windows without winlen_days
    as = [];
    magsteps_desc = [];
    
    % calculation of the as values and attached times
    %
    if sta == 'ast'
        for i = 1+winlen_days*af:af:ind-winlen_days*af
            mean1 = mean(meand(1:af:i));
            mean2 = mean(meand(i:af:ncu));
            var1 = cov(meand(1:af:i));
            var2 = cov(meand(i:af:ncu));
            m = m+1;
            as(m) = (mean1 - mean2)/sqrt(var1/(1+fix(i*(step/iwln)))+...
                var2/fix((ncu-i)*(step/iwln)));
            magsteps_desc(m) = xt2(i);
        end     % for i
    end     % if sta
    
    if sta == 'lta'
        for i = 1+winlen_days*af:af:ind-winlen_days*af
            mean1 = mean(meand(1:af:ncu));
            mean2 = mean(meand(i:af:i+winlen_days));
            var1 = cov(meand(1:af:ncu));
            var2 = cov(meand(i:af:i+winlen_days));
            m = m+1;
            as(m) = (mean1 - mean2)/sqrt(var1/length(meand(1:af:ncu)) +...
                var2/length(i:af:i+iwln));
            magsteps_desc(m) = xt2(i);
        end     % for i
    end % if sta == lta
    
    
    %
    %  Plot the as(t)
    %
    
    try
        delete(p5)
        delete(ax1)
    catch ME
        error_handler(ME, @do_nothing);
    end
    figure
    orient tall
    rect = [0.15, 0.10, 0.65, 0.30];
    axes('position',rect)
    p5 = gca;
    
    plot(magsteps_desc,as,'r')
    
    
    
    xlabel('Time  [years]')
    ylabel('Mean Depth (km)')
    
    stri = ['Mean depth and z-value of ' file1];
    title(stri)
    grid
    
end
