class Dreal < Formula
  desc "SMT Solver for Nonlinear Theories of Reals"
  homepage "https://dreal.github.io"
  url "https://github.com/dreal/dreal4/archive/4.18.11.1.tar.gz"
  sha256 "6335f3c359f469c8e88205ef92a58eb3685745399dcccdbb95bef4981275d18f"
  head "https://github.com/dreal/dreal4.git"

  bottle do
    root_url "https://dl.bintray.com/dreal/homebrew-dreal"
    cellar :any
    sha256 "769ce4cfddaaa2cb209bd95eb6b0d5df142740945e4255e0c2e2ea50559db238" => :sierra
    sha256 "2f3d7cd89e99233578a77a34bdf3ffb9e7a2014e49f7b96004305d17da0db450" => :high_sierra
    sha256 "abb8ab83c5b438b4f63db58ebad8ba23e733e9e0e90e905d18c2f01cbc87f483" => :mojave
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
