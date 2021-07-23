# sparc-t4-recognition
[![License](https://img.shields.io/badge/License-GPL%20v2-blue.svg)](https://github.com/yvoinov/sparc-t4-recognition/blob/main/LICENSE)

## M4 macro for autoconf to recognize SPARC T4+ CPUs

SPARC-T4+ processors, in addition to support for backward compatibility with the SPARCv9 architecture, have new specific assembler instructions.

Since compilers (GCC, CLang, etc.) do not bother to recognize SPARC processors at the preprocessor level (excluding SPARCv8 and SPARCv9 architectures), I had to write a macro.

Due to the fact that T4 processors differ from classic SPARCv9 processors by the presence of ASR registers, the recognition is very simple: we recognize SPARC by means of the compiler, then we try to compile the T4-specific assembly instruction WRPAUSE. In classic SPARCv9, ASR registers are absent, so the assembler returns Invalid operand.

Macro set specified environment variable to 1 when compilation successful (i.e. SPARC T-4 or above detected) and 0 otherwise.

To use, add a macro to configure.ac as shown below (for C++ code; for C also require to add CFLAGS):

```sh
dnl SPARC-T4+ recognition
if test ! -z "`uname -p 2>&1 | $EGREP -o -E 'sparc'`"; then
  AX_SPARC_T4([SPARC_T4])
  if test "$SPARC_T4" = "1"; then
    CXXFLAGS="$CXXFLAGS -DSPARC_T4"
  fi
fi
```

ACTION-IF-FOUND sets the variable SPARC_T4, using which it is easy to implement processor-specific conditional compilation:

```c
#	if defined(__sparc)
#		if defined(SPARC_T4)
#			define COUNT 128
#			define PAUSE __asm__ __volatile__ ("wr %%g0, %[count], %%asr27\n\t" :: [count] "i" (COUNT) : "memory")
#		else	
#			define PAUSE __asm__ __volatile__ ("rd	%%ccr, %%g0\n\t" ::: "memory")
#		endif
```
