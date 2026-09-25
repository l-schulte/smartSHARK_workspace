#!/usr/bin/env bash
set -e

# Format: "URL TARGET_DIRECTORY [BRANCH]"
REPOS=(
    "git@github.com:l-schulte/vcsSHARK.git vcsSHARK_fork"
    "git@github.com:l-schulte/prSHARK.git prSHARK_fork coverageSHARK"
    "git@github.com:l-schulte/pycoSHARK.git pycoSHARK_fork prSHARK"
    "git@github.com:l-schulte/refactoringSHARK.git refactoringSHARK_fork"
    "git@github.com:l-schulte/inducingSHARK.git inducingSHARK_fork"
    "git@github.com:l-schulte/refSHARK.git refSHARK_fork"
    "git@github.com:l-schulte/rMinerShark.git rMineSHARK_fork"
    "git@github.com:l-schulte/RefactoringMiner.git tools/RefactoringMiner_fork js-ts-performance-fix"
    "git@github.com:l-schulte/coverageSHARK_lite.git coverageSHARK_lite"
)

for item in "${REPOS[@]}"; do
    read -r url dir branch <<< "$item"
    if [ -d "$dir" ]; then
        echo "Skipping $dir (already exists)"
    else
        echo "Cloning $url -> $dir..."
        mkdir -p "$(dirname "$dir")"
        if [ -n "$branch" ]; then
            git clone -b "$branch" "$url" "$dir"
        else
            git clone "$url" "$dir"
        fi
    fi
done

echo "Done!"
