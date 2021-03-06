classdef SymbolManager
    % SYMBOLMANAGER allows you to control appearance of symbols on map
    properties(Constant)
        %fields = {'LineWidth','LineStyle','Color',...
        %    'Marker','MarkerSize','MarkerEdgeColor','MarkerFaceColor'};
         fields={'DisplayName';'Color';'LineStyle';'LineWidth';'Marker';'MarkerSize';'MarkerEdgeColor';'MarkerFaceColor'}
    end
    properties
        markerNames ={'+','o','*','.','x','square','diamond','^','v','<','>','pentagram','hexagram','none'};
        markerValues={'+','o','*','.','x','s',     'd',      '^','v','<','>','p',        'h',       'none'};
        
        lineValues = {'-','--',':','-.','none'};
        
        colors = {'yellow','magenta','cyan','red','lime','blue','white','black','<html><b>choose'};
        colors_rgb = {[1 1 0],[1 0 1],[0 1 1], [1 0 0], [0 1 0], [0 0 1], [1 1 1], [0 0 0]};
        
    end
    
    methods
        function obj = SymbolManager()
            
        end
        
        
        function C=fill_values(obj,h)
            
            
            switch h.Type
                case 'scatter'
                    [MECidx, MarkerEdgeColor] = Xcolor({'flat';'none'}, h.MarkerEdgeColor);
                    [MFCidx, MarkerFaceColor] = Xcolor({'auto','flat','none'}, h.MarkerFaceColor);
                    if size(h.CData,2) == 3
                        [Cidx, CColor] = Xcolor({}, h.CData(1,:));
                    else
                        CColor={'<html><i>various','<html><b>choose'};
                        Cidx=1;
                    end
                    
                    mIndex=find(strcmp(h.Marker,obj.markerNames));
                    
                    C = {... fieldname, fieldwidth, fieldtype,
                        'DisplayName',      120, {'Style', 'text','String',h.DisplayName};...
                        'CData',            130,  {'Style','PopupMenu','String',CColor,'Value',Cidx,...
                                              'Callback', @(s,~)setLineEdgeFaceColor(s,'CData')};...
                        'LineStyle',        60, {'Style','text','String',''};...
                        'LineWidth',        50,  {'Style','edit','String',num2str(h.LineWidth),...
                                              'Callback', @(src,~)set(h,'LineWidth',str2double(src.String))};...
                        'Marker',           90,  {'Style','PopupMenu','String',obj.markerNames,'Value',find(strcmp(h.Marker,obj.markerNames)),...
                                              'Callback', @(src,~)set(h,'Marker',obj.markerNames{src.Value})};...
                        'SizeData',         50,  {'Style','edit','String',num2str(mean(h.SizeData)),...
                                              'Callback', @(src,~)set(h,'SizeData',str2double(src.String))};...
                        'MarkerEdgeColor',  130,  {'Style','PopupMenu','String',MarkerEdgeColor,'Value',MECidx,...
                                              'Callback', @(s,~)setLineEdgeFaceColor(s,'MarkerEdgeColor')};...
                        'MarkerFaceColor',  130,  {'Style','PopupMenu','String',MarkerFaceColor,'Value',MFCidx,...
                                              'Callback', @(s,~)setLineEdgeFaceColor(s,'MarkerFaceColor')};...
                        };
                    
                case 'line'
                    [MECidx, MarkerEdgeColor] = Xcolor({'auto';'none'}, h.MarkerEdgeColor);
                    [MFCidx, MarkerFaceColor] = Xcolor({'auto','none'}, h.MarkerFaceColor);
                    [Cidx, CColor] = Xcolor({}, h.Color(1,:));
                    
                    mIndex=find(strcmp(h.Marker,obj.markerNames));
                    assert(~isempty(mIndex),'marker issue %s not in markerNames',h.Marker);
                    
                    
                    C = {... fieldname, fieldwidth, fieldtype, inLine, inScatter, getfun, setfun
                        'DisplayName',  120, {'Style','text','String',h.DisplayName};...
                        'Color',        130,  {'Style','PopupMenu','String',CColor,'Value',Cidx,...
                                              'Callback',@(s,~)setLineEdgeFaceColor(s,'Color')};...
                        'LineStyle',    60,  {'Style','PopupMenu','String',obj.lineValues,'Value',find(strcmp(h.LineStyle,obj.lineValues)),...
                                              'Callback',@(src,~)set(h,'LineStyle',obj.lineValues{src.Value})};...
                        'LineWidth',    50,  {'Style','edit','String',num2str(h.LineWidth),...
                                              'Callback',@(src,~)set(h,'LineWidth',str2double(src.String))};...
                        'Marker',       90,  {'Style','PopupMenu','String',obj.markerNames,'Value',mIndex,...
                                              'Callback',@(src,~)set(h,'Marker',obj.markerNames{src.Value})};...
                        'MarkerSize',   50,  {'Style','edit','String',num2str(h.MarkerSize),...
                                              'Callback',@(src,~)set(h,'MarkerSize',str2double(src.String))};...
                        'MarkerEdgeColor',130,  {'Style','PopupMenu','String',MarkerEdgeColor,'Value',MECidx,...
                                              'Callback',@(s,~)setLineEdgeFaceColor(s,'MarkerEdgeColor')};...
                        'MarkerFaceColor',130,  {'Style','PopupMenu','String',MarkerFaceColor,'Value',MFCidx,...
                                              'Callback', @(s,~)setLineEdgeFaceColor(s,'MarkerFaceColor')};...
                        };
                otherwise
                    C={};
            end
            for i=1:size(C,1)
                C{i,4} = @()h.(C{i,1}); % get function
                C{i,5} = @(val)set(h,C{i,1},val); % set function
            end
            %disp(C)
            
            function setLineEdgeFaceColor(src,fld)
                if ismember(src.String{src.Value},{'auto','none','flat'})
                    h.(fld)=src.String{src.Value};
                elseif src.Value==numel(src.String) % last option is always CHOOSE
                    try
                        newc=uisetcolor(h.(fld));
                    catch
                        newc=uisetcolor([0 0 0]);
                    end
                    h.(fld)=newc;
                    % add this "new" color to the list
                    src.String(end+1)=src.String(end);
                    nm = FancyColors.name(newc);
                    src.String(end-1)={FancyColors.colorize(nm,nm)};
                else
                    cs = src.String;
                    fancy=endsWith(cs,'</font>');
                    cs(fancy)=extractBetween(cs(fancy),'">',"</font>");
                    
                    nAdded = find(strcmp(cs,obj.colors{1})) - 1; % zero if nothing addeds
                    
                    %nAdded = find(strcmp(src.String,obj.colors{1})) - 1; % zero if nothing added
                    
                    
                    idx=src.Value - nAdded;
                    idx=idx(1);
                    newc = FancyColors.rgb(cs{src.Value});
                    %{
                    if idx>numel(obj.colors_rgb)
                        %newc = FancyColors.rgb(src.String{src.Value});
                    else
                        newc = obj.colors_rgb{idx};
                    end
                    %}
                    h.(fld)= newc;
                end
            end
                
            function [idx, displist]=Xcolor(additionalOptions, existingValue)
                % find position in list. if it doesn't exist, add it. return index.
                
                % add field-unique options to top of list
                %displist = [additionalOptions(:) ; obj.colors(:)];
                cl = obj.colors(:);
                for n=1:numel(cl)
                    if ~startsWith(cl(n),'<html>')
                        cl(n)={ FancyColors.colorize(cl{n},cl{n}) };
                    end
                end
                displist = [additionalOptions(:) ; cl];
                lookuplist = [additionalOptions(:) ; obj.colors_rgb(:)];
                
                % find existing value's position within the lookup list
                idx = find(cellfun(@(x)isequal(x,existingValue), lookuplist));
                
                % if our value isn't found, then add it to the top of the list, and set index to it.
                if isempty(idx) || idx==0
                    nm = FancyColors.name(existingValue);
                    displist(end+1)=displist(end);
                    displist(end-1)={FancyColors.colorize(nm,nm)};
                    idx=numel(displist)-1;
                end
            end
        end
        
        function test(obj, ax)
            
            % show the legend. has dual purpose. it assigns DisplayName and provides feedback for user
            wasVisible=~isempty(ax.Legend) && ax.Legend.Visible == "on";
            if ~wasVisible
                legend(ax,'show');
                ax.Legend.Visible='on';
            end
            
            f=findobj('Tag','testfigure');
            
            ch=ax.Children;
            x=20; xspace=5;
            y = 20; h=20;
            fullht = y+10;
            
            
            ts = ax.Title.String;
            if isempty(ts)
                ts=ax.Tag;
            end
                
            if isempty(f)
                f=figure('Tag','testfigure','Name',sprintf('Adjust Symbols for %s',ts));
                f.Position(3)=760;
                f.Position(4)=numel(ch)*fullht+60;
                f.MenuBar='none';
            else
                set(f,'Name',sprintf('Adjust Symbols for %s',ts));
                clf
            end
            
            xoff=x;
            for itt=numel(ch): -1 : 1
                if ~isvalid(ch(itt))
                    ch(itt)=[];
                    continue;
                end
                if (~strcmp(ch(itt).Type,'line') && ~strcmp(ch(itt).Type,'scatter'))
                    continue
                end
                C=obj.fill_values(ch(itt));
                for i=1:size(C,1)
                    w=C{i,2};
                    misc_nv = C{i,3};
                    uicontrol(gcf,'Position',[xoff,y,w,20],misc_nv{:});
                    xoff = xoff + w + xspace;
                end
                
                y=y+30; % up to next row
                if itt==1 && f.Position(3) < xoff+5
                    f.Position(3)= xoff+5;
                end
                xoff=x;
            end
            
            % label the fields
            flds = {'DisplayName';'Color';'LineStyle';'LineWidth';'Marker';'MarkerSize';'MarkerEdgeColor';'MarkerFaceColor'};
            for n=1:numel(obj.fields)
                fn=obj.fields{n};
                w = C{n,2};
                uicontrol(f,'Style','text','String',fn,'HorizontalAlignment','center',...
                    'Position',[xoff, y, w, h]);
                xoff = xoff + w + xspace;
            end
            
            % hide it again.
            if ~wasVisible
                ax.Legend.Visible='off';
            end
        end
       
    end
    methods(Static)
        function cb(src,ev,ax)
            sm=SymbolManager;
            sm.test(ax);
        end
    end
end

