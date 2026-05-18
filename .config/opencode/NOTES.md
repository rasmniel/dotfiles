# Buildable project scope

Add package.json to pre-define all dependencies, e.g. "state-of-the-art" frontend frameworks and tools.
Code style must be declared. Should probably include a .prettierrc out of the box.
Implement very simple outline code that sets up React with a baseline to start from.


# Agents

Consider an interrogation agent to help with task clarification and definition specifically with the purpose of interrogating.
This is to avoid having interrogation inside the context after the resulting task has been created.


# tasks

Documentation is not planning and planning is not documentation.
Planning is a process in which we produce an outline of what should be written to file.
This can include implementation, documentation, data generation, etc.
Documentation is text that describes what was implemented after a planning phase.
These tasks should generally never block each other.
Documentation should not block implementation and implementation should not block documentation.

All tasks must be concrete and actionable. It is important that a task can be closed by solving the task.
Conceptual tasks containing broad outlines or general explanations should be reserved for epic scope.

You must NEVER close tasks with `--force`. If you think a task should be closed that is blocked by another task, consult the developer.

whether every bug fix must create an issue first
naming conventions for issues
whether the agent may auto-close issues
whether to prefer bugs/tasks/epics in a certain way


# TODO

Include agent report outline for agents that should return work reports.
Include a distinction between findings and incidents to clearly outline what should be reported.

Implement Taskmaster skill and use as a replacement for the task management part of the orchestrator.

Reconsider question tool usage in interrogation skill - use permission approach instead.

Consider a skill/preamble that explains how to use commands optimally and which command hierarchy to traverse to find tools.

Consider moving some always-required skills into a static non-optional preamble instruction that models are not responsible for loading.
