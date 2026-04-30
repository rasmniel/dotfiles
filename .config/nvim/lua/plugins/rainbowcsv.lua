-- Explicitly move RainbowCSV cache to the default Neovim cache.
local rainbow_cache = vim.fn.stdpath('cache') .. '/rainbow_csv'
vim.fn.mkdir(rainbow_cache, 'p')

-- Highlight CSV columns for increased readability.
return {
    'mechatroner/rainbow_csv',
    init = function()
        -- Move the cached files used by RainbowCSV to make it easier to handle corruption.
        vim.g.rb_storage_dir = rainbow_cache
        vim.g.rainbow_table_index = rainbow_cache .. '/rainbow_table_index'
        vim.g.table_names_settings = rainbow_cache .. '/table_names_settings'
    end,
    config = function()
        vim.api.nvim_create_autocmd('BufEnter', {
            -- Reuse existing RainbowCSV autocommand group.
            group = vim.api.nvim_create_augroup('RainbowInitAuGrp', { clear = false }),
            callback = function()
                -- RainbowCSV declares a check to determined if the current context is relevant.
                if vim.fn['rainbow_csv#is_rainbow_table_or_was_just_disabled']() ~= 1 then
                    return
                end

                local clear_rainbow_cache = function()
                    vim.fs.rm(rainbow_cache, { force = true, recursive = true })
                end

                vim.api.nvim_create_user_command('RainbowCacheClear', clear_rainbow_cache, {
                    desc = 'Clear the RainbowCSV cache. This is useful when the cache becomes corrupted.',
                })
            end,
        })
    end,
}
