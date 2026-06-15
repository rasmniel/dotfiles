import { readFile, stat } from 'node:fs/promises'
import { isAbsolute, resolve } from 'node:path'

export const resolvePath = async (path: string): Promise<string> => {
    const filePath = isAbsolute(path) ? path : resolve(process.cwd(), path)
    const info = await stat(filePath)
    if (!info.isFile()) throw new Error(`The path "${path}" is not a valid file.`)
    return filePath
}

export const readFileContent = async (path: string): Promise<string> => {
    const filePath = await resolvePath(path)
    return await readFile(filePath, 'utf-8')
}
