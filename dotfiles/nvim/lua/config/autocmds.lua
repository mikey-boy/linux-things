-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "markdown" },
  callback = function()
    vim.cmd("NoNeckPain")
    vim.cmd("set nospell")
    vim.cmd("hi @markup.heading.1.markdown guifg=#458588 gui=bold")
    vim.cmd("hi @markup.heading.2.markdown guifg=#d79921 gui=bold")
    vim.cmd("hi @markup.heading.3.markdown guifg=#98971a gui=bold")
    vim.cmd("hi @markup.heading.1.marker.markdown guifg=#458588 gui=bold")
    vim.cmd("hi @markup.heading.2.marker.markdown guifg=#d79921 gui=bold")
    vim.cmd("hi @markup.heading.3.marker.markdown guifg=#98971a gui=bold")
  end,
})
