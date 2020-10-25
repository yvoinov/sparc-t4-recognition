# sparc-t4-recognition
## An M4 macro for autoconf to recognize SPARC T4+ CPUs

SPARC-T4 + processors, in addition to support for backward compatibility with the SPARCv9 architecture, have new specific assembler instructions.

Since compilers (GCC, CLang, etc.) do not bother to recognize SPARC processors at the preprocessor level (excluding SPARCv8 and SPARCv9 architectures), I had to write a macro.

Due to the fact that T4 processors differ from classic SPARCv9 processors by the presence of ASR registers, the recognition is very simple: we recognize SPARC by means of the compiler, then we try to compile the T4-specific assembly instruction WRPAUSE. In classic SPARCv9, ASR registers are absent, so the assembler returns Invalid operand.

To use, add a macro to configure.ac as shown below:

```sh
dnl SPARC-T4+ recognition
if test ! -z "`uname -p 2>&1 | $EGREP -o -E 'sparc'`"; then
  AX_SPARC_T4([SPARC_T4])
fi
```

ACTION-IF-FOUND sets the variable SPARC_T4, using which it is easy to implement processor-specific conditional compilation

```c
#	if defined(__sparc)
#		if defined(SPARC_T4)
#			define COUNT 128
#			define PAUSE __asm__ __volatile__ ("wr %%g0, COUNT, %%asr27\n\t" ::: "memory")
#		else	
#			define PAUSE __asm__ __volatile__ ("rd	%%ccr, %%g0\n\t" ::: "memory")
#		endif
```

