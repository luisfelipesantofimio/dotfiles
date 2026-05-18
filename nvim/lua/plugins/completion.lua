require("blink.cmp").setup({
  -- Explicit keymap so accept behavior is the same with or without the popup:
  --   <Tab>      → if a snippet placeholder is active, jump forward;
  --                 if the menu is open, accept the highlighted item;
  --                 if ghost text alone is showing, accept it;
  --                 else literal Tab.
  --   <S-Tab>    → previous in menu / previous snippet placeholder.
  --   <CR>       → accept (covers cases where the popup is open but you'd rather Enter).
  --   <C-n/p>    → navigate without accepting.
  --   <C-space>  → toggle menu / docs.
  --   <C-e>      → cancel.
  keymap = {
    preset = "super-tab",
    ["<CR>"] = { "select_and_accept", "fallback" },
    ["<Tab>"] = {
      function(cmp)
        if cmp.snippet_active() then return cmp.accept() end
        if cmp.is_visible() then return cmp.select_and_accept() end
        if cmp.is_ghost_text_visible and cmp.is_ghost_text_visible() then
          return cmp.accept()
        end
      end,
      "snippet_forward",
      "fallback",
    },
    ["<C-n>"] = { "select_next", "fallback" },
    ["<C-p>"] = { "select_prev", "fallback" },
  },
  appearance = {
    nerd_font_variant = "mono",
  },
  completion = {
    accept = { auto_brackets = { enabled = true } },
    documentation = { auto_show = true, auto_show_delay_ms = 200 },
    list = {
      selection = { preselect = true, auto_insert = false },
    },
    menu = {
      border = "rounded",
      draw = { treesitter = { "lsp" } },
    },
    -- Ghost text off: it can look like a suggestion is "ready" while the
    -- popup isn't actually open, making <Tab> feel inconsistent.
    ghost_text = { enabled = false },
  },
  signature = { enabled = true, window = { border = "rounded" } },
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },
  fuzzy = { implementation = "prefer_rust_with_warning" },
})
