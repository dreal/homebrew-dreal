class Dreal < Formula
  homepage "http://dreal.github.io"
  url "https://github.com/dreal/dreal4/archive/4.17.10.3.tar.gz"
  sha256 "f6a3531b304950bbef4445a973e35a575ec241fc14a162c60536f54c40d9ae78"
  version "4.17.10.3"

  bottle do
    root_url 'https://dl.bintray.com/dreal/homebrew-dreal'
    cellar :any
    rebuild 1
    sha256 "13b6f49fa6695bed87d90fded5a3d28620c78924e1ae59f8a93adffdcbf723ca" => :high_sierra
    sha256 "9ad2ca43bd669aa5dbc2da54eeab8b1a56788260d9e99dc111eb507ec20c286c" => :sierra
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
