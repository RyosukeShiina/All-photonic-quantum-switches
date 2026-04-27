# Code for "All-photonic quantum repeaters with 9 km spacing"  
Author: Ryosuke Shiina
Affiliation: University of Massachusetts Amherst
Contact: rshiina@umass.edu

# Description
This repository contains the MATLAB, Mathematica, and Python code used to generate the results in our paper.

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

The notebooks load data from `python_plotting/Fig_Data/`.
If you would like to regenerate the simulation outputs from scratch, please use the UW3 series.

# Folder Structure and Call Hierarchy
When viewing this repository on GitHub, please first open the `README.md` file. To properly display the directory tree shown below, make sure to click on the **Code** tab.

project-root/
├── matlab_simulation/
│   ├── run_switch_resource_allocation_sweep.m
│   │   ├── GHZRate.m
│   │   │   ├── map_swapping_results_to_ghz_pauli_operator_probabilities.m
│   │   │   │   ├── OuterSwappingAndConstruction.m
│   │   │   │   └── InnerSwappingAndConstruction.m
│   │   │   ├── QxQzQab_from_CombinedResults.m
│   │   │   └── Rate_from_QxQzQab.m
│   │   └── BellRate.m
│   ├── UW3_InnerAndOuterLeave.m
│   │   ├── UW3_OuterLeave.m
│   │   │   ├── UW3_AddInitialLogErrors.m
│   │   │   └── R_ConcatenatedEC_OuterLeaves.m
│   │   │       ├── R_ReminderMod.m
│   │   │       ├── R_SyndromeToErrors.m
│   │   │       └── R_JointErrorLikelihood.m
│   │   │           └── R_ErrorLikelihood.m
│   │   ├── UW3_InnerLeave.m
│   │   │   ├── UW3_AddInitialLogErrors.m
│   │   │   └── R_ConcatenatedEC_InnerLeaves.m
│   │   │       ├── R_ReminderMod.m
│   │   │       ├── R_SyndromeToErrors.m
│   │   │       └── R_JointErrorLikelihood.m
│   │   │           └── R_ErrorLikelihood.m
│   │   ├── R_Find_v.m
│   │   └── R_LogErrAfterPost.m
│   ├── Perror_vs_v7_UW2_9km.m (Fig 9A01)
│   ├── Rate_vs_Distance_UW2_and_UW3.m (Fig 9B01)
│   ├── Rate_vs_k_UW2.m (Fig 9B02-9B04)
│   ├── Rate_vs_k_UW3.m (Fig 9B02-9B04)
│   ├── Rate_vs_Distance_ML_UW2_and_UW3.m (Fig 10A02)
│   ├── Rate_vs_Distance_LP.m (Fig 10B03)
│   └── Rate_vs_Distance_LP_Spool_125m.m (Fig 10B03)
├── mathematica_simulation/
│   ├── NoG1_vs_Distance_UW2.m (Fig 9C01)
│   ├── NoG1_vs_Distance_UW2_k=15_three9.m (Fig 9C01)
│   ├── NoG1_vs_Distance_UW2_k=15_four9.m (Fig 9C01)
│   ├── NoG1_vs_Distance_UW3.m (Fig 9C01)
│   ├── NoG1_vs_k_UW2.m (Fig 9C02)
│   ├── NoG1_vs_k_UW2_k=14.m (Fig 9C02)
│   ├── NoG1_vs_k_UW2_k=15.m (Fig 9C02)
│   ├── NoG1_vs_k_UW2_k=16.m (Fig 9C02)
│   ├── NoG1_vs_k_UW2_k=17.m (Fig 9C02)
│   ├── NoG1_vs_k_UW2_k=18.m (Fig 9C02)
│   ├── NoG1_vs_k_UW2_k=19.m (Fig 9C02)
│   ├── NoG1_vs_k_UW2_k=20.m (Fig 9C02)
│   ├── NoG1_vs_k_UW3.m (Fig 9C02)
│   ├── NoG1_vs_Distance_ML_UW2.m (Fig 10A03)
│   ├── NoG1_vs_Distance_ML_UW3.m (Fig 10A03)
│   └── NoG1_vs_Distance_LP.m (Fig 10B04)
├── python_plotting/
│   ├── FIG9A01_Perror_vs_v7.ipynb
│   ├── FIG9B01_Rate_vs_Distance.ipynb
│   ├── FIG9B02-FIG9B05_Rate_vs_k.ipynb
│   ├── FIG9C01_NoGKP_vs_Distance.ipynb
│   ├── FIG9C02_NoGKP_vs_k.ipynb
│   ├── FIG9D01-FIG9D05_Cost.ipynb
│   ├── FIG10A02_Rate_vs_Distance.ipynb
│   ├── FIG10A03_NoGKP_vs_Distance.ipynb
│   ├── FIG10B03_Rate_vs_Distance.ipynb
│   ├── FIG10B04_NoGKP_vs_Distance.ipynb
│   ├── QCNC_camera-ready_FIG3_Rate_vs_Distance.ipynb (QCNC_Fig 3)
│   ├── QCNC_camera-ready_FIG4_Rate_vs_k.ipynb (QCNC_Fig 4)
│   ├── QCNC_camera-ready_FIG5_NoGKP_vs_Distance.ipynb (QCNC_Fig 5)
│   ├── QCNC_camera-ready_FIG6_Cost_vs_k.ipynb (QCNC_Fig 6)
│   ├── QCNC_camera-ready_FIG7_Rate_vs_Distance.ipynb (QCNC_Fig 7)
│   ├── QCNC_camera-ready_FIG8_etam_vs_Lcavity.ipynb (QCNC_Fig 8)
│   └── fig_data
│       ├── Perror_vs_v7
│       ├── Pdiscard_vs_v7
│       ├── Rate_vs_Distance_UW2_and_UW3
│       ├── Rate_vs_Distance_ML_and_LP
│       ├── Rate_vs_k
│       ├── NoG1_vs_Distance
│       └── NoG1_vs_k
├── LICENSE # MIT license for usage and redistribution
└── README.md

# License
This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.
