local get_hl = function(name)
    return vim.api.nvim_get_hl(0, { name = name })
end

local set_hl = function(name, color)
    vim.api.nvim_set_hl(0, name, color)
end

local transparent = { ctermbg = 'none', bg = 'none' }
local colors = {
    'Normal',
    'NormalNC',
    'SignColumn',
    'VertSplit',
}

local M = {}
M.is_transparent = false
M.memory = {}

local remember = function()
    for i = 1, #colors do
        local color = colors[i]
        local value = get_hl(color)
        M.memory[color] = value
    end
end

local revert = function()
    for key, color in pairs(M.memory) do
        set_hl(key, color)
    end
    M.is_transparent = false
end

local set_transparent = function()
    for key in pairs(M.memory) do
        set_hl(key, transparent)
    end
    M.is_transparent = true
end

vim.api.nvim_create_autocmd('ColorScheme', {
    pattern = '*',
    callback = remember,
})

M.toggle = function()
    if not next(M.memory) then
        remember()
    end

    if M.is_transparent then
        revert()
    else
        set_transparent()
    end
end

return M
