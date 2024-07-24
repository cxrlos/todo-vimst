<p align="center">
  <img src="https://upload.wikimedia.org/wikipedia/commons/6/6d/Todoist_logo.png" alt="Todoist Logo" width="200"/>
</p>

# 🚀 todo-vimst: Todoist Tasks from Your Vim Session!

Turn your TODOs into Todoist tasks without leaving Neovim! Because productivity should be as seamless as your editing flow.

## 🌟 Features

- 📝 Create Todoist tasks from TODO comments in your code
- 🎨 Support for multiple comment styles based on file type
- 🏷️ Add priorities and custom labels with simple tags
- 🔄 Optional auto-creation of tasks on file save
- 🚦 Configurable logging levels for debugging
- 🛡️ Robust error handling and user-friendly messages

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
```

## ⚙️ Configuration

Set up todo-vimst with your preferred options:

```lua
require('todo-vimst').setup({
  token = "your_todoist_api_token", -- Optional: Set token directly
  project_id = "your_project_id",   -- Optional: Set default project ID
  log_level = "info",               -- Optional: Set log level (debug, info, warn, error)
  create_on_save = false,           -- Optional: Create tasks automatically on file save
})
```

## 🔐 Token Security

todo-vimst stores your Todoist API token locally using a basic encryption method. While this provides a layer of security, it is not foolproof. Please be aware of the following:

- The token is stored in an encrypted format in your home directory.
- The encryption used is a simple XOR cipher, which is not highly secure.
- For maximum security, consider using a password manager or environment variables instead.

**Disclaimer**: The current token storage method is basic and should not be considered fully secure. Use at your own discretion.

## 🚀 Usage

1. Set up your Todoist API token (if not provided in the config):
   ```
   :TodoVimstSetup
   ```

2. Start adding TODO comments in your code:
   ```
   // TODO: Optimize tire management strategy P1 @RacePrep
   # TODO: Analyze competitor's lap times P2 @Strategy
   -- TODO: Calibrate DRS activation points P3 @Setup
   % TODO: Write post-race report P4 @Admin
   ```

3. Create tasks from your TODOs:
   ```
   :TodoVimstCreateTasks
   ```
   Or let it happen automatically on save if you've set `create_on_save = true`!

## 🏷️ Priorities and Labels

- Use `P1`, `P2`, `P3`, or `P4` to set task priority (P1 is highest, P4 is lowest). No priority set? No problem! It defaults to P4
- Any element `#Tag` will be added as a label to your task

## 🎭 Examples

```python
# TODO: Implement traction control system P1 @Feature
# This will create a high-priority task with the "Feature" label

// TODO: Test aerodynamics in wind tunnel P3 @Testing @MP4/4
// This creates a medium-priority task with "Testing" and "MP4/4" labels

-- TODO: Document tire degradation analysis
-- This creates a low-priority task (default P4) with no labels

'''
TODO: This is a multi-line task
that spans multiple lines
'''
# This creates a single task with the content "This is a multi-line task that spans multiple lines"
```

todo-vimst now supports file type-specific comment parsing, ensuring that the correct comment syntax is used for each programming language. It recognizes common file types such as Python, C, Java, JavaScript, Lua, and more.

## 🐛 Troubleshooting

- Check your Todoist API token is correctly set
- Ensure you have an active internet connection
- Look for error messages in Neovim notifications
- Set `log_level = "debug"` for more detailed logging

## 🤝 Contributing

Contributions are welcome! Feel free to submit a Pull Request.

## 📜 License

Distributed under the MIT License. See `LICENSE` for more information.
