local M = {}

M.is_suppressed = false

M.suppress = function()
    M.is_suppressed = false
    vim.o.more = false
    vim.o.cmdheight = 0
end

M.alleviate = function()
    M.is_suppressed = true
    vim.o.more = true
    vim.o.cmdheight = 1
end

M.toggle = function()
    if M.is_suppressed then
        M.alleviate()
    else
        M.suppress()
    end
end

M.set = function(state)
    if state ~= M.is_suppressed then
        M.toggle()
    end
end

vim.keymap.set('n', '<leader>q', M.suppress)

return M
