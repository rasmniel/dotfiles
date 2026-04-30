--
-- COMMANDScomand
--

-- Add command to quickly check for actual indent settings in current buffer.
vim.api.nvim_create_user_command(
    'ShowIndents',
    'verbose set tabstop? softtabstop? shiftwidth?',
    { desc = 'Show the current tabstop, softtabstop, and shiftwidth.' }
)

-- Allow writing file with :W as a common typo and prevent saving single-letter files due to fat fingers.
vim.api.nvim_create_user_command('W', 'w', {
    nargs = '?',
    complete = 'file',
    desc = 'Write buffer typo correction.',
})

vim.api.nvim_create_user_command('Q', 'q', {
    nargs = '?',
    desc = 'Quit Neovim typo correction.',
})

--
-- AUTOCOMMANDS
--
-- :help
--  lua-guide-autocommands
--  autocmd-events

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking',
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})

-- Move the help window the the right as a vertical split.
vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'help', 'man' },
    command = 'wincmd L',
})

-- Wrap lines in quickfix window.
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'qf',
    command = 'setlocal wrap',
})
