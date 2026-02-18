#!/bin/bash

EMAIL_OLD=
EMAIL=
NAME=
BRANCH=HEAD
FORCE=

OPTIND=1
while getopts "o:e:n:b:f" opt; do
case "$opt" in
  o) EMAIL_OLD=$OPTARG ;;
  e) EMAIL=$OPTARG ;;
  n) NAME=$OPTARG ;;
  b) BRANCH=$OPTARG ;;
  f) FORCE=1 ;;
esac
done

if [ -z "$EMAIL_OLD" ]; then
  EMAIL_OLD=kenshaw@gmail.com
fi
if [ -z "$EMAIL" ]; then
  EMAIL=$(git config user.email)
fi
if [ -z "$NAME" ]; then
  NAME=$(git config user.name)
fi

EXTRA=
if [ "$FORCE" = "1" ]; then
  EXTRA+="-f "
fi

FILTER=$(cat << END
if [ "\$GIT_AUTHOR_EMAIL" = "${EMAIL_OLD}" ]; then
  GIT_AUTHOR_NAME="${NAME}";
  GIT_AUTHOR_EMAIL="${EMAIL}";
  git commit-tree "\$@";
else
  git commit-tree "\$@";
fi
END
)

export FILTER_BRANCH_SQUELCH_WARNING=1
(set -x;
  git filter-branch --commit-filter "$FILTER" $EXTRA $BRANCH
)
