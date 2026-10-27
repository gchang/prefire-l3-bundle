# PREFIRE_L3 bundle

The PREFIRE Level-3 gridded surface product code needs two sibling repositories from the PREFIRE mission team. This repository holds the three side by side as git submodules, so the algorithm can be cloned in one step:

```sh
git clone --recurse-submodules https://github.com/gchang/prefire-l3-bundle.git
```

| Submodule | Source | Commit | Role |
|---|---|---|---|
| `PREFIRE_L3` | https://github.com/gchang/prefire-l3 (upstream https://github.com/UW-PREFIRE/PREFIRE_L3 `R01` with the fixes listed in its `MAAP_CHANGES.md`) | tag `R01.post1`, bd12e7d0 | the L3 product code (`dist/produce_L3.py`) |
| `PREFIRE_PRD_GEN` | https://github.com/UW-PREFIRE/PREFIRE_PRD_GEN | R01, e3933a38 | NetCDF read and write helpers |
| `PREFIRE_tools` | https://github.com/UW-PREFIRE/PREFIRE_tools | R01, 3b590a6e | utilities |

All three are MIT-licensed by the PREFIRE Mission Team. Nothing inside the submodules is changed by this bundle.

## Software and data

- Python 3.10, as in `PREFIRE_L3/README.md`, and git (to record the code versions in the product). `environment.yml` holds the checked conda-forge set:

  ```sh
  conda env create -f environment.yml
  ```

- Inputs: the R01 2B-SFC, AUX-MET and AUX-SAT granules for the period, from NASA LaRC ASDC (Earthdata login), with their archive file names unchanged, in three subfolders `2B-SFC/`, `AUX-MET/` and `AUX-SAT/` of the folder given as `L2B_PRODUCT_DIR` (an absolute path). One day for one satellite is 51 files, about 1.2 GB; a month, the official period, is about 31 GB. If an AUX-SAT file is missing, the code quietly uses the AUX-MET surface type instead, which changes the sorting.
- Memory is set by the output grid, not the period: about 22.5 GB for all 63 channels at once, or about 7.6 GB per group of 21 channels with `SPECTRAL_IDX_RANGE_0BI`.

## Running one period

From the bundle root:

```sh
source bundle_env.sh
python PREFIRE_L3/dist/determine_prdgit.py      # records the code versions; the product step needs it
export ANCILLARY_DATA_DIR=$PWD/PREFIRE_L3/dist/ancillary \
       L2B_PRODUCT_DIR=/abs/path/to/inputs OUTPUT_DIR=/path/to/output \
       PRODUCT_MONIKER=3-SFC-SORTED-ALLSKY SAT_NUM=1 PRODUCT_FULLVER=R01_P00 \
       UTC_DTREP_RANGE_TO_PROC=2024-10-07T00:00:00Z,2024-10-08T00:00:00Z \
       SPECTRAL_IDX_RANGE_0BI=ATRACK_IDXRANGE_0BASED_INCLUSIVE:0:20
python PREFIRE_L3/dist/produce_L3.py
```

The channel range uses the three-part form that `PREFIRE_L3/README.md` documents; run the three groups `...:0:20`, `...:21:41` and `...:42:62` to cover all 63 channels in about 7.6 GB each, or leave `SPECTRAL_IDX_RANGE_0BI` unset to process all channels in one run (about 22.5 GB). `PRODUCT_FULLVER` must be set (`produce_L3.py` reads it at startup), but its value is not used: the product version comes from the input granules.

Checked on 2026-10-25 from a fresh `git clone --recurse-submodules` with one day of SAT1 inputs (7 October 2024): in the 1,821 grid bins observed only on that day, every field is bit-identical to the official October 2024 monthly 3-SFC-SORTED-ALLSKY granule, apart from 5 standard-deviation values that differ by at most 1.2e-10. Each channel group takes about 1 minute.

The author's test, `PREFIRE_L3/test/run.sh`, works from inside `PREFIRE_L3/test/` but always processes all 63 channels and expects its own input layout.
