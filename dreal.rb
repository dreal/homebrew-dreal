class Dreal < Formula
  homepage "http://dreal.github.io"
  url "https://github.com/dreal/dreal4/archive/a3c2f845ceb1c2b1490163508d1a687c8e6bd351.tar.gz"
  sha256 "358e03f950a4bf242f12ee62c82f7ab74ec1318f03956c4d6c4e5dcacd9949fc"
  version "4.17.09.2"

  bottle do
    root_url 'https://dl.bintray.com/dreal/homebrew-dreal'
    rebuild 1
    sha256 "61a08e8a0a1264a7316f32dcdbb8e8e7bc6cc4faa3fb20bdeb4c1c45ada19620" => :sierra    
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
