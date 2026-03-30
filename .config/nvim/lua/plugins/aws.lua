return {
	"jugarpeupv/aws.nvim",
	keys = {
		{ "<leader>wa", "<cmd>AwsPicker<cr>",                desc = "AWS service picker" },
		{ "<leader>wp", "<cmd>AwsPicker --profile prod<cr>", desc = "AWS picker (prod)" },
	},
	config = function()
		require("aws").setup({
			-- Default AWS CLI environment overrides applied to every command.
			-- These are used when no per-command --profile / --region flag is given.
			-- Authentication must already be handled by your environment.
			default_aws_profile = "sandbox",     -- sets AWS_PROFILE for every CLI call
			default_aws_region  = "ap-southeast-2", -- sets AWS_DEFAULT_REGION for every CLI call

			-- Status icons (requires a Nerd Font; replace with ASCII if needed)
			icons               = {
				stack       = "󰆼 ",
				complete    = "󰱑 ",
				failed      = "󰱞 ",
				in_progress = "󰔟 ",
				deleted     = "󰩺 ",
			},

			-- Buffer-local keymaps for each service.
			-- Set any key to false to disable it entirely.
			keymaps             = {
				cloudformation = {
					open_resources = "<CR>", -- open resources for stack under cursor
					open_events    = "E", -- open events for stack under cursor
					delete         = "dd", -- delete stack under cursor
					filter         = "F", -- prompt to filter stacks by name
					clear_filter   = "C", -- clear active filter
					refresh        = "R", -- re-fetch stacks from AWS
				},
				s3 = {
					open_bucket  = "<CR>", -- open bucket in oil.nvim (oil-s3://)
					empty        = "de", -- empty bucket under cursor (recursive rm)
					delete       = "dd", -- delete bucket under cursor (must be empty first)
					filter       = "F", -- prompt to filter buckets by name
					clear_filter = "C", -- clear active filter
					refresh      = "R", -- re-fetch buckets from AWS
				},
				cloudwatch = {
					open_streams = "<CR>", -- open log streams for group under cursor
					open_logs    = "<CR>", -- open log events for stream under cursor
					delete       = "dd", -- delete log group under cursor
					filter       = "F", -- prompt to filter log groups by name
					clear_filter = "C", -- clear active filter
					refresh      = "R", -- re-fetch from AWS
				},
				lambda = {
					open_detail  = "<CR>", -- open detail view for function under cursor
					open_logs    = "L", -- open CloudWatch log streams for function
					delete       = "dd", -- delete function under cursor
					filter       = "F", -- prompt to filter functions by name
					clear_filter = "C", -- clear active filter
					refresh      = "R", -- re-fetch from AWS
					detail_logs  = "L", -- open CW log streams from the detail buffer
				},
				acm = {
					open_detail    = "<CR>", -- open detail view for certificate under cursor
					delete         = "dd", -- delete certificate under cursor
					filter         = "F", -- prompt to filter certificates by domain
					clear_filter   = "C", -- clear active filter
					refresh        = "R", -- re-fetch from AWS
					detail_refresh = "R", -- refresh the detail view
				},
				secretsmanager = {
					open_detail    = "<CR>", -- open detail view for secret under cursor
					delete         = "dd", -- delete secret under cursor (no recovery window)
					filter         = "F", -- prompt to filter secrets by name
					clear_filter   = "C", -- clear active filter
					refresh        = "R", -- re-fetch from AWS
					detail_refresh = "R", -- refresh the detail view
					reveal         = "gS", -- toggle reveal/hide secret value in detail view
				},
				cloudfront = {
					open_detail       = "<CR>", -- open detail view for distribution under cursor
					invalidate        = "I", -- prompt to create a cache invalidation
					filter            = "F", -- prompt to filter distributions
					clear_filter      = "C", -- clear active filter
					refresh           = "R", -- re-fetch from AWS
					detail_refresh    = "R", -- refresh the detail view
					detail_invalidate = "I", -- create a cache invalidation from detail buffer
				},
				apigateway = {
					open_detail    = "<CR>", -- open detail view for REST API under cursor
					filter         = "F", -- prompt to filter APIs by name
					clear_filter   = "C", -- clear active filter
					refresh        = "R", -- re-fetch from AWS
					detail_refresh = "R", -- refresh the detail view
				},
				ecs = {
					open_detail    = "<CR>", -- open detail view for cluster under cursor
					filter         = "F", -- prompt to filter clusters by name
					clear_filter   = "C", -- clear active filter
					refresh        = "R", -- re-fetch from AWS
					detail_refresh = "R", -- refresh the detail view
				},
				iam = {
					open_detail    = "<CR>", -- open detail / sub-list for item under cursor
					filter         = "F", -- prompt to filter list by name
					clear_filter   = "C", -- clear active filter
					refresh        = "R", -- re-fetch from AWS
					detail_refresh = "R", -- refresh the detail view
					toggle_scope   = "T", -- toggle policy scope Local ↔ All (policies list only)
				},
				vpc = {
					open_detail    = "<CR>", -- open detail view for VPC under cursor
					open_sg        = "<CR>", -- open security group detail from VPC detail buffer
					filter         = "F", -- prompt to filter VPCs by name or ID
					clear_filter   = "C", -- clear active filter
					refresh        = "R", -- re-fetch from AWS
					detail_refresh = "R", -- refresh the detail view
				},
			},
		})
	end,
}
