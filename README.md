Open the package file you downloaded and follow the prompts to install Go.
The package installs the Go distribution to /usr/local/go. The package adds the /usr/local/go/bin directory to your PATH environment variable by creating a /etc/paths.d/go file.

Add $HOME/go/bin (the default Go bin path) to your PATH environment variable to use tools installed via go install.
You can do this by adding the following line to your ~/.zshrc or ~/.bash_profile file:

export PATH="$PATH:$(go env GOPATH)/bin"

Restart any open terminal sessions for the changes to take effect.

Verify that you've installed Go by opening a new terminal session and typing the following command:
$ go version

Confirm that the command prints the installed version of Go.
