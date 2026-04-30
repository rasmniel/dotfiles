-- Highlighting for emphasized comments.
return {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
        signs = false,
        highlight = {
            -- Improve flexibility of the highlighted string.
            pattern = [[\s?(KEYWORDS)\s*:?\s]],
        },
    },
}
