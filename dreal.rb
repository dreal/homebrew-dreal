class Dreal < Formula
  desc "SMT Solver for Nonlinear Theories of Reals"
  homepage "https://dreal.github.io"
  url "https://github.com/dreal/dreal4/archive/4.18.03.2.tar.gz"
  sha256 "532a5392db7e106a5160948b4b97fb3bcdd0779c19369dc557693513830d5427"

  bottle do
    root_url "https://dl.bintray.com/dreal/homebrew-dreal"
    cellar :any
    # sha256 "a2a8aef14e0f16768331fde0e4969fd80bd8b9a6aa1f1e6f1c80bb606aaf27c4" => :el_capitan
    # sha256 "7d91cbfbff01c448ea9eaecd041ddc31f596d88796a58294fff2107db5966baa" => :sierra
    # sha256 "982039daa4e63c9c6b76ac54c5acfb6944e7054574cafb370b9636f2ed2b9590" => :high_sierra
  end

  # Required
  depends_on "bazel"                => :build
  depends_on "pkg-config"           => :build
  depends_on "python@2"             => :build
  depends_on "nlopt"
  depends_on "dreal-deps/ibex/ibex@2.6.5"

  needs :cxx14

  def install
    system "bazel", "build", "--compilation_mode=opt", "//:archive"
    # files in archive.tar.gz have `./opt/dreal/<version>` prefix
    # (4-level). It uncompresses files at #{prefix} whil stripping the
    # prefix.
    system "tar", "xvf", "bazel-bin/archive.tar.gz", "--strip-components", "4", "-C", prefix.to_s
    inreplace "#{lib}/pkgconfig/dreal.pc", "HOMEBREW_PREFIX", HOMEBREW_PREFIX.to_s
  end

  test do
    system "#{bin}/dreal"
  end
end
