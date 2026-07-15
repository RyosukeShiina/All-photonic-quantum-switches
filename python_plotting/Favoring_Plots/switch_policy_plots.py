#!/usr/bin/env python3
"""Create one two-panel switch-allocation plot for each requested kSW value.

Each figure compares the neutral, Bell-priority, and GHZ-priority policies.
The x-axis is the fraction of switch resources allocated to Bell connections.
"""

import argparse
from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from matplotlib.patches import Polygon


DEFAULT_POLICY_CSV = "run_switch_resource_allocation_sweep_joint_transmission.csv"
DEFAULT_NEUTRAL_CSV = "switch_resource_allocation_sweep(1).csv"


def parse_ksw_values(text):
    """Parse comma/space-separated integers, or the word 'all'."""
    cleaned = text.strip().lower()
    if cleaned == "all":
        return list(range(1, 51))
    try:
        values = [int(item) for item in cleaned.replace(",", " ").split()]
    except ValueError as exc:
        raise argparse.ArgumentTypeError(
            "Use integers separated by commas/spaces, or 'all'."
        ) from exc
    if not values:
        raise argparse.ArgumentTypeError("At least one kSW value is required.")
    return list(dict.fromkeys(values))


def sigma_from_allocation(k_bell, k_ghz):
    """Width parameter used by the original policy-violin construction."""
    total = k_bell + k_ghz
    if k_bell <= 0 or k_ghz <= 0:
        return np.nan
    return np.sqrt((total + 1) / (6 * k_bell * k_ghz))


def draw_policy_violin(
    ax, x0, y_ghz, y_neutral, y_bell, sigma, max_half_width=0.014, n_points=200
):
    """Draw a violin spanning GHZ-priority, neutral, and Bell-priority values."""
    if not np.all(np.isfinite([x0, y_ghz, y_neutral, y_bell, sigma])) or sigma <= 0:
        return

    favoring = np.linspace(-1.0, 1.0, n_points)
    y = np.where(
        favoring <= 0,
        y_ghz + (favoring + 1.0) * (y_neutral - y_ghz),
        y_neutral + favoring * (y_bell - y_neutral),
    )
    width = np.exp(-(favoring**2) / (2 * sigma**2))
    width = max_half_width * width / width.max()
    x_polygon = np.concatenate([x0 - width, (x0 + width)[::-1]])
    y_polygon = np.concatenate([y, y[::-1]])
    ax.add_patch(
        Polygon(
            np.column_stack([x_polygon, y_polygon]),
            closed=True,
            facecolor=(0.8, 0.8, 0.8),
            edgecolor="black",
            linewidth=1.0,
            alpha=0.45,
            zorder=1,
        )
    )


def validate_columns(df, required, name):
    missing = sorted(set(required) - set(df.columns))
    if missing:
        raise ValueError(f"{name} is missing columns: {', '.join(missing)}")


def prepare_data(policy_csv, neutral_csv):
    policy = pd.read_csv(policy_csv)
    neutral = pd.read_csv(neutral_csv)

    rate_columns = {"rateSum", "rateGHZ", "rateBell"}
    validate_columns(
        policy, {"kSW", "kGHZ", "kBell", "policy"} | rate_columns, "Policy CSV"
    )
    validate_columns(
        neutral, {"kTotal", "kGHZ", "kBell"} | rate_columns, "Neutral CSV"
    )

    if not (policy["kSW"] == policy["kBell"] + policy["kGHZ"]).all():
        raise ValueError("Some policy rows violate kSW = kBell + kGHZ.")

    duplicate_keys = ["kSW", "kBell", "kGHZ", "policy"]
    if policy.duplicated(duplicate_keys).any():
        raise ValueError("The policy CSV has duplicate allocation-policy rows.")

    expected_policies = {"Bell_priority", "GHZ_priority"}
    unknown = set(policy["policy"].dropna().unique()) - expected_policies
    if unknown:
        raise ValueError(f"Unrecognized policy names: {sorted(unknown)}")

    return policy, neutral


def select_ksw_data(policy, neutral, ksw):
    selected = policy[policy["kSW"] == ksw].copy()
    if selected.empty:
        raise ValueError(f"No policy data found for kSW = {ksw}.")

    # In the neutral file, kTotal is a maximum budget. Select the diagonal so
    # the actual allocation total matches the requested kSW.
    neutral_selected = neutral[
        (neutral["kBell"] + neutral["kGHZ"] == ksw)
        & (neutral["kTotal"] == ksw)
    ].copy()

    keys = ["kBell", "kGHZ"]
    rates = ["rateSum", "rateBell", "rateGHZ"]

    def rate_view(frame, suffix):
        return frame[keys + rates].rename(
            columns={column: f"{column}_{suffix}" for column in rates}
        )

    bell = selected[selected["policy"] == "Bell_priority"].copy()
    ghz = selected[selected["policy"] == "GHZ_priority"].copy()
    merged = (
        rate_view(neutral_selected, "neutral")
        .merge(rate_view(bell, "bell"), on=keys, how="inner")
        .merge(rate_view(ghz, "ghz"), on=keys, how="inner")
    )

    expected_count = ksw + 1
    if len(merged) != expected_count:
        raise ValueError(
            f"kSW = {ksw}: expected {expected_count} matched allocations, "
            f"but found {len(merged)}."
        )

    merged = merged.sort_values("kBell").reset_index(drop=True)
    merged["bellFraction"] = merged["kBell"] / ksw

    # The neutral Bell-only endpoint defines Rmax for this kSW figure.
    endpoint = merged[(merged["kBell"] == ksw) & (merged["kGHZ"] == 0)]
    if endpoint.empty or endpoint["rateSum_neutral"].iloc[0] <= 0:
        raise ValueError(f"kSW = {ksw}: neutral Bell-only Rmax is not positive.")
    r_max = endpoint["rateSum_neutral"].iloc[0]

    for suffix in ("neutral", "bell", "ghz"):
        merged[f"totalNorm_{suffix}"] = merged[f"rateSum_{suffix}"] / r_max
        total = merged[f"rateSum_{suffix}"]
        merged[f"bellRateFraction_{suffix}"] = np.where(
            total > 0, merged[f"rateBell_{suffix}"] / total, np.nan
        )

    return merged, r_max


def add_violins(ax, data, quantity):
    for row in data.itertuples(index=False):
        sigma = sigma_from_allocation(row.kBell, row.kGHZ)
        draw_policy_violin(
            ax,
            row.bellFraction,
            getattr(row, f"{quantity}_ghz"),
            getattr(row, f"{quantity}_neutral"),
            getattr(row, f"{quantity}_bell"),
            sigma,
        )


def plot_one_ksw(data, ksw, r_max, output_dir, show=False):
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(12, 5))

    panels = [
        (ax1, "totalNorm", r"$R_{\mathrm{total}}/R_{\max}$"),
        (ax2, "bellRateFraction", r"$R_{\mathrm{Bell}}/R_{\mathrm{total}}$"),
    ]
    colors = {"neutral": "tab:blue", "bell": "tab:green", "ghz": "tab:red"}
    labels = {"neutral": "neutral", "bell": "prioritize Bell", "ghz": "prioritize GHZ"}

    finite_y = []
    for _, quantity, _ in panels:
        for policy_name in ("neutral", "bell", "ghz"):
            finite_y.extend(data[f"{quantity}_{policy_name}"].dropna().tolist())
    y_min, y_max = min(finite_y), max(finite_y)
    padding = 0.04 * (y_max - y_min) if y_max > y_min else 0.05

    for ax, quantity, ylabel in panels:
        add_violins(ax, data, quantity)
        for policy_name in ("neutral", "bell", "ghz"):
            ax.scatter(
                data["bellFraction"],
                data[f"{quantity}_{policy_name}"],
                s=34 if policy_name == "neutral" else 55,
                color=colors[policy_name],
                marker="o",
                zorder=3,
                label=labels[policy_name],
            )
        ax.set_xlim(0, 1)
        ax.set_ylim(y_min - padding, y_max + padding)
        ax.grid(True)
        ax.set_axisbelow(True)
        ax.set_xlabel(r"$k_{\mathrm{Bell}}/(k_{\mathrm{Bell}}+k_{\mathrm{GHZ}})$")
        ax.set_ylabel(ylabel)
        ax.set_title(f"{ylabel}, " + rf"$k_{{\mathrm{{SW}}}}={ksw}$")

    ax1.legend(loc="best")
    fig.suptitle(rf"Switch resource allocation ($R_{{\max}}={r_max:.4g}$)")
    fig.tight_layout()

    stem = f"switch_policy_comparison_kSW_{ksw}"
    png_path = output_dir / f"{stem}.png"
    pdf_path = output_dir / f"{stem}.pdf"
    fig.savefig(png_path, dpi=300, bbox_inches="tight")
    fig.savefig(pdf_path, bbox_inches="tight")
    print(f"Saved: {png_path}")
    print(f"Saved: {pdf_path}")
    if show:
        plt.show()
    plt.close(fig)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--policy-csv", default=DEFAULT_POLICY_CSV)
    parser.add_argument("--neutral-csv", default=DEFAULT_NEUTRAL_CSV)
    parser.add_argument("--ksw", type=parse_ksw_values)
    parser.add_argument("--output-dir", default="plots")
    parser.add_argument("--show", action="store_true")
    args = parser.parse_args()

    policy, neutral = prepare_data(args.policy_csv, args.neutral_csv)
    available = sorted(policy["kSW"].unique())

    if args.ksw is None:
        answer = input(
            "Enter kSW values separated by commas (for example 10,20,50), "
            "or enter 'all' [default: 50]: "
        ).strip()
        ksw_values = parse_ksw_values(answer or "50")
    else:
        ksw_values = args.ksw

    invalid = [value for value in ksw_values if value not in available]
    if invalid:
        raise ValueError(
            f"Unavailable kSW values: {invalid}. Available range: "
            f"{available[0]} through {available[-1]}."
        )

    output_dir = Path(args.output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)
    for ksw in ksw_values:
        data, r_max = select_ksw_data(policy, neutral, ksw)
        plot_one_ksw(data, ksw, r_max, output_dir, show=args.show)


if __name__ == "__main__":
    plt.rcParams.update(
        {"font.size": 12, "axes.titlesize": 13, "axes.labelsize": 13, "mathtext.fontset": "cm"}
    )
    main()
