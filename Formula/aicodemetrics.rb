class Aicodemetrics < Formula
  desc "Monitor and detect AI-generated code in your repositories"
  homepage "https://github.com/get-dx/ai-code-metrics"
  version "0.3.47"

  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/get-dx/homebrew-ai-code-metrics/releases/download/v0.3.47/aicodemetricsd-0.3.47-darwin-amd64.tar.gz"
    sha256 "343dae10e8f4a60a1424ec4f77b2bf94a0ad0d3b18ac952cf2e8edb986aa8b90"
  elsif OS.mac? && Hardware::CPU.arm?
    url "https://github.com/get-dx/homebrew-ai-code-metrics/releases/download/v0.3.47/aicodemetricsd-0.3.47-darwin-arm64.tar.gz"
    sha256 "69226fe842330bad1318915de318874d8268c581614616e9776479de8f69399f"
  end

  depends_on "watchman"

  def install
    # Install the pre-built binary
    bin.install "aicodemetricsd-darwin-amd64" => "aicodemetricsd" if Hardware::CPU.intel?
    bin.install "aicodemetricsd-darwin-arm64" => "aicodemetricsd" if Hardware::CPU.arm?
  end

  service do
    run [opt_bin/"aicodemetricsd"]
    run_at_load true
    keep_alive true
    working_dir var/"aicodemetrics"
    log_path var/"log/aicodemetrics.log"
    error_log_path var/"log/aicodemetrics.log"
    environment_variables PATH: std_service_path_env
  end

  def post_install
    # Create working directory
    (var/"aicodemetrics").mkpath
    # Create log directory
    (var/"log").mkpath
  end

  def caveats
    <<~EOS
      Logs are located at:
        #{var}/log/aicodemetrics.log
    EOS
  end

  test do
    # Test that the binary runs and shows version
    assert_match "AI Code Metrics daemon version", shell_output("#{bin}/aicodemetricsd --version 2>&1")
  end
end
