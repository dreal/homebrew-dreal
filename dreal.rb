 class Dreal < Formula
  desc "SMT Solver for Nonlinear Theories of Reals"
  homepage "https://dreal.github.io"
  url "https://github.com/dreal/dreal4/archive/4.19.04.1.tar.gz"
  sha256 "c53b39f7babe0e85e6534eb815f92681be40da10e5a636daaa274efb2dc2554d"
  head "https://github.com/dreal/dreal4.git"

  bottle do
    root_url "https://dl.bintray.com/dreal/homebrew-dreal"
    cellar :any
    sha256 "f01da483e48b97aa91a3c3c0f04e5d0f3e8aa4cbdeacb080a437eb5e26398cc2" => :sierra
    sha256 "95fa10a19fc83f79fdb18c648b0f897780d4a5df9c86744e5fd9ab9bca3bce7f" => :high_sierra
    sha256 "6906258cde7046072aef91d10c9affb5ca5367c1b7fabe8ec921f3dce07b3efc" => :mojave
  end

  # Required
  depends_on "bazelbuild/tap/bazel" => :build
  depends_on "pkg-config"           => :build
  depends_on "python@2"             => :build
  depends_on "dreal-deps/ibex/ibex@2.7.4"
  depends_on "nlopt"

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
