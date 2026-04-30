-- Status line customization.
return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons', enabled = vim.g.use_nerd_font },
    opts = {
        options = {
            icons_enabled = vim.g.use_nerd_font,
            section_separators = vim.g.use_nerd_font and nil or {},
            component_separators = vim.g.use_nerd_font and nil or { left = '|', right = '|' },
        },
        sections = {
            lualine_y = { 'searchcount', 'progress' },
            lualine_z = { 'lsp-status', 'location' },
        },
    },
}
