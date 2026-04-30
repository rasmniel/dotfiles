local notify = require('extras.notify').fast_notify

local M = {}

M.create_arg = function(arg, value)
    return '--' .. arg .. '=' .. value
end

-- The value of `--languages` argument takes a case-insensitive, comma-separated list
--  from the `ctags --list-languages` command.
M.languages_arg = function(value)
    return M.create_arg('languages', value)
end

-- The value of `--exclude` should be a glob matching files that should be tagged.
-- Typically used like `--exclude=*.json` or some similar fashion.
M.exclude_arg = function(value)
    return M.create_arg('exclude', value)
end

-- Shorthand exclude arg for files with the given extension.
M.exclude_ext_arg = function(ext)
    return M.exclude_arg('*.' .. ext)
end

-- TODO: Implement `kinds` configuration, which can be listed with `ctags --list-kinds=<language>`

M.regenerate = function(args)
    local command = vim.list_extend({ 'ctags', '-R' }, args or {})
    vim.system(command, { text = true }, function(out)
        if out.code == 0 then
            notify('Project tagged successfully!')
        else
            notify('Tagging went wrong: ' .. out.stderr)
        end
    end)
end

M.regenerate_data = function()
    M.regenerate({
        M.languages_arg('json,csv'),
    })
end

M.regenerate_docs = function()
    M.regenerate({
        M.languages_arg('markdown'),
    })
end

-- TODO Testing with this keymap - it should not live here.
vim.keymap.set('n', '<leader>xx', M.regenerate)
vim.keymap.set('n', '<leader>xd', M.regenerate_data)
vim.keymap.set('n', '<leader>xc', M.regenerate_docs)

-- TODO: Consider persistent regeneration by creating a .ctags file at the project root with the last-run arguments,
-- to the end that `ctags -R` actually REgenerates rather than generate anew.
return M
