.data
include "mapa1.data"

.text
.global _start

_start:
    # Inicialização dos registradores
    la t0, image_width     # t0 aponta para a largura da imagem
    lw t1, 0(t0)           # t1 = largura da imagem
    la t0, image_height    # t0 aponta para a altura da imagem
    lw t2, 0(t0)           # t2 = altura da imagem

    la t0, image_data      # t0 aponta para o início dos dados da imagem
    li t3, DISPLAY_ADDR    # t3 aponta para o início do display de bitmap (substitua pelo endereço real)

    li t4, 0               # t4 = contador de pixels

render_loop:
    # Calcula o endereço de destino no display de bitmap
    mul t5, t4, 4          # Cada pixel é representado por 4 bytes (ARGB)
    add t6, t3, t5         # Endereço do pixel no display

    # Lê o valor do pixel da imagem
    lbu t7, 0(t0)          # Lê o byte da imagem
    addi t0, t0, 1         # Avança para o próximo byte da imagem

    # Escreve o valor do pixel no display de bitmap
    sb t7, 0(t6)           # Escreve o byte no display

    # Incrementa o contador de pixels
    addi t4, t4, 1

    # Verifica se todos os pixels foram processados
    li t8, 256             # Número total de pixels (16x16)
    bge t4, t8, end_render # Se t4 >= 256, termina

    j render_loop

end_render:
    # Fim do programa
    ecall

# Endereço do display de bitmap (substitua pelo endereço real)
.equ DISPLAY_ADDR, 0x80000000