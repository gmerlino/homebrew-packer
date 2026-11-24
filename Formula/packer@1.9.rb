class PackerAT19 < Formula
  desc "Machine image builder, final MPL-2.0 release"
  homepage "https://github.com/hashicorp/packer/tree/v1.9.5"
  url "https://github.com/hashicorp/packer/archive/refs/tags/v1.9.5.tar.gz"
  sha256 "a6da3e455578f5373c5e333023a7be483e9c22f4235ccd599fe39d42df55f870"
  license "MPL-2.0"

  livecheck do
    skip "Final MPL-2.0 release; newer releases use BUSL"
  end

  keg_only :versioned_formula
  depends_on "go" => :build

  def install
    ENV["GOMAXPROCS"] = "4"
    system "go", "build", "-p", "4", *std_go_args(output: bin/"packer", ldflags: "-s -w")
    zsh_completion.install "contrib/zsh-completion/_packer"
  end

  def caveats
    <<~EOS
      This is the final MPL-2.0 Packer release, not a maintained upstream branch.
      Existing templates and plugin directories are preserved.
      Plugins have independent licenses and compatibility requirements.
    EOS
  end

  test do
    ENV["CHECKPOINT_DISABLE"] = "1"
    ENV["PACKER_CONFIG_DIR"] = testpath/"config"
    ENV["PACKER_PLUGIN_PATH"] = testpath/"plugins"
    assert_match "1.9.5", shell_output("#{bin}/packer version")
    (testpath/"migration.pkr.hcl").write <<~HCL
      source "null" "local" {
        communicator = "none"
      }
      build {
        sources = ["source.null.local"]
        provisioner "shell-local" {
          inline = ["printf 'migration-ok' > #{testpath}/result.txt"]
        }
        post-processor "manifest" {
          output = "#{testpath}/manifest.json"
        }
      }
    HCL
    system bin/"packer", "validate", testpath/"migration.pkr.hcl"
    system bin/"packer", "build", "-color=false", testpath/"migration.pkr.hcl"
    assert_equal "migration-ok", (testpath/"result.txt").read
    assert_path_exists testpath/"manifest.json"
  end
end
