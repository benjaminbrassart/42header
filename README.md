# 42header

42 header for Neovim in lua.

## Installation

Install with [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
    "benjaminbrassart/42header",
    opts = {
        user = "bbrassar",
    },
}
```

Here are the available options:
- `user` (string) the username used in the header, defaults to `marvin`
- `mail` (string) the email used in the header, defaults to `<user>@student.42.fr`
- `update_on_write` (boolean) whether to update the header on file write, defaults to `true`

## Usage

The command to insert or update the header in `:Stdheader`. You can map it to a key for conve

```lua
-- in your init.lua
-- map :Stdheader to F2
vim.api.nvim_set_keymap("n", "<F2>", ":Stdheader<CR>", { noremap = true })
```

## License

This project is licensed under the [MIT license](LICENSE).
