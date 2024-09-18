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
#########################################################################

.include "../System/MACROSv24.s" 		# permite a utilizaÃ§Ã£o dos ecalls "1xx"
	
.data			

# Dados das notas da musica tocada no menu principal do jogo

# Numero de Notas a tocar

NUM: .word 64
NUM2: .word 16 

# lista de nota,duraÃ§Ã£o,nota,duraÃ§Ã£o,nota,duraÃ§Ã£o,...

NOTAS: 66, 230, 61, 230, 78, 230, 61, 230, 73, 230, 61, 230, 76, 230, 78, 230, 73, 230, 76, 230, 73, 230, 76, 230, 78, 230, 61, 230, 78, 230, 61, 230, 76, 230, 64, 230, 71, 230, 62, 230, 71, 230, 64, 230, 73, 230, 76, 230, 73, 230, 71, 230, 73, 230, 61, 230, 73, 230, 61, 230, 73, 230, 61, 230, 69, 230, 64, 230, 66, 230, 61, 230, 57, 230, 61, 230, 57, 230, 61, 230, 69, 230, 64, 230, 66, 230, 61, 230, 57, 230, 61, 230, 76, 230, 78, 230, 73, 230, 71, 230, 73, 230, 57, 230, 73, 230, 57, 230, 64, 230, 57, 230, 73, 230, 57, 230, 73, 230, 57, 230, 64, 230, 57, 230, 73, 230, 57, 230 
NOTAS2: 42, 923, 49, 923, 42, 923, 49, 923, 44, 923, 52, 923, 45, 923, 49, 923, 42, 923, 49, 923, 42, 923, 49, 923, 45, 923, 52, 923, 45, 923, 52, 923 

# Dados diversos (strings para HUD, posiÃ§Ãµes dos personagens no bitmap display, etc)

STR: .string "PONTOS: "
STR2: .string "VIDAS: "
STR3: .string "+200"
STR4: .string "    "

POS_ROBOZINHO: .word 0xFF00B4C8 # endereco inicial da linha diretamente abaixo do Robozinho - posiÃ§Ã£o inicial/atual do Robozinho
POS_BLINKY: .word 0xFF0078C8	# coordenada inicial do alien verde claro (blinky)
POS_PINK: .word 0xFF009BC8	# coordenada inicial do alien azul (pink)
POS_INKY: .word 0xFF009BB8	# coordenada inicial do alien roxo (inky)
POS_CLYDE: .word 0xFF009BD8	# coordenada inicial do alien laranja (clyde)

CONTADOR_ASSUSTADO: .word -1

PONTOS: .word 0

# inclusÃ£o das imagens 

.include "../DATA/mapa1.data"
.include "../DATA/mapa1colisao.data"
.include "../DATA/mapa2.data"
.include "../DATA/mapa2colisao.data"
.include "../DATA/menuprincipal.data"
.include "../DATA/telawin.data"
.include "../DATA/telalose.data"
.include "../DATA/Robozinho1.data"
.include "../DATA/Robozinho2.data"
.include "../DATA/Robozinho1forte.data"
.include "../DATA/Robozinho2forte.data"
.include "../DATA/Robozinho1preto.data"
.include "../DATA/Inimigo1.data"
.include "../DATA/Inimigo2.data"
.include "../DATA/Inimigo3.data"
.include "../DATA/Inimigo4.data"
.include "../DATA/InimigoAssustado.data"
.include "../DATA/horpoint.data"
.include "../DATA/vertpoint.data"

.text

#Carrega o menu principal
	
	li s1,0xFF000000	# s1 = endereco inicial da Memoria VGA - Frame 0
	li s2,0xFF012C00	# s2 = endereco final da Memoria VGA - Frame 0
	la s0,menuprincipal	# s0 = endereÃƒÂ§o dos dados do mapa 1
	addi s0,s0,8		# s0 = endereÃƒÂ§o do primeiro pixel da imagem (depois das informaÃƒÂ§ÃƒÂµes de nlin ncol)
	
LOOPM: 	beq s1,s2,LOOPMEN	# se s1 = ultimo endereÃƒÂ§o da Memoria VGA, saia do loop
	lw t0,0(s0)		# le uma word do endereÃƒÂ§o s0 (le 4 pixels da imagem)
	sw t0,0(s1)		# escreve a word na memoria VGA no endereÃƒÂ§o s1 (desenha 4 pixels na tela do Bitmap Display)
	addi s1,s1,4		# soma 4 ao endereÃƒÂ§o s1 
	addi s0,s0,4		# soma 4 ao endereÃƒÂ§o s0
	j LOOPM			# volta a verificar a condiÃƒÂ§ao do loop
	
LOOPMEN:la s0, NUM       	# define o endereÃ§o do nÃºmero de notas
    	lw s1, 0(s0)     	# le o numero de notas
    	la s0, NOTAS     	# define o endereÃ§o das notas
    	li t0, 0         	# zera o contador de notas

   	la s2, NUM2      	# define o endereÃ§o do nÃºmero de notas2
    	lw s3, 0(s2)     	# le o numero de notas2
    	la s2, NOTAS2    	# define o endereÃ§o de notas2
    	li t1, 0         	# zera o contador de notas2

    	li a2, 32        	# define o instrumento para notas (Guitar Harmonics)
    	li a4, 128      	# define o instrumento para notas2 
    	li a3, 50       	# define o volume para notas
    	li s4, 0	     	# 16 para contagem de notas2

# Toca uma nota de NOTAS2

DOIS:	lw a6, 0(s2)     	# le o valor da segunda nota
    	lw a7, 4(s2)     	# le a duracao da segunda nota
	mv a0, a6        	# move valor da segunda nota para a0
    	mv a1, a7        	# move duracao da segunda nota para a1
    	li a7, 31        	# define a chamada de syscall para tocar nota
    	ecall            	# toca a segunda nota
    
   	addi s4, s4, 4  	# zera o contador de notas2
   	addi s2, s2, 8   	# incrementa para o endereÃ§o da prÃ³xima nota
   	addi t1, t1, 1   	# incrementa o contador de notas

LOOP:   li t2,0xFF200000	# carrega o endereÃƒÂ§o de controle do KDMMIO ("teclado")
	lw t0,0(t2)		# le uma word a partir do endereÃƒÂ§o de controle do KDMMIO
	andi t0,t0,0x0001	# mascara todos os bits de t0 com exceÃƒÂ§ao do bit menos significativo
   	bne t0,zero,IMG1   	# se o BMS de t0 nÃƒÂ£o for 0 (hÃƒÂ¡ tecla pressionada), pule para MAPA1
   	
 	beq t0, s4, DOIS    	# se o contador2 chegou em 16, vÃ¡ para DOIS
    
# Toca uma nota de NOTAS

    	lw a0, 0(s0)        	# le o valor da nota
   	lw a1, 4(s0)        	# le a duracao da nota
   	li a7, 31           	# define a chamada de syscall para tocar nota
    	ecall               	# toca a nota

# Pausa pela duraÃ§Ã£o da nota

    	addi a1, a1, -5	    	# reduzir a pausa pra evitar pausa abrupta nas notas
   	mv a0, a1           	# move duracao da nota para a pausa
  	li a7, 32           	# define a chamada de syscal para pausa
   	ecall               	# realiza uma pausa de a0 ms

   	addi s0, s0, 8      	# incrementa para o endereÃ§o da prÃ³xima nota
   	addi t0, t0, 1      	# incrementa o contador de notas
   	 
   	j LOOP		    	# pule para LOOP
	
# Carrega a imagem1 (mapa1) no frame 0
	
IMG1:	la t4, mapa1		# t4 cerrega endereÃƒÂ§o do mapa a fim de comparaÃƒÂ§ÃƒÂ£o
	li s1,0xFF000000	# s1 = endereco inicial da Memoria VGA - Frame 0
	li s2,0xFF012C00	# s2 = endereco final da Memoria VGA - Frame 0
	la s0,mapa1		# s0 = endereÃƒÂ§o dos dados do mapa 1
	mv t3, s0		# t3 = endereÃƒÂ§o inicial armazenado a fins de comparaÃƒÂ§ÃƒÂ£o
	addi s0,s0,8		# s0 = endereÃƒÂ§o do primeiro pixel da imagem (depois das informaÃƒÂ§ÃƒÂµes de nlin ncol)
	
LOOP1: 	beq s1,s2,IMAGEM	# se s1 = ÃƒÂºltimo endereÃƒÂ§o da Memoria VGA, saia do loop
	lw t0,0(s0)		# le uma word do endereÃƒÂ§o s0 (le 4 pixels da imagem)
	sw t0,0(s1)		# escreve a word na memÃƒÂ³ria VGA no endereÃƒÂ§o s1 (desenha 4 pixels na tela do Bitmap Display)
	addi s1,s1,4		# soma 4 ao endereÃƒÂ§o s1 
	addi s0,s0,4		# soma 4 ao endereÃƒÂ§o s0
	j LOOP1			# volta a verificar a condiÃƒÂ§ao do loop

# Carrega a imagem2 (Robozinho1 - imagem 16x16) no frame 0

IMG2:	li s1,0xFF00A0C8	# s1 = endereco inicial da primeira linha do Robozinho - Frame 0
	li s2,0xFF00A0D8	# s2 = endereco final da primeira linha do Robozinho (inicial +16) - Frame 0
	la s0,Robozinho1	# s0 = endereÃƒÂ§o dos dados do Robozinho1 (boca fechada)
	mv t3, s0		# t3 = endereÃƒÂ§o inicial armazenado a fins de comparaÃƒÂ§ÃƒÂ£o
	addi s0,s0,8		# s0 = endereÃƒÂ§o do primeiro pixel da imagem (depois das informaÃƒÂ§ÃƒÂµes de nlin ncol)
	j PRINT16
	
# Carrega a imagem3 (ALIEN1 - imagem16x16)

IMG3:	li s1,0xFF0064C8	# s1 = endereco inicial da primeira linha do alien 1 - Frame 0 
	li s2,0xFF0064D8	# s2 = endereco final da primeira linha do alien 1 (inicial +16) - Frame 0      
	la s0,Inimigo1          # s0 = endereÃƒÂ§o dos dados do alien1
	mv t3, s0		# t3 = endereÃƒÂ§o inicial armazenado a fins de comparaÃƒÂ§ÃƒÂ£o
	addi s0,s0,8		# s0 = endereÃƒÂ§o do primeiro pixel da imagem (depois das informaÃƒÂ§ÃƒÂµes de nlin ncol)
	j PRINT16
	
# Carrega a imagem4 (ALIEN2 - imagem16x16)

IMG4:	li s1,0xFF0087C8	# s1 = endereco inicial da primeira linha do alien 2 - Frame 0
	li s2,0xFF0087D8	# s2 = endereco final da primeira linha do alien 2 - Frame 0
	la s0,Inimigo2          # s0 = endereÃƒÂ§o dos dados do alien2
	mv t3, s0		# t3 = endereÃƒÂ§o inicial armazenado a fins de comparaÃƒÂ§ÃƒÂ£o
	addi s0,s0,8		# s0 = endereÃƒÂ§o do primeiro pixel da imagem (depois das informaÃƒÂ§ÃƒÂµes de nlin ncol)
	j PRINT16

# Carrega a imagem5 (ALIEN3 - imagem16x16)

IMG5:	li s1,0xFF0087B8	# s1 = endereco inicial da primeira linha do alien 3 - Frame 0
	li s2,0xFF0087C8	# s2 = endereco final da primeira linha do alien 3 - Frame 0
	la s0,Inimigo3          # s0 = endereÃƒÂ§o dos dados do alien3
	mv t3, s0		# t3 = endereÃƒÂ§o inicial armazenado a fins de comparaÃƒÂ§ÃƒÂ£o
	addi s0,s0,8		# s0 = endereÃƒÂ§o do primeiro pixel da imagem (depois das informaÃƒÂ§ÃƒÂµes de nlin ncol)
	j PRINT16
	
# Carrega a imagem6 (ALIEN4 - imagem16x16)

IMG6:	li s1,0xFF0087D8	# s1 = endereco inicial da primeira linha do alien 4 - Frame 0
	li s2,0xFF0087E8	# s2 = endereco final da primeira linha do alien 4 - Frame 0
	la s0, Inimigo4         # s0 = endereÃƒÂ§o dos dados do alien4 
	mv t3, s0		# t3 = endereÃƒÂ§o inicial armazenado a fins de comparaÃƒÂ§ÃƒÂ£o
	addi s0,s0,8		# s0 = endereÃƒÂ§o do primeiro pixel da imagem (depois das informaÃƒÂ§ÃƒÂµes de nlin ncol)
	j PRINT16
	
# Carrega a imagem7 (mapa1 - colisao) no frame 1
	
IMG7:	li s1,0xFF100000	# s1 = endereco inicial da Memoria VGA - Frame 1
	li s2,0xFF112C00	# s2 = endereco final da Memoria VGA - Frame 1
	la s0,mapa1colisao	# s0 = endereÃƒÂ§o dos dados da colisao do mapa 1
	mv t3, s0		# t3 = endereÃƒÂ§o inicial armazenado a fins de comparaÃƒÂ§ÃƒÂ£o
	addi s0,s0,8		# s0 = endereÃƒÂ§o do primeiro pixel da imagem (depois das informaÃƒÂ§ÃƒÂµes de nlin ncol)
	
LOOPCOL:beq s1,s2,IMAGEM	# se s1 = ÃƒÂºltimo endereÃƒÂ§o da Memoria VGA, saia do loop
	lw t0,0(s0)		# le uma word do endereÃƒÂ§o s0 (le 4 pixels da imagem)
	sw t0,0(s1)		# escreve a word na memÃƒÂ³ria VGA no endereÃƒÂ§o s1 (desenha 4 pixels na tela do Bitmap Display)
	addi s1,s1,4		# soma 4 ao endereÃƒÂ§o s1 
	addi s0,s0,4		# soma 4 ao endereÃƒÂ§o s0
	j LOOPCOL		# volta a verificar a condiÃƒÂ§ao do loop
	
# Carrega a imagem6 (Robozinho - imagem16x16)

IMG8:	li s1,0xFF10A0C8	# s1 = endereco inicial da primeira linha do alien 4 - Frame 0
	li s2,0xFF10A0D8	# s2 = endereco final da primeira linha do alien 4 - Frame 0
	li s0,0x69696969        # s0 = endereÃƒÂ§o dos dados do alien4 
	mv t3, s0		# t3 = endereÃƒÂ§o inicial armazenado a fins de comparaÃƒÂ§ÃƒÂ£o
	j PRINT16_Q
	
# Carrega a imagem6 (ALIEN1 - imagem16x16)

IMG9:	li s1,0xFF1064C8	# s1 = endereco inicial da primeira linha do alien 4 - Frame 0
	li s2,0xFF1064D8	# s2 = endereco final da primeira linha do alien 4 - Frame 0
	li s0,0x70707070       	# s0 = endereÃƒÂ§o dos dados do alien4 
	mv t3, s0		# t3 = endereÃƒÂ§o inicial armazenado a fins de comparaÃƒÂ§ÃƒÂ£o
	j PRINT16_Q

# Carrega a imagem6 (ALIEN4 - imagem16x16)

IMG10:	li s1,0xFF1087C8	# s1 = endereco inicial da primeira linha do alien 4 - Frame 0
	li s2,0xFF1087D8	# s2 = endereco final da primeira linha do alien 4 - Frame 0
	li s0,0x71717171        # s0 = endereÃƒÂ§o dos dados do alien4 
	mv t3, s0		# t3 = endereÃƒÂ§o inicial armazenado a fins de comparaÃƒÂ§ÃƒÂ£o
	j PRINT16_Q

# Carrega a imagem6 (ALIEN4 - imagem16x16)

IMG11:	li s1,0xFF1087B8	# s1 = endereco inicial da primeira linha do alien 4 - Frame 0
	li s2,0xFF1087C8	# s2 = endereco final da primeira linha do alien 4 - Frame 0
	li s0,0x72727272        # s0 = endereÃƒÂ§o dos dados do alien4 
	mv t3, s0		# t3 = endereÃƒÂ§o inicial armazenado a fins de comparaÃƒÂ§ÃƒÂ£o
	j PRINT16_Q

# Carrega a imagem6 (ALIEN4 - imagem16x16)

IMG12:	li s1,0xFF1087D8	# s1 = endereco inicial da primeira linha do alien 4 - Frame 0
	li s2,0xFF1087E8	# s2 = endereco final da primeira linha do alien 4 - Frame 0
	li s0,0x73737373        # s0 = endereÃƒÂ§o dos dados do alien4 
	mv t3, s0		# t3 = endereÃƒÂ§o inicial armazenado a fins de comparaÃƒÂ§ÃƒÂ£o
	j PRINT16_Q
	
# Compara os endereÃƒÂ§os para ver qual a proxima imagem a ser printada

IMAGEM: beq t3, t4, IMG2 	# se t3 contiver o endereÃƒÂ§o "mapa1", vÃƒÂ¡ para IMG2 (imprime a imagem2)
	
	la t4, Robozinho1	# t4 = endereÃƒÂ§o dos dados do Robozinho1
	beq t3, t4, IMG3	# se t3 contiver o endereÃƒÂ§o "Robozinho1", vÃƒÂ¡ para IMG3 (imprime a imagem3)
	
	la t4, Inimigo1		# t4 = endereÃƒÂ§o dos dados do alien 1
	beq t3, t4, IMG4	# se t3 contiver o endereÃƒÂ§o "Inimigo1", vÃƒÂ¡ para IMG4 (imprime a imagem4)
	
	la t4, Inimigo2		# t4 = endereÃƒÂ§o dos dados do alien 2
	beq t3, t4, IMG5	# se t3 contiver o endereÃƒÂ§o "Inimigo2", vÃƒÂ¡ para IMG5 (imprime a imagem5)
	
	la t4, Inimigo3		# t4 = endereÃƒÂ§o dos dados do alien 3
	beq t3, t4, IMG6	# se t3 contiver o endereÃƒÂ§o "Inimigo3", vÃƒÂ¡ para IMG6 (imprime a imagem6)
	
	la t4, Inimigo4		# t4 = endereÃƒÂ§o dos dados do alien 4
	beq t3, t4, IMG7	# se t3 contiver o endereÃƒÂ§o "Inimigo4", vÃƒÂ¡ para IMG7 (imprime a imagem7)
	
	la t4, mapa1colisao
	beq t3, t4, IMG8	# se t3 contiver o endereÃƒÂ§o "Inimigo4", vÃƒÂ¡ para IMG7 (imprime a imagem7)
	
	li t4, 0x69696969
	beq t3, t4, IMG9	# se t3 contiver o endereÃƒÂ§o "Inimigo4", vÃƒÂ¡ para IMG7 (imprime a imagem7)
	
	li t4, 0x70707070
	beq t3, t4, IMG10	# se t3 contiver o endereÃƒÂ§o "Inimigo4", vÃƒÂ¡ para IMG7 (imprime a imagem7)
	
	li t4, 0x71717171
	beq t3, t4, IMG11	# se t3 contiver o endereÃƒÂ§o "Inimigo4", vÃƒÂ¡ para IMG7 (imprime a imagem7)
	
	li t4, 0x72727272
	beq t3, t4, IMG12	# se t3 contiver o endereÃƒÂ§o "Inimigo4", vÃƒÂ¡ para IMG7 (imprime a imagem7)
	
	li t4, 0x73737373
	beq t3, t4, SETUP_MAIN	# se t3 contiver o endereÃƒÂ§o "Inimigo4", vÃƒÂ¡ para IMG7 (imprime a imagem7)
	
# Loop que imprime imagens 16x16

PRINT16:li t1,0
	li t2,16		#inicializa o contador de quebra de linha para 16 quebras de linha
	
LOOP2: 	beq s1,s2,ENTER		# se s1 atingir o fim da linha de pixels, quebre linha
	lw t0,0(s0)		# le uma word do endereÃƒÂ§o s0 (le 4 pixels da imagem)
	sw t0,0(s1)		# escreve a word na memÃƒÂ³ria VGA no endereÃƒÂ§o s1 (desenha 4 pixels na tela do Bitmap Display)
	addi s1,s1,4		# soma 4 ao endereÃƒÂ§o s1
	addi s0,s0,4		# soma 4 ao endereÃƒÂ§o s0
	j LOOP2 		# volta a verificar a condiÃƒÂ§ao do loop
	
ENTER:	addi s1,s1,304		# s1 pula para o pixel inicial da linha de baixo
	addi s2,s2,320		# s2 pula para o pixel final da linha de baixo
	addi t1,t1,1          	# atualiza o contador de quebras de linha
	beq t1,t2,IMAGEM	# termina o carregamento da imagem se 17 quebras de linha ocorrerem
	j LOOP2	
	
# Loop que imprime quadrados 16x16

PRINT16_Q:
	li t1,0
	li t2,16		#inicializa o contador de quebra de linha para 16 quebras de linha
	
LOOP2Q: beq s1,s2,ENTERQ	# se s1 atingir o fim da linha de pixels, quebre linha
	sw s0,0(s1)		# escreve a word na memÃƒÂ³ria VGA no endereÃƒÂ§o s1 (desenha 4 pixels na tela do Bitmap Display)
	addi s1,s1,4		# soma 4 ao endereÃƒÂ§o s1
	j LOOP2Q 		# volta a verificar a condiÃƒÂ§ao do loop
	
ENTERQ:	addi s1,s1,304		# s1 pula para o pixel inicial da linha de baixo
	addi s2,s2,320		# s2 pula para o pixel final da linha de baixo
	addi t1,t1,1          	# atualiza o contador de quebras de linha
	beq t1,t2,IMAGEM	# termina o carregamento da imagem se 17 quebras de linha ocorrerem
	j LOOP2Q
	
# Setup dos dados necessarios para o main loop

SETUP_MAIN:

	li s0,2			# s0 = 0 (zera o contador de movimentaÃ§Ãµes do Robozinho)
	li s1,0			# s1 = 0 (zera o contador de pontos coletados)
	li s2,3			# s2 = 3 (inicializa o contador de vidas do Robozinho com 3)
	li s3,0			# s3 = 0 (zera o estado de movimentaÃ§Ã£o atual do Robozinho)
	li s5,0			# s5 = 0 (zera o estado de persrguiÃ§Ã£o dos aliens)
	li s6,1			# s6 = 1 (fase 1)
	li s7,0			# s7 = 0 (zera o verificador de aliens)
	li s4,17		# s4 = 17 (zera o estado de movimentaÃ§Ã£o atual do inimigo1 : chase_mode)
	li s9,17		# s9 = 17 (zera o estado de movimentaÃ§Ã£o atual do inmimigo2 : chase_mode)
	li s10,17 		# s10 = 17 (zera o estado de movimentaÃ§Ã£o atual do inimigo3 : chase_mode)
	li s11,17 		# s11 = 17 (zera o estado de movimentaÃ§Ã£o atual do inimigo4 : chase_mode)
	
# Loop principal do jogo (mostra pontuaÃ§Ã£o na tela e verifica se ha teclas de movimentaÃ§Ã£o pressionadas)

MAINL:
	
ALIENS:
	#formula base para cÃ¡lculo de posiÃ§Ã£o: (endereÃ§o - 0xFF000000)/320 = linha(y), (endereÃ§o - 0xFF000000)%320 = coluna(x)
	
# Setup dos dados do alien verde claro (blinky)

BLINKY:	li s7,1			# s7 = 1 (salva em s7 a informaÃ§Ã£o de qual alien esta sendo movimentado)

	la t0,POS_BLINKY	# carrega o endereÃ§o de "POS_BLINKY" no registrador t0
	lw t1,0(t0)		# le a word guardada em "POS_BLINKY" para t1 (t1 = posiÃ§Ã£o atual do Blinky)
	
	li t3, 0xFF000000	# t3 = endereÃ§o base do Bitmap Display 
	li t4, 320		# t4 = nÃºmero de colunas da tela
	
	sub t1, t1, t3		# subtrai de t1 o endereÃ§o base
	mv t2, t1		# carrega em t2 o valor de t1 (posiÃ§Ã£o do alien sem o endereÃ§o base)
	rem t1, t1, t4		# t1 = posiÃ§Ã£o x do alien (coluna do pixel de posiÃ§Ã£o)
	div t2, t2, t4		# t2 = posiÃ§Ã£o y do alien (linha do pixel de posiÃ§Ã£o)
	
	mv a0, t1		# a0 = t1 (parametro da funÃ§ao CALCULO_TARGET)
	mv a1, t2		# a1 = t2 (parametro da funÃ§ao CALCULO_TARGET)
	mv a2, s4		# a2 = s4 (parametro da funÃ§ao CALCULO_TARGET)
	
	j CALCULO_TARGET 	# Pula para CALCULO_TARGET
	
# Setup dos dados do alien azul (pink)

PINK:	li s7,2			# s7 = 2 (salva em s7 a informaÃ§Ã£o de qual alien esta sendo movimentado)

	la t0,POS_PINK		# carrega o endereÃ§o de "POS_PINK" no registrador t0
	lw t1,0(t0)		# le a word guardada em "POS_PINK" para t1 (t1 = posiÃ§Ã£o atual do Pink)
	
	li t3, 0xFF000000	# t3 = endereÃ§o base do Bitmap Display 
	li t4, 320		# t4 = nÃºmero de colunas da tela
	
	sub t1, t1, t3		# subtrai de t1 o endereÃ§o base
	mv t2, t1		# carrega em t2 o valor de t1 (posiÃ§Ã£o do alien sem o endereÃ§o base)
	rem t1, t1, t4		# t1 = posiÃ§Ã£o x do alien (coluna do pixel de posiÃ§Ã£o)
	div t2, t2, t4		# t2 = posiÃ§Ã£o y do alien (linha do pixel de posiÃ§Ã£o)
	
	mv a0, t1		# a0 = t1 (parametro da funÃ§ao CALCULO_TARGET)
	mv a1, t2		# a1 = t2 (parametro da funÃ§ao CALCULO_TARGET)
	mv a2, s9		# a2 = s4 (parametro da funÃ§ao CALCULO_TARGET)
	
	j CALCULO_TARGET 	# Pula para CALCULO_TARGET
	
# Setup dos dados do alien roxo (inky)

INKY:	li s7,3			# s7 = 3 (salva em s7 a informaÃ§Ã£o de qual alien esta sendo movimentado)

	la t0,POS_INKY		# carrega o endereÃ§o de "POS_INKY" no registrador t0
	lw t1,0(t0)		# le a word guardada em "POS_INKY" para t1 (t1 = posiÃ§Ã£o atual do Inky)
	
	li t3, 0xFF000000	# t3 = endereÃ§o base do Bitmap Display 
	li t4, 320		# t4 = nÃºmero de colunas da tela
	
	sub t1, t1, t3		# subtrai de t1 o endereÃ§o base
	mv t2, t1		# carrega em t2 o valor de t1 (posiÃ§Ã£o do alien sem o endereÃ§o base)
	rem t1, t1, t4		# t1 = posiÃ§Ã£o x do alien (coluna do pixel de posiÃ§Ã£o)
	div t2, t2, t4		# t2 = posiÃ§Ã£o y do alien (linha do pixel de posiÃ§Ã£o)
	
	mv a0, t1		# a0 = t1 (parametro da funÃ§ao CALCULO_TARGET)
	mv a1, t2		# a1 = t2 (parametro da funÃ§ao CALCULO_TARGET)
	mv a2, s10		# a2 = s4 (parametro da funÃ§ao CALCULO_TARGET)
	
	
	j CALCULO_TARGET 	# Pula para CALCULO_TARGET
	
# Setup dos dados do alien laranja (clyde)

CLYDE:	li s7,4			# s7 = 4 (salva em s7 a informaÃ§Ã£o de qual alien esta sendo movimentado)

	la t0,POS_CLYDE		# carrega o endereÃ§o de "POS_CLYDE" no registrador t0
	lw t1,0(t0)		# le a word guardada em "POS_CLYDE" para t1 (t1 = posiÃ§Ã£o atual do Clyde)
	
	li t3, 0xFF000000	# t3 = endereÃ§o base do Bitmap Display 
	li t4, 320		# t4 = nÃºmero de colunas da tela
	
	sub t1, t1, t3		# subtrai de t1 o endereÃ§o base
	mv t2, t1		# carrega em t2 o valor de t1 (posiÃ§Ã£o do alien sem o endereÃ§o base)
	rem t1, t1, t4		# t1 = posiÃ§Ã£o x do alien (coluna do pixel de posiÃ§Ã£o)
	div t2, t2, t4		# t2 = posiÃ§Ã£o y do alien (linha do pixel de posiÃ§Ã£o)
	
	mv a0, t1		# a0 = t1 (parametro da funÃ§ao CALCULO_TARGET)
	mv a1, t2		# a1 = t2 (parametro da funÃ§ao CALCULO_TARGET)
	mv a2, s11		# a2 = s4 (parametro da funÃ§ao CALCULO_TARGET)
	
	j CALCULO_TARGET 	# pula para CALCULO_TARGET
	
# FunÃ§Ã£o que calcula o target do alien com relaÃ§Ã£o a posiÃ§Ã£o do Robozinho
# Calculo de distancia: distancia de manhattan : (|x_alien - x_target|) + (|y_alien - y_target|)

#dependendo do estado do jogo o fantasma irÃ¡ para o scatter(Sx < 21), chase(Sx < 38), ou frightened mode(Sx < 55)

CALCULO_TARGET:

	li t0, 179		 	# troca de modos a cada 20 segundos
	rem t1, s0, t0			# t1 = s0%179
	beq t1, zero, TROCAR_MODO  	# se t1 der 0, troca o modo
	
	li t0, 21		 	# t0 = 21
	blt a2, t0, SCATTER_MODE 	# se a2(Sx) < 21, estÃ¡ no scatter mode
	li t0, 38
	blt a2, t0, CHASE_MODE	 	# se a2(Sx) < 38, estÃ¡ no chase mode
	li t0, 55
	blt a2, t0, FRIGHTENED_VERIF	 # se a2(Sx) < 55, estÃ¡ no frightened mode
	li t0, 72
	blt a2, t0, DEATH_MODE		# se a2(Sx) < 72, estÃ£ no death mode
	
TROCAR_MODO:

	li t0, 21		 	# t0 = 21
	blt a2, t0, CHASE_MODE   	# se a2(Sx) < 21, estÃ¡ no scatter mode, entÃ£o vamos para o chase_mode(MUDARDEPOIS)
	li t0, 38
	blt a2, t0, SCATTER_MODE 	# se a2(Sx) < 38, estÃ¡ no chase mode, entÃ£o vamos para o scatter_mode
	li t0, 58	
	blt a2, t0, FRIGHTENED_VERIF    # se a2(Sx) < 38, estÃ¡ no frightened mode, entÃ£o nÃ£o muda
	li t0, 72	
	blt a2, t0, DEATH_MODE		# se a2(Sx) < 72, estÃ¡ no death mode, entÃ£o nÃ£o muda
	
FRIGHTENED_VERIF:

	la t0, CONTADOR_ASSUSTADO	# carrega o valor de "CONTADOR_ASSUSTADO" no registrador t0	
	lw t1, 0(t0)			# le a word guardada em "CONTADOR_ASSUSTADO" para t1 (t1 = contador do tempo no frightened_mode)
	
	li t2, 400			# seta para o loop durar 8 segundos
	blt t1, t2, FRIGHTENED_MODE	# se for menor que 200, continua no frightened mode
	
	li t1, -1			# t1 = -1
	sw t1, 0(t0)			# reseta o contador_assustado = -1
	
	li t0, 17			# t0 = 17
	rem t1, s4, t0			# t1 = s4%17
	li s4, 34			# reseta s4 para o chase_mode
	add s4, s4, t1			# e atualiza o mivimento dele anterior 
	
	rem t1, s9, t0			# t1 = s9%17
	li s9, 34			# reseta s9 para o chase_mode
	add s9, s9, t1			# e atualiza o mivimento dele anterior 
	
	rem t1, s10, t0			# t1 = s10%17
	li s10, 34			# reseta s10 para o chase_mode
	add s10, s10, t1		# e atualiza o mivimento dele anterior 
	
	rem t1, s11, t0			# t1 = s11%17
	li s11, 34			# reseta s11 para o chase_mode
	add s11, s11, t1		# e atualiza o mivimento dele anterior 
	
	li s0, 2			# reseta o contador s0 para temporizar certo o chase_mode
	
	j CHASE_MODE			# volta para o chase_mode
	
# Inicia o scatter/chase mode e verifica qual e o alien a ser movimentado

SCATTER_MODE: 
	
	# registrador da movimentaÃ§Ã£o Ã© menor que 21, entÃ£o foi para o scatter_mode

	li t0,1				# t0 = 1
	beq s7, t0, BLINKY_SCATTER	# se s7 = 1, entÃ£o vai para BLINKY_SCATTER
	
	li t0,2				# t0 = 2
	beq s7, t0, PINK_SCATTER	# se s7 = 2, entÃ£o vai para PINK_SCATTER
	
	li t0,3				# t0 = 3
	beq s7, t0, INKY_SCATTER	# se s7 = 3, entÃ£o vai para INKY_SCATTER 
	
	li t0,4				# t0 = 4
	beq s7, t0, CLYDE_SCATTER	# se s7 = 4, entÃ£o vai para CLYDE_SCATTER
	
CHASE_MODE: 
	
	# registrador da movimentaÃ§Ã£o Ã© maior que 21 e menor que 38, entÃ£o foi para o scatter_mode

	li t0,1				# t0 = 1
	beq s7, t0, BLINKY_CHASE	# se s7 = 1, entÃ£o vai para BLINKY_CHASE
	
	li t0,2				# t0 = 2
	beq s7, t0, PINK_CHASE		# se s7 = 2, entÃ£o vai para PINK_CHASE
	
	li t0,3				# t0 = 3
	beq s7, t0, INKY_CHASE		# se s7 = 3, entÃ£o vai para INKY_CHASE
	
	li t0,4				# t0 = 4
	beq s7, t0, CLYDE_CHASE		# se s7 = 4, entÃ£o vai para CLYDE_CHASE

FRIGHTENED_MODE:
	
	# registrador da movimentaÃ§Ã£o Ã© maior que 38 e menor que 55, entÃ£o foi para o frightened_mode
		
	addi t1, t1, 1			# adiciona 1 ao contador
	sw t1, 0(t0)			# atualiza o valor de CONTADOR_ASSUSTADO
	
	li t0,1				# t0 = 1
	beq s7, t0, BLINKY_FRIGHTENED	# se s7 = 1, entÃ£o vai para BLINKY_CHASE
	
	li t0,2				# t0 = 2
	beq s7, t0, PINK_FRIGHTENED	# se s7 = 2, entÃ£o vai para PINK_CHASE
	
	li t0,3				# t0 = 3
	beq s7, t0, INKY_FRIGHTENED	# se s7 = 3, entÃ£o vai para INKY_CHASE
	
	li t0,4				# t0 = 4
	beq s7, t0, CLYDE_FRIGHTENED	# se s7 = 4, entÃ£o vai para CLYDE_CHASE
	
DEATH_MODE:

	li t0,1				# t0 = 1
	beq s7, t0, BLINKY_DEATH	# se s7 = 1, entÃ£o vai para BLINKY_CHASE
	
	li t0,2				# t0 = 2
	beq s7, t0, PINK_DEATH		# se s7 = 2, entÃ£o vai para PINK_CHASE
	
	li t0,3				# t0 = 3
	beq s7, t0, INKY_DEATH		# se s7 = 3, entÃ£o vai para INKY_CHASE
	
	li t0,4				# t0 = 4
	beq s7, t0, CLYDE_DEATH		# se s7 = 4, entÃ£o vai para CLYDE_CHASE
	
	
# parametros necessarios:
# t4: endereÃ§o do target
# t6 : estado de movimentaÃ§Ã£o atual do alien
# a4 : posiÃ§Ã£o hexa do alien
# a6 : label do inimigo	

# Inicializa os dados do alien a ser movimentado (blinky) 
	
BLINKY_SCATTER:			# target: canto superior direito
	
	li t4, 0xFF00013F	# t4 = endereÃ§o do target do Blinky
	mv t6, s4		# t6 = movimentaÃ§Ã£o do alien no presente
	li s4, 17		# volta s4 para 17(a movimentaÃ§Ã£o jÃ¡ esta guardada em t6 e o calculo irÃ¡ adicionar em s4 posteriormente)
	
	la t0,POS_BLINKY	# carrega o endereÃ§o de "POS_BLINKY" no registrador t0
	lw a4,0(t0)		# le a word guardada em "POS_BLINKY" para a4 (a4 = posiÃ§Ã£o atual do Blinky)
	
	la a6, Inimigo1		# a6 = label da imagem a ser impressa (parametro da funÃ§Ã£o de movimentaÃ§Ã£o)
	j SETUP_TARGET		# pula para o setup do scatter_mode
	
BLINKY_CHASE:			# target: robozinho
	
	la t0,POS_ROBOZINHO	# carrega o endereÃ§o de "POS_ROBOZINHO" no registrador t0
	lw t1,0(t0)		# le a word guardada em "POS_ROBOZINHO" para t1 (t1 = posiÃ§Ã£o atual do Robozinho)
	
	mv t4, t1		# t4 = endereÃ§o do target do Blinky(robozinho)	
	mv t6, s4		# t6 = movimentaÃ§Ã£o do alien no presente
	li s4, 34		# volta s4 para 34(a movimentaÃ§Ã£o jÃ¡ esta guardada em t6 e o calculo irÃ¡ adicionar em s4 posteriormente)	
	
	la t0,POS_BLINKY	# carrega o endereÃ§o de "POS_BLINKY" no registrador t0
	lw a4,0(t0)		# le a word guardada em "POS_BLINKY" para a4 (a4 = posiÃ§Ã£o atual do Blinky)
	
	la a6, Inimigo1		# a6 = label da imagem a ser impressa (parametro da funÃ§Ã£o de movimentaÃ§Ã£o)
	j SETUP_TARGET		# pula para o setup do scatter_mode
	
BLINKY_FRIGHTENED:		# target: aleatÃ³rio(exceto no primeiro movimento que inverte a direÃ§Ã£o do alien)

	la t0,POS_BLINKY	# carrega o endereÃ§o de "POS_BLINKY" no registrador t0
	lw a4,0(t0)		# le a word guardada em "POS_BLINKY" para a4 (a4 = posiÃ§Ã£o atual do Blinky)
	
	mv t4, a4		# t4 = a4(endereÃ§o futuro do target)		

	li t0, 179		# t0 = 179
	rem t1, s0, t0		# t1 = s0%179
	beq t1, zero, INVERTE_B	# se esta no primeiro segundo do movimento, inverte a direÃ§Ã£o do alien, se nÃ£o, ve um movimento aleatÃ³rio para ele
	
	li t0, 823		# t0 = 823(numero grande primo)
	mul t0, s0, t0		# t0 = s0*t0
	li t1, 4		# t1 = 4
	rem t1, t0, t1		# t1 = t0%t1
	
	li t0, 0		# t0 = 0(up)
	beq t1, t0, UP_BLINKY # se t1 = 0, entÃ£o o blinky vai pra cima
	addi t0, t0, 1		# t0 = 1(left)
	beq t1, t0, ESQ_BLINKY  # se t1 = 1, entÃ£o o blinky vai pra esquerda
	addi t0, t0, 1		# t0 = 2(down)
	beq t1, t0, DOWN_BLINKY   # se t1 = 2, entÃ£o o blinky vai pra baixo
	addi t0, t0, 1		# t0 = 3(right)
	beq t1, t0, DIR_BLINKY   # se t1 = 3, entÃ£o o blinky vai pra direita	
	
INVERTE_B:
	li t0, 17		# t0 = 17
	rem t1,s4, t0		# t1 = s4%17
	li t0, 0		# t0 = 0(up)
	beq t1, t0, DOWN_BLINKY # se t1 = 0, entÃ£o o blinky estÃ¡ indo pra cima, logo ele inverte e va pra baixo(DOWN_BLINKY)
	addi t0, t0, 1		# t0 = 1(left)
	beq t1, t0, DIR_BLINKY  # se t1 = 1, entÃ£o o blinky estÃ¡ indo pra esquerda, logo ele inverte e va pra baixo(DIR_BLINKY)
	addi t0, t0, 1		# t0 = 2(down)
	beq t1, t0, UP_BLINKY   # se t1 = 2, entÃ£o o blinky estÃ¡ indo pra baixo, logo ele inverte e va pra baixo(UP_BLINKY)
	addi t0, t0, 1		# t0 = 3(right)
	beq t1, t0, UP_BLINKY   # se t1 = 3, entÃ£o o blinky estÃ¡ indo pra direita, logo ele inverte e va pra baixo(ESQ_BLINKY)

UP_BLINKY:
	li t0, 5120		# t0 = 5120
	sub t4, t4, t0		# t4 = t4 - 5120
	j SETUP_FRIGHTENED_BLINKY
ESQ_BLINKY:
	addi t4, t4, -16	# t4 = t4 - 16
	j SETUP_FRIGHTENED_BLINKY
DOWN_BLINKY:
	li t0, 5120		# t0 = 5120
	add t4, t4, t0		# t4 = t4 + 5120
	j SETUP_FRIGHTENED_BLINKY
DIR_BLINKY:
	addi t4, t4, 16		# t4 = t4 + 16
	
SETUP_FRIGHTENED_BLINKY:

	la a6, InimigoAssustado	# a6 = label da imagem a ser impressa (parametro da funÃ§Ã£o de movimentaÃ§Ã£o)
	mv t6, s4		# t6 = movimentaÃ§Ã£o do alien no presente
	li s4, 51		# volta s4 para 51(a movimentaÃ§Ã£o jÃ¡ esta guardada em t6 e o calculo irÃ¡ adicionar em s4 posteriormente)
	
	j SETUP_TARGET		
	
BLINKY_DEATH: 			# target: dentro da caixa
	
	li t4, 0xFF009BC8	# t4 = endereÃ§o do target do Blinky(caixa)
	mv t6, s4		# t6 = movimentaÃ§Ã£o do alien no presente
	li s4, 68		# volta s4 para 68(a movimentaÃ§Ã£o jÃ¡ esta guardada em t6 e o calculo irÃ¡ adicionar em s4 posteriormente)
	
	la t0,POS_BLINKY	# carrega o endereÃ§o de "POS_BLINKY" no registrador t0
	lw a4,0(t0)		# le a word guardada em "POS_BLINKY" para a4 (a4 = posiÃ§Ã£o atual do Blinky)
	
	la a6, Inimigo1		# a6 = label da imagem a ser impressa (parametro da funÃ§Ã£o de movimentaÃ§Ã£o)
	j SETUP_TARGET		# pula para o setup do scatter_mode
	
# Inicializa os dados do alien a ser movimentado (pinky) 
	
PINK_SCATTER:			# target: canto superior esquerdo
	
	li t4, 0xFF000000	# t4 = endereÃ§o do target do Pink 
	mv t6, s9		# t6 = movimentaÃ§Ã£o do alien no presente
	li s9, 17		# volta s9 para 17(a movimentaÃ§Ã£o jÃ¡ esta guardada em t6 e o calculo irÃ¡ adicionar em s9 posteriormente)
	
	la t0,POS_PINK		# carrega o endereÃ§o de "POS_PINK" no registrador t0
	lw a4,0(t0)		# le a word guardada em "POS_PINK" para t1 (t1 = posiÃ§Ã£o atual do Pink)
	
	la a6, Inimigo2		# a6 = label da imagem a ser impressa (parametro da funÃ§Ã£o de movimentaÃ§Ã£o)
	
	j SETUP_TARGET		# pula para o setup do scatter_mode
	
PINK_CHASE:			# target: frente do robozinho (s3 = 1  esq) (s3 = 2 cima/esquerda) (s3 = 3 baixo) (s3 = 4  dir) s3 = 0 nÃ£o hÃ¡ movimento
	
	la t0,POS_ROBOZINHO	# carrega o endereÃ§o de "POS_ROBOZINHO" no registrador t0
	lw t1,0(t0)		# le a word guardada em "POS_ROBOZINHO" para t1 (t1 = posiÃ§Ã£o atual do Robozinho)
	
	li t0, 1
	beq s3, t0, ADD_ESQ	# s3 = 1, entao o robozinho esta indo para a esquerda
	li t0, 2
	beq s3, t0, ADD_CIMA	# s3 = 2, entao o robozinho esta indo para cima
	li t0, 3
	beq s3, t0, ADD_BAIXO	# s3 = 3, entao o robozinho esta indo para baixo
	li t0, 4
	beq s3, t0, ADD_DIR	# s3 = 4, entao o robozinho esta indo para a direita
	
	jal CONT_PINK		# se o robozinho nao esta se movendo, ele vai diretamente atÃ© a posiÃ§Ã£o dele

ADD_ESQ:
	addi t1, t1, -16	# t1 = t1 - (16) 
	jal CONT_PINK
ADD_CIMA:
	li t0, 5120			
	sub t1, t1, t0		# t1 = t1 - 5120
	jal CONT_PINK	
ADD_BAIXO:
	li t0, 5120
	add t1, t1, t0		# t1 = t1 + 5120
	jal CONT_PINK
ADD_DIR:
	addi t1, t1, 16		# t1 = t1 + 16 
	
CONT_PINK:
	
	li t0, 0xFF000000	# t1 = endereÃ§o minimo 0xFF000000
	blt t1, t0, FORA_MEM_P	# se o endereÃ§o for para fora da memoria(ser menor que 0xff000000), entÃ£o o PINK se aproxima do ROBOZINHO
	li t0, 0xFF012BFF	# t1 = endereÃ§o mÃ¡ximo 0xFF012BFF
	bge t1, t0, FORA_MEM_P	# se o endereÃ§o for para fora da memoria(ser maior que 0xff012bff), entÃ£o o PINK se aproxima do ROBOZINHO
	j CONT_2_PINK		# pula para a continuaÃ§Ã£o do cÃ³digo caso o endereÃ§o esteja dentro da memÃ³ria
	
FORA_MEM_P:
	
	la t0,POS_ROBOZINHO	# carrega o endereÃ§o de "POS_ROBOZINHO" no registrador t0
	lw t1,0(t0)		# le a word guardada em "POS_ROBOZINHO" para t1 (t1 = posiÃ§Ã£o atual do Robozinho)
	
CONT_2_PINK:

	mv t4, t1
	mv t6, s9		# t6 = movimentaÃ§Ã£o do alien no presente
	li s9, 34		# volta s9 para 34(a movimentaÃ§Ã£o jÃ¡ esta guardada em t6 e o calculo irÃ¡ adicionar em s9 posteriormente)
	
	la t0,POS_PINK		# carrega o endereÃ§o de "POS_PINK" no registrador t0
	lw a4,0(t0)		# le a word guardada em "POS_PINK" para a4 (t0 = posiÃ§Ã£o atual do Pink)
	
	la a6, Inimigo2		# a6 = label da imagem a ser impressa (parametro da funÃ§Ã£o de movimentaÃ§Ã£o)
	
	j SETUP_TARGET		# pula para o setup do scatter_mode
	
PINK_FRIGHTENED:		# target: aleatÃ³rio(exceto no primeiro movimento que inverte a direÃ§Ã£o do alien)

	la t0,POS_PINK		# carrega o endereÃ§o de "POS_PINK" no registrador t0
	lw a4,0(t0)		# le a word guardada em "POS_PINK" para a4 (a4 = posiÃ§Ã£o atual do PINK)
	
	mv t4, a4		# t4 = a4(endereÃ§o futuro do target)		

	li t0, 179		# t0 = 179
	rem t1, s0, t0		# t1 = s0%179
	beq t1, zero, INVERTE_P	# se esta no primeiro segundo do movimento, inverte a direÃ§Ã£o do alien, se nÃ£o, ve um movimento aleatÃ³rio para ele
	
	li t0, 821		# t0 = 821(numero grande primo)
	mul t0, s0, t0		# t0 = s0*t0
	li t1, 4		# t1 = 4
	rem t1, t0, t1		# t1 = t0%t1
	
	li t0, 0		# t0 = 0(up)
	beq t1, t0, UP_PINK 	# se t1 = 0, entÃ£o o pink vai pra cima
	addi t0, t0, 1		# t0 = 1(left)
	beq t1, t0, ESQ_PINK    # se t1 = 1, entÃ£o o pink vai pra esquerda
	addi t0, t0, 1		# t0 = 2(down)
	beq t1, t0, DOWN_PINK   # se t1 = 2, entÃ£o o pink vai pra baixo
	addi t0, t0, 1		# t0 = 3(right)
	beq t1, t0, DIR_PINK    # se t1 = 3, entÃ£o o pink vai pra direita	
	
INVERTE_P:
	li t0, 17		# t0 = 17
	rem t1, s9, t0		# t1 = s9%17
	li t0, 0		# t0 = 0(up)
	beq t1, t0, DOWN_PINK # se t1 = 0, entÃ£o o pink estÃ¡ indo pra cima, logo ele inverte e va pra baixo(DOWN_PINK)
	addi t0, t0, 1		# t0 = 1(left)
	beq t1, t0, DIR_PINK  # se t1 = 1, entÃ£o o pink estÃ¡ indo pra esquerda, logo ele inverte e va pra baixo(DIR_PINK)
	addi t0, t0, 1		# t0 = 2(down)
	beq t1, t0, UP_PINK   # se t1 = 2, entÃ£o o pink estÃ¡ indo pra baixo, logo ele inverte e va pra baixo(UP_PINK)
	addi t0, t0, 1		# t0 = 3(right)
	beq t1, t0, ESQ_PINK   # se t1 = 3, entÃ£o o pink estÃ¡ indo pra direita, logo ele inverte e va pra baixo(ESQ_PINK)

UP_PINK:
	li t0, 5120		# t0 = 5120
	sub t4, t4, t0		# t4 = t4 - 5120
	j SETUP_FRIGHTENED_PINK
ESQ_PINK:
	addi t4, t4, -64	# t4 = t4 - 64
	j SETUP_FRIGHTENED_PINK
DOWN_PINK:
	li t0, 5120		# t0 = 5120
	add t4, t4, t0		# t4 = t4 + 5120
	j SETUP_FRIGHTENED_PINK
DIR_PINK:
	addi t4, t4, 64		# t4 = t4 + 64
	
SETUP_FRIGHTENED_PINK:

	la a6, InimigoAssustado	# a6 = label da imagem a ser impressa (parametro da funÃ§Ã£o de movimentaÃ§Ã£o)
	mv t6, s9		# t6 = movimentaÃ§Ã£o do alien no presente
	li s9, 51		# volta s4 para 51(a movimentaÃ§Ã£o jÃ¡ esta guardada em t6 e o calculo irÃ¡ adicionar em s4 posteriormente)
	
	j SETUP_TARGET	
	
PINK_DEATH:			# target: dentro da caixa
	
	li t4, 0xFF009BC8	# t4 = endereÃ§o do target do Pink(caixa) 
	mv t6, s9		# t6 = movimentaÃ§Ã£o do alien no presente
	li s9, 68		# volta s9 para 68(a movimentaÃ§Ã£o jÃ¡ esta guardada em t6 e o calculo irÃ¡ adicionar em s9 posteriormente)
	
	la t0,POS_PINK		# carrega o endereÃ§o de "POS_PINK" no registrador t0
	lw a4,0(t0)		# le a word guardada em "POS_PINK" para t1 (t1 = posiÃ§Ã£o atual do Pink)
	
	la a6, Inimigo2		# a6 = label da imagem a ser impressa (parametro da funÃ§Ã£o de movimentaÃ§Ã£o)
	
	j SETUP_TARGET		# pula para o setup do scatter_mode	
	
# Inicializa os dados do alien a ser movimentado (inky) 

INKY_SCATTER:			# target : canto inferior direito
	
	li t4, 0xFF012BFF	# t4 = endereÃ§o do target do Inky 
	mv t6, s10		# t6 = movimentaÃ§Ã£o do alien no presente
	li s10, 17		# volta s10 para 17(a movimentaÃ§Ã£o jÃ¡ esta guardada em t6 e o calculo irÃ¡ adicionar em s10 posteriormente)
	
	la t0,POS_INKY		# carrega o endereÃ§o de "POS_INKY" no registrador t0
	lw a4,0(t0)		# le a word guardada em "POS_INKY" para t1 (t1 = posiÃ§Ã£o atual do Inky)
	
	la a6, Inimigo3		# a6 = label da imagem a ser impressa (parametro da funÃ§Ã£o de movimentaÃ§Ã£o)
	
	j SETUP_TARGET		# pula para o setup do scatter_mode
	
INKY_CHASE:			# target : "cerca" o robozinho baseado na posiÃ§Ã£o do blinky 		
	
	# t1: x robo t2: y robo t3: x blinky t4: y blinky
	
	la t0,POS_ROBOZINHO	# carrega o endereÃ§o de "POS_ROBOZINHO" no registrador t0
	lw t1,0(t0)		# le a word guardada em "POS_ROBOZINHO" para t1 (t1 = posiÃ§Ã£o atual do Robozinho
	la t0,POS_BLINKY	# carrega o endereÃ§o de "POS_POS_BLINKY no registrador t0
	lw t3, 0(t0)		# le a word guardada em "POS_BLINKY" para t3 (t3 = posiÃ§Ã£o atual do BLINKY)
	
	mv t0, t1		# guarda em t0 o endereÃ§o hexa do robozinho
	
	li t6, 0xFF000000	# t1 = endereÃ§o base do Bitmap Display
	li t5, 320		# t2 = numero de colunas da tela
	
	sub t1, t1, t6		# subtrai de t1 o endereÃ§o base
	mv t2, t1		# carrega em t2 o valor de t1 (posiÃ§Ã£o do target sem o endereÃ§o base)
	rem t1, t1, t5 		# t1 = posiÃ§Ã£o x do robo (coluna do pixel de posiÃ§Ã£o)
	div t2, t2, t5		# t2 = posiÃ§Ã£o y do robo (coluna do pixel de posiÃ§Ã£o)
	
	sub t3, t3, t6		# subtrai de t3 o endereÃ§o base
	mv t4, t3		# carrega em t4 o valor de t3 (posiÃ§Ã£o do target sem o endereÃ§o base)
	rem t3, t3, t5 		# t3 = posiÃ§Ã£o x do alien (coluna do pixel de posiÃ§Ã£o)
	div t4, t4, t5		# t4 = posiÃ§Ã£o y do alien (coluna do pixel de posiÃ§Ã£o)
	
	sub t5, t1, t3		# t5 = variaÃ§Ã£o da posiÃ§Ã£o X entre o robo(t1) e o alien(t3)
	neg t5, t5 		# inverte o vetor X que liga o Blinky ao robo

	sub t6, t2, t4		# t6 = variaÃ§Ã£o da posiÃ§Ã£o Y entre o robo(t2) e o alien(t4)
	neg t6, t6		# inverte o vetor Y que liga o Blinky ao robo
	
	add t0, t0, t5		# adiciona ao endereÃ§o base a coluna 
	li t1, 5120		# t1 = 5120(320*16)
	mul t6, t6, t1		# multiplica a quantidade de linhas abaixo/acima por 5120
	add t0, t0, t6		# adiciona ao endereÃ§o base a linha
	
	li t1, 0xFF000000	# t1 = endereÃ§o minimo 0xFF000000
	blt t0, t1, FORA_MEM	# se o endereÃ§o for para fora da memoria(ser menor que 0xff000000), entÃ£o o INKY se aproxima do BLINKY
	li t1, 0xFF012BFF	# t1 = endereÃ§o mÃ¡ximo 
	bge t0, t1, FORA_MEM	# se o endereÃ§o for para fora da memoria(ser maior que 0xff012bff), entÃ£o o INKY se aproxima do BLINKY
	
	mv t4, t0		# t4 = endereÃ§o do target do Inky	
	mv t6, s10		# t6 = movimentaÃ§Ã£o do alien no presente
	li s10, 34		# volta s10 para 34(a movimentaÃ§Ã£o jÃ¡ esta guardada em t6 e o calculo irÃ¡ adicionar em s10 posteriormente)
	
	la t0,POS_INKY		# carrega o endereÃ§o de "POS_INKY" no registrador t0
	lw a4,0(t0)		# le a word guardada em "POS_INKY" para t1 (t1 = posiÃ§Ã£o atual do Inky)
	
	la a6, Inimigo3		# a6 = label da imagem a ser impressa (parametro da funÃ§Ã£o de movimentaÃ§Ã£o)
	
	j SETUP_TARGET		# pula para o setup do scatter_mode
	
 FORA_MEM:
 
 	la t0,POS_BLINKY	# carrega o endereÃ§o de "POS_ROBOZINHO" no registrador t0
	lw t1,0(t0)		# le a word guardada em "POS_ROBOZINHO" para t1 (t1 = posiÃ§Ã£o atual do Robozinho)
	
	mv t4, t1		# t4 = endereÃ§o do target do Blinky(robozinho) 	
	mv t6, s10		# t6 = movimentaÃ§Ã£o do alien no presente
	li s10, 34		# volta s10 para 34(a movimentaÃ§Ã£o jÃ¡ esta guardada em t6 e o calculo irÃ¡ adicionar em s10 posteriormente)
	
	la t0,POS_INKY		# carrega o endereÃ§o de "POS_INKY" no registrador t0
	lw a4,0(t0)		# le a word guardada em "POS_INKY" para t1 (t1 = posiÃ§Ã£o atual do Inky)
	
	la a6, Inimigo3		# a6 = label da imagem a ser impressa (parametro da funÃ§Ã£o de movimentaÃ§Ã£o)
	
	j SETUP_TARGET		# pula para o setup do scatter_mode
	
INKY_FRIGHTENED:		# target: aleatÃ³rio(exceto no primeiro movimento que inverte a direÃ§Ã£o do alien)

	la t0,POS_INKY		# carrega o endereÃ§o de "POS_INKY" no registrador t0
	lw a4,0(t0)		# le a word guardada em "POS_INKY" para a4 (a4 = posiÃ§Ã£o atual do INKY)
	
	mv t4, a4		# t4 = a4(endereÃ§o futuro do target)		

	li t0, 179		# t0 = 179
	rem t1, s0, t0		# t1 = so%179
	beq t1, zero, INVERTE_I	# se esta no primeiro segundo do movimento, inverte a direÃ§Ã£o do alien, se nÃ£o, ve um movimento aleatÃ³rio para ele
	
	li t0, 811		# t0 = 811(numero grande primo)
	mul t0, s0, t0		# t0 = s0*t0
	li t1, 4		# t1 = 4
	rem t1, t0, t1		# t1 = t0%t1
	
	li t0, 0		# t0 = 0(up)
	beq t1, t0, UP_INKY 	# se t1 = 0, entÃ£o o inky vai pra cima
	addi t0, t0, 1		# t0 = 1(left)
	beq t1, t0, ESQ_INKY    # se t1 = 1, entÃ£o o inky vai pra esquerda
	addi t0, t0, 1		# t0 = 2(down)
	beq t1, t0, DOWN_INKY   # se t1 = 2, entÃ£o o inky vai pra baixo
	addi t0, t0, 1		# t0 = 3(right)
	beq t1, t0, DIR_INKY    # se t1 = 3, entÃ£o o inky vai pra direita	
	
INVERTE_I:
	li t0, 17		# t0 = 17
	rem t1,s10, t0		# t1 = s10%17
	li t0, 0		# t0 = 0(up)
	beq t1, t0, DOWN_INKY   # se t1 = 0, entÃ£o o inky estÃ¡ indo pra cima, logo ele inverte e va pra baixo(DOWN_INKY)
	addi t0, t0, 1		# t0 = 1(left)
	beq t1, t0, DIR_INKY    # se t1 = 1, entÃ£o o inky estÃ¡ indo pra esquerda, logo ele inverte e va pra baixo(DIR_INKY)
	addi t0, t0, 1		# t0 = 2(down)
	beq t1, t0, UP_INKY     # se t1 = 2, entÃ£o o inky estÃ¡ indo pra baixo, logo ele inverte e va pra baixo(UP_INKY)
	addi t0, t0, 1		# t0 = 3(right)
	beq t1, t0, ESQ_INKY     # se t1 = 3, entÃ£o o inky estÃ¡ indo pra direita, logo ele inverte e va pra baixo(ESQ_INKY)

UP_INKY:
	li t0, 5120		# t0 = 5120
	sub t4, t4, t0		# t4 = t4 - 5120
	j SETUP_FRIGHTENED_INKY
ESQ_INKY:
	addi t4, t4, -64	# t4 = t4 - 64
	j SETUP_FRIGHTENED_INKY
DOWN_INKY:
	li t0, 5120		# t0 = 5120
	add t4, t4, t0		# t4 = t4 + 5120
	j SETUP_FRIGHTENED_INKY
DIR_INKY:
	addi t4, t4, 64		# t4 = t4 + 64
	
SETUP_FRIGHTENED_INKY:

	la a6, InimigoAssustado	# a6 = label da imagem a ser impressa (parametro da funÃ§Ã£o de movimentaÃ§Ã£o)
	mv t6, s10		# t6 = movimentaÃ§Ã£o do alien no presente
	li s10, 51		# volta s4 para 51(a movimentaÃ§Ã£o jÃ¡ esta guardada em t6 e o calculo irÃ¡ adicionar em s4 posteriormente)
	
	j SETUP_TARGET		
	
INKY_DEATH:			# target : dentro da caixa
	
	li t4, 0xFF009BC8	# t4 = endereÃ§o do target do Inky(caixa)
	mv t6, s10		# t6 = movimentaÃ§Ã£o do alien no presente
	li s10, 68		# volta s10 para 68(a movimentaÃ§Ã£o jÃ¡ esta guardada em t6 e o calculo irÃ¡ adicionar em s10 posteriormente)
	
	la t0,POS_INKY		# carrega o endereÃ§o de "POS_INKY" no registrador t0
	lw a4,0(t0)		# le a word guardada em "POS_INKY" para t1 (t1 = posiÃ§Ã£o atual do Inky)
	
	la a6, Inimigo3		# a6 = label da imagem a ser impressa (parametro da funÃ§Ã£o de movimentaÃ§Ã£o)
	
	j SETUP_TARGET		# pula para o setup do scatter_mode
	
# Inicializa os dados do alien a ser movimentado (clyde)
	
CLYDE_SCATTER:			# target: canto inferior esquerdo

	li t4, 0xFF012B40	# t4 = endereÃ§o do target do Clyde
	mv t6, s11		# t6 = movimentaÃ§Ã£o do alien no presente
	li s11, 17		# volta s11 para 17(a movimentaÃ§Ã£o jÃ¡ esta guardada em t6 e o calculo irÃ¡ adicionar em s11 posteriormente)
	
	la t0,POS_CLYDE		# carrega o endereÃ§o de "POS_CLYDE" no registrador t0
	lw a4,0(t0)		# le a word guardada em "POS_CLYDE" para t1 (t1 = posiÃ§Ã£o atual do Clyde)
	
	la a6, Inimigo4		# a6 = label da imagem a ser impressa (parametro da funÃ§Ã£o de movimentaÃ§Ã£o)
	
	j SETUP_TARGET		# pula para o setup do scatter_mode

CLYDE_CHASE:			# target: pac-man, quando chega perto de certo range escolhe uma direÃ§Ã£o aleatoria

	la t0,POS_ROBOZINHO	# carrega o endereÃ§o de "POS_ROBOZINHO" no registrador t0
	lw t1,0(t0)		# le a word guardada em "POS_ROBOZINHO" para t1 (t1 = posiÃ§Ã£o atual do Robozinho
	
	li t6, 0xFF000000	# t1 = endereÃ§o base do Bitmap Display
	li t5, 320		# t2 = numero de colunas da tela
	
	sub t1, t1, t6		# subtrai de t1 o endereÃ§o base
	mv t2, t1		# carrega em t2 o valor de t1 (posiÃ§Ã£o do target sem o endereÃ§o base)
	rem t1, t1, t5 		# t1 = posiÃ§Ã£o x do robo (coluna do pixel de posiÃ§Ã£o)
	div t2, t2, t5		# t2 = posiÃ§Ã£o y do robo (coluna do pixel de posiÃ§Ã£o)
	
	sub t1, t1, a0		# t1 = |t1 - a0|
	bge t1, zero, CONT_CLYDE 
	neg t1, t1		# se nao for maior que zero, deixa positivo o resultado
CONT_CLYDE:
	sub t2, t2, a1		# t2 = |t2 - a0|
	bge t2, zero, CONT_CLYDE2
	neg t2, t2		# se nao for maior que zero, deixa positivo o resultado
CONT_CLYDE2:
	
	li t0, 128		# t0 = 64
	add t1, t1, t2		# t1 = t1 + t2 = distancia total
	blt t1, t0, RANDOM	# se o clyde estÃ¡ prÃ³ximo do robozinho, ele assume um movimento aleatÃ³rio, se nao, ele vai atras do robozinho
	
	la t0,POS_ROBOZINHO	# carrega o endereÃ§o de "POS_ROBOZINHO" no registrador t0
	lw t1,0(t0)		# le a word guardada em "POS_ROBOZINHO" para t1 (t1 = posiÃ§Ã£o atual do Robozinho)
	
	mv t4, t1		# t4 = endereÃ§o do target do Clyde(robozinho)
	mv t6, s11		# t6 = movimentaÃ§Ã£o do alien no presente
	li s11, 34		# volta s11 para 34(a movimentaÃ§Ã£o jÃ¡ esta guardada em t6 e o calculo irÃ¡ adicionar em s11 posteriormente)
	
	la t0,POS_CLYDE		# carrega o endereÃ§o de "POS_CLYDE" no registrador t0
	lw a4,0(t0)		# le a word guardada em "POS_CLYDE" para t1 (t1 = posiÃ§Ã£o atual do Clyde)
	
	la a6, Inimigo4		# a6 = label da imagem a ser impressa (parametro da funÃ§Ã£o de movimentaÃ§Ã£o)
	
	j SETUP_TARGET		# pula para o setup do scatter_mode
							
RANDOM:
	mv t4, a4		# guarda em t4 a posiÃ§Ã£o atual do clyde
	
	mv t0, s0		# pega um numero aleatorio(contador)
	li t2, 4		# t2 = 4
	rem t1, t0, t2		# pega o resto pela divisao por 4 e armazena em t1
	
	li t0, 0
	beq t0, t1, TARGET_UP  	# se o resto der igual a 0, pega como target logo acima dele
	addi t0, t0, 1		# adiciona 1 em t0
	beq t0, t1, TARGET_L  	# se o resto der igual a 0, pega como target logo Ã  esquerda dele
	addi t0, t0, 1		# adiciona 1 em t0
	beq t0, t1, TARGET_DW  	# se o resto der igual a 0, pega como target logo abaixo dele
	addi t0, t0, 1		# adiciona 1 em t0
	beq t0, t1, TARGET_R  	# se o resto der igual a 0, pega como target logo Ã  direita dele
	
TARGET_UP:
	li t0, 5120		
	sub t4, t4, t0          # t4 = endereÃ§o do target target logo acima dele
	jal SETUP_RANDOM
TARGET_L:
	addi t4, t4, -16	# t4 = endereÃ§o do target logo Ã  esquerda dele 
	jal SETUP_RANDOM
TARGET_DW:
	li t0, 5120		
	add t4, t4, t0          # t4 = endereÃ§o do target target logo acima dele
	jal SETUP_RANDOM
TARGET_R:
	addi t4, t4, 16		# t4 = endereÃ§o do target logo Ã  direita dele

SETUP_RANDOM:

	mv t6, s11		# t6 = movimentaÃ§Ã£o do alien no presente
	li s11, 34		# volta s11 para 34(a movimentaÃ§Ã£o jÃ¡ esta guardada em t6 e o calculo irÃ¡ adicionar em s11 posteriormente)
	
	la t0,POS_CLYDE		# carrega o endereÃ§o de "POS_CLYDE" no registrador t0
	lw a4,0(t0)		# le a word guardada em "POS_CLYDE" para t1 (t1 = posiÃ§Ã£o atual do Clyde)
	
	la a6, Inimigo4		# a6 = label da imagem a ser impressa (parametro da funÃ§Ã£o de movimentaÃ§Ã£o)
	j SETUP_TARGET		# pula para o setup do scatter_mode
	
CLYDE_FRIGHTENED:		# target: aleatÃ³rio(exceto no primeiro movimento que inverte a direÃ§Ã£o do alien)

	la t0,POS_CLYDE		# carrega o endereÃ§o de "POS_CLYDE" no registrador t0
	lw a4,0(t0)		# le a word guardada em "POS_CLYDE" para a4 (a4 = posiÃ§Ã£o atual do CLYDE)
	
	mv t4, a4		# t4 = a4(endereÃ§o futuro do target)		

	li t0, 179		# t0 = 179
	rem t1, s0, t0		# t1 = so%179
	beq t1, zero, INVERTE_C	# se esta no primeiro segundo do movimento, inverte a direÃ§Ã£o do alien, se nÃ£o, ve um movimento aleatÃ³rio para ele
	
	li t0, 811		# t0 = 809(numero grande primo)
	mul t0, s0, t0		# t0 = s0*t0
	li t1, 4		# t1 = 4
	rem t1, t0, t1		# t1 = t0%t1
	
	li t0, 0		# t0 = 0(up)
	beq t1, t0, UP_CLYDE 	# se t1 = 0, entÃ£o o clyde vai pra cima
	addi t0, t0, 1		# t0 = 1(left)
	beq t1, t0, ESQ_CLYDE   # se t1 = 1, entÃ£o o clyde vai pra esquerda
	addi t0, t0, 1		# t0 = 2(down)
	beq t1, t0, DOWN_CLYDE  # se t1 = 2, entÃ£o o clyde vai pra baixo
	addi t0, t0, 1		# t0 = 3(right)
	beq t1, t0, DIR_CLYDE   # se t1 = 3, entÃ£o o clyde vai pra direita	
	
INVERTE_C:
	li t0, 17		# t0 = 17
	rem t1,s11, t0		# t1 = s11%17
	li t0, 0		# t0 = 0(up)
	beq t1, t0, DOWN_CLYDE  # se t1 = 0, entÃ£o o clyde estÃ¡ indo pra cima, logo ele inverte e va pra baixo(DOWN_CLYDE)
	addi t0, t0, 1		# t0 = 1(left)
	beq t1, t0, DIR_CLYDE   # se t1 = 1, entÃ£o o clyde estÃ¡ indo pra esquerda, logo ele inverte e va pra baixo(DIR_CLYDE)
	addi t0, t0, 1		# t0 = 2(down)
	beq t1, t0, UP_CLYDE    # se t1 = 2, entÃ£o o clyde estÃ¡ indo pra baixo, logo ele inverte e va pra baixo(UP_CLYDE)
	addi t0, t0, 1		# t0 = 3(right)
	beq t1, t0, ESQ_CLYDE   # se t1 = 3, entÃ£o o clyde estÃ¡ indo pra direita, logo ele inverte e va pra baixo(ESQ_CLYDE)

UP_CLYDE:
	li t0, 5120		# t0 = 5120
	sub t4, t4, t0		# t4 = t4 - 5120
	j SETUP_FRIGHTENED_CLYDE
ESQ_CLYDE:
	addi t4, t4, -64	# t4 = t4 - 64
	j SETUP_FRIGHTENED_CLYDE
DOWN_CLYDE:
	li t0, 5120		# t0 = 5120
	add t4, t4, t0		# t4 = t4 + 5120
	j SETUP_FRIGHTENED_CLYDE
DIR_CLYDE:
	addi t4, t4, 64		# t4 = t4 + 64
	
SETUP_FRIGHTENED_CLYDE:

	la a6, InimigoAssustado	# a6 = label da imagem a ser impressa (parametro da funÃ§Ã£o de movimentaÃ§Ã£o)
	mv t6, s11		# t6 = movimentaÃ§Ã£o do alien no presente
	li s11, 51		# volta s4 para 51(a movimentaÃ§Ã£o jÃ¡ esta guardada em t6 e o calculo irÃ¡ adicionar em s4 posteriormente)
	j SETUP_TARGET
	
CLYDE_DEATH:			# target: dentro da caixa

	li t4, 0xFF009BC8	# t4 = endereÃ§o do target do Clyde(caixa)
	mv t6, s11		# t6 = movimentaÃ§Ã£o do alien no presente
	li s11, 68		# volta s11 para 68(a movimentaÃ§Ã£o jÃ¡ esta guardada em t6 e o calculo irÃ¡ adicionar em s11 posteriormente)
	
	la t0,POS_CLYDE		# carrega o endereÃ§o de "POS_CLYDE" no registrador t0
	lw a4,0(t0)		# le a word guardada em "POS_CLYDE" para t1 (t1 = posiÃ§Ã£o atual do Clyde)
	
	la a6, Inimigo4		# a6 = label da imagem a ser impressa (parametro da funÃ§Ã£o de movimentaÃ§Ã£o)
	
# Inicializa os dados para o scatter mode, no qual sera calculado o caminho mais curto ate o target (|a0 - t4| + |a1 - t5|) = (|x_alien - x_target|) + (|y_alien - y_target|)

# FunÃ§Ã£o que calcula o target do alien com relaÃ§Ã£o a posiÃ§Ã£o do Robozinho
# Calculo de distancia: distancia de manhattan : (|x_alien - x_target|) + (|y_alien - y_target|)
# t4: endereÃ§o do target
# t6 : estado de movimentaÃ§Ã£o atual do alien
# a0 : endereÃ§o x do alien
# a1 : endereÃ§o y do alien
# a4 : posiÃ§Ã£o hexa do alien
# a6 : label do inimigo	
	
SETUP_TARGET:

	li t5, 17		# t5 = 17
	rem t6, t6, t5		# t6 = resto de t6 por 17(t6 guardava a movimentaÃ§Ã£o do alien antes de resetar para 17/34/51 e agora estÃ¡ setado para 0,1,2 ou 3)

	li t1, 0xFF000000	# t1 = endereÃ§o base do Bitmap Display 
	li t2, 320		# t2 = numero de colunas da tela
	
	sub t4, t4, t1		# subtrai de t4 o endereÃ§o base
	mv t5, t4		# carrega em t5 o valor de t4 (posiÃ§Ã£o do target sem o endereÃ§o base)
	rem t4, t4, t2 		# t4 = posiÃ§Ã£o x do target (coluna do pixel de posiÃ§Ã£o)
	div t5, t5, t2		# t5 = posiÃ§Ã£o y do target (coluna do pixel de posiÃ§Ã£o)
	
	addi a1, a1, -4		# a1 = posiÃ§Ã£o y do alien 4 linhas acima
	jal ra, LOOP_TARGET	# calcula a distancia de manhattan entre o target e a direÃ§Ã£o de cima do alien e retorna em a2
	mv t0, a2		# guarda em t0 a distancia entre target e a posiÃ§Ã£o acima do alien
	
	addi a1, a1, 4		# volta a1 para a posiÃ§Ã£o original
	addi a0, a0, -4 	# a0 = posiÃ§Ã£o x do alien 4 colunas a esquerda
	jal ra, LOOP_TARGET	# calcula a distancia de manhattan entre o target e a direÃ§Ã£o esquerda do alien e retorna em a2
	mv t1, a2		# guarda em t1 a distancia entre target e a posiÃ§Ã£o a esquerda do alien
	
	addi a0, a0, 4		# volta a0 para a posiÃ§Ã£o original
	addi a1, a1, 4		# a1 = posiÃ§Ã£o y do alien 4 linhas abaixo
	jal ra, LOOP_TARGET	# calcula a distancia de manhattan entre o target e a direÃ§Ã£o esquerda do alien e retorna em a2
	mv t2, a2		# guarda em t2 a distancia entre target e a posiÃ§Ã£o abaixo do alien
	
	addi a1, a1, -4		# volta a1 para a posiÃ§Ã£o original
	addi a0, a0, 4 		# a0 = posiÃ§Ã£o x do alien 4 colunas a direita
	jal ra, LOOP_TARGET 	# calcula a distancia de manhattan entre o target e a direÃ§Ã£o esquerda do alien e retorna em a2
	mv t3, a2		# guarda em t1 a distancia entre target e a posiÃ§Ã£o a direita do alien
	
	addi a0, a0, -4		# volta a0 para a posiÃ§Ã£o original
	
	la t5, CONTADOR_ASSUSTADO	# le o CONTADOR_ASSUSTADO
	lw t4, 0(t5)		# carrega em t4 o valor do CONTADOR_ASSUSTADO 
	
	li t5, 0		# t5 = 0(primeiro loop do blinky no frightened mode)
	bge t4, t5, VERIF_MODE	# se ele estiver no modo assustado, verifica se ele estÃ¡ em um dos primeiros ticks do fantasma no modo assustado
	j CONT_TARGET
	
VERIF_MODE:
	li t5, 4		# te = 4(proximo tick do primeiro alien)
	blt t4, t5, MENOR	# se sim, entÃ£o ele pode virar 180 graus
	
CONT_TARGET:
	
#	li t4, 116		# verifica se o alien estÃ¡ dentro da caixa(caso esteja, ele nao pode ir para baixo)
#	beq a1, t4, VERIF_MOV1  # se ele estiver na linha da caixa, vamos ver se ele estÃ¡ entre as colunas
	
	li t4, 96		#verifica se o alien estÃ¡ logo em cima da caixa(caso esteja, ele nao pode ir para cima)
	beq a1, t4, VERIF_MOV2  # se ele estiver na linha da caixa, vamos ver se ele estÃ¡ entre as colunas
		
	jal VERIF_MOV
	
#VERIF_MOV1:
#	li t4, 216		# borda direita da caixa(200 + 16)
#	li t5, 184		# borda esquerda da caixa(200 - 16)
#	bge a0, t4, VERIF_MOV	# se a0 estÃ¡ na esquerda da borda esquerda, nao esta dentro da caixa
#	blt a0, t5, VERIF_MOV	# se a0 estÃ¡ na direita da borda direita, nao esta dentro da caixa
	
#	li t2, 560		# carrega em t2 um valor grande para ele nao ir para baixo
#	jal VERIF_MOV		# pula para verificar o movimento
	
VERIF_MOV2:
	li t4, 216		# borda direita da caixa(200 + 16)
	li t5, 184		# borda esquerda da caixa(200 - 16)
	bge a0, t4, VERIF_MOV	# se a0 estÃ¡ na esquerda da borda esquerda, nao esta dentro da parte de cima da caixa
	blt a0, t5, VERIF_MOV	# se a0 estÃ¡ na direita da borda esquerda, nao esta dentro da parte de cima da caixa
	
	li t0, 560		# carrega em t0 um valor grande epara ele nao ir para cima
	li t2, 560		# carrega em t2 um valor grande para ele nao ir para baixo
	
VERIF_MOV:
	
	li t4, 0		# t4 = 0 significa que o alien estÃ¡ andando para cima		
	beq t6, t4, N_BAIXO	# logo ele nÃ£o pode ir pra baixo
	addi t4, t4, 1		# t4 = 1 significa que o alien estÃ¡ andando para a esquerda	
	beq t6, t4, N_DIREITA   # logo ele nÃ£o pode ir pra a direita
	addi t4, t4, 1		# t4 = 2 significa que o alien estÃ¡ andando para baixo
	beq t6, t4, N_CIMA	# logo ele nÃ£o pode ir pra cima
	addi t4, t4, 1		# t4 = 3 significa que o alien estÃ¡ andando para a direita
	beq t6, t4, N_ESQUERDA  # logo ele nÃ£o pode ir pra a esquerda
	
N_BAIXO:
	li t2, 560		# carrega em t2 um valor grand epara ele nao ir para baixo	
	j MENOR			# pula para MENOR (verifica o menor entre t0, t1, t2 e t3)
N_DIREITA:
	li t3, 560		# carrega em t3 um valor grand epara ele nao ir para a direita
	j MENOR			# pula para MENOR (verifica o menor entre t0, t1, t2 e t3)
N_CIMA:
	li t0, 560		# carrega em t0 um valor grand epara ele nao ir para cima
	j MENOR			# pula para MENOR (verifica o menor entre t0, t1, t2 e t3)
N_ESQUERDA:
	li t1, 560 		# carrega em t1 um valor grand epara ele nao ir para a esquerda
	j MENOR			# pula para MENOR (verifica o menor entre t0, t1, t2 e t3)
	
# Calcula a distÃ¢ncia de cada posiÃ§Ã£o relativa do alien atÃ© o target

LOOP_TARGET:

	sub a2, a0, t4		# a2 = a0 - t4 (a2 = x_alien - x_target)
	bge a2, zero, CONT	# se a2 for positivo, vai para o calculo da subtraÃ§Ã£o entre "y_alien" e "y_target"
	neg a2, a2		# calcula o mÃ³dulo do resultado caso a subtraÃ§Ã£o entre "x_alien" e "x_target" seja menor que zero
	
CONT:	sub a3, a1, t5		# a3 = a1 - t5 (a3 = y_alien - y_target)	
	bge a3, zero, CONT2	# se a3 for positivo, vai para o calculo da soma de a2 e a3
	neg a3, a3		# calcula o mÃ³dulo do resultado caso a subtraÃ§Ã£o entre "y_alien" e "y_target" seja menor que zero
	
CONT2:  add a2, a2, a3		# a2 = distÃ¢ncia de manhatan da posiÃ§Ã£o acima, abaixo, a esquerda ou a direita do alien
	ret			# retorna para verificar outra posiÃ§Ã£o

# Uma vez calculadas as distÃ£ncias entre o target e as possiveis direÃ§Ãµes de movimentaÃ§Ã£o do alien, faz um condicional para ver qual o menor registrador entre os 4 (t0, t1, t2, t3)
# prioridades de opÃ§Ã£o em caso de empate: cima > esquerda > baixo > direita

MENOR:	blt t1, t0, COMP1	# continua se t0 Ã© menor
	blt t3, t2, COMP2	# continua se t2 Ã© menor
	blt t2, t0, VDCA	# se t2 Ã© menor, entÃ£o o alien verifica colisÃ£o em baixo
	j VUCA			# se nÃ£o, ele verifica colisÃ£o acima
	
COMP1:	blt t3, t2, COMP3	# jÃ¡ que t1 Ã© menor, resta ver qual Ã© menor: t2 ou t3, se t3 for menor, cai no mesmo loop de COMP2, sÃ³ que comparando com o t1
	blt t2, t1, VDCA	# se t2 Ã© menor que o t1, entÃ£o verifica colisÃ£o em baixo
	j VLCA			# se nÃ£o, ele verifica colisÃ£o na esquerda
	
COMP2:	blt t3, t0, VRCA	# jÃ¡ que t3 Ã© menor, resta ver qual Ã© menor: t0 ou t3, se t3 for menor, o alien verifica colisÃ£o na direita
	j VUCA			# se nÃ£o, verifica colisÃ£o acima
	
COMP3:	blt t3, t1, VRCA	# jÃ¡ que t3 Ã© menor, resta ver qual Ã© menor: t1 ou t3, se t3 for menor, o alien verifica colisÃ£o na direita
	j VLCA			# se nÃ£o, verifica colisÃ£o na esquerda

# Verifica a colisao do mapa (VLCA, VUCA, VDCA e VRCA carregam 5 ou 6 pixels de detecÃ§Ã£o de colisÃ£o em cada direÃ§Ã£o, e VERC_A verifica se algum desses pixels detectou uma colisÃ£o adiante)

#	   @7       @8          @9          @10         @11
#	@6 #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  @12
#	   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  
#	   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  
#	@5 #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  @13
#	   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  
#	   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  
#	@4 #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  @14
#	   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #			# representaÃ§Ã£o do alien 16x16 com "#"
#	   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  			# os "@x" sÃ£o os pixels de colisÃ£o carregados ao redor do alien (o endereÃ§o de "@x" Ã© calculado em relaÃ§Ã£o ao endereÃ§o em POS_ALIEN, sendo "@22" igual a prÃ³pria posiÃ§Ã£o)
#	@3 #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  @15			# OBS: os pixels de colisÃ£o detectam colisÃµes apenas em relaÃ§Ã£o ao mapa desenhado no Frame 1 da memÃ³ria VGA (mapa de colisÃ£o)
#	   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #			# se tiver colisÃ£o, carrega "tX" com o maior valor possivel e volta para o loop MENOR
#	   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #
#	@2 #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  @16
#	   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #
#	   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #
#	@1 #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  @17
#	   @22(POS) @21	        @20         @19         @18

# Carrega pixels de colisÃ£o acima (@7, @8, @9, @10, @11)

VUCA:	li t6, 1		# t6 = 1 (indica que o alien esta verificando se e possivel ir para cima)
	mv a1, a4		# a1 = a4 (endereÃ§o da posiÃ§Ã£o do alien)
	
	li a2, -5440		# a2 = -5440
	add a1,a1,a2		# volta a1 1 linha e 1 pixel (carrega em a1 o endereÃƒÂ§o do pixel "@1")
	jal a3, VERC_A		# vÃƒÂ¡ para VERC_A (verifica se o pixel "@1" detectou uma colisÃƒÂ£o)
	
	li a2, -5437		
	add a1,a1,a2		# volta a1 4 linhas e 1 pixel (carrega em t5 o endereÃƒÂ§o do pixel "@2")
	jal a3, VERC_A		# vÃƒÂ¡ para VERC_A (verifica se o pixel "@1" detectou uma colisÃƒÂ£o)
	
	li a2, -5433		# a2 = -2241
	add a1,a1,a2		# volta a1 7 linhas e 1 pixel (carrega em t5 o endereÃƒÂ§o do pixel "@3")
	jal a3, VERC_A		# vÃƒÂ¡ para VERC_A (verifica se o pixel "@1" detectou uma colisÃƒÂ£o)
	
	li a2, -5429		# a2 = -3201
	add a1,a1,a2		# volta a1 10 linhas e 1 pixel (carrega em a1 o endereÃƒÂ§o do pixel "@4")
	jal a3, VERC_A		# vÃƒÂ¡ para VERC_A (verifica se o pixel "@1" detectou uma colisÃƒÂ£o)
	
	li a2, -5425		# a2 = -5121
	add a1,a1,a2		# volta a1 13 linhas e 1 pixel (carrega em a1 o endereÃƒÂ§o do pixel "@5")
	jal a3, VERC_A		# vÃƒÂ¡ para VERC_A (verifica se o pixel "@1" detectou uma colisÃƒÂ£o)
	
	beq t6, zero, CUA	# se t6 for igual a zero, entÃ£o houve colisÃ£o
	j SETUP_DELETE		# se nÃ£o, ele pode se mover tranquilamente
	
CUA:	li t0, 561		# carrega t0 com um valor que nÃ£o consiga ser menor que t1, t2 ou t3
	j MENOR			# volta para calcular qual o menor entre t1, t2 e t3
	
# Carrega pixels de colisÃ£o a esquerda (@1, @2, @3, @4, @5, @6)

VLCA:	li t6, 2		# t6 = 2 (indica que o alien esta verificando se e possivel ir para a esquerda)
	mv a1, a4		# a1 = a4 (endereÃ§o da posiÃ§Ã£o do alien) 	
	
	addi a1,a1,-321		# volta a1 1 linha e 1 pixel (carrega em a1 o endereÃƒÂ§o do pixel "@1")
	jal a3, VERC_A		# vÃƒÂ¡ para VERC_A (verifica se o pixel "@1" detectou uma colisÃƒÂ£o)
			
	addi a1,a1,-1281	# volta a1 4 linhas e 1 pixel (carrega em t5 o endereÃƒÂ§o do pixel "@2")
	jal a3, VERC_A		# vÃƒÂ¡ para VERC_A (verifica se o pixel "@1" detectou uma colisÃƒÂ£o)
	
	li a2,-2241		# a2 = -2241
	add a1,a1,a2		# volta a1 7 linhas e 1 pixel (carrega em t5 o endereÃƒÂ§o do pixel "@3")
	jal a3, VERC_A		# vÃƒÂ¡ para VERC_A (verifica se o pixel "@1" detectou uma colisÃƒÂ£o)
	
	li a2,-3201		# a2 = -3201
	add a1,a1,a2		# volta a1 10 linhas e 1 pixel (carrega em a1 o endereÃƒÂ§o do pixel "@4")
	jal a3, VERC_A		# vÃƒÂ¡ para VERC_A (verifica se o pixel "@1" detectou uma colisÃƒÂ£o)
	
	li a2,-4161		# a2 = -5121
	add a1,a1,a2		# volta a1 13 linhas e 1 pixel (carrega em a1 o endereÃƒÂ§o do pixel "@5")
	jal a3, VERC_A		# vÃƒÂ¡ para VERC_A (verifica se o pixel "@1" detectou uma colisÃƒÂ£o)
	
	li a2,-5121		# a2 = -5121
	add a1,a1,a2		# volta a1 16 linhas e 1 pixel (carrega em a1 o endereÃƒÂ§o do pixel "@6")
	jal a3, VERC_A		# vÃƒÂ¡ para VERC_A (verifica se o pixel "@1" detectou uma colisÃƒÂ£o)
	
	beq t6, zero, CLA	# se t6 for igual a zero, entÃ£o houve colisÃ£o
	j SETUP_DELETE		# se nÃ£o, ele pode se mover tranquilamente
	
CLA:	li t1, 561		# carrega t1 com um valor que nÃ£o consiga ser menor que t0, t2 ou t3
	j MENOR			# volta para calcular qual o menor entre t0, t2 e t3

# Carrega pixels de colisÃ£o abaixo (@22, @21, @20, @19, @18)

VDCA:	li t6, 3		# t6 = 3 (indica que o alien esta verificando se e possivel ir para baixo)
	mv a1, a4		# a1 = a4 (endereÃ§o da posiÃ§Ã£o do alien)
	jal a3, VERC_A		# vÃƒÂ¡ para VERC_A (verifica se o pixel "@1" detectou uma colisÃƒÂ£o)
			
	addi a1,a1,3		# volta a1 4 linhas e 1 pixel (carrega em t5 o endereÃƒÂ§o do pixel "@2")
	jal a3, VERC_A		# vÃƒÂ¡ para VERC_A (verifica se o pixel "@1" detectou uma colisÃƒÂ£o)
	
	addi a1,a1,7		# volta a1 7 linhas e 1 pixel (carrega em t5 o endereÃƒÂ§o do pixel "@3")
	jal a3, VERC_A		# vÃƒÂ¡ para VERC_A (verifica se o pixel "@1" detectou uma colisÃƒÂ£o)
	
	addi a1,a1,11		# volta a1 10 linhas e 1 pixel (carrega em a1 o endereÃƒÂ§o do pixel "@4")
	jal a3, VERC_A		# vÃƒÂ¡ para VERC_A (verifica se o pixel "@1" detectou uma colisÃƒÂ£o)
	
	addi a1,a1,15		# volta a1 13 linhas e 1 pixel (carrega em a1 o endereÃƒÂ§o do pixel "@5")
	jal a3, VERC_A		# vÃƒÂ¡ para VERC_A (verifica se o pixel "@1" detectou uma colisÃƒÂ£o)
	
	beq t6, zero, CDA	# se t6 nÃ£o for igual a zero, entÃ£o houve colisÃ£o
	j SETUP_DELETE		# se nÃ£o, ele pode se mover tranquilamente
	
CDA:	li t2, 561		# carrega t2 com um valor que nÃ£o consiga ser menor que t0, t1 ou t3
	j MENOR			# volta para calcular qual o menor entre t0, t1 e t3
	
# Carrega pixels de colisÃ£o a direita (@17, @16, @15, @14, @13, @12)

VRCA:	li t6, 4		# t6 = 4 (indica que o alien esta verificando se e possivel ir para a direita)
	mv a1, a4		# a1 = a4 (endereÃ§o da posiÃ§Ã£o do alien)
	
	addi a1,a1,-304		# volta a1 1 linha e 1 pixel (carrega em a1 o endereÃƒÂ§o do pixel "@1")
	jal a3, VERC_A		# vÃƒÂ¡ para VERC_A (verifica se o pixel "@1" detectou uma colisÃƒÂ£o)
			
	addi a1,a1,-1264	# volta a1 4 linhas e 1 pixel (carrega em t5 o endereÃƒÂ§o do pixel "@2")
	jal a3, VERC_A		# vÃƒÂ¡ para VERC_A (verifica se o pixel "@1" detectou uma colisÃƒÂ£o)
	
	li a2,-2224		# a2 = -2241
	add a1,a1,a2		# volta a1 7 linhas e 1 pixel (carrega em t5 o endereÃƒÂ§o do pixel "@3")
	jal a3, VERC_A		# vÃƒÂ¡ para VERC_A (verifica se o pixel "@1" detectou uma colisÃƒÂ£o)
	
	li a2,-3184		# a2 = -3201
	add a1,a1,a2		# volta a1 10 linhas e 1 pixel (carrega em a1 o endereÃƒÂ§o do pixel "@4")
	jal a3, VERC_A		# vÃƒÂ¡ para VERC_A (verifica se o pixel "@1" detectou uma colisÃƒÂ£o)
	
	li a2,-4144		# a2 = -5121
	add a1,a1,a2		# volta a1 13 linhas e 1 pixel (carrega em a1 o endereÃƒÂ§o do pixel "@5")
	jal a3, VERC_A		# vÃƒÂ¡ para VERC_A (verifica se o pixel "@1" detectou uma colisÃƒÂ£o)
	
	li a2,-5104		# a2 = -5121
	add a1,a1,a2		# volta a1 16 linhas e 1 pixel (carrega em a1 o endereÃƒÂ§o do pixel "@6")
	jal a3, VERC_A		# vÃƒÂ¡ para VERC_A (verifica se o pixel "@1" detectou uma colisÃƒÂ£o)
	
	beq t6, zero, CRA	# se t6 nÃ£o for igual a zero, entÃ£o houve colisÃ£o
	j SETUP_DELETE		# se nÃ£o, ele pode se mover tranquilamente
	
CRA:	li t3, 561		# carrega t3 com um valor que nÃ£o consiga ser menor que t0, t1 ou t2
	j MENOR			# volta para calcular qual o menor entre t0, t1 e t2
	
# Verifica a colisÃ£o em casa pixel

VERC_A:	li a0,0x100000		# a0 = 0x100000
	add a1,a1,a0		# soma 0x100000 a a1 (transforma o conteudo de a em um endereÃƒÂ§o do Frame 1)
	lbu a0,0(a1)		# carrega em a0 um byte do endereÃƒÂ§o a1 (cor do pixel de a1) -> OBS: o load byte deve ser "unsigned" 
				# Ex: 0d200 = 0xc8 = 0b11001000. como o MSB desse byte ÃƒÂ© 1, ele seria interpretado como -56 e nÃƒÂ£o 200 (t6 = 0xffffffc8)
				
	li a1,0x69
	beq a0,a1, COLIDIU_R			
	li a1,200		# a1 = 200
	beq a0,a1, COLIDIU_A	# se a0 = 200, vÃƒÂ¡ para COLIDIU_A (se a cor do pixel for azul, termina a iteraÃƒÂ§ÃƒÂ£o e impede movimento do Robozinho)
	li a1,3			# a1 = 3
	beq a0,a1, COLIDIU_A	# se a0 = 200, vÃƒÂ¡ para COLIDIU_A (se a cor do pixel for azul, termina a iteraÃƒÂ§ÃƒÂ£o e impede movimento do Robozinho)
	li a1,7			# a1 = 7	
	beq a0,a1, COLIDIU_A	# se a0 = 200, vÃƒÂ¡ para COLIDIU_A (se a cor do pixel for azul, termina a iteraÃƒÂ§ÃƒÂ£o e impede movimento do Robozinho)
	mv a1, a4		# a1 = a4
	jalr x0, a3, 0 		# retorna para verificar se outro pixel detectou colisÃƒÂ£o
	
COLIDIU_A:
	li t6, 0		# colidiu, logo t6 recebe o valor de 0
	mv a1, a4		# a1 = a4
	jalr x0, a3, 0 		# retorna para verificar se outro pixel detectou colisÃƒÂ£o
	
# Deleta o personagem caso haja movimento

SETUP_DELETE:
	
	mv t1,a4		# t1 = a4 (posiÃ§Ã£o atual do alien - pixel inicial da linha)
	addi t2,a4,16		# t2 = a4 + 16 (posiÃ§Ã£o atual do alien - pixel inicial da linha)
	mv a5,t6		# a5 = t6 (direÃ§Ã£o atual de movimentaÃ§Ã£o do alien)
	
DELETE_A:

	li t5,0	
	li t6,16		# reinicia o contador para 16 quebras de linha
	
	li t4, 5120		# t4 = 5120
	sub t1, t1, t4		# volta t1 16 linhas (pixel inicial da primeira linha) 
	sub t2, t2, t4		# volta t2 16 linhas (pixel final da primeira linha)
	
	li t0,1
	beq s6,t0,DELFS1
	la t3,mapa2
	j DELFS2
DELFS1:	la t3,mapa1		# carrega em t3 o endereÃ§o dos dados do mapa1
DELFS2:	addi t3,t3,8		# t3 = endereÃ§o do primeiro pixel do mapa1 (depois das informaÃ§Ãµes de nlin ncol)
	li t0,0xFF000000	# t0 = 0xFF000000 (carrega em t0 o endereÃ§o base da memoria VGA)
	sub t0,t1,t0		# t0 = t1 - 0xFF000000 (subtrai o endereÃ§o base de t1, posiÃ§Ã£o atual do alien)
	add t3,t3,t0		# t3 = t3 + t0 (carrega em t3 o endereÃ§o do pixel do mapa1 no segmento de dados sobre o qual o alien esta localizado)
	
DELLOOP_A:
	beq t1,t2,ENTER2_A	# se t1 atingir o fim da linha de pixels, quebre linha
	lw t0,0(t3)		# le uma word do endereÃ§o t3 (le 4 pixels do mapa1 no segmento de dados)
	sw t0,0(t1)		# escreve a word (4 pixels do mapa1) na memÃ³ria VGA
	addi t1,t1,4		# soma 4 ao endereÃ§o t1
	addi t3,t3,4		# soma 4 ao endereÃ§o t3
	j DELLOOP_A		# volta a verificar a condiÃ§ao do loop

ENTER2_A:
	addi t1,t1,304		# t1 (a4) pula para o pixel inicial da linha de baixo da memoria VGA
	addi t3,t3,304		# t1 pula para o pixel inicial da linha de baixo do segmento de dados 
	addi t2,t2,320		# t2 (a4 + 16) pula para o pixel final da linha de baixo da memoria VGA
	addi t5,t5,1          	# atualiza o contador de quebras de linha
	beq t5,t6,SETUP_DELETE_COL	# termina o carregamento da imagem se 16 quebras de linha ocorrerem e vai para o loop de carregamento da imagem
	j DELLOOP_A		# pula para delloop
	
# Deleta o personagem caso haja movimento

SETUP_DELETE_COL:
	
	li t0,0x100000
	add t1,a4,t0
	addi t2,t1,16		# t2 = a4 + 16 (posiÃ§Ã£o atual do alien - pixel inicial da linha)
	
DELETE_A_COL:

	li t5,0	
	li t6,16		# reinicia o contador para 16 quebras de linha
	
	li t4, 5120		# t4 = 5120
	sub t1, t1, t4		# volta t1 16 linhas (pixel inicial da primeira linha) 
	sub t2, t2, t4		# volta t2 16 linhas (pixel final da primeira linha)
	
	li t0,1
	beq s6,t0,DELFS1_COL
	la t3,mapa2colisao
	j DELFS2_COL
	
DELFS1_COL:	
	la t3,mapa1colisao		# carrega em t3 o endereÃ§o dos dados do mapa1

DELFS2_COL:	
	addi t3,t3,8		# t3 = endereÃ§o do primeiro pixel do mapa1 (depois das informaÃ§Ãµes de nlin ncol)
	li t0,0xFF100000	# t0 = 0xFF000000 (carrega em t0 o endereÃ§o base da memoria VGA)
	sub t0,t1,t0		# t0 = t1 - 0xFF000000 (subtrai o endereÃ§o base de t1, posiÃ§Ã£o atual do alien)
	add t3,t3,t0		# t3 = t3 + t0 (carrega em t3 o endereÃ§o do pixel do mapa1 no segmento de dados sobre o qual o alien esta localizado)
	
DELLOOP_A_COL:
	beq t1,t2,ENTER2_A_COL	# se t1 atingir o fim da linha de pixels, quebre linha
	lw t0,0(t3)		# le uma word do endereÃ§o t3 (le 4 pixels do mapa1 no segmento de dados)
	sw t0,0(t1)		# escreve a word (4 pixels do mapa1) na memÃ³ria VGA
	addi t1,t1,4		# soma 4 ao endereÃ§o t1
	addi t3,t3,4		# soma 4 ao endereÃ§o t3
	j DELLOOP_A_COL		# volta a verificar a condiÃ§ao do loop

ENTER2_A_COL:
	addi t1,t1,304		# t1 (a4) pula para o pixel inicial da linha de baixo da memoria VGA
	addi t3,t3,304		# t1 pula para o pixel inicial da linha de baixo do segmento de dados 
	addi t2,t2,320		# t2 (a4 + 16) pula para o pixel final da linha de baixo da memoria VGA
	addi t5,t5,1          	# atualiza o contador de quebras de linha
	beq t5,t6,SETUP_MOV	# termina o carregamento da imagem se 16 quebras de linha ocorrerem e vai para o loop de carregamento da imagem
	j DELLOOP_A_COL		# pula para delloop

# ve em qual direÃ§Ã£o foi o movimento para printar o personagem

SETUP_MOV:

	mv t3, a6		# volta o t3 com a label de a6
	addi t3, t3, 8		# s0 = endereÃ§o do primeiro pixel da imagem (depois das informaÃ§Ãµes de nlin ncol)
	
	li t5,0
	li t6,16		# inicializa o contador de quebra de linha para 16 quebras de linha
	
	li t0, 1			# t0 = 1
	beq a5, t0, MOV_UP_A		# se a5 = 1, entÃ£o vai para MOV_UP_A
	
	li t0, 2			# t0 = 2
	beq a5, t0, MOV_LEFT_A		# se a5 = 2, entÃ£o vai para MOV_LEFT_A
	
	li t0, 3			# t0 = 3
	beq a5, t0, MOV_DOWN_A		# se a5 = 3, entÃ£o vai para MOV_DOWN_A
	
	li t0, 4			# t0 = 4
	beq a5, t0, MOV_RIGHT_A		# se a5 = 4, entÃ£o vai para MOV_RIGHT_A

MOV_UP_A: 

	mv t1, a4		# t1 = a4 (posiÃ§Ã£o atual do alien - pixel inicial da linha)
	li t4, 0		# salva em t4 a movimentaÃ§Ã£o atual do alien
	addi t2,a4,16		# t2 = a4 + 16 (posiÃ§Ã£o atual do alien - pixel final da linha)
	
	li t0, 6400		# t0 = 6400
	sub t1,t1, t0		# volta t1 20 linhas (pixel inicial 4 linhas acima) 
	sub t2, t2, t0		# volta t2 20 linhas (pixel final 4 linhas acima)
	
	j LOOP2_MA		# pule para LOOP2_MA (loop que printa o alien na tela)
	
MOV_LEFT_A:

	mv t1, a4		# t1 = a4 (posiÃ§Ã£o atual do alien - pixel inicial da linha)
	li t4, 1		# salva em t4 a movimentaÃ§Ã£o atual do alien
	addi t2,a4,16		# t2 = a4 + 16 (posiÃ§Ã£o atual do alien - pixel final da linha)
	
	li t0, 5124		# t0 = 5124
	sub t1,t1, t0		# volta t1 16 linhas e vai 4 pixels para a esquerda (pixel inicial - 4)
	sub t2, t2, t0		# volta t1 16 linhas e vai 4 pixels para a esquerda (pixel final - 4)
	
	j LOOP2_MA		# pule para LOOP2_MA (loop que printa o alien na tela)
	
MOV_DOWN_A:

	mv t1, a4		# t1 = a4 (posiÃ§Ã£o atual do alien - pixel inicial da linha)
	li t4, 2		# salva em t4 a movimentaÃ§Ã£o atual do alien
	addi t2,a4,16		# t2 = a4 + 16 (posiÃ§Ã£o atual do alien - pixel final da linha)
	
	li t0, 3840		# t0 = 3840
	sub t1,t1, t0		# volta t1 12 linhas (pixel inicial 4 linhas abaixo) 
	sub t2, t2, t0		# volta t2 12 linhas (pixel final 4 linhas abaixo)
	
	j LOOP2_MA		# pule para LOOP2_MA (loop que printa o alien na tela)
	
MOV_RIGHT_A:

	mv t1, a4		# t1 = a4 (posiÃ§Ã£o atual do alien - pixel inicial da linha)
	li t4, 3		# salva em t4 a movimentaÃ§Ã£o atual do alien
	addi t2,a4,16		# t2 = a4 + 16 (posiÃ§Ã£o atual do alien - pixel final da linha)
	
	li t0, 5116		# t0 = 5116
	sub t1,t1, t0		# volta t1 16 linhas e vai 4 pixels para a direita (pixel inicial + 4) 
	sub t2, t2, t0		# volta t1 16 linhas e vai 4 pixels para a direita (pixel final + 4)
	
	j LOOP2_MA		# pule para LOOP2_MA (loop que printa o alien na tela)

LOOP2_MA:
	beq t1,t2,ENTER_MA	# se t1 atingir o fim da linha de pixels, quebre linha
	lw t0,0(t3)		# le uma word do endereÃ§o t3 (le 4 pixels da imagem)
	sw t0,0(t1)		# escreve a word na memÃ³ria VGA no endereÃ§o t1 (desenha 4 pixels na tela do Bitmap Display)
	
	li t0,0x100000
	add t1,t1,t0
	
	li t0, 1			# t0 = 1
	beq s7, t0, PRINT70		# se a5 = 1, entÃ£o vai para MOV_UP_A
	
	li t0, 2			# t0 = 2
	beq s7, t0, PRINT71		# se a5 = 2, entÃ£o vai para MOV_LEFT_A
	
	li t0, 3			# t0 = 3
	beq s7, t0, PRINT72		# se a5 = 3, entÃ£o vai para MOV_DOWN_A
	
	li t0, 4			# t0 = 4
	beq s7, t0, PRINT73		# se a5 = 4, entÃ£o vai para MOV_RIGHT_A
	
PRINT70:li t0,0x70707070
	sw t0,0(t1) 
	j NXTSQR
	
PRINT71:li t0,0x71717171
	sw t0,0(t1)
	j NXTSQR
	
PRINT72:li t0,0x72727272
	sw t0,0(t1)
	j NXTSQR
	
PRINT73:li t0,0x73737373
	sw t0,0(t1)
	j NXTSQR
	
NXTSQR:	li t0,0x100000
	sub t1,t1,t0
	addi t1,t1,4		# soma 4 ao endereÃ§o t1
	addi t3,t3,4		# soma 4 ao endereÃ§o t3
	j LOOP2_MA 		# volta a verificar a condiÃ§ao do loop
	
ENTER_MA:
	addi t1,t1,304		# t1 pula para o pixel inicial da linha de baixo
	addi t2,t2,320		# t2 pula para o pixel final da linha de baixo
	addi t5,t5,1          	# atualiza o contador de quebras de linha
	beq t5,t6,FIM_MOV	# termina o carregamento da imagem se 16 quebras de linha ocorrerem
	j LOOP2_MA		# pule para LOOP2_MA

# Verifica qual alien foi movimentado baseado em s7, atualiza a posiÃ§Ã£o dele e retorna para ver se mais um alien deve ser movimentado

FIM_MOV:

	li t0,1				# t0 = 1
	beq s7, t0, BLINKY_MOV		# se s7 = 1, entÃ£o vai para BLINKY_MOV
	
	li t0,2				# t0 = 2
	beq s7, t0, PINK_MOV		# se s7 = 2, entÃ£o vai para PINK_MOV
	
	li t0,3				# t0 = 3
	beq s7, t0, INKY_MOV		# se s7 = 3, entÃ£o vai para INKY_MOV
	
	li t0,4				# t0 = 4
	beq s7, t0, CLYDE_MOV		# se s7 = 4, entÃ£o vai para CLYDE_MOV
	
# Atualiza a posiÃ§Ã£o do alien movimentado	
	
BLINKY_MOV:
	la t0, POS_BLINKY   	# carrega o endereÃ§o de "POS_ROBOZINHO" no registrador t0 
    	sw t1, 0(t0)       	# guarda a word armazenada em t1 (posiÃ§Ã£o atual do Roboziho) em "POS_ROBOZINHO"
    	add s4, s4 ,t4		# adiciona ao movimento do alien o movimento atual(ex.: s4 = 17 + t4)	
	jal zero, PINK
PINK_MOV:
	la t0, POS_PINK   	# carrega o endereÃ§o de "POS_ROBOZINHO" no registrador t0 
    	sw t1, 0(t0)       	# guarda a word armazenada em t1 (posiÃ§Ã£o atual do Roboziho) em "POS_ROBOZINHO"	
    	add s9, s9, t4		# adiciona ao movimento do alien o movimento atual(ex.: s9 = 17 + t4)
	jal zero, INKY
INKY_MOV:
	la t0, POS_INKY   	# carrega o endereÃ§o de "POS_ROBOZINHO" no registrador t0 
    	sw t1, 0(t0)       	# guarda a word armazenada em t1 (posiÃ§Ã£o atual do Roboziho) em "POS_ROBOZINHO"	
    	add s10, s10, t4	# adiciona ao movimento do alien o movimento atual(ex.: s10 = 17 + t4)
	jal zero, CLYDE
CLYDE_MOV:
	la t0, POS_CLYDE   	# carrega o endereÃ§o de "POS_ROBOZINHO" no registrador t0 
    	sw t1, 0(t0)       	# guarda a word armazenada em t1 (posiÃ§Ã£o atual do Roboziho) em "POS_ROBOZINHO"
    	add s11, s11, t4	# adiciona ao movimento do alien o movimento atual(ex.: s11 = 17 + t4)
    	
    	li a7,32		# carrega em a7 o serviÃ§o 32 do ecall (sleep - interrompe a execuÃ§Ã£o do programa)
	li a0,80		# carrega em a0 o tempo pelo qual o codigo sera interrompido (2 ms)
	ecall			# realiza o ecall
	
	j ROBOZINHO
	
# Se o alien colidir com o Robozinho

COLIDIU_R:

	li t0,1				# t0 = 1
	beq s7, t0, BLINKY_COLIDIU	# se s7 = 1, entÃ£o vai para BLINKY_COLIDIU
		
	li t0,2				# t0 = 2
	beq s7, t0, PINK_COLIDIU	# se s7 = 2, entÃ£o vai para PINK_COLIDIU
		
	li t0,3				# t0 = 3
	beq s7, t0, INKY_COLIDIU	# se s7 = 3, entÃ£o vai para INKY_COLIDIU
		
	li t0,4				# t0 = 4
	beq s7, t0, CLYDE_COLIDIU	# se s7 = 4, entÃ£o vai para CLYDE_COLIDIU
	
	
BLINKY_COLIDIU:
	mv a1, s4			# a1 = s4
	jal zero, COLIDIU_R_2

PINK_COLIDIU:
	mv a1, s9			# a1 = s9
	jal zero, COLIDIU_R_2

INKY_COLIDIU:
	mv a1, s10			# a1 = s10
	jal zero, COLIDIU_R_2

CLYDE_COLIDIU:
	mv a1, s11			# a1 = s11
	
COLIDIU_R_2:
	li a0,38			# a0 = 38
	blt a1,a0,VERFASE		# se a1 for menor que o a0 então o alien estava no sdcatter/chase mode, então o robozino perdeu vida
	
VER_ALIEN_2:				# se não, ve qual o alien e respawna ele
	
	la t0, PONTOS
	lw t1, 0(t0)
	addi t1,t1,200
	sw t1, 0(t0)
	
	mv t0,a4

	li a7,104		# carrega em a7 o serviÃ§o 101 do ecall (print integer on bitmap display)
	la a0,STR3		# carrega em a0 o valor do inteiro a ser printado (s1 = pontuaÃ§Ã£o atual do jogador)
	li a1,60		# carrega em a1 a coluna a partir da qual o inteiro vai ser printado (coluna 60)
        li a2,11		# carrega em a1 a linha a partir da qual o inteiro vai ser printado (linha 2)
	li a3,0x00FF		# carrega em a3 a cor de fundo (0x00 - preto) e a cor dos caracteres (0xFF - branco)
	li a4,0			# carrega em a4 o frame onde o inteiro deve ser printado (Frame 0 da memoria VGA)
	ecall			# realiza o ecall
	
	li a0,61		# a0 = 76 (carrega mi para a0)
	li a1,200		# a1 = 100 (nota de duração de 100 ms)
	li a2,33		# a2 = 32 (timbre "guitar harmonic")
	li a3,80		# a3 = 50 (volume da nota)
	li a7,31		# a7 = 31 (carrega em a7 o ecall "MidiOut")
	ecall			# realiza o ecall
	
	li a0,73		# a0 = 76 (carrega mi para a0)
	li a1,200		# a1 = 100 (nota de duração de 100 ms)
	li a2,33		# a2 = 32 (timbre "guitar harmonic")
	li a3,80		# a3 = 50 (volume da nota)
	li a7,31		# a7 = 31 (carrega em a7 o ecall "MidiOut")
	ecall			# realiza o ecall
	
	li a0,100		# a3 = 50 (volume da nota)
	li a7,32		# a7 = 31 (carrega em a7 o ecall "MidiOut")
	ecall			# realiza o ecall
	
	li a0,59		# a0 = 76 (carrega mi para a0)
	li a1,200		# a1 = 100 (nota de duração de 100 ms)
	li a2,33		# a2 = 32 (timbre "guitar harmonic")
	li a3,80		# a3 = 50 (volume da nota)
	li a7,31		# a7 = 31 (carrega em a7 o ecall "MidiOut")
	ecall			# realiza o ecall
	
	li a0,71		# a0 = 76 (carrega mi para a0)
	li a1,200		# a1 = 100 (nota de duração de 100 ms)
	li a2,33		# a2 = 32 (timbre "guitar harmonic")
	li a3,80		# a3 = 50 (volume da nota)
	li a7,31		# a7 = 31 (carrega em a7 o ecall "MidiOut")
	ecall			# realiza o ecall
	
	li a0,100		# a3 = 50 (volume da nota)
	li a7,32		# a7 = 31 (carrega em a7 o ecall "MidiOut")
	ecall			# realiza o ecall
	
	li a0,61		# a0 = 76 (carrega mi para a0)
	li a1,200		# a1 = 100 (nota de duração de 100 ms)
	li a2,33		# a2 = 32 (timbre "guitar harmonic")
	li a3,80		# a3 = 50 (volume da nota)
	li a7,31		# a7 = 31 (carrega em a7 o ecall "MidiOut")
	ecall			# realiza o ecall
	
	li a0,73		# a0 = 76 (carrega mi para a0)
	li a1,200		# a1 = 100 (nota de duração de 100 ms)
	li a2,33		# a2 = 32 (timbre "guitar harmonic")
	li a3,80		# a3 = 50 (volume da nota)
	li a7,31		# a7 = 31 (carrega em a7 o ecall "MidiOut")
	ecall			# realiza o ecall
	
	li a0,200		# a3 = 50 (volume da nota)
	li a7,32		# a7 = 31 (carrega em a7 o ecall "MidiOut")
	ecall			# realiza o ecall
	
	li a7,104		# carrega em a7 o serviÃ§o 101 do ecall (print integer on bitmap display)
	la a0,STR4		# carrega em a0 o valor do inteiro a ser printado (s1 = pontuaÃ§Ã£o atual do jogador)
	li a1,60		# carrega em a1 a coluna a partir da qual o inteiro vai ser printado (coluna 60)
        li a2,11		# carrega em a1 a linha a partir da qual o inteiro vai ser printado (linha 2)
	li a3,0x00FF		# carrega em a3 a cor de fundo (0x00 - preto) e a cor dos caracteres (0xFF - branco)
	li a4,0			# carrega em a4 o frame onde o inteiro deve ser printado (Frame 0 da memoria VGA)
	ecall			# realiza o ecall
	
	mv a4,t0
	
	li t0,1				# t0 = 1
	beq s7, t0, BLINKY_MORTE	# se s7 = 1, entÃ£o vai para BLINKY_MORTE
		
	li t0,2				# t0 = 2
	beq s7, t0, PINK_MORTE		# se s7 = 2, entÃ£o vai para PINK_MORTE
		
	li t0,3				# t0 = 3
	beq s7, t0, INKY_MORTE		# se s7 = 3, entÃ£o vai para INKY_MORTE
		
	li t0,4				# t0 = 4
	beq s7, t0, CLYDE_MORTE		# se s7 = 4, entÃ£o vai para CLYDE_MORTE

BLINKY_MORTE:

	li t0, 17			# t0 = 17
	rem t1, s4, t0			# t1 = resto da movimentação
	li s4, 34			# s4 = 34 
	add s4, s4, t1			# s4 = 34 + t1
	
	li t0, 0xFF009BC8		# posição dentro da caixa
	la t1, POS_BLINKY		# t1 = POS_BLINKY
	sw t0, 0(t1)			# POS_BLINKY = posição dentro da caixa
	
	jal zero, SETUP_DELETE_MORTE
	
PINK_MORTE:

	li t0, 17			# t0 = 17
	rem t1, s9, t0			# t1 = resto da movimentação
	li s9, 34			# s9 = 34 
	add s9, s9, t1			# s9 = 34 + t1
	
	li t0, 0xFF009BC8		# posição dentro da caixa
	la t1, POS_PINK		# t1 = POS_PINK
	sw t0, 0(t1)			# POS_PINK = posição dentro da caixa
	
	jal zero, SETUP_DELETE_MORTE
	
INKY_MORTE:

	li t0, 17			# t0 = 17
	rem t1, s10, t0			# t1 = resto da movimentação
	li s10, 34			# s10 = 34 
	add s10, s10, t1		# s10 = 34 + t1
	
	li t0, 0xFF009BC8		# posição dentro da caixa
	la t1, POS_INKY			# t1 = POS_INKY
	sw t0, 0(t1)			# POS_INKY = posição dentro da caixa
	
	jal zero, SETUP_DELETE_MORTE
	
CLYDE_MORTE:
		
	li t0, 17			# t0 = 17
	rem t1, s11, t0			# t1 = resto da movimentação
	li s11, 34			# s11 = 34 
	add s11, s11, t1		# s11 = 34 + t1
	
	li t0, 0xFF009BC8		# posição dentro da caixa
	la t1, POS_CLYDE		# t1 = POS_CLYDE
	sw t0, 0(t1)			# POS_CLYDE = posição dentro da caixa

SETUP_DELETE_MORTE:
	
	mv t1,a4		# t1 = a4 (posiÃ§Ã£o atual do alien - pixel inicial da linha)
	addi t2,a4,16		# t2 = a4 + 16 (posiÃ§Ã£o atual do alien - pixel inicial da linha)
	mv a5,t6		# a5 = t6 (direÃ§Ã£o atual de movimentaÃ§Ã£o do alien)
	
DELETE_A_MORTE:

	li t5,0	
	li t6,16		# reinicia o contador para 16 quebras de linha
	
	li t4, 5120		# t4 = 5120
	sub t1, t1, t4		# volta t1 16 linhas (pixel inicial da primeira linha) 
	sub t2, t2, t4		# volta t2 16 linhas (pixel final da primeira linha)
	
	li t0,1
	beq s6,t0,DELFS1_MORTE
	la t3,mapa2
	j DELFS2_MORTE
DELFS1_MORTE:	
	la t3,mapa1		# carrega em t3 o endereÃ§o dos dados do mapa1
DELFS2_MORTE:	
	addi t3,t3,8		# t3 = endereÃ§o do primeiro pixel do mapa1 (depois das informaÃ§Ãµes de nlin ncol)
	li t0,0xFF000000	# t0 = 0xFF000000 (carrega em t0 o endereÃ§o base da memoria VGA)
	sub t0,t1,t0		# t0 = t1 - 0xFF000000 (subtrai o endereÃ§o base de t1, posiÃ§Ã£o atual do alien)
	add t3,t3,t0		# t3 = t3 + t0 (carrega em t3 o endereÃ§o do pixel do mapa1 no segmento de dados sobre o qual o alien esta localizado)
	
DELLOOP_A_MORTE:
	beq t1,t2,ENTER2_A_MORTE# se t1 atingir o fim da linha de pixels, quebre linha
	lw t0,0(t3)		# le uma word do endereÃ§o t3 (le 4 pixels do mapa1 no segmento de dados)
	sw t0,0(t1)		# escreve a word (4 pixels do mapa1) na memÃ³ria VGA
	addi t1,t1,4		# soma 4 ao endereÃ§o t1
	addi t3,t3,4		# soma 4 ao endereÃ§o t3
	j DELLOOP_A_MORTE	# volta a verificar a condiÃ§ao do loop

ENTER2_A_MORTE:
	addi t1,t1,304		# t1 (a4) pula para o pixel inicial da linha de baixo da memoria VGA
	addi t3,t3,304		# t1 pula para o pixel inicial da linha de baixo do segmento de dados 
	addi t2,t2,320		# t2 (a4 + 16) pula para o pixel final da linha de baixo da memoria VGA
	addi t5,t5,1          	# atualiza o contador de quebras de linha
	beq t5,t6,SETUP_DELETE_COL_MORTE # termina o carregamento da imagem se 16 quebras de linha ocorrerem e vai para o loop de carregamento da imagem
	j DELLOOP_A_MORTE		# pula para delloop
	
# Deleta o personagem caso ele morra

SETUP_DELETE_COL_MORTE:
	
	li t0,0x100000
	add t1,a4,t0
	addi t2,t1,16		# t2 = a4 + 16 (posiÃ§Ã£o atual do alien - pixel inicial da linha)
	
DELETE_A_COL_MORTE:

	li t5,0	
	li t6,16		# reinicia o contador para 16 quebras de linha
	
	li t4, 5120		# t4 = 5120
	sub t1, t1, t4		# volta t1 16 linhas (pixel inicial da primeira linha) 
	sub t2, t2, t4		# volta t2 16 linhas (pixel final da primeira linha)
	
	li t0,1
	beq s6,t0,DELFS1_COL_MORTE
	la t3,mapa2colisao
	j DELFS2_COL_MORTE
	
DELFS1_COL_MORTE:	
	la t3,mapa1colisao		# carrega em t3 o endereÃ§o dos dados do mapa1

DELFS2_COL_MORTE:	
	addi t3,t3,8		# t3 = endereÃ§o do primeiro pixel do mapa1 (depois das informaÃ§Ãµes de nlin ncol)
	li t0,0xFF100000	# t0 = 0xFF000000 (carrega em t0 o endereÃ§o base da memoria VGA)
	sub t0,t1,t0		# t0 = t1 - 0xFF000000 (subtrai o endereÃ§o base de t1, posiÃ§Ã£o atual do alien)
	add t3,t3,t0		# t3 = t3 + t0 (carrega em t3 o endereÃ§o do pixel do mapa1 no segmento de dados sobre o qual o alien esta localizado)
	
DELLOOP_A_COL_MORTE:
	beq t1,t2,ENTER2_A_COL_MORTE	# se t1 atingir o fim da linha de pixels, quebre linha
	lw t0,0(t3)		# le uma word do endereÃ§o t3 (le 4 pixels do mapa1 no segmento de dados)
	sw t0,0(t1)		# escreve a word (4 pixels do mapa1) na memÃ³ria VGA
	addi t1,t1,4		# soma 4 ao endereÃ§o t1
	addi t3,t3,4		# soma 4 ao endereÃ§o t3
	j DELLOOP_A_COL_MORTE		# volta a verificar a condiÃ§ao do loop

ENTER2_A_COL_MORTE:
	addi t1,t1,304		# t1 (a4) pula para o pixel inicial da linha de baixo da memoria VGA
	addi t3,t3,304		# t1 pula para o pixel inicial da linha de baixo do segmento de dados 
	addi t2,t2,320		# t2 (a4 + 16) pula para o pixel final da linha de baixo da memoria VGA
	addi t5,t5,1          	# atualiza o contador de quebras de linha
	beq t5,t6,FIM_MORTE	# termina o carregamento da imagem se 16 quebras de linha ocorrerem e vai para o loop de carregamento da imagem
	j DELLOOP_A_COL_MORTE	# pula para delloop
	
FIM_MORTE:
	jal ROBOZINHO 		# vai para a movimentação do robozinho

VERFASE:li t0,1
	beq s6,t0,FASE1
	jal zero, RESET_FASE2
##################################
DERROTAC: jal zero, DERROTA
VITORIAC: jal zero, VITORIA
FASE2C: jal zero, FASE2
##################################
# Parte do codigo que lida com a movimentaÃ§Ã£o do Robozinho

ROBOZINHO:

	li a7,104		# carrega em a7 o serviÃ§o 104 do ecall (print string on bitmap display)
	la a0,STR		# carrega em a0 o endereÃ§o da string a ser printada (STR: "PONTOS: ")
	li a1,0			# carrega em a1 a coluna a partir da qual a string vai ser printada (coluna 0)
       	li a2,2			# carrega em a2 a linha a partir da qual a string vai ser printada (linha 2)
	li a3,0x00FF		# carrega em a3 a cor de fundo (0x00 - preto) e a cor dos caracteres (0xFF - branco)
	li a4,0 		# carrega em a4 o frame onde a string deve ser printada (Frame 0 da memoria VGA)
	ecall			# realiza o ecall
	
	la t1, PONTOS
	lw t0, 0(t1)
	
	li a7,101		# carrega em a7 o serviÃ§o 101 do ecall (print integer on bitmap display)
	mv a0,t0		# carrega em a0 o valor do inteiro a ser printado (s1 = pontuaÃ§Ã£o atual do jogador)
	li a1,60		# carrega em a1 a coluna a partir da qual o inteiro vai ser printado (coluna 60)
        li a2,2			# carrega em a1 a linha a partir da qual o inteiro vai ser printado (linha 2)
	li a3,0x00FF		# carrega em a3 a cor de fundo (0x00 - preto) e a cor dos caracteres (0xFF - branco)
	li a4,0			# carrega em a4 o frame onde o inteiro deve ser printado (Frame 0 da memoria VGA)
	ecall			# realiza o ecall
	
	li a7,104		# carrega em a7 o serviÃ§o 104 do ecall (print string on bitmap display)
	la a0,STR2		# carrega em a0 o endereÃ§o da string a ser printada (STR2: "VIDAS: ")
	li a1,1			# carrega em a1 a coluna a partir da qual a string vai ser printada (coluna 1)
       	li a2,231		# carrega em a2 a linha a partir da qual a string vai ser printada (linha 231)
	li a3,0x00FF		# carrega em a3 a cor de fundo (0x00 - preto) e a cor dos caracteres (0xFF - branco)
	li a4,0 		# carrega em a4 o frame onde a string deve ser printada (Frame 0 da memoria VGA)
	ecall			# realiza o ecall
	
	li a7,101		# carrega em a7 o serviÃ§o 101 do ecall (print integer on bitmap display)
	mv a0,s2		# carrega em a0 o valor do inteiro a ser printado (s2 = vidas restantes do jogador)
	li a1,52		# carrega em a1 a coluna a partir da qual o inteiro vai ser printado (coluna 52)
        li a2,231		# carrega em a1 a linha a partir da qual o inteiro vai ser printado (linha 231)
	li a3,0x00FF		# carrega em a3 a cor de fundo (0x00 - preto) e a cor dos caracteres (0xFF - branco)
	li a4,0			# carrega em a4 o frame onde o inteiro deve ser printado (Frame 0 da memoria VGA)
	ecall			# realiza o ecall
	
	beq s2,zero,DERROTAC
	
	li t0,1
	beq s6,t0,VERVIC1
	j VERVIC2
	
VERVIC1:li t0,103
	bge s1,t0,FASE2C
	j FASE
	
VERVIC2:li t0,140
	bge s1,t0,VITORIAC
	j FASE
	
FASE:	li t0,0xFF200000	# carrega o endereÃ§o de controle do KDMMIO ("teclado")
	lw t1,0(t0)		# le uma word a partir do endereÃ§o de controle do KDMMIO
	andi t1,t1,0x0001	# mascara todos os bits de t1 com exceÃ§ao do bit menos significativo
   	beq t1,zero,MOVE   	# se o BMS de t1 for 0 (nÃ£o hÃ¡ tecla pressionada), pule para MOVE (continua o movimento atual do Robozinho)
 
  	lw t1,4(t0)		# le o valor da tecla pressionada e guarda em t1
  	li t2,1			# t2 = 1 (significa que o movimento a ser verificado veio de uma aÃ§Ã£o do jogador)
  	
  	li t0,72		# carrega 97 (valor hex de "a") para t0		
  	bne t1,t0,SKP_HACK1	# se t1 for igual a 97 (valor hex de "a"), vÃ¡ para VLCO (verify left colision)
  	
  	addi s1,s1,102
  	
SKP_HACK1:

	li t0,75		# carrega 97 (valor hex de "a") para t0		
  	bne t1,t0,SKP_HACK2	# se t1 for igual a 97 (valor hex de "a"), vÃ¡ para VLCO (verify left colision)
  	
  	addi s1,s1,139
  	
SKP_HACK2:

	li t0,97		# carrega 97 (valor hex de "a") para t0		
  	beq t1,t0,VLCO		# se t1 for igual a 97 (valor hex de "a"), vÃ¡ para VLCO (verify left colision)
  	
  	li t0,119		# carrega 119 (valor hex de "w") para t0
  	beq t1,t0,VUCO		# se t6 for igual a 119 (valor hex de "w"), vÃ¡ para VUCO (verify up colision)
  	
  	li t0,115		# carrega 115 (valor hex de "s") para t0
  	beq t1,t0,VDCO		# se t1 for igual a 115 (valor hex de "s"), vÃ¡ para VDCO (verify down colision)
  	
  	li t0,100  		# carrega 100 (valor hex de "d") para t0
	beq t1,t0,VRCO		# se t1 for igual a 100 (valor hex de "d"), vÃ¡ para VRCO (verify right colision)
	
MOVE:  	li t2,2			# t2 = 2 (significa que o movimento a ser verificado nÃ£o veio de uma aÃ§Ã£o do jogador)

	li t0,0			# carrega 0 para t0
  	beq s3,t0,FIM		# se s3 for igual a 0 (valor de movimento atual nulo), vÃ¡ para FIM
  	
  	li t0,1			# carrega 1 para t0
  	beq s3,t0,VLCO		# se s3 for igual a 1 (valor de movimento atual para a esquerda), vÃ¡ para VLCO (verify left colision)
  	
  	li t0,2			# carrega 2 para t0
  	beq s3,t0,VUCO		# se s3 for igual a 2 (valor de movimento atual para cima), vÃ¡ para VUCO (verify up colision)
  	
  	li t0,3  		# carrega 3 para t0
	beq s3,t0,VDCO		# se s3 for igual a 3 (valor de movimento atual para baixo), vÃ¡ para VDCO (verify down colision)
	
	li t0,4  		# carrega 4 para t0
	beq s3,t0,VRCO		# se s3 for igual a 4 (valor de movimento atual para a direita), vÃ¡ para VRCO (verify right colision)
	
# Verifica a colisao do mapa (VLCO, VUCO, VDCO e VRCO carregam 5 ou 6 pixels de detecÃ§Ã£o de colisÃ£o em cada direÃ§Ã£o, e VERC verifica se algum desses pixels detectou uma colisÃ£o adiante)

#	   @7       @8          @9          @10         @11
#	@6 #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  @12
#	   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  
#	   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  
#	@5 #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  @13
#	   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  
#	   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  
#	@4 #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  @14
#	   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #			# representaÃ§Ã£o do Robozinho 16x16 com "#"
#	   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  			# os "@x" sÃ£o os pixels de colisÃ£o carregados ao redor do Robozinho (o endereÃ§o de "@x" Ã© calculado em relaÃ§Ã£o ao endereÃ§o em POS_ROBOZINHO, sendo "@22" igual a prÃ³pria posiÃ§Ã£o)
#	@3 #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  @15			# OBS: os pixels de colisÃ£o detectam colisÃµes apenas em relaÃ§Ã£o ao mapa desenhado no Frame 1 da memÃ³ria VGA (mapa de colisÃ£o)
#	   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #
#	   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #
#	@2 #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  @16
#	   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #
#	   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #
#	@1 #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  @17
#	   @22(POS) @21	        @20         @19         @18

# Carrega pixels de colisÃ£o a esquerda (@1, @2, @3, @4, @5, @6)

VLCO:   la t0,POS_ROBOZINHO	# carrega o endereÃ§o de "POS_ROBOZINHO" no registrador t0
	lw t1,0(t0)		# le a word guardada em "POS_ROBOZINHO" para t1 (t1 = posiÃ§Ã£o atual do Robozinho)
	addi t1,t1,-321		# volta t1 1 linha e 1 pixel (carrega em t1 o endereÃ§o do pixel "@1")
	jal ra, VERC		# vÃ¡ para VERC (verifica se o pixel "@1" detectou uma colisÃ£o)
			
	addi t1,t1,-1281	# volta t1 4 linhas e 1 pixel (carrega em t1 o endereÃ§o do pixel "@2")
	jal ra, VERC		# vÃ¡ para VER (verifica se o pixel "@2" detectou uma colisÃ£o)
	
	li t0,-2241		# t0 = -2241
	add t1,t1,t0		# volta t1 7 linhas e 1 pixel (carrega em t1 o endereÃ§o do pixel "@3")
	jal ra, VERC		# vÃ¡ para VERC (verifica se o pixel "@3" detectou uma colisÃ£o)
	
	li t0,-3201		# t0 = -3201
	add t1,t1,t0		# volta t1 10 linhas e 1 pixel (carrega em t1 o endereÃ§o do pixel "@4")
	jal ra, VERC		# vÃ¡ para VERC (verifica se o pixel "@4" detectou uma colisÃ£o)
	
	li t0,-4161		# t0 = -5121
	add t1,t1,t0		# volta t1 13 linhas e 1 pixel (carrega em t1 o endereÃ§o do pixel "@5")
	jal ra, VERC		# vÃ¡ para VERC (verifica se o pixel "@5" detectou uma colisÃ£o)
	
	li t0,-5121		# t0 = -5121
	add t1,t1,t0		# volta t1 16 linhas e 1 pixel (carrega em t1 o endereÃ§o do pixel "@6")
	jal ra, VERC		# vÃ¡ para VERC (verifica se o pixel "@6" detectou uma colisÃ£o)
	
	li s3,1			# se nenhuma colisÃ£o foi detectada, movimentaÃ§Ã£o atual = 1 (esquerda)
	j VLP			# se nenhuma colisÃ£o foi detectada, vÃ¡ para VLP (Verify Left Point)
	
# Carrega pixels de colisÃ£o acima (@7, @8, @9, @10, @11)

VUCO:	la t0,POS_ROBOZINHO	# carrega o endereÃ§o de "POS_ROBOZINHO" no registrador t0
	lw t1,0(t0)		# le a word guardada em "POS_ROBOZINHO" para t1 (t1 = posiÃ§Ã£o atual do Robozinho)
	li t0,-5440		# t0 = -5440
	add t1,t1,t0		# volta t1 17 linhas (carrega em t1 o endereÃ§o do pixel "@7")
	jal ra, VERC		# vÃ¡ para VERC (verifica se o pixel "@7" detectou uma colisÃ£o)
	
	li t0,-5437		# t0 = -5437
	add t1,t1,t0		# t1 volta 17 linhas e vai 3 pixels pra frente (carrega em t1 o endereÃ§o do pixel "@8")
	jal ra, VERC		# vÃ¡ para VERC (verifica se o pixel "@8" detectou uma colisÃ£o)
	
	li t0,-5433		# t0 = -5433
	add t1,t1,t0		# t1 volta 17 linhas e vai 7 pixels pra frente (carrega em t1 o endereÃ§o do pixel "@9")
	jal ra, VERC		# vÃ¡ para VERC (verifica se o pixel "@9" detectou uma colisÃ£o)
	
	li t0,-5429		# t0 = -5429
	add t1,t1,t0		# t1 volta 17 linhas e vai 11 pixels pra frente (carrega em t1 o endereÃ§o do pixel "@10")
	jal ra, VERC		# vÃ¡ para VERC (verifica se o pixel "@10" detectou uma colisÃ£o)
	
	li t0,-5425		# t0 = -5425
	add t1,t1,t0		# t1 volta 17 linhas e vai 15 pixels pra frente (carrega em t1 o endereÃ§o do pixel "@11")
	jal ra, VERC		# vÃ¡ para VERC (verifica se o pixel "@11" detectou uma colisÃ£o)

	li s3,2			# se nenhuma colisÃ£o foi detectada, movimentaÃ§Ã£o atual = 2 (cima)
	j VUP			# se nenhuma colisÃ£o foi detectada, vÃ¡ para VUP (Verify Up Point)
	
# Carrega pixels de colisÃ£o abaixo (@22, @21, @20, @19, @18)
 
VDCO:	la t0,POS_ROBOZINHO	# carrega o endereÃ§o de "POS_ROBOZINHO" no registrador t0
	lw t1,0(t0)		# le a word guardada em "POS_ROBOZINHO" para t1 (t1 = posiÃ§Ã£o atual do Robozinho)
	jal ra, VERC		# vÃ¡ para VERC (verifica se o pixel "@22" detectou uma colisÃ£o)
	
	addi t1,t1,3		# t1 vai 3 pixels pra frente (carrega em t1 o endereÃ§o do pixel "@21")
	jal ra, VERC		# vÃ¡ para VERC (verifica se o pixel "@21" detectou uma colisÃ£o)
	
	addi t1,t1,7		# t1 vai 7 pixels pra frente (carrega em t1 o endereÃ§o do pixel "@20")
	jal ra, VERC		# vÃ¡ para VERC (verifica se o pixel "@20" detectou uma colisÃ£o)
	
	addi t1,t1,11		# t1 vai 11 pixels pra frente (carrega em t1 o endereÃ§o do pixel "@19")
	jal ra, VERC		# vÃ¡ para VERC (verifica se o pixel "@19" detectou uma colisÃ£o)
	
	addi t1,t1,15		# t1 vai 15 pixels pra frente (carrega em t1 o endereÃ§o do pixel "@18")
	jal ra, VERC		# vÃ¡ para VERC (verifica se o pixel "@18" detectou uma colisÃ£o)
	
	li s3,3			# se nenhuma colisÃ£o foi detectada, movimentaÃ§Ã£o atual = 3 (baixo)
	j VDP			# se nenhuma colisÃ£o foi detectada, vÃ¡ para VDP (Verify Down Point)
	
# Carrega pixels de colisÃ£o a direita (@17, @16, @15, @14, @13, @12)
 
VRCO:	la t0,POS_ROBOZINHO	# carrega o endereÃ§o de "POS_ROBOZINHO" no registrador t0
	lw t1,0(t0)		# le a word guardada em "POS_ROBOZINHO" para t1 (t1 = posiÃ§Ã£o atual do Robozinho)
	addi t1,t1,-304		# t1 volta 1 linha e vai 16 pixels pra frente (carrega em t1 o endereÃ§o do pixel "@17")
	jal ra, VERC		# vÃ¡ para VERC (verifica se o pixel "@17" detectou uma colisÃ£o)
	
	addi t1,t1,-1264	# t1 volta 4 linhas e vai 16 pixels pra frente (carrega em t1 o endereÃ§o do pixel "@16")
	jal ra, VERC 		# vÃ¡ para VERC (verifica se o pixel "@16" detectou uma colisÃ£o)
	
	li t0,-2224		# t0 = -2224
	add t1,t1,t0		# t1 volta 7 linhas e vai 16 pixels pra frente (carrega em t1 o endereÃ§o do pixel "@15")
	jal ra, VERC		# vÃ¡ para VERC (verifica se o pixel "@15" detectou uma colisÃ£o)
	
	li t0,-3184		# t0 = -3184
	add t1,t1,t0		# t1 volta 10 linhas e vai 16 pixels pra frente (carrega em t1 o endereÃ§o do pixel "@14")
	jal ra, VERC		# vÃ¡ para VERC (verifica se o pixel "@14" detectou uma colisÃ£o)
	
	li t0,-4144		# t0 = -4144
	add t1,t1,t0		# t1 volta 13 linhas e vai 16 pixels pra frente (carrega em t1 o endereÃ§o do pixel "@13")
	jal ra, VERC		# vÃ¡ para VERC (verifica se o pixel "@13" detectou uma colisÃ£o)
	
	li t0,-5104		# t0 = -5104
	add t1,t1,t0		# t1 volta 16 linhas e vai 16 pixels pra frente (carrega em t1 o endereÃ§o do pixel "@12")
	jal ra, VERC		# vÃ¡ para VERC (verifica se o pixel "@12" detectou uma colisÃ£o)
	
	li s3,4			# se nenhuma colisÃ£o foi detectada, movimentaÃ§Ã£o atual = 4 (direita)
	j VRP			# se nenhuma colisÃ£o foi detectada, vÃ¡ para VRP (Verify Right Point)
	
# Verifica se algum dos pixels de colisÃ£o detectou alguma colisÃ£o
 
VERC:	li t0,0x100000		# t0 = 0x100000
	add t1,t1,t0		# soma 0x100000 a t1 (transforma o conteudo de t1 em um endereÃ§o do Frame 1)
	lbu t0,0(t1)		# carrega em t0 um byte do endereÃ§o t1 (cor do pixel de t1) -> OBS: o load byte deve ser "unsigned" 
				# Ex: 0d200 = 0xc8 = 0b11001000. como o MSB desse byte Ã© 1, ele seria interpretado como -56 e nÃ£o 200 (t0 = 0xffffffc8)
				
	li t1,0x70		# t1 = 200
	beq t0,t1,COL_BLINKY	# se t0 = 200, vÃ¡ para VERWAY (se a cor do pixel for azul, verifica se o movimento do Robozinho foi causado ou nÃ£o pelo jogador)
	
	li t1,0x71		# t1 = 200
	beq t0,t1,COL_PINK	# se t0 = 200, vÃ¡ para VERWAY (se a cor do pixel for azul, verifica se o movimento do Robozinho foi causado ou nÃ£o pelo jogador)
	
	li t1,0x72		# t1 = 200
	beq t0,t1,COL_INKY	# se t0 = 200, vÃ¡ para VERWAY (se a cor do pixel for azul, verifica se o movimento do Robozinho foi causado ou nÃ£o pelo jogador)
	
	li t1,0x73		# t1 = 200
	beq t0,t1,COL_CLYDE	# se t0 = 200, vÃ¡ para VERWAY (se a cor do pixel for azul, verifica se o movimento do Robozinho foi causado ou nÃ£o pelo jogador)
	
	li t1,200		# t1 = 200
	beq t0,t1,VERWAY	# se t0 = 200, vÃ¡ para VERWAY (se a cor do pixel for azul, verifica se o movimento do Robozinho foi causado ou nÃ£o pelo jogador)
	
	li t1,240		# t1 = 240
	beq t0,t1,VERWAY	# se t0 = 240, vÃ¡ para VERWAY (se a cor do pixel for o da porta da caixa dos aliens, verifica se o movimento do Robozinho foi causado ou nÃ£o pelo jogador)
	
	li t1,3			# t1 = 3
	beq t0,t1,LPORTAL	# se t0 = 3, vÃ¡ para LPORTAL (se a cor do pixel for vermelho-3, o Robozinho teletransporta)
	
	li t1,7			# t1 = 7
	beq t0,t1,RPORTAL	# se t0 = 7, vÃ¡ para RPORTAL (se a cor do pixel for vermelho-7, o Robozinho teletransporta)
	
	la t0,POS_ROBOZINHO	# carrega o endereÃ§o de "POS_ROBOZINHO" no registrador t0
	lw t1,0(t0)		# le a word guardada em "POS_ROBOZINHO" para t1 (t1 = posiÃ§Ã£o atual do Robozinho)
	ret 			# retorna para verificar se outro pixel detectou colisÃ£o
	
# Verifica se o movimento atual do Robozinho foi ou nÃ£o causado pelo jogador. Se foi, vai para uma segunda checagem de colisÃ£o (se a direÃ§Ã£o escolhida pelo jogador nÃ£o Ã© permitida, o jogo verifica se a direÃ§Ã£o atual de movimento do Robozinho ainda Ã© permitida)

VERWAY: li t0,2			# t0 = 2
	beq t2,t0,FIM		# se t2 = 2 (movimento nÃ£o causado pelo jogador), vÃ¡ para FIM (nÃ£o precisa checar segunda colisÃ£o)
	
	li t2,2			# atualiza o valor de t2 para indicar que o movimento a ser checado nÃ£o Ã© mais causado pelo jogador
  	
  	li t0,0
  	beq s3,t0,FIM
  	
  	li t0,1			# carrega 1 para t0
  	beq s3,t0,VLCO		# se s3 for igual a 1 (valor de movimento atual para a esquerda), vÃ¡ para VLCO (verify left colision)
  	
  	li t0,2			# carrega 2 para t0
  	beq s3,t0,VUCO		# se s3 for igual a 2 (valor de movimento atual para cima), vÃ¡ para VUCO (verify up colision)
  	
  	li t0,3  		# carrega 3 para t0
	beq s3,t0,VDCO		# se s3 for igual a 3 (valor de movimento atual para baixo), vÃ¡ para VDCO (verify down colision)
	
	li t0,4  		# carrega 4 para t0
	beq s3,t0,VRCO		# se s3 for igual a 4 (valor de movimento atual para a direita), vÃ¡ para VRCO (verify right colision)
	
# Realiza a movimentaÃ§Ã£o do Robozinho atraves dos portais

LPORTAL:li a4,2121
	li s3,1			# se nenhuma colisÃ£o foi detectada, movimentaÃ§Ã£o atual = 1 (esquerda)
	j VLP			# se nenhuma colisÃ£o foi detectada, vÃ¡ para VLP (Verify Left Point)

RPORTAL:li a4,2222
	li s3,4			# se nenhuma colisÃ£o foi detectada, movimentaÃ§Ã£o atual = 4 (direita)
	j VRP			# se nenhuma colisÃ£o foi detectada, vÃ¡ para VRP (Verify Right Point)
	
# Verifica a colisÃ£o com pontos e incrementa o contador de pontos (extremamente nÃ£o otimizado, mas eh oq ta tendo pra hj)

#		U
#          	@4
#          	@3
#	   	@2
#	   	@1      
#	   	#  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #
#	   	#  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  
#	   	#  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  
#	   	#  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  
#	   	#  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  
#	   	#  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  
#	   	#  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  
#	   	#  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #			# representaÃ§Ã£o do Robozinho 16x16 com "#"
#	   	#  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  		# os "@x" sÃ£o as linhas/colunas de detecÃ§Ã£o de pontos carregadas ao redor do Robozinho (o endereÃ§o de "@x" Ã© calculado em relaÃ§Ã£o ao endereÃ§o em POS_ROBOZINHO)
#	   	#  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #
#	   	#  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #
#	   	#  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  
#	   	#  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #		 
#	   	#  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #		 
#    L @4@3@2@1 #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  @1@2@3@4 R
#	   	@1(POS)  				        
#	   	@2						
#	   	@3						
#	   	@4
#		D 

# Carrega colunas de detecÃ§Ã£o de pontos a esquerda (L - @1 @2 @3 @4)

VLP: 	la t0,POS_ROBOZINHO	# carrega o endereÃ§o de "POS_ROBOZINHO" no registrador t0
	lw t1,0(t0)		# le a word guardada em "POS_ROBOZINHO" para t1 (t1 = posiÃ§Ã£o atual do Robozinho)
	li t0,-5120		# t0 = -5120
	addi t1,t1,-1		# volta t1 1 pixel (carrega em t1 o endereÃ§o inicial da coluna "@1" uma linha abaixo)
	add t0,t1,t0		# t0 = t1 - 5120 (carrega em t0 o endereÃ§o final da coluna "@1", pois volta t1 16 linhas)
	li t2,-320		# t2 = -320 (carrega em t2 o "offset" de um pixel para o outro)
	li t3,4			# t3 = 4 (carrega em t3 um contador para verificar apenas 4 colunas)
	jal ra, VERP		# vÃ¡ para VERP (verifica se hÃ¡ ponto na coluna "@1")
	
	addi t1,t1,-2		# volta t1 2 pixels (carrega em t1 o endereÃ§o inicial da coluna "@2" uma linha abaixo)
	li t0,-5120		# t0 = -5120
	add t0,t1,t0		# t0 = t1 - 5120 (carrega em t0 o endereÃ§o final da coluna "@2", pois volta t1 16 linhas)
	jal ra, VERP		# vÃ¡ para VERP (verifica se hÃ¡ ponto na coluna "@2")
	
	addi t1,t1,-3		# volta t1 3 pixels (carrega em t1 o endereÃ§o inicial da coluna "@3" uma linha abaixo)
	li t0,-5120		# t0 = -5120
	add t0,t1,t0		# t0 = t1 - 5120 (carrega em t0 o endereÃ§o final da coluna "@3", pois volta t1 16 linhas)
	jal ra, VERP		# vÃ¡ para VERP (verifica se hÃ¡ ponto na coluna "@3")
	
	addi t1,t1,-4		# volta t1 4 pixels (carrega em t1 o endereÃ§o inicial da coluna "@4" uma linha abaixo)
	li t0,-5120		# t0 = -5120
	add t0,t1,t0		# t0 = t1 - 5120 (carrega em t0 o endereÃ§o final da coluna "@4", pois volta t1 16 linhas)
	jal ra, VERP		# vÃ¡ para VERP (verifica se hÃ¡ ponto na coluna "@4")
	
# Carrega linhas de detecÃ§Ã£o de pontos acima (U - @1 @2 @3 @4)
	
VUP:	la t0,POS_ROBOZINHO	# carrega o endereÃ§o de "POS_ROBOZINHO" no registrador t0
	lw t1,0(t0)		# le a word guardada em "POS_ROBOZINHO" para t1 (t1 = posiÃ§Ã£o atual do Robozinho)
	li t0, -5441		# t0 = -5441
	add t1,t1,t0		# volta t1 1 pixel e 17 linhas (carrega em t1 o endereÃ§o inicial da linha "@1" um pixel para a esquerda)
	addi t0,t1,16		# t0 = t1 + 16 (carrega em t0 o endereÃ§o final da linha "@1", pois avanÃ§a t1 16 pixels)
	li t2,1			# t2 = 1 (carrega em t2 o "offset" de um pixel para o outro)
	li t3,4			# t3 = 4 (carrega em t3 um contador para verificar 4 linhas)
	jal ra, VERP		# vÃ¡ para VERP (verifica se hÃ¡ ponto na linha "@1")
	
	li t0, -5761		# t0 = -5761
	add t1,t1,t0		# volta t1 1 pixel e 18 linhas (carrega em t1 o endereÃ§o inicial da linha "@2" um pixel para a esquerda)
	addi t0,t1,16		# t0 = t1 + 16 (carrega em t0 o endereÃ§o final da linha "@2", pois avanÃ§a t1 16 pixels)
	jal ra, VERP		# vÃ¡ para VERP (verifica se hÃ¡ ponto na linha "@2")
	
	li t0, -6081		# t0 = -6081
	add t1,t1,t0		# volta t1 1 pixel e 19 linhas (carrega em t1 o endereÃ§o inicial da linha "@3" um pixel para a esquerda)
	addi t0,t1,16		# t0 = t1 + 16 (carrega em t0 o endereÃ§o final da linha "@3", pois avanÃ§a t1 16 pixels)
	jal ra, VERP		# vÃ¡ para VERP (verifica se hÃ¡ ponto na linha "@3")
	
	li t0, -6401		# t0 = -6401
	add t1,t1,t0		# volta t1 1 pixel e 20 linhas (carrega em t1 o endereÃ§o inicial da linha "@4" um pixel para a esquerda)
	addi t0,t1,16		# t0 = t1 + 16 (carrega em t0 o endereÃ§o final da linha "@4", pois avanÃ§a t1 16 pixels)
	jal ra, VERP		# vÃ¡ para VERP (verifica se hÃ¡ ponto na coluna "@4")
	
# Carrega linhas de detecÃ§Ã£o de pontos abaixo (D - @1 @2 @3 @4)
	
VDP:	la t0,POS_ROBOZINHO	# carrega o endereÃ§o de "POS_ROBOZINHO" no registrador t0
	lw t1,0(t0)		# le a word guardada em "POS_ROBOZINHO" para t1 (t1 = posiÃ§Ã£o atual do Robozinho)
	addi t1,t1,-1		# volta t1 1 pixel (carrega em t1 o endereÃ§o inicial da linha "@1" um pixel para a esquerda)
	addi t0,t1,16		# t0 = t1 + 16 (carrega em t0 o endereÃ§o final da linha "@1", pois avanÃ§a t1 16 pixels)
	li t2,1			# t2 = 1 (carrega em t2 o "offset" de um pixel para o outro)
	li t3,4			# t3 = 4 (carrega em t3 um contador para verificar 4 linhas)
	jal ra, VERP		# vÃ¡ para VERP (verifica se hÃ¡ ponto na linha "@1")
			
	addi t1,t1,319		# volta t1 1 pixel e avanÃ§a t1 1 linha (carrega em t1 o endereÃ§o inicial da linha "@2" um pixel para a esquerda)
	addi t0,t1,16		# t0 = t1 + 16 (carrega em t0 o endereÃ§o final da linha "@2", pois avanÃ§a t1 16 pixels)
	jal ra, VERP		# vÃ¡ para VERP (verifica se hÃ¡ ponto na linha "@2")
			
	addi t1,t1,639		# volta t1 1 pixel e avanÃ§a t1 2 linhas (carrega em t1 o endereÃ§o inicial da linha "@3" um pixel para a esquerda)
	addi t0,t1,16		# t0 = t1 + 16 (carrega em t0 o endereÃ§o final da linha "@3", pois avanÃ§a t1 16 pixels)
	jal ra, VERP		# vÃ¡ para VERP (verifica se hÃ¡ ponto na linha "@3")
			
	addi t1,t1,959		# volta t1 1 pixel e avanÃ§a t1 3 linhas (carrega em t1 o endereÃ§o inicial da linha "@4" um pixel para a esquerda)
	addi t0,t1,16		# t0 = t1 + 16 (carrega em t0 o endereÃ§o final da linha "@4", pois avanÃ§a t1 16 pixels)
	jal ra, VERP		# vÃ¡ para VERP (verifica se hÃ¡ ponto na linha "@4")
	
# Carrega colunas de detecÃ§Ã£o de pontos a direita (R - @1 @2 @3 @4)

VRP:	la t0,POS_ROBOZINHO	# carrega o endereÃ§o de "POS_ROBOZINHO" no registrador t0
	lw t1,0(t0)		# le a word guardada em "POS_ROBOZINHO" para t1 (t1 = posiÃ§Ã£o atual do Robozinho)
	addi t1,t1,16		# avanÃ§a t1 16 pixels (carrega em t1 o endereÃ§o inicial da coluna "@1" uma linha abaixo)
	li t0,-5120		# t0 = -5120
	add t0,t1,t0		# t0 = t1 - 5120 (carrega em t0 o endereÃ§o final da coluna "@1", pois volta t1 16 linhas)
	li t2,-320		# t2 = -320 (carrega em t2 o "offset" de um pixel para o outro)
	li t3,4			# t3 = 4 (carrega em t3 um contador para verificar 4 colunas)
	jal ra, VERP		# vÃ¡ para VERP (verifica se hÃ¡ ponto na coluna "@1")
	
	addi t1,t1,17		# avanÃ§a t1 17 pixels (carrega em t1 o endereÃ§o inicial da coluna "@2" uma linha abaixo)
	li t0,-5120		# t0 = -5120
	add t0,t1,t0		# t0 = t1 - 5120 (carrega em t0 o endereÃ§o final da coluna "@2", pois volta t1 16 linhas)
	jal ra, VERP		# vÃ¡ para VERP (verifica se hÃ¡ ponto na coluna "@2")
	
	addi t1,t1,18		# avanÃ§a t1 18 pixels (carrega em t1 o endereÃ§o inicial da coluna "@3" uma linha abaixo)
	li t0,-5120		# t0 = -5120
	add t0,t1,t0		# t0 = t1 - 5120 (carrega em t0 o endereÃ§o final da coluna "@3", pois volta t1 16 linhas)
	jal ra, VERP		# vÃ¡ para VERP (verifica se hÃ¡ ponto na coluna "@3")
	
	addi t1,t1,19		# avanÃ§a t1 19 pixels (carrega em t1 o endereÃ§o inicial da coluna "@4" uma linha abaixo)
	li t0,-5120		# t0 = -5120
	add t0,t1,t0		# t0 = t1 - 5120 (carrega em t0 o endereÃ§o final da coluna "@4", pois volta t1 16 linhas)
	jal ra, VERP		# vÃ¡ para VERP (verifica se hÃ¡ ponto na coluna "@4")

# Verifica se algum dos pixels de pontuaÃ§Ã£o detectou algum ponto
 
VERP:	add t1,t1,t2		# t1 = t1 + offset (pula para o pixel seguinte da linha\coluna)
	lbu t4,0(t1)		# carrega em t4 um byte do endereÃ§o t1 (cor do pixel de t1)
	li t5,63		# t5 = 63 (cor amarela)
	beq t4,t5,PONTO		# se t4 = 63, vÃ¡ para PONTO (atualiza o contador de pontos e termina a busca por pontos a serem coletados)
	li t5,127
	beq t4,t5,SPRPNT
	beq t1,t0,NXTLINE	# se t1 = t0, vÃ¡ para NXTLINE (se o endereÃ§o analisado for o Ãºltimo da linha/coluna, pule para a linha/coluna seguinte)
	j VERP			# pule para VERP (se nenhum ponto foi detectado, volte para o inÃ­cio do loop)
	
NXTLINE:addi t3,t3,-1		# t3 = t3 - 1 (reduz o contador de linhas/colunas analisadas)
	beq t3,zero,DELETE	# se t3 = 0, vÃ¡ para DELETE (se nenhum ponto for encontrado, apenas mova o Robozinho)
	la t0,POS_ROBOZINHO	# carrega o endereÃ§o de "POS_ROBOZINHO" no registrador t0
	lw t1,0(t0)		# le a word guardada em "POS_ROBOZINHO" para t1 (t1 = posiÃ§Ã£o atual do Robozinho)
	ret 			# retorna para verificar se outro pixel detectou pontos 
	
PONTO:  addi s1,s1,1		# incrementa o contador de pontos (a sessÃ£o a seguir toca uma triade de mi maior para cada ponto coletado)

	la t5, PONTOS
	lw t6, 0(t5)
	addi t6,t6,10
	sw t6, 0(t5)
	
	li a0,68		# a0 = 68 (carrega sol sustenido para a0)
	li a1,100		# a1 = 100 (nota de duraÃ§Ã£o de 100 ms)
	li a2,35		# a2 = 35 (timbre "electric bass")
	li a3,50		# a3 = 50 (volume da nota)
	li a7,31		# a7 = 31 (carrega em a7 o ecall "MidiOut")
	ecall			# realiza o ecall
	
	li a0,71		# a0 = 71 (carrega si para a0)
	li a1,100		# a1 = 100 (nota de duraÃ§Ã£o de 100 ms)
	li a2,32		# a2 = 32 (timbre "guitar harmonic")
	li a3,50		# a3 = 50 (volume da nota)
	li a7,31		# a7 = 31 (carrega em a7 o ecall "MidiOut")
	ecall			# realiza o ecall
	
	li a0,76		# a0 = 76 (carrega mi para a0)
	li a1,100		# a1 = 100 (nota de duraÃ§Ã£o de 100 ms)
	li a2,32		# a2 = 32 (timbre "guitar harmonic")
	li a3,50		# a3 = 50 (volume da nota)
	li a7,31		# a7 = 31 (carrega em a7 o ecall "MidiOut")
	ecall			# realiza o ecall
	
	addi t3,t3,-1		# t3 = t3 - 1 (reduz o contador de linhas/colunas analisadas)
	beq t3,zero,DELPNT	# se t3 = 0, vÃ¡ para DELPNT (se o ponto foi encontrado na Ãºltima linha/coluna analisada, deve-se apagar o restante do ponto)
	j DELETE		# pule para DELETE (se o ponto foi encontrado nas 3 primeiras linhas/colunas, apenas mova o Robozinho)

DELPNT:	li t3,1			# carrega 1 para t3
  	beq s3,t3,DELLFT	# se s3 for igual a 1 (valor de movimento atual para a esquerda), vÃ¡ para DELLFT
  	
  	li t3,2			# carrega 2 para t3
  	beq s3,t3,DELUP		# se s3 for igual a 2 (valor de movimento atual para cima), vÃ¡ para DELUP
  	
  	li t3,3  		# carrega 3 para t3
	beq s3,t3,DELDWN	# se s3 for igual a 3 (valor de movimento atual para baixo), vÃ¡ para DELDWN
	
	li t3,4  		# carrega 4 para t3
	beq s3,t3,DELRGHT	# se s3 for igual a 4 (valor de movimento atual para a direita), vÃ¡ para DELRGHT
	
DELLFT: addi t1,t1,-1		# t1 = t1 - 1 (carrega o endereÃ§o do pixel inferior esquerdo do ponto detectado)
	sb zero,0(t1)		# grava 0 no conteÃºdo do endereÃ§o t1 (apaga o pixel carregado anteriormente da memoria VGA/tela)
	addi t1,t1,-320		# t1 = t1 - 320 (carrega o endereÃ§o do pixel superior esquerdo do ponto detectado)
	sb zero,0(t1)		# grava 0 no conteÃºdo do endereÃ§o t1 (apaga o pixel carregado anteriormente da memoria VGA/tela)
	
	li t3,0xFF000000	# t3 = 0xFF000000 (carrega em t3 o endereÃ§o base da memoria VGA)
	sub t3,t1,t3		# t3 = t1 - 0xFF000000 (subtrai o endereÃ§o base de t1, posiÃ§Ã£o do pixel a ser apagado)
	
	li t4,1
	beq s6,t4,DELL1
	la t5,mapa2
	j DELL2
	
DELL1:	la t5,mapa1		# carrega em t5 o endereÃ§o dos dados do mapa1 
DELL2:	addi t5,t5,8		# t5 = endereÃ§o do primeiro pixel do mapa1 (depois das informaÃ§Ãµes de nlin ncol)
	add t5,t5,t3		# t5 = t5 + t3 (carrega em t5 o endereÃ§o do pixel do mapa1 a ser apagado) 
	sb zero,0(t5)		# grava 0 no conteÃºdo do endereÃ§o t5 (apaga o pixel carregado anteriormente do mapa1 no segmento de dados)
		
	addi t1,t1,320		# t1 = t1 + 320 (carrega o endereÃ§o do pixel inferior esquerdo do ponto detectado)
	li t3,0xFF000000	# t3 = 0xFF000000 (carrega em t3 o endereÃ§o base da memoria VGA)
	sub t3,t1,t3		# t3 = t1 - 0xFF000000 (subtrai o endereÃ§o base de t1, posiÃ§Ã£o do pixel a ser apagado)
	
	li t4,1
	beq s6,t4,DELL3
	la t5,mapa2
	j DELL4
	
DELL3:	la t5,mapa1		# carrega em t5 o endereÃ§o dos dados do mapa1 
DELL4:	addi t5,t5,8		# t5 = endereÃ§o do primeiro pixel do mapa1 (depois das informaÃ§Ãµes de nlin ncol)
	add t5,t5,t3		# t5 = t5 + t3 (carrega em t5 o endereÃ§o do pixel do mapa1 a ser apagado)
	sb zero,0(t5)		# grava 0 no conteÃºdo do endereÃ§o t5 (apaga o pixel carregado anteriormente do mapa1 no segmento de dados)
	
	j DELETE 		# pule para DELETE
	
DELUP:	addi t1,t1,-320		# t1 = t1 - 320 (carrega o endereÃ§o do pixel superior esquerdo do ponto detectado)
	sb zero,0(t1)		# grava 0 no conteÃºdo do endereÃ§o t1 (apaga o pixel carregado anteriormente da memoria VGA/tela)
	addi t1,t1,1		# t1 = t1 + 1 (carrega o endereÃ§o do pixel superior direito do ponto detectado)
	sb zero,0(t1)		# grava 0 no conteÃºdo do endereÃ§o t1 (apaga o pixel carregado anteriormente da memoria VGA/tela)
	
	li t3,0xFF000000	# t3 = 0xFF000000 (carrega em t3 o endereÃ§o base da memoria VGA)
	sub t3,t1,t3		# t3 = t1 - 0xFF000000 (subtrai o endereÃ§o base de t1, posiÃ§Ã£o do pixel a ser apagado)
	
	li t4,1
	beq s6,t4,DELU1
	la t5,mapa2
	j DELU2
	
DELU1:	la t5,mapa1		# carrega em t5 o endereÃ§o dos dados do mapa1 
DELU2:	addi t5,t5,8		# t5 = endereÃ§o do primeiro pixel do mapa1 (depois das informaÃ§Ãµes de nlin ncol)
	add t5,t5,t3		# t5 = t5 + t3 (carrega em t5 o endereÃ§o do pixel do mapa1 a ser apagado) 
	sb zero,0(t5)		# grava 0 no conteÃºdo do endereÃ§o t5 (apaga o pixel carregado anteriormente do mapa1 no segmento de dados)
	
	addi t1,t1,-1		# t1 = t1 - 1 (carrega o endereÃ§o do pixel superior esquerdo do ponto detectado)
	li t3,0xFF000000	# t3 = 0xFF000000 (carrega em t3 o endereÃ§o base da memoria VGA)
	sub t3,t1,t3		# t3 = t1 - 0xFF000000 (subtrai o endereÃ§o base de t1, posiÃ§Ã£o do pixel a ser apagado)
	
	li t4,1
	beq s6,t4,DELU3
	la t5,mapa2
	j DELU4
	
DELU3:	la t5,mapa1		# carrega em t5 o endereÃ§o dos dados do mapa1 
DELU4:	addi t5,t5,8		# t5 = endereÃ§o do primeiro pixel do mapa1 (depois das informaÃ§Ãµes de nlin ncol)
	add t5,t5,t3		# t5 = t5 + t3 (carrega em t5 o endereÃ§o do pixel do mapa1 a ser apagado)
	sb zero,0(t5)		# grava 0 no conteÃºdo do endereÃ§o t5 (apaga o pixel carregado anteriormente do mapa1 no segmento de dados)
	
	j DELETE 		# pule para DELETE
	
DELDWN:	addi t1,t1,320		# t1 = t1 + 320 (carrega o endereÃ§o do pixel inferior esquerdo do ponto detectado)
	sb zero,0(t1)		# grava 0 no conteÃºdo do endereÃ§o t1 (apaga o pixel carregado anteriormente da memoria VGA/tela)
	addi t1,t1,1		# t1 = t1 + 1 (carrega o endereÃ§o do pixel inferior direito do ponto detectado)
	sb zero,0(t1)		# grava 0 no conteÃºdo do endereÃ§o t1 (apaga o pixel carregado anteriormente da memoria VGA/tela)
	
	li t3,0xFF000000	# t3 = 0xFF000000 (carrega em t3 o endereÃ§o base da memoria VGA)
	sub t3,t1,t3		# t3 = t1 - 0xFF000000 (subtrai o endereÃ§o base de t1, posiÃ§Ã£o do pixel a ser apagado)
	
	li t4,1
	beq s6,t4,DELD1
	la t5,mapa2
	j DELD2
	
DELD1:	la t5,mapa1		# carrega em t5 o endereÃ§o dos dados do mapa1 
DELD2:	addi t5,t5,8		# t5 = endereÃ§o do primeiro pixel do mapa1 (depois das informaÃ§Ãµes de nlin ncol)
	add t5,t5,t3		# t5 = t5 + t3 (carrega em t5 o endereÃ§o do pixel do mapa1 a ser apagado) 
	sb zero,0(t5)		# grava 0 no conteÃºdo do endereÃ§o t5 (apaga o pixel carregado anteriormente do mapa1 no segmento de dados)
	
	addi t1,t1,-1		# t1 = t1 - 1 (carrega o endereÃ§o do pixel inferior esquerdo do ponto detectado)
	li t3,0xFF000000	# t3 = 0xFF000000 (carrega em t3 o endereÃ§o base da memoria VGA)
	sub t3,t1,t3		# t3 = t1 - 0xFF000000 (subtrai o endereÃ§o base de t1, posiÃ§Ã£o do pixel a ser apagado)
	
	li t4,1
	beq s6,t4,DELD3
	la t5,mapa2
	j DELD4
	
DELD3:	la t5,mapa1		# carrega em t5 o endereÃ§o dos dados do mapa1 
DELD4:	addi t5,t5,8		# t5 = endereÃ§o do primeiro pixel do mapa1 (depois das informaÃ§Ãµes de nlin ncol)
	add t5,t5,t3		# t5 = t5 + t3 (carrega em t5 o endereÃ§o do pixel do mapa1 a ser apagado)
	sb zero,0(t5)		# grava 0 no conteÃºdo do endereÃ§o t5 (apaga o pixel carregado anteriormente do mapa1 no segmento de dados)
	
	j DELETE 		# pule para DELETE

DELRGHT:addi t1,t1,1		# t1 = t1 + 1 (carrega o endereÃ§o do pixel inferior direito do ponto detectado)
	sb zero,0(t1)		# grava 0 no conteÃºdo do endereÃ§o t1 (apaga o pixel carregado anteriormente da memoria VGA/tela)
	addi t1,t1,-320		# t1 = t1 + 1 (carrega o endereÃ§o do pixel superior direito do ponto detectado)
	sb zero,0(t1)		# grava 0 no conteÃºdo do endereÃ§o t1 (apaga o pixel carregado anteriormente da memoria VGA/tela)
	
	li t3,0xFF000000	# t3 = 0xFF000000 (carrega em t3 o endereÃ§o base da memoria VGA)
	sub t3,t1,t3		# t3 = t1 - 0xFF000000 (subtrai o endereÃ§o base de t1, posiÃ§Ã£o do pixel a ser apagado)
	
	li t4,1
	beq s6,t4,DELR1
	la t5,mapa2
	j DELR2
	
DELR1:	la t5,mapa1		# carrega em t5 o endereÃ§o dos dados do mapa1 
DELR2:	addi t5,t5,8		# t5 = endereÃ§o do primeiro pixel do mapa1 (depois das informaÃ§Ãµes de nlin ncol)
	add t5,t5,t3		# t5 = t5 + t3 (carrega em t5 o endereÃ§o do pixel do mapa1 a ser apagado) 
	sb zero,0(t5)		# grava 0 no conteÃºdo do endereÃ§o t5 (apaga o pixel carregado anteriormente do mapa1 no segmento de dados)
	
	addi t1,t1,320		# t1 = t1 + 320 (carrega o endereÃ§o do pixel inferior direito do ponto detectado)
	li t3,0xFF000000	# t3 = 0xFF000000 (carrega em t3 o endereÃ§o base da memoria VGA)
	sub t3,t1,t3		# t3 = t1 - 0xFF000000 (subtrai o endereÃ§o base de t1, posiÃ§Ã£o do pixel a ser apagado)
	
	li t4,1
	beq s6,t4,DELR3
	la t5,mapa2
	j DELR4
	
DELR3:	la t5,mapa1		# carrega em t5 o endereÃ§o dos dados do mapa1 
DELR4:	addi t5,t5,8		# t5 = endereÃ§o do primeiro pixel do mapa1 (depois das informaÃ§Ãµes de nlin ncol)
	add t5,t5,t3		# t5 = t5 + t3 (carrega em t5 o endereÃ§o do pixel do mapa1 a ser apagado)
	sb zero,0(t5)		# grava 0 no conteÃºdo do endereÃ§o t5 (apaga o pixel carregado anteriormente do mapa1 no segmento de dados)
	
	j DELETE 		# pule para DELETE
	
SPRPNT:	addi s1,s1,1		# incrementa o contador de pontos (a sessÃ£o a seguir toca uma triade de mi maior para cada ponto coletado)
	
	li s0,-1
	
	la t5, PONTOS
	lw t6, 0(t5)
	addi t6,t6,10
	sw t6, 0(t5)
	
	la t0,CONTADOR_ASSUSTADO
	li t3,0		
	sw t3,0(t0)		
	
	li t0,17
	rem t3,s4,t0
	li s4, 51
	add s4,s4,t3
	
	li t0,17
	rem t3,s9,t0
	li s9, 51
	add s9,s9,t3
	
	li t0,17
	rem t3,s10,t0
	li s10, 51
	add s10,s10,t3
	
	li t0,17
	rem t3,s11,t0
	li s11, 51
	add s11,s11,t3
	
	li a0,56		# a0 = 56 (carrega sol sustenido para a0)
	li a1,100		# a1 = 100 (nota de duraÃ§Ã£o de 100 ms)
	li a2,35		# a2 = 35 (timbre "electric bass")
	li a3,50		# a3 = 50 (volume da nota)
	li a7,31		# a7 = 31 (carrega em a7 o ecall "MidiOut")
	ecall			# realiza o ecall
	
	li a0,59		# a0 = 59 (carrega si para a0)
	li a1,100		# a1 = 100 (nota de duraÃ§Ã£o de 100 ms)
	li a2,32		# a2 = 32 (timbre "guitar harmonic")
	li a3,50		# a3 = 50 (volume da nota)
	li a7,31		# a7 = 31 (carrega em a7 o ecall "MidiOut")
	ecall			# realiza o ecall
	
	li a0,64		# a0 = 64 (carrega mi para a0)
	li a1,100		# a1 = 100 (nota de duraÃ§Ã£o de 100 ms)
	li a2,32		# a2 = 32 (timbre "guitar harmonic")
	li a3,50		# a3 = 50 (volume da nota)
	li a7,31		# a7 = 31 (carrega em a7 o ecall "MidiOut")
	ecall			# realiza o ecall
	
	li t3,1			# carrega 1 para t3
  	beq s3,t3,DELLFTS	# se s3 for igual a 1 (valor de movimento atual para a esquerda), vÃ¡ para DELLFT
  	
  	li t3,2			# carrega 2 para t3
  	beq s3,t3,DELUPS		# se s3 for igual a 2 (valor de movimento atual para cima), vÃ¡ para DELUP
  	
  	li t3,3  		# carrega 3 para t3
	beq s3,t3,DELDWNS	# se s3 for igual a 3 (valor de movimento atual para baixo), vÃ¡ para DELDWN
	
	li t3,4  		# carrega 4 para t3
	beq s3,t3,DELRGHTS	# se s3 for igual a 4 (valor de movimento atual para a direita), vÃ¡ para DELRGHT
	
DELLFTS: 
	addi t1,t1,-3		# t1 = t1 - 1 (carrega o endereÃ§o do pixel inferior esquerdo do ponto detectado)
	la t3,vertpoint		# carrega a imagem que vai sobrepor o robozinho com pixels pretos
	addi t3,t3,8		# t3 = endereÃ§o do primeiro pixel da imagem (depois das informaÃ§Ãµes de nlin ncol)

	li t5,0	
	li t6,4			# reinicia o contador para 16 quebras de linha
	
	li t4,960		# t4 = 5120
	sub t1,t1,t4		# volta t1 16 linhas (pixel inicial da primeira linha)
	mv t2,t1 		# t2 = POS_ROBOZINHO	
	addi t2,t2,2		# t2 = POS_ROBOZINHO + 16 (pixel final da primeira linha)
	
	mv t0,t1		# t0 = t1
	li t4,0xFF000000	# t4 = 0xFF000000 (carrega em t4 o endereÃ§o base da memoria VGA)
	sub t0,t0,t4		# t0 = t0 - 0xFF000000 (subtrai o endereÃ§o base de t0, posiÃ§Ã£o atual do Robozinho)
	li t4,1
	beq s6,t4,LOAD1L
	la t4,mapa2
	j LOAD2L
LOAD1L:	la t4,mapa1		# carrega em t4 o endereÃ§o dos dados do mapa1
LOAD2L:	addi t4,t4,8		# t4 = endereÃ§o do primeiro pixel do mapa1 (depois das informaÃ§Ãµes de nlin ncol)
	add t4,t4,t0		# t4 = t4 + t0 (carrega em t4 o endereÃ§o do pixel do mapa1 no segmento de dados sobre o qual o Robozinho esta localizado)
	
	
DELLOOPL:beq t1,t2,ENTER2L	# se t1 atingir o fim da linha de pixels, quebre linha
	lb t0,0(t3)		# le um byte de "Robozinho1preto" para t0
	sb t0,0(t1)		# escreve o byte (pixel preto\invisivel) na memÃ³ria VGA
	sb t0,0(t4)
	
	addi t1,t1,1		# soma 1 ao endereÃ§o t1
	addi t3,t3,1		# soma 1 ao endereÃ§o t3
	addi t4,t4,1		# soma 1 ao endereÃ§o t4
	j DELLOOPL		# volta a verificar a condiÃ§ao do loop
	
ENTER2L:addi t1,t1,318		# t1 pula para o pixel inicial da linha de baixo na memoria VGA
	addi t4,t4,318		# t4 pula para o pixel inicial da linha de baixo no segmento de dados
	addi t2,t2,320		# t2 pula para o pixel final da linha de baixo na memoria VGA
	addi t5,t5,1          	# atualiza o contador de quebras de linha
	beq t5,t6,DELETE	# termina o carregamento da imagem se 16 quebras de linha ocorrerem
	j DELLOOPL		# pula para delloop
	
DELUPS:	la t3,horpoint		# carrega a imagem que vai sobrepor o robozinho com pixels pretos
	addi t3,t3,8		# t3 = endereÃ§o do primeiro pixel da imagem (depois das informaÃ§Ãµes de nlin ncol)

	li t5,0	
	li t6,2			# reinicia o contador para 16 quebras de linha
	
	li t4,960		# t4 = 5120
	sub t1,t1,t4		# volta t1 16 linhas (pixel inicial da primeira linha)
	mv t2,t1 		# t2 = POS_ROBOZINHO	
	addi t2,t2,4		# t2 = POS_ROBOZINHO + 16 (pixel final da primeira linha)
	
	mv t0,t1		# t0 = t1
	li t4,0xFF000000	# t4 = 0xFF000000 (carrega em t4 o endereÃ§o base da memoria VGA)
	sub t0,t0,t4		# t0 = t0 - 0xFF000000 (subtrai o endereÃ§o base de t0, posiÃ§Ã£o atual do Robozinho)
	li t4,1
	beq s6,t4,LOAD1U
	la t4,mapa2
	j LOAD2U
LOAD1U:	la t4,mapa1		# carrega em t4 o endereÃ§o dos dados do mapa1
LOAD2U:	addi t4,t4,8		# t4 = endereÃ§o do primeiro pixel do mapa1 (depois das informaÃ§Ãµes de nlin ncol)
	add t4,t4,t0		# t4 = t4 + t0 (carrega em t4 o endereÃ§o do pixel do mapa1 no segmento de dados sobre o qual o Robozinho esta localizado)
	
	
DELLOOPU:beq t1,t2,ENTER2U	# se t1 atingir o fim da linha de pixels, quebre linha
	lb t0,0(t3)		# le um byte de "Robozinho1preto" para t0
	sb t0,0(t1)		# escreve o byte (pixel preto\invisivel) na memÃ³ria VGA
	sb t0,0(t4)
	
	addi t1,t1,1		# soma 1 ao endereÃ§o t1
	addi t3,t3,1		# soma 1 ao endereÃ§o t3
	addi t4,t4,1		# soma 1 ao endereÃ§o t4
	j DELLOOPU		# volta a verificar a condiÃ§ao do loop
	
ENTER2U:addi t1,t1,316		# t1 pula para o pixel inicial da linha de baixo na memoria VGA
	addi t4,t4,316		# t4 pula para o pixel inicial da linha de baixo no segmento de dados
	addi t2,t2,320		# t2 pula para o pixel final da linha de baixo na memoria VGA
	addi t5,t5,1          	# atualiza o contador de quebras de linha
	beq t5,t6,DELETE	# termina o carregamento da imagem se 16 quebras de linha ocorrerem
	j DELLOOPU		# pula para delloop
	
DELDWNS:la t3,horpoint		# carrega a imagem que vai sobrepor o robozinho com pixels pretos
	addi t3,t3,8		# t3 = endereÃ§o do primeiro pixel da imagem (depois das informaÃ§Ãµes de nlin ncol)

	li t5,0	
	li t6,2			# reinicia o contador para 16 quebras de linha
	
	li t4,640		# t4 = 5120
	add t1,t1,t4		# volta t1 16 linhas (pixel inicial da primeira linha)
	mv t2,t1 		# t2 = POS_ROBOZINHO	
	addi t2,t2,4		# t2 = POS_ROBOZINHO + 16 (pixel final da primeira linha)
	
	mv t0,t1		# t0 = t1
	li t4,0xFF000000	# t4 = 0xFF000000 (carrega em t4 o endereÃ§o base da memoria VGA)
	sub t0,t0,t4		# t0 = t0 - 0xFF000000 (subtrai o endereÃ§o base de t0, posiÃ§Ã£o atual do Robozinho)
	li t4,1
	beq s6,t4,LOAD1D
	la t4,mapa2
	j LOAD2D
LOAD1D:	la t4,mapa1		# carrega em t4 o endereÃ§o dos dados do mapa1
LOAD2D:	addi t4,t4,8		# t4 = endereÃ§o do primeiro pixel do mapa1 (depois das informaÃ§Ãµes de nlin ncol)
	add t4,t4,t0		# t4 = t4 + t0 (carrega em t4 o endereÃ§o do pixel do mapa1 no segmento de dados sobre o qual o Robozinho esta localizado)
	
	
DELLOOPD:beq t1,t2,ENTER2D	# se t1 atingir o fim da linha de pixels, quebre linha
	lb t0,0(t3)		# le um byte de "Robozinho1preto" para t0
	sb t0,0(t1)		# escreve o byte (pixel preto\invisivel) na memÃ³ria VGA
	sb t0,0(t4)
	
	addi t1,t1,1		# soma 1 ao endereÃ§o t1
	addi t3,t3,1		# soma 1 ao endereÃ§o t3
	addi t4,t4,1		# soma 1 ao endereÃ§o t4
	j DELLOOPU		# volta a verificar a condiÃ§ao do loop
	
ENTER2D:addi t1,t1,316		# t1 pula para o pixel inicial da linha de baixo na memoria VGA
	addi t4,t4,316		# t4 pula para o pixel inicial da linha de baixo no segmento de dados
	addi t2,t2,320		# t2 pula para o pixel final da linha de baixo na memoria VGA
	addi t5,t5,1          	# atualiza o contador de quebras de linha
	beq t5,t6,DELETE	# termina o carregamento da imagem se 16 quebras de linha ocorrerem
	j DELLOOPD		# pula para delloop

DELRGHTS:
	addi t1,t1,2		# t1 = t1 - 1 (carrega o endereÃ§o do pixel inferior esquerdo do ponto detectado)
	la t3,vertpoint		# carrega a imagem que vai sobrepor o robozinho com pixels pretos
	addi t3,t3,8		# t3 = endereÃ§o do primeiro pixel da imagem (depois das informaÃ§Ãµes de nlin ncol)

	li t5,0	
	li t6,4			# reinicia o contador para 16 quebras de linha
	
	li t4,960		# t4 = 5120
	sub t1,t1,t4		# volta t1 16 linhas (pixel inicial da primeira linha)
	mv t2,t1 		# t2 = POS_ROBOZINHO	
	addi t2,t2,2		# t2 = POS_ROBOZINHO + 16 (pixel final da primeira linha)
	
	mv t0,t1		# t0 = t1
	li t4,0xFF000000	# t4 = 0xFF000000 (carrega em t4 o endereÃ§o base da memoria VGA)
	sub t0,t0,t4		# t0 = t0 - 0xFF000000 (subtrai o endereÃ§o base de t0, posiÃ§Ã£o atual do Robozinho)
	li t4,1
	beq s6,t4,LOAD1R
	la t4,mapa2
	j LOAD2R
LOAD1R:	la t4,mapa1		# carrega em t4 o endereÃ§o dos dados do mapa1
LOAD2R:	addi t4,t4,8		# t4 = endereÃ§o do primeiro pixel do mapa1 (depois das informaÃ§Ãµes de nlin ncol)
	add t4,t4,t0		# t4 = t4 + t0 (carrega em t4 o endereÃ§o do pixel do mapa1 no segmento de dados sobre o qual o Robozinho esta localizado)
	
	
DELLOOPR:beq t1,t2,ENTER2R	# se t1 atingir o fim da linha de pixels, quebre linha
	lb t0,0(t3)		# le um byte de "Robozinho1preto" para t0
	sb t0,0(t1)		# escreve o byte (pixel preto\invisivel) na memÃ³ria VGA
	sb t0,0(t4)
	
	addi t1,t1,1		# soma 1 ao endereÃ§o t1
	addi t3,t3,1		# soma 1 ao endereÃ§o t3
	addi t4,t4,1		# soma 1 ao endereÃ§o t4
	j DELLOOPR		# volta a verificar a condiÃ§ao do loop
	
ENTER2R:addi t1,t1,318		# t1 pula para o pixel inicial da linha de baixo na memoria VGA
	addi t4,t4,318		# t4 pula para o pixel inicial da linha de baixo no segmento de dados
	addi t2,t2,320		# t2 pula para o pixel final da linha de baixo na memoria VGA
	addi t5,t5,1          	# atualiza o contador de quebras de linha
	beq t5,t6,DELETE	# termina o carregamento da imagem se 16 quebras de linha ocorrerem
	j DELLOOPR		# pula para delloop
	
# Printa preto em cima da posiÃ§Ã£o do personagem (apaga o personagem anterior)
	
DELETE:	la t3,Robozinho1preto	# carrega a imagem que vai sobrepor o robozinho com pixels pretos
	addi t3,t3,8		# t3 = endereÃ§o do primeiro pixel da imagem (depois das informaÃ§Ãµes de nlin ncol)

	li t5,0	
	li t6,16		# reinicia o contador para 16 quebras de linha
	
	li t4,5120		# t4 = 5120
	la t0,POS_ROBOZINHO	# carrega o endereÃ§o de "POS_ROBOZINHO" no registrador t0
	lw t1,0(t0)		# le a word guardada em "POS_ROBOZINHO" para t1 (t1 = posiÃ§Ã£o atual do Robozinho)
	sub t1,t1,t4		# volta t1 16 linhas (pixel inicial da primeira linha)
	mv t2,t1 		# t2 = POS_ROBOZINHO	
	addi t2,t2,16		# t2 = POS_ROBOZINHO + 16 (pixel final da primeira linha)
	
	mv t0,t1		# t0 = t1
	li t4,0xFF000000	# t4 = 0xFF000000 (carrega em t4 o endereÃ§o base da memoria VGA)
	sub t0,t0,t4		# t0 = t0 - 0xFF000000 (subtrai o endereÃ§o base de t0, posiÃ§Ã£o atual do Robozinho)
	li t4,1
	beq s6,t4,LOAD1
	la t4,mapa2
	j LOAD2
LOAD1:	la t4,mapa1		# carrega em t4 o endereÃ§o dos dados do mapa1
LOAD2:	addi t4,t4,8		# t4 = endereÃ§o do primeiro pixel do mapa1 (depois das informaÃ§Ãµes de nlin ncol)
	add t4,t4,t0		# t4 = t4 + t0 (carrega em t4 o endereÃ§o do pixel do mapa1 no segmento de dados sobre o qual o Robozinho esta localizado)
	
	
DELLOOP:beq t1,t2,ENTER2	# se t1 atingir o fim da linha de pixels, quebre linha
	lb t0,0(t3)		# le um byte de "Robozinho1preto" para t0
	sb t0,0(t1)		# escreve o byte (pixel preto\invisivel) na memÃ³ria VGA
	
	li a5,199		# a5 = 199 (valor de um pixel invisivel)
	bgeu t0, a5, INVSBL	# se t0 >= 199, ou seja, se t0 for um pixel invisivel, pule para INVSBL (note que t0 nunca sera realmente maior que 199, mas nÃ£o existe "bequ")
	sb t0,0(t4)		# se t0 < 199, ou seja, se t0 for um pixel preto, escreve o byte (pixel preto) no endereÃ§o t4 do mapa1 no segmento de dados 
	
INVSBL:	addi t1,t1,1		# soma 1 ao endereÃ§o t1
	addi t3,t3,1		# soma 1 ao endereÃ§o t3
	addi t4,t4,1		# soma 1 ao endereÃ§o t4
	j DELLOOP		# volta a verificar a condiÃ§ao do loop
	
ENTER2:	addi t1,t1,304		# t1 pula para o pixel inicial da linha de baixo na memoria VGA
	addi t4,t4,304		# t4 pula para o pixel inicial da linha de baixo no segmento de dados
	addi t2,t2,320		# t2 pula para o pixel final da linha de baixo na memoria VGA
	addi t5,t5,1          	# atualiza o contador de quebras de linha
	beq t5,t6,DELETE_COL	# termina o carregamento da imagem se 16 quebras de linha ocorrerem
	j DELLOOP		# pula para delloop 
	
# Printa preto em cima da posiÃ§Ã£o do personagem (apaga o personagem anterior)
	
DELETE_COL:
	li t5,0	
	li t6,16		# reinicia o contador para 16 quebras de linha
	
	li t4,5120		# t4 = 5120
	la t0,POS_ROBOZINHO	# carrega o endereÃ§o de "POS_ROBOZINHO" no registrador t0
	lw t1,0(t0)		# le a word guardada em "POS_ROBOZINHO" para t1 (t1 = posiÃ§Ã£o atual do Robozinho)
	li t0,0x100000
	add t1,t1,t0
	sub t1,t1,t4		# volta t1 16 linhas (pixel inicial da primeira linha)
	mv t2,t1 		# t2 = POS_ROBOZINHO	
	addi t2,t2,16		# t2 = POS_ROBOZINHO + 16 (pixel final da primeira linha)
	
DELLOOP_COL:
	beq t1,t2,ENTER2_COL	# se t1 atingir o fim da linha de pixels, quebre linha
	sw zero,0(t1)		# escreve o byte (pixel preto\invisivel) na memÃ³ria VGA
	addi t1,t1,4		# soma 1 ao endereÃ§o t1
	j DELLOOP_COL		# volta a verificar a condiÃ§ao do loop
	
ENTER2_COL:	
	addi t1,t1,304		# t1 pula para o pixel inicial da linha de baixo na memoria VGA
	addi t2,t2,320		# t2 pula para o pixel final da linha de baixo na memoria VGA
	addi t5,t5,1          	# atualiza o contador de quebras de linha
	beq t5,t6,VERIFY	# termina o carregamento da imagem se 16 quebras de linha ocorrerem
	j DELLOOP_COL		# pula para delloop 
	
# Verifica qual a tecla pressionada para movimentar o Robozinho
	
VERIFY: addi s0,s0,1		# incrementa o contador de estados do Robozinho (se s0 for par -> Robozinho1; se s0 for impar -> Robozinho2)

	li t0,2			# t0 = 2
	rem t1,s0,t0		# t1 = resto da divisÃ£o s0/2 
	beq t1,zero,MI		# se t1 = 0 (se s0 for par), vÃ¡ para MI (toque a nota MI)
	
	li a0,34		# a0 = 34 (carrega si bemol para a0)
	li a1,100		# a1 = 100 (nota de duraÃ§Ã£o de 100 ms)
	li a2,33		# a2 = 33 (timbre "acoustic bass")
	li a3,90		# a3 = 90 (volume da nota)
	li a7,31		# a7 = 31 (carrega em a7 o ecall "MidiOut")
	ecall			# realiza o ecall
	
	j SIB			# pule para SIB (acaba de tocar a nota SIb)
	
MI:	li a0,40		# a0 = 40 (carrega mi para a0)
	li a1,100		# a1 = 100 (nota de duraÃ§Ã£o de 100 ms)
	li a2,33		# a2 = 33 (timbre "acoustic bass")
	li a3,90		# a3 = 90 (volume da nota)
	li a7,31		# a7 = 31 (carrega em a7 o ecall "MidiOut")
	ecall			# realiza o ecall

SIB:	li t0,2121		# carrega 1 para t0
  	beq a4,t0,PORLFT	# se s3 for igual a 1 (valor de movimento atual para a esquerda), vÃ¡ para MOVLFT
  	
  	li t0,2222		# carrega 1 para t0
  	beq a4,t0,PORRGHT	# se s3 for igual a 1 (valor de movimento atual para a esquerda), vÃ¡ para MOVLFT

	li t0,1			# carrega 1 para t0
  	beq s3,t0,MOVLFT	# se s3 for igual a 1 (valor de movimento atual para a esquerda), vÃ¡ para MOVLFT
  	
  	li t0,2			# carrega 2 para t0
  	beq s3,t0,MOVUP		# se s3 for igual a 2 (valor de movimento atual para cima), vÃ¡ para MOVUP
  	
  	li t0,3  		# carrega 3 para t0
	beq s3,t0,MOVDWN	# se s3 for igual a 3 (valor de movimento atual para baixo), vÃ¡ para MOVDWN
	
	li t0,4  		# carrega 4 para t0
	beq s3,t0,MOVRGHT	# se s3 for igual a 4 (valor de movimento atual para a direita), vÃ¡ para MOVRGHT
	
# Carrega em t2 o offset correspondente a cada direÃ§Ã£o de movimento

PORLFT:	li t2,4916		# t2 = 5124 (volta t1 16 linhas e vai 4 pixels para a esquerda -> pixel inicial - 4) 
	j MOVROB		# pule para MOVROB (movimenta o Robozinho)

PORRGHT:li t2,5324		# t2 = 5124 (volta t1 16 linhas e vai 4 pixels para a esquerda -> pixel inicial - 4) 
	j MOVROB		# pule para MOVROB (movimenta o Robozinho)
	
MOVLFT: li t2,5124		# t2 = 5124 (volta t1 16 linhas e vai 4 pixels para a esquerda -> pixel inicial - 4) 
	j MOVROB		# pule para MOVROB (movimenta o Robozinho)

MOVUP:	li t2,6400		# t2 = 6400 (volta t1 20 linhas -> pixel inicial 4 linhas acima)
	j MOVROB		# pule para MOVROB (movimenta o Robozinho)

MOVDWN:	li t2,3840		# t2 = 3840 (volta t1 12 linhas -> pixel inicial 4 linhas abaixo)
	j MOVROB		# pule para MOVROB (movimenta o Robozinho)

MOVRGHT:li t2,5116		# t2 = 5116 (volta t1 16 linhas e vai 4 pixels para a direita -> pixel inicial + 4)
	j MOVROB		# pule para MOVROB (movimenta o Robozinho)
		
# Printa o personagem de acordo com sua direÃ§Ã£o atual de movimento (definida pelo registrador t2)	
	
MOVROB:	la t0,POS_ROBOZINHO	# carrega o endereÃ§o de "POS_ROBOZINHO" no registrador t0
	lw t1,0(t0)		# le a word guardada em "POS_ROBOZINHO" para t1 (t1 = posiÃ§Ã£o atual do Robozinho)
	sub t1,t1,t2		# volta t1 16 linhas e vai 4 pixels pra frente (pixel inicial + 4) 
	mv t2,t1 		# t2 = t1
	addi t2,t2,16		# t2 = t2 + 16 (pixel final da primeira linha + 4)
	
	li t4,2			# t4 = 2 (para verificar a paridade de s0)
	rem t3,s0,t4		# t3 = resto da divisÃ£o inteira s0/2
	
	la t0,CONTADOR_ASSUSTADO
	lw t5,0(t0)
	li t0,-1
	
	beq t3,zero,PAR3	# se t3 = 0, va para PAR3 (se s0 for par, imprime o Robozinho1, se for impar, imprime o Robozinho2)

	beq t5,t0,FRACO2
	la t3,Robozinho2forte
	j NEXT3
	
FRACO2:	la t3,Robozinho2	# t3 = endereÃ§o dos dados do Robozinho2 (boca aberta)
	j NEXT3			# pula para NEXT3
	
PAR3:	beq t5,t0,FRACO1
	la t3,Robozinho1forte
	j NEXT3
	
FRACO1:	la t3,Robozinho1	# t3 = endereÃ§o dos dados do Robozinho1 (boca fechada)
	
NEXT3:	addi t3,t3,8		# t3 = endereÃ§o do primeiro pixel da imagem (depois das informaÃ§Ãµes de nlin ncol)

	li t5,0
	li t6,16		# reinicia contador para 16 quebras de linha	
	
LOOP3: 	beq t1,t2,ENTER3	# se t1 atingir o fim da linha de pixels, quebre linha
	lw t0,0(t3)		# le uma word do endereÃ§o t3 (le 4 pixels da imagem)
	sw t0,0(t1)		# escreve a word na memÃ³ria VGA no endereÃ§o t1 (desenha 4 pixels na tela do Bitmap Display)
	
	li t0,0x100000
	add t1,t1,t0
	
	li t0,0x69696969
	sw t0,0(t1)
	
	li t0,0x100000
	sub t1,t1,t0
	
	addi t1,t1,4		# soma 4 ao endereÃ§o t1
	addi t3,t3,4		# soma 4 ao endereÃ§o t3
	j LOOP3			# volta a verificar a condiÃ§ao do loop
	
ENTER3:	addi t1,t1,304		# t1 pula para o pixel inicial da linha de baixo
	addi t2,t2,320		# t2 pula para o pixel final da linha de baixo
	addi t5,t5,1            # atualiza o contador de quebras de linha
	beq t5,t6,FIMMOV	# termine o carregamento da imagem se 16 quebras de linha ocorrerem
	j LOOP3			# pula para loop 3
	
# Se o Robozinho tiver se movimentado, espera 80 ms para a prÃ³xima iteraÃ§Ã£o (visa reduzir a velocidade do Robozinho)
    
FIMMOV:	la t0, POS_ROBOZINHO    # carrega o endereÃ§o de "POS_ROBOZINHO" no registrador t0 
    	sw t1, 0(t0)       	# guarda a word armazenada em t1 (posiÃ§Ã£o atual do Roboziho) em "POS_ROBOZINHO"
    	
	jal zero, MAINL			# retorna ao loop principal
	
# Se o Robozinho nÃ£o tiver se movimentado, espera 2 ms para a prÃ³xima iteraÃ§Ã£o (visa reduzir o "flick" do contador de pontos)
	
FIM:	jal zero, MAINL			# retorna ao loop principal

# Se o Robozinho colidir com o Blinky ou vice-versa

COL_BLINKY:

	li a0,38			# a0 = 38
	blt s4,a0,VERFASE_B		# se a1 for menor que o a0 então o alien estava no sdcatter/chase mode, então o robozino perdeu vida
	la a0, POS_BLINKY		# a0 = pos_pink
	lw a1, 0(a0)			# a1 = lw a0
	mv a4, a1			# a4 = a1
	li s7,1
	jal VER_ALIEN_2		# se não, o blinky morreu
	
# Se o Robozinho colidir com o Blinky ou vice-versa

COL_PINK:
	li a0,38			# a0 = 38
	blt s9,a0,VERFASE_B		# se a1 for menor que o a0 então o alien estava no sdcatter/chase mode, então o robozino perdeu vida
	la a0, POS_PINK		# a0 = pos_pink
	lw a1, 0(a0)			# a1 = lw a0
	mv a4, a1			# a4 = a1
	li s7,2
	jal VER_ALIEN_2		# se não, o pink morreu

# Se o Robozinho colidir com o Pink ou vice-versa

COL_INKY:
	li a0,38			# a0 = 38
	blt s10,a0,VERFASE_B		# se a1 for menor que o a0 então o alien estava no sdcatter/chase mode, então o robozino perdeu vida
	la a0, POS_INKY		# a0 = pos_inky
	lw a1, 0(a0)			# a1 = lw a0
	mv a4, a1			# a4 = a1
	li s7,3
	jal VER_ALIEN_2			# se não, o blinky morreu
	
# Se o Robozinho colidir com o Clyde ou vice-versa

COL_CLYDE:
	li a0,38			# a0 = 38
	blt s11,a0,VERFASE_B		# se a1 for menor que o a0 então o alien estava no sdcatter/chase mode, então o robozino perdeu vida
	la a0, POS_CLYDE		# a0 = pos_clyde
	lw a1, 0(a0)			# a1 = lw a0
	mv a4, a1			# a4 = a1
	li s7,4
	jal VER_ALIEN_2		# se não, o blinky morreu
	

VERFASE_B:
	li t0,1
	beq s6,t0,FASE1
	jal zero, RESET_FASE2
	
# Mostra a tela de derrota

DERROTA:li s1,0xFF000000	# s1 = endereco inicial da Memoria VGA - Frame 0
	li s2,0xFF012C00	# s2 = endereco final da Memoria VGA - Frame 0
	la s0,telalose		# s0 = endereÃ§o dos dados do mapa 1
	addi s0,s0,8		# s0 = endereÃ§o do primeiro pixel da imagem (depois das informaÃ§Ãµes de nlin ncol)

LOOPL: 	beq s1,s2,LOOPLOSE		# se s1 = Ãºltimo endereÃ§o da Memoria VGA, saia do loop
	lw t0,0(s0)		# le uma word do endereÃ§o s0 (le 4 pixels da imagem)
	sw t0,0(s1)		# escreve a word na memÃ³ria VGA no endereÃ§o s1 (desenha 4 pixels na tela do Bitmap Display)
	addi s1,s1,4		# soma 4 ao endereÃ§o s1 
	addi s0,s0,4		# soma 4 ao endereÃ§o s0
	j LOOPL			# volta a verificar a condiÃ§ao do loop

LOOPLOSE:li t2,0xFF200000	# carrega o endereÃ§o de controle do KDMMIO ("teclado")
	lw t0,0(t2)		# le uma word a partir do endereÃ§o de controle do KDMMIO
	andi t0,t0,0x0001	# mascara todos os bits de t0 com exceÃ§ao do bit menos significativo
   	bne t0,zero,CLSL   	# se o BMS de t0 não for 0 (há tecla pressionada), pule para MAPA1
   	j LOOPLOSE

CLSL:	li a7, 10
	ecall	
	
# Mostra a tela de vitoria
	
VITORIA:li s1,0xFF000000	# s1 = endereco inicial da Memoria VGA - Frame 0
	li s2,0xFF012C00	# s2 = endereco final da Memoria VGA - Frame 0
	la s0,telawin		# s0 = endereÃ§o dos dados do mapa 1
	addi s0,s0,8		# s0 = endereÃ§o do primeiro pixel da imagem (depois das informaÃ§Ãµes de nlin ncol)

LOOPV: 	beq s1,s2,LOOPVIC		# se s1 = Ãºltimo endereÃ§o da Memoria VGA, saia do loop
	lw t0,0(s0)		# le uma word do endereÃ§o s0 (le 4 pixels da imagem)
	sw t0,0(s1)		# escreve a word na memÃ³ria VGA no endereÃ§o s1 (desenha 4 pixels na tela do Bitmap Display)
	addi s1,s1,4		# soma 4 ao endereÃ§o s1 
	addi s0,s0,4		# soma 4 ao endereÃ§o s0
	j LOOPV			# volta a verificar a condiÃ§ao do loop

LOOPVIC:li t2,0xFF200000	# carrega o endereÃ§o de controle do KDMMIO ("teclado")
	lw t0,0(t2)		# le uma word a partir do endereÃ§o de controle do KDMMIO
	andi t0,t0,0x0001	# mascara todos os bits de t0 com exceÃ§ao do bit menos significativo
   	bne t0,zero,CLSV   	# se o BMS de t0 não for 0 (há tecla pressionada), pule para MAPA1
   	j LOOPVIC

CLSV:	li a7, 10
	ecall
	
###########################
##### DADOS DA FASE 1 #####
###########################
	
FASE1:  li s6,1

# Toca a musica de morte

	li a0,100
	li a7,32           	# define a chamada de syscal para pausa
   	ecall               	# realiza uma pausa de 3 s
   	
   	li a0,70		# a0 = 76 (carrega mi para a0)
	li a1,1000		# a1 = 100 (nota de duração de 100 ms)
	li a2,32		# a2 = 32 (timbre "guitar harmonic")
	li a3,100		# a3 = 50 (volume da nota)
	li a7,31		# a7 = 31 (carrega em a7 o ecall "MidiOut")
	ecall			# realiza o ecall
	
	li a0,65		# a0 = 76 (carrega mi para a0)
	li a1,1000		# a1 = 100 (nota de duração de 100 ms)
	li a2,32		# a2 = 32 (timbre "guitar harmonic")
	li a3,100		# a3 = 50 (volume da nota)
	li a7,31		# a7 = 31 (carrega em a7 o ecall "MidiOut")
	ecall			# realiza o ecall
	
	li a0,61		# a0 = 76 (carrega mi para a0)
	li a1,1000		# a1 = 100 (nota de duração de 100 ms)
	li a2,32		# a2 = 32 (timbre "guitar harmonic")
	li a3,100		# a3 = 50 (volume da nota)
	li a7,31		# a7 = 31 (carrega em a7 o ecall "MidiOut")
	ecall			# realiza o ecall
	
	li a0,58		# a0 = 76 (carrega mi para a0)
	li a1,1000		# a1 = 100 (nota de duração de 100 ms)
	li a2,32		# a2 = 32 (timbre "guitar harmonic")
	li a3,100		# a3 = 50 (volume da nota)
	li a7,31		# a7 = 31 (carrega em a7 o ecall "MidiOut")
	ecall			# realiza o ecall
	
	li a0,53		# a0 = 76 (carrega mi para a0)
	li a1,1000		# a1 = 100 (nota de duração de 100 ms)
	li a2,32		# a2 = 32 (timbre "guitar harmonic")
	li a3,100		# a3 = 50 (volume da nota)
	li a7,31		# a7 = 31 (carrega em a7 o ecall "MidiOut")
	ecall			# realiza o ecall
	
	li a0,46		# a0 = 76 (carrega mi para a0)
	li a1,1000		# a1 = 100 (nota de duração de 100 ms)
	li a2,32		# a2 = 32 (timbre "guitar harmonic")
	li a3,100		# a3 = 50 (volume da nota)
	li a7,31		# a7 = 31 (carrega em a7 o ecall "MidiOut")
	ecall			# realiza o ecall
	
	li a0,1000
	li a7,32           	# define a chamada de syscal para pausa
   	ecall               	# realiza uma pausa de 3 s
	
	li a0,70		# a0 = 76 (carrega mi para a0)
	li a1,1000		# a1 = 100 (nota de duração de 100 ms)
	li a2,32		# a2 = 32 (timbre "guitar harmonic")
	li a3,100		# a3 = 50 (volume da nota)
	li a7,31		# a7 = 31 (carrega em a7 o ecall "MidiOut")
	ecall			# realiza o ecall
	
	li a0,66		# a0 = 76 (carrega mi para a0)
	li a1,1000		# a1 = 100 (nota de duração de 100 ms)
	li a2,32		# a2 = 32 (timbre "guitar harmonic")
	li a3,100		# a3 = 50 (volume da nota)
	li a7,31		# a7 = 31 (carrega em a7 o ecall "MidiOut")
	ecall			# realiza o ecall
	
	li a0,63		# a0 = 76 (carrega mi para a0)
	li a1,1000		# a1 = 100 (nota de duração de 100 ms)
	li a2,32		# a2 = 32 (timbre "guitar harmonic")
	li a3,100		# a3 = 50 (volume da nota)
	li a7,31		# a7 = 31 (carrega em a7 o ecall "MidiOut")
	ecall			# realiza o ecall
	
	li a0,58		# a0 = 76 (carrega mi para a0)
	li a1,1000		# a1 = 100 (nota de duração de 100 ms)
	li a2,32		# a2 = 32 (timbre "guitar harmonic")
	li a3,100		# a3 = 50 (volume da nota)
	li a7,31		# a7 = 31 (carrega em a7 o ecall "MidiOut")
	ecall			# realiza o ecall
	
	li a0,51		# a0 = 76 (carrega mi para a0)
	li a1,1000		# a1 = 100 (nota de duração de 100 ms)
	li a2,32		# a2 = 32 (timbre "guitar harmonic")
	li a3,100		# a3 = 50 (volume da nota)
	li a7,31		# a7 = 31 (carrega em a7 o ecall "MidiOut")
	ecall			# realiza o ecall

	li a0,3000
	li a7,32           	# define a chamada de syscal para pausa
   	ecall               	# realiza uma pausa de 3 s
   	
# Carrega a imagem1 (mapa2) no frame 0
	
IMG1_1:	la t4, mapa1		# t4 cerrega endereÃƒÂ§o do mapa a fim de comparaÃƒÂ§ÃƒÂ£o
	li t5,0xFF000000	# t5 = endereco inicial da Memoria VGA - Frame 0
	li t6,0xFF012C00	# t6 = endereco final da Memoria VGA - Frame 0
	la s0,mapa1		# s0 = endereÃƒÂ§o dos dados do mapa 1
	mv t3, s0		# t3 = endereÃƒÂ§o inicial armazenado a fins de comparaÃƒÂ§ÃƒÂ£o
	addi s0,s0,8		# s0 = endereÃƒÂ§o do primeiro pixel da imagem (depois das informaÃƒÂ§ÃƒÂµes de nlin ncol)
	
LOOP1_1: 
	beq t5,t6,IMAGEM_1	# se t5 = ÃƒÂºltimo endereÃƒÂ§o da Memoria VGA, saia do loop
	lw t0,0(s0)		# le uma word do endereÃƒÂ§o s0 (le 4 pixels da imagem)
	sw t0,0(t5)		# escreve a word na memÃƒÂ³ria VGA no endereÃƒÂ§o t5 (desenha 4 pixels na tela do Bitmap Display)
	addi t5,t5,4		# soma 4 ao endereÃƒÂ§o t5 
	addi s0,s0,4		# soma 4 ao endereÃƒÂ§o s0
	j LOOP1_1		# volta a verificar a condiÃƒÂ§ao do loop

# Carrega a imagem2 (Robozinho1 - imagem 16x16) no frame 0

IMG2_1:	li t5,0xFF00A0C8	# t5 = endereco inicial da primeira linha do Robozinho - Frame 0
	li t6,0xFF00A0D8	# t6 = endereco final da primeira linha do Robozinho (inicial +16) - Frame 0
	la s0,Robozinho1	# s0 = endereÃƒÂ§o dos dados do Robozinho1 (boca fechada)
	mv t3, s0		# t3 = endereÃƒÂ§o inicial armazenado a fins de comparaÃƒÂ§ÃƒÂ£o
	addi s0,s0,8		# s0 = endereÃƒÂ§o do primeiro pixel da imagem (depois das informaÃƒÂ§ÃƒÂµes de nlin ncol)
	j PRINT16_1
	
# Carrega a imagem3 (ALIEN1 - imagem16x16)

IMG3_1:	li t5,0xFF0064C8	# t5 = endereco inicial da primeira linha do alien 1 - Frame 0 
	li t6,0xFF0064D8	# t6 = endereco final da primeira linha do alien 1 (inicial +16) - Frame 0      
	la s0,Inimigo1          # s0 = endereÃƒÂ§o dos dados do alien1
	mv t3, s0		# t3 = endereÃƒÂ§o inicial armazenado a fins de comparaÃƒÂ§ÃƒÂ£o
	addi s0,s0,8		# s0 = endereÃƒÂ§o do primeiro pixel da imagem (depois das informaÃƒÂ§ÃƒÂµes de nlin ncol)
	j PRINT16_1
	
# Carrega a imagem4 (ALIEN2 - imagem16x16)

IMG4_1:	li t5,0xFF0087C8	# t5 = endereco inicial da primeira linha do alien 2 - Frame 0
	li t6,0xFF0087D8	# t6 = endereco final da primeira linha do alien 2 - Frame 0
	la s0,Inimigo2          # s0 = endereÃƒÂ§o dos dados do alien2
	mv t3, s0		# t3 = endereÃƒÂ§o inicial armazenado a fins de comparaÃƒÂ§ÃƒÂ£o
	addi s0,s0,8		# s0 = endereÃƒÂ§o do primeiro pixel da imagem (depois das informaÃƒÂ§ÃƒÂµes de nlin ncol)
	j PRINT16_1

# Carrega a imagem5 (ALIEN3 - imagem16x16)

IMG5_1:	li t5,0xFF0087B8	# t5 = endereco inicial da primeira linha do alien 3 - Frame 0
	li t6,0xFF0087C8	# t6 = endereco final da primeira linha do alien 3 - Frame 0
	la s0,Inimigo3          # s0 = endereÃƒÂ§o dos dados do alien3
	mv t3, s0		# t3 = endereÃƒÂ§o inicial armazenado a fins de comparaÃƒÂ§ÃƒÂ£o
	addi s0,s0,8		# s0 = endereÃƒÂ§o do primeiro pixel da imagem (depois das informaÃƒÂ§ÃƒÂµes de nlin ncol)
	j PRINT16_1
	
# Carrega a imagem6 (ALIEN4 - imagem16x16)

IMG6_1:	li t5,0xFF0087D8	# t5 = endereco inicial da primeira linha do alien 4 - Frame 0
	li t6,0xFF0087E8	# t6 = endereco final da primeira linha do alien 4 - Frame 0
	la s0, Inimigo4         # s0 = endereÃƒÂ§o dos dados do alien4 
	mv t3, s0		# t3 = endereÃƒÂ§o inicial armazenado a fins de comparaÃƒÂ§ÃƒÂ£o
	addi s0,s0,8		# s0 = endereÃƒÂ§o do primeiro pixel da imagem (depois das informaÃƒÂ§ÃƒÂµes de nlin ncol)
	j PRINT16_1
	
# Carrega a imagem7 (mapa1 - colisao) no frame 1
	
IMG7_1:	li t5,0xFF100000	# t5 = endereco inicial da Memoria VGA - Frame 1
	li t6,0xFF112C00	# t6 = endereco final da Memoria VGA - Frame 1
	la s0,mapa1colisao	# s0 = endereÃƒÂ§o dos dados da colisao do mapa 1
	mv t3, s0		# t3 = endereÃƒÂ§o inicial armazenado a fins de comparaÃƒÂ§ÃƒÂ£o
	addi s0,s0,8		# s0 = endereÃƒÂ§o do primeiro pixel da imagem (depois das informaÃƒÂ§ÃƒÂµes de nlin ncol)
	
LOOPCOL_1:
	beq t5,t6,IMAGEM_1	# se t5 = ÃƒÂºltimo endereÃƒÂ§o da Memoria VGA, saia do loop
	lw t0,0(s0)		# le uma word do endereÃƒÂ§o s0 (le 4 pixels da imagem)
	sw t0,0(t5)		# escreve a word na memÃƒÂ³ria VGA no endereÃƒÂ§o t5 (desenha 4 pixels na tela do Bitmap Display)
	addi t5,t5,4		# soma 4 ao endereÃƒÂ§o t5 
	addi s0,s0,4		# soma 4 ao endereÃƒÂ§o s0
	j LOOPCOL_1		# volta a verificar a condiÃƒÂ§ao do loop
	
# Carrega a imagem6 (Robozinho - imagem16x16)

IMG8_1:	li t5,0xFF10A0C8	# t5 = endereco inicial da primeira linha do alien 4 - Frame 0
	li t6,0xFF10A0D8	# t6 = endereco final da primeira linha do alien 4 - Frame 0
	li s0,0x69696969        # s0 = endereÃƒÂ§o dos dados do alien4 
	mv t3, s0		# t3 = endereÃƒÂ§o inicial armazenado a fins de comparaÃƒÂ§ÃƒÂ£o
	j PRINT16_Q_1
	
# Carrega a imagem6 (ALIEN1 - imagem16x16)

IMG9_1:	li t5,0xFF1064C8	# t5 = endereco inicial da primeira linha do alien 4 - Frame 0
	li t6,0xFF1064D8	# t6 = endereco final da primeira linha do alien 4 - Frame 0
	li s0,0x70707070       	# s0 = endereÃƒÂ§o dos dados do alien4 
	mv t3, s0		# t3 = endereÃƒÂ§o inicial armazenado a fins de comparaÃƒÂ§ÃƒÂ£o
	j PRINT16_Q_1

# Carrega a imagem6 (ALIEN4 - imagem16x16)

IMG10_1:li t5,0xFF1087C8	# t5 = endereco inicial da primeira linha do alien 4 - Frame 0
	li t6,0xFF1087D8	# t6 = endereco final da primeira linha do alien 4 - Frame 0
	li s0,0x71717171        # s0 = endereÃƒÂ§o dos dados do alien4 
	mv t3, s0		# t3 = endereÃƒÂ§o inicial armazenado a fins de comparaÃƒÂ§ÃƒÂ£o
	j PRINT16_Q_1

# Carrega a imagem6 (ALIEN4 - imagem16x16)

IMG11_1:li t5,0xFF1087B8	# t5 = endereco inicial da primeira linha do alien 4 - Frame 0
	li t6,0xFF1087C8	# t6 = endereco final da primeira linha do alien 4 - Frame 0
	li s0,0x72727272        # s0 = endereÃƒÂ§o dos dados do alien4 
	mv t3, s0		# t3 = endereÃƒÂ§o inicial armazenado a fins de comparaÃƒÂ§ÃƒÂ£o
	j PRINT16_Q_1

# Carrega a imagem6 (ALIEN4 - imagem16x16)

IMG12_1:li t5,0xFF1087D8	# t5 = endereco inicial da primeira linha do alien 4 - Frame 0
	li t6,0xFF1087E8	# t6 = endereco final da primeira linha do alien 4 - Frame 0
	li s0,0x73737373        # s0 = endereÃƒÂ§o dos dados do alien4 
	mv t3, s0		# t3 = endereÃƒÂ§o inicial armazenado a fins de comparaÃƒÂ§ÃƒÂ£o
	j PRINT16_Q_1
	
# Compara os endereÃƒÂ§os para ver qual a proxima imagem a ser printada

IMAGEM_1: 
	beq t3, t4, IMG2_1 	# se t3 contiver o endereÃƒÂ§o "mapa1", vÃƒÂ¡ para IMG2 (imprime a imagem2)
	
	la t4, Robozinho1	# t4 = endereÃƒÂ§o dos dados do Robozinho1
	beq t3, t4, IMG3_1	# se t3 contiver o endereÃƒÂ§o "Robozinho1", vÃƒÂ¡ para IMG3 (imprime a imagem3)
	
	la t4, Inimigo1		# t4 = endereÃƒÂ§o dos dados do alien 1
	beq t3, t4, IMG4_1	# se t3 contiver o endereÃƒÂ§o "Inimigo1", vÃƒÂ¡ para IMG4 (imprime a imagem4)
	
	la t4, Inimigo2		# t4 = endereÃƒÂ§o dos dados do alien 2
	beq t3, t4, IMG5_1	# se t3 contiver o endereÃƒÂ§o "Inimigo2", vÃƒÂ¡ para IMG5 (imprime a imagem5)
	
	la t4, Inimigo3		# t4 = endereÃƒÂ§o dos dados do alien 3
	beq t3, t4, IMG6_1	# se t3 contiver o endereÃƒÂ§o "Inimigo3", vÃƒÂ¡ para IMG6 (imprime a imagem6)
	
	la t4, Inimigo4		# t4 = endereÃƒÂ§o dos dados do alien 4
	beq t3, t4, IMG7_1	# se t3 contiver o endereÃƒÂ§o "Inimigo4", vÃƒÂ¡ para IMG7 (imprime a imagem7)
	
	la t4, mapa1colisao
	beq t3, t4, IMG8_1	# se t3 contiver o endereÃƒÂ§o "Inimigo4", vÃƒÂ¡ para IMG7 (imprime a imagem7)
	
	li t4, 0x69696969
	beq t3, t4, IMG9_1	# se t3 contiver o endereÃƒÂ§o "Inimigo4", vÃƒÂ¡ para IMG7 (imprime a imagem7)
	
	li t4, 0x70707070
	beq t3, t4, IMG10_1	# se t3 contiver o endereÃƒÂ§o "Inimigo4", vÃƒÂ¡ para IMG7 (imprime a imagem7)
	
	li t4, 0x71717171
	beq t3, t4, IMG11_1	# se t3 contiver o endereÃƒÂ§o "Inimigo4", vÃƒÂ¡ para IMG7 (imprime a imagem7)
	
	li t4, 0x72727272
	beq t3, t4, IMG12_1	# se t3 contiver o endereÃƒÂ§o "Inimigo4", vÃƒÂ¡ para IMG7 (imprime a imagem7)
	
	li t4, 0x73737373
	beq t3, t4, SETUP_MAIN_1	# se t3 contiver o endereÃƒÂ§o "Inimigo4", vÃƒÂ¡ para IMG7 (imprime a imagem7)	
	
# Loop que imprime imagens 16x16

PRINT16_1:
	li t1,0
	li t2,16		#inicializa o contador de quebra de linha para 16 quebras de linha
	
LOOP2_1: 	
	beq t5,t6,ENTER_1	# se t5 atingir o fim da linha de pixels, quebre linha
	lw t0,0(s0)		# le uma word do endereÃƒÂ§o s0 (le 4 pixels da imagem)
	sw t0,0(t5)		# escreve a word na memÃƒÂ³ria VGA no endereÃƒÂ§o t5 (desenha 4 pixels na tela do Bitmap Display)
	addi t5,t5,4		# soma 4 ao endereÃƒÂ§o t5
	addi s0,s0,4		# soma 4 ao endereÃƒÂ§o s0
	j LOOP2_1 		# volta a verificar a condiÃƒÂ§ao do loop
	
ENTER_1:	
	addi t5,t5,304		# t5 pula para o pixel inicial da linha de baixo
	addi t6,t6,320		# t6 pula para o pixel final da linha de baixo
	addi t1,t1,1          	# atualiza o contador de quebras de linha
	beq t1,t2,IMAGEM_1	# termina o carregamento da imagem se 17 quebras de linha ocorrerem
	j LOOP2_1

# Loop que imprime imagens 16x16

PRINT16_Q_1:
	li t1,0
	li t2,16		#inicializa o contador de quebra de linha para 16 quebras de linha
	
LOOP2Q_1: beq t5,t6,ENTERQ_1	# se t5 atingir o fim da linha de pixels, quebre linha
	sw s0,0(t5)		# escreve a word na memÃƒÂ³ria VGA no endereÃƒÂ§o t5 (desenha 4 pixels na tela do Bitmap Display)
	addi t5,t5,4		# soma 4 ao endereÃƒÂ§o t5
	j LOOP2Q_1		# volta a verificar a condiÃƒÂ§ao do loop
	
ENTERQ_1:	addi t5,t5,304		# t5 pula para o pixel inicial da linha de baixo
	addi t6,t6,320		# t6 pula para o pixel final da linha de baixo
	addi t1,t1,1          	# atualiza o contador de quebras de linha
	beq t1,t2,IMAGEM_1	# termina o carregamento da imagem se 17 quebras de linha ocorrerem
	j LOOP2Q_1
	
# Setup dos dados necessarios para o main loop

SETUP_MAIN_1:

	li s0,2			# s0 = 2 (zera o contador de movimentaÃ§Ãµes do Robozinho)
	addi s2,s2,-1			
	li s3,0			# s3 = 0 (zera o estado de movimentaÃ§Ã£o atual do Robozinho)
	li s5,0			# s5 = 0 (zera o estado de persrguiÃ§Ã£o dos aliens)
	li s6,1			# s6 = 2 (fase 2)
	li s7,0			# s7 = 0 (zera o verificador de aliens)
	li s4,17		# s4 = 17 (zera o estado de movimentaÃ§Ã£o atual do inimigo1 : chase_mode)
	li s9,17		# s9 = 17 (zera o estado de movimentaÃ§Ã£o atual do inmimigo2 : chase_mode)
	li s10,17 		# s10 = 17 (zera o estado de movimentaÃ§Ã£o atual do inimigo3 : chase_mode)
	li s11,17 		# s11 = 17 (zera o estado de movimentaÃ§Ã£o atual do inimigo4 : chase_mode)
	
	la t0,CONTADOR_ASSUSTADO
	li t3,-1		
	sw t3,0(t0)
	
	li t1,0xFF00B4C8
	la t0,POS_ROBOZINHO    # carrega o endereÃ§o de "POS_ROBOZINHO" no registrador t0 
    	sw t1,0(t0)       	# guarda a word armazenada em t1 (posiÃ§Ã£o atual do Roboziho) em "POS_ROBOZINHO"
    	
    	li t1,0xFF0078C8
	la t0,POS_BLINKY    # carrega o endereÃ§o de "POS_ROBOZINHO" no registrador t0 
    	sw t1,0(t0)       	# guarda a word armazenada em t1 (posiÃ§Ã£o atual do Roboziho) em "POS_ROBOZINHO"
    	
    	li t1,0xFF009BC8
	la t0,POS_PINK    # carrega o endereÃ§o de "POS_ROBOZINHO" no registrador t0 
    	sw t1,0(t0)       	# guarda a word armazenada em t1 (posiÃ§Ã£o atual do Roboziho) em "POS_ROBOZINHO"
    	
    	li t1,0xFF009BB8
	la t0,POS_INKY    # carrega o endereÃ§o de "POS_ROBOZINHO" no registrador t0 
    	sw t1,0(t0)       	# guarda a word armazenada em t1 (posiÃ§Ã£o atual do Roboziho) em "POS_ROBOZINHO"
    	
    	li t1,0xFF009BD8
	la t0,POS_CLYDE    # carrega o endereÃ§o de "POS_ROBOZINHO" no registrador t0 
    	sw t1,0(t0)       	# guarda a word armazenada em t1 (posiÃ§Ã£o atual do Roboziho) em "POS_ROBOZINHO"
	
	jal zero, MAINL

###########################
##### DADOS DA FASE 2 #####
###########################

FASE2:  addi s2,s2,1
	li s1,0
	
# Toca a musica de transicao de fase
	
	li a0,100
	li a7,32           	# define a chamada de syscal para pausa
   	ecall               	# realiza uma pausa de 3 s
	
	li a0,62		# a0 = 76 (carrega mi para a0)
	li a1,125		# a1 = 100 (nota de duração de 100 ms)
	li a2,32		# a2 = 32 (timbre "guitar harmonic")
	li a3,100		# a3 = 50 (volume da nota)
	li a7,31		# a7 = 31 (carrega em a7 o ecall "MidiOut")
	ecall			# realiza o ecall
	
	li a0,250
	li a7,32           	# define a chamada de syscal para pausa
   	ecall               	# realiza uma pausa de 3 s
	
	li a0,62		# a0 = 76 (carrega mi para a0)
	li a1,125		# a1 = 100 (nota de duração de 100 ms)
	li a2,32		# a2 = 32 (timbre "guitar harmonic")
	li a3,100		# a3 = 50 (volume da nota)
	li a7,31		# a7 = 31 (carrega em a7 o ecall "MidiOut")
	ecall			# realiza o ecall
	
	li a0,250
	li a7,32           	# define a chamada de syscal para pausa
   	ecall               	# realiza uma pausa de 3 s
	
	li a0,57		# a0 = 76 (carrega mi para a0)
	li a1,125		# a1 = 100 (nota de duração de 100 ms)
	li a2,32		# a2 = 32 (timbre "guitar harmonic")
	li a3,100		# a3 = 50 (volume da nota)
	li a7,31		# a7 = 31 (carrega em a7 o ecall "MidiOut")
	ecall			# realiza o ecall
	
	li a0,125
	li a7,32           	# define a chamada de syscal para pausa
   	ecall               	# realiza uma pausa de 3 s
	
	li a0,59		# a0 = 76 (carrega mi para a0)
	li a1,125		# a1 = 100 (nota de duração de 100 ms)
	li a2,32		# a2 = 32 (timbre "guitar harmonic")
	li a3,100		# a3 = 50 (volume da nota)
	li a7,31		# a7 = 31 (carrega em a7 o ecall "MidiOut")
	ecall			# realiza o ecall
	
	li a0,125
	li a7,32           	# define a chamada de syscal para pausa
   	ecall               	# realiza uma pausa de 3 s
	
	li a0,60		# a0 = 76 (carrega mi para a0)
	li a1,125		# a1 = 100 (nota de duração de 100 ms)
	li a2,32		# a2 = 32 (timbre "guitar harmonic")
	li a3,100		# a3 = 50 (volume da nota)
	li a7,31		# a7 = 31 (carrega em a7 o ecall "MidiOut")
	ecall			# realiza o ecall
	
	li a0,125
	li a7,32           	# define a chamada de syscal para pausa
   	ecall               	# realiza uma pausa de 3 s
	
	li a0,62		# a0 = 76 (carrega mi para a0)
	li a1,125		# a1 = 100 (nota de duração de 100 ms)
	li a2,32		# a2 = 32 (timbre "guitar harmonic")
	li a3,100		# a3 = 50 (volume da nota)
	li a7,31		# a7 = 31 (carrega em a7 o ecall "MidiOut")
	ecall			# realiza o ecall
	
	j SKPSNG		# pula a musica de morte

RESET_FASE2:
	
# Toca a musica de morte
	
	li a0,100
	li a7,32           	# define a chamada de syscal para pausa
   	ecall               	# realiza uma pausa de 3 s
   	
   	li a0,70		# a0 = 76 (carrega mi para a0)
	li a1,1000		# a1 = 100 (nota de duração de 100 ms)
	li a2,32		# a2 = 32 (timbre "guitar harmonic")
	li a3,100		# a3 = 50 (volume da nota)
	li a7,31		# a7 = 31 (carrega em a7 o ecall "MidiOut")
	ecall			# realiza o ecall
	
	li a0,65		# a0 = 76 (carrega mi para a0)
	li a1,1000		# a1 = 100 (nota de duração de 100 ms)
	li a2,32		# a2 = 32 (timbre "guitar harmonic")
	li a3,100		# a3 = 50 (volume da nota)
	li a7,31		# a7 = 31 (carrega em a7 o ecall "MidiOut")
	ecall			# realiza o ecall
	
	li a0,61		# a0 = 76 (carrega mi para a0)
	li a1,1000		# a1 = 100 (nota de duração de 100 ms)
	li a2,32		# a2 = 32 (timbre "guitar harmonic")
	li a3,100		# a3 = 50 (volume da nota)
	li a7,31		# a7 = 31 (carrega em a7 o ecall "MidiOut")
	ecall			# realiza o ecall
	
	li a0,58		# a0 = 76 (carrega mi para a0)
	li a1,1000		# a1 = 100 (nota de duração de 100 ms)
	li a2,32		# a2 = 32 (timbre "guitar harmonic")
	li a3,100		# a3 = 50 (volume da nota)
	li a7,31		# a7 = 31 (carrega em a7 o ecall "MidiOut")
	ecall			# realiza o ecall
	
	li a0,53		# a0 = 76 (carrega mi para a0)
	li a1,1000		# a1 = 100 (nota de duração de 100 ms)
	li a2,32		# a2 = 32 (timbre "guitar harmonic")
	li a3,100		# a3 = 50 (volume da nota)
	li a7,31		# a7 = 31 (carrega em a7 o ecall "MidiOut")
	ecall			# realiza o ecall
	
	li a0,46		# a0 = 76 (carrega mi para a0)
	li a1,1000		# a1 = 100 (nota de duração de 100 ms)
	li a2,32		# a2 = 32 (timbre "guitar harmonic")
	li a3,100		# a3 = 50 (volume da nota)
	li a7,31		# a7 = 31 (carrega em a7 o ecall "MidiOut")
	ecall			# realiza o ecall
	
	li a0,1000
	li a7,32           	# define a chamada de syscal para pausa
   	ecall               	# realiza uma pausa de 3 s
	
	li a0,70		# a0 = 76 (carrega mi para a0)
	li a1,1000		# a1 = 100 (nota de duração de 100 ms)
	li a2,32		# a2 = 32 (timbre "guitar harmonic")
	li a3,100		# a3 = 50 (volume da nota)
	li a7,31		# a7 = 31 (carrega em a7 o ecall "MidiOut")
	ecall			# realiza o ecall
	
	li a0,66		# a0 = 76 (carrega mi para a0)
	li a1,1000		# a1 = 100 (nota de duração de 100 ms)
	li a2,32		# a2 = 32 (timbre "guitar harmonic")
	li a3,100		# a3 = 50 (volume da nota)
	li a7,31		# a7 = 31 (carrega em a7 o ecall "MidiOut")
	ecall			# realiza o ecall
	
	li a0,63		# a0 = 76 (carrega mi para a0)
	li a1,1000		# a1 = 100 (nota de duração de 100 ms)
	li a2,32		# a2 = 32 (timbre "guitar harmonic")
	li a3,100		# a3 = 50 (volume da nota)
	li a7,31		# a7 = 31 (carrega em a7 o ecall "MidiOut")
	ecall			# realiza o ecall
	
	li a0,58		# a0 = 76 (carrega mi para a0)
	li a1,1000		# a1 = 100 (nota de duração de 100 ms)
	li a2,32		# a2 = 32 (timbre "guitar harmonic")
	li a3,100		# a3 = 50 (volume da nota)
	li a7,31		# a7 = 31 (carrega em a7 o ecall "MidiOut")
	ecall			# realiza o ecall
	
	li a0,51		# a0 = 76 (carrega mi para a0)
	li a1,1000		# a1 = 100 (nota de duração de 100 ms)
	li a2,32		# a2 = 32 (timbre "guitar harmonic")
	li a3,100		# a3 = 50 (volume da nota)
	li a7,31		# a7 = 31 (carrega em a7 o ecall "MidiOut")
	ecall			# realiza o ecall

SKPSNG:	li a0,3000
	li a7,32           	# define a chamada de syscal para pausa
   	ecall               	# realiza uma pausa de 3 s
   	
# Carrega a imagem1 (mapa2) no frame 0
	
IMG1_2:	la t4, mapa2		# t4 cerrega endereÃƒÂ§o do mapa a fim de comparaÃƒÂ§ÃƒÂ£o
	li t5,0xFF000000	# t5 = endereco inicial da Memoria VGA - Frame 0
	li t6,0xFF012C00	# t6 = endereco final da Memoria VGA - Frame 0
	la s0,mapa2		# s0 = endereÃƒÂ§o dos dados do mapa 1
	mv t3, s0		# t3 = endereÃƒÂ§o inicial armazenado a fins de comparaÃƒÂ§ÃƒÂ£o
	addi s0,s0,8		# s0 = endereÃƒÂ§o do primeiro pixel da imagem (depois das informaÃƒÂ§ÃƒÂµes de nlin ncol)
	
LOOP1_2: 
	beq t5,t6,IMAGEM_2	# se t5 = ÃƒÂºltimo endereÃƒÂ§o da Memoria VGA, saia do loop
	lw t0,0(s0)		# le uma word do endereÃƒÂ§o s0 (le 4 pixels da imagem)
	sw t0,0(t5)		# escreve a word na memÃƒÂ³ria VGA no endereÃƒÂ§o t5 (desenha 4 pixels na tela do Bitmap Display)
	addi t5,t5,4		# soma 4 ao endereÃƒÂ§o t5 
	addi s0,s0,4		# soma 4 ao endereÃƒÂ§o s0
	j LOOP1_2		# volta a verificar a condiÃƒÂ§ao do loop

# Carrega a imagem2 (Robozinho1 - imagem 16x16) no frame 0

IMG2_2:	li t5,0xFF00A0C8	# t5 = endereco inicial da primeira linha do Robozinho - Frame 0
	li t6,0xFF00A0D8	# t6 = endereco final da primeira linha do Robozinho (inicial +16) - Frame 0
	la s0,Robozinho1	# s0 = endereÃƒÂ§o dos dados do Robozinho1 (boca fechada)
	mv t3, s0		# t3 = endereÃƒÂ§o inicial armazenado a fins de comparaÃƒÂ§ÃƒÂ£o
	addi s0,s0,8		# s0 = endereÃƒÂ§o do primeiro pixel da imagem (depois das informaÃƒÂ§ÃƒÂµes de nlin ncol)
	j PRINT16_2
	
# Carrega a imagem3 (ALIEN1 - imagem16x16)

IMG3_2:	li t5,0xFF0064C8	# t5 = endereco inicial da primeira linha do alien 1 - Frame 0 
	li t6,0xFF0064D8	# t6 = endereco final da primeira linha do alien 1 (inicial +16) - Frame 0      
	la s0,Inimigo1          # s0 = endereÃƒÂ§o dos dados do alien1
	mv t3, s0		# t3 = endereÃƒÂ§o inicial armazenado a fins de comparaÃƒÂ§ÃƒÂ£o
	addi s0,s0,8		# s0 = endereÃƒÂ§o do primeiro pixel da imagem (depois das informaÃƒÂ§ÃƒÂµes de nlin ncol)
	j PRINT16_2
	
# Carrega a imagem4 (ALIEN2 - imagem16x16)

IMG4_2:	li t5,0xFF0087C8	# t5 = endereco inicial da primeira linha do alien 2 - Frame 0
	li t6,0xFF0087D8	# t6 = endereco final da primeira linha do alien 2 - Frame 0
	la s0,Inimigo2          # s0 = endereÃƒÂ§o dos dados do alien2
	mv t3, s0		# t3 = endereÃƒÂ§o inicial armazenado a fins de comparaÃƒÂ§ÃƒÂ£o
	addi s0,s0,8		# s0 = endereÃƒÂ§o do primeiro pixel da imagem (depois das informaÃƒÂ§ÃƒÂµes de nlin ncol)
	j PRINT16_2

# Carrega a imagem5 (ALIEN3 - imagem16x16)

IMG5_2:	li t5,0xFF0087B8	# t5 = endereco inicial da primeira linha do alien 3 - Frame 0
	li t6,0xFF0087C8	# t6 = endereco final da primeira linha do alien 3 - Frame 0
	la s0,Inimigo3          # s0 = endereÃƒÂ§o dos dados do alien3
	mv t3, s0		# t3 = endereÃƒÂ§o inicial armazenado a fins de comparaÃƒÂ§ÃƒÂ£o
	addi s0,s0,8		# s0 = endereÃƒÂ§o do primeiro pixel da imagem (depois das informaÃƒÂ§ÃƒÂµes de nlin ncol)
	j PRINT16_2
	
# Carrega a imagem6 (ALIEN4 - imagem16x16)

IMG6_2:	li t5,0xFF0087D8	# t5 = endereco inicial da primeira linha do alien 4 - Frame 0
	li t6,0xFF0087E8	# t6 = endereco final da primeira linha do alien 4 - Frame 0
	la s0, Inimigo4         # s0 = endereÃƒÂ§o dos dados do alien4 
	mv t3, s0		# t3 = endereÃƒÂ§o inicial armazenado a fins de comparaÃƒÂ§ÃƒÂ£o
	addi s0,s0,8		# s0 = endereÃƒÂ§o do primeiro pixel da imagem (depois das informaÃƒÂ§ÃƒÂµes de nlin ncol)
	j PRINT16_2
	
# Carrega a imagem7 (mapa1 - colisao) no frame 1
	
IMG7_2:	li t5,0xFF100000	# t5 = endereco inicial da Memoria VGA - Frame 1
	li t6,0xFF112C00	# t6 = endereco final da Memoria VGA - Frame 1
	la s0,mapa2colisao	# s0 = endereÃƒÂ§o dos dados da colisao do mapa 1
	mv t3, s0		# t3 = endereÃƒÂ§o inicial armazenado a fins de comparaÃƒÂ§ÃƒÂ£o
	addi s0,s0,8		# s0 = endereÃƒÂ§o do primeiro pixel da imagem (depois das informaÃƒÂ§ÃƒÂµes de nlin ncol)
	
LOOPCOL_2:
	beq t5,t6,IMAGEM_2	# se t5 = ÃƒÂºltimo endereÃƒÂ§o da Memoria VGA, saia do loop
	lw t0,0(s0)		# le uma word do endereÃƒÂ§o s0 (le 4 pixels da imagem)
	sw t0,0(t5)		# escreve a word na memÃƒÂ³ria VGA no endereÃƒÂ§o t5 (desenha 4 pixels na tela do Bitmap Display)
	addi t5,t5,4		# soma 4 ao endereÃƒÂ§o t5 
	addi s0,s0,4		# soma 4 ao endereÃƒÂ§o s0
	j LOOPCOL_2		# volta a verificar a condiÃƒÂ§ao do loop
	
# Carrega a imagem6 (Robozinho - imagem16x16)

IMG8_2:	li t5,0xFF10A0C8	# t5 = endereco inicial da primeira linha do alien 4 - Frame 0
	li t6,0xFF10A0D8	# t6 = endereco final da primeira linha do alien 4 - Frame 0
	li s0,0x69696969        # s0 = endereÃƒÂ§o dos dados do alien4 
	mv t3, s0		# t3 = endereÃƒÂ§o inicial armazenado a fins de comparaÃƒÂ§ÃƒÂ£o
	j PRINT16_Q_2
	
# Carrega a imagem6 (ALIEN1 - imagem16x16)

IMG9_2:	li t5,0xFF1064C8	# t5 = endereco inicial da primeira linha do alien 4 - Frame 0
	li t6,0xFF1064D8	# t6 = endereco final da primeira linha do alien 4 - Frame 0
	li s0,0x70707070       	# s0 = endereÃƒÂ§o dos dados do alien4 
	mv t3, s0		# t3 = endereÃƒÂ§o inicial armazenado a fins de comparaÃƒÂ§ÃƒÂ£o
	j PRINT16_Q_2

# Carrega a imagem6 (ALIEN4 - imagem16x16)

IMG10_2:li t5,0xFF1087C8	# t5 = endereco inicial da primeira linha do alien 4 - Frame 0
	li t6,0xFF1087D8	# t6 = endereco final da primeira linha do alien 4 - Frame 0
	li s0,0x71717171        # s0 = endereÃƒÂ§o dos dados do alien4 
	mv t3, s0		# t3 = endereÃƒÂ§o inicial armazenado a fins de comparaÃƒÂ§ÃƒÂ£o
	j PRINT16_Q_2

# Carrega a imagem6 (ALIEN4 - imagem16x16)

IMG11_2:li t5,0xFF1087B8	# t5 = endereco inicial da primeira linha do alien 4 - Frame 0
	li t6,0xFF1087C8	# t6 = endereco final da primeira linha do alien 4 - Frame 0
	li s0,0x72727272        # s0 = endereÃƒÂ§o dos dados do alien4 
	mv t3, s0		# t3 = endereÃƒÂ§o inicial armazenado a fins de comparaÃƒÂ§ÃƒÂ£o
	j PRINT16_Q_2

# Carrega a imagem6 (ALIEN4 - imagem16x16)

IMG12_2:li t5,0xFF1087D8	# t5 = endereco inicial da primeira linha do alien 4 - Frame 0
	li t6,0xFF1087E8	# t6 = endereco final da primeira linha do alien 4 - Frame 0
	li s0,0x73737373        # s0 = endereÃƒÂ§o dos dados do alien4 
	mv t3, s0		# t3 = endereÃƒÂ§o inicial armazenado a fins de comparaÃƒÂ§ÃƒÂ£o
	j PRINT16_Q_2
	
# Compara os endereÃƒÂ§os para ver qual a proxima imagem a ser printada

IMAGEM_2: 
	beq t3, t4, IMG2_2 	# se t3 contiver o endereÃƒÂ§o "mapa1", vÃƒÂ¡ para IMG2 (imprime a imagem2)
	
	la t4, Robozinho1	# t4 = endereÃƒÂ§o dos dados do Robozinho1
	beq t3, t4, IMG3_2	# se t3 contiver o endereÃƒÂ§o "Robozinho1", vÃƒÂ¡ para IMG3 (imprime a imagem3)
	
	la t4, Inimigo1		# t4 = endereÃƒÂ§o dos dados do alien 1
	beq t3, t4, IMG4_2	# se t3 contiver o endereÃƒÂ§o "Inimigo1", vÃƒÂ¡ para IMG4 (imprime a imagem4)
	
	la t4, Inimigo2		# t4 = endereÃƒÂ§o dos dados do alien 2
	beq t3, t4, IMG5_2	# se t3 contiver o endereÃƒÂ§o "Inimigo2", vÃƒÂ¡ para IMG5 (imprime a imagem5)
	
	la t4, Inimigo3		# t4 = endereÃƒÂ§o dos dados do alien 3
	beq t3, t4, IMG6_2	# se t3 contiver o endereÃƒÂ§o "Inimigo3", vÃƒÂ¡ para IMG6 (imprime a imagem6)
	
	la t4, Inimigo4		# t4 = endereÃƒÂ§o dos dados do alien 4
	beq t3, t4, IMG7_2	# se t3 contiver o endereÃƒÂ§o "Inimigo4", vÃƒÂ¡ para IMG7 (imprime a imagem7)
	
	la t4, mapa2colisao
	beq t3, t4, IMG8_2	# se t3 contiver o endereÃƒÂ§o "Inimigo4", vÃƒÂ¡ para IMG7 (imprime a imagem7)
	
	li t4, 0x69696969
	beq t3, t4, IMG9_2	# se t3 contiver o endereÃƒÂ§o "Inimigo4", vÃƒÂ¡ para IMG7 (imprime a imagem7)
	
	li t4, 0x70707070
	beq t3, t4, IMG10_2	# se t3 contiver o endereÃƒÂ§o "Inimigo4", vÃƒÂ¡ para IMG7 (imprime a imagem7)
	
	li t4, 0x71717171
	beq t3, t4, IMG11_2	# se t3 contiver o endereÃƒÂ§o "Inimigo4", vÃƒÂ¡ para IMG7 (imprime a imagem7)
	
	li t4, 0x72727272
	beq t3, t4, IMG12_2	# se t3 contiver o endereÃƒÂ§o "Inimigo4", vÃƒÂ¡ para IMG7 (imprime a imagem7)
	
	li t4, 0x73737373
	beq t3, t4, SETUP_MAIN_2	# se t3 contiver o endereÃƒÂ§o "Inimigo4", vÃƒÂ¡ para IMG7 (imprime a imagem7)	
	
# Loop que imprime imagens 16x16

PRINT16_2:
	li t1,0
	li t2,16		#inicializa o contador de quebra de linha para 16 quebras de linha
	
LOOP2_2: 	
	beq t5,t6,ENTER_2	# se t5 atingir o fim da linha de pixels, quebre linha
	lw t0,0(s0)		# le uma word do endereÃƒÂ§o s0 (le 4 pixels da imagem)
	sw t0,0(t5)		# escreve a word na memÃƒÂ³ria VGA no endereÃƒÂ§o t5 (desenha 4 pixels na tela do Bitmap Display)
	addi t5,t5,4		# soma 4 ao endereÃƒÂ§o t5
	addi s0,s0,4		# soma 4 ao endereÃƒÂ§o s0
	j LOOP2_2 		# volta a verificar a condiÃƒÂ§ao do loop
	
ENTER_2:	
	addi t5,t5,304		# t5 pula para o pixel inicial da linha de baixo
	addi t6,t6,320		# t6 pula para o pixel final da linha de baixo
	addi t1,t1,1          	# atualiza o contador de quebras de linha
	beq t1,t2,IMAGEM_2	# termina o carregamento da imagem se 17 quebras de linha ocorrerem
	j LOOP2_2

# Loop que imprime imagens 16x16

PRINT16_Q_2:
	li t1,0
	li t2,16		#inicializa o contador de quebra de linha para 16 quebras de linha
	
LOOP2Q_2: beq t5,t6,ENTERQ_2	# se t5 atingir o fim da linha de pixels, quebre linha
	sw s0,0(t5)		# escreve a word na memÃƒÂ³ria VGA no endereÃƒÂ§o t5 (desenha 4 pixels na tela do Bitmap Display)
	addi t5,t5,4		# soma 4 ao endereÃƒÂ§o t5
	j LOOP2Q_2 		# volta a verificar a condiÃƒÂ§ao do loop
	
ENTERQ_2:	addi t5,t5,304		# t5 pula para o pixel inicial da linha de baixo
	addi t6,t6,320		# t6 pula para o pixel final da linha de baixo
	addi t1,t1,1          	# atualiza o contador de quebras de linha
	beq t1,t2,IMAGEM_2	# termina o carregamento da imagem se 17 quebras de linha ocorrerem
	j LOOP2Q_2
	
# Setup dos dados necessarios para o main loop

SETUP_MAIN_2:

	li s0,2			# s0 = 2 (zera o contador de movimentaÃ§Ãµes do Robozinho)
#	li s1,0			# s1 = 0 (zera o contador de pontos coletados)
	addi s2,s2,-1			# s2 = 3 (inicializa o contador de vidas do Robozinho com 3)
	li s3,0			# s3 = 0 (zera o estado de movimentaÃ§Ã£o atual do Robozinho)
	li s5,0			# s5 = 0 (zera o estado de persrguiÃ§Ã£o dos aliens)
	li s6,2			# s6 = 2 (fase 2)
	li s7,0			# s7 = 0 (zera o verificador de aliens)
	li s4,17		# s4 = 17 (zera o estado de movimentaÃ§Ã£o atual do inimigo1 : chase_mode)
	li s9,17		# s9 = 17 (zera o estado de movimentaÃ§Ã£o atual do inmimigo2 : chase_mode)
	li s10,17 		# s10 = 17 (zera o estado de movimentaÃ§Ã£o atual do inimigo3 : chase_mode)
	li s11,17 		# s11 = 17 (zera o estado de movimentaÃ§Ã£o atual do inimigo4 : chase_mode)
	
	la t0,CONTADOR_ASSUSTADO
	li t3,-1		
	sw t3,0(t0)
	
	li t1,0xFF00B4C8
	la t0,POS_ROBOZINHO    # carrega o endereÃ§o de "POS_ROBOZINHO" no registrador t0 
    	sw t1,0(t0)       	# guarda a word armazenada em t1 (posiÃ§Ã£o atual do Roboziho) em "POS_ROBOZINHO"
    	
    	li t1,0xFF0078C8
	la t0,POS_BLINKY    # carrega o endereÃ§o de "POS_ROBOZINHO" no registrador t0 
    	sw t1,0(t0)       	# guarda a word armazenada em t1 (posiÃ§Ã£o atual do Roboziho) em "POS_ROBOZINHO"
    	
    	li t1,0xFF009BC8
	la t0,POS_PINK    # carrega o endereÃ§o de "POS_ROBOZINHO" no registrador t0 
    	sw t1,0(t0)       	# guarda a word armazenada em t1 (posiÃ§Ã£o atual do Roboziho) em "POS_ROBOZINHO"
    	
    	li t1,0xFF009BB8
	la t0,POS_INKY    # carrega o endereÃ§o de "POS_ROBOZINHO" no registrador t0 
    	sw t1,0(t0)       	# guarda a word armazenada em t1 (posiÃ§Ã£o atual do Roboziho) em "POS_ROBOZINHO"
    	
    	li t1,0xFF009BD8
	la t0,POS_CLYDE    # carrega o endereÃ§o de "POS_ROBOZINHO" no registrador t0 
    	sw t1,0(t0)       	# guarda a word armazenada em t1 (posiÃ§Ã£o atual do Roboziho) em "POS_ROBOZINHO"
	
	jal zero, MAINL
	
.data 

.include "../System/SYSTEMv24.s"		# permite a utilizaÃ§Ã£o dos ecalls "1xx
