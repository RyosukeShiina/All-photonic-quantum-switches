# `ghz/` folder

This folder contains the GHZ-state rate functions.

## Purpose

The GHZ module maps assigned outer-leaf and inner-leaf error probabilities into a 24-source Pauli-error model, combines those into a three-qubit Pauli distribution, converts that distribution into GHZ-basis error quantities, and evaluates the GHZ secret-key rate.

## Main files

```text
GHZRate_from_outer_errors.m                         % new shared-pooling interface
map_outer_errors_to_ghz_pauli_probabilities.m       % new shared-pooling mapper
GHZRate_from_pauli_probabilities.m                  % computes GHZ rate from Pauli probabilities
emptyGHZPauliOperatorResults.m                      % empty GHZ result structure
GHZRate_from_lists.m                                % old list-based interface
map_swapping_results_to_pauli_operator_probabilities_from_lists.m
```

## New shared-pooling path

Use this path for the new switch model:

```matlab
[rateGHZ, ghzPauliOperatorProbabilities] = GHZRate_from_outer_errors( ...
    allocation.GHZ.xA, allocation.GHZ.zA, ...
    allocation.GHZ.xB, allocation.GHZ.zB, ...
    allocation.GHZ.xC, allocation.GHZ.zC, ...
    params);
```

The outer-leaf errors are generated once by the switch-level code and assigned to GHZ according to the selected policy.

The GHZ inner leaves use the longest user distance:

```matlab
LGHZ = max([params.LA, params.LB, params.LC]);
```

## GHZ rate pipeline

The rate pipeline is:

```text
assigned outer errors
+ GHZ inner errors
→ 24-source GHZ Pauli probability structure
→ combined 64-entry three-qubit Pauli distribution
→ GHZ-basis lambdas and Q values
→ secret-key rate
```

The final rate is the sum of the per-GHZ-mode rates.

## Old list-based path

The files below are kept for backward compatibility:

```text
GHZRate_from_lists.m
map_swapping_results_to_pauli_operator_probabilities_from_lists.m
```

These old functions generate their own outer leaves internally, so they should not be used for the new shared-pooling policy comparison.
