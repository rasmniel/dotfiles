import { tool } from '@opencode-ai/plugin'

import { readFileContent } from '../lib/fs'
import * as Frontmatter from '../lib/frontmatter'

const PATH_ARG = tool.schema.string().describe('Path of the markdown file.')

export const frontmatter = tool({
    description: 'Read the entire frontmatter of a markdown file.',
    args: { path: PATH_ARG },
    execute: async (args) => {
        const markdown = await readFileContent(args.path)
        return Frontmatter.frontmatter(markdown)
    },
})

export const frontmatter_field = tool({
    description: 'Read an inline value of a field in the frontmatter of a markdown file.',
    args: {
        path: PATH_ARG,
        field: tool.schema.string().describe('Name of the frontmatter field.'),
    },
    execute: async (args) => {
        const markdown = await readFileContent(args.path)
        const field = args.field
        const value = Frontmatter.inlineField(markdown, field)
        return value
    }
})

