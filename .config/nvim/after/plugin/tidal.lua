local tidal = require('tidal')
local message = require('tidal.core.message')

-- Add .tidal file type in order to detect filetype for localleader mapping.
vim.filetype.add({
    extension = {
        tidal = 'tidal',
    },
})

-- Setup keymaps for .tidal files manually because original ones are not very good and not very flexible.
local set_keymap = function(mode, lhs, rhs, opts)
    opts = vim.tbl_extend('force', { buffer = true }, opts or {})
    vim.keymap.set(mode, lhs, rhs, opts)
end

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'tidal',
    callback = function()
        vim.opt_local.commentstring = '-- %s'
        -- Disable c-like smartindent, because it forces leading `#` to column 0, which is undesired in tidal.
        vim.opt_local.smartindent = false
    end,
})

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
    pattern = '*.tidal',
    callback = function()
        -- Override haskell filetype set by tidal.nvim with tidal filetype and manually apply haskell treesitter to the buffer.
        -- This is because hls allegedly does not do well with tidal syntax and constantly throws highlighting errors for tidal.
        --  (I am not configuring lsp highlighting to account for outliers like this!)
        -- The haskell client is configured to stop when attaching to a tidal file.
        vim.api.nvim_set_option_value('filetype', 'tidal', { buf = 0 })
        vim.treesitter.start(nil, 'haskell')

        -- Shortcuts to launch and quit tidal.
        set_keymap('n', '<localleader>t', ':TidalLaunch<CR>', { desc = 'Launch Tidal' })
        set_keymap('n', '<localleader>q', ':TidalQuit<CR>', { desc = 'Quit Tidal' })

        -- Send block, line, and visual selection to tidal. NOTE: send_node is not bound.
        set_keymap({ 'n' }, '<CR>', tidal.api.send_block, { desc = 'Send block' })
        set_keymap({ 'n' }, '<localleader><CR>', tidal.api.send_line, { desc = 'Send line' })
        -- NOTE: Visual selection command is copied from tidal.nvim source code, because it is not exported.
        set_keymap({ 'x' }, '<CR>', [[<Esc><Cmd>lua require("tidal").api.send_visual()<CR>gv]], { desc = 'Send visual selection' })

        -- Bind 1-9 (single-digit) to silence respective channels.
        for i = 1, 9, 1 do
            set_keymap({ 'n', 'v' }, '<localleader>' .. i, function()
                message.tidal.send_line(string.format('d%d silence', i))
            end, { desc = 'Silence d' .. i })
        end

        -- Hush.
        set_keymap({ 'n', 'v' }, '<localleader><localleader>', function()
            message.tidal.send_line('hush')
        end, { desc = 'Hush' })
    end,
})
