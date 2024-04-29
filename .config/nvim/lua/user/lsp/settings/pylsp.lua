return {
	settings = {
		pylsp = {
			plugins = {
				autopep8 = {
					enabled = false,
					args = {
						"--max_line_length = 79",
					},
				},
				flake8 = {
					enabled = true,
				},
				jedi_completion = {
					enabled = true,
				},
				jedi_definition = {
					enabled = true,
				},
				jedi_hover = {
					enabled = true,
				},
				jedi_signature_help = {
					enabled = true,
				},
				jedi_symbols = {
					enabled = true,
				},
				mccabe = {
					enabled = false,
				},
				pycodestyle = {
					enabled = false,
				},
				pydocstyle = {
					enabled = true,
				},
				pyflakes = {
					enabled = false,
				},
				pylint = {
					enabled = true,
					args = {
						"--max-line-length=79",
					},
				},
				rope_autoimport = {
					enabled = true,
				},
				rope_completion = {
					enabled = false,
				},
				yapf = {
					enabled = false,
				},
			},
		},
	},
}
