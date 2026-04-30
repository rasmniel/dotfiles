require('plugins.lazy')

require('lazy').setup({
    -- TODO: spec = { import = 'plugins' }

    require('plugins.lsp'),

    require('plugins.cmp'),

    require('plugins.treesitter'),

    require('plugins.telescope'),

    require('plugins.conform'),

    require('plugins.vimsleuth'),

    require('plugins.gitsigns'),

    require('plugins.lazydev'),

    require('plugins.whichkey'),

    require('plugins.autopairs'),

    require('plugins.autotag'),

    require('plugins.lualine'),

    require('plugins.theme'),

    require('plugins.ibl'),

    require('plugins.todocomments'),

    require('plugins.colorizer'),

    require('plugins.rainbowcsv'),

    require('plugins.kulala'),

    require('plugins.tidal'),

    require('plugins.csharpls'),
}, {
    rocks = {
        enabled = false,
    },
    ui = {
        icons = vim.g.use_nerd_font and {} or {
            cmd = '⌘',
            config = '🛠',
            event = '📅',
            ft = '📂',
            init = '⚙',
            keys = '🗝',
            plugin = '🔌',
            runtime = '💻',
            require = '🌙',
            source = '📄',
            start = '🚀',
            task = '📌',
            lazy = '💤 ',
        },
    },
})
