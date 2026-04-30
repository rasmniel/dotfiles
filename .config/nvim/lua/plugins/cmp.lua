--
-- CMP
--

local match_client = function(entry, name)
    local client = entry.source and entry.source.source and entry.source.source.client
    return type(client) == 'table' and client.name == name or false
end

local deprioritize_client = function(name)
    return function(entry1, entry2)
        local entry1_match = match_client(entry1, name)
        local entry2_match = match_client(entry2, name)
        if entry1_match ~= entry2_match then
            return not entry1_match
        end
        return nil
    end
end

return {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
        -- Configure luasnip here.
        require('plugins.luasnip'),
        'saadparwaiz1/cmp_luasnip',
        -- Adds extra completion capabilities.
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-nvim-lsp-signature-help',
    },
    config = function()
        local luasnip = require('luasnip')
        local cmp = require('cmp')
        local feedcode = require('extras.feedcode')
        cmp.setup({
            -- Declare luasnip as snippet engine.
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },

            completion = {
                completeopt = 'menu,menuone,noinsert',
            },

            mapping = {
                -- Move between suggestion items.
                ['<C-k>'] = cmp.mapping.select_prev_item(),
                ['<C-j>'] = cmp.mapping.select_next_item(),

                -- Scroll the documentation window.
                ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                ['<C-d>'] = cmp.mapping.scroll_docs(4),

                -- Manually trigger a completion suggestions.
                ['<C-Space>'] = cmp.mapping.complete({ select = true }),

                -- Abort completion suggestions, closing the window.
                ['<C-a>'] = cmp.mapping.abort(),

                -- Perform completion in order: first for cmp suggestion and then for luasnip expansion.
                ['<Tab>'] = cmp.mapping(function(fallback)
                    -- Create an undo breakpoint before completion.
                    feedcode.nmap('<C-g>u')
                    if cmp.visible() then
                        if luasnip.expandable() then
                            -- TODO: Test that pcall avoids snippet expansion errors and uses default behavior instead of throwing an error.
                            -- Even if it works, does the updated logic work where cmp.visible is a condition for snippet expansion?
                            local err = pcall(luasnip.expand, {})
                            if err then
                                print(vim.inspect(err))
                                print('Temporary error output informing that snippet expansion failed silently. Did the input behave as expected?')
                            end
                        else
                            cmp.confirm({ select = true })
                        end
                    else
                        fallback()
                    end
                end, { 'i', 's' }),

                -- Jump ahead through a snippet.
                ['<C-l>'] = cmp.mapping(function(fallback)
                    if luasnip.locally_jumpable(1) then
                        luasnip.jump(1)
                    else
                        fallback()
                    end
                end, { 'i', 's' }),

                -- Jump back through a snippet.
                ['<C-o>'] = cmp.mapping(function(fallback)
                    if luasnip.locally_jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { 'i', 's' }),

                -- Toggle snippet choices.
                ['<C-c>'] = cmp.mapping(function(fallback)
                    if luasnip.choice_active() then
                        luasnip.change_choice(1)
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
            },
            sources = {
                -- Set lazydev group index to 0 to skip loading LuaLS completions according to lazydev recommendation.
                { name = 'lazydev', group_index = 0 },
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
                { name = 'path' },
                { name = 'nvim_lsp_signature_help' },
            },
            sorting = {
                priority_weight = 1,
                comparators = {
                    -- Deprioritize emmet, which aggressively puts snippet suggestions on top.
                    deprioritize_client('emmet_ls'),
                    -- Default comparator order.
                    cmp.config.compare.offset,
                    cmp.config.compare.exact,
                    cmp.config.compare.score,
                    cmp.config.compare.recently_used,
                    cmp.config.compare.kind,
                    cmp.config.compare.sort_text,
                    cmp.config.compare.length,
                    cmp.config.compare.order,
                },
            },
        })
    end,
}
