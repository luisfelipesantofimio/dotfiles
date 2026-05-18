require("gitsigns").setup({
  signs = {
    add          = { text = "▎" },
    change       = { text = "▎" },
    delete       = { text = "_" },
    topdelete    = { text = "‾" },
    changedelete = { text = "~" },
    untracked    = { text = "▎" },
  },
  current_line_blame = false,
  current_line_blame_opts = { delay = 500 },
  on_attach = function(buffer)
    local gs = require("gitsigns")
    local function bmap(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = buffer, desc = desc })
    end

    bmap("n", "]h", function() gs.nav_hunk("next") end, "Next hunk")
    bmap("n", "[h", function() gs.nav_hunk("prev") end, "Prev hunk")

    bmap({ "n", "v" }, "<leader>ghs", "<cmd>Gitsigns stage_hunk<cr>", "Stage hunk")
    bmap({ "n", "v" }, "<leader>ghr", "<cmd>Gitsigns reset_hunk<cr>", "Reset hunk")
    bmap("n", "<leader>ghS", gs.stage_buffer, "Stage buffer")
    bmap("n", "<leader>ghu", gs.undo_stage_hunk, "Undo stage hunk")
    bmap("n", "<leader>ghR", gs.reset_buffer, "Reset buffer")
    bmap("n", "<leader>ghp", gs.preview_hunk, "Preview hunk")
    bmap("n", "<leader>ghd", gs.diffthis, "Diff this")
    bmap("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff this ~")
    bmap("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame line")
    bmap("n", "<leader>gtb", gs.toggle_current_line_blame, "Toggle line blame")
    bmap("n", "<leader>gtd", gs.toggle_deleted, "Toggle deleted")
  end,
})
