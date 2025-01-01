#!/bin/bash

# ============================================
# BACKFILL GITHUB CONTRIBUTION GRAPH
# Kompatibel: Git Bash (Windows)
# 5-12 commit/hari, semua hari terisi
# ============================================

set -e

echo "🚀 Mulai backfill contribution graph..."
echo ""

if ! command -v python &>/dev/null && ! command -v python3 &>/dev/null; then
  echo "❌ Python tidak ditemukan."
  exit 1
fi

PY=$(command -v python || command -v python3)

if [ -z "$(git config user.email)" ]; then
  echo "❌ Git belum dikonfigurasi."
  exit 1
fi

echo "📧 Git user: $(git config user.name) <$(git config user.email)>"
echo ""

$PY -c "
from datetime import date, timedelta
start = date(2025, 1, 1)
end = date.today()
d = start
while d <= end:
    print(d.isoformat() + ' ' + str(d.isoweekday()))
    d += timedelta(days=1)
" | tr -d '\r' > /tmp/dates.txt

total=$(wc -l < /tmp/dates.txt | tr -d ' ')

MESSAGES=(
  "chore(bot): 😂 auto commit"
  "chore(bot): 😱 auto commit"
  "chore(bot): 👿 auto commit"
  "chore(bot): 💩 auto commit"
  "chore(bot): 🙏 auto commit"
  "chore(bot): 🙈 auto commit"
  "chore(bot): 🐐 auto commit"
  "chore(bot): 🤖 auto commit"
  "chore(bot): 🟩 auto commit"
  "chore(bot): 👻 auto commit"
  "feat: update project"
  "fix: minor bug fix"
  "docs: update readme"
  "refactor: clean up code"
  "chore: maintenance"
)

count=0
day_num=0

echo "📅 Total hari: $total hari"
echo "⏳ Sedang proses, mohon tunggu..."
echo ""

while IFS=' ' read -r current dow; do
  current=$(echo "$current" | tr -d '\r\n ')
  dow=$(echo "$dow" | tr -d '\r\n ')

  [ -z "$current" ] && continue
  [ -z "$dow" ] && continue

  day_num=$((day_num + 1))

  if [ "$dow" -le 5 ]; then
    base=$((RANDOM % 8 + 5))
  else
    base=$((RANDOM % 5 + 5))
  fi

  burst=$((RANDOM % 5))
  if [ "$burst" -eq 0 ]; then
    base=$((base + RANDOM % 4 + 1))
  fi

  num_commits=$base

  HOURS=()
  for i in $(seq 1 $num_commits); do
    h=$((RANDOM % 16 + 7))
    HOURS+=($h)
  done
  IFS=$'\n' SORTED=($(sort -n <<< "${HOURS[*]}")); unset IFS

  for h in "${SORTED[@]}"; do
    minute=$((RANDOM % 60))
    second=$((RANDOM % 60))

    COMMIT_DATE=$(printf "%sT%02d:%02d:%02d" "$current" $h $minute $second)
    rand=$((RANDOM % ${#MESSAGES[@]}))
    msg="${MESSAGES[$rand]}"

    echo "$COMMIT_DATE" > LAST_UPDATED
    git add -A
    GIT_AUTHOR_DATE="$COMMIT_DATE" GIT_COMMITTER_DATE="$COMMIT_DATE" \
      git commit -m "$msg" --quiet

    count=$((count + 1))
  done

  # Update progress di baris yang sama
  echo -ne "  ⏳ $current | hari ke-$day_num/$total | total $count commits\r"

done < /tmp/dates.txt

rm -f /tmp/dates.txt

echo ""
echo ""
echo "========================================="
echo "✅ SELESAI!"
echo "📊 Total commit : $count"
echo "📅 Periode      : 2025-01-01 s/d $(date '+%Y-%m-%d')"
echo "========================================="
echo ""
echo "Sekarang jalankan:"
echo "   git push origin main --force"