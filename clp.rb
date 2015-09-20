require "formula"

class Clp < Formula
  homepage "http://dreal.github.io"
  url "https://github.com/dreal-deps/clp-1.16.git"
  version "1.16.6"

  # Required
  depends_on 'automake'         => :build
  depends_on 'autoconf'         => :build
  depends_on 'libtool'          => :build
  depends_on 'pkg-config'       => :build

  def install
    mkdir 'build' do
      system "../configure LDFLAGS=-lstdc++"
      system "make", "-j", "install"
    end
  end

  test do
    system "make", "-j", "test"
  end

  def caveats; <<-EOS.undent
      clp installed.
    EOS
  end
end
