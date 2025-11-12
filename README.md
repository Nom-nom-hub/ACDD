# Adaptive Context-Driven Development (ACDD) Kit

**ACDD** (Adaptive Context-Driven Development) is an evolution of specification-driven development that incorporates continuous learning and adaptation into the development process. Unlike traditional specification-driven approaches, ACDD includes unique learning and adaptation phases that continuously improve the development methodology based on real-world implementation experience.

## Core Principles

### Living Context Model

- Context is multidimensional and evolving, not static
- Team patterns, architecture decisions, metrics, and preferences are continuously updated
- Knowledge from past features directly improves future development

### Continuous Learning

- Every feature contributes to organizational learning
- Outcomes are systematically analyzed and documented
- Pattern effectiveness is continuously measured

### Adaptive Methodology

- Development approach evolves based on evidence
- Patterns are refined and updated based on usage outcomes
- Team capabilities and preferences are tracked and leveraged

## The 9-Phase Workflow

ACDD extends the traditional specification-driven approach with two additional phases:

1. **Constitution** - Establish project principles and context
2. **Specify** - Define requirements with context awareness
3. **Clarify** - Resolve specification ambiguities
4. **Plan** - Create implementation plan referencing patterns
5. **Analyze** - Cross-artifact consistency check
6. **Tasks** - Break plan into actionable tasks
7. **Implement** - Execute implementation
8. **Learn** - Analyze outcomes and capture learnings *(ACDD-specific)*
9. **Adapt** - Update patterns and methodology *(ACDD-specific)*

The unique **Learn** and **Adapt** phases create feedback loops that continuously improve the development process based on evidence from completed implementations.

## Getting Started

### Prerequisites

- Python 3.11+
- Git
- A supported AI coding assistant (Claude, Copilot, Cursor, Gemini, etc.)

### Installation

Install and initialize a new project with ACDD:

```bash
uvx --from git+https://github.com/Nom-nom-hub/acdd-kit.git acdd init <PROJECT_NAME>
```

Or install globally:

```bash
uv tool install acdd-cli --from git+https://github.com/Nom-nom-hub/acdd-kit.git
acdd init <PROJECT_NAME>
```

### Quick Usage

After project initialization, use the ACDD slash commands in your AI coding assistant:

1. `/acdd.constitution` - Create project principles and guidelines
2. `/acdd.specify` - Define what you want to build (requirements and user stories)
3. `/acdd.plan` - Create technical implementation plans with your chosen tech stack
4. `/acdd.tasks` - Generate actionable task lists for implementation
5. `/acdd.implement` - Execute all tasks to build the feature according to the plan
6. `/acdd.learn` - Analyze outcomes and capture learning insights
7. `/acdd.adapt` - Update patterns and methodology based on learning

### Enhancement Commands

Optional commands that improve quality and confidence:

- `/acdd.clarify` - Clarify underspecified areas (recommended before `/acdd.plan`)
- `/acdd.analyze` - Cross-artifact consistency & coverage analysis
- `/acdd.checklist` - Generate quality checklists like "unit tests for English"

## Key Features

### Pattern Library Management

- Automatic tracking of proven development approaches
- Effectiveness measurement and refinement
- Living documentation of team best practices

### Learning Integration

- Systematic capture of implementation outcomes
- Pattern effectiveness analysis
- Team capability evolution tracking

### Adaptation Engine

- Automated updates to methodology based on evidence
- Pattern refinement and creation
- Context model evolution

## Supported AI Assistants

ACDD works with all major AI coding assistants:

- GitHub Copilot
- Claude Code
- Cursor
- Gemini
- Qwen Code
- OpenCode
- CodeBuddy
- Amazon Q Developer
- And more

## Documentation

- [Installation Guide](./docs/installation.md)
- [Quick Start](./docs/quickstart.md)
- [Local Development](./docs/local-development.md)

## Contributing

We welcome contributions to ACDD! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## License

This project is licensed under the terms found in [LICENSE](LICENSE).

---

ACDD transforms specification-driven development from a linear process into an adaptive, learning system that continuously improves based on real-world implementation experience.
