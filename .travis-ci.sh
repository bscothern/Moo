#!/bin/bash -x

###################################################################
# Setup
###################################################################
SWIFTLINT=$(which swiftlint)
function run_swiftlint () {
    ${SWIFTLINT} --strict
}

if [[ $TRAVIS_OS_NAME == "linux" ]]; then
    SWIFT=./usr/bin/swift
else
    SWIFT=$(which swift)
fi
function run_swift() {
    if [[ ${RUN_TESTS} == "True" ]]; then
        ${SWIFT} test;
    else
        ${SWIFT} build;
    fi
}

###################################################################
# Main Execution
###################################################################
if [[ ${NAME} == "Swiftlint" ]]; then
    run_swiftlint
elif [[ ${NAME} == "SwiftPM" ]]; then
    run_swift
else
    echo "Invalid build scheme in matrix"
    exit 1
fi
