class Dreal < Formula
  homepage "http://dreal.github.io"
  url "https://github.com/dreal/dreal4/archive/4.17.09.4.tar.gz"
  sha256 "bf5d505541498dbd13b0196ac6d649d674841925dddcfd4f722bce7d9ff798e6"
  version "4.17.09.4"

#  bottle do
#    root_url 'https://dl.bintray.com/dreal/homebrew-dreal'
#    sha256 "4f122c35de62e1031686b4902199e444480884867525fba97a397d2c2b2f7062" => :high_sierra
#    sha256 "76fd8632a8a429b5ceca2221c546ef71828404866cdfea23c5f8f5e5b6595004" => :sierra
#  end

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
