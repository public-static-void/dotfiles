# Set PYTHONPATH in .envrc for mypy and pylint
set_pythonpath() {
	local version
	version=$(python --version | awk -F'[ .]' '{print $2"."$3}')
	local pythonpath="\$PYTHONPATH:\$PWD/.venv/lib/python$version/site-packages/"
	if [ -f .envrc ]; then
		sed -i.bak "/^export PYTHONPATH=/c\export PYTHONPATH=$pythonpath" .envrc
		echo "PYTHONPATH updated in existing .envrc file."
	else
		echo "export PYTHONPATH=$pythonpath" >>.envrc
		echo ".envrc created with PYTHONPATH: $pythonpath"
	fi
	command -v direnv >/dev/null 2>&1 && direnv allow
}

# Create and activate a Python virtual environment in .venv
create_venv() {
	if [ -z "$VIRTUAL_ENV" ]; then
		if python -m venv .venv; then
			if [ -f .venv/bin/activate ]; then
				# shellcheck source=/dev/null
				. .venv/bin/activate
				echo "Virtual environment created and activated."
			else
				echo "Error: .venv/bin/activate not found."
				return 1
			fi
		else
			echo "Error: Failed to create the virtual environment."
			return 1
		fi
	else
		echo "Error: A virtual environment is already activated in '$VIRTUAL_ENV'."
		return 1
	fi
}

# Initialize Poetry for an existing Python project
init_poetry() {
	poetry config virtualenvs.prefer-active-python true
	poetry config virtualenvs.in-project false
	if [ -f .venv/bin/activate ]; then
		# shellcheck source=/dev/null
		. .venv/bin/activate
	else
		echo "Error: .venv/bin/activate not found."
		return 1
	fi
	poetry init -n
	python -m pip install --upgrade pip
}

# Create a new Python project with Poetry and direnv integration
init_pyproj() {
	if [ -z "$1" ]; then
		read -r -p "Please enter a directory name: " DIR_NAME
	else
		DIR_NAME="$1"
	fi
	DIR_NAME=$(echo "$DIR_NAME" | xargs)
	if mkdir "$DIR_NAME"; then
		echo "Directory '$DIR_NAME' created successfully."
	else
		echo "Error: Directory '$DIR_NAME' already exists or could not be created."
		return 1
	fi
	poetry config virtualenvs.prefer-active-python true
	poetry config virtualenvs.in-project true
	poetry new "$DIR_NAME"
	cd "$DIR_NAME" || return
	set_pythonpath
	poetry install --no-root
	if [ -f .venv/bin/activate ]; then
		# shellcheck source=/dev/null
		. .venv/bin/activate
	else
		echo "Error: .venv/bin/activate not found."
		return 1
	fi
	python -m pip install --upgrade pip
	gi python >.gitignore
	gi direnv >>.gitignore
	git init
}
