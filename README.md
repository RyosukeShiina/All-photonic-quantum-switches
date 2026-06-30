# Code for "All-photonic quantum repeaters with 9 km spacing"  
Author: Ryosuke Shiina
Affiliation: University of Massachusetts Amherst
Contact: rshiina@umass.edu

Author: Mohadeseh Azari
Affiliation: University of Massachusetts Amherst
Contact: rshiina@umass.edu

# Description
This repository contains the MATLAB and Python code used to generate the results in our paper.

# For QCNC paper readers
This repository already contains simulation outputs used in the QCNC figures.
To reproduce QCNC figures from the provided data:
1. Go to `python_plotting/`
2. Open and run the following notebooks:
   - QCNC Fig. 3: `QCNC_camera-ready_FIG3_Rate_vs_Distance.ipynb`
   - QCNC Fig. 4: `QCNC_camera-ready_FIG4_Rate_vs_k.ipynb`
   - QCNC Fig. 5: `QCNC_camera-ready_FIG5_NoGKP_vs_Distance.ipynb`
   - QCNC Fig. 6: `QCNC_camera-ready_FIG6_Cost_vs_k.ipynb`
   - QCNC Fig. 7: `QCNC_camera-ready_FIG7_Rate_vs_Distance.ipynb`
   - QCNC Fig. 8: `QCNC_camera-ready_FIG8_etam_vs_Lcavity.ipynb`

The notebooks load data from `python_plotting/fig_data/`.

# Folder Structure and Call Hierarchy

```text
project-root/
├── matlab_simulation/
│   ├── run_switch_resource_allocation_sweep.m
│   │   ├── GHZRate.m
│   │   │   ├── map_swapping_results_to_ghz_pauli_operator_probabilities.m
│   │   │   │   ├── ghz_source_pauli_operators
│   │   │   │   ├── outer_leaves_swapping_and_construction.m
│   │   │   │   │   └── UW3_OuterLeave.m
│   │   │   │   │       ├── UW3_AddInitialLogErrors.m
│   │   │   │   │       └── R_ConcatenatedEC_OuterLeaves.m
│   │   │   │   │           ├── R_ReminderMod.m
│   │   │   │   │           ├── R_SyndromeToErrors.m
│   │   │   │   │           └── R_JointErrorLikelihood.m
│   │   │   │   │               └── R_ErrorLikelihood.m
│   │   │   │   └── inner_leaves_swapping_and_construction.m
│   │   │   │       └── UW3_InnerLeave.m
│   │   │   │           ├── UW3_AddInitialLogErrors.m
│   │   │   │           └── R_ConcatenatedEC_InnerLeaves.m
│   │   │   │               ├── R_ReminderMod.m
│   │   │   │               ├── R_SyndromeToErrors.m
│   │   │   │               └── R_JointErrorLikelihood.m
│   │   │   │                   └── R_ErrorLikelihood.m
│   │   │   ├── map_ghz_pauli_operator_probabilities_to_combined_pauli_operator_probabilities.m
│   │   │   │   └── ghz_source_pauli_operators
│   │   │   ├── map_combined_pauli_operator_probabilities_to_ghz_basis_lambdas_and_Qs.m
│   │   │   │   ├── get_three_qubit_pauli_labels.m
│   │   │   │   └── map_three_qubit_pauli_to_ghz_basis_index.m
│   │   │   └── map_Qs_to_secret_key_rate.m
│   │   │       ├── p_log2_p.m
│   │   │       ├── p_times_one_minus_log2_p.m
│   │   │       └── binary_entropy.m
│   │   └── BellRate.m
│   │       ├── UW3_OuterLeave.m
│   │       │   ├── UW3_AddInitialLogErrors.m
│   │       │   └── R_ConcatenatedEC_OuterLeaves.m
│   │       │       ├── R_ReminderMod.m
│   │       │       ├── R_SyndromeToErrors.m
│   │       │       └── R_JointErrorLikelihood.m
│   │       │           └── R_ErrorLikelihood.m
│   │       ├── UW3_InnerLeave.m
│   │       │   ├── UW3_AddInitialLogErrors.m
│   │       │   └── R_ConcatenatedEC_InnerLeaves.m
│   │       │       ├── R_ReminderMod.m
│   │       │       ├── R_SyndromeToErrors.m
│   │       │       └── R_JointErrorLikelihood.m
│   │       │           └── R_ErrorLikelihood.m
│   │       ├── R_SecretKey6State_total.m
│   │       ├── R_Find_v.m
│   │       └── R_LogErrAfterPost.m
│   ├── run_switch_resource_allocation_sweep_end_node.m
│   │   ├── GHZRate_end_node.m
│   │   │   ├── UW3_OuterLeave_end_node.m
│   │   │   │   ├── UW3_AddInitialLogErrors.m
│   │   │   │   └── R_ConcatenatedEC_OuterLeaves.m
│   │   │   │       ├── R_ReminderMod.m
│   │   │   │       ├── R_SyndromeToErrors.m
│   │   │   │       └── R_JointErrorLikelihood.m
│   │   │   │           └── R_ErrorLikelihood.m
│   │   │   ├── UW3_InnerLeave_end_node.m
│   │   │   │   ├── UW3_AddInitialLogErrors.m
│   │   │   │   └── R_ConcatenatedEC_OuterLeaves.m
│   │   │   │       ├── R_ReminderMod.m
│   │   │   │       ├── R_SyndromeToErrors.m
│   │   │   │       └── R_JointErrorLikelihood.m
│   │   │   │           └── R_ErrorLikelihood.m
│   │   │   ├── UW3_end_node_swapping.m
│   │   │   │   ├── UW3_AddInitialLogErrors.m
│   │   │   │   └── R_ConcatenatedEC_InnerLeaves.m
│   │   │   │       ├── R_ReminderMod.m
│   │   │   │       ├── R_SyndromeToErrors.m
│   │   │   │       └── R_JointErrorLikelihood.m
│   │   │   │           └── R_ErrorLikelihood.m
│   │   │   ├── R_SecretKey6State_total.m
│   │   │   ├── R_Find_v.m
│   │   │   └── R_LogErrAfterPost.m
│   │   └── BellRate.m
│   ├── run_switch_resource_allocation_sweep_end_node_simplified.m
│   │   ├── GHZRate_end_node_simplified.m
│   │   │   ├── UW3_OuterLeave_end_node.m
│   │   │   │   ├── UW3_AddInitialLogErrors.m
│   │   │   │   └── R_ConcatenatedEC_OuterLeaves.m
│   │   │   │       ├── R_ReminderMod.m
│   │   │   │       ├── R_SyndromeToErrors.m
│   │   │   │       └── R_JointErrorLikelihood.m
│   │   │   │           └── R_ErrorLikelihood.m
│   │   │   ├── UW3_InnerLeave_end_node_simplified.m
│   │   │   │   ├── UW3_AddInitialLogErrors.m
│   │   │   │   └── R_ConcatenatedEC_OuterLeaves.m
│   │   │   │       ├── R_ReminderMod.m
│   │   │   │       ├── R_SyndromeToErrors.m
│   │   │   │       └── R_JointErrorLikelihood.m
│   │   │   │           └── R_ErrorLikelihood.m
│   │   │   ├── UW3_end_node_swapping_simplified.m
│   │   │   │   ├── UW3_AddInitialLogErrors.m
│   │   │   │   └── R_ConcatenatedEC_InnerLeaves.m
│   │   │   │       ├── R_ReminderMod.m
│   │   │   │       ├── R_SyndromeToErrors.m
│   │   │   │       └── R_JointErrorLikelihood.m
│   │   │   │           └── R_ErrorLikelihood.m
│   │   │   ├── R_SecretKey6State_total.m
│   │   │   ├── R_Find_v.m
│   │   │   └── R_LogErrAfterPost.m
│   │   └── BellRate.m
│   └── run_switch_resource_allocation_sweep_joint_transmission.m
│       ├── make_entangled_link_pools
│       │   └── outer_leaves_swapping_and_construction.m
│       ├── allocate_entangled_links
│       ├── GHZRate_from_allocated_links.m
│       │   ├── map_allocated_links_to_pauli_operator_probabilities.m
│       │   │   ├── ghz_source_pauli_operators
│       │   │   └── inner_leaves_swapping_and_construction.m
│       │   │       └── UW3_InnerLeave.m
│       │   │           ├── UW3_AddInitialLogErrors.m
│       │   │           └── R_ConcatenatedEC_InnerLeaves.m
│       │   │               ├── R_ReminderMod.m
│       │   │               ├── R_SyndromeToErrors.m
│       │   │               └── R_JointErrorLikelihood.m
│       │   │                   └── R_ErrorLikelihood.m
│       │   ├── map_ghz_pauli_operator_probabilities_to_combined_pauli_operator_probabilities.m
│       │   │   └── ghz_source_pauli_operators
│       │   ├── map_combined_pauli_operator_probabilities_to_ghz_basis_lambdas_and_Qs.m
│       │   │   ├── get_three_qubit_pauli_labels.m
│       │   │   └── map_three_qubit_pauli_to_ghz_basis_index.m
│       │   └── map_Qs_to_secret_key_rate.m
│       │       ├── p_log2_p.m
│       │       ├── p_times_one_minus_log2_p.m
│       │       └── binary_entropy.m
│       └── BellRate_from_allocated_links.m
│           ├── UW3_InnerLeave.m
│           │   ├── UW3_AddInitialLogErrors.m
│           │   └── R_ConcatenatedEC_InnerLeaves.m
│           │       ├── R_ReminderMod.m
│           │       ├── R_SyndromeToErrors.m
│           │       └── R_JointErrorLikelihood.m
│           │           └── R_ErrorLikelihood.m
│           ├── R_SecretKey6State_total.m
│           ├── R_Find_v.m
│           └── R_LogErrAfterPost.m
├── python_plotting/
│   ├── QCNC_PLOT1_Rate_vs_Distance.ipynb (QCNC_Fig 2)
│   ├── QCNC_PLOT2_Rate_vs_k.ipynb (QCNC_Fig 3)
│   ├── QCNC_PLOT3_NoGKP_vs_Distance.ipynb (QCNC_Fig 4)
│   ├── QCNC_PLOT4_Cost_vs_k.ipynb (QCNC_Fig 5)
│   ├── QCNC_PLOT5_Rate_vs_Distance.ipynb (QCNC_Fig 6)
│   ├── QCNC_PLOT6_etam_vs_Lcavity.ipynb (QCNC_Fig 7)
│   └── fig_data
│       ├── run_switch_resource_allocation_sweep.csv
│       ├── run_switch_resource_allocation_sweep_end_node.csv
│       ├── run_switch_resource_allocation_sweep_end_node_simplified.csv
│       └── run_switch_resource_allocation_sweep_joint_transmission.csv
├── LICENSE # MIT license for usage and redistribution
└── README.md
```

# License
This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.
