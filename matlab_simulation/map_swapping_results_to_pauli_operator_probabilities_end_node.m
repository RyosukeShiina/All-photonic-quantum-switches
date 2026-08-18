function ghzPauliOperatorResults = ...
    map_swapping_results_to_pauli_operator_probabilities_end_node( ...
    XerrOuterA, ZerrOuterA, ...
    XerrOuterB, ZerrOuterB, ...
    XerrOuterB2, ZerrOuterB2, ...
    XerrOuterC, ZerrOuterC, ...
    XerrInnerAB, ZerrInnerAB, ...
    XerrInnerBC, ZerrInnerBC, ...
    XerrEndNode, ZerrEndNode)


probabilityVectors = {
    % Types 1-4: Outer A
    XerrOuterA;     % Type 1
    ZerrOuterA;     % Type 2
    XerrOuterA;     % Type 3
    ZerrOuterA;     % Type 4

    % Types 5-8: Outer B
    XerrOuterB;     % Type 5
    ZerrOuterB;     % Type 6
    XerrOuterB;     % Type 7
    ZerrOuterB;     % Type 8

    % Types 9-12: Outer B2
    XerrOuterB2;    % Type 9
    ZerrOuterB2;    % Type 10
    XerrOuterB2;    % Type 11
    ZerrOuterB2;    % Type 12

    % Types 13-16: Outer C
    XerrOuterC;     % Type 13
    ZerrOuterC;     % Type 14
    XerrOuterC;     % Type 15
    ZerrOuterC;     % Type 16

    % Types 17-20: Inner AB
    XerrInnerAB;    % Type 17
    ZerrInnerAB;    % Type 18
    XerrInnerAB;    % Type 19
    ZerrInnerAB;    % Type 20

    % Types 21-24: Inner BC
    XerrInnerBC;    % Type 21
    ZerrInnerBC;    % Type 22
    XerrInnerBC;    % Type 23
    ZerrInnerBC;    % Type 24

    % Types 25-28: End-node fusion
    XerrEndNode;    % Type 25
    ZerrEndNode;    % Type 26
    XerrEndNode;    % Type 27
    ZerrEndNode     % Type 28
};

numSources = numel(probabilityVectors);

% All probability vectors must correspond to the same number of
% matched GHZ attempts.
numkGHZ = numel(XerrOuterA);

for sourceIndex = 1:numSources

    probabilityVectors{sourceIndex} = ...
        probabilityVectors{sourceIndex}(:);

    if numel(probabilityVectors{sourceIndex}) ~= numkGHZ
        error('All end-node error-probability vectors must have the same length.');
    end

    if any(probabilityVectors{sourceIndex} < 0) || ...
            any(probabilityVectors{sourceIndex} > 1)
        error('All end-node error probabilities must lie in [0, 1].');
    end
end


% Each row gives the Pauli operator produced by the corresponding
% logical error source above.
pauliTable = [
    "I" "I" "I";   % Type 1
    "Z" "I" "I";   % Type 2
    "X" "I" "I";   % Type 3
    "I" "I" "I";   % Type 4

    "I" "I" "I";   % Type 5
    "I" "Z" "I";   % Type 6
    "X" "I" "I";   % Type 7
    "I" "I" "I";   % Type 8

    "I" "I" "I";   % Type 9
    "I" "Z" "I";   % Type 10
    "I" "X" "I";   % Type 11
    "I" "I" "I";   % Type 12

    "I" "I" "I";   % Type 13
    "I" "I" "Z";   % Type 14
    "I" "X" "I";   % Type 15
    "I" "I" "I";   % Type 16

    "X" "I" "I";   % Type 17
    "I" "I" "I";   % Type 18
    "I" "I" "I";   % Type 19
    "Z" "I" "I";   % Type 20

    "I" "X" "I";   % Type 21
    "I" "I" "I";   % Type 22
    "I" "I" "I";   % Type 23
    "I" "Z" "I";   % Type 24

    "I" "X" "I";   % Type 25
    "I" "I" "I";   % Type 26
    "I" "I" "I";   % Type 27
    "I" "Z" "I"    % Type 28
];


ghzPauliOperatorResults = struct();
ghzPauliOperatorResults.PauliOperators = pauliTable;
ghzPauliOperatorResults.Probs = probabilityVectors;
ghzPauliOperatorResults.numkGHZ = numkGHZ;

end
