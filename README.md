# PREFIRE_L3 bundle

The PREFIRE Level-3 gridded surface product code needs two sibling repositories from the PREFIRE mission team. This repository holds the three side by side as git submodules, so the algorithm can be cloned in one step:

```sh
git clone --recurse-submodules https://github.com/gchang/prefire-l3-bundle.git
```

| Submodule | Source | Commit | Role |
|---|---|---|---|
| `PREFIRE_L3` | https://github.com/gchang/prefire-l3 (upstream https://github.com/UW-PREFIRE/PREFIRE_L3 `R01` with the fixes listed in its `MAAP_CHANGES.md`) | tag `R01.post1`, a893526f | the L3 product code (`dist/produce_L3.py`) |
| `PREFIRE_PRD_GEN` | https://github.com/UW-PREFIRE/PREFIRE_PRD_GEN | R01, e3933a38 | NetCDF read and write helpers |
| `PREFIRE_tools` | https://github.com/UW-PREFIRE/PREFIRE_tools | R01, 3b590a6e | utilities |

All three are MIT-licensed by the PREFIRE Mission Team. Nothing inside the submodules is changed by this bundle.

## Software and data

- Python 3.10 with numpy, scipy and netcdf4 from conda-forge, and git (to record the code versions in the product).
- Inputs: the R01 2B-SFC, AUX-MET and AUX-SAT granules for the period, from NASA LaRC ASDC (Earthdata login). One day for one satellite is 51 files, about 1.2 GB; a month, the official period, is about 31 GB.
- Memory is set by the output grid, not the period: about 22.5 GB for all 63 channels at once, or about 7.6 GB per group of 21 channels with `SPECTRAL_IDX_RANGE_0BI`.

## Running one period

From the bundle root:

```sh
source bundle_env.sh
python PREFIRE_L3/dist/determine_prdgit.py      # records the code versions; the product step needs it
export ANCILLARY_DATA_DIR=$PWD/PREFIRE_L3/dist/ancillary \
       L2B_PRODUCT_DIR=/path/to/inputs OUTPUT_DIR=/path/to/output \
       PRODUCT_MONIKER=3-SFC-SORTED-ALLSKY PRODUCT_FULLVER=R01_P00 SAT_NUM=1 \
       UTC_DTREP_RANGE_TO_PROC=2024-10-07T00:00:00Z,2024-10-08T00:00:00Z \
       SPECTRAL_IDX_RANGE_0BI=0:20
python PREFIRE_L3/dist/produce_L3.py
```

Leave `SPECTRAL_IDX_RANGE_0BI` unset to process all channels in one run. The author's own test, `PREFIRE_L3/test/run.sh`, does the same from inside `PREFIRE_L3/test/`.
