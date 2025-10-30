class Aicodemetrics < Formula
  desc "Monitor and detect AI-generated code in your repositories"
  homepage "https://github.com/get-dx/ai-code-metrics"
  version "0.3.7"

  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/get-dx/ai-code-metrics/releases/download/v0.3.7/aicodemetricsd-0.3.7-darwin-amd64.tar.gz"
    sha256 "b9016cbe2f60565ed0e6e9f3757cbc7ec44f0ee15d1b89ae63d1708e9b698f9d"
  elsif OS.mac? && Hardware::CPU.arm?
    url "https://github.com/get-dx/ai-code-metrics/releases/download/v0.3.7/aicodemetricsd-0.3.7-darwin-arm64.tar.gz"
    sha256 "3ec09172128c98f80b18e541fbc40ad45cba870ca2e65ed1a157465233dac93e"
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
      To start the AI Code Metrics daemon now and at login:
        brew services start aicodemetrics

      Or, to start it now without auto-restart on login:
        #{opt_bin}/aicodemetricsd

      Logs are located at:
        #{var}/log/aicodemetrics.log
    EOS
  end

  test do
    # Test that the binary runs and shows version
    assert_match "AI Code Metrics daemon version", shell_output("#{bin}/aicodemetricsd --version 2>&1")
  end
end
