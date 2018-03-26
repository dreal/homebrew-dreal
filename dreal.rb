class Dreal < Formula
  homepage "http://dreal.github.io"
  url "https://github.com/dreal/dreal4/archive/4.18.03.1.tar.gz"
  sha256 "02051d9695a7395d25135901ddc1203449bf45ac653069452f43e9d615fb248e"
  
  bottle do
    root_url 'https://dl.bintray.com/dreal/homebrew-dreal'
    cellar :any
      # sha256 "17f18baccadc8055389d83d4e2a682115e8e14291cc575a4f33acf76bed2b696" => :el_capitan
      # sha256 "b9ede02afd86feefc188559ec489133e4bb2898fab1a43b7fe65ed4d4b8bf529" => :sierra
      # sha256 "83b6a76ad0b288bdd17eab535e476ff1ddcc54106a159905634c84ea7c66e07a" => :high_sierra
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
