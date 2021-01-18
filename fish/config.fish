. ~/.config/fish/color.fish
. ~/.config/fish/alias.fish
. ~/.config/fish/git.fish
. ~/.config/fish/key_binding.fish


set fish_color_cwd yellow

function fish_prompt
    set_color blue
    printf "%s " (date +%H:%M:%S)
    printf "\n"
    set last_status $status
    set_color cyan
    printf '%s' (whoami)
    tput setaf 8
    printf '@'
    tput setaf 172
    printf '%s ' (hostname)
    set_color $fish_color_cwd

    set -g fish_prompt_pwd_dir_length 0
    printf '%s' (prompt_pwd)
    set_color normal
    printf ' %s ' (scm_prompt_info)
    set_color normal
end

set -x NVM_DIR "~/.nvm"
test -s "$NVM_DIR/nvm.sh"  && . "$NVM_DIR/nvm.sh"  # This loads nvm

# cd with ls
function chpwd --on-variable PWD
    status --is-command-substitution; and return
    ll
end

# opencv library path
set -x LD_LIBRARY_PATH $LD_LIBRARY_PATH:/usr/local/lib
# cuda path
# export PATH="$PATH:/usr/local/cuda-8.0/"
# PATH="$PATH:/usr/local/cuda-8.0/bin"
# export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/cuda-8.0/lib64:/usr/local/cuda-8.0/lib64/stubs"

set -x PATH "$PATH:/usr/local/cuda-9.0/"
set -x PATH "$PATH:/usr/local/cuda-9.0/bin"
set -x LD_LIBRARY_PATH "$LD_LIBRARY_PATH:/usr/local/cuda-9.0/lib64:/usr/local/cuda-9.0/lib64/stubs"
set -x LD_LIBRARY_PATH "$LD_LIBRARY_PATH:/usr/lib/nvidia-384"

set -x TERM screen-256color

# auto launch tmux when new bash being created
# case $- in *i*)
# [ -z "$TMUX" ] && exec tmux

# esac
#PYTHONPATH
# set -x  PYTHONPATH="${PYTHONPATH}:/usr/local/lib/python2.7/site-packages://usr/local/google/home/chunyolin/pyvision/src"
# set -x  PYTHONPATH "$PYTHONPATH://usr/local/google/home/chunyolin/anaconda3/envs/AI/lib/python3.6/site-packages"
# set -x  PYTHONPATH "$PYTHONPATH://usr/local/google/home/chunyolin/anaconda3/lib/python3.6/site-packages"
# set -x  PYTHONPATH "$PYTHONPATH://usr/local/google/home/chunyolin/anaconda3/lib/python3.7/site-packages"

# added by Anaconda2 4.2.0 installer
set -e GNOME_KEYRING_CONTROL
set -x  CAFFE_ROOT //usr/local/google/home/chunyolin/work/caffe
# set -x  PATH "//usr/local/google/home/chunyolin/anaconda3/bin:$PATH"
# source //usr/local/google/home/chunyolin/anaconda3/etc/fish/conf.d/conda.fish

# riscv
set -x PATH "$PATH://usr/local/google/home/chunyolin/.local/riscv/bin"
set -x PATH "$PATH://usr/local/google/home/chunyolin/.local/riscv/riscv32-unknown-elf/bin"

set -x LLVM_CONFIG "/usr/lib/llvm-3.8/bin/llvm-config"

set -x  NVM_DIR "//usr/local/google/home/chunyolin/.nvm"

function nvm
    bass source ~/.nvm/nvm.sh --no-use ';' nvm $argv
end
set -x GOPATH ~/go
set -x PATH "$PATH:$GOPATH/bin"
set -x PATH "$PATH://usr/local/google/home/chunyolin/flutter/bin"

set -x NDK "//usr/local/google/home/chunyolin/android-ndk-r21d/"

set -x VULKAN_SDK "//usr/local/google/home/chunyolin/vulkan/1.2.148.1/x86_64/"
set -x PATH "$VULKAN_SDK/bin:$PATH"
set -x LD_LIBRARY_PATH "$VULKAN_SDK/lib:$LD_LIBRARY_PATH"
set -x VK_LAYER_PATH "$VULKAN_SDK/etc/vulkan/explicit_layer.d"

set -x PATH "$PATH:/usr/local/google/home/chunyolin/.local/bin"

set -x ANDROID_SDK_HOME "$HOME/Android/Sdk"
set -x ANDROID_NDK_HOME "$HOME/Android/Sdk/ndk/21.3.6528147"
set -x PATH "$ANDROID_SDK_HOME:$PATH"
set -x PATH "$ANDROID_NDK_HOME:$PATH"
set -x PATH "$ANDROID_SDK_HOME/build-tools/30.0.2:$PATH"
set -x PATH "$PATH":"$HOME/flutter/.pub-cache/bin"
set -x PATH "$PATH:/usr/lib/dart/bin"
if status --is-interactive
    gcertstatus --check_remaining=60m >/dev/null 2>&1
    or gcert -s
end
set -x M5_PATH "/usr/local/google/home/chunyolin/m5/"
