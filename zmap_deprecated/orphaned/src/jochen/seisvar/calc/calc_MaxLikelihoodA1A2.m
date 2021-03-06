function [fA1Value, fA2Value] = calc_MaxLikelihoodA1A2(mCatalog, mControl, fBValue, bReBin)
% function [fAValue] = calc_MaxLikelihoodA(mCatalog, mControl, fBValue, bReBin)
% -----------------------------------------------------------------------------
% Computes the maximum likelihood a-values for a set of given catalogs
%   and a fixed b-value
%
% Input parameters:
%   mCatalog        Catalog containing different periods with varying
%                   magnitude of completeness
%   mControl        Controlmatrix containing informations about the single catalogs
%                   mControl(n,:) contains information about caCatalogs{n}
%                   Column 1: Starting time of catalog
%                   Column 2: Magnitude of completeness
%                   Column 3: Starting magnitude bin
%                   Column 4: Magnitude bin stepsize (must be 0.1)
%   fBValue         Fixed b-value
%   bReBin          Rebin the catalogs to the given binning in mControl
%                   (must be 0)
%
% Output parameters:
%   fAValue         Maximum likelihooda-value
%
% Danijel Schorlemmer
% July 5, 2002

% Get the number of different periods in the catalog
[nRow_, nColumn_] = size(mControl);
% Init vector with ending times for each period
vMaxTime_ = zeros(nRow_, 1);
% Loop over the control matrix
for nCnt_ = 1:nRow_
  % Determine starting time of period
  fMinTime_ = mControl(nCnt_, 1);
  % Determine ending time of period
  if nCnt_ < nRow_
    vMaxTime_(nCnt_) = mControl(nCnt_+1, 1);
  else
    vMaxTime_(nCnt_) = max(mCatalog(:,3));
  end
  % Create subcatalog for period
  vSel_ = (mCatalog(:,3) >= fMinTime_) & (mCatalog(:,3) < vMaxTime_(nCnt_));
  mTmpCatalog_ = mCatalog(vSel_,:);
  % Rebin the catalog (should not be used)
  if bReBin
    fMaxMag_ = max(mTmpCatalog_(:,6));
    for nBin_ = mControl(nCnt_,3):mControl(nCnt_,4):(fMaxMag_ + mControl(nCnt_,4))
      vSel_ = (mTmpCatalog_(:,6) >= (nBin_ - (mControl(nCnt_,4)/2))) & (mTmpCatalog_(:,6) < (nBin_ + (mControl(nCnt_,4)/2)));
      mTmpCatalog_(vSel_,6) = nBin_;
    end
  end
  % Cut the subcatalog at magnitude of completeness
  vSel_ = mTmpCatalog_(:,6) >= mControl(nCnt_,2);
  mTmpCatalog_ = mTmpCatalog_(vSel_,:);
  % Store the subcatalog
  caCatalogs_{nCnt_} = mTmpCatalog_;
end
% Add the ending times to the control matrix
mControl = [mControl vMaxTime_];
% Set the callback starting values
vStartValue = [1; 1];
% Find the maximum likelihood solution
[fAValues, vDummy, bExitFlag_] = fminsearch('callback_LogLikelihoodA1A2Value', vStartValue, [], caCatalogs_, mControl, fBValue);
fA1Value = fAValues(1);
fA2Value = fAValues(2);
