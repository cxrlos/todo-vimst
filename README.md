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

## 🚀 Usage

1. Set up your Todoist API token (if not provided in the config):
   ```
   :TodoVimstSetup
   ```

2. Start adding TODO comments in your code:
   ```
   // TODO: Refactor the flux capacitor #P1 #Project:TimeTravel
   # TODO: Buy plutonium #P2 #Shopping
   -- TODO: Calibrate speedometer to 88 mph #P3 #Maintenance
   % TODO: Write memoir: "My Life at 1.21 Gigawatts" #P4 #Personal
   ```

3. Create tasks from your TODOs:
   ```
   :TodoVimstCreateTasks
   ```

   Or let it happen automatically on save if you've set `create_on_save = true`!

## 🏷️ Priorities and Labels

- Use `#P1`, `#P2`, `#P3`, or `#P4` to set task priority (P1 is highest, P4 is lowest)
- Any other `#Tag` will be added as a label to your task
- No priority tag? No problem! It defaults to P4

## 🎭 Examples

```python
# TODO: Implement time circuits #P1 #Feature
# This will create a high-priority task with the "Feature" label

// TODO: Test flux dispersal #P3 #Testing #BackToTheFuture
// This creates a medium-priority task with "Testing" and "BackToTheFuture" labels

-- TODO: Document temporal experiments
-- This creates a low-priority task (default P4) with no labels
```

## 🐛 Troubleshooting

- Check your Todoist API token is correctly set
- Ensure you have an active internet connection
- Look for error messages in Neovim notifications
- Set `log_level = "debug"` for more detailed logging

## 🤝 Contributing

Contributions are welcome! Feel free to submit a Pull Request.

## 📜 License

Distributed under the MIT License. See `LICENSE` for more information.
