import { md2frontmatter } from './mdconv'

export const frontmatter = (md: string): string => md2frontmatter(md).join('\n')

export const inlineField = (md: string, name: string): string => {
    const field = md2frontmatter(md).find((l) => l.startsWith(name + ':'))
    if (!field) throw new Error(`Field ${name} does not exist.`)
    const value = field?.replace(/^[a-zA-Z0-9-_]+:/, '')?.trim()
    if (!value) throw new Error(`Field ${name} is empty or multiline.`)
    return value
}
