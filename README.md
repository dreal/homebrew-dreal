[![Build Status](https://travis-ci.org/dreal/homebrew-dreal.svg?branch=master)](https://travis-ci.org/dreal/homebrew-dreal)

homebrew-dreal
=============

Homebrew tap for [dReal4][dreal4]

[dreal4]: https://github.com/dreal/dreal4

How to Install
--------------

```bash
brew tap dreal/dreal
brew install dreal
```

Run ``brew upgrade dreal`` to get the latest version of dReal after installation.

How to Maintain
---------------

```bash
brew rm dreal -f
brew install ./dreal.rb --build-bottle
brew bottle ./dreal.rb --force-core-tap
```
