#!/usr/bin/env bash
set -euxo pipefail
cp ./dreal.rb /usr/local/Homebrew/Library/Taps/dreal/homebrew-dreal/dreal.rb
brew rm dreal -f --ignore-dependencies
brew install dreal --build-bottle
brew bottle dreal --verbose
