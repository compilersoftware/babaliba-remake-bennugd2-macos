#!/usr/bin/env bash


mkdir -p build
bennugd/bgdc.app/Contents/MacOS/bgdc src/babaliba.prg -o build/babaliba.dcb
cp -r src/* build/
rm build/babaliba.prg
