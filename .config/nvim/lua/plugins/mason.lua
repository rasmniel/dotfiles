--
-- MASON
--
-- LSP list can also be found here:
--  https://github.com/williamboman/mason-lspconfig.nvim?tab=readme-ov-file#available-lsp-servers
--
-- All LSPs take the following configuration options:
--  cmd (table): Override the default command used to start the server
--  filetypes (table): Specify the default list of associated filetypes for the server
--  capabilities (table): Add or override capabilities. Can be used to disable certain LSP features.
--  settings (table): Settings to configure the server.
--  on_attach (function): A function to call when the LSP attaches to a buffer.
--  init_options (table): Options to send to the lsp upon initial launch. Not all LSPs support this option. Not to be confused with settings.

-- Use this function to debug the client's capabilities.
-- The function can be passed as the server's on_attach argument.
---@diagnostic disable-next-line: unused-function, unused-local
local inspect_capabilities = function(client, bufnr)
    print(vim.inspect(client))
end

local lsps = {
    lua_ls = {
        settings = {
            Lua = {
                completion = {
                    callSnippet = 'Replace',
                },
                -- May toggle noisy `missing-fields` warnings
                -- diagnostics = { disable = { 'missing-fields' } },
            },
        },
    },

    -- All the typescript configuration documentation you could ever want: https://www.typescriptlang.org/tsconfig/
    -- https://github.com/microsoft/TypeScript/blob/v5.0.4/src/server/protocol.ts#L3418
    -- https://github.com/typescript-language-server/typescript-language-server/blob/master/docs/configuration.md
    -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#ts_ls
    ts_ls = {
        init_options = {
            preferences = {
                quotePreference = 'single',
            },
        },
    },

    emmet_ls = {
        -- Currently, all css-subtype files are are disabled to avoid faulty snippet errors caused by unescaped $
        filetypes = { 'css', 'eruby', 'html', 'javascript', 'javascriptreact', 'svelte', 'pug', 'typescriptreact', 'vue' },
        init_options = {
            html = {
                options = {
                    -- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
                    ['bem.enabled'] = true,
                },
            },
        },
    },

    superhtml = {},
    cssls = {},
    jsonls = {},

    bashls = {},
    -- systemd_ls = {},

    hls = {
        filetypes = { 'haskell', 'lhaskell', 'cabal' },
        on_attach = function(client, bufnr)
            -- Disable hls for tidal files.
            if vim.bo[bufnr].filetype == 'tidal' then
                -- TODO: This just stops the server, which means opening a .hs file will cause it to start again without executing this clause.
                --  Subsequently returning to a .tidal file will now have the LSP enabled, which is what we want to avoid.
                client.stop()
            end
        end,
    },

    csharp_ls = {},
    gopls = {},
}

local formatters = {
    stylua = {},
    prettierd = {},
    jq = {},
    shellcheck = {},
}

local installations = vim.tbl_extend('force', lsps, formatters)
-- Ensure installation of all listed mason-supported tools.
require('mason-tool-installer').setup({ ensure_installed = vim.tbl_keys(installations) })
require('mason-lspconfig').setup({
    -- Explicitly set an empty table to declare installs with mason-tool-installer instead.
    ensure_installed = {},
    -- Disable automatic_enable to avoid LSPs starting at incorrect times or in tandem.
    automatic_enable = false,
})

-- Create a table of all available capabilities by neovim and plugins.
local capabilities = vim.tbl_deep_extend('force', vim.lsp.protocol.make_client_capabilities(), require('cmp_nvim_lsp').default_capabilities())
-- Installed LSPs are configured by default and enabled automatically with mason-lspconfig
-- This loop overrides the default configuration with the custom config in this file.
for server, config in pairs(lsps) do
    -- Allow for individual servers to override capabilities.
    config.capabilities = vim.tbl_deep_extend('force', capabilities, config.capabilities or {})
    vim.lsp.config(server, config)
    vim.lsp.enable(server)
end

-- TODO Setup godot using same approach as above.
require('extras.godot').setup()
