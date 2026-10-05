# Contexts and providers

Read this reference when implementing required-context consumption or supplying integration dependencies through providers.
A context makes a value available to descendants; its provider supplies that value.
The consumption hook establishes how consumers access it and what happens when its required provider is absent.
Use this implementation as the default when a required context has no equivalent consumption safeguard.
It works with any suitable context value and does not depend on `ApiModel`, the reference lifecycle hooks, or a particular client.

## Required-context safeguard

For contexts that require a provider, use this safeguard when no equivalent is in place.
It reports invalid composition at consumption rather than allowing misleading failures later.

```ts
import { useContext, type Context } from 'react'

export function useRequiredContext<T>(context: Context<T | undefined>, name: string): T {
    const value = useContext(context)
    if (value === undefined) throw new Error(`${name}Context must be used within a ${name}Provider`)
    return value
}
```

This is a fail-fast consumption contract, not a React Error Boundary or an error-presentation mechanism.
It throws an actionable error; it does not render recovery UI.

## Application-facing context

Contexts should offer a dedicated consumption hook using `useRequiredContext`.
With conceptual implementation, the `EntityContext` can provide `Entity` models and their mutation handles to the application layer.

```tsx
import { createContext } from 'react'

import { useRequiredContext } from './useRequiredContext'

interface EntityContextValue {
    data: Entity[]
}

const EntityContext = createContext<EntityContextValue| undefined>(undefined)

export default function EntityProvider({ children }: PropsWithChildren) {
    const [entities, isLoading, error, refresh] = useEntities()
    const [isCreating, createError, create] = useCreateEntity()
    const [isReplacing, replaceError, replace] = useReplaceEntity()
    const [isDeleting, deleteError, remove] = useDeleteEntity()

    const createEntity = async (request: CreateEntityRequest) => {
        const entity = await create(request)

        await refresh()

        return entity
    }

    const replaceEntity = async (id: string, request: UpdateEntityRequest) => {
        const entity = await replace(id, request)

        await refresh()

        return entity
    }

    const deleteEntity = async (id: string) => {
        await remove(id)

        await refresh()
    }

    return <EntityContext.Provider value={value}>{children}</EntityContext.Provider>
})

export const useEntityContext = () => useRequiredContext(EntityContext, 'Entity')
```

`DataContextValue` stands for the configured dependencies or owned state supplied by the corresponding provider.
The local import illustrates the relationship between the helper and context; adapt its location to the project.
Consumers use the dedicated hook rather than repeating checks or asserting that the context must exist.


## Intentional defaults and existing consumers

Apply the safeguard to required providers, not every context indiscriminately.
A context with an intentional, useful default has a different contract and can remain consumable without a provider.
Preserve suitable existing safeguards, including those using a different absence sentinel; distinguish missing provision from ordinary resource state rather than requiring this helper's API.

When working on existing consumption, replace unsafe assertions or placeholder defaults where the provider is already required.
First distinguish a typing placeholder from an intentional fallback: replacing the latter with a throw changes behavior.
Do not initiate an unrelated migration or change an optional provider into a required one without an explicit decision.


## Provider responsibilities

Providers supply configured integration dependencies or owned state; they do not silently select application workflows.
The application supplies configuration and makes provider dependencies visible in composition.
Keep these responsibilities whether the integration lives in a shared package or inside one app.
Context is one way to supply integration dependencies; it does not replace suitable existing module configuration or dependency mechanisms merely to match the examples.

Constructing clients and operations is separate from initiating data requests.
Keep their identities stable where consumers depend on their lifetime, replacing them when meaningful configuration changes require it.
Dependent hooks must observe those changes; memoization serves this lifetime contract rather than being a general requirement for every value or operation function.

A shared context is not a mandatory intermediary for every integration hook.
Use application hooks and contexts for application composition and shared ownership without exposing internal clients or operation collections to UI consumers.

