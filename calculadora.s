.section .data

menu:
    .asciz "\n===== CALCULADORA ARM64 =====\n1. Suma\n2. Resta\n3. Multiplicacion\n4. Division entera\n5. Potencia\n6. Factorial\n7. Salir\nSeleccione una opcion: "

msg_num1:
    .asciz "Ingrese el primer numero: "

msg_num2:
    .asciz "Ingrese el segundo numero: "

msg_div0:
    .asciz "ERROR: No se puede dividir entre cero.\n"

msg_exp:
    .asciz "ERROR: El exponente debe ser no negativo.\n"

msg_fact:
    .asciz "ERROR: El factorial debe ser no negativo.\n"

msg_invalid:
    .asciz "ERROR: Opcion invalida.\n"

msg_result:
    .asciz "Resultado: "

newline:
    .asciz "\n"

.section .bss
.lcomm buffer, 128
.lcomm outbuf, 128

.section .text
.global _start

_start:

menu_loop:
    // Mostrar menu
    ldr x0, =menu
    bl print_string

    // Leer opcion
    bl read_number
    mov x20, x0

    cmp x20, #1
    b.eq do_sum

    cmp x20, #2
    b.eq do_sub

    cmp x20, #3
    b.eq do_mul

    cmp x20, #4
    b.eq do_div

    cmp x20, #5
    b.eq do_pow

    cmp x20, #6
    b.eq do_fact

    cmp x20, #7
    b.eq exit_program

    ldr x0, =msg_invalid
    bl print_string
    b menu_loop


// =====================================
// SUMA
// =====================================
do_sum:
    ldr x0, =msg_num1
    bl print_string
    bl read_number
    mov x21, x0

    ldr x0, =msg_num2
    bl print_string
    bl read_number
    mov x22, x0

    add x0, x21, x22
    bl print_result

    b menu_loop


// =====================================
// RESTA
// =====================================
do_sub:
    ldr x0, =msg_num1
    bl print_string
    bl read_number
    mov x21, x0

    ldr x0, =msg_num2
    bl print_string
    bl read_number
    mov x22, x0

    sub x0, x21, x22
    bl print_result

    b menu_loop


// =====================================
// MULTIPLICACION
// =====================================
do_mul:
    ldr x0, =msg_num1
    bl print_string
    bl read_number
    mov x21, x0

    ldr x0, =msg_num2
    bl print_string
    bl read_number
    mov x22, x0

    mul x0, x21, x22
    bl print_result

    b menu_loop


// =====================================
// DIVISION
// =====================================
do_div:
    ldr x0, =msg_num1
    bl print_string
    bl read_number
    mov x21, x0

    ldr x0, =msg_num2
    bl print_string
    bl read_number
    mov x22, x0

    cmp x22, #0
    b.eq division_error

    sdiv x0, x21, x22
    bl print_result

    b menu_loop

division_error:
    ldr x0, =msg_div0
    bl print_string
    b menu_loop


// =====================================
// POTENCIA
// x21 = base
// x22 = exponente
// =====================================
do_pow:
    ldr x0, =msg_num1
    bl print_string
    bl read_number
    mov x21, x0

    ldr x0, =msg_num2
    bl print_string
    bl read_number
    mov x22, x0

    cmp x22, #0
    b.lt exponent_error

    mov x23, #1

power_loop:
    cmp x22, #0
    b.eq power_done

    mul x23, x23, x21
    sub x22, x22, #1

    b power_loop

power_done:
    mov x0, x23
    bl print_result

    b menu_loop

exponent_error:
    ldr x0, =msg_exp
    bl print_string
    b menu_loop


// =====================================
// FACTORIAL
// =====================================
do_fact:
    ldr x0, =msg_num1
    bl print_string
    bl read_number
    mov x21, x0

    cmp x21, #0
    b.lt factorial_error

    mov x22, #1
    mov x23, #1

factorial_loop:
    cmp x22, x21
    b.gt factorial_done

    mul x23, x23, x22
    add x22, x22, #1

    b factorial_loop

factorial_done:
    mov x0, x23
    bl print_result

    b menu_loop

factorial_error:
    ldr x0, =msg_fact
    bl print_string
    b menu_loop


// =====================================
// PRINT STRING
// x0 = direccion del string
// =====================================
print_string:
    mov x1, x0
    mov x2, #0

find_length:
    ldrb w3, [x1, x2]
    cmp w3, #0
    b.eq write_string
    add x2, x2, #1
    b find_length

write_string:
    mov x0, #1
    mov x8, #64
    svc #0

    ret


// =====================================
// READ NUMBER
// retorna numero en x0
// =====================================
read_number:
    mov x0, #0
    ldr x1, =buffer
    mov x2, #128
    mov x8, #63
    mov x0, #0
    svc #0

    ldr x1, =buffer
    mov x2, #0
    mov x3, #0
    mov x4, #1

    // Revisar signo negativo
    ldrb w5, [x1]
    cmp w5, #45
    b.ne parse_digits

    mov x4, #-1
    add x1, x1, #1

parse_digits:
    ldrb w5, [x1]
    cmp w5, #10
    b.eq number_done

    cmp w5, #0
    b.eq number_done

    cmp w5, #13
    b.eq number_done

    sub w5, w5, #48

    mov x6, #10
    mul x2, x2, x6
    add x2, x2, x5

    add x1, x1, #1
    b parse_digits

number_done:
    mul x0, x2, x4
    ret


// =====================================
// PRINT RESULT
// x0 = numero
// =====================================
print_result:
    mov x19, x0

    ldr x0, =msg_result
    bl print_string

    mov x0, x19
    bl print_number

    ldr x0, =newline
    bl print_string

    ret


// =====================================
// PRINT NUMBER
// x0 = numero
// =====================================
print_number:
    mov x19, x0
    ldr x20, =outbuf
    add x20, x20, #127
    mov w21, #0

    // Caso negativo
    cmp x19, #0
    b.ge positive_number

    mov w21, #1
    neg x19, x19

positive_number:
    mov x22, #0

    // Caso cero
    cmp x19, #0
    b.ne convert_loop

    sub x20, x20, #1
    mov w23, #48
    strb w23, [x20]
    mov x22, #1
    b print_converted

convert_loop:
    mov x0, x19
    mov x1, #10
    udiv x2, x0, x1
    msub x3, x2, x1, x0

    add w3, w3, #48
    sub x20, x20, #1
    strb w3, [x20]

    mov x19, x2
    add x22, x22, #1

    cmp x19, #0
    b.ne convert_loop

print_converted:
    // Agregar signo si era negativo
    cmp w21, #1
    b.ne write_number

    sub x20, x20, #1
    mov w23, #45
    strb w23, [x20]
    add x22, x22, #1

write_number:
    mov x0, #1
    mov x1, x20
    mov x2, x22
    mov x8, #64
    svc #0

    ret


// =====================================
// SALIR
// =====================================
exit_program:
    mov x0, #0
    mov x8, #93
    svc #0
