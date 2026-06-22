#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../utils.sh"

declare -r PROJECTS_DIR="$HOME/projects"

# Repos to clone on a fresh machine, as "<dir-name>|<owner/repo>".
# Existing directories are skipped; failures are non-fatal (a brand-new
# machine may not have SSH/gh auth yet — set it up and re-run).
declare -a REPOS=(
    "llm-wiki|lukasjuhas/llm-wiki"
    "claude-skills|lukasjuhas/claude-skills"   # after clone, run claude-skills/install.sh
    # "consumer-web|POSH-Group/consumer-web"
    # add more here as needed
)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

clone_repo() {

    local name="${1%%|*}"
    local slug="${1#*|}"
    local target="$PROJECTS_DIR/$name"
    local rc

    if [ -d "$target" ]; then
        print_success "$name (already present)"
        return 0
    fi

    # Prefer gh (works over HTTPS token even without SSH keys); fall back to SSH.
    if cmd_exists "gh" && gh auth status &> /dev/null; then
        gh repo clone "$slug" "$target" -- --quiet &> /dev/null
        rc=$?
    else
        git clone --quiet "git@github.com:$slug.git" "$target" &> /dev/null
        rc=$?
    fi

    if [ "$rc" -eq 0 ]; then
        print_success "$name (cloned)"
    else
        print_warning "$name (skipped — clone failed; set up SSH/gh auth and re-run)"
    fi

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    print_in_purple "\n • Clone repositories\n\n"

    mkdir -p "$PROJECTS_DIR"

    local repo
    for repo in "${REPOS[@]}"; do
        clone_repo "$repo"
    done

}

main
