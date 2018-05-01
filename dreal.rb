class Dreal < Formula
  desc "SMT Solver for Nonlinear Theories of Reals"
  homepage "https://dreal.github.io"
  head "https://github.com/dreal/dreal4.git"

  stable do
    url "https://github.com/dreal/dreal4/archive/4.18.04.1.tar.gz"
    sha256 "69b668a2d9b8a5e0e192318b7716e14e40c96f9b907ff8895b4d09ed10d130a3"
  end

  bottle do
    root_url "https://dl.bintray.com/dreal/homebrew-dreal"
    cellar :any
    sha256 "d1f580648f0838d48f8eff0f8864fd609d8c6f6d755b84d19177de5b61cdba1d" => :el_capitan
    sha256 "3e540d0aa3db5c3e194cc5297792d3f5461058801503723e65a6b9560bf0d851" => :sierra
    sha256 "0d71a2cd62cf63f5a7766543b42cf9035267db10cbf9f4663b7db2e2bbf9d84f" => :high_sierra
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
