local PACKAGE_CONFIG = {
    ['package.json'] = '"prettier":',
    ['package.yaml'] = 'prettier',
    ['package.toml'] = 'prettier',
}

local PRETTIER_CONFIG = {
    -- .prettierrc files (JSON or YAML)
    '.prettierrc',

    -- Specific extensions
    '.prettierrc.json',
    '.prettierrc.yml',
    '.prettierrc.yaml',
    '.prettierrc.json5',

    -- JavaScript/TypeScript module configs
    '.prettierrc.js',
    'prettier.config.js',
    '.prettierrc.ts',
    'prettier.config.ts',

    -- ES module configs
    '.prettierrc.mjs',
    'prettier.config.mjs',
    '.prettierrc.mts',
    'prettier.config.mts',

    -- CommonJS module configs
    '.prettierrc.cjs',
    'prettier.config.cjs',
    '.prettierrc.cts',
    'prettier.config.cts',

    -- TOML
    '.prettierrc.toml',
}

return {
    uses_prettier = function(bufnr)
        local root = require('extras.buf_root').get_buf_root_by_marker(bufnr, 'package.json')

        if root then
            -- Check for supported prettier config files.
            for _, config in ipairs(PRETTIER_CONFIG) do
                if vim.fn.filereadable(root .. '/' .. config) == 1 then
                    return true
                end
            end
            -- Check for embedded prettier config in package files.
            for config, field in pairs(PACKAGE_CONFIG) do
                local ok, lines = pcall(vim.fn.readfile, root .. '/' .. config)
                if ok then
                    for _, line in ipairs(lines) do
                        if string.find(line, field, 1, true) ~= nil then
                            return true
                        end
                    end
                end
            end
        end
        -- Prettier is not applicable for the given buffer.
        return false
    end,
}
