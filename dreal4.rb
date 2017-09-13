class Dreal4 < Formula
  homepage "http://dreal.github.io"
  url "https://codeload.github.com/dreal/dreal4/tar.gz/5421fa080416f90c1d79c4c47a900031acacacfb"
  sha256 "e6d744591defa82edc7107544ce12142c9ab74bea5386229ed2ab2afb242c44d"
  version "17.09"

  # Required
  depends_on 'bazel'                 => :build
  depends_on 'pkg-config'               => :build
  depends_on 'dreal-deps/ibex/ibex'

  needs :cxx11

  def install
    system "bazel", "build", "--compilation_mode=opt", "//:package"
    system "tar", "xf", "bazel-bin/package.tar.gz"
    bin.install "usr/bin/dreal"
    lib.install "usr/lib/libdreal.so"
    include.install "usr/include/dreal"
  end

  def caveats; <<-EOS.undent
      dReal installed.
    EOS
  end
end
