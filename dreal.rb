class Dreal < Formula
  homepage "http://dreal.github.io"
  url "https://github.com/dreal/dreal4/archive/4.18.01.3.tar.gz"
  sha256 "7321613a917a7b5a5c79310e93f103f5cefabed69586778a42cd4ba56f888bee"

  bottle do
    root_url 'https://dl.bintray.com/dreal/homebrew-dreal'
    cellar :any
     sha256 "59ff143a64f0d5471d70763ee3ae8f5bdcd4c02227512e222c6e03b55e8080c2" => :el_capitan
     # sha256 "" => :sierra
     sha256 "69d14a782ffe6684a2f8f984ad7c7d9d6553295617937f919e1adc7496c82c41" => :high_sierra
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
