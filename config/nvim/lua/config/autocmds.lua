local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

autocmd("TextYankPost", {
  group = augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
  end,
  desc = "Briefly highlight yanked text",
})

autocmd("BufReadPost", {
  group = augroup("restore-cursor", { clear = true }),
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      vim.api.nvim_win_set_cursor(0, mark)
    end
  end,
  desc = "Restore the cursor position when reopening a file",
})

autocmd("FileType", {
  group = augroup("close-with-q", { clear = true }),
  pattern = {
    "help",
    "qf",
    "lspinfo",
    "checkhealth",
    "startuptime",
    "notify",
  },
  callback = function(args)
    vim.keymap.set("n", "q", "<cmd>close<cr>", {
      buffer = args.buf,
      silent = true,
      desc = "Close window",
    })
  end,
})

autocmd("FocusLost", {
  group = augroup("auto-write", { clear = true }),
  callback = function()
    if vim.bo.modified and not vim.bo.readonly and vim.fn.expand("%") ~= "" then
      vim.cmd("silent! write")
    end
  end,
  desc = "Write modified buffers when losing focus",
})
