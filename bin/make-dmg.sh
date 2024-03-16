#!/bin/bash

# Se necesita instalar appdmg
# @see https://www.npmjs.com/package/appdmg

# delete previous image
rm build/Babaliba.dmg

# create files
cp assets/babaliba.json build/
cp assets/background.png build/
cp -r assets/README.rtfd build/
cd build/
appdmg babaliba.json Babaliba.dmg

# remove temp files
rm babaliba.json
rm background.png
rm -r README.rtfd