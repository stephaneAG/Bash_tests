#!/usr/bin/env bash

#return value visualisation
PS1="\$? \$(if [[ \$? == 0 ]]; then echo \"\[\033[0;32m\];)\"; else echo \"\[\033[0;31m\];(\"; fi)\[\033[00m\] : "
# Zero is a green smiley and non-zero a red one. So your prompt will smile if the last operation was successful.
