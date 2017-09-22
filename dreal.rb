class Dreal < Formula
  homepage "http://dreal.github.io"
  url "https://github.com/dreal/dreal4/archive/bbc10dc5f45bbad21a695f59f6e5d7bcf16bbf3f.tar.gz"
  sha256 "a7e37759d897784cec6eaa997240b8d7cc24eec7c1cee331e713ed75d75262c2"
  version "4.17.09.2"

#  bottle do
#    root_url 'https://dl.bintray.com/dreal/homebrew-dreal'
#    sha256 "9716cc0e7d756f91c512ac0113a483248ef9540c3a64ec59e5abe0fc4999ce56" => :sierra
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
