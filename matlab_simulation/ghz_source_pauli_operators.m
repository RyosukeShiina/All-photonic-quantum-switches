function pauliTable = ghz_source_pauli_operators()

% Returns the 24 source Pauli operators used to build the GHZ Pauli-operator probability distribution.
%
% Output:
%   pauliTable
%       A 24-by-3 string array. Each row specifies a three-qubit Pauli
%       operator acting on qubits A, B, and C.
%
%       The row ordering must match the ordering of the probability entries
%       assigned in map_swapping_results_to_ghz_pauli_operator_probabilities.

pauliTable = [
    "I" "I" "I";  % Type 1
    "Z" "I" "I";
    "X" "I" "I";
    "I" "I" "I";

    "I" "I" "I";  % Type 5
    "I" "Z" "I";
    "I" "X" "I";
    "I" "I" "I";

    "I" "I" "I";
    "I" "I" "Z";  % Type 10
    "I" "I" "X";
    "I" "I" "I";

    "X" "I" "I";
    "I" "I" "I";
    "I" "I" "I";  % Type 15
    "Z" "I" "I";

    "I" "X" "I";
    "I" "I" "I";
    "I" "I" "I";
    "I" "Z" "I";  % Type 20

    "I" "I" "X";
    "I" "I" "I";
    "I" "I" "I";
    "I" "I" "Z";  % Type 24
];

end
