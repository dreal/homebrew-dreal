require "formula"

class Dreal < Formula
  homepage "http://dreal.github.io"
  url "https://github.com/soonhokong/dreal.git"
  version "2.15.01-git86bae161414d88776d53d23906f5ab76594e3fcc"

  bottle do
    root_url 'https://dreal.github.io/homebrew-dreal'
    sha1 '96bfdd326996f2ea6b6bd1246a998409d53190f1' => :yosemite
    sha1 '635648078fc7ece6328caa9cd1b1a31f71876019' => :mavericks
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
  depends_on 'google-perftools' => :optional

  def install
    args = ["-DCMAKE_INSTALL_PREFIX=#{prefix}",
            "-DCMAKE_BUILD_TYPE=Release"]
    mkdir 'build' do
      # Compile tools (Ocaml)
      if ! Dir.exists?(ENV['HOME'] + "/.opam")
          system "opam", "init", "--yes"
      end
      # system "opam", "switch", "4.02.1"
      # ENV['PATH'] = ENV['HOME'] + "/.opam/4.02.1/bin" + ":" + ENV['PATH']
      ENV['PATH'] = ENV['HOME'] + "/.opam/system/bin" + ":" + ENV['PATH']
      puts "PATH= " + ENV['PATH']
      system "opam", "install", "--yes", "oasis", "batteries", "ocamlfind"
      system "make", "-C", "../tools", "setup.ml", "setup.data"
      system "make", "-C", "../tools"
      # Compile dReal (C++)
      system "cmake", "../src", *args
      system "make", "-j"
      system "make", "-j", "install"
    end
  end

  test do
    system "make", "-j", "test"
  end

  def caveats; <<-EOS.undent
      dReal installed.
    EOS
  end
end
