local prettier_or = function(fallback)
    fallback = fallback or { lsp_format = 'fallback' }
    return function(bufnr)
        local uses_prettier = require('extras.prettier').uses_prettier(bufnr)

        if uses_prettier then
            return { 'prettierd' }
        end

        return fallback
    end
end

return {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
        {
            '<leader>f',
            function()
                require('conform').format({ async = true, lsp_format = 'fallback' })
            end,
            mode = '',
            desc = 'Format buffer',
        },
    },
    opts = {
        notify_on_error = true,
        lsp_fallback = true,
        -- Formatters do not support options, but instead use the nearest conventional configuration file.
        formatters_by_ft = {
            lua = { 'stylua' },

            javascript = prettier_or(),
            javascriptreact = prettier_or(),
            typescript = prettier_or(),
            typescriptreact = prettier_or(),
            html = prettier_or({ 'superhtml' }),
            css = prettier_or(),
            json = prettier_or({ 'jq' }),
        },
    },
}
