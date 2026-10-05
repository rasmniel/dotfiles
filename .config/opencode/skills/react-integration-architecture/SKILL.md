---
name: react-integration-architecture
description: Design, review, and evolve React transport architecture through clear API client, operation, model, hook, context, and provider responsibilities. Use when implementing or discussing API integration, modeled data, asynchronous hooks, shared state coordination, or provider composition in React projects. Applies to standalone applications and shared integration packages.
---

# React integration architecture

Build an understandable path from external data to reactive state and actions.
Define responsibilities clearly, implement only the structure that provides value, and omit abstractions that add ceremony.


## Applying the architecture

Use this skill as a preferred integration pattern, not a mandatory framework.
Preserve suitable established implementations. When a responsibility lacks an implementation, use the fitting reference as the default.
An implementation is suitable when it keeps transport responsibilities behind the integration boundary, provides an intentional readable data contract, gives reactive state a deliberate owner, and exposes predictable execution and failure behavior.
Choose implementations independently across responsibility boundaries; do not introduce parallel infrastructure or restructure established code merely to match the examples.

Read current integration code, its consumers, and relevant project guidance before proposing or making changes.
Match established conventions and distinguish architectural improvements from unrelated restructuring.
Discussion and review do not authorize implementation.

Reduce structural ceremony without obscuring responsibility ownership.
A responsibility need not have its own directory, package, or forwarding abstraction.
Introduce a separate abstraction when it gives that responsibility a useful home, removes repeated coordination, or protects a meaningful contract.

Design for human developers: favor recognizable execution paths, actionable failures, and behavior that can be inspected without tracing unnecessary indirection.
Explain material ambiguities instead of inventing requirements.

As requirements grow, extract responsibilities that are already distinguishable.
Do not burden a small application with speculative infrastructure simply because a larger application might eventually need it.

### Using the references

The references provide concrete, usable implementations whose scope and contracts can be inspected before adoption.
Models do not require the reference hooks, operations do not depend on React state, and context safeguards do not require particular models or clients.
Connect implementations through explicit contracts, not undocumented assumptions about their internal structure.
Keep cohesion within an implementation: the reference hooks share a lifecycle primitive, an internal hook owning their common execution behavior, to maintain consistency without duplication.


## Responsibility map

A horizontal layer groups related responsibilities across features, such as transport, operations, or React integration.
Models are readable data representations used across these layers, not a separate layer.
A boundary defines where responsibilities separate; an implementation is the concrete code that fulfills them.
An integration capability is a read or action exposed to consumers with the data or execution state needed to use it.

| Responsibility | Typical owner |
| --- | --- |
| External communication, transport configuration, request and response contracts | API clients |
| Client invocation, request packaging, response-to-model mapping | Integration operations |
| Readable data representation and associated computed values | Models |
| Reactive lifecycle and focused integration capabilities | Lifecycle mechanisms and integration hooks |
| Application state, coordinated actions, and shared ownership | Application composition |
| Presentation and user interaction using integration and application-facing capabilities | Application UI |

The normal responsibility relationship is:

```
API client → operations → integration hooks → application composition → application UI
```

Operations establish readable data contracts, mapping responses where needed.
Integration hooks expose models through reactive state or action results, and application composition and UI consume them.
Models represent data; they do not coordinate execution.
Providers supply configured integration dependencies or owned state.


## API clients and the transport boundary

The transport boundary keeps external communication details and request and response contracts within API clients.
The integration boundary exposes readable data and integration capabilities to consumers while keeping client invocation and internal operations private.
An API client's responsibility is the same whether it is handwritten or supplied by tooling or a dependency.

Configure clients centrally rather than reconstructing URLs, headers, and client instances throughout consumers.
Operations own invocation details such as endpoint request containers; ordinary consumers should not need to know how a client packages an endpoint call.

Make integration capabilities the natural access path for UI code.
Discourage direct client invocation in UI: it bypasses mapping and lifecycle contracts and duplicates integration knowledge.
Do not make such exceptions technically impossible, but treat a bypass as an explicit architectural decision rather than the normal path.

When a package boundary exists, expose deliberate entry points for models and integration capabilities. Keep operation implementations internal.
If raw transport access is needed, distinguish it explicitly from the normal integration interface.
Inside a standalone app, maintain the same distinction through module boundaries without requiring a separate package.

### Read and write contracts

Establish the readable data contract before exposing results through integration hooks, mapping or interpreting transport data where needed.
When a response already fits that contract, do not copy it into an identical representation merely to demonstrate a mapping step.
Apply the same readable data contract to write responses that describe state.

Reuse request types when they already express the intended input.
Do not duplicate a suitable transport request contract solely to create another type boundary.
Introduce a separate input contract when a form or workflow has genuinely different requirements, and map it at the boundary that owns those requirements.


## Readable models

A readable data contract defines the meaning and structure of data exposed to consumers; a model is its representation.
Preserve a suitable established representation, where a modeling approach exists.
When no modeling approach exists and a distinct readable model provides value, use getter-only classes based on `ApiModel` as the default.

Models follow the readable data contract independently of the lifecycle mechanism that exposes them to React.
When using `ApiModel`, subclasses inherit its single-data constructor and expose direct or computed getters while keeping backing data protected.
Read [the models and operations reference](references/models-and-operations.md) when implementing model classes or response mapping.
It includes the concrete `ApiModel` implementation, a getter-only subclass, state replacement, and response mapping in an operation.

Treat readable model values and exposed nested values as immutable, regardless of representation.
`ApiModel` subclasses have no setters or state-mutating methods; their `clone` makes a shallow copy and preserves the concrete model type.
This is a usage contract, not a deep-freezing mechanism.
Replace nested values rather than modifying shared nested objects.

React-side state owners replace readable values when they change, using object replacement, `clone`, or the established equivalent.
This replaces local state; it does not persist a change to the external system.
Changes to external state are performed through integration operations.
Keep transient write inputs separate from readable model instances.


## React-independent operations

An integration operation accepts inputs, invokes a configured client, and returns a result or rejects.
An execution is one invocation of asynchronous work, whether an operation or another callback.
Operations package transport requests and establish readable results without knowing about React state.
The operations layer can be implemented with functions, classes, or service modules.

An operation may retain its configured client, but it does not retain loaded application data, manage loading flags, update contexts, or mount providers.
This separation keeps transport integration usable without React and makes its execution path easy to follow.

The [models and operations reference](references/models-and-operations.md#mapping-in-an-operation) demonstrates this boundary with a client call that returns a model.

Keep operations focused and name them meaningfully within their owner.
Share mapping helpers where they remove real repetition, but do not force different endpoint behaviors into a universal CRUD abstraction.
Preserve meaningful transport semantics rather than hiding them behind misleading method names.

Operations do not absorb application workflows merely because those workflows call multiple endpoints.
Application composition coordinates focused integration capabilities.


## Asynchronous React lifecycle

A hook is a React function that connects reusable behavior to reactive state.
A lifecycle mechanism owns the reactive behavior of asynchronous work, connecting operations to observable data and execution state without repeating loading and error handling for every integration capability.

Use a suitable existing mechanism or choose an implementation that meets the project's needs.
Keep client invocation and response mapping in operations, regardless of which mechanism owns the reactive lifecycle.

Read [the optional asynchronous hook reference](references/async-hooks.md) when a lightweight implementation is useful or when examining one concrete realization of these responsibilities.
It provides `useAsyncOperation`, `useOne`, `useList`, and `useAction` with explicit scope and lifecycle contracts.

Resource state holds readable data associated with a requested resource; execution state reports pending work and failures.
Lifecycle state refers to the combined state managed by the lifecycle mechanism.

### Reads

Define when reads execute and how input changes affect the requested resource.
Automatic reads on mount and on relevant input changes are a useful default.
Expose the data and execution state consumers need, making initial loading, background work, and failures understandable.
Make refresh and reset behavior clear when exposed to consumers.

Refresh updates hook-owned read state; report its failures through that state rather than propagating them to callers.
Expose refresh as a non-rejecting `Promise<void>`: awaiting it waits for the attempt to settle but does not establish success or guarantee a committed React render.
Callers may await refresh for sequencing or initiate it without awaiting when follow-up work should proceed independently.
Use an explicit result-bearing action when a workflow needs a read result and per-call failure handling.

Distinguish data that has not loaded from a successful empty result.
For example, `undefined` and `[]` convey different states.
Retaining existing data while refreshing is a useful default: loading does not have to erase a previously available result.

### Actions

An action exposes explicitly initiated work through the React-facing interface; a mutation is work that changes external state.
An action may perform a manually requested read rather than a mutation.
Use explicit actions for state-changing work rather than running it automatically on mount.
Preserve operation inputs and make execution state, failures, and results available for reliable composition.
Returning results to callers without retaining them as persistent resource state is a useful default.

A composing hook or context can retain an action result when its workflow needs it.
Do not duplicate state simply because both a lifecycle mechanism and a caller could store the same result.

### Inputs and callable handles

Make request changes and execution behavior predictable:

- Relevant input changes identify the resource being requested and affect its lifecycle as intended.
- Callable identity is predictable where consumers depend on it; stable handles are one useful approach.
- Consumers can understand which operation and inputs a call will use, without accidentally executing obsolete behavior.

If a lifecycle mechanism uses explicit dependencies, declare all inputs that should trigger another read.

### Errors and completion

Expose failures consistently, preserving useful error information.

Make failure behavior explicit so callers can reliably compose operations.
Rejecting explicit action calls allows ordinary `try`/`catch` and promise composition; mechanisms with other failure APIs need equally clear contracts.
Read refresh handles contain their execution's rejection after lifecycle error reporting, so consumers do not need repeated catch-and-discard guards.
Automatically initiated work should expose failures through its lifecycle without leaving unhandled rejections.

Keep error interpretation with knowledgeable code.
Operations and lifecycle mechanisms should not invent universal meanings or recovery policies for transport failures.

Distinguish a successful write from unsuccessful follow-up work.
A completed mutation does not become unsuccessful merely because a subsequent read failed.
Mutation-success feedback and refresh-failure feedback are independent; expose refresh errors for presentation without making them reject the completed mutation.
Define what a composed action promises to complete and expose follow-up failures through their appropriate state or contract.

### Overlapping work

Handle concurrency in proportion to the interaction.
UI loading states and disabled controls can prevent ordinary conflicting actions.
When multiple operations form one coordinated interaction, compose them into one action with understandable progress, completion, and failure semantics.

Do not introduce synchronization for hypothetical overlaps.
If existing execution paths appear to require additional coordination for correctness, flag the discrepancy and explain which competing executions or input changes could overwrite state incorrectly.
First examine whether execution and state ownership are fragmented, and consider consolidating the interaction rather than layering guards onto separate paths.
Establish the intended behavior before implementing additional coordination; some overlaps are inherent to changing resource inputs rather than fragmented ownership.

The optional reference is a shared asynchronous lifecycle boundary with a deliberate latest-started execution policy across automatic reads, explicit executions, resets, and unmounting.
Its tighter execution tracking implements that specific contract, not a baseline for ordinary effects, application hooks, or state setters.
Do not copy its ref-based counters or invalidate state setters merely because application code awaits a result.

A lifecycle mechanism protects its own state, not separate state assigned by callers.
That distinction does not itself establish a race or require additional guards; identify and discuss a concrete discrepancy before extending protection to caller-owned state.
Where an established lifecycle contract handles obsolete results, respect its state ownership and reset or unmount behavior.
Preventing obsolete state updates does not necessarily cancel the underlying request or stop its promise settling for a caller.

Do not add general-purpose locks or workflow infrastructure where clear action composition and interaction state are sufficient.


## Focused integration hooks

Expose focused reads and actions around operations.
Consumers should receive integration capabilities with readable data and execution state, not client instances or broad operation collections.

A focused integration hook accesses operations through the project's configuration and dependency mechanism, then exposes integration capabilities through the chosen lifecycle mechanism.
Any operations-consumption hook remains an internal integration implementation detail, not a public shortcut for UI code.
An internal context is a useful way to supply operations.
The [optional focused capability examples](references/async-hooks.md#composing-focused-capabilities) demonstrate this boundary using the reference hooks.

Preserve endpoint-specific behavior without adding automatic pagination traversal, refresh, retries, or other policies merely because a hook could implement them.
Add such behavior where an actual requirement has a clear owner.


## Application composition

Application composition coordinates integration capabilities and owns additional application state through application hooks, contexts, or established equivalents.
Application state includes selections, editable drafts, and workflow state beyond the resource and execution state owned by the lifecycle mechanism.
A context supplies a value to descendants and can establish shared ownership; it is not a mandatory intermediary between integration hooks and UI.

Do not judge architecture by where a hook is called.
Direct UI consumption is appropriate when responsibilities remain intact.
Extract repeated coordination and state-control patterns into a useful hook or context under ordinary DRY reasoning.

Expose a meaningful application-facing contract rather than forwarding the complete hook result to every endpoint or bundling.
Make clear:

- Which data the composition owns.
- What each action promises to accomplish.
- Which loading and error states describe that work.
- Whether follow-up work is part of completion.
- How returned results affect retained state.

Keep a single deliberate owner for each state value.
A lifecycle mechanism may already own and share remote resource state.
Compose its capabilities without copying that state into another hook or context merely to match this pattern.
Application composition owns the additional coordination or state it actually introduces.
Derive values from their source where possible.
An editable draft can be intentionally independent state; make that distinction explicit rather than keeping accidental copies synchronized.

Coordinate related operations through application composition when they constitute an application workflow.
Refreshing, replacing known state, or leaving results local are different consistency choices, not mandatory mutation steps.
Keep the chosen policy with the behavior that requires it.


## Providers and configuration

A provider supplies configured integration dependencies or owned state to its consumers.
Keep provider dependencies visible in application composition rather than silently adding unrelated integration dependencies inside shared infrastructure.
Use providers for context-based provision, or supply configured integration dependencies through modules or other established mechanisms.

The application supplies configuration.
Integration code should not discover application-specific environment settings, mount the application root, or select workflows on its behalf.
Apply this boundary inside standalone apps as well as shared packages.

Separate configuring integration dependencies from executing data requests.
Constructing clients and operations does not itself require fetching application resources; read hooks initiate their declared lifecycle.

Avoid recreating integration dependencies in ways that unintentionally restart work or discard state.
Ensure meaningful configuration changes reach consumers, using stable instances and memoization where their lifetime requires it.
Do not introduce instance management for operation functions that already have a suitable lifetime.

### Safe context consumption

For contexts that require a provider, prefer a dedicated consumption hook or preserve an equivalent safe consumption API.
Use `useRequiredContext` when no equivalent safeguard is in place: it reports missing providers at consumption rather than allowing misleading failures later.
Keep provider absence distinguishable from ordinary loading or unavailable data inside the provided value.
Preserve intentional context defaults: optional provider consumption is a different contract.

Read [the contexts and providers reference](references/contexts-and-providers.md) when implementing dependency provision or required-context consumption.
It includes the safeguard and dedicated consumption-hook example, application-facing context example, and guidance on existing consumers.

When working on existing context consumption, replace unsafe assertions or placeholder defaults with this safeguard where appropriate.
Changing an intentional default to a required-provider contract requires an explicit decision.


## Architectural review

Use these questions to check whether the architecture is understandable and valuable:

- Where does client invocation belong, and can UI consumers avoid knowing its details?
- Where is the readable data contract established, and where does response mapping belong?
- Are operations independent of React state and application workflows?
- Who owns asynchronous state, and what do reads and actions promise?
- How do hooks and contexts compose without duplicating responsibilities or state?
- How is configuration supplied, and what happens when it changes?
- Are failures handled where their affected state is owned?
- Which abstraction solves a present problem, and which merely adds ceremony?
- Do the contracts between layers allow their implementations to change independently?
