class Aicodemetrics < Formula
  desc "Monitor and detect AI-generated code in your repositories"
  homepage "https://github.com/get-dx/ai-code-metrics"
  version "0.3.40"

  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/get-dx/homebrew-ai-code-metrics/releases/download/v0.3.40/aicodemetricsd-0.3.40-darwin-amd64.tar.gz"
    sha256 "9915598d538f7439a2a04a4bff72d3045d34fc72ef878b4ac4552dbd932745e9"
  elsif OS.mac? && Hardware::CPU.arm?
    url "https://github.com/get-dx/homebrew-ai-code-metrics/releases/download/v0.3.40/aicodemetricsd-0.3.40-darwin-arm64.tar.gz"
    sha256 "ab5e5ef39b7a79d27f64d1f2835310e0db74d9efec3c11720059a8cca18061ff"
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
