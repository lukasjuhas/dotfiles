#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Home-server only: stay on 24/7, be reachable (SSH + Screen Sharing),
# SSH keys only, and share the d2 drive over SMB.

declare -r SSHD_DROP_IN="/etc/ssh/sshd_config.d/010-dotfiles.conf"
declare -r SHARE_NAME="d2"
declare -r SHARE_PATH="/Volumes/d2"
declare -r BACKUP_PATH="/Volumes/Backup-A"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

stay_on() {

    # Never sleep, restart after a power cut, wake for network access.

    execute \
        "sudo pmset -a sleep 0 disksleep 0 autorestart 1 womp 1" \
        "Power: never sleep, restart after power failure, wake on network"

}

enable_remote_access() {

    # Both need the terminal to have Full Disk Access (see `init.sh`).

    if sudo systemsetup -getremotelogin 2> /dev/null | grep -q "On"; then
        print_success "Remote Login (SSH)"
    else
        execute \
            "sudo systemsetup -setremotelogin on" \
            "Remote Login (SSH)" \
        || print_warning "Turn on manually: System Settings → General → Sharing → Remote Login"
    fi

    if sudo launchctl print system/com.apple.screensharing &> /dev/null; then
        print_success "Screen Sharing"
    else
        execute \
            "sudo launchctl enable system/com.apple.screensharing \
                && sudo launchctl bootstrap system /System/Library/LaunchDaemons/com.apple.screensharing.plist" \
            "Screen Sharing" \
        || print_warning "Turn on manually: System Settings → General → Sharing → Screen Sharing"
    fi

}

ssh_keys_only() {

    # Lockout guard: only disable passwords once this machine already
    # accepts at least one key (add one with `ssh-copy-id server@<host>`).

    if ! grep -q -E "^(ssh-|ecdsa-|sk-)" "$HOME/.ssh/authorized_keys" 2> /dev/null; then
        print_warning "SSH keys only (skipped — no keys in ~/.ssh/authorized_keys yet; run ssh-copy-id from a laptop, then re-run)"
        return 0
    fi

    if [ -f "$SSHD_DROP_IN" ]; then
        print_success "SSH keys only (password login off)"
        return 0
    fi

    ask_for_confirmation "Turn off SSH password login? Only machines whose key is in ~/.ssh/authorized_keys ($(grep -c -E "^(ssh-|ecdsa-|sk-)" "$HOME/.ssh/authorized_keys") keys) can SSH in afterwards. Screen Sharing is not affected."
    if ! answer_is_yes; then
        print_warning "SSH keys only (skipped)"
        return 0
    fi

    # Files in sshd_config.d are read in order and the first value wins,
    # so `010-` takes precedence over macOS's own `100-macos.conf`.
    # sshd is started per connection by launchd: no restart needed.

    execute \
        "printf '%s\n' \
            '# Managed by dotfiles (src/os/preferences/macos/server.sh).' \
            'PasswordAuthentication no' \
            'KbdInteractiveAuthentication no' \
            | sudo tee '$SSHD_DROP_IN' > /dev/null \
         && sudo sshd -t \
         || { sudo rm -f '$SSHD_DROP_IN'; false; }" \
        "SSH keys only (password login off)"

}

share_d2() {

    if [ ! -d "$SHARE_PATH" ]; then
        print_warning "File share '$SHARE_NAME' (skipped — $SHARE_PATH is not mounted)"
        return 0
    fi

    if sharing -l 2> /dev/null | grep -q -E "^name:[[:space:]]+$SHARE_NAME$"; then
        print_success "File share '$SHARE_NAME' ($SHARE_PATH)"
        return 0
    fi

    execute \
        "sudo sharing -a '$SHARE_PATH' -n '$SHARE_NAME' -S '$SHARE_NAME' -s 001" \
        "File share '$SHARE_NAME' ($SHARE_PATH, SMB)"

}

time_machine() {

    # Back up d2 (and the system) to Backup-A with Time Machine: hourly,
    # versioned, and still encrypted (the volume keeps its FileVault
    # encryption; it's not erased).

    if [ ! -d "$BACKUP_PATH" ] || [ ! -d "$SHARE_PATH" ]; then
        print_warning "Time Machine (skipped — $BACKUP_PATH and $SHARE_PATH must both be mounted)"
        return 0
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if tmutil destinationinfo 2> /dev/null | grep -q -E "^Mount Point[[:space:]]*:[[:space:]]*$BACKUP_PATH$"; then
        print_success "Time Machine destination ($BACKUP_PATH)"
    else

        local device=""
        device="$(diskutil info "$BACKUP_PATH" | awk -F': *' '/Device Identifier/ { print $2 }')"

        ask_for_confirmation "Use $BACKUP_PATH ($device) as the Time Machine disk? Its encryption stays; existing files aren't deleted."
        if ! answer_is_yes; then
            print_warning "Time Machine (skipped)"
            return 0
        fi

        execute \
            "sudo diskutil apfs changeVolumeRole '$device' T \
                && sudo tmutil setdestination '$BACKUP_PATH'" \
            "Time Machine destination ($BACKUP_PATH)" \
            || return 1

    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Time Machine skips external drives unless told otherwise.

    if tmutil isexcluded "$SHARE_PATH" 2> /dev/null | grep -q "\[Excluded\]"; then
        execute \
            "sudo tmutil removeexclusion -v '$SHARE_PATH'" \
            "Time Machine: include $SHARE_PATH"
    else
        print_success "Time Machine: include $SHARE_PATH"
    fi

    execute \
        "sudo tmutil enable" \
        "Time Machine: automatic backups on"

    # Kick off the first backup now instead of waiting for the hour.

    tmutil latestbackup &> /dev/null \
        || execute "tmutil startbackup --auto" "Time Machine: first backup started"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    print_in_purple "\n   Server\n\n"

    ask_for_sudo

    stay_on
    enable_remote_access
    ssh_keys_only
    share_d2
    time_machine

}

main
