set -g fish_greeting ""
set -gx EDITOR helix
if status is-interactive
    # Commands to run in interactive sessions can go here
    zoxide init fish | source
    alias ls="eza --icons --sort=type"
    alias l="ls -l --sort=type -a"
    alias t="ls --tree"
    alias hx="helix"
end
set -gx SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"

# CUDA
set -gx PATH /opt/cuda/bin $PATH
set -gx LD_LIBRARY_PATH /opt/cuda/targets/x86_64-linux/lib $LD_LIBRARY_PATH

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
set --export PATH $HOME/.cargo/bin $PATH

# Added by LM Studio CLI (lms)
set -gx PATH $PATH $HOME/.lmstudio/bin
# End of LM Studio CLI section
starship init fish | source

# pnpm
set -gx PNPM_HOME "/home/akza/.local/share/pnpm"
if not string match -q -- "$PNPM_HOME/bin" $PATH
    set -gx PATH "$PNPM_HOME/bin" $PATH
end
# pnpm end

# Android SDK Environment Variables
set -gx ANDROID_HOME $HOME/Android/Sdk

# Add Android SDK binaries to PATH
fish_add_path $ANDROID_HOME/cmdline-tools/latest/bin
fish_add_path $ANDROID_HOME/platform-tools
fish_add_path $ANDROID_HOME/emulator
fish_add_path $ANDROID_HOME/tools
fish_add_path $ANDROID_HOME/tools/bin
fish_add_path ~/development/flutter/bin


# Added by Antigravity CLI installer
set -gx PATH "/home/akza/.local/bin" $PATH
