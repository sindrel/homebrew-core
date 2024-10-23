class Usbutils < Formula
  desc "List detailed info about USB devices"
  # Homepage for multiple Linux USB tools, 'usbutils' is one of them.
  homepage "http://www.linux-usb.org/"
  url "https://mirrors.edge.kernel.org/pub/linux/utils/usb/usbutils/usbutils-018.tar.gz"
  sha256 "0048d2d8518fb0cc7c0516e16e52af023e52b55ddb3b2068a77041b5ef285768"
  license all_of: [
    "GPL-2.0-only",
    "GPL-2.0-or-later",
    any_of: ["GPL-2.0-only", "GPL-3.0-only"],
  ]

  livecheck do
    url "https://mirrors.edge.kernel.org/pub/linux/utils/usb/usbutils/"
    regex(/href=.*?usbutils[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "29214690f12e4b8adb6616dd47c41b43cec827637d09c1f4dab15a255050ca68"
    sha256 cellar: :any,                 arm64_sonoma:   "374ce8a0c6782808d4fd194dbfd177c779ca568e7d5b0a5687412add96cce4ed"
    sha256 cellar: :any,                 arm64_ventura:  "735a4d7ec2d7393bb3421c27583f1df30455c5a4c3b092786dfe3ee92144806e"
    sha256 cellar: :any,                 arm64_monterey: "eabe8a0f9cee89292386b2b0900677127c8827882bf43323dfb732013d6a2f1a"
    sha256 cellar: :any,                 sonoma:         "3c3468d2b41346db49f356b1f0ab04e86bfbcc93954bbcfc2c343c6fbd720eaa"
    sha256 cellar: :any,                 ventura:        "1c2b43d31059a4b67815be116ab308817487a9f06d670244a2a234a023851d93"
    sha256 cellar: :any,                 monterey:       "6a760ee183985a6d80d58efe5e78c945511c3b89cce5e01bfb48858637fdb322"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17f5961f3ebd783d33e4851654070498c44c65c2bf235754ce8dcd704063dcaa"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"

  on_linux do
    depends_on "systemd"
  end

  conflicts_with "lsusb", "lsusb-laniksj", because: "both provide an `lsusb` binary"

  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/24a6945778381a62ecdcc1d78bcc16b9f86778c1/usbutils/portable.patch"
    sha256 "ec09531017e1fa45dbc37233b286a736a24d7f98668e38a92e3697559f739c7f"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def caveats
    <<~EOS
      usbhid-dump requires either proper code signing with com.apple.vm.device-access
      entitlement or root privilege
    EOS
  end

  test do
    assert_empty shell_output("#{bin}/lsusb -d ffff:ffff", 1)
  end
end
