# typed: false
# frozen_string_literal: true

class Dreal < Formula
  VERSION = "4.21.06.2"
  desc "SMT Solver for Nonlinear Theories of Reals"
  homepage "https://dreal.github.io"
  url "https://github.com/dreal/dreal4/archive/#{VERSION}.tar.gz"
  sha256 "7bbd328a25c14cff814753694b1823257bb7cff7f84a7b705b9f111624d5b2e4"
  head "https://github.com/dreal/dreal4.git"

  bottle do
    root_url "https://github.com/dreal/dreal4/releases/download/#{VERSION}"
    sha256 cellar: :any, mojave: "6a3c2fb758d24d93fb5db90eb3d0d5c0aa7a3e78845ae157e601a8b63b7d5188"
    sha256 cellar: :any, catalina: "898227b6fd230665f99e3581a090f4f96fce339df83a141f8f0737eacf695f92"
    sha256 cellar: :any, big_sur: "76b3dcf38338d02653c841ce223a7d6ebd910c00984a4f78a0f13147022ad5f6"
  end

  # Required
  depends_on "bazel"                => :build
  depends_on "bison"                => :build
  depends_on "flex"                 => :build
  depends_on "pkg-config"           => :build
  depends_on "python"               => :build
  depends_on "robotlocomotion/director/ibex@2.7.4"
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
