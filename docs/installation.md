# Installation

ACDD can be installed and used in several ways to fit your development workflow.

## Prerequisites

- Python 3.11 or higher
- Git
- A supported AI assistant (Claude, Copilot, Cursor, etc.)

## Install via UV (Recommended)

The recommended way to install ACDD is using UV, a fast Python package manager:

```bash
uvx --from git+https://github.com/Nom-nom-hub/acdd-kit.git acdd init <PROJECT_NAME>
```

Or install globally:

```bash
uv tool install acdd-cli --from git+https://github.com/Nom-nom-hub/acdd-kit.git
acdd init <PROJECT_NAME>
```

## Manual Installation

1. Clone the ACDD repository
2. Install the CLI tool locally
3. Initialize your project

## Supported AI Agents

ACDD supports all major AI coding assistants:

- GitHub Copilot
- Claude Code
- Cursor
- Gemini
- And more

After installation, you'll have access to the full ACDD command set for your chosen AI assistant.
