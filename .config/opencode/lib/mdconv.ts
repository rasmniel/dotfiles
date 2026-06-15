export const md2lines = (text: string) =>
    text.split(/(\r?\n|\r)/).filter((l) => !!l)

export const lines2frontmatter = (lines: string[]) => {
    const frontmatter: string[] = []
    if (lines.shift()?.trim() === '---') for (const line of lines) {
        if (line.trim() === '---') break;
        frontmatter.push(line)
    }
    return frontmatter
}

export const md2frontmatter = (text: string) => {
    const lines = md2lines(text)
    return lines2frontmatter(lines)
}
