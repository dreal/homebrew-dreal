class Dreal < Formula
  desc "SMT Solver for Nonlinear Theories of Reals"
  homepage "https://dreal.github.io"
  url "https://github.com/dreal/dreal4/archive/4.19.06.3.tar.gz"
  sha256 "84ad7d1eb245f234e06ba43b2a6cd913048bea0a901d88cd99cf6e7cf0ad00ac"
  head "https://github.com/dreal/dreal4.git"

  bottle do
    root_url "https://dl.bintray.com/dreal/homebrew-dreal"
    cellar :any
    sha256 "2ef7a504a89aa4d8dd32dc5f60014a1ff01a477095edd6e4b52bf347e3c07cf0" => :sierra
    sha256 "cf7390a98655df16dd5c64019713a0ad80c0af529825f4cbfc617d70994125e2" => :high_sierra
    sha256 "d1edc119a005786d935ed549000f8b0199dd5e758fbda73d5cbac345152b6513" => :mojave
  end

  # Required
  depends_on "bazelbuild/tap/bazel" => :build
  depends_on "bison"                => :build
  depends_on "flex"                 => :build
  depends_on "pkg-config"           => :build
  depends_on "python@2"             => :build
  depends_on "dreal-deps/ibex/ibex@2.7.4"
  depends_on "nlopt"

  def install
    system "bazel", "build", "--compilation_mode=opt", "--host_force_python=PY2", "//:archive"
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
