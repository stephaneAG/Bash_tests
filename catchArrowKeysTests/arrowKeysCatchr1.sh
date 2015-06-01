#!/bin/bash

# 1st way to bind the arrow keys
while true
do
    read -r -sn1 t
    case C in
        A) echo up ;;
        B) echo down ;;
        C) echo right ;;
        D) echo left ;;
    esac
done
