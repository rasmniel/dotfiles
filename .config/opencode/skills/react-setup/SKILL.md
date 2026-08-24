---
name: react-setup
description: Set up and evolve React projects with sensible defaults, respecting established architecture. Use for React project setup and architecture changes.
---

# React setup

This React setup skill helps provide assistance in setting up React codebases consistently.

Certain parts of this skill are deliberately kept underspecified to avoid over-defining the scope.
In greenfield scenarios, consult the user regarding material ambiguities and unknowns instead of making assumptions.

The purpose of this skill is to create missing pieces from scratch and fill in gaps.
It is not the purpose of this skill to proactively align existing projects or impose changes to features that already work.


## Scope

Respect and preserve established project architecture, verifying and reusing existing approaches where possible.
Absent or underspecified implementation may be filled using these defaults, but does not by itself justify imposing defaults on established architecture.
Treat established alternatives to the defaults as project decisions, not as deficiencies.

Follow this precedence hierarchy.

1. Explicit user instruction
2. Project-specific instructions
3. Established architecture and configuration
4. Defaults and rules outlined in this skill

Apply the guidelines in this skill according to the scope of the work.

1. **Greenfield**: Use this skill as the authority on implementing architectural defaults when no higher-precedence guidance exists.
    - For fresh projects, prefer to apply established defaults decisively over performing unnecessary analysis.
2. **Gaps**: Use this skill to fill architectural gaps, preserving established and out-of-scope architecture.
    - Consult the user regarding ambiguities that would materially affect already established architecture.
3. **Restructure**: Use this skill as guidance, preserving established architecture unless explicitly instructed.
    - Architectural rewrites are always explicitly initiated by the user.

### Greenfield

This skill chiefly focuses on greenfield projects and the early steps that establish foundational architecture.
The presence of any pre-existing files in a project could indicate that the project is not in a greenfield state.
Do not assume greenfield state if any established concepts can be detected before work begins.

Before starting work in a project, determine if the project already has established conventions and make sure to prioritize those over greenfield defaults.
Verify the root of the React project before starting, as you may be working in a monorepo or similar where there may be other files not pertaining to the greenfield project.
Even in greenfield scenarios, remember to run available checking scripts to ensure a proper development process.

### Configuration

Aim to preserve established configuration.
Only change or extend configuration when explicitly instructed or if necessary to complete the requested work.
When changing configuration, consider the impact on existing code.


## Project dependencies

Install project dependencies only as needed.

Greenfield defaults are expressed using npm, which is the greenfield choice.
If the project uses another package manager, some package script invocations outlined in this skill must be adapted.

Any existing package management configuration must be preserved and reused.
Add missing package scripts only when they are supported by the installed project dependencies.

Do not replace an already implemented framework in an existing project.
Do not migrate established tools or packages to this outline unless explicitly instructed.
When migrating, prefer a piece-by-piece approach over full-scale rewrites.

### React

React is our UI framework of choice and the baseline for this skill.
Projects that use another UI framework than React should not be considered with this skill.

### TypeScript

Greenfield projects must use TypeScript.
Use type-checking consistently as part of setup and development.
Add a `tsc` package script if the project package is missing a type-checking script.
Derive the command from the existing project or consult the user on how to write the type-checking command.

Do not migrate an established JavaScript codebase to TypeScript unless explicitly instructed.

### Vite

The chosen toolchain is Vite, used to transpile and serve the app.
If another toolchain exists, do not replace it unless instructed.

We try to assume as little as possible about the Vite config, because it can be very specific for each individual project.
Keep in mind that even after scaffolding, the Vite configuration may contain important bits and pieces that must be preserved.

In greenfield projects the Vite config should follow these rules.

- Fall back to 3000 as default port
- Only produce sourcemaps for builds targeting development mode
- Allow disabling `server.hmr` with a `DISABLE_HMR` environment variable

Associated package scripts
```json
{
    "start": "vite",
    "dev": "vite",
    "preview": "vite preview",
    "build": "npm run tsc && vite build",
    "build:dev": "npm run build -- --mode development",
    "build:prod": "npm run build -- --mode production"
}
```

### Vitest

Always use the established testing strategy if one exists.
If Vite is the established toolchain, use Vitest for testing.
If an existing project doesn't use Vite and no testing strategy is established, defer to the user for a decision on testing.

In greenfield projects Vitest should be configured with these requirements.

- UI and coverage should not run by default
- Use Vitest's default coverage provider to generate coverage reports in a top level `coverage` directory.
- Include and exclude files appropriately as needed to support the setup correctly and simply.

Follow these rules for testing in greenfield projects.

- Test only framework-independent tooling and application logic.
- Do not test React components, hooks, contexts, etc. unless instructed.
- Do not test generated code unless instructed.


Associated package scripts
```json
{
    "test": "vitest run",
    "test:coverage": "npm run test -- --coverage",
    "test:ui": "vitest --ui --coverage"
}
```

### Prettier

Use Prettier as a formatter in greenfield projects.

Use the following `.prettierrc` configuration shape when one doesn't exist.
```json
{
    "printWidth": 100,
    "tabWidth": 4,
    "useTabs": false,
    "semi": false,
    "singleQuote": true,
    "bracketSpacing": true,
    "trailingComma": "es5",
    "arrowParens": "always",
    "proseWrap": "preserve"
}
```

Also include a `.prettierignore` with the following content.
```gitignore
_generated
package-lock.json
```

Associated package scripts
```json
{
    "format": "prettier --check .",
    "format:fix": "prettier --write ."
}
```

### ESLint

Use ESLint as a linter in greenfield projects.

We use linting to protect the code from bugs and errors, not to strain the developer.
Any rules ignored by the established configuration must be respected.

Lint configuration should ignore transpiled and generated code.
For greenfield projects, we use the recommended defaults as provided by ESLint itself and related React packages.
Keep in mind that even in greenfield projects this file may already exist, in which case it should not implicitly be changed.

Associated package scripts
```json
{
    "lint": "eslint ."
}
```

### OpenAPI generator

The OpenAPI generator is an optional dependency and should only be installed when instructed.
The generator reads an API specification and generates a client and the necessary DTO types to integrate with that API.

Using the OpenAPI generator is predicated on the API actually following and declaring such a specification.
In cases where the API does not, we do not include this dependency.

The OpenAPI generator should be used with the following constraints.

- Generate a TypeScript-fetch client
- Output generated code to `src/_generated/api/<domain>`
- Enable single request parameter

Instead of running a generation command directly in the CLI, the client generation should be standardized as a package script called `generate-api`.

In many cases it is necessary to create a workflow script file that parameterizes the domain and version of the generator and more, to create multiple different clients consistently.
Such a function should be compatible with the project, e.g. written in JavaScript or TypeScript.
Commands for such parameterized API generator scripts should be `generate-api:<domain>` according to their domain.
In cases where multiple parameterized API client generators are declared, we also want to consolidate these with `generate-api:all`.

The code generated by the OpenAPI generator must not be edited directly, but should be checked into version control.
Typically, the user will initiate API client generation. Do not regenerate the API client unless required by the requested work or explicitly instructed.
Problems with the API client should be flagged and reported for correction to those responsible for the API specification.
Always consult the user when generated code causes problems that cannot be solved within the given constraints by the generated clients.


## Scaffolding

Scaffold greenfield projects with the current official Vite scaffolding mechanism and apply defaults to the resulting structure.
You should discover the current recommended approach to scaffolding yourself and how to execute it to accommodate declared defaults as accurately as possible.
Only bootstrap defaults indiscriminately when the project is truly a greenfield project.

If scaffolding has already been run or is not right for this project, missing dependencies should be installed manually.
Allow the established package manager to resolve appropriate versions of requested packages, but forward concerns for any considerable vulnerabilities in installed packages.
If the install command is not directly runnable, provide the command to the user and let them run it instead.
After scaffolding the project and applying greenfield defaults, ensure the project is still functional by building the project and running linting, type-checking, tests, etc.
Files immediately resulting from a scaffolding command are considered part of the greenfield baseline.

Before performing an initial setup, provide the user with an overview of what will be installed and created.
Only when the users has seen and confirmed the setup can installation and scaffolding of files begin.

### Environment

Discover existing environment setup before tampering with environment variables.
For greenfield projects, add an environment file setup.
Projects created with this skill need two mandatory environment files.

- `.env`: The live environment as it is used by the system locally.
    - This file must never be checked into version control.
    - You must not inspect this file without explicit permission.
- `.env.init`: An environment outline file describing the setup with placeholder values.
    - This file should be used as a template to create the environment file and is checked into version control.
    - In existing projects, this file may exist with a different but similar name.

Add the following package script to generate an `.env` file from template, and run it if no `.env` file exists yet.
```json
{
    "init-env": "node ./scripts/init-env.js"
}
```

The `scripts/init-env.js` workflow script ensures cross-platform support.
```js
import('fs').then((fs) => {
    if (!fs.existsSync('.env'))
        fs.cpSync('.env.init', '.env')
})
```

Note that environment variables used inside the Vite-built client-side source code must be prefixed with `VITE_`.

Initially, the environment file must include a `PORT` field, which defaults to `3000`.
For developer convenience, we include an option to disable hot module reloading with `DISABLE_HMR`, which defaults to empty.
If an API integration should be included or if the OpenAPI generator is installed, a `VITE_BASE_API_PATH` variable must also exist, which defaults to the placeholder value `http://localhost/api`.

### Version control

We use Git for version control, unless an alternative is explicitly established.
Do not modify Git state directly through the CLI, unless instructed.

Include the following gitignore file in a project when it's missing.
When necessary, add appropriate missing lines to the existing gitignore.
```gitignore
.env
node_modules
dist
coverage
```


## Architecture

Keep the architecture as light as possible.
Apply only architectural parts that produce value to the system, avoiding superfluous and unnecessary architectural ceremony.

### Directory structure

The project directory structure should resemble the following outline.
Follow established project directory conventions, and refer to this outline for missing structure.
Do not create empty directories just because they are missing.
Only create directories if they serve a purpose.

```
scripts/                # Workflow scripts
src/                    # Conventional source code directory
├─ _generated/          # Generated API clients, types, etc.
├─ components/          # Grouped UI components
│  ├─ common/           # Common and shared components
│  ├─ screens/          # Route-specific screen components
│  └─ ...               # Additional domain-specific components
├─ contexts/            # Contexts and providers
├─ hooks/               # Grouped hooks
│  ├─ common/           # Common and shared hooks
│  └─ ...               # Additional domain-specific hooks
├─ models/              # Application data models
└─ tools/               # General TypeScript utilities
test/                   # Test suite
```

### Domain transport

Stick as closely as possible to the unidirectional data flow employed by React.
Strive to implement the following data flow in the given direction.
This data flow does not require every abstraction layer to exist.
Layers that add no additional value may be omitted.

```
Generated API clients > Application API boundary > Transport normalization > Domain-specific models > Domain contexts > Domain hooks > Screens and UI compositions
```

Always keep the following guidelines in mind.

- Keep transport behind domain boundaries. Configure generated API clients centrally and expose domain-oriented operations to the UI through contexts or hooks.
- Normalize data at the boundary. Convert transport responses, errors, and DTOs into stable domain representations before exposing them to UI code.
- Use consistent asynchronous semantics. Standardize how loading, errors, refreshing, cancellation, and mutations are represented across domains.

### Patterns

Aim to implement similar features consistently.

#### Domain models

Domain models are application-specific constructions that are mapped from DTOs.
Represent such a model by an immutable class to encapsulate domain behavior and provide computed getters.

Isolate DTOs inside their respective domain boundary when a domain abstraction adds value.
Avoid creating domain models that merely rename or mirror trivial DTOs.

#### Hook usage

Use hooks deliberately, favoring developer ergonomics over unnecessary complexity and speculative optimization.

State: Each state value should have only a single source of truth to avoid bugs and confusing state code.
- Duplicate and derived states can become stale when stored separately and diverge from the source state.
- Only store derived state when it can be explicitly justified as an intentional independent state.

#### Context providers

Export a dedicated hook from each domain context for consuming its value.
This helps unify context usage and improves context safety.

Place this helper in the common hook namespace and reuse it to standardize safe context consumption.

```ts
import { useContext, type Context } from 'react'

export const useRequiredContext = <T>(contextType: Context<T | undefined>, name: string) => {
    const context = useContext(contextType)
    if (context === undefined) throw new Error(`${name}Context must be used within a ${name}Provider`)
    return context
}
```

In a conceptual `DataContext.tsx` file this code would export the context.

```ts
export const useDataContext = () => useRequiredContext(DataContext, 'Data')
```

