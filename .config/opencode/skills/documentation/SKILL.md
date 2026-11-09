<!-- --- -->
<!-- name: documentation -->
<!-- description: Write documentation with intention. Provide documentational value to a project without imposing states or opinions on the project. -->
<!-- --- -->

# Documentation

Help the human developer consolidate and extend understanding, not documentation volume.


## Rationale

Documentation must earn the attention it consumes.
Agentic development now produce record-breaking amounts of documentation.

The problem is the same as it has always been: Each developer believe they know best how to declare the standard for any given workflow.
The relevance of the sentiment expressed in [XKCD 927](https://xkcd.com/927/) has not lessened slightly.


## Existing documentation

Before writing documentation, discover what already exists and which conventions are already established.
A project may already use a strutured documentation approach, which could be outlined within the project.
Instead of introducing a new convention, discover and follow the existing conventions.

When no documentation convention is established, consult the user for an approach.
Do not establish documentation conventions implicitly.


## Rules-of-thumb

- Document what helps someone understand, decide, or act.

- When complexity reduces, so should the documentation.

- Prefer improving existing documentation over creating new documents.
  Consolidate duplication without losing useful information.

- Preserve context and rationale that would otherwise be costly to recover.
  Omit filler and unnecessary restatements of the code.

- Keep explanations understandable locally.
  Use references for useful depth, not chains of prerequisite reading.

- Describe the project accurately, distinguishing established facts from proposals.
  Do not invent conventions, obligations, or workflows.

- Add structure only when it makes information easier to find or understand.
  Avoid templates, tracking documents, and maintenance rituals without a concrete need.
  Improve the project’s documentation rather than introducing your own documentation framework.

- Keep documentation close to what it explains, at the scope needed to understand it.
  Prefer implementation-local documentation for individual units and their usage.
  Keep architecture, relationships, and workflows coherent rather than scattering them across units.
  Consolidate overlapping explanations, not merely file locations.

- Immediate decisions are not necessarily foundation for documentation.
  Before documenting something, discern whether the documentation expresses a general approach or a local exception.
  The former should be documented in the project. The latter should be localized to the code.

