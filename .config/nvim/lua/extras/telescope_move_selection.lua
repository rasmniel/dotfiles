local action_state = require('telescope.actions.state')
local fb_utils = require('telescope._extensions.file_browser.utils')
local fb_actions = require('telescope._extensions.file_browser.actions')

local scan = require('plenary.scandir')

local function rename_file(client, old_path, new_path)
    local params = {
        files = {
            {
                oldUri = vim.uri_from_fname(old_path),
                newUri = vim.uri_from_fname(new_path),
            },
        },
    }

    -- Ensure destination directory exists.
    vim.fn.mkdir(vim.fs.dirname(new_path), 'p')

    -- Acquire and apply workspace edits for renaming the file before the rename occurs.
    -- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#workspace_willRenameFiles
    local response, response_error = client:request_sync('workspace/willRenameFiles', params, 2000)
    if response_error then
        local sf = 'LSP: workspace/willRenameFiles failed: %s'
        vim.notify(sf:format(response_error), vim.log.levels.ERROR)
        return
    end

    if response and response.result then
        vim.lsp.util.apply_workspace_edit(response.result, client.offset_encoding)
    end

    -- Actually perform the file rename.
    local ok, rename_error = vim.uv.fs_rename(old_path, new_path)
    if not ok then
        local sf = 'File rename failed: %s'
        vim.notify(sf:format(rename_error), vim.log.levels.ERROR)
        return
    end

    -- Update the current buffer if it was attached to the old file.
    -- TODO: Updating current buffer doesn't seem to work...
    local buf = vim.fn.bufnr(old_path)
    if buf ~= -1 then
        -- TODO: Consider fb_utils.rename_buf or fb_utils.rename_dir_buf instead.
        pcall(vim.api.nvim_buf_set_name, buf, new_path)
    end

    -- Notify the LSP know that renaming completed successfully.
    -- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#workspace_didRenameFiles
    if client:supports_method('workspace/didRenameFiles') then
        client:notify('workspace/didRenameFiles', params)
    end
end

local function flatten_selection(paths, target_path)
    local files = {}
    local add_file = function(old_path, new_path)
        old_path = vim.fs.normalize(old_path)
        new_path = vim.fs.normalize(new_path)
        if old_path ~= new_path then
            table.insert(files, { old = old_path, new = new_path })
        end
    end

    for _, path in ipairs(paths) do
        local abs_path = path:absolute()
        if path:is_dir() then
            local dir_name = vim.fs.basename(path.filename)
            local target_dir = vim.fs.joinpath(target_path, dir_name)
            -- Recursively scan directory.
            for _, file in ipairs(scan.scan_dir(abs_path, { hidden = true, add_dirs = true })) do
                local new_path = file:gsub(vim.pesc(abs_path), target_dir)
                add_file(file, new_path)
            end
        else
            local new_path = vim.fs.joinpath(target_path, vim.fs.basename(abs_path))
            add_file(abs_path, new_path)
        end
    end

    -- -- Output flattened file selection for debugging.
    -- local file_string = [[File moves:
    -- ]]
    -- for _, value in ipairs(files) do
    --     file_string = file_string .. [[
    --     ]] .. value.old .. [[ ->
    --     ]] .. value.new .. [[
    --     ]]
    -- end
    -- print(file_string)

    return files
end

return function(prompt_bufnr)
    local picker = action_state.get_current_picker(prompt_bufnr)

    if not picker.finder or not picker.finder.path then
        -- NOTE: At this point, no valid picker can be found.
        return
    end

    -- NOTE: Currently, only ts_ls has been observed to provide poor multi-file refactoring, apparently due to non-standard `_typescript.applyRenameFile` command.
    -- https://github.com/typescript-language-server/typescript-language-server/blob/master/README.md#workspace-commands-workspaceexecutecommand
    -- TODO: Other LSPs may very well suffer from the same problems.
    -- https://github.com/neovim/neovim/issues/32363
    local client = vim.lsp.get_clients({ name = 'ts_ls' })[1]
    if not client then
        -- If no LSP client could be found, fall back to telescope file browser default move behavior.
        return fb_actions.move(prompt_bufnr)
    end

    ---@type Path[]
    local selection = fb_utils.get_selected_files(prompt_bufnr, false)
    local target_path = vim.fs.normalize(picker.finder.path)
    local files = flatten_selection(selection, target_path)

    if vim.tbl_isempty(files) then
        vim.notify('No movable files selected', vim.log.levels.WARN)
        return
    end

    for _, file in ipairs(files) do
        rename_file(client, file.old, file.new)
        -- Write all files after every rename to avoid stale references on further changes.
        vim.cmd([[wall!]])
    end

    picker:refresh(picker.finder, { reset_prompt = true })
end
