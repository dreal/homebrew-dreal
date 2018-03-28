class Dreal < Formula
  homepage "http://dreal.github.io"
  url "https://github.com/dreal/dreal4/archive/4.18.03.2.tar.gz"
  sha256 "532a5392db7e106a5160948b4b97fb3bcdd0779c19369dc557693513830d5427"
  version "4.18.03.2"
  
  bottle do
    root_url 'https://dl.bintray.com/dreal/homebrew-dreal'
    cellar :any
      sha256 "a2a8aef14e0f16768331fde0e4969fd80bd8b9a6aa1f1e6f1c80bb606aaf27c4" => :el_capitan
      sha256 "7d91cbfbff01c448ea9eaecd041ddc31f596d88796a58294fff2107db5966baa" => :sierra
      sha256 "982039daa4e63c9c6b76ac54c5acfb6944e7054574cafb370b9636f2ed2b9590" => :high_sierra
  end

  # Required
  depends_on 'bazel'                => :build
  depends_on 'pkg-config'           => :build
  depends_on 'python@2'             => :build
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
    (lib+"python2.7").install "opt/dreal/#{version}/lib/python2.7/site-packages"
  end

  def caveats; <<~EOS
    To use Python binding, add the following path to PYTHONPATH environment variable:
      #{HOMEBREW_PREFIX}/opt/dreal/lib/python2.7/site-packages
    EOS
  end
end
