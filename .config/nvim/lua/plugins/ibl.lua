-- Show vertical lines aligned with indentation.
return {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {},
    config = function()
        local ibl = require('ibl')
        -- The ibl plugin does not expose its enabled state, so we keep it here.
        local enabled = false
        ibl.setup({ enabled = enabled })
        vim.keymap.set('n', '<leader>ti', function()
            enabled = not enabled
            ibl.update({ enabled = enabled })
        end, { desc = '[T]oggle [I]ndent blankline' })
    end,
}
