#!/usr/bin/env bash
set -euxo pipefail
cp ./Formula/dreal.rb /usr/local/Homebrew/Library/Taps/dreal/homebrew-dreal/Formula/dreal.rb
brew rm dreal -f --ignore-dependencies
brew install dreal --build-bottle
brew bottle dreal --verbose --no-rebuild

# Reset homebrew-dreal repo
git -C /usr/local/Homebrew/Library/Taps/dreal/homebrew-dreal reset --hard origin/master
