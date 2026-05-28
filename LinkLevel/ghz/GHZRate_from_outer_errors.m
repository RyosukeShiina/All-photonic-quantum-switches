function [rateGHZ, ghzPauliOperatorProbabilities] = GHZRate_from_outer_errors( ...
    xOuterA, zOuterA, xOuterB, zOuterB, xOuterC, zOuterC, params)

% I compute the GHZ rate from already-generated outer-leaf errors.
%
% This function is for the shared-pooling switch model.
% The outer leaves are not generated here.
% They are generated once at the switch level, sorted once, and then passed
% into this function after the pooling policy assigns them to GHZ.

ghzPauliOperatorProbabilities = ...
    map_outer_errors_to_ghz_pauli_probabilities( ...
        xOuterA, zOuterA, ...
        xOuterB, zOuterB, ...
        xOuterC, zOuterC, ...
        params);

rateGHZ = GHZRate_from_pauli_probabilities(ghzPauliOperatorProbabilities);

end