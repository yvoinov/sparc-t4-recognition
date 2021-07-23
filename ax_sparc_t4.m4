#
# SYNOPSIS
#
#   AX_SPARC_T4([ACTION-IF-FOUND])
#
# DESCRIPTION
#
#   Checks if the host cpu supports SPARC-T4+ assembler instruction(s).
#
#   If any of the test for the instruction set were succeeded, the configure
#   script would run ACTION-IF-FOUND if it is specified.
#
# LICENSE
#
#   Copyright (c) 2020-2021 Yuri Voinov <yvoinov@gmail.com>
#
#   Copying and distribution of this file, with or without modification, are
#   permitted in any medium without royalty provided the copyright notice
#   and this notice are preserved. This file is offered as-is, without any
#   warranty.

#serial 4

# To do that on compilation stage we're trying to read from v9e ancillary state register
AC_DEFUN([AX_SPARC_T4],[
  AC_LANG(C)
  AC_MSG_CHECKING([if assembler supports T4+ instructions on SPARC])
  AC_RUN_IFELSE([AC_LANG_PROGRAM([
#include <signal.h>
#include <stdlib.h>
void _sigill_handler(int signum)
{
	exit(1);
}
                                 ],
                                 [
signal(SIGILL, &_sigill_handler);
#if __sparc__
__asm__ ("rd %%asr26, %%g0\n\t":::);
#else
#error This is not SPARC
#endif
return 0;
                                 ])],
                    [AC_MSG_RESULT([yes])
                     AC_SUBST([$1],[1])],
                    [AC_MSG_RESULT([no])
                     AC_SUBST([$1],[0])])
])
