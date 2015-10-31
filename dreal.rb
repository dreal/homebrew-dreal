require "formula"

class Dreal < Formula
  homepage "http://dreal.github.io"
  url "https://github.com/dreal/dreal3.git"
  version "3.15.10.06"

  bottle do
    root_url 'https://dreal.github.io/homebrew-dreal'
    sha256 "c7b2f3e8a9c3e9c09e24458b30f904f3f3afbc0c9a14ad3d3c280e3474ef16ff" => :yosemite
    sha256 "a6e96589cdb013f4400b75bbca1dccd509b569b07047a4784e0d39ea678ff64a" => :el_capitan
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
