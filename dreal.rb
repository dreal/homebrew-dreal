class Dreal < Formula
  homepage "http://dreal.github.io"
  url "https://github.com/dreal/dreal4/archive/4.18.02.2.tar.gz"
  sha256 "51f576a8881d3f916293b2ff56dc7038638e694a6ed6da9c1503cf0e37957d0d"

  bottle do
    root_url 'https://dl.bintray.com/dreal/homebrew-dreal'
    cellar :any
      sha256 "3d7971bdd0f29e2babaa2a09e936878dd44ed277d60b9d42de70f4efa29b771c" => :el_capitan
      sha256 "58fba701488bd73814448b1de0948407a16b0c4ea48d45b5c70fd6faae55e5ce" => :sierra
      sha256 "9c8afa5d2f640d3be96c5658aed7632a9f5a2b4ca7ff7d1fc459ac5931323a63" => :high_sierra
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
