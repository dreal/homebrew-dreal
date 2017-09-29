class Dreal < Formula
  homepage "http://dreal.github.io"
  url "https://github.com/dreal/dreal4/archive/4.17.09.3.tar.gz"
  sha256 "57beb7eebe87d8c17625e02feb8f22e831dc8110c2d7f610f0e7a68965c7b5bc"
  version "4.17.09.3"

#  bottle do
#    root_url 'https://dl.bintray.com/dreal/homebrew-dreal'
#    sha256 "61a08e8a0a1264a7316f32dcdbb8e8e7bc6cc4faa3fb20bdeb4c1c45ada19620" => :sierra    
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
