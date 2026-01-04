#!/usr/bin/env bash
set -euo pipefail

########################################
# Redeploy script with fast mode
# Usage:
#   ./redeploy.sh                           # full build + restart
#   ./redeploy.sh fast                      # fast incremental (no restart)
#   ./redeploy.sh watch                     # watch (fast redeploy on change)
#   ./redeploy.sh <appName> fast            # specify app name + fast
#   ./redeploy.sh <appName> watch           # watch specific app name
#   MODE=watch ./redeploy.sh                # via env vars
########################################

# === CONFIG (defaults) ===
TOMCAT_BASE="${TOMCAT_BASE:-/opt/homebrew/Cellar/tomcat/11.0.10/libexec}"
ALT_WEBAPPS_DIR="${ALT_WEBAPPS_DIR:-/opt/homebrew/etc/tomcat/webapps}" # alt persistent dir

# Parse arguments (allow one or two positional, order agnostic for mode/app)
RAW_ARG1="${1:-}"; RAW_ARG2="${2:-}"
if [ -n "$RAW_ARG1" ]; then
  case "$RAW_ARG1" in
    fast|full|watch) MODE="$RAW_ARG1" ;;
    *) APP_NAME="$RAW_ARG1" ;;
  esac
fi
if [ -n "$RAW_ARG2" ]; then
  case "$RAW_ARG2" in
    fast|full|watch) MODE="$RAW_ARG2" ;;
    *) [ -n "$RAW_ARG2" ] && APP_NAME="$RAW_ARG2" ;;
  esac
fi

APP_NAME="${APP_NAME:-uninest}"
MODE="${MODE:-full}" # full | fast | watch

WAR_NAME="$APP_NAME.war"
TARGET_WAR="target/$WAR_NAME"
CATALINA_DIR="$TOMCAT_BASE/bin"

if [ -d "$ALT_WEBAPPS_DIR" ]; then DEPLOY_DIR="$ALT_WEBAPPS_DIR"; else DEPLOY_DIR="$TOMCAT_BASE/webapps"; fi
DEPLOY_WAR="$DEPLOY_DIR/$WAR_NAME"
EXPLODED_DIR="$DEPLOY_DIR/$APP_NAME"

if [ "$MODE" = "fast" ] || [ "$MODE" = "watch" ]; then
  echo "🚀 [FAST] Building (no clean) $WAR_NAME"
  mvn -q -DskipTests package
else
  echo "🚀 [1/4] Building (clean) $WAR_NAME"
  mvn -q clean package -DskipTests
fi

if [ "$MODE" = "watch" ]; then
  echo "👀 Watch mode: initial fast build & deploy, then watching for changes..."
fi

fast_deploy() {
  echo "⚡ [FAST] Syncing changes"
  if [ -d "$EXPLODED_DIR" ]; then
    BUILD_EXPLODED="target/$APP_NAME"
    if [ -d "$BUILD_EXPLODED" ]; then
      if command -v rsync >/dev/null 2>&1; then
        rsync -a --delete "$BUILD_EXPLODED/" "$EXPLODED_DIR/"
      else
        cp -R "$BUILD_EXPLODED/." "$EXPLODED_DIR/"
      fi
      [ -f "$EXPLODED_DIR/WEB-INF/web.xml" ] && touch "$EXPLODED_DIR/WEB-INF/web.xml"
      echo "✔ Synced"
    else
      echo "❗ No exploded build dir; copying WAR"
      cp "$TARGET_WAR" "$DEPLOY_WAR" && touch "$DEPLOY_WAR"
    fi
  else
    echo "ℹ First run created no exploded dir yet; copying WAR"
    cp "$TARGET_WAR" "$DEPLOY_WAR" && touch "$DEPLOY_WAR"
  fi
}

if [ "$MODE" = "fast" ]; then
  echo "⚡ Fast mode: incremental copy & context reload"
  fast_deploy
  echo "✅ Fast deploy complete. (No restart) Visit: http://localhost:8080/$APP_NAME/"
elif [ "$MODE" = "watch" ]; then
  fast_deploy
  echo "✅ Initial fast deploy complete. Watching... (Ctrl+C to stop)"
  WATCH_CMD=""
  if command -v fswatch >/dev/null 2>&1; then
    WATCH_CMD="fswatch -or src src/main/webapp |"
  elif command -v entr >/dev/null 2>&1; then
    # Generate file list for entr
    find src/main/java src/main/webapp -type f > .redeploy_watch_list
    WATCH_CMD="awk '{print}' .redeploy_watch_list | entr -r echo trigger |"
  fi
  if [ -n "$WATCH_CMD" ]; then
    echo "Using watch backend: $WATCH_CMD"
    sh -c "$WATCH_CMD while read -r _; do echo trigger; done" | while read -r _; do
      echo "--- Change detected at $(date +%H:%M:%S) ---"
      mvn -q -DskipTests package || { echo "Build failed."; continue; }
      fast_deploy
    done
  else
    echo "Polling fallback (install fswatch or entr for efficiency)"
    PREV_HASH=""
    while sleep 2; do
      CUR_HASH=$(find src/main/java src/main/webapp -type f -exec md5sum {} + 2>/dev/null | md5sum | cut -d' ' -f1 || echo 0)
      if [ "$CUR_HASH" != "$PREV_HASH" ]; then
        echo "--- Change detected at $(date +%H:%M:%S) ---"
        PREV_HASH="$CUR_HASH"
        mvn -q -DskipTests package || { echo "Build failed."; continue; }
        fast_deploy
      fi
    done
  fi
else
  if [ -d "$EXPLODED_DIR" ]; then
    echo "🗑️  [2/4] Removing exploded directory"
    rm -rf "$EXPLODED_DIR"
  fi
  echo "📦 [3/4] Deploying WAR to $DEPLOY_DIR"
  cp "$TARGET_WAR" "$DEPLOY_WAR"
  if pgrep -f "org.apache.catalina.startup.Bootstrap" >/dev/null; then
    echo "🔄 [4/4] Restarting Tomcat"
    bash "$CATALINA_DIR/shutdown.sh" >/dev/null 2>&1 || true
    sleep 2
    bash "$CATALINA_DIR/startup.sh"
  else
    echo "▶️  [4/4] Starting Tomcat"
    bash "$CATALINA_DIR/startup.sh"
  fi
  echo "✅ Done. Visit: http://localhost:8080/$APP_NAME/"
  echo "(Deployed -> $DEPLOY_WAR)"
fi