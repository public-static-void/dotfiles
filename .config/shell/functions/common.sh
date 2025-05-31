# Download a .gitignore template for any language or framework from Toptal
gi() {
	curl -sL "https://www.toptal.com/developers/gitignore/api/$(
		IFS=,
		echo "$*"
	)"
}
