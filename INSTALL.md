## How do I install this thing?

You take the built package and install it on your platform using the
local package management.

# Pre-build secrets

There are various settings you will need to declare, they are the
graphite, oauth and session_secret. You need to go and change them in
the attributes file. You can either change the attributes
file (not recommended), or you could add an attributes file called
`secrets.rb`. By default we ignore the secrets file in git. In the
secrets file you then add entries like:

`override['descartes']['config']['graphite_url'] = "https://graphite.mycompany.com"`

The cookbooks live in the `files/descartes-cookbooks/descartes/`
directory.

## Configuring

Once installed - you can run:

`descartes-ctl reconfigure`

to setup descartes.

This is driven by a chef run.

## Process management

Use `descartes-ctl` to mange the processes, you can view their status,
logs, start and stop them. Running the command with no options will show
you everything you can do.

This is based on the
[omnibus-ctl](https://github.com/opscode/omnibus-ctl) software.

## Where are the files??

Everything is installed in `/opt/descartes`, with data being in
`/var/opt`.

## How do I get to the service?

By default the service is listening on `http://hostname:7600`. You'll
probably want to put a web server in front of that, and give it some
DNS. Currently we are not doing this in the package.
