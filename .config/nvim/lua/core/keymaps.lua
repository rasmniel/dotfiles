--
-- KEYMAPS
--
-- :help
--  vim.keymap.set()
--  key-notation

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier to remember.
-- NOTE: This may not work in all terminal emulators.
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Close the current buffer and go to the previous buffer in reverse order.
-- This closes the current file buffer without closing the split it was in.
-- See :help alternate-file
-- vim.keymap.set('n', '<C-q>', '<cmd>bp|bd#<CR>', { desc = 'Close the current buffer without closing the split' })

-- Go to the previous buffer and then close the buffer that has now become the previous.
-- This is essentially the command `bp|bd#` but complicated by terminal behavior.
vim.keymap.set('n', '<C-q>', function()
    -- `bd` won't close terminal buffers, because their context could be live outside what Neovim can detect.
    -- Force close terminal buffers to ensure they do not persist due to this safety-measure.
    local bd_args = { args = { '#' }, bang = vim.bo.buftype == 'terminal' }
    -- Go to the previous buffer only after reading the type of the current buffer.
    vim.cmd.bp()
    local ok, err = pcall(vim.cmd.bd, bd_args)
    if not ok then
        -- Use the original error message provided by the error without the 'Vim:' prefix
        vim.notify(err:gsub('^Vim:', ''), vim.log.levels.ERROR)
    end
end, { desc = 'Close the current buffer without closing the split' })

-- Remove shortcut for system file-browser integration, because it is not desired.
--  (also, it has a long, unnecessary description, which skews the which-key table)
-- TODO: Reconsider gx and if it is possible to change description without changing the keymap
vim.keymap.del('n', 'gx')
-- Effectively disable page up and page down.
-- These keys are often placed in inconvenient spots on the keyboard where they might be fat-fingered.
vim.keymap.set({ 'n', 'i', 'v' }, '<PageUp>', '<Nop>')
vim.keymap.set({ 'n', 'i', 'v' }, '<PageDown>', '<Nop>')

-- Set backspace to delete the entire previous word like most typical text editors.
vim.keymap.set('i', '<C-BS>', '<C-W>', { desc = 'Conventional ctrl+backspace to delete the entire previos word' })
-- The <C-H> is the output of ctrl+backspace, which is the only input some editors will respond to for that command.
vim.keymap.set('i', '<C-H>', '<C-W>', { desc = 'Some terminals will only respond to the <C-H> input as ctrl+backspace' })
vim.keymap.set('i', '<C-Delete>', '<Esc>ldei', { desc = 'Mimic inverse ctrl+backspace with ctrl+delete' })
-- Skip to the start and end of the current line in insert mode.
vim.keymap.set('i', '<A-left>', '<C-o>_', { desc = 'Skip to the start of the line in insert mode' })
vim.keymap.set('i', '<A-right>', '<C-o>$', { desc = 'Skip to the end of the line in insert mode' })
-- Dedent with shift-tab in insert mode.
vim.keymap.set('i', '<S-Tab>', '<C-o><<', { desc = 'Dedent in insert mode' })
vim.keymap.set('v', '>', '>gv', { desc = 'Repeat last selection after indenting' })
vim.keymap.set('v', '<', '<gv', { desc = 'Repeat last selection after dedenting' })

-- Select in the given direction, changing from insert to visual mode.
vim.keymap.set({ 'i', 'n' }, '<S-left>', '<Esc>v<left>', { desc = 'Leave insert mode and select left' })
vim.keymap.set({ 'i', 'n' }, '<S-right>', '<Esc>v<right>', { desc = 'Leave insert mode and select right' })

-- Move lines up or down in normal and visual mode.
vim.keymap.set('n', '<A-j>', '<cmd>m .+1<CR>==', { silent = true })
vim.keymap.set('n', '<A-k>', '<cmd>m .-2<CR>==', { silent = true })
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", { silent = true })
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", { silent = true })
-- Move a single line up or down in insert mode, entering normal mode.
vim.keymap.set('i', '<A-j>', '<Esc>ddp')
vim.keymap.set('i', '<A-k>', '<Esc>ddkP')

-- Improve `ci`-bracket to go to the nearest bracket on the current line before changing.
-- This avoids falling back to surrounding bracket, which is usually undesired.
-- TODO: Consider implementing this for y and v as well.
--  Maybe even add around support.
vim.keymap.set('n', 'ci{', 'f{ci{')
vim.keymap.set('n', 'ci[', 'f[ci[')
vim.keymap.set('n', 'ci(', 'f(ci(')

-- Additional motion-like shortcuts and enhancement.
vim.keymap.set('n', 'ycc', '<cmd>norm yygccp<CR>', { desc = 'Duplicate a line and comment the original' })

-- Remove enclosing curly brackets on the same line.
vim.keymap.set('n', '<leader>cb', '<cmd>norm 0f{xf}x<CR>', { desc = 'Remote single-line enclosing curly brackets' })
-- Toggle quotes on the given line.
vim.keymap.set('n', '<leader>cq', require('extras.quotes'), { desc = 'Toggle between single and double quotes on the current line' })
-- Toggle transparent background, taking the color scheme into account.
vim.keymap.set('n', '<leader>tt', require('extras.transparency').toggle, { desc = 'Toggle transparent background' })
vim.keymap.set('n', '<leader>tw', '<cmd>setlocal wrap!<CR>', { desc = 'Toggle line wraps' })

vim.keymap.set('n', '<leader>qq', require('extras.suppress').toggle, { desc = 'Suppress all errors and messages' })

-- Write shortcut to avoid typos.
vim.keymap.set('n', '<leader>w', '<cmd>write<CR>', { desc = 'Write current buffer' })

-- Increase and reduce split width by multiple factors.
vim.keymap.set('n', '<C-right>', '20<C-w>>', { desc = 'Increase width by multiple factors' })
vim.keymap.set('n', '<C-left>', '20<C-w><', { desc = 'Reduce width by multiple factors' })
-- Increase and reduce split height by multiple factors.
vim.keymap.set('n', '<C-up>', '10<C-w>+', { desc = 'Increase height by multiple factors' })
vim.keymap.set('n', '<C-down>', '10<C-w>-', { desc = 'Reduce height by multiple factors' })

-- Use ctrl-hjkl to navigate between words in normal mode instead of arrow keys.
vim.keymap.set('n', '<C-h>', '<C-left>', { desc = 'Navigate words backward with ctrl-h' })
vim.keymap.set('n', '<C-j>', '<C-down>', { desc = 'Navigate down with ctrl-j' })
vim.keymap.set('n', '<C-k>', '<C-up>', { desc = 'Navigate up with ctrl-k' })
vim.keymap.set('n', '<C-l>', '<C-right>', { desc = 'Navigate words forward with ctrl-h' })

-- Mimic classic ctrl-a to select all with alt-a.
vim.keymap.set('n', '<A-a>', 'ggVG', { desc = 'Select the entire document text' })

-- Remap x command to black hole register.
vim.keymap.set({ 'n', 'v' }, 'x', '"_x', { desc = 'Change the register of the `x` command to the black hole register' })
-- Remap y command to use system clipboard.
vim.keymap.set({ 'n', 'v' }, 'y', '"+y', { desc = 'Change the register of the `y` command to the system clipboard' })
-- Use Ctrl+p to paste directly from system clipboard.
vim.keymap.set({ 'n', 'v' }, '<C-p>', '"+p', { desc = 'Paste directly from system clipboard' })
vim.keymap.set('i', '<C-p>', '<Esc>"+p', { desc = 'Paste directly from system clipboard in insert mode' })
-- Modify the `p` command in visual mode to re-yank previous selection after paste to avoid overriding the register.
vim.keymap.set('v', 'p', 'pgvy', { desc = 'Disable automatic yanking with the `p` command' })

-- Add undo breakpoints.
vim.keymap.set('i', ',', ',<C-g>u', { desc = 'Add undo breakpoint for comma' })
vim.keymap.set('i', '.', '.<C-g>u', { desc = 'Add undo breakpoint for period' })
vim.keymap.set('i', ';', ';<C-g>u', { desc = 'Add undo breakpoint for semicolon' })
vim.keymap.set('i', ' ', ' <C-g>u', { desc = 'Add undo breakpoint for space bar' })

-- Enable C-z as undo in insert mode.
vim.keymap.set('i', '<C-z>', '<C-o>u', { desc = 'Enable C-z as undo in insert mode' })

-- Enable inc/dec in insert mode.
vim.keymap.set('i', '<C-a>', '<C-o><C-a>', { desc = 'Enable increment in insert mode' })
vim.keymap.set('i', '<C-x>', '<C-o><C-x>', { desc = 'Enable decrement in insert mode' })

-- Clear search highlights when pressing <Esc> in normal mode.
vim.keymap.set('n', '<Esc>', '<cmd>nohls<CR>')

-- Shortcuts to open UI.
vim.keymap.set('n', '<leader>ol', '<cmd>Lazy<CR>', { desc = 'Open [L]azy UI' })
vim.keymap.set('n', '<leader>om', '<cmd>Mason<CR>', { desc = 'Open [M]ason UI' })
vim.keymap.set('n', '<leader>oe', '<cmd>Ex<CR>', { desc = 'Open the netrw [e]xplorer' })
vim.keymap.set('n', '<leader>ot', '<cmd>terminal<CR>', { desc = 'Open the [t]erminal' })

-- Center the cursor in the screen then navigating up or down.
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Center cursor in screen when navigating up' })
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Center cursor in screen when navigating down' })
vim.keymap.set('n', 'n', 'nzz', { desc = 'Center cursor in screen when searching down' })
vim.keymap.set('n', 'N', 'Nzz', { desc = 'Center cursor in screen when searching down' })

-- Warn about Danish keyboard layout, which doesn't harmonize well with Vim motions.
local da_warning = '<cmd>echo "@ NOTICE: Danish keyboard layout detected!"<CR>'
vim.keymap.set('n', '-', da_warning)
vim.keymap.set('n', 'Æ', da_warning)
vim.keymap.set('n', 'æ', da_warning)
vim.keymap.set('n', 'Ø', da_warning)
vim.keymap.set('n', 'ø', da_warning)
vim.keymap.set('n', 'Å', da_warning)
vim.keymap.set('n', 'å', da_warning)
vim.keymap.set('n', '½', da_warning)
vim.keymap.set('n', '§', da_warning)
