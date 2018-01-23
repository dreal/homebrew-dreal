class Dreal < Formula
  homepage "http://dreal.github.io"
  url "https://github.com/dreal/dreal4/archive/4.18.01.2.tar.gz"
  sha256 "67fc77890ffeff2551df607272892c96feea3f01d8aef2b22b86bc00eea2d438"

  bottle do
    root_url 'https://dl.bintray.com/dreal/homebrew-dreal'
    cellar :any
     sha256 "4a7b4e58ca52c659e34bf47e8d1c6d383d7366a52216e039caa9f827cfd37976" => :el_capitan
     sha256 "f538806440253ba4f90056e95cae54091e3fa0c9f5e078ebd132312cab4630db" => :sierra
     sha256 "cb5e1b5ec550d77844cd434f1fbec2e77a7183ef6155b9bacf1856393ac83c8a" => :high_sierra
  end

  # Required
  depends_on 'bazel'                => :build
  depends_on 'pkg-config'           => :build
  depends_on 'nlopt'
  depends_on 'dreal-deps/ibex/ibex'

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
