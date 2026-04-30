-- TODO: Consider multiline visual mode support.
return function()
    local from, to = (function()
        local line = vim.api.nvim_get_current_line()
        local double = string.find(line, '"') or 99999
        local single = string.find(line, "'") or 99999
        if single == double then
            return
        end
        local has_double = double < single
        if has_double then
            return '"', "'"
        else
            return "'", '"'
        end
    end)()
    local substitution = string.format([[s/%s/%s/g]], from, to)
    vim.cmd(substitution)
    vim.cmd('nohls')
end
