local luasnip = require('luasnip')
local fmt = require('luasnip.extras.fmt').fmt

local s = luasnip.snippet
local sn = luasnip.snippet_node
local t = luasnip.text_node
local c = luasnip.choice_node
local i = luasnip.insert_node
local f = luasnip.function_node

-- TODO: How to source snippets without duplicates?
-- Setup source keybind to avoid restarting vim when iterating snippets.
-- vim.keymap.set('n', '<leader>o', '<cmd>source ~/.config/nvim/lua/extras/snippets.lua<CR>', { desc = 'Source snippets.' })

local identical_to = function(index)
    return f(function(arg)
        return arg[1]
    end, { index })
end

-- Lua snippets
local lua_snippets = {
    s('clog', fmt('print({})', { i(1) })),
    s('req', fmt("require('{}')", { i(1) })),
    s('insp', fmt('print(vim.inspect({}))', { i(1) })),
    s('fun', {
        sn(1, fmt('function({})', { i(1) })),
        c(2, {
            fmt('\n\t{}\n', { i(1) }, { trim_empty = false, dedent = false }),
            fmt(' {} ', { i(1) }, { dedent = false }),
        }),
        t('end'),
    }),
}

luasnip.add_snippets('lua', lua_snippets)

-- Javascript Snippets
local javascript_snippets = {
    s('clog', fmt('console.log({})', { i(1) })),
    s('fun', fmt('({}) => {{{}}}', { i(1), i(2) })),
    s('req', fmt("const {} = require('{}')", { identical_to(1), i(1) })),
    s('imp', fmt("import {} from '{}'", { identical_to(1), i(1) })),
    s('rfc', fmt('export default function {}({}){{\n\t\n\treturn ({})\n}}', { i(1, 'Component'), i(2), i(0) })),
    s(
        'iife',
        c(1, {
            fmt(';(() => {{{}}})({})', { i(1), i(2) }),
            fmt(';(async () => {{{}}})({})', { i(1), i(2) }),
        })
    ),
}

luasnip.add_snippets('javascript', javascript_snippets)
luasnip.add_snippets('javascriptreact', javascript_snippets)
luasnip.add_snippets('typescript', javascript_snippets)
luasnip.add_snippets('typescriptreact', javascript_snippets)
luasnip.add_snippets('vue', javascript_snippets)
