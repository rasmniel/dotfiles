local default_marker = { '.gitignore', '.git' }

local get_buf_root_by_marker = function(bufnr, marker)
    local buf_path = vim.api.nvim_buf_get_name(bufnr)
    marker = marker or default_marker
    -- TODO: Implement with vim.fs.root instead of .find, which is more explicit.
    local root_markers = vim.fs.find(marker, { path = buf_path, upward = true })
    local root = vim.fs.root(0, marker)
    if root_markers then
        return vim.fs.dirname(root_markers[1])
    end
    return nil
end

local get_current_buf_root_by_marker = function(marker)
    local bufnr = vim.api.nvim_get_current_buf()
    return get_buf_root_by_marker(bufnr, marker)
end

return {
    get_buf_root_by_marker = get_buf_root_by_marker,
    get_current_buf_root_by_marker = get_current_buf_root_by_marker,
}
