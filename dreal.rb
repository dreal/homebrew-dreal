class Dreal < Formula
  desc "SMT Solver for Nonlinear Theories of Reals"
  homepage "https://dreal.github.io"
  head "https://github.com/dreal/dreal4.git"

  stable do
    url "https://github.com/dreal/dreal4/archive/4.18.05.3.tar.gz"
    sha256 "ea83bf28488d70606dffccade705f20c627e791496c930f9e01d9800a3daacf4"
  end

  bottle do
    root_url "https://dl.bintray.com/dreal/homebrew-dreal"
    cellar :any
    sha256 "9b9b2877c20c54694f42af3bb11a2219c5247bf18fd5c08f45bf7c8def7e34ad" => :el_capitan
    sha256 "906ebe4937092b44b45cc6301ae05866f82ad7cb82d67e0eccc498d53276bdde" => :sierra
    sha256 "a0e4ee46ae41df5b1a44987df5946c0b7ab4dcfa180547dae5e2728e04143e9e" => :high_sierra
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
