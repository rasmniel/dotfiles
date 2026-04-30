# Neovim configuration

## Symlink
It is sufficient to link this directory as the nvim config directory instead of having to move the files around.
On Linux, link the directory with the init.lua in it like so: `ln -s ~/path/to/dir ~/.config/nvim`


# TODO
- Several nvim 12 deprecations
- Consider `nvim --startuptime perf.log` script that can quickly test and show startup performance of Neovim.
    - In the future this may become a problem and it would be nice to know about performance before it does.
    - This config contains relevant lazy.nvim configuration to improve startup performance: https://github.com/MSmaili/nvim/blob/708b9ec3d6f7abcdba4b0f0218b0c5bb43cfad9b/init.lua
- Note to self = :g and :v are incredible and can be mixed with norm, eg. :g/bug/norm A -- FIXME
- Arrange keymap keys prefixed by leader into sections
- Which key
    - Consider which-key rules
    - Improve which-key names
    - Consider removing all [] from descriptions, because they fudge the neat which-key semantic icon logic.
- Consider toggleable auto-save.
    - NOTE: This feature is supported natively by neovim.
    - debounced :w on all changes?
    - May set background as transparent when auto save is live.
        - This helps understand that auto save is on, but can also be used to have live updates in the background while coding.
- Buffer control:
    - https://stackoverflow.com/questions/4545275/vim-close-all-buffers-but-this-one
- Research tags and marks for quick navigation in file and globally on machine.
- https://github.com/LazyVim/LazyVim/tree/main/lua/lazyvim/config
- Better and streamlined help/reference section in config files.
- Consider how to use tabs effectively.
    - <leader><tab> is an option, as a close alternative to alt+tab
- Consider new Lsp setup: https://github.com/Rishabh672003/Neovim/blob/main/lua%2Frj%2Flsp.lua
- Telescope file/directory name: 
    - https://github.com/nvim-telescope/telescope.nvim/issues/2014
    - https://www.reddit.com/r/neovim/comments/14ah5k2/telescope_file_name_and_path_display/

## Plugins
- Minintro: https://github.com/eoh-bse/minintro.nvim - or do it better! or https://github.com/rockerBOO/awesome-neovim?tab=readme-ov-file#startup
    - Add useful links:
        - https://github.com/rockerBOO/awesome-neovim
        - https://dotfyle.com/
- Undo and undo tree: https://learnvim.irian.to/basics/undo
- Black metal themes: https://github.com/metalelf0/black-metal-theme-neovim
- Treesitter
    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    - text-objects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    - treewalker: https://github.com/aaronik/treewalker.nvim
    - context: https://github.com/nvim-treesitter/nvim-treesitter-context

## JS/TS
- Consider how to use a fallback jsconfig or tsconfig if necessary, in case project doesn't have one (it probably won't)
- Consider module: CommonJS to solve missing require statements issue.
- Consider typescript-tools
