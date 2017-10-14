function catsave3(version)
    % save catalog and associated items, collated from various methods

    %TODO detangle this
    warning('not saving');
    switch version
        
        case 'bcross'
            savestuff =[ 'ZmapMessageCenter.set_info(''Save Grid'',''  '');',...
                '[file1,path1] = uiputfile([ ''*.mat''], ''Grid Datafile Name?'') ;',...
                'sapa2=[''save '' path1 file1 '' ll a newgri lat1 lon1 lat2 lon2 ZG.xsec_width_km  bvg xvect yvect gx gy dx dd ZG.bin_dur newa maex maey maix maiy ''];',...
                ' if length(file1) > 1, eval(sapa2),end , '];
            
        case 'bcrossV2'
            savestuff = [ 'ZmapMessageCenter.set_info(''Save Grid'',''  '');',...
                '[file1,path1] = uiputfile(fullfile(ZmapGlobal.Data.data_dir, ''*.mat''), ''Grid Datafile Name?'') ;',...
                ' sapa2 = [''save '' path1 file1 '' ll a tmpgri newgri lat1 lon1 lat2 lon2 ZG.xsec_width_km  bvg xvect yvect gx gy dx dd ZG.bin_dur newa maex maey maix maiy ''];',...
                ' if length(file1) > 1, eval(sapa2),end , '];
            
        case 'bcrossVt2'
            savestuff =[ 'ZmapMessageCenter.set_info(''Save Grid'',''  '');',...
                '[file1,path1] = uiputfile(fullfile(ZmapGlobal.Data.data_dir, ''*.mat''), ''Grid Datafile Name?'') ;',...
                ' sapa2 = [''save '' path1 file1 '' ll tmpgri bvg xvect yvect gx gy ni dx dd ZG.bin_dur ni newa maex maey maix maiy ''];',...
                ' if length(file1) > 1, eval(sapa2),end , '];
            
        case 'bdepth_ratio'
            savestuff=[ 'ZmapMessageCenter.set_info(''Save Grid'',''  '');',...
                ' sapa2 = [''save '' path1 file1 '' bvg gx gy dx dy ZG.bin_dur tdiff t0b teb a main faults mainfault coastline yvect xvect tmpgri ll depth_ratio top_zonet top_zoneb bot_zoneb bot_zonet ni_plot''];',...
                ' if length(file1) > 1, eval(sapa2),end , '];
        case 'bgrid3dB'
            savestuff=[ 'ZmapMessageCenter.set_info(''Save Grid'',''  '');',...
                '[file1,path1] = uiputfile(fullfile(ZmapGlobal.Data.data_dir, ''*.mat''), ''Grid Datafile Name?'') ;',...
                ' sapa2 = [''save '' path1 file1 '' zvg teb ram go avm mcma gx gy gz dx dy dz ZG.bin_dur bvg tdiff t0b teb a main faults mainfault coastline yvect xvect tmpgri well ll ni''];',...
                ' if length(file1) > 1, eval(sapa2),end , '];
            
        case 'bvalgrid'
            savestuff=[ 'ZmapMessageCenter.set_info(''Save Grid'',''  '');',...
                '[file1,path1] = uiputfile(fullfile(ZmapGlobal.Data.data_dir, ''*.mat''), ''Grid Datafile Name?'') ;wholePath=[path1 file1]; ',...
                ' sapa2 = [''save('' ''wholePath'' '', ''''bvg'''',''''gx'''', ''''gy'''', ''''dx'''', ''''dy'''', ''''ZG.bin_dur'''', ''''tdiff'''', ''''t0b'''', ''''teb'''', ''''a'''', ''''main'''', ''''faults'''', ''''mainfault'''', ''''coastline'''', ''''yvect'''', ''''xvect'''', ''''newgri'''', ''''ll'''')''];',...
                ' if length(file1) > 1, eval(sapa2);end , '];
            
        case 'bvalmaptd'
            savestuff=[ 'ZmapMessageCenter.set_info(''Save Grid'',''  '');',...
                '[file1,path1] = uiputfile(fullfile(ZmapGlobal.Data.data_dir, ''*.mat''), ''Grid Datafile Name?'') ;',...
                ' sapa2 = [''save '' path1 file1 '' bvg gx gy dx dy ZG.bin_dur tdiff t0b teb a main faults mainfault coastline yvect xvect tmpgri ll''];',...
                ' if length(file1) > 1, eval(sapa2),end , '];
            
        case 'calc_across'
            savestuff=[ 'ZmapMessageCenter.set_info(''Save Grid'',''  '');',...
                '[file1,path1] = uiputfile([ ''*.mat''], ''Grid Datafile Name?'') ;',...
                'sapa2=[''save '' path1 file1 '' ll a tmpgri newgri lat1 lon1 lat2 lon2 ZG.xsec_width_km  avg xvect yvect gx gy dx dd ZG.bin_dur newa maex maey maix maiy ''];',...
                ' if length(file1) > 1, eval(sapa2),end , '];
            
        case 'calc_Omoricross'
            savestuff=[ 'ZmapMessageCenter.set_info(''Save Grid'',''  '');',...
                '[file1,path1] = uiputfile(fullfile(hodi, ''eq_data'', ''*.mat''), ''Grid Datafile Name?'') ;',...
                ' sapa2 = [''save '' path1 file1 '' mCross gx gy dx dy ZG.bin_dur tdiff t0b teb newa a main faults mainfault coastline yvect xvect tmpgri ll ZG.bo1 newgri ra time timef bootloops ZG.maepi xsecx xsecy ZG.xsec_width_km lon1 lat1 lon2 lat2 ''];',...
                ' if length(file1) > 1, eval(sapa2),end , '];
            
        case 'Dcross'
            savestuff=[ 'ZmapMessageCenter.set_info(''Save Grid'',''  '');',...
                '[file1,path1] = uiputfile(fullfile(ZmapGlobal.Data.data_dir, ''*.mat''), ''Grid Datafile Name?'') ;',...
                'sapa2=[''save '' path1 file1 '' ll a tmpgri newgri lat1 lon1 lat2 lon2 ZG.xsec_width_km  bvg xvect yvect gx gy dx dd ZG.bin_dur newa maex maey maix maiy''];',...
                ' if length(file1) > 1, eval(sapa2),end , '];
            
        case 'magrcros'
            savestuff=[ 'ZmapMessageCenter.set_info(''Save Grid'',''  '');',...
                '[file1,path1] = uiputfile(fullfile(ZmapGlobal.Data.data_dir, ''*.mat''), ''Grid Datafile Name?'');',...
                ' sapa2 = [''save '' path1 file1 '' cumuall pos gx gy ni dx dy ZG.bin_dur newa maex maix maey maiy tmpgri ll newgri xvect yvect ''];',...
                ' if length(file1) > 1, eval(sapa2),end , '];
        case 'makegrid'
            savestuff=[ 'ZmapMessageCenter.set_info(''Save Grid'',''  '');',...
                ' [file1,path1] = uiputfile(fullfile(ZmapGlobal.Data.data_dir, ''*.mat''), ''Grid Datafile'',400,400);',...
                ' sapa2 = [''save '' path1 file1 '' x y tmpgri newgri xvect yvect ll cumuall ZG.bin_dur ni dx dy gx gy tdiff t0b teb loc a main faults mainfault coastline''];',...
                ' if length(file1) > 1, eval(sapa2),end , '];
            
        otherwise
            savestuff='';
    end
    eval(savestuff);
end