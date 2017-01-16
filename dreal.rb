require "formula"

class Dreal < Formula
  homepage "http://dreal.github.io"
  url "https://github.com/dreal/dreal3.git"
  version "3.16.12"
  bottle do
    root_url 'https://dl.bintray.com/dreal/homebrew-dreal'    
    sha256 "d83aa55b6edf9c4822ed084cb75e0c343dedd50ac22ffdca29ead9e32d6a5a80" => :sierra
  end  

  # Required
  depends_on 'automake'                 => :build
  depends_on 'autoconf'                 => :build
  depends_on 'libtool'                  => :build
  depends_on 'pkg-config'               => :build
  depends_on 'objective-caml'           => :build
  depends_on 'opam'                     => :build
  depends_on 'cmake'                    => :build
  depends_on 'wget'                     => :build
  depends_on 'homebrew/science/glpk'    
  depends_on 'homebrew/science/nlopt'   
  depends_on 'coin-or-tools/coinor/clp'         

  needs :cxx11

  def install
    args = ["-DCMAKE_INSTALL_PREFIX=#{prefix}",
            "-DCMAKE_BUILD_TYPE=Release",
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
