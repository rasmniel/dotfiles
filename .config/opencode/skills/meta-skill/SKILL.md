---
name: meta-skill
description: Create, edit, and explore agentic skills with intention. Use when working with agentic skills, skill content, and agentic skill behavior.
---

# Meta Skill

Create and edit skills with intention.
Explore skills to achieve a shared understanding with the user.

Aim to fulfill the following goals for the skill.

- Correctness according to responsibility and purpose
- Internal consistency in terminology
- Statelessness; no history baked into skill text

Do not use any other skills about editing or working with agent skills.


## The Skill

The skill should confidently and concisely state the expected behavior or strategy desired from its usage.
The skill should describe a coherent concept in its current form, not document the reasoning history that led to it.

### Purpose and Responsibility

Before editing the skill, you must understand its purpose and responsibility.
This is also true for the user, but it is not implied that the user has this understanding.
You must establish a clear and common understanding between you and the user about the purpose of the skill.
If the purpose of the skill is not clear from the skill text alone, discuss with the user until you share a common understanding.

Every expansion of the skill text is to some degree an expansion of its responsibility.
Changing the responsibility of the skill must be lead by a decision.

When adding new text to the skill, first consider whether an edit to existing text would be more appropriate.
Even when skill responsibility does change, we should aim to not bloat the skill further and further with every edit.

### Red Flags

The following are typical red flags in skill design:

- The skill provides exceptions to its own rules.
- The skill includes standalone descriptions that are far removed from the core concept.
- The skill uses multiple terms to describe the same concept.
- The skill provides little or no actionability to its expectations.

### Improvements

Completeness and consolidation of established purpose and responsbility are the core parts of improving a skill.
The best improvements to a skill remove redundancy and contradiction.

Additions are only improvements to the skill when they

- constitute missing explanations
- strengthen its responsibility boundary
- materially clarify uncertain aspects its purpose


## Suggestion Format

When providing suggestions to edit the skill, provide the following information about your suggestion.

- The file and the line number or range.
- An explanation
    - Why you think this is an improvement.
    - If this is an addition, justify it over an update to existing responsibility.
- What the text says now.
    - You may summarize the text if the section is very long.
- Exactly what you suggest it should say.
- Line diff summary; added, removed, and changed.


## Skill Style

The following is guidance for the style of the skill text.

- Use serial comma, aka. Oxford comma.
- Avoid parenthetical clause.

### Line Breaks

Break long lines with multiple sentences into multiple lines.
A rule of thumb is to break the line on every period, but don't follow this rule religiously.

Don't break lines before a period. Let long sentences take up the full line.
Consider if very long sentences can be restructured into smaller sentences to break them into multiple lines without altering semantics.

Use common sense with regard to the length of the line to determine when it should break.

