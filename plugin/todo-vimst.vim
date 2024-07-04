if exists('g:loaded_todo_vimst')
  finish
endif
let g:loaded_todo_vimst = 1

command! -nargs=0 TodoVimstCreateTasks lua require('todo-vimst').create_tasks()
command! -nargs=0 TodoVimstSetup lua require('todo-vimst').setup_token()
