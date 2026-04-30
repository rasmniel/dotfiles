--
-- GITSIGNS
--

return {
    'lewis6991/gitsigns.nvim',
    opts = {
        on_attach = function(bufnr)
            -- NOTE: This is largely based on the default gitsigns config.

            local gitsigns = require('gitsigns')
            local function map(mode, lhs, rhs, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, lhs, rhs, opts)
            end

            -- Navigation
            map('n', ']c', function()
                if vim.wo.diff then
                    vim.cmd.normal({ ']c', bang = true })
                else
                    gitsigns.nav_hunk('next')
                end
            end, { desc = 'Navigate to next git change' })

            map('n', '[c', function()
                if vim.wo.diff then
                    vim.cmd.normal({ '[c', bang = true })
                else
                    gitsigns.nav_hunk('prev')
                end
            end, { desc = 'Navigate to previous git change' })

            -- Actions
            map('v', '<leader>gs', function()
                gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
            end, { desc = 'git [s]tage hunk' })

            map('v', '<leader>gr', function()
                gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
            end, { desc = 'git [r]eset hunk' })

            map('n', '<leader>gs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
            map('n', '<leader>gr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })

            map('n', '<leader>gS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
            map('n', '<leader>gR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
            map('n', '<leader>gp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
            map('n', '<leader>gi', gitsigns.preview_hunk_inline, { desc = 'git preview hunk [i]nline' })

            map('n', '<leader>gb', function()
                gitsigns.blame_line({ full = true })
            end, { desc = 'git [b]lame line' })

            map('n', '<leader>gd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
            map('n', '<leader>gD', function()
                gitsigns.diffthis('~')
            end, { desc = 'git [D]iff against last commit' })

            map('n', '<leader>gq', gitsigns.setqflist, { desc = 'Set [q]uickfix list for current buffer' })
            map('n', '<leader>gQ', function()
                gitsigns.setqflist('all')
            end, { desc = 'Set [Q]uickfix list for all for all files' })

            -- Toggles
            map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git [b]lame line' })
            -- map('n', '<leader>tw', gitsigns.toggle_word_diff, { desc = '[T]oggle git [w]ord diff' })

            -- Text object
            map({ 'o', 'x' }, 'ih', gitsigns.select_hunk, { desc = 'Select hunks as text objects' })

            -- Change new-signs to stand out from changed-signs.
            vim.cmd('hi GitSignsAdd guifg=#408040')
        end,
    },
}
