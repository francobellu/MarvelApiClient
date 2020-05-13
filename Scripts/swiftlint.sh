#!/bin/sh

if which swiftlint >/dev/null; then
  swiftlint --config Scripts/.swiftlint.yml
else
  echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi
