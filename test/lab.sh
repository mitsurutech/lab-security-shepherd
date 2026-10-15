#!/usr/bin/env bash
# What the README promises, checked from inside the lab's own network: run by check.sh.
set -euo pipefail
: "${NET:?run through test/check.sh}"
probe() { docker run --rm --network "$NET" lab-check-probe bash -c "$1"; }
echo "- the databases were made for us and a student signs in and is offered the first challenge"
probe '
set -eu
j=/tmp/j; B=http://web:8080
curl -fs -c $j -b $j $B/login.jsp | grep -q "OWASP Security Shepherd - Login"
code=$(curl -s -o /dev/null -w "%{http_code}" -c $j -b $j -d "login=student&pwd=password" $B/login)
[ "$code" = 302 ] || { echo "sign in answered $code, expected 302" >&2; exit 1; }
page=$(curl -fs -c $j -b $j $B/index.jsp)
echo "$page" | grep -q "student&nbsp;" || { echo "not signed in as student" >&2; exit 1; }
tok=$(echo "$page" | grep -o "logout?csrfToken=[-0-9]*" | head -1 | cut -d= -f2)
menu=$(curl -fs -c $j -b $j -d "csrfToken=$tok" $B/refreshMenu)
echo "$menu" | grep -q "Get Next Challenge" || { echo "no Get Next Challenge in the menu" >&2; exit 1; }
id=$(echo "$menu" | grep -o "id=.[0-9a-f]\{40\}" | head -1 | grep -o "[0-9a-f]\{40\}")
first=$(curl -fs -c $j -b $j -d "moduleId=$id&csrfToken=$tok" $B/getModule)
echo "$first" | grep -q "^lessons/.*\.jsp" || { echo "the first step is not a lesson: $first" >&2; exit 1; }
curl -fs -c $j -b $j "$B/$first?csrfToken=$tok" | grep -q "Insecure Direct Object References" || { echo "the first lesson did not open" >&2; exit 1; }
echo "- the administrator signs in too"
curl -s -c $j -b $j -d "login=admin&pwd=password" $B/login -o /dev/null
curl -fs -c $j -b $j $B/index.jsp | grep -q "admin&nbsp;"
'
echo "  ok"
