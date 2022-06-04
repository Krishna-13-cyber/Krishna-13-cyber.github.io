#!/bin/bash
#Input : commit message
echo "Commiting to git:"
git add --all
git commit -m $1
git push -u origin master