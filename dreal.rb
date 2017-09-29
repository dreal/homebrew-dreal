class Dreal < Formula
  homepage "http://dreal.github.io"
  url "https://github.com/dreal/dreal4/archive/4.17.09.3.tar.gz"
  sha256 "57beb7eebe87d8c17625e02feb8f22e831dc8110c2d7f610f0e7a68965c7b5bc"
  version "4.17.09.3"

  bottle do
    root_url 'https://dl.bintray.com/dreal/homebrew-dreal'
    sha256 "4f122c35de62e1031686b4902199e444480884867525fba97a397d2c2b2f7062" => :high_sierra
    sha256 "76fd8632a8a429b5ceca2221c546ef71828404866cdfea23c5f8f5e5b6595004" => :sierra
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
