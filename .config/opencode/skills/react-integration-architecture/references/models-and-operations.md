# Models and operations

Read this reference when implementing getter-only models or mapping readable transport responses through React-independent operations.
Use its class-based model implementation as the default when no suitable modeling approach exists and a distinct readable model provides value.
Preserve suitable existing representations, including plain interfaces with pure mapping or computation functions; this reference does not require a migration to classes.
The examples show one coherent boundary: operations invoke clients and establish readable results; React-side state owners decide when those values replace existing state.
Adapt names and module organization to the project without changing these responsibilities.
The model implementation is independent of React, operations, and lifecycle mechanisms. Adopt it without adopting the other references.

## `ApiModel`

When choosing the class-based fallback, use this foundation for readable results:

```ts
export class ApiModel<T extends object> {
    public constructor(protected readonly data: T) {}

    public clone(overrides: Partial<T> = {}): this {
        const Constructor = this.constructor as new (data: T) => this
        const data = { ...this.data, ...overrides }

        return new Constructor(data)
    }
}
```

Subclasses inherit the single-data constructor.
Preserve this constructor contract so `clone` can reconstruct the concrete subclass.
The backing data is available to subclasses, while consumers use getters.
Models using this foundation have no setters or state-mutating methods.

`clone` constructs another instance of the concrete model class with a shallow copy and optional overrides.
Treat both the backing data and exposed nested values as immutable; this implementation does not deep-freeze or deep-copy them.
Replace nested values rather than modifying objects shared by the original and cloned instances.

## Getter-only subclass

Expose direct and computed getters without modifying model data:

```ts
interface EntryResponse {
    id: string
    title: string
}

export class Entry extends ApiModel<EntryResponse> {
    public get id(): string {
        return this.data.id
    }

    public get title(): string {
        return this.data.title
    }

    public get hasTitle(): boolean {
        return this.data.title.length > 0
    }
}
```

`EntryResponse` stands for the client's readable response contract.
It is shown here to make the example understandable, not as an instruction to duplicate an existing transport type.
Even a model containing only direct getters provides a consistent representation of the readable data contract and a place for future computed values.

## Replacing React state

A state owner replaces a model rather than mutating it.
For state that already holds an `Entry`, replacement can use:

```ts
setEntry((current) => current.clone({ title: nextTitle }))
```

This replaces local state; it does not persist a change to an external system.
Changes to external state are performed through integration operations.

## Mapping in an operation

An operation retains a configured client, packages a request, and maps the response before returning it.
Use this class structure when retaining a client and grouping operations is useful; suitable functions or service modules can fulfill the same responsibility:

```ts
interface EntryClient {
    getEntry(request: { id: string }): Promise<EntryResponse>
}

class EntryOperations {
    public constructor(private readonly client: EntryClient) {}

    public async get(id: string): Promise<Entry> {
        const response = await this.client.getEntry({ id })
        return new Entry(response)
    }
}
```

`EntryClient` defines only the transport contract this operation needs; its implementation and configuration are separate from this mapping example.
The operation contains no hooks, loading state, retained resource state, or provider composition.
Its promise returns a model or rejects, independently of which lifecycle mechanism later owns reactive state.
The use of `Entry` demonstrates class-based mapping, not a requirement that every operation return an `ApiModel` subclass.

This example maps directly to keep the responsibility visible.
Reuse suitable existing mapping helpers or base classes; extract shared mapping code when repetition makes it valuable.

Apply the same readable data contract to collections and to write responses that describe state.

Any suitable React-facing lifecycle mechanism can execute these operations without repeating client invocation or response mapping.
The [optional asynchronous hook reference](async-hooks.md) demonstrates one such implementation; neither the model nor the operation depends on it.
