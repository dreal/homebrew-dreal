class Dreal < Formula
  desc "SMT Solver for Nonlinear Theories of Reals"
  homepage "https://dreal.github.io"
  url "https://github.com/dreal/dreal4/archive/4.18.10.1.tar.gz"
  sha256 "919db0574c3488e4a744181bf3b480f827756c9528cbe2f0c7ffa29f2ebf89e8"

  bottle do
    root_url "https://dl.bintray.com/dreal/homebrew-dreal"
    cellar :any
    sha256 "168c1c50c7b24bacbb0b07f712ab296645d4317a4cb52f834316c25364955785" => :sierra
    sha256 "536683b496c7c8bd66d20d33f903d4fff343f1131145e5a67c8164453ed0770c" => :high_sierra
    sha256 "3dac59301d3611b4fdd08d6a336ee4f148eb1ac8ec76c0cf309e5d0c2ff758ab" => :mojave
  end

  # Required
  depends_on "bazelbuild/tap/bazel" => :build
  depends_on "pkg-config"           => :build
  depends_on "python@2"             => :build
  depends_on "dreal-deps/ibex/ibex@2.7.2"
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
