class Dreal < Formula
  homepage "http://dreal.github.io"
  url "https://github.com/dreal/dreal4/archive/4.17.12.3.tar.gz"
  sha256 "dda8384cc1458a511a1214621f4ae9a951452921ba0a774f2294e4e3a9259c8c"

  bottle do
    root_url 'https://dl.bintray.com/dreal/homebrew-dreal'
    cellar :any
     sha256 "0ce07f24d00dae5eaf6aca3a00e727e6e7a8040e7afc826c8e14080705beb6e3" => :el_capitan
     sha256 "bc93726a76b0a124dc5c9afcbc4627c8632201daae13179f9d28ddac1b18e25e" => :high_sierra
     sha256 "dc03448ac8660e112a7960daff9ccfbc85b13ace0fadb1969e3f1592c119fdaf" => :sierra
  end

  # Required
  depends_on 'bazel'                => :build
  depends_on 'pkg-config'           => :build
  depends_on 'dreal-deps/ibex/ibex'

  needs :cxx11

  def install
    system "bazel", "build", "--compilation_mode=opt", "//:archive"
    system "tar", "xf", "bazel-bin/archive.tar.gz"
    bin.install "usr/bin/dreal"
    lib.install "usr/lib/libdreal.so"
    include.install "usr/include/dreal"
    inreplace "usr/lib/pkgconfig/dreal.pc", "HOMEBREW_CELLAR", "#{HOMEBREW_PREFIX}/Cellar"
    (lib+"pkgconfig").install "usr/lib/pkgconfig/dreal.pc"
  end
end
