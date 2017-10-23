class Dreal < Formula
  homepage "http://dreal.github.io"
  url "https://github.com/dreal/dreal4/archive/4.17.10.4.tar.gz"
  sha256 "fa473acc2dbf54ea513fc1a02265aa9e5aec206e407cd5db85f9b01d8ca7ba58"

  bottle do
    root_url 'https://dl.bintray.com/dreal/homebrew-dreal'
    cellar :any
    sha256 "5a2b91964770211ce7e71dac67d5dbc3c8e70519d5c7fb744488a72e8afcdbca" => :high_sierra
#    sha256 "" => :sierra
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
