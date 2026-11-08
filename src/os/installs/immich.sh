#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Immich (https://immich.app) on the home server, in OrbStack: a photo
# library next to Lightroom that shows the film scan archive on d2
# (read-only). Safe to re-run: it also applies a new pinned version.
#
# Data lives in ~/immich, never in this repo: `.env` (with a generated
# database password), `library/` (thumbnails, Immich's own nightly
# database backups) and `postgres/`, all on the internal SSD. Server
# settings come from this repo's immich-config.json.

declare -r SOURCE_DIR="$(cd ../../server/immich && pwd)"
declare -r COMPOSE_FILE="$SOURCE_DIR/docker-compose.yml"
declare -r IMMICH_DIR="$HOME/immich"
declare -r DOCKER="$HOME/.orbstack/bin/docker"
declare -r WEB_APP="$HOME/Applications/Immich.app"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

start_orbstack() {

    if "$DOCKER" info &> /dev/null; then
        print_success "OrbStack (running)"
        return 0
    fi

    open -a OrbStack 2> /dev/null

    for _ in $(seq 1 60); do
        "$DOCKER" info &> /dev/null && break
        sleep 2
    done

    if "$DOCKER" info &> /dev/null; then
        print_success "OrbStack (started)"
    else
        print_error "OrbStack isn't running — open it once on this Mac to finish its setup (choose Docker), then re-run"
        return 1
    fi

}

create_settings() {

    if [ -f "$IMMICH_DIR/.env" ]; then
        print_success "Immich environment (~/immich/.env)"
        return 0
    fi

    local timezone=""
    timezone="$(readlink /etc/localtime | sed 's|.*/zoneinfo/||')"

    mkdir -p "$IMMICH_DIR/library" "$IMMICH_DIR/postgres" \
        || return 1

    (
        umask 077
        cat > "$IMMICH_DIR/.env" << ENV_EOF
# Immich settings for this server, made by the dotfiles (src/os/installs/immich.sh).
# Not in the repo: it holds the database password. The version is pinned in the
# repo's docker-compose.yml.
UPLOAD_LOCATION=./library
DB_DATA_LOCATION=./postgres
TZ=${timezone:-Etc/UTC}
DB_PASSWORD=$(openssl rand -hex 24)
DB_USERNAME=postgres
DB_DATABASE_NAME=immich
ENV_EOF
    )

    print_result $? "Immich environment (~/immich/.env, new database password)"

}

install_config() {

    # Returns 0 if the settings changed (so a running Immich must restart).

    if cmp -s "$SOURCE_DIR/immich-config.json" "$IMMICH_DIR/immich-config.json"; then
        print_success "Immich server settings (immich-config.json)"
        return 1
    fi

    cp "$SOURCE_DIR/immich-config.json" "$IMMICH_DIR/immich-config.json"
    print_result $? "Immich server settings (immich-config.json, updated)"

}

start_immich() {

    local -r compose="'$DOCKER' compose --project-directory '$IMMICH_DIR' -f '$COMPOSE_FILE'"
    local settings_changed=false

    install_config && settings_changed=true

    execute \
        "$compose up -d --remove-orphans" \
        "Immich (docker compose up — the first run downloads a few GB)" \
        || return 1

    # Immich reads its settings file at startup.
    if $settings_changed; then
        execute "$compose restart immich-server" "Immich (restarted for the new settings)"
    fi

}

skip_live_database_in_backups() {

    # Time Machine copying Postgres's files mid-write can give an unusable
    # copy; Immich's own nightly dumps in library/backups are the backup.

    if tmutil isexcluded "$IMMICH_DIR/postgres" 2> /dev/null | grep -q "\[Excluded\]"; then
        print_success "Time Machine: skips Immich's live database (its nightly dumps are backed up)"
    else
        execute \
            "tmutil addexclusion '$IMMICH_DIR/postgres'" \
            "Time Machine: skips Immich's live database (its nightly dumps are backed up)"
    fi

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    print_in_purple "\n • Immich\n\n"

    if [ ! -d "/Applications/OrbStack.app" ]; then
        print_error "OrbStack is not installed (it comes from Brewfile.server)"
        return 1
    fi

    start_orbstack \
        && create_settings \
        && start_immich \
        || return 1

    skip_live_database_in_backups

    print_success "Immich: http://localhost:2283 here, http://$(scutil --get LocalHostName 2> /dev/null | tr '[:upper:]' '[:lower:]'):2283 over Tailscale"

    if [ ! -d "$WEB_APP" ]; then
        print_warning "Dock: open http://localhost:2283 in Safari → File → Add to Dock (name it Immich), then run \`just prefs\`"
    fi

}

main
