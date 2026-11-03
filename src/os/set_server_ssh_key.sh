#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Laptops: make sure this machine can SSH into the home server with a
# key. Generates a dedicated key if needed, adds a `Host` entry to
# ~/.ssh/config, installs the public key on the server (asks for the
# server password once), then verifies key login works.
#
# Keys only ever live in ~/.ssh on each machine — never in this repo.

declare -r HOST="erebor"
declare -r SSH_USER="server"
declare -r KEY_FILE="$HOME/.ssh/$HOST"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

key_login_works() {
    ssh -o BatchMode=yes -o ConnectTimeout=5 "$SSH_USER@$HOST" true &> /dev/null
}

ensure_key() {

    if [ -f "$KEY_FILE" ]; then
        print_success "SSH key ($KEY_FILE)"
        return 0
    fi

    mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh"

    # Prompts for an optional passphrase (stored in the Keychain).
    ssh-keygen -t ed25519 -C "$(whoami)@$(scutil --get LocalHostName 2> /dev/null || hostname -s)" -f "$KEY_FILE"
    print_result $? "Generate SSH key ($KEY_FILE)"

}

ensure_ssh_config() {

    # `ssh -G` prints the effective config, so this also catches an
    # existing `Host` block that points at a different key.

    if ssh -G "$HOST" 2> /dev/null | grep -qx "identityfile $KEY_FILE"; then
        print_success "SSH config (Host $HOST)"
        return 0
    fi

    if grep -qE "^Host([[:space:]].*)?[[:space:]]$HOST([[:space:]]|$)" "$HOME/.ssh/config" 2> /dev/null; then
        print_warning "SSH config: ~/.ssh/config already has a 'Host $HOST' block — add 'IdentityFile $KEY_FILE' to it"
        return 1
    fi

    printf "\n%s\n" \
        "Host $HOST" \
        "  User $SSH_USER" \
        "  IdentityFile $KEY_FILE" \
        "  IdentitiesOnly yes" \
        "  AddKeysToAgent yes" \
        "  UseKeychain yes" >> "$HOME/.ssh/config"

    print_result $? "SSH config (add Host $HOST)"

}

install_key_on_server() {

    print_in_yellow "   Installing the key on $HOST (enter the server password once):\n"

    ssh-copy-id -i "$KEY_FILE.pub" "$SSH_USER@$HOST" &> /dev/null \
        && return 0

    # The server may already refuse passwords (keys only). Then the key
    # has to be added from a machine that's already allowed in.

    pbcopy < "$KEY_FILE.pub" 2> /dev/null
    print_warning "Could not install the key. Its public half is on your clipboard ($KEY_FILE.pub);"
    print_warning "append it to ~/.ssh/authorized_keys on $HOST from an already-allowed machine or via Screen Sharing, then re-run."
    return 1

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    print_in_purple "\n • Home server SSH key\n\n"

    if ! nc -z -G 3 "$HOST" 22 &> /dev/null; then
        print_warning "$HOST is not reachable (not home and Tailscale off?) — skipped; run \`just server-key\` later"
        return 0
    fi

    if key_login_works; then
        print_success "Key login to $SSH_USER@$HOST works"
        return 0
    fi

    ensure_key \
        && ensure_ssh_config \
        || return 1

    key_login_works \
        || install_key_on_server \
        || return 1

    key_login_works
    print_result $? "Key login to $SSH_USER@$HOST works"

}

main
