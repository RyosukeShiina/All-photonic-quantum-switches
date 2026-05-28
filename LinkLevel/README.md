# Switch Resource Simulation

This folder contains the shared-pooling switch simulation for comparing Bell-pair and GHZ-state resource allocation.

## Main idea

The new simulation treats Bell and GHZ connections as competing for one shared pool of outer-leaf resources. For fixed raw budgets `kBell` and `kGHZ`, the code converts them into actual mode counts:

```matlab
kBellModes = floor(kBell / 2);
kGHZModes  = floor(kGHZ  / 3);
```

Then the per-user resource counts are:

```matlab
kA = kBellModes + kGHZModes;
kB = kBellModes + kGHZModes;
kC = kGHZModes;
```

The switch creates one sorted outer-leaf pool for users A, B, and C, then allocates resources according to one of two policies:

- `favor_Bell`: Bell receives the best A/B outer-leaf resources first.
- `favor_GHZ`: GHZ receives the best A/B/C outer-leaf resources first.

Bell and GHZ rates are then computed from the assigned outer-leaf resources plus service-specific inner-leaf resources.

## Required folders

```text
switch_resource_simulation/
├── bell/
├── ghz/
├── shared/
├── existing_physics_functions/
└── pooling_policy_results/
```

The `pooling_policy_results/` folder is created automatically by the main scripts if it does not already exist.

## Main scripts

Typical scripts in the main folder are:

```text
main_six_point_pooling_policy_test.m
```

### `main_six_point_pooling_policy_test.m`

Runs a small six-point test for `kTotal = 40`. This is useful before launching a long sweep on the server.

## Path setup

Each main script should include:

```matlab
addpath("shared");
addpath("bell");
addpath("ghz");
addpath("existing_physics_functions");
```

## Output files

Simulation results are saved in:

```text
pooling_policy_results/
```

Typical output files are:

```text
six_point_kTotal_40_favor_Bell_N_1000.csv
six_point_kTotal_40_favor_GHZ_N_1000.csv
six_point_kTotal_40_both_policies_N_1000.mat
```

## Notes

The old grouping/optimization code is not required for the shared-pooling test. The new model assumes that `kBell` and `kGHZ` are given by the switch-level controller or swept externally.
