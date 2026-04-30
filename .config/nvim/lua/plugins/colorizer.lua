-- Highlight color expressions.
return {
    'norcalli/nvim-colorizer.lua',
    config = function()
        local opts = {
            names = false,
            no_names = true,
            RRGGBBAA = true,
            rgb_fn = true,
            hsl_fn = true,
            css = false,
            css_fn = true,
        }
        require('colorizer').setup({ ['*'] = opts }, opts)
    end,
}
