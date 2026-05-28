# `existing_physics_functions/` folder

This folder contains the lower-level physical simulation and rate-evaluation functions.

## Purpose

These functions implement the physical error models for outer leaves, inner leaves, GKP/Steane error correction, Bell-pair rate evaluation, and GHZ Pauli-error mapping.

The shared-pooling code treats these functions as the physics backend.

## Main outer/inner leaf functions

```text
outer_leaves_swapping_and_construction.m
inner_leaves_swapping_and_construction.m
UW3_OuterLeaves.m
UW3_InnerLeaves.m
UW3_AddInitialLogErrors.m
```

### `outer_leaves_swapping_and_construction.m`

Computes the X/Z error probabilities for outer leaves after elementary Bell-pair construction and outer-leaves swapping.

This function returns vectors of length `k`.

### `inner_leaves_swapping_and_construction.m`

Computes the X/Z error probabilities for inner leaves. The result is copied into vectors of length `k`, because inner leaves are treated as identical within a connection.

The distance `L0` controls memory waiting noise. In the shared-pooling model:

```matlab
LBell = max(LA, LB);
LGHZ  = max([LA, LB, LC]);
```

## Error-correction helpers

```text
R_ConcatenatedEC_OuterLeaves.m
R_ConcatenatedEC_InnerLeaves.m
R_SyndromeToErrors.m
R_ErrorLikelihood.m
R_JointErrorLikelihood.m
R_ReminderMod.m
R_Find_v.m
R_LogErrAfterPost.m
```

These functions implement the GKP/Steane decoding and post-selection error model.

## Bell-rate functions

```text
R_SecretKey6State_total.m
R_SecretKey6State_per.m
R_ShannonEnt.m
```

These functions evaluate the Bell-pair secret-key/entanglement rate from X/Z error probabilities.

## GHZ-rate and Pauli-mapping functions

```text
ghz_source_pauli_operators.m
map_pauli_operator_probs_to_combined_pauli_operator_probs.m
map_combined_pauli_operator_probs_to_ghz_basis_lambdas_and_Qs.m
map_three_qubit_pauli_to_ghz_basis_index.m
get_three_qubit_pauli_labels.m
map_Qs_to_secret_key_rate.m
binary_entropy.m
p_log2_p.m
p_times_one_minus_log2_p.m
```

These functions map the 24-source GHZ Pauli-error model into a combined three-qubit Pauli distribution, then into GHZ-basis error quantities and a final GHZ secret-key rate.

## Notes

Do not edit these functions unless you are intentionally changing the physical model. Most switch-policy changes should happen in the `shared/`, `bell/`, and `ghz/` folders.
