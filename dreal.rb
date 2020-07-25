class Dreal < Formula
  desc "SMT Solver for Nonlinear Theories of Reals"
  homepage "https://dreal.github.io"
  url "https://github.com/dreal/dreal4/archive/4.20.07.1.tar.gz"
  sha256 "3189120cae9f750c2cce981ec823f91c83cb5f2ba2d8c71b03cab74f89d31d72"
  head "https://github.com/dreal/dreal4.git"

  bottle do
    root_url "https://dl.bintray.com/dreal/homebrew-dreal"
    cellar :any
    sha256 "cfd4441757e9e5de00ff85dd4f1c852b1eb6d1a7a7389cdda32de6ad78ed8709" => :high_sierra
    sha256 "1252d9b523553a081417b8567e1f02009e99e70b9be8c1992f03013a051bf640" => :mojave
    sha256 "d6d5105bb67b2ba6cfe5ab0e30b5dc2098a2173f141d75aed63aebdd8e1c82dd" => :catalina
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
