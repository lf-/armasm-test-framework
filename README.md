# Test framework for ARM assembly language

This consists of two parts. The first is a `native` portion, which should NOT
be run on ARM in order to comply with the rules. I attempt to cause it to
entirely fail to build if it's not being built from an x86_64 computer.

You write your C code in the `native` section, which will dump binary files
of output that you can use to validate the ARM assembly implementation does
the same thing as the x86_64 C implementation. Array sizing will be handled
automagically because we just include the bytes of the arrays directly into
the ARM executable file and can find the size from that.

## Usage

Write your test function that modifies the given data array in
`native/testfn.c`, replacing the C function `testfn`. Then, run `make run`
from the `native` directory.

I have not figured out how to use crosstool or similar things to get a qemu and
toolchain for Linux-ARM, but I provide my `shell.nix` file that can be executed
with `nix-shell` to get an environment with all the tools you need for the ARM
side. This will only work under Windows if you are using WSL 2 and have Nix
installed. Otherwise you have to be running Linux on your computer or in a
VM.

Next, you run `make run` from the `arm` folder, to build the ARM executable
and run it. It will verify that the output array is as expected, highlighting
any wrong entries in red. Note that this command must be run inside a
`nix-shell`.

It will probably screw up. You can debug it with `make run-gdb` from the `arm`
folder. Then, run `make gdb` from another window, which, with the provided
`.gdbinit` file should get you up and running (if it doesn't like it, you will
have to add stuff to `YOURHOMEDIRECTORY/.gdbinit` as it states).  To reconnect,
type `connect` (you don't have to close the debugger when you reassemble the
assembly program, just type `connect`, possibly twice). If it gets in some
infinite loop, try the `kill` command.

This is not a `gdb` tutorial, and in fact, `gdb` is a horribly hard to use
program that I've been using for years and still hate and have no idea how to
use well. Here's some common commands, however:

- `fin` (`finish`): runs until it exits the current function. good if you
  accidentally stepped into someone else's function.
- `c`: continue
- `s`: steps forward one line
- `si`: steps forward one instruction
- `n`: step over, in terms of source code
- `ni`: step over, in instructions
- `b main`: sets a breakpoint on the function `main`. if you have debugging
  info in your executables, you can also give it stuff like `main.s:20` for
  line based breakpoints, and `b *0xffe2` to stop at the address `0xffe2`
- `x/wx $r0`: examine word, hex, at the memory address in r0.
  This one is super super super useful, you should probably read `help x` in
  full (it's short and good!)
- `p/x $r0`: print the value of `r0` in hex. it can also print the evaluation
  of arbitrary C-syntax expressions. super powerful.
- `info reg`: prints out all your registers
- `exit` or ctrl-D: leave
