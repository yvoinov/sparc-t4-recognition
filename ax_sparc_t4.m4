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
#   Copyright (c) 2020 Yuri Voinov <yvoinov@gmail.com>
#
#   This program is free software; you can redistribute it and/or modify it
#   under the terms of the GNU General Public License as published by the
#   Free Software Foundation; either version 2 of the License, or (at your
#   option) any later version.
#
#   This program is distributed in the hope that it will be useful, but
#   WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
#   Public License for more details.
#
#   You should have received a copy of the GNU General Public License along
#   with this program. If not, see <https://www.gnu.org/licenses/>.
#
#   As a special exception, the respective Autoconf Macro's copyright owner
#   gives unlimited permission to copy, distribute and modify the configure
#   scripts that are the output of Autoconf when processing the Macro. You
#   need not follow the terms of the GNU General Public License when using
#   or distributing such scripts, even though portions of the text of the
#   Macro appear in them. The GNU General Public License (GPL) does govern
#   all other use of the material that constitutes the Autoconf Macro.
#
#   This special exception to the GPL applies to versions of the Autoconf
#   Macro released by the Autoconf Archive. When you make and distribute a
#   modified version of the Autoconf Macro, you may extend this special
#   exception to the GPL to apply to your modified version as well.

#serial 3

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
