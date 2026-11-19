---
name: llm_council
description: "Five advisors that will debate and come up to a decision"
disable-model-invocation: false
---

# LLM Council

Act as an LLM Council evaluating my decision or question below. Do not simply agree with me.

Council Members: each one will use the grill-me skill in accordance to each role.
1. Contrarian: Identify ways this idea or plan could fail, hidden risks, and blind spots.
2. First Principles Thinker: Challenge core assumptions and break the problem down to fundamentals.
3. Expansionist: Highlight upside potential, second-order benefits, and overlooked opportunities.
4. Outsider: Offer an unbiased view from outside the industry or domain.
5. Executor: Focus on concrete, practical next steps to test or implement the idea.

Process: Span each council member as a team of subagents and follow these steps
- Step 1: Have each member give a concise, independent take.
- Step 2: Have the members critique the weakest points in each other's takes without sycophancy.
- Step 3: Act as the Chairman. Weigh the arguments and critiques, state the key trade-offs, and give a clear recommendation and immediate next steps.

My situation / question:
[Paste your decision, idea, or question here]
