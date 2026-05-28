# `shared/` folder

This folder contains helper functions used by both Bell and GHZ simulations.

## Main files

```text
make_shared_outer_pools.m
split_shared_outer_pools_by_policy.m
sort_xz_by_total_error.m
odd_parity_3.m
allocation_vectors_from_lists.m
```

## `make_shared_outer_pools.m`

Creates one shared sorted outer-leaf resource pool for users A, B, and C.

For actual mode counts `kBell` and `kGHZ`, the per-user resource counts are:

```matlab
kA = kBell + kGHZ;
kB = kBell + kGHZ;
kC = kGHZ;
```

The function calls `outer_leaves_swapping_and_construction` once per user and sorts each user's resources from best to worst.

## `split_shared_outer_pools_by_policy.m`

Splits the sorted outer-leaf pool according to the switch policy.

### `favor_Bell`

```text
Bell receives the best A/B resources.
GHZ receives the remaining A/B resources and all C resources.
```

### `favor_GHZ`

```text
GHZ receives the best A/B/C resources.
Bell receives the remaining A/B resources.
```

## `sort_xz_by_total_error.m`

Sorts resources according to:

```matlab
qualityMetric = xErr + zErr;
```

Smaller total error means better resource quality.

## `odd_parity_3.m`

Computes the probability of an odd number of errors among three independent error events. This is used to combine outer-inner-outer errors in the Bell connection.

## `allocation_vectors_from_lists.m`

Legacy helper for visualizing or recording which indices are assigned to Bell or GHZ. It is not essential for the new six-point shared-pooling test.
