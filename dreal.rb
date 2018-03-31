class Dreal < Formula
  desc "SMT Solver for Nonlinear Theories of Reals"
  homepage "https://dreal.github.io"
  url "https://github.com/dreal/dreal4/archive/4.18.03.3.tar.gz"
  sha256 "b1747eab3e498ad33e8703d8e29fb1986a2125cc4b1e4c7f11c8a39a134d7a31"
  head "https://github.com/dreal/dreal4.git"

  bottle do
    root_url "https://dl.bintray.com/dreal/homebrew-dreal"
    cellar :any
    # sha256 "a2a8aef14e0f16768331fde0e4969fd80bd8b9a6aa1f1e6f1c80bb606aaf27c4" => :el_capitan
    # sha256 "7d91cbfbff01c448ea9eaecd041ddc31f596d88796a58294fff2107db5966baa" => :sierra
    sha256 "2c93fc75d374187b7b917f8cac8031448a02925b95acedd810aeee18df3935fb" => :high_sierra
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
