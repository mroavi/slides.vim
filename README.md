# slides.vim

**slides.vim** is a plugin that turns markdown files into presentable slides.
Best served with [vim-obsession](tpope/vim-obsession),
[hologram.nvim](edluffy/hologram.nvim), and
[limelight.vim](junegunn/limelight.vim).

This plugin uses the *argument list* (see `:h arglist`) to define the set of
slides for a given presentation. Each slide corresponds to one entry in the
argument list. Entries correspond to files with the `slide` extension.

The **example** directory contains a set of example slides which produce the
following output:

|                                             |                                                        |                                             |
| :---:                                       | :---:                                                  | :---:                                       |
| <img alt="" src="../media/01-title.png">    | <img src="../media/02-contents.png">                   | <img alt="" src="../media/03-syntax-1.png"> |
| <img alt="" src="../media/04-syntax-2.png"> | <img alt="" src="../media/05-syntax-3.png">            | <img alt="" src="../media/06-image.png">    |
| <img alt="" src="../media/07-code.png">     | <img alt="" src="../media/08-ascii-block-diagram.png"> | <img alt="" src="../media/09-end.png">      |

## Installation

Using [vim-plug](https://github.com/junegunn/vim-plug):

```vim
Plug 'mroavi/slides.vim'
```


Using [packer.nvim](https://github.com/wbthomason/packer.nvim):

```vim
use 'mroavi/slides.vim'
```

## Features

- WYSIWYG slides
- Markdown syntax
- Code block syntax highlighting
- Configurable *font size* and *cursor color* for the
  [Alacritty](https://github.com/alacritty/alacritty) and
  [Kitty](https://github.com/kovidgoyal/kitty) terminals.

## Commands

| Action     | Description              |
| :---       | :---                     |
| `:Present` | Toggle presentation mode |
| `j`        | Next slide               |
| `k`        | Previous slide           |

## Configuration

| Option                       | Description                            | Default     |
| ---                          | ---                                    | ---         |
| `g:slides_font_size`         | Font size in presentation mode         | `18`        |
| `g:slides_cursor_color`      | Cursor color in presentation mode      | `'#282828'` |
| `g:slides_cursor_text_color` | Cursor text color in presentation mode | `'#ffc24b'` |
