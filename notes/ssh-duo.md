# duo notes

```sh
$ yay -S duo_unix pam-ssh-agent

# setup duo pam config
$ cat /etc/duo/pam_duo.conf
[duo]
ikey = <ikey>
skey = <skey>
host = <apihost>
failmode = secure
pushinfo = yes
autopush = yes

# change sshd config to use pam and 2 challenges: public key followed by
# keyboard interactive
$ cat /etc/ssh/sshd_config.d/100-duo.conf
UsePAM yes
PermitRootLogin no
PubkeyAuthentication yes
PasswordAuthentication no
AuthenticationMethods publickey,keyboard-interactive
ChallengeResponseAuthentication yes
KbdInteractiveAuthentication yes
UseDNS no

# restart sshd
$ sudo systemctl restart sshd

# change pam config for sshd
$ cat /etc/pam.d/sshd
#%PAM-1.0

# bypass password (pam_unix.so) auth, require duo and disable system auth
auth required pam_duo.so

#auth      include   system-remote-login
account   include   system-remote-login
password  include   system-remote-login
session   include   system-remote-login

# change system-auth for system logins and sudo
# see notes at: https://www.imss.caltech.edu/services/security/duo-mfa/deploying-duo/deploying-duo-linux
#
# key is to change:
# "auth (.*) pam_unix.so (.*)" -->
#
# "auth requisite pam_unix.so \2"
# "auth \1 pam_duo.so"
$ cat /etc/pam.d/system-auth
#%PAM-1.0

auth       required                    pam_faillock.so      preauth
# Optionally use requisite above if you do not want to prompt for the password
# on locked accounts.
-auth      [success=2 default=ignore]  pam_systemd_home.so
auth       requisite     pam_unix.so          try_first_pass nullok
auth       [success=1 default=bad]     pam_duo.so
auth       [default=die]               pam_faillock.so      authfail
auth       optional                    pam_permit.so
auth       required                    pam_env.so
auth       required                    pam_faillock.so      authsucc
# If you drop the above call to pam_faillock.so the lock will be done also
# on non-consecutive authentication failures.

-account   [success=1 default=ignore]  pam_systemd_home.so
account    required                    pam_unix.so
account    optional                    pam_permit.so
account    required                    pam_time.so

-password  [success=1 default=ignore]  pam_systemd_home.so
password   required                    pam_unix.so          try_first_pass nullok shadow
password   optional                    pam_permit.so

-session   optional                    pam_systemd_home.so
session    required                    pam_limits.so
session    required                    pam_unix.so
session    optional                    pam_permit.so

# change pam config for sudo
$ cat /etc/pam.d/sudo
#%PAM-1.0

auth requisite pam_ssh_agent.so file=~/.ssh/authorized_keys
auth required pam_duo.so

#auth        include     system-auth
account     include     system-auth
session     include     system-auth
```
