require "formula"

class Dreal < Formula
  homepage "http://dreal.github.io"
  url "https://github.com/dreal/dreal3.git"
  version "3.15.11.02"

  bottle do
    root_url 'https://dl.bintray.com/dreal/homebrew-dreal'
    sha256 "b3f0163e0c9ee63537383589a294ff1ef580271d5b17d159f7970e128a118a02" => :yosemite
    sha256 "29d8af07e0caa02771b1397b5ab72e672b9e42929fc51d5097a6cf7bfcdc6dcb" => :el_capitan
  end

  # Required
  depends_on 'gcc'
  depends_on 'automake'         => :build
  depends_on 'autoconf'         => :build
  depends_on 'libtool'          => :build
  depends_on 'pkg-config'       => :build
  depends_on 'objective-caml'   => :build
  depends_on 'opam'             => :build
  depends_on 'cmake'            => :build
  depends_on 'wget'             => :build
  depends_on 'ninja'            => :build
  depends_on 'google-perftools' => :optional

  def install
    args = ["-DCMAKE_INSTALL_PREFIX=#{prefix}",
            "-DCMAKE_BUILD_TYPE=Release"]
    mkdir 'build' do
      # Compile tools (Ocaml)
      if ! Dir.exists?(ENV['HOME'] + "/.opam")
          system "opam", "init", "--yes"
      end
      # Compile dReach(OCaml)
      ENV['PATH'] = ENV['HOME'] + "/.opam/system/bin" + ":" + ENV['PATH']
      puts "PATH= " + ENV['PATH']
      system "opam", "install", "--yes", "oasis", "batteries", "ocamlfind"
      system "make", "-C", "../tools", "setup.ml", "setup.data"
      system "make", "-C", "../tools"
      # Compile dReal (C++)
      system "cmake", "-GNinja", "../src", *args
      system "ninja", "-j1"
      system "ninja", "install"
    end
  end

  test do
    system "ninja", "test"
  end

  def caveats; <<-EOS.undent
      dReal installed.
    EOS
  end
end
