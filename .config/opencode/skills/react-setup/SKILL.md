---
name: react-setup
description: Set up React web projects with sensible defaults and dependencies or extend or adjust established architecture with respect to existing implementation. Use when setting up a full React project or parts of a React project from scratch or editing existing React architecture.
---

TODO: Better description with notes about opinionation and framework preference recap
TODO: styling, suggestion: autoprefixer, postcss, sass
TODO: Split this file into smaller files to maintain skill parsability despite its size

# React setup

This React setup skill helps provide assistance in setting up React codebases consistently.

Certain parts of this skill are deliberately kept underspecified to avoid over-defining the scope.
In greenfield scenarios, consult the user regarding ambiguities and unknowns instead of making assumptions.

The purpose of this skill is to create missing pieces from scratch and fill in gaps.
It is not the purpose of this skill to proactively align existing projects or impose changes to features that already work.


## Scope

Respect and preserve established project architecture, verifying and reusing existing approaches where possible.
Absent or underspecified implementation may be filled using these defaults, but does not by itself justify imposing defaults on established architecture.

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

### Configuration

Aim to preserve established configuration.
Only change or extend configuration when explicitly instructed or if necessary to complete the requested work.
When changing configuration, consider the impact on existing code.


## Project dependencies

Install project dependencies as needed.
Add missing npm scripts only when they are supported by the installed project dependencies.

Do not replace an already implemented framework in an existing project.
Do not migrate established tools or packages to this outline unless explicitly instructed.
When migrating, prefer a piece-by-piece approach over full-scale rewrites.

### React

React is our UI framework of choice and the baseline for this skill.
Projects that use another UI framework than React should not be considered with this skill.

Associated runtime packages
- react
- react-dom

### TypeScript

Greenfield projects must use TypeScript.
Use `tsc` consistently to ensure type-checking is performed.
Do not migrate an established JavaScript codebase to TypeScript unless explicitly instructed.

Associated dev packages:
- typescript
- @types/node
- @types/react
- @types/react-dom

Associated npm scripts
```json
{
    "tsc": "tsc -b"
}
```

### Vite

The chosen toolchain is Vite, used to transpile and serve the app.
If another toolchain exists, do not replace it unless instructed.

We try to assume as little as possible about the Vite config, because it can be very specific for each individual project.
For greenfield projects, we use the following `vite.config.ts` shape.
Keep in mind that even in greenfield projects, this configuration may already contain important bits and pieces that must be preserved.

```ts
import react from '@vitejs/plugin-react'
import { defineConfig, loadEnv } from 'vite'

export default defineConfig(({ mode }) => {
    const env = loadEnv(mode, process.cwd(), '')
    const port = parseInt(env.PORT) || 3000

    return {
        // ...

        plugins: [react()]

        build: {
            sourcemap: mode === 'development',
        },

        preview: {
            port
        },

        server: {
            port,
            hmr: env.DISABLE_HMR !== 'true',
            host: true,
        }
    }
})
```

Associated dev packages
- vite
- @vitejs/plugin-react

Associated npm scripts
```json
{
    "start": "vite",
    "dev": "vite",
    "preview": "vite preview",
    "build": "npm run tsc && vite build",
    "build:prod": "npm run build -- --mode production",
    "build:dev": "npm run build -- --mode development"
}
```

### Vitest

Use Vitest for testing, if Vite is the established toolchain.
Otherwise, defer to the user for a decision on testing tools.

As a starting point, we test only tooling and logic, not `.tsx` files or React-related code.
Defaults exclude the appropriate files for this purpose.

For testing we use the following defaults, added to `vite.config.ts`.
Do not merge configurations if a testing configuration is already established.

```ts
{
    // ...

    test: {
        // Vitest UI is enabled with --ui CLI arg.
        ui: false,
        silent: 'passed-only',
        // Generate coverage report available in Vitest UI.
        coverage: {
            // Coverage is enabled with --coverage CLI arg.
            enabled: false,
            reporter: ['text', 'html', 'lcov'],
            reportsDirectory: 'coverage',
            include: ['src/**/*.{js,ts}'],
            exclude: ['src/_generated/**'],
        }
    }
}
```

Also add the Vitest config type to the top of the file
```ts
/// <reference types="vitest/config" />
```

Associated dev packages
- vitest
- @vitest/coverage-v8
- @vitest/ui

Associated npm scripts
```json
{
    "test": "vitest run",
    "test:coverage": "npm run test -- --coverage",
    "test:ui": "vitest --ui --coverage"
}
```

### Prettier

Formatting is a must, and we prefer to use Prettier.

In greenfield projects, use the following `.prettierrc` configuration shape.
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

Associated dev packages
- prettier

Associated npm scripts
```json
{
    "format": "prettier --check .",
    "format:fix": "prettier --write ."
}
```

### ESLint

Linting is a must, and we prefer to use ESLint.

We use linting to protect the code from bugs and errors, not to strain the developer.
Any rules ignored by the established configuration must be respected.

Lint configuration should ignore transpiled and generated code.
For greenfield projects, we use the following `eslint.config.js` file.
Keep in mind that even in greenfield projects this file may already exist, in which case it should not implicitly be changed.

```js
import js from '@eslint/js'
import globals from 'globals'
import reactHooks from 'eslint-plugin-react-hooks'
import tseslint from 'typescript-eslint'
import { defineConfig, globalIgnores } from 'eslint/config'

export default defineConfig([
    globalIgnores(['dist', 'src/_generated']),
    {
        files: ['src/**/*.{ts,tsx}'],
        extends: [
            js.configs.recommended,
            tseslint.configs.recommended,
            reactHooks.configs.flat.recommended,
        ],
        languageOptions: {
            globals: globals.browser,
        },
    },
])
```

Associated dev packages
- eslint
- @eslint/js
- typescript-eslint
- globals
- eslint-plugin-react-hooks

Associated npm scripts
```json
{
    "lint": "eslint src/"
}
```

### OpenAPI generator

The OpenAPI generator is an optional dependency and should only be installed when instructed.
The generator reads an API specification and generates a client and the necessary DTO types to integrate with that API.

Using the OpenAPI generator is predicated on the API actually following and declaring such a specification.
In cases where the API does not, we do not include this dependency.

The following command can generate the client for an API.
Instead of running the command directly in the CLI, the client generation should be standardized as an npm script called `npm run generate-api`.

```sh
openapi-generator-cli generate -i "<API_URL/VERSION/DOMAIN>" -g typescript-fetch -o "src/_generated/api/<DOMAIN>" --additional-properties=useSingleRequestParameter=true
```

In many cases it is necessary to create a script file that parameterizes the domain and version of the generator and more, to create multiple different clients consistently.
Such a function should be compatible with the project, e.g. written in JavaScript or TypeScript.
Commands for such parameterized API generator scripts should be `npm run generate-api:domain` according to their domain.
In cases where multiple parameterized API client generators are declared, we also want to consolidate these with `npm run generate-api:all`.

The code generated by the OpenAPI generator must not be edited directly, but must be checked into version control.
Typically, the user will initiate API client generation. You must not regenerate the API client without permission from the user.
Problems with the API client should be flagged and reported for correction to those responsible for the API specification.
Always consult the user when generated code causes problems that cannot be solved within the given constraints by the generated clients.

Associated dev packages
- @openapitools/openapi-generator-cli


## Bootstrapping

Scaffold greenfield projects with `npm create`.
If `npm create` has already been run or is not right for this project, missing dependencies should be installed with the latest mutually compatible version with `npm install`.
Before determining the version to install, check the local environment and make sure to consult the user if the latest tools are not available.

- Runtime packages should be installed with `npm install --save package1 package2 ...`
- Dev packages should be installed with `npm install --save-dev package1 package2 ...`

If the install command is not directly runnable, provide the command to the user and let them run it instead.

### Scaffolding

In greenfield scenarios, the user will typically scaffold the project using `npm create`.
This means that a lot of structure will exist and the project should already be runnable.

Otherwise, the following command can be used to scaffold the project in an empty directory.
Make sure to get the user's permission before running the scaffolding command.

```sh
npm create vite@latest . --yes -- --template react-ts --eslint --no-interactive
```

### Environment

Every project needs an environment file.
Projects created with this skill need two mandatory environment files.

- `.env`: The live environment as it is used by the system locally.
    - This file must never be checked into version control.
    - You must not inspect this file without explicit permission.
- `.env.init`: An environment outline file describing the setup with placeholder values.
    - This file should be used as a template to create the environment file and is checked into version control.

Employ the following npm script to ensure `.env` always exists.
```json
{
    "postinstall": "npm run init-env",
    "init-env": "node ./scripts/init-env.js"
}
```

The `scripts/init-env.js` script ensures cross-platform support.
```js
import fs from 'fs'

if (!fs.existsSync('.env'))
    fs.cpSync('.env.init', '.env')
```

Note that environment variables used inside the Vite-built client-side source code must be prefixed with `VITE_`.

Initially, the environment file must include a `PORT` field, which defaults to `3000`.
For developer convenience, we include an option to disable hot module reloading with `DISABLE_HMR`, which defaults to empty.
If an API integration should be included or if the OpenAPI generator is installed, a `VITE_BASE_API_PATH` variable must also exist, which defaults to the placeholder value `http://localhost/api`.

### Version control

Use git for version control.

Include the following gitignore in a project when it's missing.
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
Strive to implement the following chain of communication with the given direction.
This dependency chain does not require every abstraction layer to exist.
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

