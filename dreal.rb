class Dreal < Formula
  desc "SMT Solver for Nonlinear Theories of Reals"
  homepage "https://dreal.github.io"
  head "https://github.com/dreal/dreal4.git"

  stable do
    url "https://github.com/dreal/dreal4/archive/4.18.03.3.tar.gz"
    sha256 "b1747eab3e498ad33e8703d8e29fb1986a2125cc4b1e4c7f11c8a39a134d7a31"
  end

  bottle do
    root_url "https://dl.bintray.com/dreal/homebrew-dreal"
    cellar :any
    sha256 "27e68d0f3badb325db4f1feec04c2eefea1b4682f70bd459c073edb29bbae762" => :el_capitan
    sha256 "8ef811ce2a175fbaafaa9de534fd9c897abe0634471e4a97e72ad9d48819949d" => :sierra
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
    (testpath/"01.smt2").write <<~EOS
      (set-logic QF_NRA)
      (declare-fun x () Real)
      (declare-fun y () Real)
      (assert (< 2.4 x))
      (assert (< x 2.6))
      (assert (< -10.0 y))
      (assert (< y 10.0))
      (assert (= y (cos x)))
      (check-sat)
      (exit)
    EOS
    system "#{bin}/dreal", "#{testpath}/01.smt2"
  end
end
