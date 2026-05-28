function [xSorted, zSorted] = sort_xz_by_total_error(xErr, zErr)

% I sort the X/Z error vectors using the simple total-error metric.
% The best resource is the one with the smallest Xerr + Zerr.

xErr = xErr(:);
zErr = zErr(:);

qualityMetric = xErr + zErr;

[~, order] = sort(qualityMetric, "ascend");

xSorted = xErr(order);
zSorted = zErr(order);

end