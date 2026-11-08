#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Immich (https://immich.app) on the home server, in OrbStack: a photo
# library next to Lightroom that shows the film scan archive on d2
# (read-only). Safe to re-run: it also applies a new pinned version.
#
# Settings and data live in ~/immich, never in this repo: `.env` (with a
# generated database password), `library/` (thumbnails, Immich's own
# database backups) and `postgres/`, all on the internal SSD.

declare -r COMPOSE_FILE="$(cd ../../server/immich && pwd)/docker-compose.yml"
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
        print_success "Immich settings (~/immich/.env)"
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

    print_result $? "Immich settings (~/immich/.env, new database password)"

}

start_immich() {

    execute \
        "'$DOCKER' compose --project-directory '$IMMICH_DIR' -f '$COMPOSE_FILE' up -d --remove-orphans" \
        "Immich (docker compose up — the first run downloads a few GB)"

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

    print_success "Immich: http://localhost:2283 here, http://$(scutil --get LocalHostName 2> /dev/null | tr '[:upper:]' '[:lower:]'):2283 over Tailscale"

    if [ ! -d "$WEB_APP" ]; then
        print_warning "Dock: open http://localhost:2283 in Safari → File → Add to Dock (name it Immich), then run \`just prefs\`"
    fi

}

main
