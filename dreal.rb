class Dreal < Formula
  homepage "http://dreal.github.io"
  url "https://github.com/dreal/dreal4/archive/4.18.02.4.tar.gz"
  sha256 "7f2f534a1f1314bb9e2d58b7af66989ce0538208528fd63ed2fd5efc4457c162"
  version "4.18.02.4"
  
  bottle do
    root_url 'https://dl.bintray.com/dreal/homebrew-dreal'
    cellar :any
      # sha256 "3d7971bdd0f29e2babaa2a09e936878dd44ed277d60b9d42de70f4efa29b771c" => :el_capitan
      sha256 "b9ede02afd86feefc188559ec489133e4bb2898fab1a43b7fe65ed4d4b8bf529" => :sierra
      sha256 "83b6a76ad0b288bdd17eab535e476ff1ddcc54106a159905634c84ea7c66e07a" => :high_sierra
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
    inreplace "opt/dreal/#{version}/lib/pkgconfig/dreal.pc", "HOMEBREW_PREFIX", "#{HOMEBREW_PREFIX}"
    (lib+"pkgconfig").install "opt/dreal/#{version}/lib/pkgconfig/dreal.pc"
  end
end
