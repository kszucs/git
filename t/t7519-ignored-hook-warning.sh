#!/bin/sh

test_description='ignored hook warning'

. ./test-lib.sh

# install hook that always succeeds
HOOKDIR="$(git rev-parse --git-dir)/hooks"
HOOK="$HOOKDIR/pre-commit"
mkdir -p "$HOOKDIR"
cat > "$HOOK" <<EOF
#!/bin/sh
exit 0
EOF

chmod +x "$HOOK"

test_expect_success 'no warning if proper hook' '

    if git commit -m "more" 2>&1 >/dev/null | grep hint
    then
	false
    else
	true
    fi

'

chmod -x "$HOOK"

test_expect_success POSIXPERM 'warning if hook not set as executable' '

    if git commit -m "more" 2>&1 >/dev/null | grep hint
    then
	true
    else
	false
    fi
'

test_expect_success 'no warning if advice.ignoredHook set to false' '

    git config advice.ignoredHook false &&
    if git commit -m "more" 2>&1 >/dev/null | grep hint
    then
	false
    else
	true
    fi
'

rm "$HOOK"

test_expect_success 'no warning if unset advice.ignoredHook and hook removed' '

    git config --unset advice.ignoredHook &&
    if git commit -m "more" 2>&1 >/dev/null | grep hint
    then
	false
    else
	true
    fi
'
git commit -m "more" 2>&1 >/dev/null


test_done