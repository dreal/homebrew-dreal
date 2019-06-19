class KleeAT2 < Formula
  desc "Symbolic virtual machine built on top of the LLVM compiler infrastructure"
  homepage "https://klee.github.io"
  url "https://github.com/soonho-tri/klee/archive/09b00e4e57aca67e9ca02b640fe515efac367fec.zip"
  sha256 "777136b8022bec66632fb140d86796523e2466db251a3c435a093ceea009d7da"
  version "2.0"

  keg_only :versioned_formula

  # Required
  depends_on "llvm" => :build
  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DLLVM_CONFIG_BINARY=#{Formula["llvm"].opt_bin}/llvm-config", "-DENABLE_UNIT_TESTS=OFF", "-DENABLE_SYSTEM_TESTS=OFF"
      system "make", "install"
    end
  end
end
