#!/usr/bin/env bash

# @see https://github.com/AugustoRuiz/UWOL/blob/master/buildOSXApp.sh

APPNAME=Babaliba
APPBUNDLE=build/${APPNAME}.app


# Compilamos el juego de cero y sin debug, para no empaquetar lo que no queremos

bin/clean.sh
bin/compile.sh

# Generamos el bundle

rm -rf ${APPBUNDLE}
mkdir -p ${APPBUNDLE}/Contents
mkdir -p ${APPBUNDLE}/Contents/MacOS/
cp -r templates/app/* ${APPBUNDLE}/
cp bennugd/bgdi.app/Contents/MacOS/* ${APPBUNDLE}/Contents/MacOS/
cp -r build/babaliba.dcb ${APPBUNDLE}/Contents/MacOS/
cp -r src/data ${APPBUNDLE}/Contents/MacOS/
cp -r src/gfx ${APPBUNDLE}/Contents/MacOS/
cp -r src/music ${APPBUNDLE}/Contents/MacOS/
cp -r src/sfx ${APPBUNDLE}/Contents/MacOS/
cp assets/Info.plist ${APPBUNDLE}/Contents/Info.plist
cp assets/Babaliba ${APPBUNDLE}/Contents/MacOS/Babaliba
chmod +x ${APPBUNDLE}/Contents/MacOS/Babaliba

# Iconos

rm -rf ${APPNAME}.iconset
mkdir ${APPNAME}.iconset
sips -z 16 16     assets/${APPNAME}Icon.png --out ${APPNAME}.iconset/icon_16x16.png
sips -z 32 32     assets/${APPNAME}Icon.png --out ${APPNAME}.iconset/icon_16x16@2x.png
sips -z 32 32     assets/${APPNAME}Icon.png --out ${APPNAME}.iconset/icon_32x32.png
sips -z 64 64     assets/${APPNAME}Icon.png --out ${APPNAME}.iconset/icon_32x32@2x.png
sips -z 128 128   assets/${APPNAME}Icon.png --out ${APPNAME}.iconset/icon_128x128.png
sips -z 256 256   assets/${APPNAME}Icon.png --out ${APPNAME}.iconset/icon_128x128@2x.png
sips -z 256 256   assets/${APPNAME}Icon.png --out ${APPNAME}.iconset/icon_256x256.png
sips -z 512 512   assets/${APPNAME}Icon.png --out ${APPNAME}.iconset/icon_256x256@2x.png
sips -z 512 512   assets/${APPNAME}Icon.png --out ${APPNAME}.iconset/icon_512x512.png
cp assets/${APPNAME}Icon.png ${APPNAME}.iconset/icon_512x512@2x.png
mkdir -p ${APPBUNDLE}/Contents/Resources
iconutil -c icns -o ${APPBUNDLE}/Contents/Resources/${APPNAME}.icns ${APPNAME}.iconset
rm -r ${APPNAME}.iconset