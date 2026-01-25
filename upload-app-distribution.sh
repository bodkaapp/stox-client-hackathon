#!/bin/bash

cd android
./gradlew assembleRelease appDistributionUploadRelease
cd ../