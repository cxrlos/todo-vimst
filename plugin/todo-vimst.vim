if exists('g:loaded_todo_vimst')
  finish
endif
let g:loaded_todo_vimst = 1

command! -nargs=0 TodoVimstCreateTasks lua require('todo-vimst').create_tasks()
command! -nargs=0 TodoVimstSetup lua vim.ui.input({prompt = "Enter Todoist API token: "}, function(token) require('todo-vimst').setup({token = token}) end)
