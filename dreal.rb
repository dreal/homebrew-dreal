class Dreal < Formula
  homepage "http://dreal.github.io"
  url "https://codeload.github.com/dreal/dreal4/tar.gz/22cea792816d773abb1e521f2823cbb4e895700a"
  sha256 "5eb2900d295a91e67964ae8243ff7163d4a21a84cc6845af3a34ae8905314dc4"
  version "4.17.09.1"

  bottle do
    root_url 'https://dl.bintray.com/dreal/homebrew-dreal'
    sha256 "9716cc0e7d756f91c512ac0113a483248ef9540c3a64ec59e5abe0fc4999ce56" => :sierra
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
    (lib+"pkgconfig").install "usr/lib/pkgconfig/dreal.pc"
  end
end
