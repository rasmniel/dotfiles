---
name: hand-off
description: Prepare a project for hand off. Use when leaving or handing over a project.
---

# Hand off

We are leaving the project and must ensure it is simple for the next developer to pick up.

You must help gather and analyze details about the workspace in a structured process.
The purpose of this process is to determine completeness of several aspects of the codebase.


## Documentation

- Explore project documentation files. Are the respective areas properly covered by documentation?
- Explore areas that are not documented. Do these contain complexity that warrant documentation?


## Tests coverage

- Verify that test requirements are satisfied, if any requirements are specified.
- If no tests or requirements exist, assume testing is not required.


## Unfinished business

- Search for TODO comments that express work which has not finished or has been postponed for later.
- Search for stale and orphaned code that could reasonable be removed or cut down to size.
- Search for hardcoded values that could be replaced with constants or lookups.


# Procedure

To keep the process effecient and avoid redundancy, we attempt to follow a loose procedure.
If you are not directed towards any single aspect, you stick to the following procedure.

1. Start by becoming familiar with as many documented facets of the project as possible.
2. Reflect over project state in relation to documentation. Is existing documentation sufficient?
3. Run tests and verify the result match project expectations. If no tests exist, we skip this step.
4. Take note of the line- and branch coverage, even if no requirements can be found.
5. Explore the project for hardcoded values or comments that suggest an unresolved decision, incomplete task, or missing or incorrect implementation.


## Reporting

When analyzis of the project has ended, provide a report of your findings.

Include any of the investigated aspects that could reasonable be improved or considered incomplete or incorrect.
Wherever relevant, include file name and line number of the offending code.

The reporting format should stick to a simple overview of the analyzed areas and a list of respective findings.
Unless large clusters of reporting arise from a single branch, stick to using the 3 categories that are outlined here.

Example:
```
# Documentation
- Readme is missing an installation guide
- Tooling documentation is incomplete

# Test coverage
- Line-coverage insufficient
- Untested areas:
    - src/controllers/
    - src/models/

# Unfinished business
- Actionable TODO comments:
    - src/components/Input.tsx:12
    - src/model/Product.ts:71
- Hardcoded values:
    - src/components/Input.tsx:53
    - src/components/Dialog.tsx:132
```

