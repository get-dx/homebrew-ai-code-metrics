class Aicodemetrics < Formula
  desc "Monitor and detect AI-generated code in your repositories"
  homepage "https://github.com/get-dx/ai-code-metrics"
  url "https://github.com/get-dx/ai-code-metrics/archive/refs/tags/v0.3.5.tar.gz"
  sha256 "0019dfc4b32d63c1392aa264aed2253c1e0c2fb09216f8e2cc269bbfb8bb49b5"

  depends_on "go" => :build

  def install
    # Build the binary with version information
    ldflags = "-X main.BuildTime=#{time.iso8601} -X main.GitCommit=#{version}"
    system "go", "build", "-ldflags", ldflags, "-o", "aicodemetricsd", "./cmd/aicodemetricsd"

    # Install the binary
    bin.install "aicodemetricsd"
  end

  service do
    run [opt_bin/"aicodemetricsd"]
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

  test do
    # Test that the binary runs and shows version
    assert_match "AI Code Metrics daemon version", shell_output("#{bin}/aicodemetricsd --version 2>&1")
  end
end
