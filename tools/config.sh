#!/bin/sh

CC=$1
AC="tools/config.c"
AOUT="tools/config.out"
CCEX="$CC $AC -o $AOUT"

TARGET=`$CC -v 2>&1 | sed -e "/Target:/b" -e "/--target=/b" -e d | sed "s/.* --target=//; s/Target: //; s/ .*//" | head -1`
MINGW_GCC=`echo "$TARGET" | sed "/mingw/!d"`
if [ "$MINGW_GCC" = "" ]; then
  MINGW=0
else
  MINGW=1
fi

if [ $MINGW -eq 0 ]; then
  LONG=`echo "#include <stdio.h>int main() { printf(\\"%d\\", (int)sizeof(long)); return 0; }" > $AC && $CCEX && $AOUT && rm -f $AOUT`
  INT=`echo "#include <stdio.h>int main() { printf(\\"%d\\", (int)sizeof(int)); return 0; }" > $AC && $CCEX && $AOUT && rm -f $AOUT`
  SHORT=`echo "#include <stdio.h>int main() { printf(\\"%d\\", (int)sizeof(short)); return 0; }" > $AC && $CCEX && $AOUT && rm -f $AOUT`
  CHAR=`echo "#include <stdio.h>int main() { printf(\\"%d\\", (int)sizeof(char)); return 0; }" > $AC && $CCEX && $AOUT && rm -f $AOUT`
  LLONG=`echo "#include <stdio.h>int main() { printf(\\"%d\\", (int)sizeof(long long)); return 0; }" > $AC && $CCEX && $AOUT && rm -f $AOUT`
  DOUBLE=`echo "#include <stdio.h>int main() { printf(\\"%d\\", (int)sizeof(double)); return 0; }" > $AC && $CCEX && $AOUT && rm -f $AOUT`
  LILEND=`echo "#include <stdio.h>int main() { short int word = 0x0001; char *byte = (char *) &word; printf(\\"%d\\", (int)byte[0]); return 0; }" > $AC && $CCEX && $AOUT && rm -f $AOUT`
else
  CHAR="1"
  SHORT="2"
  LONG="4"
  INT="4"
  DOUBLE="8"
  LLONG="8"
  LILEND="1"
fi

if [ "$2" = "mingw" ]; then
  if [ $MINGW -eq 0 ]; then
    echo -n "0"
  else
    echo -n "1"
  fi
elif [ "$2" = "strip" ]; then
  if [ $MINGW -eq 0 ]; then
    echo -n "strip -x"
  else
    echo -n "ls"
  fi
else
  echo "#define POTION_PLATFORM \"$TARGET\""
  echo "#define POTION_WIN32    $MINGW"
  echo
  echo "#define PN_SIZE_T     $LONG"
  echo "#define LONG_SIZE_T   $LONG"
  echo "#define DOUBLE_SIZE_T $DOUBLE"
  echo "#define INT_SIZE_T    $INT"
  echo "#define SHORT_SIZE_T  $SHORT"
  echo "#define CHAR_SIZE_T   $CHAR"
  echo "#define LONGLONG_SIZE_T   $LLONG"
  echo "#define PN_LITTLE_ENDIAN  $LILEND"
fi
