local _, fidget = pcall(require, 'fidget')
local notify = fidget.notify or vim.notify

vim.notify = fidget.notify

return {
    notify = notify,
    -- This version of notify is required for some handlers that do not allow Neovim to run notify inside "fast" handler scopes.
    fast_notify = function(arg)
        vim.schedule(function()
            notify(arg)
        end)
    end,
}
