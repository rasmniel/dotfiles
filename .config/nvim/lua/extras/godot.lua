-- TODO: Consider if godot should be included with other lsp and probably also declare common capabilities?
return {
    -- Connect to the gdscript language server started by the Godot editor, because Godot doesn't offer a standalone lsp.
    -- This means that the Godot editor must be running with external language support enabled for the lsp to be active outside the editor.
    setup = function()
        vim.lsp.config('gdscript', {
            -- NOTE: Assuming godot language server is running on the default port.
            cmd = vim.lsp.rpc.connect('127.0.0.1', 6005),
            filetypes = { 'gdscript' },
            root_markers = { 'project.godot', '.git' },
            --- @diagnostic disable-next-line: unused-local
            on_attach = function(client, bufnr)
                -- Use this hook to debug issues with connecting to the lsp.
            end,
        })
        vim.lsp.enable('gdscript')
    end,
}
