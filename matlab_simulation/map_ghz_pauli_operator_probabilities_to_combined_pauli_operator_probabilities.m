function combinedPauliOperatorResults = map_ghz_pauli_operator_probabilities_to_combined_pauli_operator_probabilities(ghzPauliOperatorResults)


% Maps individual GHZ Pauli-operator probabilities to the combined three-qubit Pauli-operator probability distribution.
%
% Each source Pauli operator is represented by a 6-bit mask:
%   bits 1-3: X components on qubits A, B, C
%   bits 4-6: Z components on qubits A, B, C
%
% The combined Pauli operator is obtained by XOR-combining these masks.
% For example, X and Z acting on the same qubit combine into Y.


persistent pauliTable sourceMasks pauliOperatorLabels numSourceOperators


if isempty(pauliTable)
    pauliTable = sourcePaulis();
    [numSourceOperators, numQubits] = size(pauliTable);

    if numQubits ~= 3
        error('sourcePaulis must return a Pauli table with 3 columns.');
    end

    sourceMasks = zeros(numSourceOperators, 1, 'uint8');

    for sourceIndex = 1:numSourceOperators
        xMask = zeros(1, 3);
        zMask = zeros(1, 3);
        for qubitIndex = 1:3
            pauliOperator = upper(string(pauliTable(sourceIndex, qubitIndex)));
            switch pauliOperator
                case "I"
                    xMask(qubitIndex) = 0;
                    zMask(qubitIndex) = 0;
                case "X"
                    xMask(qubitIndex) = 1;
                    zMask(qubitIndex) = 0;
                case "Z"
                    xMask(qubitIndex) = 0;
                    zMask(qubitIndex) = 1;
                otherwise
                    error('Unsupported source Pauli operator: %s', pauliOperator);
            end
        end
        sourceMasks(sourceIndex) = uint8(xMask(1)*1 + xMask(2)*2 + xMask(3)*4 + zMask(1)*8 + zMask(2)*16 + zMask(3)*32);
    end

    pauliOperatorLabels = strings(64, 1);

    for operatorIndex = 0:63
        label = "";
        for qubitIndex = 1:3
            hasX = bitget(operatorIndex, qubitIndex);
            hasZ = bitget(operatorIndex, qubitIndex + 3);
            if hasX == 0 && hasZ == 0
                pauliChar = "I";
            elseif hasX == 1 && hasZ == 0
                pauliChar = "X";
            elseif hasX == 0 && hasZ == 1
                pauliChar = "Z";
            else
                pauliChar = "Y";
            end
            label = label + pauliChar;
        end
        pauliOperatorLabels(operatorIndex + 1) = label;
    end

end

sourceProbs = ghzPauliOperatorResults.Probs(:);

if length(sourceProbs) ~= numSourceOperators
    error('Expected %d source probabilities, but received %d.', numSourceOperators, length(sourceProbs));
end

combinedProbs = zeros(64, 1);
combinedProbs(1) = 1.0;  % Initial distribution: P(III) = 1.


for sourceIndex = 1:numSourceOperators
    sourceProb = sourceProbs{sourceIndex};
    sourceMask = sourceMasks(sourceIndex);

    updatedCombinedProbs = zeros(64, 1);
    for operatorIndex = 0:63
        currentProb = combinedProbs(operatorIndex + 1);

        if currentProb == 0
            continue;
        end

        % Case 1: this source Pauli operator does not occur.
        updatedCombinedProbs(operatorIndex + 1) = updatedCombinedProbs(operatorIndex + 1) + (1 - sourceProb) * currentProb;

        % Case 2: this source Pauli operator occurs.
        newOperatorIndex = bitxor(uint8(operatorIndex), sourceMask);

        updatedCombinedProbs(double(newOperatorIndex) + 1) = updatedCombinedProbs(double(newOperatorIndex) + 1) + sourceProb * currentProb;
    end

    combinedProbs = updatedCombinedProbs;
end

combinedPauliOperatorResults = struct();
combinedPauliOperatorResults.PauliOperators = pauliOperatorLabels;
combinedPauliOperatorResults.Probs = combinedProbs;

end
