class Dreal < Formula
  desc "SMT Solver for Nonlinear Theories of Reals"
  homepage "https://dreal.github.io"
  url "https://github.com/dreal/dreal4/archive/4.20.03.1.tar.gz"
  sha256 "023ef454b9c48f959defa727b2ec79b8f90d2dcb3c8cf1fcb1b9b1c986b3394d"
  head "https://github.com/dreal/dreal4.git"

  bottle do
    root_url "https://dl.bintray.com/dreal/homebrew-dreal"
    cellar :any
    sha256 "9f22e1da95b27470e91162c587870114d384317691a76fa24864dcb9663264ad" => :high_sierra
    sha256 "ad66fa33518bf4d209c5084b5b0047af795a032d56bfd09d5bdfa87133c42ce7" => :mojave
    sha256 "f874d5e9626895625d700543c476fd7f5dab09184c225001923b1e79cc923bba" => :catalina
  end

  # Required
  depends_on "bazelbuild/tap/bazel" => :build
  depends_on "bison"                => :build
  depends_on "flex"                 => :build
  depends_on "pkg-config"           => :build
  depends_on "python"               => :build
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
