#!/bin/sh


if which "${PROJECT_DIR}/Scripts/swiftlint" >/dev/null; then
  "${PROJECT_DIR}/Scripts/swiftlint" --config Scripts/.swiftlint.yml
else
  echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi
