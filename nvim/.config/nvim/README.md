# Neovim Keymap Cheatsheet

Leader key is set to `<space>`.

## File Explorer
| Shortcut         | Mode   | Action           |
|------------------|--------|------------------|
| `<leader>e`      | Normal | Toggle file tree |

## Telescope (Fuzzy Finder)
| Shortcut             | Mode   | Action         |
|----------------------|--------|----------------|
| `<leader><leader>`   | Normal | Find files     |
| `<leader>fg`         | Normal | Live grep      |
| `<leader>fb`         | Normal | List buffers   |
| `<leader>fh`         | Normal | Help tags      |

## LSP (Language Server Protocol)
| Shortcut         | Mode         | Action                  |
|------------------|--------------|-------------------------|
| `gd`             | Normal       | Go to definition        |
| `gD`             | Normal       | Go to declaration       |
| `gi`             | Normal       | Go to implementation    |
| `gr`             | Normal       | List references         |
| `K`              | Normal       | Hover documentation     |
| `<leader>rn`     | Normal       | Rename symbol           |
| `<leader>ca`     | Normal       | Code action             |
| `<leader>fd`     | Normal       | Show line diagnostics   |
| `[d`             | Normal       | Previous diagnostic     |
| `]d`             | Normal       | Next diagnostic         |
| `<leader>f`      | Normal/Visual| Format code             |

## Completion (nvim-cmp)
| Shortcut     | Mode   | Action                        |
|--------------|--------|-------------------------------|
| `<C-Space>`  | Insert | Trigger completion            |
| `<C-e>`      | Insert | Abort completion              |
| `<CR>`       | Insert | Confirm completion            |
| `<C-f>`      | Insert | Scroll docs forward           |
| `<C-b>`      | Insert | Scroll docs backward          |
| `<Tab>`      | Insert | Next item/expand snippet      |
| `<S-Tab>`    | Insert | Prev item/jump back in snippet|

## Compile/Run Hotkeys
| Shortcut     | Mode   | Action                  |
|--------------|--------|-------------------------|
| `<leader>r`  | Normal | Run Rust (`cargo run`)  |
| `<leader>c`  | Normal | Compile & run C++       |
| `<leader>p`  | Normal | Run Python (`python3`)  |

---
- `<leader>` means your leader key, which is set to `<space>`.
- Normal mode = press `Esc` then the shortcut.
- Visual mode = select text, then the shortcut.
- Insert mode = while editing text.
