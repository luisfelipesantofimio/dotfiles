-- Session management — every session file lives in `<stdpath('data')>/sessions/`.
-- Project sessions are keyed by the cwd (path-encoded into the filename), so
-- nothing is ever written into the project directory.

local sessions = require("mini.sessions")
local sessions_dir = vim.fn.stdpath("data") .. "/sessions"

vim.fn.mkdir(sessions_dir, "p")

sessions.setup({
  autoread = false,
  autowrite = true, -- save the *currently loaded* session on exit
  directory = sessions_dir,
  -- Set `file` to a sentinel so mini.sessions never matches a real
  -- file in cwd (i.e. local sessions are effectively disabled).
  file = "__no_local_session__",
  verbose = { read = false, write = false, delete = true },
})

-- /Users/foo/myapp  →  proj%Users%foo%myapp
local function project_name(cwd)
  cwd = cwd or vim.fn.getcwd()
  return "proj" .. cwd:gsub("[\\/]", "%%")
end

local function decode_project(name)
  if not name:match("^proj") then return nil end
  return name:sub(5):gsub("%%", "/")
end

-- Auto-save on :qa.
-- - If a session was loaded this run, mini.sessions's autowrite handles it.
-- - Otherwise, write a project session for cwd into the central dir.
vim.api.nvim_create_autocmd("VimLeavePre", {
  group = vim.api.nvim_create_augroup("auto_save_session", { clear = true }),
  callback = function()
    if vim.v.this_session ~= "" then return end
    if vim.fn.argc() == 0 and #vim.fn.getbufinfo({ buflisted = 1, bufloaded = 1 }) == 0 then
      return
    end
    pcall(sessions.write, project_name(), { force = true })
  end,
})

-- Fresh disk scan per call so the picker reflects current state.
local function list_sessions()
  local results = {}
  for _, name in ipairs(vim.fn.readdir(sessions_dir)) do
    if not name:match("^%.") then
      local path = sessions_dir .. "/" .. name
      local stat = (vim.uv or vim.loop).fs_stat(path)
      local cwd = decode_project(name)
      table.insert(results, {
        name         = name,
        kind         = cwd and "project" or "named",
        display_name = cwd or name,
        path         = path,
        mtime        = stat and stat.mtime.sec or 0,
      })
    end
  end
  table.sort(results, function(a, b) return a.mtime > b.mtime end)
  return results
end

local map = vim.keymap.set

-- <leader>Ss — save under a custom name.
map("n", "<leader>Ss", function()
  vim.ui.input({ prompt = "Session name: " }, function(name)
    if not name or name == "" then return end
    sessions.write(name, { force = true })
    vim.notify("Saved session: " .. name)
  end)
end, { desc = "Save session as…" })

-- <leader>Sl — load this project's auto-saved session.
map("n", "<leader>Sl", function()
  local n = project_name()
  if vim.fn.filereadable(sessions_dir .. "/" .. n) == 1 then
    sessions.read(n)
  else
    vim.notify("No session for this project.", vim.log.levels.WARN)
  end
end, { desc = "Load project session" })

-- <leader>Sf — telescope picker over all sessions.
map("n", "<leader>Sf", function()
  local items = list_sessions()
  if #items == 0 then
    vim.notify("No sessions found.", vim.log.levels.INFO)
    return
  end

  local pickers       = require("telescope.pickers")
  local finders       = require("telescope.finders")
  local actions       = require("telescope.actions")
  local action_state  = require("telescope.actions.state")
  local conf          = require("telescope.config").values
  local themes        = require("telescope.themes")

  -- Dropdown theme = single-column centered list, no preview pane reserved.
  -- Avoids the horizontal-shift effect from the default horizontal layout.
  local picker_opts = themes.get_dropdown({
    prompt_title = "Sessions",
    layout_config = { width = 0.6, height = 0.5 },
    previewer = false,
  })

  pickers.new(picker_opts, {
    finder = finders.new_table({
      results = items,
      entry_maker = function(e)
        -- Truncate very long project paths so the entry never exceeds picker width.
        local name = e.display_name
        if #name > 50 then name = "…" .. name:sub(-49) end
        return {
          value   = e,
          display = string.format("[%-7s] %s", e.kind, name),
          ordinal = e.display_name,
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, m)
      actions.select_default:replace(function()
        local sel = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        if sel and sel.value then sessions.read(sel.value.name) end
      end)
      m({ "i", "n" }, "<C-d>", function()
        local sel = action_state.get_selected_entry()
        if sel and sel.value then
          sessions.delete(sel.value.name, { force = true })
          actions.close(prompt_bufnr)
        end
      end)
      return true
    end,
  }):find()
end, { desc = "Find session" })

-- <leader>Sd — delete via vim.ui.select.
map("n", "<leader>Sd", function()
  local items = list_sessions()
  if #items == 0 then
    vim.notify("No sessions to delete.", vim.log.levels.INFO)
    return
  end
  vim.ui.select(items, {
    prompt = "Delete session",
    format_item = function(s) return string.format("[%s] %s", s.kind, s.display_name) end,
  }, function(choice)
    if choice then sessions.delete(choice.name, { force = true }) end
  end)
end, { desc = "Delete session" })
