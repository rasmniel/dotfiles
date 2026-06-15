---
name: dots-tasks
description: How to use dots for task management. Use when instructed to employ dots for task management.
---

## Dots

You use [Dots](https://github.com/joelreymont/dots) for task management.

You have full access to the CLI tool with the `dot` command.

Prefer using the CLI to interact with dots tasks whenever possible.
For editing and analyzing tasks metadata, you may occasionally need to read or edit the task files directly in `.dots/*`.

For questions regarding the tool and how to operate it, direct your investigation to the tool itself and its `dot help` overview.
In cases where such questions cannot be answered with the tool's help overview, ask for clarification.

This tool and its commands should only be used by you.
You must attempt to fix errors arising from using these commands yourself.
Only if errors are severely blocking and unsolvable from the help overview, should you let me know about issues with the tool.

You must _never_ include task tooling commands e.g. `dot ...` as part of reports or summaries.


## Official Dots Command Reference 

### Initialize

```bash
dot init
```
Creates `.dots/` directory. Runs `git add .dots` if in a git repository. Safe to run if already exists.

### Add Task

```bash
dot add "title" [-p PRIORITY] [-d "description"] [-P PARENT_ID] [-a AFTER_ID] [--json]
dot "title"  # shorthand for: dot add "title"
```

Options:
- `-p N`: Priority 0-4 (0 = highest, default 2)
- `-d "text"`: Long description (markdown body of the file)
- `-P ID`: Parent task ID (creates folder hierarchy)
- `-a ID`: Blocked by task ID (dependency)
- `--json`: Output created task as JSON

Examples:
```bash
dot add "Design API" -p 1
# Output: dots-1a2b3c4d5e6f7890

dot add "Implement API" -a dots-1a2b3c4d -d "REST endpoints for user management"
# Output: dots-3c4d5e6f7a8b9012

dot add "Write tests" --json
# Output: {"id":"dots-5e6f7a8b9012cdef","title":"Write tests","status":"open","priority":2,...}
```

### List Tasks

```bash
dot ls [--status STATUS] [--json]
```

Options:
- `--status`: Filter by `open`, `active`, or `done` (default: shows open + active)
- `--json`: Output as JSON array

Output format (text):
```
[1a2b3c4] o Design API        # o = open
[3c4d5e6] > Implement API     # > = active
[5e6f7a8] x Write tests       # x = done
```

### Start Working

```bash
dot on <id> [id2 ...]
```
Marks task(s) as `active`. Use when you begin working on tasks. Supports short ID prefixes.

### Complete Task

```bash
dot off <id> [id2 ...] [-r "reason"]
```
Marks task(s) as `done` and archives them. Optional reason applies to all. Root tasks are moved to `.dots/archive/`. Child tasks wait for parent to close before moving.

### Show Task Details

```bash
dot show <id>
```

Output:
```
ID:       dots-1a2b3c4d5e6f7890
Title:    Design API
Status:   open
Priority: 1
Desc:     REST endpoints for user management
Created:  2024-12-24T10:30:00Z
```

### Remove Task

```bash
dot rm <id> [id2 ...]
```
Permanently deletes task file(s). If removing a parent, children are also deleted.

### Show Ready Tasks

```bash
dot ready [--json]
```
Lists tasks that are `open` and have no blocking dependencies (or blocker is `done`).

### Show Hierarchy

```bash
dot tree [id]
```

Without arguments: shows all open root dots and their children.
With `id`: shows that specific dot's tree (including closed children).

Output:
```
[1a2b3c4] o Build auth system
  +- [2b3c4d5] o Design schema
  +- [3c4d5e6] o Implement endpoints (blocked)
  +- [4d5e6f7] o Write tests (blocked)
```

### Fix Orphans

```bash
dot fix
```
Promotes orphaned children to root and removes missing parent folders.

### Search Tasks

```bash
dot find "query"
```
Case-insensitive search across title, description, close-reason, created-at, and closed-at. Shows open dots first, then archived.

### Purge Archive

```bash
dot purge
```
Permanently deletes all archived (completed) tasks from `.dots/archive/`.

## Storage Format

Tasks are stored as markdown files with YAML frontmatter in `.dots/`:

```
.dots/
  a1b2c3d4e5f6a7b8.md              # Root dot (no children)
  f9e8d7c6b5a49382/                # Parent with children
    f9e8d7c6b5a49382.md            # Parent dot file
    1a2b3c4d5e6f7890.md            # Child dot
  archive/                          # Closed dots
    oldtask12345678.md             # Archived root dot
    oldparent1234567/              # Archived tree
      oldparent1234567.md
      oldchild23456789.md
  config                            # ID prefix setting
```

### File Format

```markdown
---
title: Fix the bug
status: open
priority: 2
issue-type: task
assignee: joel
created-at: 2024-12-24T10:30:00Z
blocks:
  - a3f2b1c8d9e04a7b
---

Description as markdown body here.
```

### ID Format

IDs have the format `{prefix}-{slug}-{hex}` where:
- `prefix`: Project prefix from `.dots/config` (default: `dots`)
- `slug`: URL-safe abbreviation of the title (max 32 chars)
- `hex`: 8-character random hex suffix

Example: `dots-fix-user-auth-a3f2b1c8`

The slug uses common abbreviations (authentication→auth, configuration→config, etc.) and truncates at word boundaries. Run `dot slugify` to rename existing IDs to include slugs.

Commands accept short prefixes:

```bash
dot on a3f2b1    # Matches dots-fix-user-auth-a3f2b1c8
dot show a3f     # Error if ambiguous (multiple matches)
```

### Slugify

```bash
dot slugify
```
Renames all issue IDs (including archived) to include slugs based on their titles. Preserves the hex suffix and updates all dependency references.

### Status Flow

```
open -> active -> done (archived)
```

- `open`: Task created, not started
- `active`: Currently being worked on
- `done`: Completed, moved to archive

### Priority Scale

- `0`: Critical
- `1`: High
- `2`: Normal (default)
- `3`: Low
- `4`: Backlog

### Dependencies

- `parent (-P)`: Creates folder hierarchy. Parent folder contains child files.
- `blocks (-a)`: Stored in frontmatter. Task blocked until all blockers are `done`.

### Archive Behavior

When a task is marked done:
- **Root tasks**: Immediately moved to `.dots/archive/`
- **Child tasks**: Stay in parent folder until parent is closed
- **Parent tasks**: Only archive when ALL children are closed (moves entire folder)
