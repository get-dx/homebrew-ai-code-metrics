# AI Code Metrics - Homebrew Tap

Official Homebrew tap for [AI Code Metrics](https://github.com/get-dx/ai-code-metrics), a tool to monitor and detect AI-generated code in your repositories.

## Installation

```bash
brew tap get-dx/ai-code-metrics
brew install aicodemetrics
```

Or install directly:

```bash
brew install get-dx/ai-code-metrics/aicodemetrics
```

## Running as a Service

Start the daemon:

```bash
brew services start aicodemetrics
```

Stop the daemon:

```bash
brew services stop aicodemetrics
```

Check status:

```bash
brew services info aicodemetrics
```

## Logs

Logs are written to:
```
/opt/homebrew/var/log/aicodemetrics.log
```

## Documentation

For more information about AI Code Metrics, visit the [main repository](https://github.com/get-dx/ai-code-metrics).
