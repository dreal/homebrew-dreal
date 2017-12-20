class Dreal < Formula
  homepage "http://dreal.github.io"
  url "https://github.com/dreal/dreal4/archive/4.17.12.3.tar.gz"
  sha256 "dda8384cc1458a511a1214621f4ae9a951452921ba0a774f2294e4e3a9259c8c"

  bottle do
    root_url 'https://dl.bintray.com/dreal/homebrew-dreal'
    cellar :any
    sha256 "bc93726a76b0a124dc5c9afcbc4627c8632201daae13179f9d28ddac1b18e25e" => :high_sierra
#    sha256 "bd1cc4b516b2db77e7e27f865c10d3ef53f7ea9caec667cde263940be671743e" => :sierra
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
