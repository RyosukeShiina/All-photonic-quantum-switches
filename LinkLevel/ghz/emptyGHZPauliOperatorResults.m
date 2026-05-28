function ghzPauliOperatorResults = emptyGHZPauliOperatorResults()

pauliTable = ghz_source_pauli_operators();
numPauliOperators = size(pauliTable, 1);

ghzPauliOperatorResults = struct();
ghzPauliOperatorResults.PauliOperators = pauliTable;
ghzPauliOperatorResults.Probs = cell(numPauliOperators, 1);
ghzPauliOperatorResults.numkGHZ = 0;

for i = 1:numPauliOperators
    ghzPauliOperatorResults.Probs{i} = [];
end

end