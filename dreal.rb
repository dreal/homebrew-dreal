class Dreal < Formula
  desc "SMT Solver for Nonlinear Theories of Reals"
  homepage "https://dreal.github.io"
  head "https://github.com/dreal/dreal4.git"

  stable do
    url "https://github.com/dreal/dreal4/archive/4.18.05.1.tar.gz"
    sha256 "dec2ac698bd60af171c3f597749b591d03c10db719ad7c949e4c80fdb6b60cc6"
  end

  bottle do
    root_url "https://dl.bintray.com/dreal/homebrew-dreal"
    cellar :any
    sha256 "4738f071f21d17276dba702133011fc959db738322d81a7b029383eacd07e1bf" => :el_capitan
    sha256 "f9073805e53d947925d9f489ebc234f13ce24d183b3cc2e0f3e117e9294ab621" => :sierra
    sha256 "582f75926b41bb02b9f1f1d091b9bf0ffce3d1dff3186861ee906bc6fcf3a19e" => :high_sierra
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
