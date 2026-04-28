function [pauli1, pauli2, pauli3] = get_three_qubit_pauli_labels(patternLabels, patternIndex)

% get_three_qubit_pauli_labels
%
%   Extracts the three single-qubit Pauli labels from patternLabels.
%
%   Accepted formats:
%       64x3 string array:
%           ["I", "X", "Z"]
%
%       64x1 string array:
%           "IXZ"

if ismatrix(patternLabels) && size(patternLabels, 2) == 3
    % Format: 64x3 string array, e.g., ["I", "X", "Z"].
    pauli1 = string(patternLabels(patternIndex, 1));
    pauli2 = string(patternLabels(patternIndex, 2));
    pauli3 = string(patternLabels(patternIndex, 3));

else
    % Format: 64x1 string array, e.g., "IXZ".
    concatenatedLabel = char(patternLabels(patternIndex));

    if numel(concatenatedLabel) ~= 3
        error('Each concatenated Pauli label must have length 3. Invalid label at row %d.', patternIndex);
    end

    pauli1 = string(concatenatedLabel(1));
    pauli2 = string(concatenatedLabel(2));
    pauli3 = string(concatenatedLabel(3));
end

validPaulis = ["I", "X", "Y", "Z"];

if ~ismember(pauli1, validPaulis) || ~ismember(pauli2, validPaulis) || ~ismember(pauli3, validPaulis)
    error('Invalid Pauli label at row %d. Allowed labels are I, X, Y, and Z.', patternIndex);
end

end
