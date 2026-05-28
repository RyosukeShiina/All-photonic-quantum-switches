# `bell/` folder

This folder contains the Bell-pair rate functions.

## Purpose

The Bell module computes the Bell-pair secret-key/entanglement rate after outer-leaf errors and inner-leaf errors are combined.

In the new shared-pooling model, the Bell module should **not** generate its own outer leaves. Instead, the switch-level code generates one shared outer-leaf pool and passes the Bell-assigned outer errors into `BellRate_from_outer_errors.m`.

## Main files

```text
BellRate_from_outer_errors.m   % new shared-pooling interface
BellRate_from_errors.m         % converts Bell X/Z errors into rate
BellRate_from_lists.m          % old list-based interface
BellErrors_from_lists.m        % old list-based error generator
```

## New shared-pooling path

Use this path for the new switch model:

```matlab
[rateBell, bellErr] = BellRate_from_outer_errors( ...
    allocation.Bell.xA, allocation.Bell.zA, ...
    allocation.Bell.xB, allocation.Bell.zB, ...
    params);
```

This function receives already-selected outer-leaf errors for users A and B. It then generates the Bell inner-leaf errors using:

```matlab
LBell = max(params.LA, params.LB);
```

The final Bell X/Z errors are computed using odd parity:

```matlab
Zerr = odd_parity_3(zOuterA, zInner, zOuterB);
Xerr = odd_parity_3(xOuterA, xInner, xOuterB);
```

Then `BellRate_from_errors.m` computes the rate using:

```matlab
R_SecretKey6State_total(bellErr.Zerr, bellErr.Xerr)
```

## Old list-based path

The files below are kept for backward compatibility:

```text
BellRate_from_lists.m
BellErrors_from_lists.m
```

These old functions generate their own A/B outer leaves internally, so they should not be used in the new shared-pooling policy comparison.
