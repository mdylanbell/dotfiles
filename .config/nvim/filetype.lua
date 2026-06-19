vim.filetype.add({
  extension = {
    tfrc = "terraform",
  },
  pattern = {
    ["${XDG_CONFIG_HOME}/git/config%..*"] = "gitconfig",
    ["${DOTFILES_ROOT}/%.config/git/config%..*"] = "gitconfig",
  },
})
