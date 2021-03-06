function [mResult] = calc_Bwtime(mCatalog, nSampleSize, nOverlap, nMethod, nBstSample, nMinNumberevents, fBinning)
% [mResult] = calc_Bwtime(mCatalog, nSampleSize, nOverlap, nMethod, nBstSample, nMinNumberevents, fBinning)
% ------------------------------------------------------------------------------------------------
% Calculate b-value with time
% Calculate Mc by boostrapping and use mean Mc
%
% Incoming variables:
% mCatalog    : Earthquake catalog
% nSampleSize : Number of events to calculate single b-value
% nOverlap    : Samplesize/nOverlap determines overlap of moving windows
% nMethod     : Method to determine Mc
% nBstSample  : Number of bootstraps to determine Mc
% nMinNumberevents : Minimum number of events
% fBinning    : Binning interval
%
% Outgoing variables:
% mResult(:,1) : Mean time of sample
% mResult(:,2) : fMc with time (mean Mc)
% mResult(:,3) : Standard deviation of mean Mc from the bootstrap
% mResult(:,4) : b-value (mean b)
% mResult(:,5) : Standard deviation of mean b-value from the bootstrap
% mResult(:,6) :a-value (mean b)
% mResult(:,7) : Standard deviation of meana-value from the bootstrap
%
% Author: J. Woessner
% last update: 25.06.03

% Check input
if nargin == 0, error('No catalog input'); end
if nargin == 1, nSampleSize=150, nOverlap=10, nMethod=1, nBstSample=100, nMinNumberevents=50; fBinning = 0.1;
    disp('Default Sample size: 150, Overlap: 10, Mc-Method=1, Bootstraps for Mc=100, Bin size: 0.1, Minimum number of events: 50');end
if nargin == 2, nOverlap=10, nMethod=1, nBstSample=100, nMinNumberevents=50; fBinning = 0.1;
    disp('Default Overlap: 10, Mc-Method=1, Bootstraps for Mc=100, Bin size: 0.1, Minimum number of events: 50');end
if nargin == 3, nMethod=1, nBstSample=100, nMinNumberevents=50; fBinning = 0.1;
    disp('Default Mc-Method=1, Bootstraps for Mc=100, Bin size: 0.1, Minimum number of events: 50');end
if nargin == 4, nBstSample=100, nMinNumberevents=50; fBinning = 0.1;
    disp('Default Bootstraps for Mc=100, Bin size: 0.1, Minimum number of events: 50');end
if nargin == 5, nMinNumberevents=50; fBinning = 0.1;
    disp('Default Bin size: 0.1, Minimum number of events: 50');end
if nargin == 6, fBinning = 0.1; disp('Default Minimum number of events: 50');end
if nargin > 7, error('Too many arguments!'); end


% Initialze
mResult = [];

% Set fix values
fMinMag = min(mCatalog(:,6));
fMaxMag = max(mCatalog(:,6));

for nSamp = 1:nSampleSize/nOverlap:length(mCatalog(:,1))-nSampleSize
    % Select samples
    mCat = mCatalog(nSamp:nSamp+nSampleSize,:);
    % Mean time of selected events
    fTime = mean(mCat(:,3));
    [fMc, fStd_Mc, fBvalue, fStd_B, fAvalue, fStd_A, vMc, mBvalue] = calc_McBboot(mCat, fBinning, nBstSample, nMethod);
    mResult = [mResult; fTime fMc fStd_Mc fBvalue fStd_B fAvalue fStd_A];
end % END of FOR fMag
