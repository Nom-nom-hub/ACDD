# Local Development

This guide shows how to iterate on the ACDD CLI locally without publishing a release or committing to `main` first.

## Quick Test Run

For quick testing without installing:

```bash
python -m src.acdd_cli --help
python -m src.acdd_cli init demo-project --ai claude --ignore-agent-tools --script sh
```

Or for PowerShell:

```bash
python src/acdd_cli/__init__.py init demo-project --script ps
```

## Install in Development Mode

Install your local version as an editable install:

```bash
# Install in development mode
uv pip install --editable .

# Now 'acdd' entrypoint is available
acdd --help
```

## Test with UV

Use UV to test from the local directory:

```bash
uvx --from . acdd init demo-uvx --ai copilot --ignore-agent-tools --script sh
```

## Test from Git Branch

Test from a local branch:

```bash
uvx --from git+https://github.com/Nom-nom-hub/ACDD@your-feature-branch acdd init demo-branch-test --script ps
```

## Using Environment Variable

If you're working on a local copy:

```bash
export SPEC_KIT_SRC="/path/to/your/acdd/source"
uvx --from "$SPEC_KIT_SRC" acdd --help
uvx --from "$SPEC_KIT_SRC" acdd init demo-env --ai copilot --ignore-agent-tools --script ps
```

## Shell Alias for Development

Create a shell alias to test your development version:

```bash
acdd-dev() { uvx --from /path/to/acdd/source acdd "$@"; }
acdd-dev --help
```

## Running Tests

If you have tests in your ACDD implementation:

```bash
python -m pytest tests/
```

## Version Management

Remember to update the version in `pyproject.toml` when you make significant changes:

- Update version number following semantic versioning
- Add notes to CHANGELOG.md
- Ensure all tests pass before publishing

## Troubleshooting

If you encounter issues:

1. Check that your Python version is 3.11 or higher
2. Ensure dependencies are properly installed
3. Verify that the entry point is correctly configured in pyproject.toml
4. Check that scripts have proper execute permissions
