return {
  "julienvincent/nvim-paredit",
  config = function()
    local paredit = require("nvim-paredit")
    paredit.setup({
      indent = {
        enabled = true,
      },
      keys = {
        ["<localleader>o"] = false,
        ["<localleader>O"] = false,
        ["<localleader>io"] = { paredit.api.raise_form, "Raise form" },
        ["<localleader>iO"] = { paredit.api.raise_element, "Raise element" },
      },
    })
  end,
}
