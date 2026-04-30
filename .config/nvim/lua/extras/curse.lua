local feedcode = require('extras.feedcode')
local cursed = true

-- Enable keymap to toggle the curse.
vim.keymap.set('n', '<leader>tc', function()
    cursed = not cursed
end, { desc = 'Toggle the arrow key curse' })

local curse_arrow_key = function(key)
    vim.keymap.set('n', key, function()
        if cursed then
            vim.notify('The arrow keys are cursed!')
        else
            feedcode.nmap(key)
        end
    end)
end

-- Normal mode arrow key navigation is cursed.
curse_arrow_key('<left>')
curse_arrow_key('<right>')
curse_arrow_key('<up>')
curse_arrow_key('<down>')
