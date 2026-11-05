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

**Criticality assessment**: Rationale of the criticality assessment.

**Verification**: How this is the implementation of this requirement going to be verified/tested/assessed?

**Assumptions**:

- Assumption used to write this requirement
- Assumption used to write this requirement

**Details**: Details of the requirement.

#### FR2: Single Sentence of the requirement

**Summary**: Summary of this requirements

**Impact**: Impact of the requirement.

**Criticality assessment**: Rationale of the criticality assessment.

**Verification**: How this is the implementation of this requirement going to be verified/tested/assessed?

**Assumptions**:

- Assumption used to write this requirement
- Assumption used to write this requirement

**Details**: Details of the requirement.

...

#### FRn: Single Sentence of the requirement

**Summary**: Summary of this requirements

**Impact**: Impact of the requirement.

**Criticality assessment**: Rationale of the criticality assessment.

**Verification**: How this is the implementation of this requirement going to be verified/tested/assessed?

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

**Criticality assessment**: Rationale of the criticality assessment.

**Verification**: How this is the implementation of this requirement going to be verified/tested/assessed?

**Assumptions**:

- Assumption used to write this requirement
- Assumption used to write this requirement

**Details**: Details of the requirement.

#### NFR2: Single Sentence of the requirement

**Summary**: Summary of this requirements

**Impact**: Impact of the requirement.

**Criticality assessment**: Rationale of the criticality assessment.

**Verification**: How this is the implementation of this requirement going to be verified/tested/assessed?

**Assumptions**:

- Assumption used to write this requirement
- Assumption used to write this requirement

**Details**: Details of the requirement.

...

#### NFRm: Single Sentence of the requirement

**Summary**: Summary of this requirements

**Impact**: Impact of the requirement.

**Criticality assessment**: Rationale of the criticality assessment.

**Verification**: How this is the implementation of this requirement going to be verified/tested/assessed?

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

| Entry Id | Entry Name | Description | Severity | Workaround | Related Decision Id | Related Decision Name | Id of Requirements that this Entry Directly Impacts | Title of Requirements this Entry Directly Impacts |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |

Each bug id has the format `BX` and each limitation id has the format `LX`, where `X` is a leading zero number applied for `X` is between 1 and 9 (inclusive).

### Bugs

Summary of the bugs under level 4 headers.

Order the bugs having most critical bugs first.

#### B01: Single Sentence of the bug

**Summary**: Summary of this bug

**Impact**: Impact of the bug.

**Criticality assessment**: Rationale of the criticality assessment.

**Why**: Cause of the bug.

**Details**: Details of the bug.

#### B02: Single Sentence of the bug

**Summary**: Summary of this bug

**Impact**: Impact of the bug.

**Criticality assessment**: Rationale of the criticality assessment.

**Why**: Cause of the bug.

**Details**: Details of the bug.

...

#### BN: Single Sentence of the bug

**Summary**: Summary of this bug

**Impact**: Impact of the bug.

**Criticality assessment**: Rationale of the criticality assessment.

**Why**: Cause of the bug.

**Details**: Details of the bug.

### Limitations

Summary of the accepted limitations under level 4 headers.

Order the limitations having most critical limitations first.

#### L01: Single Sentence of the limitation

**Summary**: Summary of this limitation

**Impact**: Impact of the limitation.

**Criticality assessment**: Rationale of the criticality assessment.

**Why**: Cause of the limitation.

**Details**: Details of the limitation.

#### L02: Single Sentence of the limitation

**Summary**: Summary of this limitation

**Impact**: Impact of the limitation.

**Criticality assessment**: Rationale of the criticality assessment.

**Why**: Cause of the limitation.

**Details**: Details of the limitation.

...

#### LM: Single Sentence of the limitation

**Summary**: Summary of this limitation

**Impact**: Impact of the limitation.

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

### Criticality

`Criticality` grades the consequence of shipping without the item. It applies to every requirement, bug and limitation in this document, and takes one of three values:

| Criticality | Definition |
| --- | --- |
| `High` | The release cannot go ahead without it. A requirement at High is one the product has no purpose without. A bug at High loses or exposes data, blocks a core flow, or breaks a security or compliance obligation. A limitation at High changes what users can be promised. |
| `Medium` | The release can go ahead, but a named group of users is left worse off and the gap must be scheduled into a later release. The system still works for everyone else. |
| `Low` | The release can go ahead and nothing is owed afterwards. The item improves the result, for example through ergonomics, polish or cleanup, and is done when there is room for it. |

The `Criticality assessment` field under each item is where the chosen value is justified against these definitions.