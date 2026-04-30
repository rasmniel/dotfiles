--
-- OPTIONS
--
-- :help
--  vim.opt
--  option-list

-- See `:help mapleader`
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Indicate whether a nerd font is installed in the terminal.
vim.g.use_nerd_font = true
-- Disable external language providers as they are unused and make noise in :checkhealth
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0

-- Set the shell opened with ! to be interactive and use commands.
-- vim.opt.shellcmdflag = '-ic'

-- The netrw file tree has several shortcuts, many of which can be found in this handy gist:
--  https://gist.github.com/danidiaz/37a69305e2ed3319bfff9631175c5d0f
-- See `:help netrw-browser-settings`
-- Set the default list style as a folding file tree.
vim.g.netrw_liststyle = 3

-- Configure line numbers.
vim.opt.number = true
-- Enable relative line numbers.
vim.opt.relativenumber = true
-- Toggled relative line numbers.
vim.keymap.set('n', '<leader>tn', function()
    ---@diagnostic disable-next-line: undefined-field
    vim.opt.relativenumber = not vim.opt.relativenumber:get()
end, { desc = 'Toggle relative line numbers' })

-- Disable mouse and toggle normal and visual mode.
vim.opt.mouse = ''
-- Enable toggling mouse.
vim.keymap.set('n', '<leader>tm', function()
    ---@diagnostic disable-next-line: undefined-field
    vim.opt.mouse = vim.opt.mouse:get().n and '' or 'nv'
end, { desc = 'Toggle mouse input' })

-- Set English language, but disable spell checking by default.
vim.opt.spelllang = 'en'
vim.opt.spell = false
vim.opt.spelloptions = 'camel'
-- Toggle spell check.
vim.keymap.set('n', '<leader>ts', function()
    ---@diagnostic disable-next-line: undefined-field
    vim.opt.spell = not vim.opt.spell:get()
end, { desc = 'Spell check' })

-- Disable soft wrapping of long lines.
vim.opt.wrap = false
-- Enable true colors.
vim.opt.termguicolors = true
-- Don't show the mode, since it's already in the status line.
vim.opt.showmode = false

-- Set 4 indents using spaces and enable auto-indent.
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.smarttab = true

-- Enable break indent.
vim.opt.breakindent = true

-- Save undo history.
vim.opt.undofile = true

-- Case-insensitive searching unless the search term contains \C or one or more capital letters.
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- C-o and C-i behaviour.
vim.opt.jumpoptions = 'clean'

-- Keep signcolumn on by default.
vim.opt.signcolumn = 'yes'

-- Set update time for event hooks.
vim.opt.updatetime = 200

-- Set timeout for keymap sequences.
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview search and substitutions while typing.
vim.opt.inccommand = 'split'
vim.opt.incsearch = true

-- Allow selecting empty blocks in visual block mode.
vim.opt.virtualedit = 'block'

-- Highlight the line the cursor is on.
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Let the editor confirm when closing unsaved changes instead of aborting.
vim.opt.confirm = false
