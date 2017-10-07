class Dreal < Formula
  homepage "http://dreal.github.io"
  url "https://github.com/dreal/dreal4/archive/4.17.10.tar.gz"
  sha256 "a8bb8d8b517ffe77a8651e804c67c3ce933906101835eb4a6697589bd723daf7"
  version "4.17.10"

  bottle do
    root_url 'https://dl.bintray.com/dreal/homebrew-dreal'
    sha256 "a5b4ef867a045436c9c15f00d19ab804b4d537aae28726e77a5a53f8a700628b" => :high_sierra
#    sha256 "76fd8632a8a429b5ceca2221c546ef71828404866cdfea23c5f8f5e5b6595004" => :sierra
  end

  # Required
  depends_on 'bazel'                => :build
  depends_on 'pkg-config'           => :build
  depends_on 'dreal-deps/ibex/ibex'
  depends_on 'nlopt'

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
