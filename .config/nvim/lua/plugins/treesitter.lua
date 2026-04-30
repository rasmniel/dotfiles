--
-- TREESITTER
--

return {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs',
    opts = {
        highlight = { enable = true },
        indent = { enable = true },
        auto_install = true,
        ensure_installed = {
            'bash',

            'haskell',
            'supercollider',

            'diff', -- git diff

            'html',
            'css',

            'markdown',
            'markdown_inline',

            'http',
            'query', -- treesitter query

            'lua',
            'luadoc',

            'vim',
            'vimdoc',

            'javascript',
            'jsdoc',
        },
    },
}
