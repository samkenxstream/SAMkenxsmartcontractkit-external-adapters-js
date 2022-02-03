#!/bin/bash
# echo "=============== list modified files ==============="
git diff --name-only HEAD^ HEAD

# echo "========== check paths of modified files =========="
filename=$(date +%s)
git diff --name-only HEAD^ HEAD > $filename.txt
has_adapter_change=0
has_changeset=0

while IFS= read -r file
do
# echo $file
if [[ $file == packages/sources/*/src/* || $file == packages/composites/*/src/* || $file == packages/targets/*/src/* ]]; then
    # echo "This PR contains an adapter src code change."
    has_adapter_change=1
fi

if [[ $file == .changeset/* ]]; then
    # echo "This PR contains a changeset file."
    has_changeset=1
fi
done < $filename.txt

is_valid_change=1
if [ "$has_adapter_change" -eq 1 ] && [ "$has_changeset" -eq 0 ] ; then
    is_valid_change=0
fi

if [ "$is_valid_change" -eq 0 ] ; then
    echo "⚠️ NOTICE: Adapter changes must also have a changeset. Generate a changeset with 'yarn changeset' and include it in your commit."
fi

exit "$is_valid_change"