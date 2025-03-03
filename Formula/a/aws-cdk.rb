class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1002.0.tgz"
  sha256 "77f55c7552501d87e052ed09b25f0bc78f71f296aa44682f53200b7ba0b9c5ef"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f3c100dcd3ef1100fdcd89027a1b2cbec7d9e9abc59f794392eebf25d1a06ce8"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    # `cdk init` cannot be run in a non-empty directory
    mkdir "testapp" do
      shell_output("#{bin}/cdk init app --language=javascript")
      list = shell_output("#{bin}/cdk list")
      cdkversion = shell_output("#{bin}/cdk --version")
      assert_match "TestappStack", list
      assert_match version.to_s, cdkversion
    end
  end
end
