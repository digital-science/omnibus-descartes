## How do I install this thing?

You take the built package and install it on your platform using the
local package management.

## Configuring

Once installed - you can run:

`descartes-ctl reconfigure`

to setup descartes.

This is driven by a chef run.

If you want to change anything, you can either change the attributes
file (not recommended), or you could add an attributes file called
`secrets.rb`. By default we're ignoring that file in git.

The cookbooks live in the `files/descartes-cookbooks/descartes/`
directory.

## Process management

Use `descartes-ctl` to mange the processes, you can view their status,
logs, start and stop them. Running the command with no options will show
you everything you can do.

This is based on the
[omnibus-ctl](https://github.com/opscode/omnibus-ctl) software.
