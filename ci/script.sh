# Github CI has bazelisk pre-installed. We remove it to avoid conflicts with bazel.
brew uninstall bazelisk -f

# Set up dreal/dreal tap
brew tap dreal/dreal

# Install dependencies
brew tap dreal-deps/ibex
brew install dreal --only-dependencies || true

# Build from source and test
brew install dreal --build-from-source -v
brew test dreal

# Audit the formula and check linkage
brew audit --strict --online dreal
brew linkage --test dreal

# Check we can use it as a library
export PKG_CONFIG_PATH=/usr/local/opt/ibex@2.7.4/share/pkgconfig:${PKG_CONFIG_PATH}
curl -o check_sat.cc  https://raw.githubusercontent.com/dreal/dreal-bazel-example-project/master/check_sat.cc
clang++ --std=c++14 check_sat.cc `pkg-config dreal --cflags --libs` && ./a.out

# Python3 binding test
wget https://raw.githubusercontent.com/dreal/dreal4/master/dreal/test/python/api_test.py
wget https://raw.githubusercontent.com/dreal/dreal4/master/dreal/test/python/solver_test.py
python3 -m pip install dreal
python3 api_test.py --verbose
python3 solver_test.py --verbose
