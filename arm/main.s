.text
.equ testdata_len, etestdata - testdata
.equ testdata_out_len, etestdata_out - testdata_out

fail:
    bkpt

// int main(int argc, char **argv)
.globl main
main:
    push {r4-r11, lr}
    // put some crap in r4-r11 we can check later
    mov r4,  #4
    mov r5,  #5
    mov r6,  #6
    mov r7,  #7
    mov r8,  #8
    mov r9,  #9
    mov r10, #10
    mov r11, #11

    ldr r0, =testdata
    // int testfunc(int *ptr)
    bl testfunc

    // check for ABI compliance
    cmp r4,  #4
    bne fail
    cmp r5,  #5
    bne fail
    cmp r6,  #6
    bne fail
    cmp r7,  #7
    bne fail
    cmp r8,  #8
    bne fail
    cmp r9,  #9
    bne fail
    cmp r10, #10
    bne fail
    cmp r11, #11
    bne fail

    pop {r4-r11, lr}

    // printf(it_returned, func_output)
    mov r1, r0
    ldr r0, =it_returned
    push {lr}
    bl printf
    pop {lr}

    push {r4-r7}
    ldr r0, =compareheader
    push {lr}
    bl printf
    pop {lr}


    // once we've run the function we want to compare the regions to make sure
    // they are equal to the C program's result
    ldr r4, =testdata
    ldr r5, =testdata_out
    mov r1, #0
    ldr r7, =testdata_len
loop:
    cmp r1, r7, lsr#2
    bge leave
    // load expected
    ldr r3, [r5, r1, lsl#2]
    // load value
    ldr r2, [r4, r1, lsl#2]
    cmp r2, r3
    // if this is a failing case load the failing format string addr to r0
    ldrne r0, =failcompare
    ldreq r0, =compareline

    push {r0-r3,lr}
    // printf(s, idx, value, expected)
    bl printf
    pop {r0-r3,lr}

    add r1, #1
    b loop
leave:
    mov r0, #0
    pop {r4-r7}
    bx lr

.data
testdata:
    .incbin "../native/testdata"
etestdata:

// stop it getting overwritten accidentally
.section .rodata
compareheader: .string       "POS    GOT        EXPECT\n"
compareline: .string         "%04x   %08x   %08x\n"
failcompare: .string   "%04x   \x1b[31m%08x\x1b[0m   %08x\n"
it_returned: .string "testfunc(data) = %08x\n"
testdata_out:
    .incbin "../native/testdata.out"
etestdata_out:
