class Dreal < Formula
  desc "SMT Solver for Nonlinear Theories of Reals"
  homepage "https://dreal.github.io"
  url "https://github.com/dreal/dreal4/archive/4.20.09.1.tar.gz"
  sha256 "e5fa7c0acd6e0f259507476fd58973e3f5ef0baa741a7a34909076aebd25044a"
  head "https://github.com/dreal/dreal4.git"

  bottle do
    root_url "https://dl.bintray.com/dreal/homebrew-dreal"
    cellar :any
    sha256 "806c1397c2523c9091fd87c8ac6d5a3d319ca8c1ed999dd3f9bf777032a55ee0" => :high_sierra
    sha256 "267d41d00bad1694d9c24c826a670ae8a5074ce736d89a1da0e72199bef2b61b" => :mojave
    sha256 "6242e89c780ce30c33ba8fb562a89e4f46be6e1736ee47455b21df55dbfc95de" => :catalina
    sha256 "e36b5953a50a3d3d391f2e0b6c7ff38187d1dae02a5dda223a8ef8e1f4efd986" => :big_sur
  end

  # Required
  depends_on "bazel"                => :build
  depends_on "bison"                => :build
  depends_on "flex"                 => :build
  depends_on "pkg-config"           => :build
  depends_on "python"               => :build
  depends_on "dreal-deps/ibex/ibex@2.7.4"
  depends_on "gmp"
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
