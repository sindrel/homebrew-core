class TailwindcssLanguageServer < Formula
  desc "LSP for TailwindCSS"
  homepage "https://github.com/tailwindlabs/tailwindcss-intellisense/tree/HEAD/packages/tailwindcss-language-server"
  url "https://github.com/tailwindlabs/tailwindcss-intellisense/archive/refs/tags/v0.14.9.tar.gz"
  sha256 "2616d7da876b9b81ded4db27f4e2e25831a042877c80c0f24c3d796ab71fac89"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/@tailwindcss/language-server/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1461f7a7c4486c588d19e2a4377e902a27b04d1fbc92c2c163ec97daf1c41b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1461f7a7c4486c588d19e2a4377e902a27b04d1fbc92c2c163ec97daf1c41b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b1461f7a7c4486c588d19e2a4377e902a27b04d1fbc92c2c163ec97daf1c41b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1461f7a7c4486c588d19e2a4377e902a27b04d1fbc92c2c163ec97daf1c41b7"
    sha256 cellar: :any_skip_relocation, ventura:       "b1461f7a7c4486c588d19e2a4377e902a27b04d1fbc92c2c163ec97daf1c41b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b95d765188c0d530caa4c9631064ebab2c883c0927c639fcb063bf618269154a"
  end

  depends_on "pnpm@9" => :build
  depends_on "node"

  def install
    cd "packages/tailwindcss-language-server" do
      system "pnpm", "install", "--frozen-lockfile"
      system "pnpm", "run", "build"
      bin.install "bin/tailwindcss-language-server"
    end
  end

  test do
    require "open3"

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON

    Open3.popen3(bin/"tailwindcss-language-server", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
