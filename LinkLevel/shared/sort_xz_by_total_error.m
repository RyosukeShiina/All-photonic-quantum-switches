function [xSorted, zSorted] = sort_xz_by_total_error(xErr, zErr)

% Sort the X/Z error-probability vectors using the same ranking rule used in
% UW3_OuterLeaves: the per-channel six-state secret-key/entanglement rate.
%
% The best resource is the one with the largest secret-key rate, not
% necessarily the one with the smallest Xerr + Zerr.

xErr = xErr(:);
zErr = zErr(:);

if numel(xErr) ~= numel(zErr)
    error("xErr and zErr must have the same number of elements.");
end

if any(~isfinite(xErr)) || any(~isfinite(zErr))
    error("xErr and zErr must contain only finite values.");
end

if any(xErr < 0 | xErr > 1) || any(zErr < 0 | zErr > 1)
    error("xErr and zErr must be probabilities in the interval [0, 1].");
end

numResources = numel(xErr);
secretKeyRanking = zeros(numResources, 1);

for i = 1:numResources
    % R_SecretKey6State_per expects inputs as:
    %   R_SecretKey6State_per(QerrZ, QerrX)
    secretKeyRanking(i) = R_SecretKey6State_per(zErr(i), xErr(i));
end

% Same direction as UW3_OuterLeaves: best resource first.
[~, order] = sort(secretKeyRanking, "descend");

xSorted = xErr(order);
zSorted = zErr(order);

end
