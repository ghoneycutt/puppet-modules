puppet-modules
==============

This repo contains a Puppetfile with modules that I use and support. All of my modules and their dependencies are tracked here. Recommend watching this repo to know when to update.

# Dependencies
This module utilizes [librarian-puppet-simple](https://github.com/bodepd/librarian-puppet-simple).

```
# gem install -V --no-ri --no-rdoc librarian-puppet-simple
```

# Usage

## Clone repo

into /var/local/ghoneycutt-modules on your puppet masters.

```
git clone https://github.com/ghoneycutt/puppet-modules.git /var/local/ghoneycutt-modules
```

## Add it to your modulepath

Prior to 3.6 this meant the following in your `puppet.conf`

```
modulepath = /etc/puppet/modules:/whatever/else:/var/local/ghoneycutt-modules
```

In 3.6 and later

```
environmentpath = $confdir/environments
basemodulepath = /var/local/ghoneycutt-modules/modules
```

## Get updates

```
cd /var/local/ghoneycutt-modules
git pull
./update_puppet_modules.sh
```

### Firewall issues with git protocol?

```
./update_puppet_modules.sh https
```

This will use sed to replace git: with https: and then revert the
Puppetfile after installation. Useful hack if you have firewall issues
that prevent git but allow https and do not want to fork the project
simply to change the protocol.
