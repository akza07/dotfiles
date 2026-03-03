set -g fish_greeting ""
set -g EDITOR helix
if status is-interactive
    # Commands to run in interactive sessions can go here
    zoxide init fish | source
    alias ls="eza --icons --sort=type"
    alias l="ls -l --sort=type -a"
    alias t="ls --tree"
    alias hx="helix"
end
# android-studio
set -gx ANDROID_HOME ~/Android/Sdk
set -gx PATH $PATH $ANDROID_HOME/emulator $ANDROID_HOME/platform-tools ~/development/flutter/bin
set -gx SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"

# pnpm
set -gx PNPM_HOME "/home/akza/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
