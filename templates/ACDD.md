# Adaptive Context-Driven Development (ACDD) Template

## Overview

The Adaptive Context-Driven Development (ACDD) template implements a methodology that extends traditional Specification-Driven Development (SDD) with adaptive capabilities. ACDD focuses on creating software systems that can evolve and adapt based on changing contexts, requirements, and environmental factors.

## Core Principles

### 1. Context Awareness

- Systems must be aware of their operational context
- Context includes environment, user needs, business requirements, and external factors
- Context changes trigger adaptive responses

### 2. Adaptive Implementation

- Code and architecture must support adaptation to context changes
- Components should be designed for flexibility and evolution
- Implementation plans account for future context evolution

### 3. Pattern Compliance

- All adaptive implementations must comply with architectural patterns
- Constitutional principles guide adaptive behavior
- Pattern compliance is validated throughout the development process

### 4. Learning Preparation

- Development process includes preparation for context learning
- Systems are built to acquire knowledge from operational context
- Feedback loops enable continuous learning and adaptation

### 5. Context Evolution Tracking

- Changes in context are tracked and documented
- Evolution paths are planned and validated
- Historical context changes inform future adaptations

## Template Structure

### Commands

- `acdd-tasks.md`: Generates adaptive task lists with context tracking
- `acdd-tasks-template.md`: Template for adaptive task generation

### Key Components

#### Context Tags

- `[CTX-INIT]`: Initial context setup and pattern recognition
- `[CTX-LEARN]`: Learning preparation and knowledge acquisition
- `[CTX-ADAPT]`: Context adaptation and implementation adjustments
- `[CTX-VALIDATE]`: Validation against evolving context requirements

#### Phase Structure

1. **Context Setup & Pattern Recognition**: Establish context awareness
2. **Learning Preparation**: Prepare for adaptive implementation
3. **Adaptive Foundation**: Build context-aware infrastructure
4. **User Stories**: Adaptive implementation with context tracking
5. **Adaptive Polish**: Context validation and optimization

## Usage

### Prerequisites

- Existing spec-kit structure with design documents
- Context evolution logs in `/memory/context/`
- Constitutional principles in `memory/constitution.md`

### Generating ACDD Tasks

Use the `/acdd.tasks` command to generate adaptive task lists:

```bash
/acdd.tasks [feature-description]
```

This command will:

1. Analyze existing context patterns
2. Prepare for adaptive implementation
3. Generate context-aware tasks
4. Include pattern compliance validation
5. Create context evolution tracking points

### Task Format

Each task follows the format:

```text
- [ ] [TaskID] [P?] [Story?] [Context?] Description with file path
```

Example:

```text
- [ ] T012 [P] [US1] [CTX-INIT] Create adaptive User model in src/models/user.py with context tracking
```

## ACDD Methodology Benefits

### For Development Teams

- **Predictable Adaptation**: Systems designed to handle context changes
- **Reduced Technical Debt**: Adaptive architecture prevents rigid implementations
- **Improved Quality**: Context validation ensures robust implementations
- **Faster Response**: Pre-planned adaptation points for requirement changes

### For Project Management

- **Risk Mitigation**: Context awareness identifies potential change points
- **Resource Planning**: Adaptive phases account for evolution needs
- **Quality Assurance**: Context validation provides comprehensive testing
- **Progress Tracking**: Context evolution tracking shows system maturity

### For Architecture

- **Pattern Compliance**: Constitutional principles maintained during adaptation
- **Scalable Design**: Adaptive components support growth and change
- **Maintainable Code**: Context-aware implementations are easier to modify
- **Future-Proof**: Architecture designed for evolution rather than static requirements

## Integration with SDD

ACDD extends the existing SDD methodology by adding adaptive capabilities:

- Maintains all SDD benefits (specifications as source of truth)
- Adds context awareness to specification and implementation
- Enhances pattern compliance with adaptive validation
- Provides evolution tracking for long-term maintainability

## Best Practices

### When to Use ACDD

- Projects with changing requirements or uncertain specifications
- Systems that need to adapt to environmental changes
- Applications with evolving user needs or business contexts
- Long-term projects where requirements may shift over time

### Context Pattern Identification

- Analyze historical requirement changes
- Identify external factors that may affect the system
- Document context change triggers
- Plan adaptation strategies for each context type

### Adaptive Implementation Guidelines

- Design components for flexibility rather than optimization
- Include monitoring and feedback mechanisms
- Plan for graceful degradation during adaptation
- Maintain backward compatibility where possible

## Quality Gates

ACDD includes specific validation points:

- Context pattern compliance validation
- Adaptive implementation verification
- Context evolution tracking validation
- Cross-context consistency checks
- Performance impact assessment for adaptive components

## Template Files

- `acdd-tasks-template.md`: The main template for generating adaptive task lists
- `acdd-tasks.md`: Command template for the `/acdd.tasks` command
- This README: Documentation for the ACDD methodology and usage

The ACDD template provides a comprehensive framework for building adaptive, context-aware software systems while maintaining the benefits of specification-driven development.
