class Keploy < Formula
  desc "Testing Toolkit creates test-cases and data mocks from API calls, DB queries"
  homepage "https://keploy.io"
  url "https://github.com/keploy/keploy/archive/refs/tags/v2.4.13.tar.gz"
  sha256 "47f1d1681d18b3ebe489a2ceb37448b3c76a46b4cfeb39572e186973a0401ad1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bbbd6f97c33cf6239cc4f0c6e9a441f0b6c72b393b31177dda690f83a84f99bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbbd6f97c33cf6239cc4f0c6e9a441f0b6c72b393b31177dda690f83a84f99bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bbbd6f97c33cf6239cc4f0c6e9a441f0b6c72b393b31177dda690f83a84f99bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "37148109db39888be47e5e070e637b994565640a1ea2cef679a4066bafdc3344"
    sha256 cellar: :any_skip_relocation, ventura:       "37148109db39888be47e5e070e637b994565640a1ea2cef679a4066bafdc3344"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54b16ce86cb2967cb46270f90ad1d0bc433ac185b3fd06f1e31f77534be3cfc7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    system bin/"keploy", "config", "--generate", "--path", testpath
    assert_match "# Generated by Keploy", (testpath/"keploy.yml").read

    output = shell_output("#{bin}/keploy templatize --path #{testpath}")
    assert_match "No test sets found to templatize", output

    assert_match version.to_s, shell_output("#{bin}/keploy --version")
  end
end
