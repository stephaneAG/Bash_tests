/* KupaCPPmain.cpp - short C++ program to execute a system command that is itself actually calling the Kupa__Linx.sh bash script 
 * 
 * It was needed as it seems that the Kupa script & its current implementation can't be run from a keyboard shortcut on Linux ( and I don't know why -> wierd ! )
*/

#include <iostream>
#include <stdlib.h>

int main()
{

    // execute the call to the Kupa bash script
    system("kupalinux"); // using the symbolic link that resides in /usr/bin
    //system("saytest"); // using the symbolic link that resides in /usr/bin


    return 0;
}
