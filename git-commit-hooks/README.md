This directory contains various Git commit hooks. At the moment, there is only
a post-receive hook that generates and emails HTML commit diffs.

# post-receive #
Sends HTML emails out after a commit has been successfully pushed to a shared
repository.

This script is an adaptation of the original Git contrib post-receive email
hook (as taken from the latest git-contrib on Ubuntu). However, this version
sends out an HTML email containing a colorized version of the git diff. 

Additionally, many of the changes/enhancements/ideas in this script were
adopted from a post on [chomperstomp.com](http://blog.chomperstomp.com/making-git-show-post-receive-e-mails-as-an-html-color-formatted-diff/).

Uses [pygmentize](http://pygments.org/docs/cmdline/), a command line Python
script that will generate HTML for different file syntaxes (C, PHP, diff, etc).
In this script, pygmentize generates "colorized" HTML from the git diff.

Unlike other HTML post-receive hooks available, this one does not use any extra
frameworks/templating languages to generate a simple HTML diff and email. 

## Screenshot ##

[![post-receive HTML commit email](https://github.com/kenshaw/shell-config/raw/master/git-commit-hooks/img/screenshot-th.png)](https://github.com/kenshaw/shell-config/raw/master/git-commit-hooks/img/screenshot.png)

## Configuration ##

In addition to configuration options available in the original post-receive
contrib script, there are a couple of other options that have been enabled:

 - *hooks.httplink* - Prefix to a web based tracker, ie 'http://<your host>/git?cs='
 - *hooks.defaultdomain* - Default domain to affix to the $REMOTE\_USER
   environment variable. Assumes this is being executed through HTTP
 - *hooks.pygmentizeoptions* - Options to pass to pygmentize -- for example, to
   set the pygmentize style to 'github' set this value to: 'style=github'

## Installation ##

Make sure that pygmentize is installed:

	sudo aptitude install -y python-pygments 

To install:

	cd ~/src/
	git clone https://github.com/kenshaw/shell-config.git
	ln -s ~/src/shell-config/git-commit-hooks/post-receive /var/lib/git/<repo>/hooks
	cd /var/lib/git/<repo>
	git config hooks.mailinglist '<some email address>'
	git config hooks.defaultdomain '<default domain address of the sender>' 
	git config hooks.emailprefix '[GIT] '
    git config hooks.httplink 'http://<your host>/git?cs='
	echo "<my project name>" > description

## TODO ##
- Get rid of pygmentize dependency
- Update post-receive hook to make diffs look better (ala Fisheye/Github) 
- Add JIRA integration to look up the authenticated user's fullname and/or use
  an alias file
