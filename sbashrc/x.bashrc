#!/bin/bash

# 颜色变量的定义～
case "$TERM" in
msys)
CONTEXT_COLOR="^[[37m"
ADD_COLOR="^[[32m"
DELETE_COLOR="^[[31m"
LOCATION_COLOR="^[[36m"
FILE_COLOR="^[[33m"
INDEX_COLOR="^[[35m"
BLUE_COLOR="^[[34m"
NORM_COLOR="^[[0m"
;;
*) CONTEXT_COLOR=`tput setaf 7`
ADD_COLOR=`tput setaf 2`
DELETE_COLOR=`tput setaf 1`
LOCATION_COLOR=`tput setaf 6`
FILE_COLOR=`tput setaf 3`
INDEX_COLOR=`tput setaf 5`
BLUE_COLOR=`tput setaf 4`
NORM_COLOR=`tput sgr0`
;;
esac

# 该函数用于svn log的颜色显示
slg() {
    env svn log $* |
    sed -e "/r[0-9]\+ /,/^------\+/{
    /r[0-9]\+ /s:.*:$ADD_COLOR&$NORM_COLOR:
    /r[0-9]\+ /!{
    /^------\+/!s:.*:$FILE_COLOR&$NORM_COLOR:
    }
    }" -e "/^------\+/s:.*:$DELETE_COLOR&$NORM_COLOR:" |
    ${PAGER:-less -QRS}
}

# 该函数用于svn diff的颜色显示
sdl() {
env svn diff $* |
sed -e "s/^+[^+].*/${ADD_COLOR}&${NORM_COLOR}/g" \
    -e "s/^-[^-].*/${DELETE_COLOR}&${NORM_COLOR}/g" \
    -e "s/^[-+]\{3\}.*/${FILE_COLOR}&${FILE_COLOR}/g" \
    -e "s/^@@.*/${LOCATION_COLOR}&${NORM_COLOR}/g" \
    -e "s/^[iI]ndex.*/${INDEX_COLOR}&${NORM_COLOR}/g" \
    -e "s/.*/${CONTEXT_COLOR}&${NORM_COLOR}/g" \
    -e "s/\r//g" |
${PAGER:-less -QRS}
}

# 该函数用于显示当前svn被修改的文件
sdlf() {
env svn diff $* |
grep "^--- " |
sed -e "s/^[-+]\{3\}.*/${FILE_COLOR}&${FILE_COLOR}/g"
}

# 该函数用于显示当前文件修改的状况
sds() {
env svn st $* |
sed -e "s/^A.*/${FILE_COLOR}&${NORM_COLOR}/g" \
    -e "s/^D.*/${DELETE_COLOR}&${NORM_COLOR}/g" \
    -e "s/^M.*/${ADD_COLOR}&${FILE_COLOR}/g" \
    -e "s/.*/${CONTEXT_COLOR}&${NORM_COLOR}/g" \
    -e "s/\r//g"
}

# 该函数用于Update时显示颜色
sdu() {
env svn up $* |
sed -e "s/^A\s.*/${FILE_COLOR}&${NORM_COLOR}/g" \
    -e "s/^D\s.*/${DELETE_COLOR}&${NORM_COLOR}/g" \
    -e "s/^M\s.*/${ADD_COLOR}&${FILE_COLOR}/g" \
    -e "s/^G\s.*/${DELETE_COLOR}&${FILE_COLOR}/g" \
    -e "s/^U\s.*/${LOCATION_COLOR}&${FILE_COLOR}/g" \
    -e "s/^@@.*/${LOCATION_COLOR}&${NORM_COLOR}/g" \
    -e "s/^+[^+<>=].*/${ADD_COLOR}&${NORM_COLOR}/g" \
    -e "s/^-[^-].*/${DELETE_COLOR}&${NORM_COLOR}/g" \
    -e "s/^[-+]\{3\}.*/${FILE_COLOR}&${FILE_COLOR}/g" \
    -e "s/^+[<>=]\{7\}.*/${DELETE_COLOR}&${FILE_COLOR}/g" \
    -e "s/.*/${CONTEXT_COLOR}&${NORM_COLOR}/g" \
    -e "s/\r//g"
}

# 这里，用于自定义svn的子命令
svn() {
    case "$1" in
    log)
        shift
        slg "$@"
        ;;
    diff|di)
        shift
        sdl "$@"
        ;;
    st|status|stat)
        shift
        sds "$@"
        ;;
    up|update)
        shift
        sdu "$@"
        ;;
    *)
        env svn "$@"
        ;;
    esac
}