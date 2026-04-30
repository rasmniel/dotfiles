--
-- TIDAL
--

-- TidalCycles boot files should be available in the Neovim bootfiles directory.
-- If the boot files do not exist, allow tidal.nvim to fallback to defaults.
local bootfiles = vim.fn.stdpath('data') .. '/bootfiles/tidal/'
-- Assess the TidalBoot.hs file.
local boot_tidal_path = vim.fn.expand(bootfiles .. 'BootTidal.hs')
local boot_tidal_exists = vim.fn.filereadable(boot_tidal_path)
-- Assess the startup.scd file.
local startup_scd_path = vim.fn.expand(bootfiles .. 'startup.scd')
local startup_scd_exists = vim.fn.filereadable(startup_scd_path)

return {
    'grddavies/tidal.nvim',
    opts = {
        -- Configure the :TidalLaunch command.
        boot = {
            split = 'v',
            tidal = {
                cmd = 'ghci',
                args = { '-v0', '-i' .. bootfiles },
                file = boot_tidal_exists and boot_tidal_path or nil,
                enabled = true,
            },
            sclang = {
                cmd = 'sclang',
                file = startup_scd_exists and startup_scd_path or nil,
                enabled = false,
            },
        },
        selection_highlight = {
            -- NOTE: Must supply empty link to avoid the plugin merging the default IncSearch link.
            highlight = { fg = '#e236ce', link = '' },
            timeout = 150,
        },
        -- Disable default keymaps, because they do not support localleader.
        mappings = false,
    },
}
