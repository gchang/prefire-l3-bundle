# Put the PREFIRE_L3 sibling packages on PYTHONPATH (the PYTHONPATH method in PREFIRE_L3/README.md)
# and keep Python from rewriting tracked bytecode in the submodules.
# Usage, from anywhere: source /path/to/prefire-l3-bundle/bundle_env.sh
_bundle_root="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
export PYTHONPATH="${_bundle_root}/PREFIRE_PRD_GEN/source:${_bundle_root}/PREFIRE_tools/source/python${PYTHONPATH:+:${PYTHONPATH}}"
export PYTHONDONTWRITEBYTECODE=1
unset _bundle_root
