class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.18.09.tar.gz"
  sha256 "0694f2c24eb5d839fe11f41adc2c0ea31bb7e9c1a53316fc251847d1d55f6344"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53ef65541fc184f5c5dee7a2ca141080c0f64c9f04b8bc5e03b3391beccd5cdb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38891a8854d5a855ef54bcac2f69c912c806738a8dfd8389ce8cf5b23b79493a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a96b0a45b02440351f6230d1aeb7990aa30f26dc364d1e87b391706c10068a38"
    sha256 cellar: :any_skip_relocation, sonoma:        "528299090a15bc13d1f4db0c0e05213d90bf7dab5834beaa9d4dd4d8f1e9b38e"
    sha256 cellar: :any_skip_relocation, ventura:       "924c0a7fea042a7d94f8c73f05ebbaaa20b08e2ac434525873754be31580fa4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6774694091270608b9d5d2f81c8c0a139e5d6c4b2efe3a42314a439ad94ffac9"
  end

  depends_on macos: :sierra

  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  def install
    inreplace "Makefile" do |s|
      s.gsub! "/usr", prefix
      s.change_make_var! "BASHDIR", prefix/"etc/bash_completion.d"
    end
    system "make"
    system "make", "install"
    bash_completion.install "bash-completion/stress-ng"
  end

  test do
    output = shell_output("#{bin}/stress-ng -c 1 -t 1 2>&1")
    assert_match "successful run completed", output
  end
end
