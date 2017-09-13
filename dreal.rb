class Dreal < Formula
  homepage "http://dreal.github.io"
  url "https://codeload.github.com/dreal/dreal4/tar.gz/5421fa080416f90c1d79c4c47a900031acacacfb"
  sha256 "e6d744591defa82edc7107544ce12142c9ab74bea5386229ed2ab2afb242c44d"
  version "4.17.09"

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
    (lib+"pkgconfig/dreal.pc").write pc_file
  end

  def pc_file; <<-EOS.undent
     prefix=#{prefix}
     exec_prefix=${prefix}
     libdir=${prefix}/lib
     includedir=${prefix}/include

     Name: dReal
     Description: SMT Solver for Nonlinear Theories
     Version: #{version}
     Libs: -L${libdir} -ldreal -libex -lClpSolver -lClp -lCoinUtils -lbz2 -lz -lm
     Cflags: -I${includedir} -I${includedir}/dreal -I${includedir}/ibex -I${includedir}/ibex/3rd -I${includedir}/clp/coin -I${includedir}/coinutils/coin
     EOS
  end
end
