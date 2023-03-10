#!/bin/bash

containerWorkspaceFolder=$1

julia --project=$containerWorkspaceFolder -e "using Pkg; Pkg.instantiate()"