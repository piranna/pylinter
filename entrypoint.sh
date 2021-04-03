#!/bin/bash

# --- Parameters --- #
# $1: python-root
# $2: flake8-flags
# $3: mypy-flags
# $4: fail-on-isort
# $5: skip-flake8
# $6: skip-mypy
# $7: skip-isort

if [ "$5" = false ]; then
  FLAKE8_ERRORS=$(python3 -m flake8 "$2" "$1")
  exit_code=$?

  if [ "$exit_code" != "0" ]; then
    printf "\nflake8 errors:\n-----------------\n%s\n-----------------\n" "$FLAKE8_ERRORS"
    exit $exit_code
  fi
fi

if [ "$6" = false ]; then
  # mypy by default doesn't recurse, have to do manually
  MYPY_ERRORS=$(find "$1" -name "*.py" -print0 | xargs mypy "$3")
  exit_code=$?

  if [ "$exit_code" != "0" ]; then
    printf "\nmypy errors:\n-----------------\n%s\n-----------------\n" "$MYPY_ERRORS"
    exit $exit_code
  fi
fi

if [ "$7" = false ]; then
  # --diff gives list of changes to apply
  # no error code, so have to check if changes include import/from changes
  ISORT_ERRORS=$(isort "$1" --diff)
  if [[ "$ISORT_ERRORS" == *"import"* ]] || [[ "$ISORT_ERRORS" == *"from"* ]]; then
      printf "\nisort errors:\n-----------------\n%s\n-----------------\n" "$ISORT_ERRORS"

      if [ "$4" = true ]; then
          exit 1
      else
        isort "$1"  # no diff so modifies files
      fi
  fi
fi
