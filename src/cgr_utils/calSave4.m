
function calSave4(~, ~, catalog, faults, mainfault, coastline, main, infstri)
    % save fault information, I think. called from ZmapInBox/src/setup.m
    % infstri is user-entered information about hte current dataset
    
    %msg.infodisp('  ','Save Data');
    
    [file1,path1] = uiputfile(fullfile(ZmapGlobal.Data.Directories.data, '*.mat'), 'Filename?');
    save([path1, file21], 'catalog', 'faults', 'mainfault', 'coastline', 'main', 'infstri');
    close(loda);
    zmap_update_displays();
    
end