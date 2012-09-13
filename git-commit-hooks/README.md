Various commit hooks

aptitude install pygmentize

To install:

	cp post-receive /var/lib/git/<repo>/hooks
	cd /var/lib/git/<repo>
	git config hooks.mailinglist '@gmail.com'
	git config hooks.defaultdomain 'gmail.com' 
	git config hooks.emailprefix '[GIT] '
    git config hooks.httplink 'http://<your host>/git?cs='
	echo "project name" > description
