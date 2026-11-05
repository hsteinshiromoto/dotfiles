---
version_number: Count of changes made to this requirement
date_update: Date this requirements has been created/modified
uuid: UUIDv7
---

# Requirements Name

## Summary

Table summarizing the requirements. One row per requirement. Most critical requirement first.

| Requirement Id | Requirement Title | Type | Requirement Summary | Impact | Criticality |
| --- | --- | --- | --- | --- | --- |
| FR1 | Single sentence of the requirement | Functional | Summary of this requirement | Impact of the requirement | High |
| FR2 | Single sentence of the requirement | Functional | Summary of this requirement | Impact of the requirement | Medium |
| NFR1 | Single sentence of the requirement | Non-Functional | Summary of this requirement | Impact of the requirement | High |

### What?

What this plan addresses.

### Why?

Why are these changes necessary?

### So What?

What is going to be implemented

## Requirements

Summary of the requirements.

You will have to also include data and AI-related requirements. For example, if building an AI agent, how the agent will behave, how the agent will be evaluated (eg toxicity rate, etc). Decide where each of these requirements should be in functional or non-functional.

### Functional Requirements

Summary of the functional requirements under level 4 headers.

Order the requirements having most critical requirements first.

#### FR1: Single Sentence of the requirement

**Summary**: Summary of this requirements

**Impact**: Impact of the requirement.

**Criticality**: High

**Criticality assessment**: Rationale of the criticality assessment.

**Verification**: Gherkin scenarios that cover this requirement. One scenario per behaviour, including the paths the system must refuse. See [Verification Format](#verification-format).

```gherkin
Feature: FR1 - Single sentence of the requirement

  Scenario: Name of the expected behaviour
    Given a precondition that holds before the behaviour
    When the actor does something observable
    Then the system produces an observable result
    And the system produces a second observable result

  Scenario: Name of the path the system must refuse
    Given a precondition that holds before the behaviour
    When the actor does something the system must reject
    Then the system refuses with a named error
    And the system leaves the stored data unchanged
```

**Assumptions**:

- Assumption used to write this requirement
- Assumption used to write this requirement

**Details**: Details of the requirement.

#### FR2: Single Sentence of the requirement

**Summary**: Summary of this requirements

**Impact**: Impact of the requirement.

**Criticality**: Medium

**Criticality assessment**: Rationale of the criticality assessment.

**Verification**: Gherkin scenarios that cover this requirement, written in the format shown under FR1. See [Verification Format](#verification-format).

**Assumptions**:

- Assumption used to write this requirement
- Assumption used to write this requirement

**Details**: Details of the requirement.

...

#### FRn: Single Sentence of the requirement

**Summary**: Summary of this requirements

**Impact**: Impact of the requirement.

**Criticality**: Low

**Criticality assessment**: Rationale of the criticality assessment.

**Verification**: Gherkin scenarios that cover this requirement, written in the format shown under FR1. See [Verification Format](#verification-format).

**Assumptions**:

- Assumption used to write this requirement
- Assumption used to write this requirement

**Details**: Details of the requirement.

### Non-Functional Requirements

Summary of the non-functional requirements under level 4 headers.

Order the requirements having most critical requirements first.

#### NFR1: Single Sentence of the requirement

**Summary**: Summary of this requirements

**Impact**: Impact of the requirement.

**Criticality**: High

**Criticality assessment**: Rationale of the criticality assessment.

**Verification**: The measurement, its threshold, and the conditions the measurement is taken under. For example, `p95 latency below 200 ms at 500 requests per second`. Do not use Gherkin here. See [Verification Format](#verification-format).

**Assumptions**:

- Assumption used to write this requirement
- Assumption used to write this requirement

**Details**: Details of the requirement.

#### NFR2: Single Sentence of the requirement

**Summary**: Summary of this requirements

**Impact**: Impact of the requirement.

**Criticality**: Medium

**Criticality assessment**: Rationale of the criticality assessment.

**Verification**: The measurement, its threshold, and the conditions the measurement is taken under. For example, `p95 latency below 200 ms at 500 requests per second`. Do not use Gherkin here. See [Verification Format](#verification-format).

**Assumptions**:

- Assumption used to write this requirement
- Assumption used to write this requirement

**Details**: Details of the requirement.

...

#### NFRm: Single Sentence of the requirement

**Summary**: Summary of this requirements

**Impact**: Impact of the requirement.

**Criticality**: Low

**Criticality assessment**: Rationale of the criticality assessment.

**Verification**: The measurement, its threshold, and the conditions the measurement is taken under. For example, `p95 latency below 200 ms at 500 requests per second`. Do not use Gherkin here. See [Verification Format](#verification-format).

**Assumptions**:

- Assumption used to write this requirement
- Assumption used to write this requirement

**Details**: Details of the requirement.

## Decision Register

Add all the questions and answers produced using the skill `grill-me` add an id for each decision.

Create a table with the decisions using the following format:

| Decision Id | Decision Name | Description | Impacts Decision Id | Is Impacted by Decision Id | Id of Requirements that this Decision Directly Impacts | Title of Requirements this Decision Directly Impacts |
| --- | --- | --- | --- | --- | --- | --- |

Each decision id has the format `DX`, where `X` is a leading zero number applied for `X` is between 1 and 9 (inclusive).

## Bugs and Known Limitations

List the known bugs and the accepted limitations. Add an id for each entry.

Create a table with the bugs and limitations using the following format:

| Entry Id | Entry Name | Description | Criticality | Workaround | Related Decision Id | Related Decision Name | Id of Requirements that this Entry Directly Impacts | Title of Requirements this Entry Directly Impacts |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |

Each bug id has the format `BX` and each limitation id has the format `LX`, where `X` is a leading zero number applied for `X` is between 1 and 9 (inclusive).

### Bugs

Summary of the bugs under level 4 headers.

Order the bugs having most critical bugs first.

#### B01: Single Sentence of the bug

**Summary**: Summary of this bug

**Impact**: Impact of the bug.

**Criticality**: High

**Criticality assessment**: Rationale of the criticality assessment.

**Why**: Cause of the bug.

**Details**: Details of the bug.

#### B02: Single Sentence of the bug

**Summary**: Summary of this bug

**Impact**: Impact of the bug.

**Criticality**: Medium

**Criticality assessment**: Rationale of the criticality assessment.

**Why**: Cause of the bug.

**Details**: Details of the bug.

...

#### BN: Single Sentence of the bug

**Summary**: Summary of this bug

**Impact**: Impact of the bug.

**Criticality**: Low

**Criticality assessment**: Rationale of the criticality assessment.

**Why**: Cause of the bug.

**Details**: Details of the bug.

### Limitations

Summary of the accepted limitations under level 4 headers.

Order the limitations having most critical limitations first.

#### L01: Single Sentence of the limitation

**Summary**: Summary of this limitation

**Impact**: Impact of the limitation.

**Criticality**: High

**Criticality assessment**: Rationale of the criticality assessment.

**Why**: Cause of the limitation.

**Details**: Details of the limitation.

#### L02: Single Sentence of the limitation

**Summary**: Summary of this limitation

**Impact**: Impact of the limitation.

**Criticality**: Medium

**Criticality assessment**: Rationale of the criticality assessment.

**Why**: Cause of the limitation.

**Details**: Details of the limitation.

...

#### LM: Single Sentence of the limitation

**Summary**: Summary of this limitation

**Impact**: Impact of the limitation.

**Criticality**: Low

**Criticality assessment**: Rationale of the criticality assessment.

**Why**: Cause of the limitation.

**Details**: Details of the limitation.

## Changelog

If applicable, list the changes made to this plan. Most recent change first.

### YYYY-MM-DD Change Abstract - Most recent change

Key changes to the plan summarized below as bullet points.

### YYYY-MM-DD Change Abstract - Second Most recent change

Key changes to the plan summarized below as bullet points.

...

### YYYY-MM-DD Change Abstract - Last recent change

## Definitions

### Verification Format

`Verification` states what counts as proof the requirement is met. The format depends on the kind of requirement.

Functional requirements use Gherkin, because a functional requirement describes a behaviour and a behaviour has a precondition, a trigger and an observable result. Writing it as `Given` / `When` / `Then` forces each of the three to be named, and the scenario carries straight into the implementation plan as the test for the changes that address the requirement.

Rules for the scenarios:

- One `Feature` block per requirement. The feature line repeats the requirement id and its single sentence.
- One `Scenario` per behaviour. Cover the expected path and every path the system must refuse.
- `Given` states what holds before. `When` states the single action. `Then` states what is observable afterwards. Use `And` to add a step of the same kind.
- Each step is one fact. Do not join two facts with `and` inside one step.
- Write steps the way a user or a caller sees the system. Do not name functions, files or database tables.
- Keep values concrete. `Given the account holds 50 AUD` beats `Given the account holds some money`.

Non-functional requirements do not use Gherkin. A threshold is a measurement, not a scenario, and `Given` / `When` / `Then` adds lines without adding precision. State the measurement, the threshold and the conditions instead.

### Criticality

`Criticality` grades the consequence of shipping without the item. It applies to every requirement, bug and limitation in this document, and takes one of three values:

| Criticality | Definition |
| --- | --- |
| `High` | The release cannot go ahead without it. A requirement at High is one the product has no purpose without. A bug at High loses or exposes data, blocks a core flow, or breaks a security or compliance obligation. A limitation at High changes what users can be promised. |
| `Medium` | The release can go ahead, but a named group of users is left worse off and the gap must be scheduled into a later release. The system still works for everyone else. |
| `Low` | The release can go ahead and nothing is owed afterwards. The item improves the result, for example through ergonomics, polish or cleanup, and is done when there is room for it. |

The `Criticality assessment` field under each item is where the chosen value is justified against these definitions.