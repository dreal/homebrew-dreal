#!/usr/bin/env bash
set -euxo pipefail
brew rm dreal -f --ignore-dependencies
brew install ./dreal.rb --build-bottle
brew bottle ./dreal.rb --force-core-tap --verbose
