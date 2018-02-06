class Dreal < Formula
  homepage "http://dreal.github.io"
  url "https://github.com/dreal/dreal4/archive/4.18.02.1.tar.gz"
  sha256 "6f8a8d3f6f77612953231203e312b9ada94946042f1e4c65016d8bef954757ae"

  bottle do
    root_url 'https://dl.bintray.com/dreal/homebrew-dreal'
    cellar :any
     # sha256 "59ff143a64f0d5471d70763ee3ae8f5bdcd4c02227512e222c6e03b55e8080c2" => :el_capitan
     # sha256 "e2c7767018a8aba60ce4536bea1d6ce6e6a89372d8dd5642ca1b27d458e209fc" => :sierra
     sha256 "cc8219c6554962135466be72551e27eb8d9f2cd172bde6139f43ff820e9a178d" => :high_sierra
  end

  # Required
  depends_on 'bazel'                => :build
  depends_on 'pkg-config'           => :build
  depends_on 'nlopt'
  depends_on 'dreal-deps/ibex/ibex@2.6.5'

  needs :cxx11

  def install
    system "bazel", "build", "--compilation_mode=opt", "//:archive"
    system "tar", "xvf", "bazel-bin/archive.tar.gz"
    bin.install "opt/dreal/#{version}/bin/dreal"
    lib.install "opt/dreal/#{version}/lib/libdreal.so"
    include.install "opt/dreal/#{version}/include/dreal"
    inreplace "opt/dreal/#{version}/lib/pkgconfig/dreal.pc", "HOMEBREW_CELLAR", "#{HOMEBREW_PREFIX}/Cellar"
    (lib+"pkgconfig").install "opt/dreal/#{version}/lib/pkgconfig/dreal.pc"
  end
end
