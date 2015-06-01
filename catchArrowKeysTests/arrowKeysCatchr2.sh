#!/bin/bash

# 2nd way to have left/right keys handled ( but not arrow keys )
read -n 1 key

case "" in
    '<') echo go_left ;;
    '>') echo go_right ;;
esac
