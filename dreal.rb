class Dreal < Formula
  homepage "http://dreal.github.io"
  url "https://github.com/dreal/dreal4/archive/4.17.10.3.tar.gz"
  sha256 "f6a3531b304950bbef4445a973e35a575ec241fc14a162c60536f54c40d9ae78"
  version "4.17.10.3"

  bottle do
    root_url 'https://dl.bintray.com/dreal/homebrew-dreal'
    sha256 "9948601703de98266b312c137ea0083fc6da6220eea04887dd1b3c130cd1d6f7" => :high_sierra
    sha256 "4f870ea7cae12f1993baab4c6fbee082cc1fd68a2205fee02b7494eeec89b434" => :sierra
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
