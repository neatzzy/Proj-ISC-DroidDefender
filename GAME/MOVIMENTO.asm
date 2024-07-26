.data
.include "../DATA/mapa1.data"
.include "../DATA/Robozinho1.data"
.include "../DATA/Robozinho1preto.data"

.text

# Funções dos registradores: s0 (carrega o endereço do mapa1 e do Robozinho), s1 (pixel inicial para preenchimento de imagem), s2 (pixel final para preenchimento de imagem)

# Carrega a imagem1 (mapa1)
	
	li s1,0xFF000000	# s1 = endereco inicial da Memoria VGA - Frame 0
	li s2,0xFF012C00	# s2 = endereco final da Memoria VGA - Frame 0
	la s0,mapa1		# s0 = endereço dos dados do mapa 1
	addi s0,s0,8		# s0 = endereço do primeiro pixel da imagem (depois das informações de nlin ncol)
	
LOOP1: 	beq s1,s2,IMG2		# se s1 = último endereço da Memoria VGA, saia do loop
	lw t0,0(s0)		# le uma word do endereço s0 (le 4 pixels da imagem)
	sw t0,0(s1)		# escreve a word na memória VGA no endereço s1 (desenha 4 pixels na tela do Bitmap Display)
	addi s1,s1,4		# soma 4 ao endereço s1 
	addi s0,s0,4		# soma 4 ao endereço s0
	j LOOP1			# volta a verificar a condiçao do loop

# Carrega a imagem2 (Robozinho1 - imagem 16x16)

IMG2:	li t1,0
	li t2,16		#inicializa o contador de quebra de linha para 17 quebras de linha

	li s1,0xFF00A098	# s1 = endereco inicial da primeira linha do Robozinho - Frame 0
	li s2,0xFF00A0A8	# s2 = endereco final da primeira linha do Robozinho (inicial +16) - Frame 0
	la s0,Robozinho1	# s0 = endereço dos dados do Robozinho1
	addi s0,s0,8		# s0 = endereço do primeiro pixel da imagem (depois das informações de nlin ncol)
	
LOOP2: 	beq s1,s2,ENTER		# se s1 atingir o fim da linha de pixels, quebre linha
	lw t0,0(s0)		# le uma word do endereço s0 (le 4 pixels da imagem)
	sw t0,0(s1)		# escreve a word na memória VGA no endereço s1 (desenha 4 pixels na tela do Bitmap Display)
	addi s1,s1,4		# soma 4 ao endereço s1
	addi s0,s0,4		# soma 4 ao endereço s0
	j LOOP2			# volta a verificar a condiçao do loop
	
ENTER:	addi s1,s1,304		# s1 pula para o pixel inicial da linha de baixo
	addi s2,s2,320		# s2 pula para o pixel final da linha de baixo
	addi t1,t1,1          	# atualiza o contador de quebras de linha
	beq t1,t2,MAINL		# termina o carregamento da imagem se 17 quebras de linha ocorrerem
	j LOOP2			# pula para loop 2

# Loop principal do jogo (verifica se ha teclas de movimentação pressionadas)

MAINL:  li t2,0xFF200000	# carrega o endereço de controle do KDMMIO ("teclado")
	lw t0,0(t2)		# le uma word a partir do endereço de controle do KDMMIO
	andi t0,t0,0x0001	# mascara todos os bits de t0 com exceçao do bit menos significativo
   	beq t0,zero,FIM   	# se o BMS de t0 for 0 (não há tecla pressionada), pule para FIM
   	
  	lw s6,4(t2)		# le o valor da tecla pressionada
  	
  	li t1,97		# carrega 97 (valor hex de "a") para t1
  	beq s6,t1,DELETE	# se t0 for igual a 97 (valor hex de "a"), vá para DELETE
  	
  	li t1,119		# carrega 119 (valor hex de "w") para t1
  	beq s6,t1,DELETE	# se t0 for igual a 119 (valor hex de "w"), vá para DELETE
  	
  	li t1,115		# carrega 115 (valor hex de "s") para t1
  	beq s6,t1,DELETE	# se t0 for igual a 115 (valor hex de "s"), vá para DELETE
  	
  	li t1,100  		# carrega 100 (valor hex de "d") para t1
	beq s6,t1,DELETE	# se t0 for igual a 100 (valor hex de "d"), vá para DELETE
	
	j FIM			# se outra tecla for pressionada, vá para FIM
	
# Printa preto em cima da posição do personagem (apaga o personagem anterior)
	
DELETE:	la s3,Robozinho1preto	# carrega a imagem que vai sobrepor o robozinho com pixels pretos
	addi s3, s3, 8		# s3 = endere�o do primeiro pixel da imagem (depois das informa��es de nlin ncol)

	li t1,0	
	li t2,16		# reinicia o contador para 17 quebras de linha
	
	addi s1,s1,-1280
	addi s1,s1,-1280
	addi s1,s1,-1280
	addi s1,s1,-1280	# volta s1 17 linhas (pixel inicial da primeira linha) 
	addi s1,s1,-1280	# volta s1 17 linhas (pixel inicial da primeira linha) 
	
	addi s2,s2,-1280
	addi s2,s2,-1280
	addi s2,s2,-1280
	addi s2,s2,-1280	# volta s2 17 linhas (pixel final da primeira linha)
	addi s2,s2,-1280	# volta s2 17 linhas (pixel final da primeira linha)
	
DELLOOP:beq s1,s2,ENTER2	# se s1 atingir o fim da linha de pixels, quebre linha
	lw t0,0(s3)
	sw t0,0(s1)		# escreve a word (4 pixels pretos) na memória VGA
	addi s1,s1,4		# soma 4 ao endereço s1
	addi s3,s3,4		# soma 4 ao endereço s3
	j DELLOOP		# volta a verificar a condiçao do loop
	
ENTER2:	addi s1,s1,304		# s1 pula para o pixel inicial da linha de baixo
	addi s2,s2,320		# s2 pula para o pixel final da linha de baixo
	addi t1,t1,1          	# atualiza o contador de quebras de linha
	beq t1,t2,VERIFY	# termina o carregamento da imagem se 17 quebras de linha ocorrerem
	j DELLOOP		# pula para delloop 
	
# Verifica qual a tecla pressionada para movimentar o Robozinho
	
VERIFY: li t1,97		# carrega 97 (valor hex de "a") para t1
  	beq s6,t1,MOVLFT	# se t0 for igual a 97 (valor hex de "a"), vá para MOVLFT
  	
  	li t1,119		# carrega 119 (valor hex de "w") para t1
  	beq s6,t1,MOVUP	# se t0 for igual a 119 (valor hex de "w"), vá para MOVUP
  	
  	li t1,115		# carrega 115 (valor hex de "s") para t1
  	beq s6,t1,MOVDWN	# se t0 for igual a 115 (valor hex de "s"), vá para MOVDWN
  	
  	li t1,100  		# carrega 100 (valor hex de "d") para t1
	beq s6,t1,MOVRGHT	# se t0 for igual a 100 (valor hex de "d"), vá para MOVRGHT
		
# Printa o personagem 4 pixels para frente (move o Robozinho para a direita)	
	
MOVRGHT:addi s1,s1,-1280
	addi s1,s1,-1280
	addi s1,s1,-1280
	addi s1,s1,-1276	# volta s1 17 linnhas e vai 4 pixels pra frente (pixel inicial + 4) 
	
	addi s2,s2,-1280
	addi s2,s2,-1280
	addi s2,s2,-1280
	addi s2,s2,-1276	# volta s2 17 linhas e vai 4 pixels pra frente (pixel final + 4)
	
	li t1,0
	li t2,16		# reinicia contador para 17 quebras de linha
		
	addi s0,s0,-256		# s0 = endereço dos dados do Robozinho1	
	
LOOP3: 	beq s1,s2,ENTER3	# se s1 atingir o fim da linha de pixels, quebre linha
	lw t0,0(s0)		# le uma word do endereço s0 (le 4 pixels da imagem)
	sw t0,0(s1)		# escreve a word na memória VGA no endereço s1 (desenha 4 pixels na tela do Bitmap Display)
	addi s1,s1,4		# soma 4 ao endereço s1
	addi s0,s0,4		# soma 4 ao endereço s0
	j LOOP3			# volta a verificar a condiçao do loop
	
ENTER3:	addi s1,s1,304		# s1 pula para o pixel inicial da linha de baixo
	addi s2,s2,320		# s2 pula para o pixel final da linha de baixo
	addi t1,t1,1            # reinicia o contador de quebras de linha
	beq t1,t2,FIM		# termine o carregamento da imagem se 17 quebras de linha ocorrerem
	j LOOP3			# pula para loop 3
	
# Printa o personagem 4 linhas para baixo (move o Robozinho para baixo)	
	
MOVDWN: addi s1,s1,-960
	addi s1,s1,-960
	addi s1,s1,-960
	addi s1,s1,-960		# volta s1 13 linnhas (pixel inicial 4 linhas abaixo) 
	
	addi s2,s2,-960
	addi s2,s2,-960
	addi s2,s2,-960
	addi s2,s2,-960		# volta s2 13 linnhas (pixel final 4 linhas abaixo)
	
	li t1,0
	li t2,16		# reinicia contador para 17 quebras de linha
		
	addi s0,s0,-256		# s0 = endereço dos dados do Robozinho1	
	
LOOP4: 	beq s1,s2,ENTER4	# se s1 atingir o fim da linha de pixels, quebre linha
	lw t0,0(s0)		# le uma word do endereço s0 (le 4 pixels da imagem)
	sw t0,0(s1)		# escreve a word na memória VGA no endereço s1 (desenha 4 pixels na tela do Bitmap Display)
	addi s1,s1,4		# soma 4 ao endereço s1
	addi s0,s0,4		# soma 4 ao endereço s0
	j LOOP4			# volta a verificar a condiçao do loop
	
ENTER4:	addi s1,s1,304		# s1 pula para o pixel inicial da linha de baixo
	addi s2,s2,320		# s2 pula para o pixel final da linha de baixo
	addi t1,t1,1            # reinicia o contador de quebras de linha
	beq t1,t2,FIM		# termine o carregamento da imagem se 17 quebras de linha ocorrerem
	j LOOP4			# pula para loop 4

# Printa o personagem 4 linhas para cima (move o Robozinho para cima)	
	
MOVUP: addi s1,s1,-1600
	addi s1,s1,-1600
	addi s1,s1,-1600
	addi s1,s1,-1600	# volta s1 21 linnhas (pixel inicial 4 linhas acima) 
	
	addi s2,s2,-1600
	addi s2,s2,-1600
	addi s2,s2,-1600
	addi s2,s2,-1600	# volta s2 21 linhas (pixel final 4 linhas acima)
	
	li t1,0
	li t2,16		# reinicia contador para 17 quebras de linha
		
	addi s0,s0,-256		# s0 = endereço dos dados do Robozinho1	
	
LOOP5: 	beq s1,s2,ENTER5	# se s1 atingir o fim da linha de pixels, quebre linha
	lw t0,0(s0)		# le uma word do endereço s0 (le 4 pixels da imagem)
	sw t0,0(s1)		# escreve a word na memória VGA no endereço s1 (desenha 4 pixels na tela do Bitmap Display)
	addi s1,s1,4		# soma 4 ao endereço s1
	addi s0,s0,4		# soma 4 ao endereço s0
	j LOOP5 		# volta a verificar a condiçao do loop
	
ENTER5:	addi s1,s1,304		# s1 pula para o pixel inicial da linha de baixo
	addi s2,s2,320		# s2 pula para o pixel final da linha de baixo
	addi t1,t1,1            # reinicia o contador de quebras de linha
	beq t1,t2,FIM		# termine o carregamento da imagem se 17 quebras de linha ocorrerem
	j LOOP5 		# pula para loop 5
	
# Printa o personagem 4 pixels para a esquerda (move o Robozinho para a esquerda)	
	
MOVLFT: addi s1,s1,-1280
	addi s1,s1,-1280
	addi s1,s1,-1280
	addi s1,s1,-1284	# volta s1 17 linhas e vai 4 pixels pra esquerda (pixel inicial - 4) 
	
	addi s2,s2,-1280
	addi s2,s2,-1280
	addi s2,s2,-1280
	addi s2,s2,-1284	# volta s2 17 linhas e vai 4 pixels pra esquerda (pixel final - 4) 
	
	li t1,0
	li t2,16		# reinicia contador para 17 quebras de linha
		
	addi s0,s0,-256		# s0 = endereço dos dados do Robozinho1	
	
LOOP6: 	beq s1,s2,ENTER6	# se s1 atingir o fim da linha de pixels, quebre linha
	lw t0,0(s0)		# le uma word do endereço s0 (le 4 pixels da imagem)
	sw t0,0(s1)		# escreve a word na memória VGA no endereço s1 (desenha 4 pixels na tela do Bitmap Display)
	addi s1,s1,4		# soma 4 ao endereço s1
	addi s0,s0,4		# soma 4 ao endereço s0
	j LOOP6			# volta a verificar a condiçao do loop
	
ENTER6:	addi s1,s1,304		# s1 pula para o pixel inicial da linha de baixo
	addi s2,s2,320		# s2 pula para o pixel final da linha de baixo
	addi t1,t1,1            # reinicia o contador de quebras de linha
	beq t1,t2,FIM		# termine o carregamento da imagem se 17 quebras de linha ocorrerem
	j LOOP6			# pula para loop 6
	
FIM:	j MAINL			# retorna ao loop principal