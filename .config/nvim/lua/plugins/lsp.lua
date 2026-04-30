--
-- LSP
--

return {
    'neovim/nvim-lspconfig',
    dependencies = {
        -- Automatically install LSPs and related tools to stdpath for Neovim.
        -- Mason must be loaded before its dependents so we need to set it up here.
        { 'williamboman/mason.nvim', opts = {} },
        'williamboman/mason-lspconfig.nvim',
        'WhoIsSethDaniel/mason-tool-installer.nvim',

        -- Useful status updates for LSP.
        { 'j-hui/fidget.nvim', opts = {} },

        -- Allows extra capabilities provided by nvim-cmp.
        'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
        -- TODO: Decouple autocmd and telescope.builtin from the lsp config

        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
            callback = function(event)
                local map = function(keys, func, desc, mode)
                    mode = mode or 'n'
                    vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                end

                -- Find the definition of the symbol under the cursor.
                map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

                -- Find references for the symbol under the cursor.
                map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

                -- Find implementations of the symnol under the cursor.
                map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

                -- Jump to the declaration of the symbol under the cursor.
                map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

                -- Jump to the type of the symbol under the cursor.
                map('gt', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

                -- Rename the variable under the cursor.
                map('<leader>cr', vim.lsp.buf.rename, '[R]ename symbol')

                -- Execute a code action at the cursor position.
                map('<leader>ca', vim.lsp.buf.code_action, 'Code [A]ction', { 'n', 'x' })

                -- Add a single-line border to the hover documentation window.
                map('K', function()
                    vim.lsp.buf.hover({ border = 'single' })
                end, 'Override default lsp.buf.hover kepmap to use a border')

                -- Highlight relevant references when resting the cursor over a symbol.
                local client = vim.lsp.get_client_by_id(event.data.client_id)
                if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
                    local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
                    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                        buffer = event.buf,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.document_highlight,
                    })

                    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                        buffer = event.buf,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.clear_references,
                    })

                    vim.api.nvim_create_autocmd('LspDetach', {
                        group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
                        callback = function(detach_event)
                            vim.lsp.buf.clear_references()
                            vim.api.nvim_clear_autocmds({ group = 'lsp-highlight', buffer = detach_event.buf })
                        end,
                    })
                end
            end,
        })

        -- Configure mason after lspconfig, because mason depends on lspconfig.
        require('plugins.mason')
    end,
}
