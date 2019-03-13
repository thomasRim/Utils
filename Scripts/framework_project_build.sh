#!/bin/bash

set -e

# Constants

PROJECT_NAME="PRJECT_NAME"
CONFIGURATION="Debug"
CLEAR_DEST=true
DERIVED_FOLDER="build" 
FRAMEWORK_FOLDER="framework"

# build simulator arc

## increasing the number of concurrent build tasks
defaults write com.apple.dt.Xcode BuildSystemScheduleInherentlyParallelCommandsExclusively -bool NO

say 'starting compile'

if [ -d "${DERIVED_FOLDER}" ]; then
    rm -rd ${DERIVED_FOLDER}
fi

echo '=== start device-arc framework compile ==='

time xcodebuild -workspace ${PROJECT_NAME}.xcworkspace -scheme ${PROJECT_NAME} -configuration ${CONFIGURATION} -sdk iphoneos \
SWIFT_OPTIMIZATION_LEVEL="-Owholemodule" SWIFT_WHOLE_MODULE_OPTIMIZATION=YES \
OTHER_SWIFT_FLAGS="-Onone -D COCOAPODS -Xfrontend -warn-long-function-bodies=100 -Xfrontend -warn-long-expression-type-checking=100" \
-derivedDataPath ${DERIVED_FOLDER} clean build -quiet 

afplay /System/Library/Sounds/Purr.aiff
say 'compiled for device'

# build device arc
echo '=== start simulator-arc framework compile ==='

time xcodebuild -workspace ${PROJECT_NAME}.xcworkspace -scheme ${PROJECT_NAME} -configuration ${CONFIGURATION} -sdk iphonesimulator \
SWIFT_OPTIMIZATION_LEVEL="-Owholemodule" SWIFT_WHOLE_MODULE_OPTIMIZATION=YES \
OTHER_SWIFT_FLAGS="-Onone -D COCOAPODS -Xfrontend -warn-long-function-bodies=100 -Xfrontend -warn-long-expression-type-checking=100" \
-derivedDataPath ${DERIVED_FOLDER} clean build -quiet 

afplay /System/Library/Sounds/Purr.aiff
say 'compiled for simulator'

# define BIG variables

APP_FRAMEWORK_DIR=${CONFIGURATION}-universal

APP_FRAMEWORK_LIBRARY_PATH=${APP_FRAMEWORK_DIR}/${PROJECT_NAME}.framework
APP_SIMULATOR_LIBRARY_PATH=${CONFIGURATION}-iphonesimulator/${PROJECT_NAME}/${PROJECT_NAME}.framework
APP_DEVICE_LIBRARY_PATH=${CONFIGURATION}-iphoneos/${PROJECT_NAME}/${PROJECT_NAME}.framework

# Prepare output folder

cd ${DERIVED_FOLDER}/Build/Products/

if [ "$CLEAR_DEST" = true ]; then
rm -rf "${APP_FRAMEWORK_DIR}"
fi

mkdir -p "${APP_FRAMEWORK_DIR}"
cp -R "${APP_DEVICE_LIBRARY_PATH}" "${APP_FRAMEWORK_LIBRARY_PATH}"

# Smash them together to combine all architectures
echo '=== prepare universal binary ===' 
lipo -create  "${APP_SIMULATOR_LIBRARY_PATH}/${PROJECT_NAME}" "${APP_DEVICE_LIBRARY_PATH}/${PROJECT_NAME}" -output "${APP_FRAMEWORK_LIBRARY_PATH}/${PROJECT_NAME}"

# For Swift framework, Swiftmodule needs to be copied in the universal framework

if [ -d "${APP_SIMULATOR_LIBRARY_PATH}/Modules/${PROJECT_NAME}.swiftmodule/" ]; then
cp -R "${APP_SIMULATOR_LIBRARY_PATH}/Modules/${PROJECT_NAME}.swiftmodule/." "${APP_FRAMEWORK_LIBRARY_PATH}/Modules/${PROJECT_NAME}.swiftmodule/" | echo
fi

if [ -d "${APP_DEVICE_LIBRARY_PATH}/Modules/${PROJECT_NAME}.swiftmodule/" ]; then
cp -R "${APP_DEVICE_LIBRARY_PATH}/Modules/${PROJECT_NAME}.swiftmodule/." "${APP_FRAMEWORK_LIBRARY_PATH}/Modules/${PROJECT_NAME}.swiftmodule/" | echo
fi

say 'universe lib prepared'

# move to prepared folder and ZIP
echo '=== compress binary arch ==='
cd ../../..
mkdir ${FRAMEWORK_FOLDER}
mkdir ${FRAMEWORK_FOLDER}/${PROJECT_NAME}
mkdir ${FRAMEWORK_FOLDER}/${PROJECT_NAME}/Core

touch ${FRAMEWORK_FOLDER}/${PROJECT_NAME}/README.md
touch ${FRAMEWORK_FOLDER}/${PROJECT_NAME}/Core/dummy.txt

cp -R ${DERIVED_FOLDER}/Build/Products/${APP_FRAMEWORK_LIBRARY_PATH} ${FRAMEWORK_FOLDER}/${PROJECT_NAME}/Core

cd ${FRAMEWORK_FOLDER}
tar -czvf ${PROJECT_NAME}.tar.gz */
mv ${PROJECT_NAME}.tar.gz ..

# clear prepared folders
cd ..
rm -rd ${FRAMEWORK_FOLDER}
rm -rd ${DERIVED_FOLDER}

## remove increasing the number of concurrent build tasks
defaults delete com.apple.dt.Xcode BuildSystemScheduleInherentlyParallelCommandsExclusively

say 'ready and cleared'