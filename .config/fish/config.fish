set -g fish_greeting ""
set -g EDITOR hx
if status is-interactive
    # Commands to run in interactive sessions can go here
    zoxide init fish | source
    alias ls="eza --icons --sort=type"
    alias l="ls -l --sort=type -a"
    alias t="ls --tree"
end
# android-studio
set -gx ANDROID_HOME ~/Android/Sdk
set -gx PATH $PATH $ANDROID_HOME/emulator $ANDROID_HOME/platform-tools ~/development/flutter/bin
# pnpm
set -gx PNPM_HOME "/home/akza/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /home/akza/.lmstudio/bin
# End of LM Studio CLI section

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
