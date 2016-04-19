require "formula"

class Dreal < Formula
  homepage "http://dreal.github.io"
  url "https://github.com/dreal/dreal3.git"
  version "3.16.04.20160419140341.git03da8aca282fca4f60c91a2fc4fdf4c3babc7fbd"

  bottle do
    root_url 'https://dl.bintray.com/dreal/homebrew-dreal'
    sha1 '411775891e704083be3c567ad6159e6567a11d00eb7ac1bcf75de34eb091ad0f' => :el_capitan
    sha1 '1478cfccf8097b6b7148741b2f3653731f6733d62f005582f8e015b10613e85f' => :yosemite
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
  depends_on 'google-perftools' => :optional

  needs :cxx11

  def install
    args = ["-DCMAKE_INSTALL_PREFIX=#{prefix}",
            "-DCMAKE_BUILD_TYPE=Release",
            "-DCMAKE_CXX_COMPILER=/usr/local/bin/clang++-3.8",
            "-DCMAKE_C_COMPILER=/usr/local/bin/clang-3.8"]
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
