# Neovim IDE config

Minimal, IDE-like Neovim config targeting **Neovim 0.12+**. Built on `vim.pack`,
`vim.lsp.config` / `vim.lsp.enable`, native `vim.treesitter`, and a small set of
plugins.

---

## Requirements

### System tools

| Tool | Status | Used for |
|------|--------|----------|
| Neovim ≥ 0.12 | required | uses `vim.pack`, `vim.lsp.config`, native treesitter, `vim.diagnostic.jump` |
| `git` | required | `vim.pack` clones plugins |
| `make` + C compiler | required | builds `telescope-fzf-native` on first install |
| `ripgrep` (`rg`) | required | `live_grep` and `grepprg` |
| Nerd Font (terminal-side) | required | mini.icons, statusline, file-explorer glyphs |
| `lazygit` | optional | `<leader>tg` floats it |
| `delve` (`dlv`) | required for Go debugging | `brew install delve` or `go install github.com/go-delve/delve/cmd/dlv@latest` |

### Language servers

There is no in-Neovim installer (Mason is intentionally not used). Install each binary system-wide; `vim.lsp.enable` auto-attaches when one is found on `PATH`. Missing servers are silent — the buffer still works, you just lose LSP features for that language.

| Language | Server | Filetypes | Install (macOS) | Install (other) |
|----------|--------|-----------|------------------|-----------------|
| Lua | `lua-language-server` | `lua` | `brew install lua-language-server` | `pacman -S lua-language-server` |
| C / C++ | `clangd` | `c`, `cpp`, `objc`, `objcpp`, `cuda` | `brew install llvm` (provides clangd) | `apt install clangd` |
| Go | `gopls` | `go`, `gomod`, `gowork`, `gotmpl` | `brew install gopls` | `go install golang.org/x/tools/gopls@latest` |
| Dart / Flutter | `dartls` (managed by flutter-tools.nvim) | `dart` | `brew install --cask flutter` | flutter.dev/docs/get-started |
| Rust | `rust-analyzer` | `rust` | `brew install rust-analyzer` | `rustup component add rust-analyzer` |
| Zig | `zls` | `zig`, `zon` | `brew install zls` | github.com/zigtools/zls/releases |
| Odin | `ols` | `odin` | build from source: github.com/DanielGavin/ols | same |
| JavaScript / TypeScript | `typescript-language-server` (`ts_ls`) | `js`, `ts`, `jsx`, `tsx` | `npm i -g typescript-language-server typescript` | same |
| HTML | `vscode-html-language-server` (`html`) | `html` | `npm i -g vscode-langservers-extracted` | `yay -S vscode-langservers-extracted` |
| CSS / SCSS | `vscode-css-language-server` (`css`) | `css`, `scss`, `less` | `npm i -g vscode-langservers-extracted` | `yay -S vscode-langservers-extracted` |
| Fortran | `fortls` | `fortran` | `pipx install fortls` | `pip install fortls` |
| Bash | `bash-language-server` (`bashls`) | `sh`, `bash` | `brew install bash-language-server` | `npm i -g bash-language-server` |
| Fish | `fish-lsp` (`fish_lsp`) | `fish` | `npm i -g fish-lsp` | same |
| XML | `lemminx` | `xml`, `xsd`, `xsl`, `xslt`, `svg` | `brew install lemminx` | github.com/eclipse/lemminx/releases |
| JSON | `vscode-json-language-server` (`jsonls`) | `json`, `jsonc` | `npm i -g vscode-langservers-extracted` | `pacman -S vscode-json-languageserver` |
| Markdown | `marksman` | `markdown`, `markdown.mdx` | `brew install marksman` | github.com/artempyanykh/marksman/releases |
| Python | `pyright` | `python` | `brew install pyright` | `npm i -g pyright` |
| TOML | `taplo` | `toml` | `brew install taplo` | `cargo install taplo-cli --features lsp` |

---

## First launch

1. Place this directory at `~/.config/nvim/`.
2. Launch `nvim` — `vim.pack` clones every plugin synchronously. Subsequent starts are instant.
3. Install whichever language servers you need (see the table above). They'll auto-attach the next time you open a matching file; no further config needed.
4. Open a real project file (not just `nvim`) so the server picks up `root_markers`.

To update plugins later: `<leader>Pu` (opens a confirm buffer, `:w` applies) or `<leader>PU` (updates everything without confirming). To remove a plugin (after deleting it from `lua/config/plugins.lua`): `:lua vim.pack.del({ "<name>" })`.

---

## Layout

```
~/.config/nvim/
├── init.lua                  entry point
├── lua/
│   ├── config/
│   │   ├── options.lua       vim options
│   │   ├── keymaps.lua       global keymaps
│   │   ├── autocmds.lua      misc autocmds (yank highlight, last-loc, native treesitter)
│   │   └── plugins.lua       vim.pack spec + plugin loader
│   ├── plugins/              one file per plugin
│   └── lsp/                  one file per language server (consumed by vim.lsp.config)
└── after/ftplugin/           per-language overrides (indent, format-on-save)
```

---

## Plugins

| Plugin | Role |
|--------|------|
| `ellisonleao/gruvbox.nvim` | colorscheme |
| `echasnovski/mini.nvim` | icons, pairs, surround, comment, ai, indentscope, notify, sessions, bufremove, trailspace |
| `nvim-lualine/lualine.nvim` | statusline |
| `stevearc/aerial.nvim` | symbol outline (lateral panel) |
| `nvim-telescope/telescope.nvim` + `telescope-fzf-native.nvim` | fuzzy finder |
| `nvim-tree/nvim-tree.lua` | file explorer |
| `lewis6991/gitsigns.nvim` | git gutter + hunk operations |
| `akinsho/toggleterm.nvim` | float / horizontal / vertical terminals |
| `folke/which-key.nvim` | keymap discovery popup |
| `saghen/blink.cmp` (`^1`) | LSP completion — prebuilt binaries auto-fetched |
| `nvim-flutter/flutter-tools.nvim` | Flutter/Dart tooling; manages `dartls` itself |
| `nvim-lua/plenary.nvim` | telescope dependency |
| `nvim-treesitter/nvim-treesitter-context` | sticky context bar (current function/class at top of window) |
| `mfussenegger/nvim-dap` | Debug Adapter Protocol client |
| `leoluz/nvim-dap-go` | Go debug adapter config (drives `dlv`) |
| `rcarriga/nvim-dap-ui` (+ `nvim-neotest/nvim-nio`) | debug UI: scopes, breakpoints, stacks, watches, REPL |
| `theHamsta/nvim-dap-virtual-text` | inline variable values while debugging |
| `sphamba/smear-cursor.nvim` | animated cursor trail |

---

## Treesitter (native runtime)

Highlighting, indent, and folds come from core `vim.treesitter` — there is no `nvim-treesitter` highlight module. The autocmd in `lua/config/autocmds.lua` starts the native highlighter on every `FileType` *if* a parser is installed; otherwise the buffer falls back to Vim regex syntax.

Parsers are installed by the `nvim-treesitter` **`main` branch**, used purely as a parser installer/query provider (see `lua/plugins/treesitter.lua`). It fetches parsers into its install dir (on the runtimepath) and ships Neovim-compatible queries; the native autocmd above then picks them up. `ts.install()` is async and idempotent, so it's re-run on every startup and only fetches what's missing.

Neovim 0.12 also ships parsers + queries for: `c`, `lua`, `vim`, `vimdoc`, `query`, `markdown`, `markdown_inline`.

To add a language, append it to the `ensure` list in `lua/plugins/treesitter.lua` (e.g. `go`, `gomod`, `gowork`, `gotmpl` are already there) and restart, or run `:lua require("nvim-treesitter").install({ "<lang>" })`. A fully manual route is still documented in [Adding a treesitter parser](#adding-a-treesitter-parser).

`nvim-treesitter-context` (`lua/plugins/treesitter-context.lua`) pins the enclosing function/class/block to the top of the window as you scroll through its body. It reads treesitter queries directly, so it works on top of whatever parsers are installed above — no separate setup. Toggle it with `<leader>lx`.

---

## Keymaps

Leader is `<Space>`. The which-key popup (300ms) shows everything available under any prefix.

### Editing & windows

| Keys | Action |
|------|--------|
| `<leader>w` / `<leader>q` / `<leader>Q` | save / quit window / quit all |
| `jk` (insert) | escape |
| `<Esc>` (normal) | clear search highlight |
| `<C-w>h/j/k/l` | window navigation (Vim native) |
| `<C-arrows>` | resize window |
| `/` | split horizontally (search via telescope: `<leader>fg`, `<leader>fl`) |
| `\|` | split vertically |
| `J`, `<C-d>`, `<C-u>`, `n`, `N` | keep cursor centered |
| `]d` / `[d` | next / prev diagnostic |

### Buffers

| Keys | Action |
|------|--------|
| `<C-h>` / `<C-k>` | previous buffer |
| `<C-l>` / `<C-j>` | next buffer |
| `<S-h>` / `<S-l>` | prev / next buffer (alternate) |
| `<C-q>` | close current buffer (window preserved) |
| `<leader>bp` | jump to alternate buffer (the one you came from) |
| `<leader>bd` | delete current buffer |
| `<leader>bn` | new empty buffer |
| `<leader>bc` | close every other buffer |
| `<leader>bC` | close every buffer (modified ones are skipped) |

### Find (telescope)

| Keys | Action |
|------|--------|
| `<leader>ff` | find files |
| `<leader>fg` | live grep |
| `<leader>fb` | buffers |
| `<leader>fr` | recent files |
| `<leader>fh` | help tags |
| `<leader>fk` | keymaps |
| `<leader>fs` / `<leader>fS` | document / workspace symbols |
| `<leader>fd` | diagnostics |
| `<leader>fw` | grep word under cursor |
| `<leader>fl` | lines in current buffer |
| `<leader>fc` | command history |
| `<leader>fR` | resume last picker |
| `<leader>ft` | theme picker (live preview while scrolling) |

Inside any picker: `<Esc>` drops to normal mode (full vim navigation: `j/k`, `gg/G`, `q`, `?`, `i`, `a`); `<C-c>` closes from either mode; `<C-j>`/`<C-k>` navigate while typing.

### Files (nvim-tree)

| Keys | Action |
|------|--------|
| `<leader>e` | toggle explorer |
| `<leader>o` | switch focus tree ↔ editor (opens it if hidden) |
| `s` (in tree) | open file in vertical split |
| `S` (in tree) | open file in horizontal split |

The tree alone is allowed at startup (e.g. `nvim .`). Once you've opened any real file, the tree being the *only* remaining window will exit Neovim.

### Git

| Keys | Action |
|------|--------|
| `<leader>gc` | commits picker |
| `<leader>gC` | buffer commits |
| `<leader>gb` | branches |
| `<leader>gs` | status |
| `<leader>gS` | stash |
| `<leader>gf` | tracked files |
| `]h` / `[h` | next / prev hunk |
| `<leader>ghs` / `<leader>ghr` | stage / reset hunk (visual selects work) |
| `<leader>ghS` / `<leader>ghR` | stage / reset whole buffer |
| `<leader>ghp` | preview hunk |
| `<leader>ghd` / `<leader>ghD` | diff this / diff against `~` |
| `<leader>ghb` | full blame for line |
| `<leader>gtb` / `<leader>gtd` | toggle line blame / show deleted |
| `<leader>tg` | lazygit float |

### Terminals (toggleterm)

| Keys | Action |
|------|--------|
| `<leader>tf` | floating |
| `<leader>th` | horizontal split |
| `<leader>tv` | vertical split |
| `<leader>tt` / `<C-\>` | toggle last terminal |
| `<Esc>` / `jk` (terminal mode) | exit to normal mode |

### LSP

`g`-prefix mappings and `<leader>c*` keys remain for muscle memory. `<leader>l*` is a discoverability mirror — every LSP feature in one menu.

| Keys | Action |
|------|--------|
| `gd` / `gD` | definition / declaration |
| `gr` | references |
| `gi` / `gy` | implementation / type definition |
| `K` | hover (rounded border, capped at 80×25, wraps) |
| `<leader>cr` / `<leader>ca` / `<leader>cf` | rename / code action / format |
| `<leader>lI` | `:checkhealth vim.lsp` (always available) |
| `<leader>lR` | `:LspRestart` |
| `<leader>lL` | open the LSP log file |
| `<leader>lh` / `<leader>ls` | hover / signature help |
| `<leader>ld` / `<leader>lD` | definition / declaration |
| `<leader>lr` / `<leader>lm` / `<leader>lt` | references / implementation / type def |
| `<leader>la` / `<leader>ln` / `<leader>lf` | code action / rename / format |
| `<leader>lo` | toggle outline panel (aerial) |
| `<leader>lO` | workspace symbols (telescope) |
| `<leader>lN` | symbol navigator (aerial floating) |
| `<leader>lx` | toggle sticky context bar (treesitter-context) |
| `<leader>li` | toggle inlay hints |
| `<leader>ll` / `<leader>lT` | run / refresh code lens |
| `<leader>lwa` / `<leader>lwr` / `<leader>lwl` | workspace folder add / remove / list |
| `<leader>lci` / `<leader>lco` | call hierarchy: incoming / outgoing |

### Diagnostics

| Keys | Action |
|------|--------|
| `<leader>xd` | line diagnostics float |
| `<leader>xq` | diagnostics → loclist |

### Debug (nvim-dap)

Requires `dlv` on `PATH` (see [System tools](#system-tools)). `nvim-dap-go` provides
the Go adapter/configs; `nvim-dap-ui` opens automatically when a session starts
and closes when it ends; `nvim-dap-virtual-text` shows variable values inline
while stopped.

| Keys | Action |
|------|--------|
| `<leader>db` | toggle breakpoint |
| `<leader>dB` | conditional breakpoint (prompts for condition) |
| `<leader>dc` | continue / start session |
| `<leader>di` / `<leader>do` / `<leader>dO` | step into / over / out |
| `<leader>dr` | toggle REPL |
| `<leader>du` | toggle debug UI |
| `<leader>dl` | run last |
| `<leader>dx` | terminate session |
| `<leader>dgt` | (Go) debug nearest test |
| `<leader>dgl` | (Go) debug last test |

### Packages (vim.pack)

| Keys | Action |
|------|--------|
| `<leader>Pu` | check for updates; opens a confirm buffer — `:w` (or save normally) applies the selected updates, closing the window cancels |
| `<leader>PU` | update everything immediately, no confirmation |

### Sessions

All sessions live in `~/.local/share/nvim/sessions/`. Project sessions are auto-saved on `:qa`, keyed by an encoded cwd.

| Keys | Action |
|------|--------|
| `<leader>Ss` | save under a custom name |
| `<leader>Sf` | telescope picker over all sessions; `<C-d>` deletes |
| `<leader>Sl` | load this project's auto-saved session |
| `<leader>Sd` | delete via `vim.ui.select` |

### Comments

| Keys | Action |
|------|--------|
| `<leader>/` | toggle comment (line in normal, selection in visual) |
| `gcc` / `gc` | mini.comment's native bindings still work |

### Flutter

| Keys | Action |
|------|--------|
| `<leader>Fr` / `<leader>FR` / `<leader>Fq` | run / restart / quit |
| `<leader>Fd` / `<leader>Fe` | devices / emulators |
| `<leader>Fl` / `<leader>Fo` | log clear / outline |
| `<leader>Fp` / `<leader>Fu` | pub get / pub upgrade |
| `<leader>Fv` | DevTools |


---

## Per-language behavior

Defined in `after/ftplugin/<lang>.lua`. Languages not listed below use the global defaults from `lua/config/options.lua` (2-space, expand).

| Filetype | Indent | Format on save |
|----------|--------|----------------|
| C | 4-space, expand | yes (`clangd`) |
| Lua | 2-space, expand | no |
| Go | tabs (4-wide) | yes — runs `source.organizeImports` then `gopls` format |
| Dart | 2-space, expand | yes (`dartls`) |
| Rust | 4-space, expand | yes (`rust-analyzer`) |
| Zig | 4-space, expand | yes (`zls`) |
| Odin | 4-space, expand | no |
| Markdown | 2-space, expand, wrap on | no |
| Python | 4-space, expand | no |
| JS / TS / JSON / XML / TOML | 2-space, expand (default) | no |
| Fortran / Bash / Fish | inherits defaults | no |

---

## Integrations

A walkthrough of how each piece is wired and where to look in the code.

### Telescope (fuzzy finder) — `lua/plugins/telescope.lua`

- `defaults.preview.treesitter = true` so previews use treesitter when a parser is available.
- `<Esc>` in the prompt drops into normal mode; `<C-c>` closes. Normal-mode bindings (`j/k`, `q`, `gg`, `G`, `?`) work inside any picker.
- `telescope-fzf-native` provides Rust-fast scoring (built on first install via `PackChanged`).
- File-size limit on previews is 5 MB (skips bigger files).
- Git pickers (`<leader>gc/gC/gb/gs/gS/gf`) live alongside file pickers.

### Git (gitsigns + telescope) — `lua/plugins/git.lua`

- gitsigns adds gutter signs and the per-buffer `<leader>gh*` hunk operators.
- The `diff` filetype highlights are explicitly redefined in `lua/plugins/colorscheme.lua` because gruvbox leaves `DiffAdd`/`DiffDelete`/`DiffChange` undefined and Vim's stock diff syntax links both `diffAdded` and `diffRemoved` to the same group. After the override, telescope git previews show vivid green/red/yellow line highlights.
- `<leader>tg` opens lazygit in a float (only if `lazygit` is on `PATH`).

### Sessions (mini.sessions) — `lua/plugins/sessions.lua`

- Two kinds: **project** (auto-saved per cwd, keyed by an encoded path like `proj%Users%foo%project`) and **named** (manual via `<leader>Ss`). Both live in `~/.local/share/nvim/sessions/`. Nothing is ever written into the project directory.
- Auto-save fires on `VimLeavePre`. Cold launches with no buffers don't write anything.
- The picker uses telescope's `dropdown` theme — single column, no preview, fixed width.
- `<leader>Sf` is the picker; `<C-d>` inside it deletes a session.

### Terminals (toggleterm) — `lua/plugins/terminal.lua`

- One persistent terminal per direction (`floating`, `horizontal`, `vertical`) — toggling preserves state and process.
- `<C-\>` is the global open mapping (toggleterm's default).
- Lazygit is a separate `Terminal:new` instance with `cmd = "lazygit"`, accessible via `<leader>tg`.

### LSP — `lua/plugins/lsp.lua` and `lua/lsp/<server>.lua`

- One file per server: a plain table with `cmd`, `filetypes`, `root_markers`, optional `settings` / `init_options`.
- The loader iterates `servers`, calls `vim.lsp.config(name, cfg)` for each, then `vim.lsp.enable(servers)` once.
- Capabilities are merged from blink.cmp via `vim.lsp.config("*", { capabilities = ... })`.
- `LspAttach` autocmd sets buffer-local keymaps, enables inlay hints, hooks `CursorHold` document-highlight, and (where supported) wires code-lens shortcuts.
- `flutter-tools.nvim` is the one carve-out: it owns dartls and is **not** in the `servers` list (it would double-attach).

### Debugging (nvim-dap + dap-go + dap-ui + virtual-text) — `lua/plugins/dap.lua`

- `dap-go.setup()` registers the Go adapter, which shells out to `dlv dap` — no
  manual adapter config needed. It also exposes `debug_test()` /
  `debug_last_test()`, used by `<leader>dgt` / `<leader>dgl`.
- `dap.listeners.after.event_initialized` / `before.event_terminated` /
  `before.event_exited` open and close `dapui` automatically, so the panel
  tracks the session lifecycle instead of needing manual toggling.
- Breakpoint/stopped signs reuse the existing `DiagnosticSignError/Warn/Info/Hint`
  highlight groups (same ones the LSP diagnostics use — see `lua/plugins/lsp.lua`)
  so the gutter stays visually consistent instead of introducing new colors.
- `nvim-dap-virtual-text` renders variable values at end-of-line while a session
  is stopped; no extra wiring — it listens to `nvim-dap` events itself.

### Cursor trail (smear-cursor) — `lua/plugins/smear-cursor.lua`

- `require("smear_cursor").setup()` with defaults — no config overrides.
- `:SmearCursorToggle` (built into the plugin) turns the effect on/off for the session if it's distracting.

### Outline (aerial) — `lua/plugins/aerial.lua`

- Backends preference: LSP → treesitter → markdown → man.
- `attach_mode = "global"` so the outline reflects whichever buffer has focus.
- Right-edge panel, 30 cols wide, `autojump = false` (cursor moves don't teleport — press `<CR>` to jump).
- `<leader>lo` toggles, `<leader>lN` opens a floating navigator.

### Completion (blink.cmp) — `lua/plugins/completion.lua`

- `super-tab` preset, with `<Tab>` explicitly handling: snippet placeholder forward → menu accept → ghost-text accept → literal Tab fallback.
- `<CR>` accepts (belt-and-suspenders).
- `selection.preselect = true` + `auto_insert = false` → first item highlighted from the start, buffer text only changes on accept.
- `ghost_text` is off by default to avoid confusion with the popup.
- Sources: `lsp`, `path`, `snippets`, `buffer`. Prebuilt fuzzy binaries are auto-downloaded via the `^1` version pin.

---

## Playbooks

### Adding a colorscheme

1. **Add the plugin** to `lua/config/plugins.lua`:

   ```lua
   { src = "https://github.com/folke/tokyonight.nvim" },
   ```

2. **Replace the call** in `lua/plugins/colorscheme.lua`:

   ```lua
   require("tokyonight").setup({ style = "moon" })
   vim.cmd.colorscheme("tokyonight")
   ```

3. **Update lualine** in `lua/plugins/statusline.lua` if the new theme has its own lualine variant:

   ```lua
   options = { theme = "tokyonight", ... }
   ```

   If lualine doesn't ship a theme for it, set `theme = "auto"` (lualine derives from the active colorscheme).

4. **Re-apply highlight overrides** — the existing `ColorScheme` autocmd in `lua/plugins/colorscheme.lua` re-runs the diff/cursor-line overrides automatically. If you want to drop them, remove the `apply_overrides` call.

5. **Restart Neovim** or `:source $MYVIMRC`. The `vim.pack.add` call is synchronous on first load, so the plugin will be cloned and ready.

### Adding a language

Worked example: adding **Kotlin**.

1. **Install the language server** (no in-Neovim installer):

   ```sh
   brew install kotlin-language-server
   ```

   Confirm: `which kotlin-language-server`.

2. **Define the LSP config** in `lua/lsp/kotlin_language_server.lua`:

   ```lua
   return {
     cmd = { "kotlin-language-server" },
     filetypes = { "kotlin" },
     root_markers = { "settings.gradle", "settings.gradle.kts", "build.gradle", "build.gradle.kts", ".git" },
   }
   ```

   The schema mirrors `vim.lsp.config`: `cmd`, `filetypes`, `root_markers`, `settings`, optionally `init_options`/`capabilities`. Don't redefine capabilities or `LspAttach` keymaps — those are wired globally.

   *Tip:* the `nvim-lspconfig` repo's `lua/lspconfig/configs/<name>.lua` is the canonical source for `cmd`/`filetypes`/`root_markers` for any server — copy-translate.

3. **Append to the servers list** in `lua/plugins/lsp.lua`:

   ```lua
   local servers = {
     -- existing entries...
     "kotlin_language_server",
   }
   ```

   The loader does the rest (`vim.lsp.config(name, cfg)` + `vim.lsp.enable(servers)`).

4. **(Optional) ftplugin overrides** in `after/ftplugin/kotlin.lua`:

   ```lua
   vim.bo.tabstop = 4
   vim.bo.shiftwidth = 4
   vim.bo.softtabstop = 4
   vim.bo.expandtab = true

   vim.api.nvim_create_autocmd("BufWritePre", {
     buffer = 0,
     callback = function()
       if next(vim.lsp.get_clients({ bufnr = 0, name = "kotlin_language_server" })) then
         vim.lsp.buf.format({ async = false, timeout_ms = 2000 })
       end
     end,
   })
   ```

5. **(Optional) install a treesitter parser** for highlighting — see below.

6. **Verify**:

   ```vim
   :e foo.kt
   :checkhealth vim.lsp        " confirm kotlin_language_server attached
   :Inspect                    " show treesitter highlight at cursor
   ```

#### Special cases

- **Server is a meta-plugin** (e.g. `flutter-tools.nvim`, `rustaceanvim`) — install the plugin in `lua/config/plugins.lua` and let it own the LSP. Don't list its server in `lua/plugins/lsp.lua` or you'll double-attach.
- **Multiple filetypes share a server** (e.g. `clangd` for C/C++/Objective-C) — list them all in the server's `filetypes` table; one entry in `servers` is enough.
- **Per-project settings** — drop a `.luarc.json` / `compile_commands.json` / `rust-project.json` etc. in the project root. `root_markers` makes the server auto-anchor there.

### Adding a treesitter parser

Native treesitter has no installer. For language `<lang>`:

1. **Build the parser** (one-time, requires `tree-sitter` CLI and a C compiler):

   ```sh
   git clone --depth 1 https://github.com/tree-sitter/tree-sitter-<lang>
   cd tree-sitter-<lang>
   tree-sitter generate            # only if a generated src/parser.c isn't checked in
   cc -O2 -fPIC -shared -I src src/parser.c src/scanner.c \
      -o ~/.config/nvim/parser/<lang>.so
   ```

2. **Copy the queries** (highlights, indents, locals, injections, folds — whichever the parser ships):

   ```sh
   mkdir -p ~/.config/nvim/queries/<lang>
   cp queries/*.scm ~/.config/nvim/queries/<lang>/
   ```

3. Restart Neovim. The `FileType` autocmd in `lua/config/autocmds.lua` picks up the new parser and starts the highlighter automatically.

If the parser repo doesn't ship Neovim-compatible queries, grab them from the [`nvim-treesitter` queries directory](https://github.com/nvim-treesitter/nvim-treesitter/tree/main/runtime/queries) and copy the ones you need.

---

## Troubleshooting

- **Plugins didn't update** — `<leader>Pu` opens a confirm buffer listing pending updates; it does nothing until you save it (`:w`) — closing the window without saving cancels. `<leader>PU` skips the confirm step entirely. To force a re-checkout of one plugin: `:lua vim.pack.update({ "<plugin>" }, { force = true })`. To remove: `:lua vim.pack.del({ "<plugin>" })`.
- **fzf-native missing build** — `cd ~/.local/share/nvim/site/pack/core/opt/telescope-fzf-native.nvim && make`, or `:lua vim.pack.update({ "telescope-fzf-native.nvim" }, { force = true })` to retrigger the `PackChanged` build hook.
- **LSP not attaching** — `:checkhealth vim.lsp` (or `<leader>lI`). Confirm the server binary is on `PATH` (`:!which clangd`, etc.). Make sure your project has one of the configured `root_markers` somewhere up the tree.
- **Treesitter highlighting absent** — check the parser installed: `:checkhealth nvim-treesitter` or `:lua print(vim.treesitter.language.add("<lang>"))`. Add the language to the `ensure` list in `lua/plugins/treesitter.lua` (or `:lua require("nvim-treesitter").install({ "<lang>" })`). Without a parser the file falls back to Vim regex syntax — that's by design.
- **blink.cmp errors about a missing binary** — make sure the spec keeps `version = vim.version.range("^1")`. The prebuilt fuzzy library is downloaded only on tagged releases.
- **`<leader>Sf` opens but the prompt doesn't react** — confirm you're in the prompt buffer (insert mode by default). `<Esc>` drops to normal-mode picker bindings, `<C-c>` closes.
- **Auto-quit on tree-only window fires unexpectedly** — the gate is "did the user open a real buffer this session?". If it triggers wrongly, check `lua/plugins/tree.lua`'s `opened_real_buffer` flag logic.
