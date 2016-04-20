require "formula"

class Dreal < Formula
  homepage "http://dreal.github.io"
  url "https://github.com/dreal/dreal3.git"
  version "3.16.04.20160419143802.gitad0cea2bc9458e4b1ed5df88082d89121f04aab8"

  bottle do
    root_url 'https://dl.bintray.com/dreal/homebrew-dreal'
    sha256 'db8d783da7fd58f40ece5bf8072f8f7164b0af21b47563922417685bb90586d5' => :el_capitan
    sha256 '7f7f8b6d1623455972fe2823ee48c161483108062b88e1f7f272c5ca6752bc0c' => :yosemite
  end

  # Required
  depends_on 'automake'         => :build
  depends_on 'autoconf'         => :build
  depends_on 'libtool'          => :build
  depends_on 'pkg-config'       => :build
  depends_on 'objective-caml'   => :build
  depends_on 'opam'             => :build
  depends_on 'cmake'            => :build
  depends_on 'wget'             => :build
  depends_on 'homebrew/versions/llvm38' => :build

  needs :cxx11

  def install
    args = ["-DCMAKE_INSTALL_PREFIX=#{prefix}",
            "-DCMAKE_BUILD_TYPE=Release",
            "-DCMAKE_CXX_COMPILER=/usr/local/bin/clang++-3.8",
            "-DCMAKE_C_COMPILER=/usr/local/bin/clang-3.8",
            "-DTCMALLOC=OFF"]
    mkdir 'build' do
      # Compile tools (Ocaml)
      if ! Dir.exists?(ENV['HOME'] + "/.opam")
          system "opam", "init", "--yes"
      end
      ENV['PATH'] = ENV['HOME'] + "/.opam/system/bin" + ":" + ENV['PATH']
      puts "PATH= " + ENV['PATH']
      system "opam", "install", "--yes", "oasis", "batteries", "ocamlfind"
      system "make", "-C", "../tools", "setup.ml", "setup.data"
      system "make", "-C", "../tools"
      # Compile dReal (C++)
      system "cmake", "../src", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "make", "test"
  end

  def caveats; <<-EOS.undent
      dReal installed.
    EOS
  end
end
