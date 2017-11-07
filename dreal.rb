class Dreal < Formula
  homepage "http://dreal.github.io"
  url "https://github.com/dreal/dreal4/archive/4.17.10.5.tar.gz"
  sha256 "d1a54c3522033fd56a2a01769126481ad33b376daed508a48a17e5356382218f"

  bottle do
    root_url 'https://dl.bintray.com/dreal/homebrew-dreal'
    cellar :any
    sha256 "bd71c7b61309d3b5226e0ef99d6d2d2ee439756bb45867ff1fd9fd32f9be2e8f" => :el_capitan
    sha256 "9bb9c64aeaa82f11fab26f35f32cb69960ca81bd07d2ce8ba7c79e295ddfe402" => :high_sierra
    sha256 "fe413dd34941a1345d6a7b96f0a7f73fa364e1b28f8679ba192e26d4ed4545ca" => :sierra
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
