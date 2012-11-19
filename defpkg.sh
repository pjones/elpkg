#!/bin/sh

################################################################################
NAME=$1
ELFILE=$2
ELPKG=`dirname $0`
VERSION=`$ELPKG/version.sh $ELFILE`
DESC=`head -1 $ELFILE | sed -E 's/^.*-- *//'`
DEPS=`[ -r deps.el ] && cat deps.el`

###############################################################################
printf '(define-package "%s" "%s" "%s" %s)\n' \
  "$NAME" "$VERSION" "$DESC" "$DEPS"
