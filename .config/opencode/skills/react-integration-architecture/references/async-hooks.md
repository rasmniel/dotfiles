# Asynchronous integration hooks

This reference provides usable hooks for asynchronous execution and local React state.
Use them as the default fallback when no suitable lifecycle mechanism exists and their scope meets the project's needs, or inspect them as a concrete example of lifecycle composition.
Preserve suitable existing lifecycle mechanisms rather than introducing a parallel hook system.
Choosing another implementation does not require changing the surrounding architectural boundaries or reproducing these hooks' names, tuple format, or specific lifecycle policies.
The hooks accept asynchronous callbacks and their results without requiring `ApiModel`, operation classes, or a context-based dependency mechanism.

These hooks do not provide:

- Shared caching and resource identity across consumers.
- Request deduplication across separate hook instances.
- Coordinated invalidation and refetching of related resources.

When those shared-resource behaviors are required, these hooks alone are insufficient.
Choose or introduce a lifecycle mechanism that provides them; models, operations, and integration capabilities can retain their responsibilities through that transition.

## Composition and contracts

| Hook | Responsibility | Exposed result |
| --- | --- | --- |
| `useAsyncOperation` | Internal lifecycle primitive | Lifecycle state, execution, and reset handles |
| `useOne` | Automatic read of one value | `[data, isLoading, error, refresh, reset]` |
| `useList` | Collection-shaped specialization of reads | `[items, isLoading, error, refresh, reset]` |
| `useAction` | Explicit execution | `[isLoading, error, action, reset]` |

When using this reference implementation, keep `useAsyncOperation` as its internal lifecycle primitive.
Focused integration hooks compose `useOne`, `useList`, or `useAction` so their read or action intent remains visible.
The wrapper hooks share lifecycle behavior without sharing every public responsibility.
Their internal dependencies are deliberate: adopting this implementation keeps its shared primitive and wrappers together, without prescribing implementations outside this lifecycle mechanism.

This implementation has the following contracts:

- Reads execute on mount and when their declared dependencies change.
- Data starts as `undefined`; a loaded empty list is `[]`.
- Existing data remains available while refreshing and after a failed refresh.
- Actions are lazy, preserve their arguments, and return their results to callers without exposing retained result state.
- Refresh, action, and reset handles have stable identities. Execution uses the callback from the latest committed render whose layout effects have run.
- Starting an execution clears its previous error. Only the latest-started execution may publish a result or error to lifecycle state.
- Older internal executions still resolve or reject; read refresh handles consume their rejection, while action callers still receive it.
- Reset clears state and invalidates pending updates. Unmount also invalidates pending updates; neither cancels underlying work.
- Actions reject to their callers. Automatic reads and explicit refreshes consume execution rejections after lifecycle error reporting.
- Refresh returns `Promise<void>` and resolves when its attempt settles, regardless of success. Data and errors are exposed through read state, not its return value.

These hooks assume supplied asynchronous callbacks reject with `Error` instances and expose failures through their execution lifecycle.
Place error interpretation, translation, and recovery at the boundary that understands the failure.
Keep generic lifecycle code focused on execution state rather than imposing an application-wide error policy.

These hooks do not map transport responses, configure clients, coordinate workflows, or automatically refresh other reads.
Operations perform mapping before results reach the hooks. Application composition owns any follow-up policy.

## `useAsyncOperation.ts`

The lifecycle primitive owns lifecycle state and execution identity tracking.
A ref supplies the committed callback to a stable execution handle; an execution counter prevents older completions from replacing newer lifecycle state.
Update the callback ref in a layout effect, not during render, so an interrupted or discarded render cannot replace the callable operation.
Layout effects run before the passive effect that starts an automatic read.
Mount cleanup also runs in the layout phase, invalidating pending completions without changing what their callers receive.
This implementation records and rethrows the caught error without normalization.

```ts
import { useCallback, useLayoutEffect, useRef, useState } from 'react'

interface AsyncOperationState<TResult> {
    readonly data: TResult | undefined
    readonly isLoading: boolean
    readonly error: Error | undefined
}

interface AsyncOperationResult<TArguments extends unknown[], TResult> extends AsyncOperationState<TResult> {
    readonly execute: (...args: TArguments) => Promise<TResult>
    readonly reset: () => void
}

export function useAsyncOperation<TArguments extends unknown[], TResult>(
    operation: (...args: TArguments) => Promise<TResult>,
    initiallyLoading: boolean
): AsyncOperationResult<TArguments, TResult> {
    const operationRef = useRef(operation)
    const mountedRef = useRef(false)
    const executionRef = useRef(0)
    const [state, setState] = useState<AsyncOperationState<TResult>>({
        data: undefined,
        isLoading: initiallyLoading,
        error: undefined,
    })

    useLayoutEffect(() => {
        operationRef.current = operation
    }, [operation])

    useLayoutEffect(() => {
        mountedRef.current = true

        return () => {
            mountedRef.current = false
            executionRef.current += 1
        }
    }, [])

    const execute = useCallback(async (...args: TArguments): Promise<TResult> => {
        const execution = ++executionRef.current

        setState((current) => ({
            ...current,
            isLoading: true,
            error: undefined,
        }))

        try {
            const data = await operationRef.current(...args)

            if (mountedRef.current && execution === executionRef.current)
                setState({ data, isLoading: false, error: undefined })

            return data
        } catch (reason) {
            const error = reason as Error

            if (mountedRef.current && execution === executionRef.current)
                setState((current) => ({ ...current, isLoading: false, error }))

            throw error
        }
    }, [])

    const reset = useCallback(() => {
        executionRef.current += 1
        setState({ data: undefined, isLoading: false, error: undefined })
    }, [])

    return { ...state, execute, reset }
}
```

This protects the primitive's state, not arbitrary state written by a caller after awaiting a result.
Keep any additional result ownership and concurrency decisions with the code that owns that additional state.
The loading flag describes the current execution, not the number of outstanding promises.
The mount flag rejects completion updates after unmount, while the counter distinguishes overlapping executions and invalidates work across reset or remount.
Invoke execution handles from interactions or effects, not during render. When composing layout effects, declare the consuming effect after the lifecycle hook so its callback ref has been updated first.

## `useOne.ts`

`useOne` reads a single asynchronously produced value, in contrast to the collection read exposed by `useList`.
Its callback is parameterless: capture request inputs and declare the inputs that should trigger another read as dependencies.
Omitting dependencies executes the read on mount, not on every render.
Keep the dependency list's length and ordering consistent across renders.

```ts
import { useCallback, useEffect, type DependencyList } from 'react'

import { useAsyncOperation } from './useAsyncOperation'

export type UseOneResult<T> = readonly [
    data: T | undefined,
    isLoading: boolean,
    error: Error | undefined,
    refresh: () => Promise<void>,
    reset: () => void,
]

export function useOne<T>(
    operation: () => Promise<T>,
    dependencies: DependencyList = []
): UseOneResult<T> {
    const { data, isLoading, error, execute, reset } = useAsyncOperation(operation, true)

    const refresh = useCallback(async (): Promise<void> => {
        try {
            await execute()
        } catch {
            // The primitive owns lifecycle error reporting.
        }
    }, [execute])

    useEffect(() => {
        void refresh()
    }, dependencies) // eslint-disable-line react-hooks/exhaustive-deps

    return [data, isLoading, error, refresh, reset]
}
```

The primitive owns lifecycle error reporting; the stable refresh handle consumes its invocation's rejection for both automatic reads and explicit refreshes.
Awaiting `refresh` waits for that invocation to settle but does not establish success or guarantee a committed React render. Consumers read data and errors from hook state.
Callers may use `await refresh()` for sequencing or `void refresh()` to proceed independently without rejection guards.
For example, a successful creation can show its success notification immediately and initiate refresh without awaiting it; a failed refresh is a separate read-state signal for the application to present.
Reset does not itself restart the read; a dependency change or explicit refresh can do so.

### Dependency forwarding and linting

Caller-controlled dependencies are appropriate when the wrapper preserves them unchanged and its internal lifecycle dependencies remain stable.
The caller lists every input that should trigger an automatic read. `useList` and `useOne` forward that list without filtering, reordering, or supplementing it.
The effect calls the stable `refresh` handle, which wraps the stable `execute` handle accessing the committed callback through a ref; the wrapper introduces no hidden changing dependency.
Maintain these guarantees when modifying the implementation. Keeping the callback current does not trigger a read when an input is missing from the dependency list.

The disable comments apply only to opaque forwarding expressions; keep dependency checking enabled at call sites.
If using another linter, replace these directives with its equivalent narrowly scoped suppression.

## `useList.ts`

`useList` gives collection reads a recognizable name without duplicating their lifecycle.
It retains the returned array unchanged: mapping, pagination, and collection-management policy do not belong in this wrapper.

```ts
import type { DependencyList } from 'react'

import { useOne, type UseOneResult } from './useOne'

export type UseListResult<T> = UseOneResult<T[]>

export function useList<T>(
    operation: () => Promise<T[]>,
    dependencies?: DependencyList
): UseListResult<T> {
    return useOne(operation, dependencies) // eslint-disable-line react-hooks/exhaustive-deps
}
```

## `useAction.ts`

`useAction` does not execute on mount.
Its action handle preserves the callback's argument and result types, including operations that resolve with no readable result.
The common primitive records a result internally, but this wrapper does not expose it as retained resource state.
Callers use the returned result directly or retain it deliberately when their workflow requires it.

```ts
import { useAsyncOperation } from './useAsyncOperation'

export type UseActionResult<TArguments extends unknown[], TResult> = readonly [
    isLoading: boolean,
    error: Error | undefined,
    action: (...args: TArguments) => Promise<TResult>,
    reset: () => void,
]

export function useAction<TArguments extends unknown[], TResult>(
    operation: (...args: TArguments) => Promise<TResult>
): UseActionResult<TArguments, TResult> {
    const { isLoading, error, execute, reset } = useAsyncOperation(operation, false)

    return [isLoading, error, execute, reset]
}
```

## Composing focused capabilities

Compose the lifecycle around operations, not raw client calls or response mapping.
These composition fragments assume existing operations, their internal consumption hook, the lifecycle imports above, and the application's request type:

```ts
export function useEntry(id: string) {
    const { entries } = useIntegrationOperations()
    return useOne(() => entries.get(id), [entries, id])
}

export function useEntries() {
    const { entries } = useIntegrationOperations()
    return useList(() => entries.list(), [entries])
}

export function useCreateEntry() {
    const { entries } = useIntegrationOperations()
    return useAction((request: CreateEntryRequest) => entries.create(request))
}
```

This example supplies operations through internal integration context; another suitable dependency mechanism can supply those operations.
Readable results follow the operations' readable data contracts, represented by classes or plain data.
The request type and operation collection in this example stand for the integration contracts of the application.
No particular client, package layout, or provider implementation is required.

React may rerun mount effects in development Strict Mode, so automatic reads must tolerate repeated execution.
Invalidating an obsolete execution protects lifecycle state; it does not deduplicate requests or make side effects safe.
Keep state-changing operations behind explicit actions rather than automatic reads.
