return {
	"hsteinshiromoto/todo.nvim",
	branch = "dev",
	config = function()
		require("todo-nvim").setup({
			keymaps = {
				add_todo = "<localleader>ta", -- Add new todo
				toggle_todo = "<localleader>td", -- Toggle completion (done)
				set_priority = "<localleader>tp", -- Set priority
				open_todo_list = "<localleader>tl", -- Open todo list
			},
		})
	end,
}
