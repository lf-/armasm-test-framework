target extended-remote :12345
symbol-file test-arm
set disassemble-next-line on
set confirm off

alias connect = target remote :12345