class Aicodemetrics < Formula
  desc "Monitor and detect AI-generated code in your repositories"
  homepage "https://github.com/get-dx/ai-code-metrics"
  version "0.3.21"

  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/get-dx/homebrew-ai-code-metrics/releases/download/v0.3.21/aicodemetricsd-0.3.21-darwin-amd64.tar.gz"
    sha256 "4b8ff636fb19959bcd95ece97c65ea7796099666f86f8fe8ce731c88448b38e4"
  elsif OS.mac? && Hardware::CPU.arm?
    url "https://github.com/get-dx/homebrew-ai-code-metrics/releases/download/v0.3.21/aicodemetricsd-0.3.21-darwin-arm64.tar.gz"
    sha256 "fc49bf7b1794cb66d7debdde58f13fcb7c1df0ac6544917d7621eaa906785942"
  end

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
