return {
	'wsdjeg/calendar.nvim',
	config = function()
		require('calendar').setup({
			mark_icon = '•',
			-- locale currently affects UI language only.
			locale = 'en-US', -- en-US | de-DE | en-GB | es-ES | fr-FR | it-IT | ja-JP | ko-KR | zh-CN | zh-TW | ru-RU
			show_adjacent_days = true,
			-- calendar.nvim support vim style keyboard navigation, hjkl.
			keymap = {
				next_month = 'L',
				previous_month = 'H',
				next_day = 'l',
				previous_day = 'h',
				next_week = 'j',
				previous_week = 'k',
				today = 't',
				close = 'q',
			},
			highlights = {
				current = 'Visual',
				today = 'Todo',
				mark = 'Todo',
				adjacent_days = 'Comment',
			},
			locales = {} -- See `## Locales`
		})
	end
}
