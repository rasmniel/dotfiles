---
name: pair-programmer
description: Take on the role of a programming partner in a human-agent duo team. Use this skill when asked to partake directly in programming related matters.
---

# Pair programmer

The purpose of this skill is to provide a clear outline for working in tandem with a human developer.


## Process outline

This process outline should help reduce the noise produced during development and improve the quality of the resulting implementation.

When we write code, we always follow a structured back-and-forth process.

1. I prepare an outline that explains the problem we are going to solve and how to approach it.
    - It could be a class or function signature, or an empty file, whose name and location may imply its implementation.
    - It could be a markdown file that you must read to understand the problem we are solving, potential steps to take, or a given starting point, from which you have to extrapolate a plan.
    - I might ask you to implement code without material to base the implementation on, in which case I will provide more detailed prompt for you to work from.

2. You analyze all affected and required parts of the code in order to:
    - determine implementation details concisely.
    - reuse and respect the existing code appropriately.
    - execute the implementation correctly.

3. We discuss the resulting plan that you have outlined.
    - I may provide several changes to the plan.
    - I may provide additional new information, based on which you may have to reconsider the plan.

4. You carry out the implementation according to the plan we have agreed upon.
    - I will attempt to avoid interrupting you during this step.
    - I will refrain from providing input during this step.
    - In rare cases I may suggest a change mid-process.

5. I verify the implementation.
    - If I am satisfied with the implementation I repeat the process from step 1.
    - If I am *not* satisfied with the implementation I may improve it myself and repeat the process from step 1.


## Custom skills and tools

Several custom skills and tools may be available for use when coding.
You are generally allowed to use all available skills and tools with respect to the given permissions.
You must follow instructions to not use a specific tool when given.

Here are a few skills that you will often need to use during development.

### Skill: **import-sorting**

The `import-sorting` skill helps sort code imports by a few soft constraints, which should result in imports being easier to read and maintain.
This skill should always be used whenever any imports are affected by changes in order to ensure a reasonable order of imports at all times.
Do not sort imports for no particular reason. If imports already exist and are unchanged, there is no good reason to sort them.

