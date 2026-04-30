return {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = 'master',
    dependencies = {
        { 'nvim-lua/plenary.nvim' },

        {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make',
            cond = function()
                return vim.fn.executable('make') == 1
            end,
        },

        { 'nvim-telescope/telescope-ui-select.nvim' },

        { 'nvim-telescope/telescope-file-browser.nvim' },

        { 'nvim-tree/nvim-web-devicons', enabled = vim.g.use_nerd_font },
    },
    config = function()
        local telescope = require('telescope')
        local themes = require('telescope.themes')
        local builtin = require('telescope.builtin')

        telescope.setup({
            defaults = {
                path_display = { 'smart' },
            },
            extensions = {
                ['ui-select'] = {
                    themes.get_dropdown(),
                },
                file_browser = {
                    layout_config = {
                        height = 30,
                    },
                    theme = 'ivy',
                    initial_mode = 'normal',
                    mappings = {
                        ['i'] = {},
                        ['n'] = {
                            m = require('extras.telescope_move_selection'),
                        },
                    },
                },
            },
        })

        -- Load extensions.
        local load_extension = function(name)
            pcall(telescope.load_extension, name)
        end
        -- If `make` is not installed, loading fzf will fail.
        load_extension('fzf')
        load_extension('ui-select')
        load_extension('file_browser')
        load_extension('fidget')

        -- Map telescope functions in normal mode prefixed by leader.
        -- TODO: Implement
        local map_telescope = function(rhs_keys, lhs, desc)
            vim.keymap.set('n', '<leader>' .. rhs_keys, lhs, { desc = desc })
        end

        -- Map telescope builtin features.
        vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = 'Telescope builtins' })
        vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = 'Help' })
        vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = 'Keymaps' })
        vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = 'Files' })
        vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = 'Grep' })
        vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = 'Diagnostics' })
        vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = 'Current word' })
        vim.keymap.set('n', '<leader>st', builtin.tags, { desc = 'Tags' })
        vim.keymap.set('n', '<leader>sc', builtin.colorscheme, { desc = 'Colorschemes' })
        vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = 'Resume search' })
        vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = 'Recent Files' })
        vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = 'Find existing buffer' })

        -- Open the Telescope file browser at the location of the current file.
        vim.keymap.set('n', '<leader>b', '<cmd>Telescope file_browser path=%:p:h select_buffer=true<CR>', { desc = 'Open file browser' })

        vim.keymap.set('n', '<leader>sa', function()
            builtin.find_files({
                hidden = true,
                no_ignore = true,
                follow = true,
                prompt_title = 'Find in all files',
            })
        end, { desc = 'All files' })

        vim.keymap.set('n', '<leader>sp', function()
            -- TODO: More exhaustive package root list.
            local cwd = require('extras.buf_root').get_current_buf_root_by_marker('package.json')
            builtin.find_files({
                cwd = cwd,
                prompt_title = 'Find in project',
            })
        end, { desc = 'Project' })

        vim.keymap.set('n', '<leader>sb', function()
            local current_buf_dir = require('telescope.utils').buffer_dir()
            builtin.live_grep({
                cwd = current_buf_dir,
                prompt_title = 'Grep in ' .. current_buf_dir,
            })
        end, { desc = 'Grep in buffer dir' })

        vim.keymap.set('n', '<leader>/', function()
            builtin.current_buffer_fuzzy_find(themes.get_dropdown({
                -- winblend = 10,
                previewer = false,
            }))
        end, { desc = 'Fuzzy search current buffer' })

        vim.keymap.set('n', '<leader>s/', function()
            builtin.live_grep({
                grep_open_files = true,
                prompt_title = 'Grep in open files',
            })
        end, { desc = 'Grep in open files' })

        vim.keymap.set('n', '<leader>sn', function()
            builtin.find_files({
                cwd = vim.fn.stdpath('config'),
                prompt_title = 'Find in Neovim configuration files',
            })
        end, { desc = 'Neovim configuration' })
    end,
}
