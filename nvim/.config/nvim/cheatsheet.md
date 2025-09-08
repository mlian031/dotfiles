# Neovim Cheatsheet

## Basic Modes
| Key         | Action                        |
|-------------|------------------------------|
| `i`         | Insert mode                  |
| `v`         | Visual mode                  |
| `V`         | Visual line mode             |
| `Ctrl+v`    | Visual block mode            |
| `Esc`       | Normal mode                  |
| `:`         | Command-line mode            |

## File Operations
| Key         | Action                        |
|-------------|------------------------------|
| `:w`        | Save file                    |
| `:q`        | Quit                         |
| `:wq`       | Save and quit                |
| `:e <file>` | Open file                    |
| `:Ex`       | Open file explorer           |

## Navigation
| Key         | Action                        |
|-------------|------------------------------|
| `h` `j` `k` `l` | Left, Down, Up, Right   |
| `gg`        | Go to top                    |
| `G`         | Go to bottom                 |
| `0`         | Start of line                |
| `$`         | End of line                  |
| `w`         | Next word                    |
| `b`         | Previous word                |
| `Ctrl+d`    | Half-page down               |
| `Ctrl+u`    | Half-page up                 |

## Editing
| Key         | Action                        |
|-------------|------------------------------|
| `dd`        | Delete line                  |
| `yy`        | Yank (copy) line             |
| `p`         | Paste after cursor           |
| `u`         | Undo                         |
| `Ctrl+r`    | Redo                         |
| `x`         | Delete character             |
| `r<char>`   | Replace character            |
| `cw`        | Change word                  |
| `cc`        | Change line                  |

## Visual Mode & Clipboard
| Key         | Action                        |
|-------------|------------------------------|
| `v`         | Start visual mode            |
| `V`         | Start linewise visual mode   |
| `Ctrl+v`    | Start block visual mode      |
| `y`         | Yank (copy) selection        |
| `d`         | Delete selection             |
| `c`         | Change selection             |
| `"+y`       | Yank to system clipboard     |
| `"+p`       | Paste from system clipboard  |
| `ggVG`      | Select all                   |
| `ggVG"+y`   | Copy entire file to clipboard|

## Search & Replace
| Key         | Action                        |
|-------------|------------------------------|
| `/pattern`  | Search forward               |
| `?pattern`  | Search backward              |
| `n`         | Next search result           |
| `N`         | Previous search result       |
| `:%s/foo/bar/g` | Replace all foo with bar |

---

# Your Custom Keybinds

## Compile/Run Shortcuts
| Key                | Action                        |
|--------------------|------------------------------|
| `<leader>r`        | `:!cargo run` (Run Rust)      |
| `<leader>c`        | `:!g++-15 -std=c++20 % -o %:r && ./%:r` (Compile & Run C++) |
| `<leader>p`        | `:!python3 %` (Run Python)    |

## Plugin Shortcuts

### NvimTree (File Explorer)
| Key                | Action                        |
|--------------------|------------------------------|
| `<leader>e`        | Toggle file tree              |

### Telescope (Fuzzy Finder)
| Key                | Action                        |
|--------------------|------------------------------|
| `<leader><leader>` | Find files                    |
| `<leader>fg`       | Live grep                     |
| `<leader>fb`       | List buffers                  |
| `<leader>fh`       | Help tags                     |

### LSP (Language Server Protocol)
| Key                | Action                        |
|--------------------|------------------------------|
| `gd`               | Go to definition              |
| `gD`               | Go to declaration             |
| `gi`               | Go to implementation          |
| `gr`               | List references               |
| `K`                | Hover documentation           |
| `<leader>rn`       | Rename symbol                 |
| `<leader>ca`       | Code action                   |
| `<leader>fd`       | Show line diagnostics         |
| `[d`               | Previous diagnostic           |
| `]d`               | Next diagnostic               |
| `<leader>f`        | Format buffer (normal/visual) |

---

# Clipboard (System)
| Key                | Action                        |
|--------------------|------------------------------|
| `"+y` (in visual)  | Copy selection to clipboard   |
| `ggVG"+y`          | Copy entire file to clipboard |
| `"+p`              | Paste from clipboard          |

---

# Tips
- `<leader>` is set to the spacebar (` `).
- To copy to system clipboard, Neovim must be compiled with clipboard support (`+clipboard`).  
  Check with `:version | grep clipboard`.
