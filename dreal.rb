class Dreal < Formula
  desc "SMT Solver for Nonlinear Theories of Reals"
  homepage "https://dreal.github.io"
  url "https://github.com/dreal/dreal4/archive/4.18.07.1.tar.gz"
  sha256 "c04d5b0f2b2378ee7689f5a8401c606dc6c73636a860d48d74f5d27e1b9950c5"

  bottle do
    root_url "https://dl.bintray.com/dreal/homebrew-dreal"
    cellar :any
    sha256 "6806b90be6c84988cfe8ab1f1286ff2415546ec80ac0536063e7dbdb3210e38e" => :el_capitan
    sha256 "decfdbf715d1d811b3f2d42e583a3966a09097da4de89b9a546a3649b434ae81" => :sierra
    sha256 "7cae6919420694302e6a07a8407d5bb75de54815f34aec731d613f425783b47f" => :high_sierra
  end

  # Required
  depends_on "bazelbuild/tap/bazel" => :build
  depends_on "pkg-config"           => :build
  depends_on "python@2"             => :build
  depends_on "dreal-deps/ibex/ibex@2.6.5"
  depends_on "nlopt"

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
