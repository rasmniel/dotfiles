---
name: import-sorting
description: This skill must be used when adding, removing, or changing code imports in any way, or whenever asked to change or sort code imports.
---

# Sorting code imports

Code imports can become messy and we want to avoid that consistently, therefore we sort code imports heuristically according to a soft order.
To this end we define an outline for ordering imports such that they are associatively grouped and easy to browse.

When purely sorting imports it is imperative that the individual line doesn't change internally, but stays the exact same.
We are not looking for help improving import structure or import architecture, but rather readabilitly of the imports by merit of ordering them sensibly.


# Order of imports

The order of imports rely on a set of rules that should be fairly easy to follow.
All imports live at the top of the file.

Code imports are often somewhat hierarichal in nature, that is to say, some imports are more "important" than others.
In this case, we want to order "most important" imports on top. The order would be something like:

1. Dependency imports, starting with core framework and listing depending libraries and components under it.
2. Blank line
3. Core code imports used in this file. In UI code this would be self-contained components and mechanisms that are used to build the UI.
4. Secondary code imports, e.g. helpers and models. In most files models and helpers are somewhat distanced from the core functions of that file.
5. Blank line
6. Data files, e.g. json or csv file imports and similar.

Notice how there are specific blank lines AFTER external dependencies and BEFORE data dependencies.
These are the only blank lines allowed. Absolutely no other blank lines are allowed in the import region whatsoever.
In cases where blank lines collide within the import lines, they should be collapsed to a single blank line.


# Definition of imports

When sorting imports we make a distinction between different kinds of imports based on their positional relation to the file and the responsibility they have.
When talking about these aspects of distinction, it is important to understand that they are _guidelines_ to help identify how imports could ideally be ordered.
There can be multiple acceptable solutions to ordering imports, but the following set of constraints will help us understand when the order is wrong based on the import type.

## External imports

Imports that pertain to external libraries and dependencies are added first at the very top.
After the external dependencies we need to include a blank line to seperate these imports from the internal ones.

## Internal imports

Imports that pertain to the project source code directly and contain code editable by the project developer should come after the external imports.
These internal imports are where the most important sorting ruleset comes in:

1. The import with the path nearest to the current file should be on top, and paths with shallower depth should come before deep paths, e.g.
    - `./` and should come before paths starting with `../`
    - `./file` should come before `./folder/file`
2. All imports should be grouped by their namespace, e.g.
    - `./common/a` and `./common/b` should be grouped
    - `./common/a` should come before `./common/b`
    - `./common/a` should _not_ be  grouped with `./components/a`
    - `./common/pure/a` should be grouped with `./common/pure/b`, but come after the `./common/...` grouping
3. Attempt to list most generically sounding imports on top and more specifically sounding imports on the bottom, e.g.
    - `import { Container } from './layout'` is more generic than and should be above `import { TableContainer } from './table'`
    - `import { Row, Column } from './layout'` is less generic than and should be below `import { Container } from './layout'`,
        but more generic than and should be above `import { TableContainer } from './table'`
4. Attempt to group concepts associatively despite not being alphabetically correct, e.g.
    - `import { Column, Row } from '../common/FlexContainer'` is very closely related conceptually to `import { ContentColumn } from '../common/layout'`,
        and these two imports should be placed as close to each other as possible, preferably with the most generic component on top as previously discussed.
5. In rare cases, internal imports may reference generated code or similar black-box code.
    - These imports will often contain a slug called "/gen/" or "/generated/" or similar naming indicating that containing code is generated
    - They may also include a `.`, `_`, or similar prefix to denote their transience.
    - Imports referencing generated or black-box code should be on top of the region of internal imports.

Whenever there's an overlap or collision, sort the imports alphabetically.
Note that alphabetical sorting is the least important and can generally be omitted in favor of more sensible association between imports.

## Data imports

Imports that contain data, e.g. json or csv, should be at the bottom end of the imports list.
If any of these imports exist, a single blank line should separate them from the previous import region.


# Imports in different project types

Depending on the context, imports may come in different flavors. Use your existing knowledge to determine if a dependency is internal or external to the project.
Here are a few examples of how imports can appear in different languages:

## TypeScript
This is an example of import sorting in TypeScript and instructions to what imports look like and how to identify them.

External imports are contained within the string as just the raw name or the library.
They rarely contain any symbols or seperators as they are referenced by just that a single name.
However, this is a rule of thumb, not a constant truth.

Internal imports ALWAYS represent a path to the given file. This means it will ALWAYS start with `./` or `../`.
This is a hard rule that is absolutely reliable when determining what kind of import a line is.
Most of the time, internal code imports do not include an extension.
Sometimes they do, but the extension will always conform to this regex for TypeScript/JavaScript files: `/(j|t)sx?/`

Data imports ALWAYS use an extension, which will always be the relevant extension for the data type.
Typically these data files will be `.json`, `.csv`, or `.xml`, however other data files can occur.


# Examples

In an arbitrary React component, these imports could be considered correctly ordered:

```
import react from 'react'
import { navigate } from 'react-router-dom'
import { Button } from 'react-ui-framework'

import { Container } from '../../layout/Container'
import TextField from '../../common/TextField'
import NumberField from '../../common/NumberField'
import TypeScreen from '../../screens/TypeScreen'
import { useDataContext } from '../../contexts/DataContext'
import { useMetaContext } from '../../contexts/MetaContext'
import { calculation } from '../../tools/math'
import { translation } from '../../tools/lang'

import exceptions from '../data/exceptions.csv'
import constraints from '../data/constraints.json'
```
