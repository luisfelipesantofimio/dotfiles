local telescope = require("telescope")
local actions = require("telescope.actions")
local builtin = require("telescope.builtin")

telescope.setup({
  defaults = {
    prompt_prefix = "  ",
    selection_caret = "▶ ",
    -- Pad non-selected entries to match the caret width so rows stay aligned
    -- as the selection moves (no left/right shift on scroll).
    entry_prefix = "  ",
    -- Wrap long entries instead of horizontally scrolling them — prevents the
    -- "row jitters right" effect as the selection moves between long/short entries.
    wrap_results = true,
    dynamic_preview_title = true,
    path_display = { "smart" },
    sorting_strategy = "ascending",
    layout_strategy = "horizontal",
    layout_config = {
      prompt_position = "top",
      horizontal = { preview_width = 0.55 },
      width = 0.9,
      height = 0.85,
    },
    -- Preview: use treesitter wherever a parser is installed; fall back to
    -- regex syntax otherwise. `filesize_limit` is in MB.
    preview = {
      treesitter = true,
      filesize_limit = 5,
      timeout = 250,
    },
    -- <Esc> from insert mode drops into normal mode (vim-style navigation in
    -- the picker). Use <C-c> if you actually want to close the picker.
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-c>"] = actions.close,
        ["<C-u>"] = false,
      },
      n = {
        ["q"] = actions.close,
        ["<C-c>"] = actions.close,
      },
    },
  },
  pickers = {
    find_files = { hidden = true, follow = true },
    live_grep = { additional_args = function() return { "--hidden" } end },
    buffers = {
      sort_lastused = true,
      mappings = { i = { ["<C-d>"] = actions.delete_buffer } },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
  },
})

pcall(telescope.load_extension, "fzf")

local map = vim.keymap.set

-- Find
map("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
map("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
map("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
map("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
map("n", "<leader>fr", builtin.oldfiles, { desc = "Recent files" })
map("n", "<leader>fc", builtin.command_history, { desc = "Command history" })
map("n", "<leader>fk", builtin.keymaps, { desc = "Keymaps" })
map("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Document symbols" })
map("n", "<leader>fS", builtin.lsp_dynamic_workspace_symbols, { desc = "Workspace symbols" })
map("n", "<leader>fw", builtin.grep_string, { desc = "Word under cursor" })
map("n", "<leader>fd", builtin.diagnostics, { desc = "Diagnostics" })
map("n", "<leader>fR", builtin.resume, { desc = "Resume last picker" })
map("n", "<leader>fl", builtin.current_buffer_fuzzy_find, { desc = "Lines in buffer" })
-- Theme picker with a C-snippet preview buffer. Each entry, on selection,
-- applies the colorscheme to the current window — but we first replace the
-- current buffer with a scratch C file so the preview shows what comments,
-- keywords, types, strings, numbers, macros and control flow actually look
-- like under that theme. Cancel restores both the buffer and the original theme.
local C_PREVIEW_SNIPPET = [[
/*
 * Quicksort — Lomuto partition scheme.
 * Exercises: comments, includes, macros, types, pointers, control flow.
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_SIZE     128
#define SWAP(a, b)   do { __typeof__(a) _t = (a); (a) = (b); (b) = _t; } while (0)

typedef struct Node {
    int          value;
    char         name[32];
    struct Node *next;
} Node;

static int partition(int arr[], int low, int high) {
    int pivot = arr[high];
    int i     = low - 1;
    for (int j = low; j < high; j++) {
        if (arr[j] < pivot) {
            i++;
            SWAP(arr[i], arr[j]);
        }
    }
    SWAP(arr[i + 1], arr[high]);
    return i + 1;
}

void quicksort(int arr[], int low, int high) {
    if (low < high) {
        int p = partition(arr, low, high);
        quicksort(arr, low,     p - 1);
        quicksort(arr, p + 1,   high);
    }
}

int main(int argc, char **argv) {
    int    data[] = { 64, 25, 12, 22, 11, 90, 7, 33 };
    size_t n      = sizeof(data) / sizeof(data[0]);
    const char *label = "sorted";

    quicksort(data, 0, n - 1);
    for (size_t i = 0; i < n; i++) {
        printf("%s[%zu] = %d\n", label, i, data[i]);
    }
    return EXIT_SUCCESS;
}
]]

map("n", "<leader>ft", function()
  local pickers           = require("telescope.pickers")
  local finders           = require("telescope.finders")
  local previewers        = require("telescope.previewers")
  local telescope_actions = require("telescope.actions")
  local action_state      = require("telescope.actions.state")
  local conf              = require("telescope.config").values

  local orig_colorscheme = vim.g.colors_name
  local accepted = false

  -- Custom previewer: drops the C snippet into the preview buffer, sets ft=c,
  -- and applies the entry's colorscheme on every selection change. Telescope
  -- calls define_preview for the active entry whenever the selection moves,
  -- so this is the right hook for "live" theme switching.
  local c_preview = previewers.new_buffer_previewer({
    title = "C preview",
    define_preview = function(self, entry)
      local buf = self.state.bufnr
      if not vim.b[buf].theme_preview_loaded then
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(C_PREVIEW_SNIPPET, "\n"))
        vim.bo[buf].filetype = "c"
        vim.b[buf].theme_preview_loaded = true
      end
      local name = entry and (entry.value or entry[1])
      if name then pcall(vim.cmd.colorscheme, name) end
    end,
  })

  pickers.new({}, {
    prompt_title = "Theme (C preview)",
    finder       = finders.new_table({ results = vim.fn.getcompletion("", "color") }),
    sorter       = conf.generic_sorter({}),
    previewer    = c_preview,
    attach_mappings = function(prompt_bufnr, _)
      telescope_actions.select_default:replace(function()
        local sel = action_state.get_selected_entry()
        accepted = true
        telescope_actions.close(prompt_bufnr)
        local name = sel and (sel.value or sel[1])
        if name then pcall(vim.cmd.colorscheme, name) end
      end)
      -- Cancel: revert to the colorscheme we started with.
      vim.api.nvim_create_autocmd("BufWinLeave", {
        buffer = prompt_bufnr,
        once   = true,
        callback = function()
          if not accepted and orig_colorscheme and vim.g.colors_name ~= orig_colorscheme then
            pcall(vim.cmd.colorscheme, orig_colorscheme)
          end
        end,
      })
      return true
    end,
  }):find()
end, { desc = "Theme picker (C preview)" })

-- Git pickers (commits, branches, status, stash, files)
map("n", "<leader>gc", builtin.git_commits,  { desc = "Commits" })
map("n", "<leader>gC", builtin.git_bcommits, { desc = "Buffer commits" })
map("n", "<leader>gb", builtin.git_branches, { desc = "Branches" })
map("n", "<leader>gs", builtin.git_status,   { desc = "Status" })
map("n", "<leader>gS", builtin.git_stash,    { desc = "Stash" })
map("n", "<leader>gf", builtin.git_files,    { desc = "Tracked files" })
