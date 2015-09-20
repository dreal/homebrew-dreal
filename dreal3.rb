require "formula"

class Dreal < Formula
  homepage "http://dreal.github.io"
  url "https://github.com/soonhokong/dreal3.git"
  version "3.15.08-gitc8002152874ff32df70996c85addbece29b84395"

##BOTTLE_COMMENT##  bottle do
##BOTTLE_COMMENT##    root_url 'https://soonhokong.github.io/homebrew-dreal3'
##BOTTLE_COMMENT##    sha1 '##BOTTLE_YOSEMITE_HASH##' => :yosemite
##BOTTLE_COMMENT##    sha1 '##BOTTLE_MAVERICKS_HASH##' => :mavericks
##BOTTLE_COMMENT##  end

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

  # If this formula conflicts with another one:
  conflicts_with "dreal", :because => "please remove dreal to install dreal3"

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