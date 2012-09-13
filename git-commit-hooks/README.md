Various commit hooks

aptitude install pygmentize

To install:

	cp post-receive /var/lib/git/<repo>/hooks
	cd /var/lib/git/<repo>
	git config hooks.mailinglist '@gmail.com'
	git config hooks.envelopesender '@gmail.com' 
	git config hooks.emailprefix '[GIT] '
	echo "project name" > description
