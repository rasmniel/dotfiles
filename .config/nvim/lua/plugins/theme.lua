--
-- THEME
--

return {
    {
        'folke/tokyonight.nvim',
        priority = 1000,
        config = function()
            ---@diagnostic disable-next-line: missing-fields
            require('tokyonight').setup({
                styles = {
                    -- Disable italic comments.
                    comments = { italic = false },
                    keywords = { italic = false },
                },
            })
        end,
    },
    {
        'xiantang/darcula-dark.nvim',
        -- Load theme plugin before any other plugins.
        priority = 1000,
        config = function()
            local color = {}
            ---@diagnostic disable-next-line: missing-fields
            require('darcula').setup({
                -- Copy colors through the override function in the darcula color scheme.
                -- The function is called before flow of control continues from the setup call.
                override = function(darcula_color)
                    color = darcula_color
                    return darcula_color
                end,
            })

            local apply_darcula_override = function()
                -- Override white/gray diagnostic info.
                vim.api.nvim_set_hl(0, 'DiagnosticInfo', { ctermfg = 4, fg = '#8bbe3c' })
                -- Override pale diagnostic warning to be brighter.
                vim.api.nvim_set_hl(0, 'DiagnosticWarn', { ctermfg = 3, fg = '#fe7203' })
                -- Better search highlight colors.
                vim.api.nvim_set_hl(0, 'Search', { bg = '#00a3ee', blend = 10, ctermbg = 11, ctermfg = 0, fg = '#111122' })
                vim.api.nvim_set_hl(0, 'IncSearch', { bg = '#001099', fg = '#eeeeff' })
                vim.api.nvim_set_hl(0, 'CurSearch', { bg = '#001099', fg = '#eeeeff' })
                -- Border and background colors for floating windows.
                vim.api.nvim_set_hl(0, 'NormalFloat', { bg = color.very_dark_grey })
                vim.api.nvim_set_hl(0, 'FloatBorder', { fg = color.very_dark_grey, bg = color.very_dark_grey })
                -- Bring out the results title, which is hidden by default due to matching fg and bg colors.
                vim.api.nvim_set_hl(0, 'TelescopePromptTitle', { fg = color.burnt_orange })
                vim.api.nvim_set_hl(0, 'TelescopePromptPrefix', { fg = color.burnt_orange })
                vim.api.nvim_set_hl(0, 'TelescopePreviewTitle', { bg = color.very_dark_grey, fg = color.burnt_orange })
                vim.api.nvim_set_hl(0, 'TelescopeResultsTitle', { bg = color.very_dark_grey, fg = color.burnt_orange })
            end

            -- Apply color override when changing color scheme into darcula.
            vim.api.nvim_create_autocmd('ColorScheme', {
                pattern = '*',
                callback = function()
                    if vim.g.colors_name == 'darcula-dark' then
                        apply_darcula_override()
                    end
                end,
            })
            apply_darcula_override()
        end,
    },
}
