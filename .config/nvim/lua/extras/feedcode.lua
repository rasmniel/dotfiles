local DEFAULT_MODE = 'n'

local feedcode = function(code, mode)
    mode = mode or DEFAULT_MODE
    local keys = vim.api.nvim_replace_termcodes(code, true, false, true)
    vim.api.nvim_feedkeys(keys, mode, true)
end

local feedcode_mode = function(mode)
    return function(code)
        feedcode(code, mode)
    end
end

return {
    -- Feed code with custom mode.
    feed = feedcode,
    -- Non-recursive mapping.
    nmap = feedcode_mode('n'),
    -- Recursive mapping.
    remap = feedcode_mode('m'),
    -- Non-recursive typed codes.
    type = feedcode_mode('t'),
    -- Dynamic expression.
    expr = feedcode_mode('x'),
    -- Command-line expression.
    cmd = feedcode_mode('!'),
    -- Insert mode commands.
    ins = feedcode_mode('i'),
}
