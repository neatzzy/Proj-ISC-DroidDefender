#########################################################################
#									#
#	Universidade de Brasilia - Instituto de Ciencias Exatas		#
#		  Departamento de Ciencia da Computacao  		#
#									#
#	     Introducao aos Sistemas Computacionais - 2024.1		#
#		    Professor: Marcus Vinicius Lamar			#
#									#
#	 Alunos: Elvis Miranda, Gustavo Alves e Pedro Marcinoni		#
#								        #
#		       	    DROID DEFENDER:		     		#
#			 Earth's Last Sentinel				#
#									#
#########################################################################

.data

.include "mapa1.data"
.include "mapa1colisao.data"
.include "Robozinho1.data"
.include "Robozinho2.data"
.include "Robozinho1preto.data"
.include "Inimigo1.data"
.include "Inimigo2.data"
.include "Inimigo3.data"
.include "Inimigo4.data"

.text

# Funções dos registradores: 
# s0 (carrega o endereço do mapa1 e do Robozinho)
# s1 (pixel inicial para preenchimento de imagem)
# s2 (pixel final para preenchimento de imagem)
# s3 carrega um contador de paridade baseado nos inputs do jogador
	
# Carrega a imagem1 (mapa1) no frame 0
	
IMG1:	la t4, mapa1		# t4 cerrega endereço do mapa a fim de comparação
	li s1,0xFF000000	# s1 = endereco inicial da Memoria VGA - Frame 0
	li s2,0xFF012C00	# s2 = endereco final da Memoria VGA - Frame 0
	la s0,mapa1		# s0 = endereço dos dados do mapa 1
	mv t3, s0		# t3 = endereço inicial armazenado a fins de comparação
	addi s0,s0,8		# s0 = endereço do primeiro pixel da imagem (depois das informações de nlin ncol)
	
LOOP1: 	beq s1,s2,IMAGEM	# se s1 = último endereço da Memoria VGA, saia do loop
	lw t0,0(s0)		# le uma word do endereço s0 (le 4 pixels da imagem)
	sw t0,0(s1)		# escreve a word na memória VGA no endereço s1 (desenha 4 pixels na tela do Bitmap Display)
	addi s1,s1,4		# soma 4 ao endereço s1 
	addi s0,s0,4		# soma 4 ao endereço s0
	j LOOP1			# volta a verificar a condiçao do loop

# Carrega a imagem2 (Robozinho1 - imagem 16x16) no frame 0

IMG2:	li s1,0xFF00A0C8	# s1 = endereco inicial da primeira linha do Robozinho - Frame 0
	li s2,0xFF00A0D8	# s2 = endereco final da primeira linha do Robozinho (inicial +16) - Frame 0
	la s0,Robozinho1	# s0 = endereço dos dados do Robozinho1 (boca fechada)
	mv t3, s0		# t3 = endereço inicial armazenado a fins de comparação
	addi s0,s0,8		# s0 = endereço do primeiro pixel da imagem (depois das informações de nlin ncol)
	j PRINT16
	
# Carrega a imagem3 (ALIEN1 - imagem16x16)

IMG3:	li s1,0xFF0064C8	# s1 = endereco inicial da primeira linha do alien 1 - Frame 0 
	li s2,0xFF0064D8	# s2 = endereco final da primeira linha do alien 1 (inicial +16) - Frame 0      
	la s0,Inimigo1          # s0 = endereço dos dados do alien1
	mv t3, s0		# t3 = endereço inicial armazenado a fins de comparação
	addi s0,s0,8		# s0 = endereço do primeiro pixel da imagem (depois das informações de nlin ncol)
	j PRINT16
	
# Carrega a imagem4 (ALIEN2 - imagem16x16)

IMG4:	li s1,0xFF008548	# s1 = endereco inicial da primeira linha do alien 2 - Frame 0
	li s2,0xFF008558	# s2 = endereco final da primeira linha do alien 2 - Frame 0
	la s0,Inimigo2          # s0 = endereço dos dados do alien2
	mv t3, s0		# t3 = endereço inicial armazenado a fins de comparação
	addi s0,s0,8		# s0 = endereço do primeiro pixel da imagem (depois das informações de nlin ncol)
	j PRINT16

# Carrega a imagem5 (ALIEN3 - imagem16x16)

IMG5:	li s1,0xFF008538	# s1 = endereco inicial da primeira linha do alien 3 - Frame 0
	li s2,0xFF008548	# s2 = endereco final da primeira linha do alien 3 - Frame 0
	la s0,Inimigo3          # s0 = endereço dos dados do alien3
	mv t3, s0		# t3 = endereço inicial armazenado a fins de comparação
	addi s0,s0,8		# s0 = endereço do primeiro pixel da imagem (depois das informações de nlin ncol)
	j PRINT16
	
# Carrega a imagem6 (ALIEN4 - imagem16x16)

IMG6:	li s1,0xFF008558	# s1 = endereco inicial da primeira linha do alien 4 - Frame 0
	li s2,0xFF008568	# s2 = endereco final da primeira linha do alien 4 - Frame 0
	la s0, Inimigo4         # s0 = endereço dos dados do alien4 
	mv t3, s0		# t3 = endereço inicial armazenado a fins de comparação
	addi s0,s0,8		# s0 = endereço do primeiro pixel da imagem (depois das informações de nlin ncol)
	j PRINT16
	
# Carrega a imagem7 (mapa1 - colisao) no frame 1
	
IMG7:	li s1,0xFF100000	# s1 = endereco inicial da Memoria VGA - Frame 1
	li s2,0xFF112C00	# s2 = endereco final da Memoria VGA - Frame 1
	la s0,mapa1colisao	# s0 = endereço dos dados da colisao do mapa 1
	mv t3, s0		# t3 = endereço inicial armazenado a fins de comparação
	addi s0,s0,8		# s0 = endereço do primeiro pixel da imagem (depois das informações de nlin ncol)
	
LOOPCOL:beq s1,s2,SETUP_MAIN	# se s1 = último endereço da Memoria VGA, saia do loop
	lw t0,0(s0)		# le uma word do endereço s0 (le 4 pixels da imagem)
	sw t0,0(s1)		# escreve a word na memória VGA no endereço s1 (desenha 4 pixels na tela do Bitmap Display)
	addi s1,s1,4		# soma 4 ao endereço s1 
	addi s0,s0,4		# soma 4 ao endereço s0
	j LOOPCOL		# volta a verificar a condiçao do loop
	
# Compara os endereços para ver qual a proxima imagem a ser printada

IMAGEM: beq t3, t4, IMG2 	# se t3 contiver o endereço "mapa1", vá para IMG2 (imprime a imagem2)
	
	la t4, Robozinho1	# t4 = endereço dos dados do Robozinho1
	beq t3, t4, IMG3	# se t3 contiver o endereço "Robozinho1", vá para IMG3 (imprime a imagem3)
	
	la t4, Inimigo1		# t4 = endereço dos dados do alien 1
	beq t3, t4, IMG4	# se t3 contiver o endereço "Inimigo1", vá para IMG4 (imprime a imagem4)
	
	la t4, Inimigo2		# t4 = endereço dos dados do alien 2
	beq t3, t4, IMG5	# se t3 contiver o endereço "Inimigo2", vá para IMG5 (imprime a imagem5)
	
	la t4, Inimigo3		# t4 = endereço dos dados do alien 3
	beq t3, t4, IMG6	# se t3 contiver o endereço "Inimigo3", vá para IMG6 (imprime a imagem6)
	
	la t4, Inimigo4		# t4 = endereço dos dados do alien 4
	beq t3, t4, IMG7	# se t3 contiver o endereço "Inimigo4", vá para IMG7 (imprime a imagem7)	
	
# Loop que imprime imagens 16x16

PRINT16:li t1,0
	li t2,16		#inicializa o contador de quebra de linha para 16 quebras de linha
	
LOOP2: 	beq s1,s2,ENTER		# se s1 atingir o fim da linha de pixels, quebre linha
	lw t0,0(s0)		# le uma word do endereço s0 (le 4 pixels da imagem)
	sw t0,0(s1)		# escreve a word na memória VGA no endereço s1 (desenha 4 pixels na tela do Bitmap Display)
	addi s1,s1,4		# soma 4 ao endereço s1
	addi s0,s0,4		# soma 4 ao endereço s0
	j LOOP2 		# volta a verificar a condiçao do loop
	
ENTER:	addi s1,s1,304		# s1 pula para o pixel inicial da linha de baixo
	addi s2,s2,320		# s2 pula para o pixel final da linha de baixo
	addi t1,t1,1          	# atualiza o contador de quebras de linha
	beq t1,t2,IMAGEM	# termina o carregamento da imagem se 17 quebras de linha ocorrerem
	j LOOP2	
	
# Setup dos dados necessarios para o main loop
	
SETUP_MAIN:
			
	li s1,0xFF00B4C8	# s1 = endereco inicial da linha diretamente abaixo do Robozinho
	li s2,0xFF00B4D8	# s2 = endereco final da linha diretamente abaixo do Robozinho (inicial +16)
	li s8,0xFF0064C8	# s8 = coordenada inicial do alien vermelho (blinky)
	#li s9,
	#li s10, 
	#li s11, 	

# Loop principal do jogo (verifica se ha teclas de movimentação pressionadas)

MAINL:  li t2,0xFF200000	# carrega o endereço de controle do KDMMIO ("teclado")
	lw t0,0(t2)		# le uma word a partir do endereço de controle do KDMMIO
	andi t0,t0,0x0001	# mascara todos os bits de t0 com exceçao do bit menos significativo
   	beq t0,zero,FIM   	# se o BMS de t0 for 0 (não há tecla pressionada), pule para FIM
 
  	lw s6,4(t2)		# le o valor da tecla pressionada
  	
  	li t1,97		# carrega 97 (valor hex de "a") para t1
  	beq s6,t1,VLCO		# se t0 for igual a 97 (valor hex de "a"), vá para VLCO (verify left colision)
  	
  	li t1,119		# carrega 119 (valor hex de "w") para t1
  	beq s6,t1,VUCO		# se t0 for igual a 119 (valor hex de "w"), vá para VUCO (verify up colision)
  	
  	li t1,115		# carrega 115 (valor hex de "s") para t1
  	beq s6,t1,VDCO		# se t0 for igual a 115 (valor hex de "s"), vá para VDCO (verify down colision)
  	
  	li t1,100  		# carrega 100 (valor hex de "d") para t1
	beq s6,t1,VRCO		# se t0 for igual a 100 (valor hex de "d"), vá para VRCO (verify right colision)
	
	j FIM			# se outra tecla for pressionada, vá para FIM
	
# Verifica a colisao do mapa (VLCO, VUCO, VDCO e VRCO carregam 5 pixels de detecção de colisão em cada direção, e VER verifica se algum desses pixels detectou uma colisão adiante)

#	   @7       @8          @9          @10          @11
#	@6 #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  @12
#	   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  
#	   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  
#	@5 #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  @13
#	   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  
#	   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  
#	@4 #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  @14
#	   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #			# representação do Robozinho 16x16 com "#"
#	   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  			# os "@x" são os pixels de colisão carregados ao redor do Robozinho (o endereço de "@x" é calculado em relação ao endereço em s1, sendo "@22" igual ao próprio s1)
#	@3 #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  @15			# OBS: os pixels de colisão detectam colisões apenas em relação ao mapa desenhado no Frame 1 da memória VGA (mapa de colisão)
#	   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #
#	   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #
#	@2 #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  @16
#	   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #
#	   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #
#	@1 #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  @17
#	   @22(s1)  @21	        @20         @19         @18

# Carrega pixels de colisão a esquerda (@1, @2, @3, @4, @5, @6)

VLCO:   mv t5,s1		# t5 = s1
	addi t5,t5,-321		# volta t5 1 linha e 1 pixel (carrega em t5 o endereço do pixel "@1")
	jal ra, VER		# vá para VER (verifica se o pixel "@1" detectou uma colisão)
			
	addi t5,t5,-1281	# volta t5 4 linhas e 1 pixel (carrega em t5 o endereço do pixel "@2")
	jal ra, VER		# vá para VER (verifica se o pixel "@2" detectou uma colisão)
	
	li t6,-2241		# t6 = -2241
	add t5,t5,t6		# volta t5 7 linhas e 1 pixel (carrega em t5 o endereço do pixel "@3")
	jal ra, VER		# vá para VER (verifica se o pixel "@3" detectou uma colisão)
	
	li t6,-3201		# t6 = -3201
	add t5,t5,t6		# volta t5 10 linhas e 1 pixel (carrega em t5 o endereço do pixel "@4")
	jal ra, VER		# vá para VER (verifica se o pixel "@4" detectou uma colisão)
	
	li t6,-4161		# t6 = -5121
	add t5,t5,t6		# volta t5 13 linhas e 1 pixel (carrega em t5 o endereço do pixel "@5")
	jal ra, VER		# vá para VER (verifica se o pixel "@5" detectou uma colisão)
	
	li t6,-5121		# t6 = -5121
	add t5,t5,t6		# volta t5 16 linhas e 1 pixel (carrega em t5 o endereço do pixel "@6")
	jal ra, VER		# vá para VER (verifica se o pixel "@6" detectou uma colisão)
	
	j DELETE		# se nenhuma colisão foi detectada, vá para DELETE
	
# Carrega pixels de colisão acima (@7, @8, @9, @10, @11)

VUCO:	mv t5,s1		# t5 = s1
	li t6,-5440		# t6 = -5440
	add t5,t5,t6		# volta t5 17 linhas (carrega em t5 o endereço do pixel "@7")
	jal ra, VER		# vá para VER (verifica se o pixel "@7" detectou uma colisão)
	
	li t6,-5437		# t6 = -5437
	add t5,t5,t6		# t5 volta 17 linhas e vai 3 pixels pra frente (carrega em t5 o endereço do pixel "@8")
	jal ra, VER		# vá para VER (verifica se o pixel "@8" detectou uma colisão)
	
	li t6,-5433		# t6 = -5433
	add t5,t5,t6		# t5 volta 17 linhas e vai 7 pixels pra frente (carrega em t5 o endereço do pixel "@9")
	jal ra, VER		# vá para VER (verifica se o pixel "@9" detectou uma colisão)
	
	li t6,-5429		# t6 = -5429
	add t5,t5,t6		# t5 volta 17 linhas e vai 11 pixels pra frente (carrega em t5 o endereço do pixel "@10")
	jal ra, VER		# vá para VER (verifica se o pixel "@10" detectou uma colisão)
	
	li t6,-5425		# t6 = -5425
	add t5,t5,t6		# t5 volta 17 linhas e vai 15 pixels pra frente (carrega em t5 o endereço do pixel "@11")
	jal ra, VER		# vá para VER (verifica se o pixel "@11" detectou uma colisão)
	
	j DELETE		# se nenhuma colisão foi detectada, vá para DELETE
	
# Carrega pixels de colisão abaixo (@22, @21, @20, @19, @18)
 
VDCO:   mv t5,s1		# t5 = s1 (carrega em t5 o endereço do pixel "@22")
	jal ra, VER		# vá para VER (verifica se o pixel "@22" detectou uma colisão)
	
	addi t5,t5,3		# t5 vai 3 pixels pra frente (carrega em t5 o endereço do pixel "@21")
	jal ra, VER		# vá para VER (verifica se o pixel "@21" detectou uma colisão)
	
	addi t5,t5,7		# t5 vai 7 pixels pra frente (carrega em t5 o endereço do pixel "@20")
	jal ra, VER		# vá para VER (verifica se o pixel "@20" detectou uma colisão)
	
	addi t5,t5,11		# t5 vai 11 pixels pra frente (carrega em t5 o endereço do pixel "@19")
	jal ra, VER		# vá para VER (verifica se o pixel "@19" detectou uma colisão)
	
	addi t5,t5,15		# t5 vai 15 pixels pra frente (carrega em t5 o endereço do pixel "@18")
	jal ra, VER		# vá para VER (verifica se o pixel "@18" detectou uma colisão)
	
	j DELETE		# se nenhuma colisão foi detectada, vá para DELETE
	
# Carrega pixels de colisão a direita (@17, @16, @15, @14, @13, @12)
 
VRCO:   mv t5,s1		# t5 = s1
	addi t5,t5,-304		# t5 volta 1 linha e vai 16 pixels pra frente (carrega em t5 o endereço do pixel "@17")
	jal ra, VER		# vá para VER (verifica se o pixel "@17" detectou uma colisão)
	
	addi t5,t5,-1264	# t5 volta 4 linhas e vai 16 pixels pra frente (carrega em t5 o endereço do pixel "@16")
	jal ra, VER 		# vá para VER (verifica se o pixel "@16" detectou uma colisão)
	
	li t6,-2224		# t6 = -2224
	add t5,t5,t6		# t5 volta 7 linhas e vai 16 pixels pra frente (carrega em t5 o endereço do pixel "@15")
	jal ra, VER		# vá para VER (verifica se o pixel "@15" detectou uma colisão)
	
	li t6,-3184		# t6 = -3184
	add t5,t5,t6		# t5 volta 10 linhas e vai 16 pixels pra frente (carrega em t5 o endereço do pixel "@14")
	jal ra, VER		# vá para VER (verifica se o pixel "@14" detectou uma colisão)
	
	li t6,-4144		# t6 = -4144
	add t5,t5,t6		# t5 volta 13 linhas e vai 16 pixels pra frente (carrega em t5 o endereço do pixel "@13")
	jal ra, VER		# vá para VER (verifica se o pixel "@13" detectou uma colisão)
	
	li t6,-5104		# t6 = -5104
	add t5,t5,t6		# t5 volta 16 linhas e vai 16 pixels pra frente (carrega em t5 o endereço do pixel "@12")
	jal ra, VER		# vá para VER (verifica se o pixel "@12" detectou uma colisão)
	
	j DELETE		# se nenhuma colisão foi detectada, vá para DELETE
	
# Verifica se algum dos pixels de colisão detectou alguma colisão
 
VER:	li t6,0x100000		# t6 = 0x100000
	add t5,t5,t6		# soma 0x100000 a t5 (transforma o conteudo de t5 em um endereço do Frame 1)
	lbu t6,0(t5)		# carrega em t6 um byte do endereço t5 (cor do pixel de t5) -> OBS: o load byte deve ser "unsigned" 
				# Ex: 0d200 = 0xc8 = 0b11001000. como o MSB desse byte é 1, ele seria interpretado como -56 e não 200 (t6 = 0xffffffc8)
	li t5,200		# t5 = 200
	beq t6,t5,FIM		# se t6 = 200, vá para FIM (se a cor do pixel for azul, termina a iteração e impede movimento do Robozinho)
	mv t5,s1		# t5 = s1
	ret 			# retorna para verificar se outro pixel detectou colisão
	
# Printa preto em cima da posição do personagem (apaga o personagem anterior)
	
DELETE:	la s0,Robozinho1preto	# carrega a imagem que vai sobrepor o robozinho com pixels pretos
	addi s0,s0,8		# s0 = endereço do primeiro pixel da imagem (depois das informações de nlin ncol)

	li t1,0	
	li t2,16		# reinicia o contador para 16 quebras de linha
	
	li t3, 5120
	sub s1, s1, t3		# volta s1 17 linhas (pixel inicial da primeira linha) 
	sub s2, s2, t3		# volta s2 17 linhas (pixel final da primeira linha)
	
DELLOOP:beq s1,s2,ENTER2	# se s1 atingir o fim da linha de pixels, quebre linha
	lw t0,0(s0)
	sw t0,0(s1)		# escreve a word (4 pixels pretos) na memória VGA
	addi s1,s1,4		# soma 4 ao endereço s1
	addi s0,s0,4		# soma 4 ao endereço s0
	j DELLOOP		# volta a verificar a condiçao do loop
	
ENTER2:	addi s1,s1,304		# s1 pula para o pixel inicial da linha de baixo
	addi s2,s2,320		# s2 pula para o pixel final da linha de baixo
	addi t1,t1,1          	# atualiza o contador de quebras de linha
	beq t1,t2,VERIFY	# termina o carregamento da imagem se 16 quebras de linha ocorrerem
	j DELLOOP		# pula para delloop 
	
# Verifica qual a tecla pressionada para movimentar o Robozinho
	
VERIFY: addi s3,s3,1		# incrementa o contador de estados do Robozinho (se s3 for par -> Robozinho1; se s3 for impar -> Robozinho2)

	li t1,97		# carrega 97 (valor hex de "a") para t1
  	beq s6,t1,MOVLFT	# se t0 for igual a 97 (valor hex de "a"), vá para MOVLFT
  	
  	li t1,119		# carrega 119 (valor hex de "w") para t1
  	beq s6,t1,MOVUP	        # se t0 for igual a 119 (valor hex de "w"), vá para MOVUP
  	
  	li t1,115		# carrega 115 (valor hex de "s") para t1
  	beq s6,t1,MOVDWN	# se t0 for igual a 115 (valor hex de "s"), vá para MOVDWN
  	
  	li t1,100  		# carrega 100 (valor hex de "d") para t1
	beq s6,t1,MOVRGHT	# se t0 for igual a 100 (valor hex de "d"), vá para MOVRGHT
		
# Printa o personagem 4 pixels para frente (move o Robozinho para a direita)	
	
MOVRGHT:li t3, 5116
	sub s1, s1, t3		# volta s1 16 linhas e vai 4 pixels pra frente (pixel inicial + 4) 
	sub s2, s2, t3		# volta s2 16 linhas e vai 4 pixels pra frente (pixel final + 4)
	
	li t1,0
	li t2,16		# reinicia contador para 16 quebras de linha
	
	li t5,2			# t5 = 2 (para verificar a paridade de s3)
	rem t4,s3,t5		# t4 = resto da divisão inteira s3/2
	beq t4,zero,PAR3	# se t4 = 0, va para PAR3 (se s3 for par, imprime o Robozinho1, se for impar, imprime o Robozinho2)
	
	la s0,Robozinho2	# s0 = endereço dos dados do Robozinho2 (boca aberta)
	j NEXT3			# pula para NEXT3
	
PAR3:	la s0,Robozinho1	# s0 = endereço dos dados do Robozinho1 (boca fechada)
	
NEXT3:	addi s0,s0,8		# s0 = endereço do primeiro pixel da imagem (depois das informações de nlin ncol)	
	
LOOP3: 	beq s1,s2,ENTER3	# se s1 atingir o fim da linha de pixels, quebre linha
	lw t0,0(s0)		# le uma word do endereço s0 (le 4 pixels da imagem)
	sw t0,0(s1)		# escreve a word na memória VGA no endereço s1 (desenha 4 pixels na tela do Bitmap Display)
	addi s1,s1,4		# soma 4 ao endereço s1
	addi s0,s0,4		# soma 4 ao endereço s0
	j LOOP3			# volta a verificar a condiçao do loop
	
ENTER3:	addi s1,s1,304		# s1 pula para o pixel inicial da linha de baixo
	addi s2,s2,320		# s2 pula para o pixel final da linha de baixo
	addi t1,t1,1            # reinicia o contador de quebras de linha
	beq t1,t2,FIM		# termine o carregamento da imagem se 16 quebras de linha ocorrerem
	j LOOP3			# pula para loop 3
	
# Printa o personagem 4 linhas para baixo (move o Robozinho para baixo)	
	
MOVDWN: li t3, 3840
	sub s1, s1, t3		# volta s1 12 linhas (pixel inicial 4 linhas abaixo) 
	sub s2, s2, t3		# volta s2 12 linhas (pixel final 4 linhas abaixo)
	
	li t1,0
	li t2,16		# reinicia contador para 16 quebras de linha
		
	li t5,2			# t5 = 2 (para verificar a paridade de s3)
	rem t4,s3,t5		# t4 = resto da divisão inteira s3/2
	beq t4,zero,PAR4	# se t4 = 0, va para PAR4 (se s3 for par, imprime o Robozinho1, se for impar, imprime o Robozinho2)
	
	la s0,Robozinho2	# s0 = endereço dos dados do Robozinho2 (boca aberta)
	j NEXT4			# pula para NEXT4
	
PAR4:	la s0,Robozinho1	# s0 = endereço dos dados do Robozinho1 (boca fechada)
	
NEXT4:	addi s0,s0,8		# s0 = endereço do primeiro pixel da imagem (depois das informações de nlin ncol)
	
LOOP4: 	beq s1,s2,ENTER4	# se s1 atingir o fim da linha de pixels, quebre linha
	lw t0,0(s0)		# le uma word do endereço s0 (le 4 pixels da imagem)
	sw t0,0(s1)		# escreve a word na memória VGA no endereço s1 (desenha 4 pixels na tela do Bitmap Display)
	addi s1,s1,4		# soma 4 ao endereço s1
	addi s0,s0,4		# soma 4 ao endereço s0
	j LOOP4			# volta a verificar a condiçao do loop
	
ENTER4:	addi s1,s1,304		# s1 pula para o pixel inicial da linha de baixo
	addi s2,s2,320		# s2 pula para o pixel final da linha de baixo
	addi t1,t1,1            # reinicia o contador de quebras de linha
	beq t1,t2,FIM		# termine o carregamento da imagem se 16 quebras de linha ocorrerem
	j LOOP4			# pula para loop 4

# Printa o personagem 4 linhas para cima (move o Robozinho para cima)	
	
MOVUP:  li t3, 6400
	sub s1, s1, t3	# volta s1 20 linhas (pixel inicial 4 linhas acima) 
	sub s2, s2, t3	# volta s2 20 linhas (pixel final 4 linhas acima)
	
	li t1,0
	li t2,16		# reinicia contador para 16 quebras de linha
		
	li t5,2			# t5 = 2 (para verificar a paridade de s3)
	rem t4,s3,t5		# t4 = resto da divisão inteira s3/2
	beq t4,zero,PAR5	# se t4 = 0, va para PAR5 (se s3 for par, imprime o Robozinho1, se for impar, imprime o Robozinho2)
	
	la s0,Robozinho2	# s0 = endereço dos dados do Robozinho2 (boca aberta)
	j NEXT5			# pula para NEXT5
	
PAR5:	la s0,Robozinho1	# s0 = endereço dos dados do Robozinho1 (boca fechada)
	
NEXT5:	addi s0,s0,8		# s0 = endereço do primeiro pixel da imagem (depois das informações de nlin ncol)	
	
LOOP5: 	beq s1,s2,ENTER5	# se s1 atingir o fim da linha de pixels, quebre linha
	lw t0,0(s0)		# le uma word do endereço s0 (le 4 pixels da imagem)
	sw t0,0(s1)		# escreve a word na memória VGA no endereço s1 (desenha 4 pixels na tela do Bitmap Display)
	addi s1,s1,4		# soma 4 ao endereço s1
	addi s0,s0,4		# soma 4 ao endereço s0
	j LOOP5 		# volta a verificar a condiçao do loop
	
ENTER5:	addi s1,s1,304		# s1 pula para o pixel inicial da linha de baixo
	addi s2,s2,320		# s2 pula para o pixel final da linha de baixo
	addi t1,t1,1            # reinicia o contador de quebras de linha
	beq t1,t2,FIM		# termine o carregamento da imagem se 16 quebras de linha ocorrerem
	j LOOP5 		# pula para loop 5
	
# Printa o personagem 4 pixels para a esquerda (move o Robozinho para a esquerda)	
	
MOVLFT: li t3, 5124
	sub s1, s1, t3	        # volta s1 16 linhas e vai 4 pixels pra esquerda (pixel inicial - 4) 
	sub s2, s2, t3	        # volta s2 16 linhas e vai 4 pixels pra esquerda (pixel final - 4)  
	
	li t1,0
	li t2,16		# reinicia contador para 16 quebras de linha
		
	li t5,2			# t5 = 2 (para verificar a paridade de s3)
	rem t4,s3,t5		# t4 = resto da divisão inteira s3/2
	beq t4,zero,PAR6	# se t4 = 0, va para PAR6 (se s3 for par, imprime o Robozinho1, se for impar, imprime o Robozinho2)
	
	la s0,Robozinho2	# s0 = endereço dos dados do Robozinho2 (boca aberta)
	j NEXT6			# pula para NEXT6
	
PAR6:	la s0,Robozinho1	# s0 = endereço dos dados do Robozinho1 (boca fechada)
	
NEXT6:	addi s0,s0,8		# s0 = endereço do primeiro pixel da imagem (depois das informações de nlin ncol)	
	
LOOP6: 	beq s1,s2,ENTER6	# se s1 atingir o fim da linha de pixels, quebre linha
	lw t0,0(s0)		# le uma word do endereço s0 (le 4 pixels da imagem)
	sw t0,0(s1)		# escreve a word na memória VGA no endereço s1 (desenha 4 pixels na tela do Bitmap Display)
	addi s1,s1,4		# soma 4 ao endereço s1
	addi s0,s0,4		# soma 4 ao endereço s0
	j LOOP6			# volta a verificar a condiçao do loop
	
ENTER6:	addi s1,s1,304		# s1 pula para o pixel inicial da linha de baixo
	addi s2,s2,320		# s2 pula para o pixel final da linha de baixo
	addi t1,t1,1            # reinicia o contador de quebras de linha
	beq t1,t2,FIM		# termine o carregamento da imagem se 16 quebras de linha ocorrerem
	j LOOP6			# pula para loop 6
	
FIM:	li a0,80		
	li a7,32
	ecall			# serviço 32 do ecall (sleep - a proxima iteraçao demora 50 milissegundos para acontecer)
	
	j MAINL			# retorna ao loop principal
