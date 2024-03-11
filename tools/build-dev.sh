#!/bin/bash
rojo build default.project.json -o devPlace.rbxlx
if [[ "$OSTYPE" == "darwin"* ]]; then
    open devPlace.rbxlx
elif [[ "$OSTYPE" == "msys"* ]]; then
    start devPlace.rbxlx
fi