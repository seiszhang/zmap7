function [declusCat, mNumDeclus] = MonteGK(mCatalog_, nSimul_)
    % Monte Carlo Simulation for Gardner&Knopoff-declustering parameters
    %
    % [fSpaceRange,fTimeRange] = CalcMonteGKWinParms();
    % fSpaceDiff = fSpaceRange(2) - fSpaceRange(1);
    % fTimeDiff = fTimeDiff(2) - fTimeDiff(1);
    
    report_this_filefun();
    mCatalog_(:,10)=zeros(size(mCatalog_,1),1);
    mNumDeclus=[];
    
    for simNum = 1:nSimul_
        %     nRand = rand(1,2);
        %     fSpace = fSpaceRange(1) + fSpaceDiff*nRand(1);
        %     fTime = fTimeRange(1) + fTimeDiff*nRand(2);
        simNum;
        [declusCat, mCatAfter, vCluster, vCl, vMainCluster] = GKDeclus(mCatalog_);
        vSel=~(vCluster(:,1) >= 1 ); %alternate version had > instead of >=
        mNumDeclus=vSel;
        %     mCatalog_(:,10)=mCatalog_(:,10)+vSel;
        
    end
