<<com
/* ====== bash_aliases by Aston Li ====== */

# Single versus double quotation marks in aliases

  The choice of single or double quotation marks is significant in the alias
  syntax when the alias includes variables. If you enclose value within double
  quotation marks, any variables that appear in value are expanded when the
  alias is created. If you enclose value within single quotation marks,
  variables are not expanded until the alias is used. The following example
  illustrates the difference.
com

shopt -s autocd # change directory without `cd` command

alias c='cd'
alias ex='exit'
alias fdiff='find ./ -maxdepth 1 -type f -name \*.diff'
alias ls='ls --color=auto --group-directories-first'
alias lsl='ls -l'
alias ll='ls -al'
alias lll='ls -al --color | less -R' # output with color
alias minicom='minicom -w' # line-wrap
alias retab='expand -t 4 ${1}' # convert tabs to 4 spaces
alias cpu_order='lscpu | grep Endian'

# list all files exclude ...
alias tree_a='tree -I ".git*|.svn|Debug|*.o|*.d" -a'
# list only source and header files
alias tree_s='tree -P "*.c|*.h"'
# export the output in HTML format
alias tree_to_html='tree -I ".git*|.svn|Debug|*.o|*.d|tree.*" -a -H ./ --dirsfirst -s -h > tree.html; firefox tree.html &'
# export the output in ASCII format
alias tree_to_ascii='tree -I ".git*|.svn|Debug|*.o|*.d|tree.*" -a --charset=ascii --dirsfirst -s -h > tree.ascii; xdg-open tree.ascii'

alias open_file='xdg-open' # opens a file or URL in the user's preferred application
alias pdf='evince' # opens a PDF file

# dos2unix
alias d2u_ch='find . -type f \( -name "*.c" -o -name "*.h" \) -print0 | xargs -0 dos2unix'
# Will recursively find all files inside current directory and call for these files dos2unix command.
alias d2u_all='find . -type f -print0 | xargs -0 dos2unix'

alias hdc='hexdump -C'
# print only the hex values from hexdump without line numbers or ASCII table
hdn() {
    hexdump -e '16/1 "%02x " "\n"' ${1}
}

# hexdump display as hexedit style
hds() {
    if [ $# -eq 1 ]; then
        hexdump -v -e '"%08.8_ax  "' \
                   -e ' 4/1 "%02x " "  " 4/1 "%02x " "  "  4/1 "%02x " "  " 4/1 "%02x "  ' \
                   -e '" |" 16/1 "%_p" "|\n"' ${1}
    else
        echo "invalid input"
    fi
}

# create a hex dump of file containing only the hex characters without spaces
print_hex() {
    if [ $# -eq 1 ]; then
        xxd -ps ${1} | tr -d '\n' # all on a single line

    elif [ $# -eq 2 ]; then
        if [ "${1}" == "-r" ]; then
            # To reverse the process: xxd -r -ps hex_file
            # (it is ok with or without newlines)
            xxd -r -ps ${2}
        else
            echo "invalid input"
        fi
    else
        echo "invalid input"
    fi

}

### ================================================================================
# SHA
# shasum -a 256 -b ${1}
# sha256sum -b --tag ${1}

### === OpenSSL example ===
<<com
openssl rsautl -help

# Generate a 2048 bit RSA Key
openssl genrsa -out rsa.private
# Export the RSA Public Key to a File
openssl rsa -in rsa.private -out rsa.public -pubout -outform PEM

# Encrypt with public key and decrypt with private key
openssl rsautl -encrypt -inkey rsa.public -pubin -in foo -out foo.encrypt
openssl rsautl -decrypt -inkey rsa.private -in foo.encrypt -out foo.decrypt

# Encrypt with private key and decrypt with public key
openssl rsautl -sign -inkey rsa.private -in foo -out foo.encrypt
openssl rsautl -verify -inkey rsa.public -pubin -in foo.encrypt -out foo.decrypt

com
### ================================================================================
### === git ===
alias g.a='git add'
alias g.c='git commit'
alias g.p='git pull'
alias g.pr='git pull --rebase'
alias g.d='git diff --no-ext-diff --binary' # Disallow external diff drivers.
alias g.ds='g.d --staged' # show changes that have been staged(--staged is a synonym for --cached)
alias g.df='g.d FETCH_HEAD'
alias g.xd='git diff --ext-diff --binary' # Allow an external diff drivers.
alias g.meld='git difftool -t meld'
alias g.b='git branch -v'
alias g.bd='git branch -d' # delete branch locally
alias g.r='git revert'
alias g.rb='git rebase'
alias g.rs='git reset'
alias g.rslast='git reset HEAD~1' # Undoing the Last Commit
alias g.s='git status'
alias g.co='git checkout'
alias g.f='git fetch'

alias g.url='git remote -v'
alias g.curl='git config --get remote.origin.url'

git_config() {
    git config --global user.name "asli18"
    git config --global user.email "63712526+asli18@users.noreply.github.com"
    git config -l --show-origin
    git config -l --show-scope
}

# gitk - The Git repository browser
alias g.k='gitk'
alias g.kf='gitk FETCH_HEAD'

# list all file in branch, ${1}: <commit> or <branch>
alias g.ls='git ls-tree -r HEAD~1 --name-only ${1}'

# git log option
alias g.l='git log'
alias g.lg='git log --graph'
alias g.lgn='g.lg --name-only'
alias g.lgns='g.lg --name-status'
alias g.lgnsf='g.lg --name-status FETCH_HEAD'
alias g.lgs='g.lg --stat'
alias g.lgp='g.lg --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s \
                                  %Cgreen(%cr) %C(bold blue)<%an>%Creset" \
                  --abbrev-commit'

alias g.lnh='git log --name-status HEAD^..HEAD'
alias g.sum='git show --summary'

# generate a git diff file of the latast commit and use commit ID as file name.
git_gen_diff() {
    local head_sha_id=$(git show --summary | head -1 | awk '{ print substr($2, 1, 8) }')
    local file_path=$(pwd)
    local git_dir_top=$(echo $(git rev-parse --show-toplevel) | sed 's|.*/||')
    local file_name="${git_dir_top}_${head_sha_id}.diff"

    if [ -f "${file_name}" ]; then
        echo -e "File ${LRED}${file_name}${NC} exists, abort generate process"
        return 1
    fi

    echo -e "Generate ${YELLOW}${file_path}/${BOLD}${LRED}${file_name}${NC}"
    g.d > "${file_name}"
}

# git apply patch flow
git_ap() {
    git apply --stat ${1}
    if [ $? -ne 0 ]; then
        echo "Apply status FAIL."
        return 1;
    fi
    echo "Apply status PASS."

    git apply --check ${1}
    if [ $? -ne 0 ]; then
        echo "Apply check FAIL."
        return 1;
    fi
    echo "Apply check PASS."

    git apply ${1}
}

# rename git branch locally and remotely
git_branch_rename() {
    if [ $# -ne 2 ]; then
        echo "Invalid input"
    else
        local old=${1}
        local new=${2}

        echo -e "Change Branch Name ${GREEN}${old}${NC} to ${GREEN}${new}${NC}"

        git branch -m ${old} ${new} # Rename branch locally

        if [ $? -ne 0 ]; then
            return 1;
        fi

        git push origin :${old} # Delete the old branch
        # Push the new branch, set local branch to track the new remote
        git push --set-upstream origin ${new}
    fi
}

### === svn ===
alias s.a='svn add'
alias s.c='svn commit'
alias s.d='svn diff'
alias s.dm='svn diff --diff-cmd="meld"'
alias s.i='svn info'
alias s.r='svn revert'
alias s.s='svn st | grep -v ^?'
alias s.u='svn up'
alias s.l='svn log -v | less'
alias svnadd='svn st |grep ^? | cut -b 9- | xargs svn add'
alias svndiff='LC_ALL=C svn diff --diff-cmd meld'
alias svnplog='svn propedit --revprop svn:log -r'
alias svnrevert='svn revert -R *'
alias svnrevertM='svn st | grep ^M | cut -b 9- | xargs svn revert'
alias svnst='svn st | grep -v ^?'
alias rmnonsvn='svn st |grep ^? | cut -b 9- | xargs rm -rf'
alias rmsvn='find . -name .svn -print0 | xargs -0 rm -rf'

### ================================================================================
alias v='vim'
alias vi='vim'
alias g='gvim'

alias shutdn='sudo shutdown -h 0'
alias p0='patch -p0 -i'
alias ssh='ssh -X'

alias mk='make'
alias mkcl='make clean'
alias mkcla='make clean all'
alias mkd='make distclean'
alias mkm='make menuconfig'

cleanup() {
    find . -name "Debug" | xargs rm -rf;
    find . -name "output" | xargs rm -rf;
    find . -type f \( -name "*.o" -o -name "*.d" \) | xargs rm -rf;
}

alias ice1='monice -d ice1:e -v4kec'
alias ice2='monice -d ice2:e -v4kec'
alias relfgdb='rlwrap -a -r -pyellow mips-elf-gdb'
alias rice1='rlwrap -a -r -pyellow monice -d ice1:e -v4kec'
alias rice2='rlwrap -a -r -pyellow monice -d ice2:e -v4kec'
alias sq3='rlwrap -a -r -pyellow -z pipeto sqlite3'
### ================================================================================

### === Process operations ===

# killall requires the precise process name, whereas pkill & pgrep do basic pattern matching

# list PID
alias pg='pgrep -f ${1}'
alias pgl='pgrep -f -l ${1}' # -l print PID and process name
alias fpid='top -b -n 1 | grep ${1}' # ${1}: process name
alias fpid_num='top -b -n 1 | grep -c ${1}' # print counting number of basic pattern matches

alias psg='ps ax | grep ${1}' # ${1}: process name

alias kl='kill -9 ${1}' # ${1}: PID
alias kal='killall ${1}' # ${1}: process name
alias pk='pkill -f ${1}' # ${1}: process name

### === Finding files which contain a certain string ===
alias ff='find . -name "*.[ch]" -print0 | xargs -0 grep -rn -E -C 0 --color ${1}'
alias ffa='find . -type f -print0 | xargs -0 grep -rn -E -C 0 --color ${1}'

alias gn='grep -rn -E --color ${1}'
alias gnc='grep -rn -i --include \*.c ${1}'
alias gnh='grep -rn -i --include \*.h ${1}'
alias gnch='grep -rn -i --include \*.c --include \*.h ${1}'
alias gnsp='grep -rn -i --include \*.sh --include \*.py ${1}'

alias fch='find . -type f \( -name "*.c" -o -name "*.h" \)'
alias fsp='find . -type f \( -name "*.sh" -o -name "*.py" \)'

# rg, -S smart case, -H display file path
#     -C context <NUM> Show NUM lines before and after each match.
alias rg='rg -H --no-heading'
alias rgn='rg -H -C ${1} --no-heading ${2}'
alias rgs='rg -S -H --no-heading ${1}'

alias rgc='rg -t c -H --no-heading ${1}'
alias rgh='rg -t h -H --no-heading ${1}'
alias rgs='rg -S -H --no-heading'
alias rgcs='rg -t c -S -H --no-heading'
alias rghs='rg -t h -S -H --no-heading'
alias rghid='rg --hidden -e ${1}'

alias frgc='find . -name "*.[c]" | xargs rg -H --no-heading ${1}'
alias frgh='find . -name "*.[h]" | xargs rg -H --no-heading ${1}'
alias frgs='find . -name "*.[ch]" | xargs rg -S -H --no-heading'
alias frgcs='find . -name "*.[c]" | xargs rg -S -H --no-heading'
alias frghs='find . -name "*.[h]" | xargs rg -S -H --no-heading'
### ================================================================================

# recursively find all files in current and subfolders based on wildcard matching
# find . -name "foo*"
# note that the "foo*" is in quotes so the shell doesn't expand it before passing it to find.
# if you just did find . foo*, the foo* would be expanded AND THEN passed to find.
# worth stressing that " " is very necessary for recursive searching
# Without the quotes, the shell interprets foo* as a glob pattern.
# fn "*.c"
alias fn='find . -name'

### ================================================================================
alias tags='gtags -v; ctags -R *'
alias path='realpath' # absolute path to the file

# print size
alias du_c='du -sc *' # print total size of current directory(folder)
alias du_f='du -s' # print total size of specific folder
alias du_d='du --max-depth=1' # print total size of a directory(folder)
# human-readable
alias du_hc='du -hsc *' # print total size of current directory(folder)
alias du_hf='du -hs' # print total size of specific folder
alias du_hd='du -h --max-depth=1' # print total size of a directory(folder)

alias sshpi166='ssh -X pi@10.8.30.166'
### ================================================================================
# compression
# 7z a file.7z file folder ...
alias 7z_c='7z a'

# decompression
# 7z x file.7z
# 7z x file.7z -o/out_path
alias 7z_d='7z x'

### ================================================================================

export GIT_EDITOR=vim
export SVN_EDITOR=vim

# "How do I extract a single chunk of bytes from within a file?"
#dd skip=0 count=16384 bs=1 if=input.bin of=output.bin

#hexdump -C test.bin | less
#diff or cmp
#vbindiff or vimdiff

# bash turn on debug mode
#set -xv
#set -x : Display commands and their arguments as they are executed.
#set -v : Display shell input lines as they are read.

# bash turn off debug mode
#set +xv

### ================================================================================
reload_bash() {
    # remove functions
    unset -f sys_update
    unset -f sshpi
    unset -f arm
    unset -f andes

    # remove all defined aliases
    unalias -a
    source ~/.bashrc
    source ~/.bash_aliases
}

# display the attributes and value of each NAME
# print out just the body of the function
# -- string
# -i integer
# -a arrays
# -A map(associative arrays)
alias var.attr='declare -p ${1}'

typec() {
    if [ $# -eq 1 ]; then
        type ${1} | sed '1,3d;$d'
    fi
}

sys_update() {
    sudo apt-get update
    sudo apt-get upgrade
    sudo apt autoremove && sudo apt clean
}

rmtags() {
    if [ -f "./tags" ]; then
        rm tags
    fi
    if [ -f "./GTAGS" ]; then
        rm GTAGS
    fi
    if [ -f "./GRTAGS" ]; then
        rm GRTAGS
    fi
    if [ -f "./GPATH" ]; then
        rm GPATH
    fi
}

# do math on the command line
# set 4 digits after decimal point
# set ibase last, it would change the base of input value including settings.
math() {
    echo "scale=4; obase=10; ibase=10; ${1}" | bc -l
    echo -ne "0x"
    echo "scale=0; obase=16; ibase=10; ${1}" | bc -l
}

# The bc must use upper case letters for hex
# (Note: They must be capitals. Lower case letters are variable names.)
math16() {
    local res=$(echo "scale=0; obase=10; ibase=16; ${1}" | bc -l)

    if [ -z ${res} ]; then
        echo "bc only support UPPER CASE hex digits"
        return 1
    fi

    echo "${res}"
    echo -ne "0x"
    echo "scale=0; obase=16; ibase=16; ${1}" | bc -l
}

function sshpi {
    if [ $# -ne 2 ]; then
        echo "Invalid input"
    else
        echo -e "ssh to host ${GREEN}pi@10.8.${1}.${2}${NC}"
        ssh -X pi@10.8.${1}.${2};
    fi
}

### ================================================================================
# List of Recently Modified Files
function lst { ls -alrt --color ${1} | tail -n 10; }

file_changed() {
    # find all files modified in the last ${1} days
    # '-' before ${1} means anything changed ${1} days or less ago.
    # '+' before ${1} means anything changed at least ${1} days ago.
    # -mtime means days
    # -mmin  means mins

    if [ $# -eq 2 ]; then
        find ${2} -type f -mtime -${1} -exec ls -altr {} +;
        #find ${2} -type f -mmin -${1} -exec ls -altr {} +;
    elif [ $# -eq 1 ]; then
        find -type f -mtime -${1} -exec ls -altr {} +;
        #find -type f -mmin -${1} -exec ls -altr {} +;
    else
        echo "Invalid input"
    fi
}

### ================================================================================
#function arm { cd ~/work/proj/${1}/Customer/Phison/FPGA_Verify/trunk/fw; }
#function andes { cd ~/work/proj/${1}/Customer/Phison/opt_andes_fpga_test/trunk/fw; }
# dd skip=0 count=16384 bs=1 if=Debug/output/ps5016_opt_test.bin of=ps5016_opt_test.bin
function andes { cd ~/work/proj/sa_andes/base/et760-2.0/; }
function tool { cd ~/work/proj/sa_andes/tool/; }
function rasp { cd ~/work/proj/sa_raspberry/kaleidoscope/; }

sed_name() {
    if [ $# -eq 3 ]; then
        echo -e "Change Name ${GREEN}${1}${NC} to ${GREEN}${2}${NC} path: ${LYELLOW}${3}${NC}"
        sed -i "s/${1}/${2}/g" ${3}
    elif [ $# -eq 2 ]; then
        echo -e "Change Name ${GREEN}${1}${NC} to ${GREEN}${2}${NC}"
        #exclude svn-directories
        find . -name .svn -prune -o -type f -print0 | xargs -0 -n 1 sed -i -e "s/${1}/${2}/g"
    else
        echo "Invalid input: sed_name {old} {new} ({file path})"
    fi
}

### ================================================================================
find_all() {
    find . -name .svn -prune -o -name .git -prune -o \
           -type f -print0
}

find_src() {
    find . -name .svn -prune -o -name .git -prune -o \
           -type f \( -name "*.c" -o -name "*.h" \) -print0
}

line_count() {
    if [ $# -eq 0 ]; then
        find_src | xargs -0 wc -l
    elif [ $# -eq 1 ] && [ ${1} == "all" ]; then
        find_all | xargs -0 wc -l
    else
        echo "Invalid input"
    fi
}

line_count2() {
    # declare inside a function automatically makes the variable local.
    declare -i sum=0

    if [ $# -eq 0 ]; then
        while IFS=  read -r -d $'\0'; do
            local lines=$(wc -l ${REPLY} | cut -f1 -d' ')
            sum=$((lines + sum))
            printf "%10d %s\n" "${lines}" "${REPLY}"
        done < <(find_src)

    elif [ $# -eq 1 ] && [ ${1} == "all" ]; then
        while IFS=  read -r -d $'\0'; do
            local lines=$(wc -l ${REPLY} | cut -f1 -d' ')
            sum=$((lines + sum))
            printf "%10d %s\n" "${lines}" "${REPLY}"
        done < <(find_all)
    else
        echo "Invalid input"
    fi

    printf "total line: $sum\r\n"
}

file_count() {
    find . -type f | wc -l
}

sfile_count() {
    find . -name "*.[ch]" | wc -l
}

### ================================================================================
# Artistic Style - Code formatter
run_astyle() {
    if [ $# -ge 1 ]; then
        astyle -A3 -s4 -xn -xl -S -L -m0 -p -H -k3 -W3 -xf -xh -c -xC96 -n -z2 -v -Q ${@}
    else
        astyle -A3 -s4 -xn -xl -S -L -m0 -p -H -k3 -W3 -xf -xh -c -xC96 -n -z2 -v -Q -r \
               ./*.c,*.cpp,*.ino
    fi
}

### ================================================================================
# Colors and formatting
alias echo_color='
        echo -e ${RED}      "RED     " ${LRED}      "LRED     " ${BOLD} "LRED"     ${NC}
        echo -e ${GREEN}    "GREEN   " ${LGREEN}    "LGREEN   " ${BOLD} "LGREEN"   ${NC}
        echo -e ${YELLOW}   "YELLOW  " ${LYELLOW}   "LYELLOW  " ${BOLD} "LYELLOW"  ${NC}
        echo -e ${BLUE}     "BLUE    " ${LBLUE}     "LBLUE    " ${BOLD} "LBLUE"    ${NC}
        echo -e ${PURPLE}   "PURPLE  " ${LPURPLE}   "LPURPLE  " ${BOLD} "LPURPLE"  ${NC}
        echo -e ${CYAN}     "CYAN    " ${LCYAN}     "LCYAN    " ${BOLD} "LCYAN"    ${NC}
        echo -e ${BLACK}    "BLACK   " ${WHITE}     "WHIT     " ${BOLD} "WHITE"    ${NC}
        echo -e ${DRAKGRAY} "DRAKGRAY" ${LIGHTGRAY} "LIGHTGRAY" ${BOLD} "LIGHTGRAY"${NC}'

<<com
  Escape character (often represented by "^[" or "<Esc>")
  followed by some other characters: "<Esc>[FORMATCODEm".
  <Esc>: \e, \033, \x18

  multiple attribute example:
    echo -e "\e[1;39mSTRING${NC}"
    echo -e "${BOLD}${RED}STRING${NC}"
com

# Reset all attributes
NC='\e[0m'

# Formatting
BOLD='\e[1m' # Bold/Bright
DIM='\e[2m'
UNDERLINE='\e[4m'
BLINK='\e[5m'
REVERSE='\e[7m' # invert the foreground and background colors
HIDDEN='\e[8m' # useful for passwords
# Reset
RBOLD='\e[21m'
RDIM='\e[22m'
RUNDERLINE='\e[24m'
RBLINK='\e[25m'
RREVERSE='\e[27m'
RHIDDEN='\e[28m'

# === 8/16 Colors ===

# Foreground (text)
DEF='\e[39m'
BLACK='\e[30m'
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'
PURPLE='\e[35m' # Magenta
CYAN='\e[36m'
LIGHTGRAY='\e[37m'

DRAKGRAY='\e[90m'
LRED='\e[91m'
LGREEN='\e[92m'
LYELLOW='\e[93m'
LBLUE='\e[94m'
LPURPLE='\e[95m'
LCYAN='\e[96m'
WHITE='\e[97m'

# Background
BG_DEF='\e[49m'
BG_BLACK='\e[40m'
BG_RED='\e[41m'
BG_GREEN='\e[42m'
BG_YELLOW='\e[43m'
BG_BLUE='\e[44m'
BG_PURPLE='\e[45m'
BG_CYAN='\e[46m'
BG_LIGHTGRAY='\e[47m'

BG_DRAKGRAY='\e[100m'
BG_LRED='\e[101m'
BG_LGREEN='\e[102m'
BG_LYELLOW='\e[103m'
BG_LBLUE='\e[104m'
BG_LPURPLE='\e[105m'
BG_LCYAN='\e[106m'
BG_WHITE='\e[107m'
### ================================================================================

