class Aicodemetrics < Formula
  desc "Monitor and detect AI-generated code in your repositories"
  homepage "https://github.com/get-dx/ai-code-metrics"
  version "0.3.15"

  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/get-dx/homebrew-ai-code-metrics/releases/download/v0.3.15/aicodemetricsd-0.3.15-darwin-amd64.tar.gz"
    sha256 "e38b5cc0df263bc082e7613487fb1d1d699f2e2b187c0ce2b8d828c854969a6c"
  elsif OS.mac? && Hardware::CPU.arm?
    url "https://github.com/get-dx/homebrew-ai-code-metrics/releases/download/v0.3.15/aicodemetricsd-0.3.15-darwin-arm64.tar.gz"
    sha256 "80cd28fb44213aec83b0d1a578299362529b3475ee1a4c75addc1f662bccb76a"
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
