<p align="center">
  <img src="https://upload.wikimedia.org/wikipedia/commons/6/6d/Todoist_logo.png" alt="Todoist Logo" width="200"/>
</p>

# 🚀 todo-vimst: Todoist Tasks from Your Vim Session!

Turn your TODOs into Todoist tasks without leaving Neovim! Because productivity should be as seamless as your editing flow.

## 🌟 Features

- 📝 Create Todoist tasks from TODO comments in your code
- 🎨 Support for multiple comment styles (`//`, `#`, `--`, `%`)
- 🏷️ Add priorities and custom labels with simple tags
- 🔄 Optional auto-creation of tasks on file save

## 🛠️ Installation

Using [packer.nvim](https://github.com/wbthomason/packer.nvim):

```lua
use {
  'yourusername/todo-vimst',
  requires = {'nvim-lua/plenary.nvim'},
  config = function()
    require('todo-vimst').setup({
      -- Your configuration options here
    })
  end
}
