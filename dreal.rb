class Dreal < Formula
  desc "SMT Solver for Nonlinear Theories of Reals"
  homepage "https://dreal.github.io"
  url "https://github.com/dreal/dreal4/archive/4.19.06.2.tar.gz"
  sha256 "f5f9ec1a7a4b1dd85ffdef665b25281ecf68ff17665b1915cd42d8170d704aa8"
  head "https://github.com/dreal/dreal4.git"

  bottle do
    root_url "https://dl.bintray.com/dreal/homebrew-dreal"
    cellar :any
    sha256 "b2ff0bb92790e80903ae672d692f5d9c045f5c99bf353d2eb1279e5db8eb5845" => :sierra
    sha256 "79ee92ca9182160b775990cd6d1487bf149abb778a4b509cef8aa9ddada8403a" => :high_sierra
    sha256 "f878ac1228c7eba715c923e28433434e0f032a59048837347a653302831e4605" => :mojave
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
