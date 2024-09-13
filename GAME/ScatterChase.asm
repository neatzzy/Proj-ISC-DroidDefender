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

.include "MACROSv24.s" 		# permite a utilização dos ecalls "1xx"
	
.data			

# Dados das notas da musica tocada no menu principal do jogo

# Numero de Notas a tocar

NUM: .word 64
NUM2: .word 16 

# lista de nota,duração,nota,duração,nota,duração,...

NOTAS: 66, 230, 61, 230, 78, 230, 61, 230, 73, 230, 61, 230, 76, 230, 78, 230, 73, 230, 76, 230, 73, 230, 76, 230, 78, 230, 61, 230, 78, 230, 61, 230, 76, 230, 64, 230, 71, 230, 62, 230, 71, 230, 64, 230, 73, 230, 76, 230, 73, 230, 71, 230, 73, 230, 61, 230, 73, 230, 61, 230, 73, 230, 61, 230, 69, 230, 64, 230, 66, 230, 61, 230, 57, 230, 61, 230, 57, 230, 61, 230, 69, 230, 64, 230, 66, 230, 61, 230, 57, 230, 61, 230, 76, 230, 78, 230, 73, 230, 71, 230, 73, 230, 57, 230, 73, 230, 57, 230, 64, 230, 57, 230, 73, 230, 57, 230, 73, 230, 57, 230, 64, 230, 57, 230, 73, 230, 57, 230 
NOTAS2: 42, 923, 49, 923, 42, 923, 49, 923, 44, 923, 52, 923, 45, 923, 49, 923, 42, 923, 49, 923, 42, 923, 49, 923, 45, 923, 52, 923, 45, 923, 52, 923 

# Dados diversos (strings para HUD, posições dos personagens no bitmap display, etc)

STR: .string "PONTOS: "

POS_ROBOZINHO: .word 0xFF00B4C8 # endereco inicial da linha diretamente abaixo do Robozinho - posição inicial/atual do Robozinho
POS_BLINKY: .word 0xFF0078C8	# coordenada inicial do alien verde claro (blinky)
POS_PINK: .word 0xFF009BC8	# coordenada inicial do alien azul (pink)
POS_INKY: .word 0xFF009BB8	# coordenada inicial do alien roxo (inky)
POS_CLYDE: .word 0xFF009BD8	# coordenada inicial do alien laranja (clyde)

CONTADOR_ASSUSTADO: .word -1

# inclusão das imagens 

.include "mapa1.data"
.include "mapa1colisao.data"
.include "mapa2.data"
.include "mapa2colisao.data"
.include "menuprincipal.data"
.include "Robozinho1.data"
.include "Robozinho2.data"
.include "Robozinho1forte.data"
.include "Robozinho2forte.data"
.include "Robozinho1preto.data"
.include "Inimigo1.data"
.include "Inimigo2.data"
.include "Inimigo3.data"
.include "Inimigo4.data"
.include "InimigoAssustado.data"
.include "horpoint.data"
.include "vertpoint.data"

.text

#Carrega o menu principal
	
	li s1,0xFF000000	# s1 = endereco inicial da Memoria VGA - Frame 0
	li s2,0xFF012C00	# s2 = endereco final da Memoria VGA - Frame 0
	la s0,menuprincipal	# s0 = endereÃ§o dos dados do mapa 1
	addi s0,s0,8		# s0 = endereÃ§o do primeiro pixel da imagem (depois das informaÃ§Ãµes de nlin ncol)
	
LOOPM: 	beq s1,s2,LOOPMEN	# se s1 = ultimo endereÃ§o da Memoria VGA, saia do loop
	lw t0,0(s0)		# le uma word do endereÃ§o s0 (le 4 pixels da imagem)
	sw t0,0(s1)		# escreve a word na memoria VGA no endereÃ§o s1 (desenha 4 pixels na tela do Bitmap Display)
	addi s1,s1,4		# soma 4 ao endereÃ§o s1 
	addi s0,s0,4		# soma 4 ao endereÃ§o s0
	j LOOPM			# volta a verificar a condiÃ§ao do loop
	
LOOPMEN:la s0, NUM       	# define o endereço do número de notas
    	lw s1, 0(s0)     	# le o numero de notas
    	la s0, NOTAS     	# define o endereço das notas
    	li t0, 0         	# zera o contador de notas

   	la s2, NUM2      	# define o endereço do número de notas2
    	lw s3, 0(s2)     	# le o numero de notas2
    	la s2, NOTAS2    	# define o endereço de notas2
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
   	addi s2, s2, 8   	# incrementa para o endereço da próxima nota
   	addi t1, t1, 1   	# incrementa o contador de notas

LOOP:   li t2,0xFF200000	# carrega o endereÃ§o de controle do KDMMIO ("teclado")
	lw t0,0(t2)		# le uma word a partir do endereÃ§o de controle do KDMMIO
	andi t0,t0,0x0001	# mascara todos os bits de t0 com exceÃ§ao do bit menos significativo
   	bne t0,zero,IMG1   	# se o BMS de t0 nÃ£o for 0 (hÃ¡ tecla pressionada), pule para MAPA1
   	
 	beq t0, s4, DOIS    	# se o contador2 chegou em 16, vá para DOIS
    
# Toca uma nota de NOTAS

    	lw a0, 0(s0)        	# le o valor da nota
   	lw a1, 4(s0)        	# le a duracao da nota
   	li a7, 31           	# define a chamada de syscall para tocar nota
    	ecall               	# toca a nota

# Pausa pela duração da nota

    	addi a1, a1, -5	    	# reduzir a pausa pra evitar pausa abrupta nas notas
   	mv a0, a1           	# move duracao da nota para a pausa
  	li a7, 32           	# define a chamada de syscal para pausa
   	ecall               	# realiza uma pausa de a0 ms

   	addi s0, s0, 8      	# incrementa para o endereço da próxima nota
   	addi t0, t0, 1      	# incrementa o contador de notas
   	 
   	j LOOP		    	# pule para LOOP
	
# Carrega a imagem1 (mapa1) no frame 0
	
IMG1:	la t4, mapa1		# t4 cerrega endereÃ§o do mapa a fim de comparaÃ§Ã£o
	li s1,0xFF000000	# s1 = endereco inicial da Memoria VGA - Frame 0
	li s2,0xFF012C00	# s2 = endereco final da Memoria VGA - Frame 0
	la s0,mapa1		# s0 = endereÃ§o dos dados do mapa 1
	mv t3, s0		# t3 = endereÃ§o inicial armazenado a fins de comparaÃ§Ã£o
	addi s0,s0,8		# s0 = endereÃ§o do primeiro pixel da imagem (depois das informaÃ§Ãµes de nlin ncol)
	
LOOP1: 	beq s1,s2,IMAGEM	# se s1 = Ãºltimo endereÃ§o da Memoria VGA, saia do loop
	lw t0,0(s0)		# le uma word do endereÃ§o s0 (le 4 pixels da imagem)
	sw t0,0(s1)		# escreve a word na memÃ³ria VGA no endereÃ§o s1 (desenha 4 pixels na tela do Bitmap Display)
	addi s1,s1,4		# soma 4 ao endereÃ§o s1 
	addi s0,s0,4		# soma 4 ao endereÃ§o s0
	j LOOP1			# volta a verificar a condiÃ§ao do loop

# Carrega a imagem2 (Robozinho1 - imagem 16x16) no frame 0

IMG2:	li s1,0xFF00A0C8	# s1 = endereco inicial da primeira linha do Robozinho - Frame 0
	li s2,0xFF00A0D8	# s2 = endereco final da primeira linha do Robozinho (inicial +16) - Frame 0
	la s0,Robozinho1	# s0 = endereÃ§o dos dados do Robozinho1 (boca fechada)
	mv t3, s0		# t3 = endereÃ§o inicial armazenado a fins de comparaÃ§Ã£o
	addi s0,s0,8		# s0 = endereÃ§o do primeiro pixel da imagem (depois das informaÃ§Ãµes de nlin ncol)
	j PRINT16
	
# Carrega a imagem3 (ALIEN1 - imagem16x16)

IMG3:	li s1,0xFF0064C8	# s1 = endereco inicial da primeira linha do alien 1 - Frame 0 
	li s2,0xFF0064D8	# s2 = endereco final da primeira linha do alien 1 (inicial +16) - Frame 0      
	la s0,Inimigo1          # s0 = endereÃ§o dos dados do alien1
	mv t3, s0		# t3 = endereÃ§o inicial armazenado a fins de comparaÃ§Ã£o
	addi s0,s0,8		# s0 = endereÃ§o do primeiro pixel da imagem (depois das informaÃ§Ãµes de nlin ncol)
	j PRINT16
	
# Carrega a imagem4 (ALIEN2 - imagem16x16)

IMG4:	li s1,0xFF0087C8	# s1 = endereco inicial da primeira linha do alien 2 - Frame 0
	li s2,0xFF0087D8	# s2 = endereco final da primeira linha do alien 2 - Frame 0
	la s0,Inimigo2          # s0 = endereÃ§o dos dados do alien2
	mv t3, s0		# t3 = endereÃ§o inicial armazenado a fins de comparaÃ§Ã£o
	addi s0,s0,8		# s0 = endereÃ§o do primeiro pixel da imagem (depois das informaÃ§Ãµes de nlin ncol)
	j PRINT16

# Carrega a imagem5 (ALIEN3 - imagem16x16)

IMG5:	li s1,0xFF0087B8	# s1 = endereco inicial da primeira linha do alien 3 - Frame 0
	li s2,0xFF0087C8	# s2 = endereco final da primeira linha do alien 3 - Frame 0
	la s0,Inimigo3          # s0 = endereÃ§o dos dados do alien3
	mv t3, s0		# t3 = endereÃ§o inicial armazenado a fins de comparaÃ§Ã£o
	addi s0,s0,8		# s0 = endereÃ§o do primeiro pixel da imagem (depois das informaÃ§Ãµes de nlin ncol)
	j PRINT16
	
# Carrega a imagem6 (ALIEN4 - imagem16x16)

IMG6:	li s1,0xFF0087D8	# s1 = endereco inicial da primeira linha do alien 4 - Frame 0
	li s2,0xFF0087E8	# s2 = endereco final da primeira linha do alien 4 - Frame 0
	la s0, Inimigo4         # s0 = endereÃ§o dos dados do alien4 
	mv t3, s0		# t3 = endereÃ§o inicial armazenado a fins de comparaÃ§Ã£o
	addi s0,s0,8		# s0 = endereÃ§o do primeiro pixel da imagem (depois das informaÃ§Ãµes de nlin ncol)
	j PRINT16
	
# Carrega a imagem7 (mapa1 - colisao) no frame 1
	
IMG7:	li s1,0xFF100000	# s1 = endereco inicial da Memoria VGA - Frame 1
	li s2,0xFF112C00	# s2 = endereco final da Memoria VGA - Frame 1
	la s0,mapa1colisao	# s0 = endereÃ§o dos dados da colisao do mapa 1
	mv t3, s0		# t3 = endereÃ§o inicial armazenado a fins de comparaÃ§Ã£o
	addi s0,s0,8		# s0 = endereÃ§o do primeiro pixel da imagem (depois das informaÃ§Ãµes de nlin ncol)
	
LOOPCOL:beq s1,s2,SETUP_MAIN	# se s1 = Ãºltimo endereÃ§o da Memoria VGA, saia do loop
	lw t0,0(s0)		# le uma word do endereÃ§o s0 (le 4 pixels da imagem)
	sw t0,0(s1)		# escreve a word na memÃ³ria VGA no endereÃ§o s1 (desenha 4 pixels na tela do Bitmap Display)
	addi s1,s1,4		# soma 4 ao endereÃ§o s1 
	addi s0,s0,4		# soma 4 ao endereÃ§o s0
	j LOOPCOL		# volta a verificar a condiÃ§ao do loop
	
# Compara os endereÃ§os para ver qual a proxima imagem a ser printada

IMAGEM: beq t3, t4, IMG2 	# se t3 contiver o endereÃ§o "mapa1", vÃ¡ para IMG2 (imprime a imagem2)
	
	la t4, Robozinho1	# t4 = endereÃ§o dos dados do Robozinho1
	beq t3, t4, IMG3	# se t3 contiver o endereÃ§o "Robozinho1", vÃ¡ para IMG3 (imprime a imagem3)
	
	la t4, Inimigo1		# t4 = endereÃ§o dos dados do alien 1
	beq t3, t4, IMG4	# se t3 contiver o endereÃ§o "Inimigo1", vÃ¡ para IMG4 (imprime a imagem4)
	
	la t4, Inimigo2		# t4 = endereÃ§o dos dados do alien 2
	beq t3, t4, IMG5	# se t3 contiver o endereÃ§o "Inimigo2", vÃ¡ para IMG5 (imprime a imagem5)
	
	la t4, Inimigo3		# t4 = endereÃ§o dos dados do alien 3
	beq t3, t4, IMG6	# se t3 contiver o endereÃ§o "Inimigo3", vÃ¡ para IMG6 (imprime a imagem6)
	
	la t4, Inimigo4		# t4 = endereÃ§o dos dados do alien 4
	beq t3, t4, IMG7	# se t3 contiver o endereÃ§o "Inimigo4", vÃ¡ para IMG7 (imprime a imagem7)	
	
# Loop que imprime imagens 16x16

PRINT16:li t1,0
	li t2,16		#inicializa o contador de quebra de linha para 16 quebras de linha
	
LOOP2: 	beq s1,s2,ENTER		# se s1 atingir o fim da linha de pixels, quebre linha
	lw t0,0(s0)		# le uma word do endereÃ§o s0 (le 4 pixels da imagem)
	sw t0,0(s1)		# escreve a word na memÃ³ria VGA no endereÃ§o s1 (desenha 4 pixels na tela do Bitmap Display)
	addi s1,s1,4		# soma 4 ao endereÃ§o s1
	addi s0,s0,4		# soma 4 ao endereÃ§o s0
	j LOOP2 		# volta a verificar a condiÃ§ao do loop
	
ENTER:	addi s1,s1,304		# s1 pula para o pixel inicial da linha de baixo
	addi s2,s2,320		# s2 pula para o pixel final da linha de baixo
	addi t1,t1,1          	# atualiza o contador de quebras de linha
	beq t1,t2,IMAGEM	# termina o carregamento da imagem se 17 quebras de linha ocorrerem
	j LOOP2	
	
# Setup dos dados necessarios para o main loop

SETUP_MAIN:

	li s0,2			# s0 = 0 (zera o contador de movimentações do Robozinho)
	li s1,0			# s1 = 0 (zera o contador de pontos coletados)
	li s2,3			# s2 = 3 (inicializa o contador de vidas do Robozinho com 3)
	li s3,0			# s3 = 0 (zera o estado de movimentação atual do Robozinho)
	li s5,0			# s5 = 0 (zera o estado de persrguição dos aliens)
	li s6,1			# s6 = 1 (fase 1)
	li s7,0			# s7 = 0 (zera o verificador de aliens)
	li s4,17		# s4 = 17 (zera o estado de movimentação atual do inimigo1 : chase_mode)
	li s9,17		# s9 = 17 (zera o estado de movimentação atual do inmimigo2 : chase_mode)
	li s10,17 		# s10 = 17 (zera o estado de movimentação atual do inimigo3 : chase_mode)
	li s11,17 		# s11 = 17 (zera o estado de movimentação atual do inimigo4 : chase_mode)
	
# Loop principal do jogo (mostra pontuação na tela e verifica se ha teclas de movimentação pressionadas)

MAINL:
	
ALIENS:
	#formula base para cálculo de posição: (endereço - 0xFF000000)/320 = linha(y), (endereço - 0xFF000000)%320 = coluna(x)
	
# Setup dos dados do alien verde claro (blinky)

BLINKY:	li s7,1			# s7 = 1 (salva em s7 a informação de qual alien esta sendo movimentado)

	la t0,POS_BLINKY	# carrega o endereço de "POS_BLINKY" no registrador t0
	lw t1,0(t0)		# le a word guardada em "POS_BLINKY" para t1 (t1 = posição atual do Blinky)
	
	li t3, 0xFF000000	# t3 = endereço base do Bitmap Display 
	li t4, 320		# t4 = número de colunas da tela
	
	sub t1, t1, t3		# subtrai de t1 o endereço base
	mv t2, t1		# carrega em t2 o valor de t1 (posição do alien sem o endereço base)
	rem t1, t1, t4		# t1 = posição x do alien (coluna do pixel de posição)
	div t2, t2, t4		# t2 = posição y do alien (linha do pixel de posição)
	
	mv a0, t1		# a0 = t1 (parametro da funçao CALCULO_TARGET)
	mv a1, t2		# a1 = t2 (parametro da funçao CALCULO_TARGET)
	mv a2, s4		# a2 = s4 (parametro da funçao CALCULO_TARGET)
	
	jal a7, CALCULO_TARGET 	# Pula para CALCULO_TARGET e guarda o retorno em a7
	
# Setup dos dados do alien azul (pink)

PINK:	li s7,2			# s7 = 2 (salva em s7 a informação de qual alien esta sendo movimentado)

	la t0,POS_PINK		# carrega o endereço de "POS_PINK" no registrador t0
	lw t1,0(t0)		# le a word guardada em "POS_PINK" para t1 (t1 = posição atual do Pink)
	
	li t3, 0xFF000000	# t3 = endereço base do Bitmap Display 
	li t4, 320		# t4 = número de colunas da tela
	
	sub t1, t1, t3		# subtrai de t1 o endereço base
	mv t2, t1		# carrega em t2 o valor de t1 (posição do alien sem o endereço base)
	rem t1, t1, t4		# t1 = posição x do alien (coluna do pixel de posição)
	div t2, t2, t4		# t2 = posição y do alien (linha do pixel de posição)
	
	mv a0, t1		# a0 = t1 (parametro da funçao CALCULO_TARGET)
	mv a1, t2		# a1 = t2 (parametro da funçao CALCULO_TARGET)
	mv a2, s9		# a2 = s4 (parametro da funçao CALCULO_TARGET)
	
	jal a7, CALCULO_TARGET 	# Pula para CALCULO_TARGET e guarda o retorno em a7
	
# Setup dos dados do alien roxo (inky)

INKY:	li s7,3			# s7 = 3 (salva em s7 a informação de qual alien esta sendo movimentado)

	la t0,POS_INKY		# carrega o endereço de "POS_INKY" no registrador t0
	lw t1,0(t0)		# le a word guardada em "POS_INKY" para t1 (t1 = posição atual do Inky)
	
	li t3, 0xFF000000	# t3 = endereço base do Bitmap Display 
	li t4, 320		# t4 = número de colunas da tela
	
	sub t1, t1, t3		# subtrai de t1 o endereço base
	mv t2, t1		# carrega em t2 o valor de t1 (posição do alien sem o endereço base)
	rem t1, t1, t4		# t1 = posição x do alien (coluna do pixel de posição)
	div t2, t2, t4		# t2 = posição y do alien (linha do pixel de posição)
	
	mv a0, t1		# a0 = t1 (parametro da funçao CALCULO_TARGET)
	mv a1, t2		# a1 = t2 (parametro da funçao CALCULO_TARGET)
	mv a2, s10		# a2 = s4 (parametro da funçao CALCULO_TARGET)
	
	
	jal a7, CALCULO_TARGET 	# Pula para CALCULO_TARGET e guarda o retorno em a7
	
# Setup dos dados do alien laranja (clyde)

CLYDE:	li s7,4			# s7 = 4 (salva em s7 a informação de qual alien esta sendo movimentado)

	la t0,POS_CLYDE		# carrega o endereço de "POS_CLYDE" no registrador t0
	lw t1,0(t0)		# le a word guardada em "POS_CLYDE" para t1 (t1 = posição atual do Clyde)
	
	li t3, 0xFF000000	# t3 = endereço base do Bitmap Display 
	li t4, 320		# t4 = número de colunas da tela
	
	sub t1, t1, t3		# subtrai de t1 o endereço base
	mv t2, t1		# carrega em t2 o valor de t1 (posição do alien sem o endereço base)
	rem t1, t1, t4		# t1 = posição x do alien (coluna do pixel de posição)
	div t2, t2, t4		# t2 = posição y do alien (linha do pixel de posição)
	
	mv a0, t1		# a0 = t1 (parametro da funçao CALCULO_TARGET)
	mv a1, t2		# a1 = t2 (parametro da funçao CALCULO_TARGET)
	mv a2, s11		# a2 = s4 (parametro da funçao CALCULO_TARGET)
	
	jal a7, CALCULO_TARGET 	# pula para CALCULO_TARGET e guarda o retorno em a7
	
	li a7,32		# carrega em a7 o serviço 32 do ecall (sleep - interrompe a execução do programa)
	li a0,80		# carrega em a0 o tempo pelo qual o codigo sera interrompido (2 ms)
	ecall			# realiza o ecall
	
	j ROBOZINHO           	# pula para ROBOZINHO (ultimo alien foi movimentado, então o loop dos aliens se encerra)
	
# Função que calcula o target do alien com relação a posição do Robozinho
# Calculo de distancia: distancia de manhattan : (|x_alien - x_target|) + (|y_alien - y_target|)

#dependendo do estado do jogo o fantasma irá para o scatter(Sx < 21), chase(Sx < 38), ou frightened mode(Sx < 55)

CALCULO_TARGET:

	li t0, 179		 	# troca de modos a cada 20 segundos
	rem t1, s0, t0			# t1 = s0%179
	beq t1, zero, TROCAR_MODO  	# se t1 der 0, troca o modo
	
	li t0, 21		 	# t0 = 21
	blt a2, t0, SCATTER_MODE 	# se a2(Sx) < 21, está no scatter mode
	li t0, 38
	blt a2, t0, CHASE_MODE	 	# se a2(Sx) < 38, está no chase mode
	li t0, 55
	blt a2, t0, FRIGHTENED_VERIF	 # se a2(Sx) < 55, está no frightened mode
	li t0, 72
	blt a2, t0, DEATH_MODE		# se a2(Sx) < 72, estã no death mode
	
TROCAR_MODO:

	li t0, 21		 	# t0 = 21
	blt a2, t0, CHASE_MODE   	# se a2(Sx) < 21, está no scatter mode, então vamos para o chase_mode(MUDARDEPOIS)
	li t0, 38
	blt a2, t0, SCATTER_MODE 	# se a2(Sx) < 38, está no chase mode, então vamos para o scatter_mode
	li t0, 58	
	blt a2, t0, FRIGHTENED_VERIF    # se a2(Sx) < 38, está no frightened mode, então não muda
	li t0, 72	
	blt a2, t0, DEATH_MODE		# se a2(Sx) < 72, está no death mode, então não muda
	
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
	
	# registrador da movimentação é menor que 21, então foi para o scatter_mode

	li t0,1				# t0 = 1
	beq s7, t0, BLINKY_SCATTER	# se s7 = 1, então vai para BLINKY_SCATTER
	
	li t0,2				# t0 = 2
	beq s7, t0, PINK_SCATTER	# se s7 = 2, então vai para PINK_SCATTER
	
	li t0,3				# t0 = 3
	beq s7, t0, INKY_SCATTER	# se s7 = 3, então vai para INKY_SCATTER 
	
	li t0,4				# t0 = 4
	beq s7, t0, CLYDE_SCATTER	# se s7 = 4, então vai para CLYDE_SCATTER
	
CHASE_MODE: 
	
	# registrador da movimentação é maior que 21 e menor que 38, então foi para o scatter_mode

	li t0,1				# t0 = 1
	beq s7, t0, BLINKY_CHASE	# se s7 = 1, então vai para BLINKY_CHASE
	
	li t0,2				# t0 = 2
	beq s7, t0, PINK_CHASE		# se s7 = 2, então vai para PINK_CHASE
	
	li t0,3				# t0 = 3
	beq s7, t0, INKY_CHASE		# se s7 = 3, então vai para INKY_CHASE
	
	li t0,4				# t0 = 4
	beq s7, t0, CLYDE_CHASE		# se s7 = 4, então vai para CLYDE_CHASE

FRIGHTENED_MODE:
	
	# registrador da movimentação é maior que 38 e menor que 55, então foi para o frightened_mode
		
	addi t1, t1, 1			# adiciona 1 ao contador
	sw t1, 0(t0)			# atualiza o valor de CONTADOR_ASSUSTADO
	
	li t0,1				# t0 = 1
	beq s7, t0, BLINKY_FRIGHTENED	# se s7 = 1, então vai para BLINKY_CHASE
	
	li t0,2				# t0 = 2
	beq s7, t0, PINK_FRIGHTENED	# se s7 = 2, então vai para PINK_CHASE
	
	li t0,3				# t0 = 3
	beq s7, t0, INKY_FRIGHTENED	# se s7 = 3, então vai para INKY_CHASE
	
	li t0,4				# t0 = 4
	beq s7, t0, CLYDE_FRIGHTENED	# se s7 = 4, então vai para CLYDE_CHASE
	
DEATH_MODE:

	li t0,1				# t0 = 1
	beq s7, t0, BLINKY_DEATH	# se s7 = 1, então vai para BLINKY_CHASE
	
	li t0,2				# t0 = 2
	beq s7, t0, PINK_DEATH		# se s7 = 2, então vai para PINK_CHASE
	
	li t0,3				# t0 = 3
	beq s7, t0, INKY_DEATH		# se s7 = 3, então vai para INKY_CHASE
	
	li t0,4				# t0 = 4
	beq s7, t0, CLYDE_DEATH		# se s7 = 4, então vai para CLYDE_CHASE
	
	
# parametros necessarios:
# t4: endereço do target
# t6 : estado de movimentação atual do alien
# a4 : posição hexa do alien
# a6 : label do inimigo	

# Inicializa os dados do alien a ser movimentado (blinky) 
	
BLINKY_SCATTER:			# target: canto superior direito
	
	li t4, 0xFF00013F	# t4 = endereço do target do Blinky
	mv t6, s4		# t6 = movimentação do alien no presente
	li s4, 17		# volta s4 para 17(a movimentação já esta guardada em t6 e o calculo irá adicionar em s4 posteriormente)
	
	la t0,POS_BLINKY	# carrega o endereço de "POS_BLINKY" no registrador t0
	lw a4,0(t0)		# le a word guardada em "POS_BLINKY" para a4 (a4 = posição atual do Blinky)
	
	la a6, Inimigo1		# a6 = label da imagem a ser impressa (parametro da função de movimentação)
	j SETUP_TARGET		# pula para o setup do scatter_mode
	
BLINKY_CHASE:			# target: robozinho
	
	la t0,POS_ROBOZINHO	# carrega o endereço de "POS_ROBOZINHO" no registrador t0
	lw t1,0(t0)		# le a word guardada em "POS_ROBOZINHO" para t1 (t1 = posição atual do Robozinho)
	
	mv t4, t1		# t4 = endereço do target do Blinky(robozinho)	
	mv t6, s4		# t6 = movimentação do alien no presente
	li s4, 34		# volta s4 para 34(a movimentação já esta guardada em t6 e o calculo irá adicionar em s4 posteriormente)	
	
	la t0,POS_BLINKY	# carrega o endereço de "POS_BLINKY" no registrador t0
	lw a4,0(t0)		# le a word guardada em "POS_BLINKY" para a4 (a4 = posição atual do Blinky)
	
	la a6, Inimigo1		# a6 = label da imagem a ser impressa (parametro da função de movimentação)
	j SETUP_TARGET		# pula para o setup do scatter_mode
	
BLINKY_FRIGHTENED:		# target: aleatório(exceto no primeiro movimento que inverte a direção do alien)

	la t0,POS_BLINKY	# carrega o endereço de "POS_BLINKY" no registrador t0
	lw a4,0(t0)		# le a word guardada em "POS_BLINKY" para a4 (a4 = posição atual do Blinky)
	
	mv t4, a4		# t4 = a4(endereço futuro do target)		

	li t0, 179		# t0 = 179
	rem t1, s0, t0		# t1 = s0%179
	beq t1, zero, INVERTE_B	# se esta no primeiro segundo do movimento, inverte a direção do alien, se não, ve um movimento aleatório para ele
	
	li t0, 823		# t0 = 823(numero grande primo)
	mul t0, s0, t0		# t0 = s0*t0
	li t1, 4		# t1 = 4
	rem t1, t0, t1		# t1 = t0%t1
	
	li t0, 0		# t0 = 0(up)
	beq t1, t0, UP_BLINKY # se t1 = 0, então o blinky vai pra cima
	addi t0, t0, 1		# t0 = 1(left)
	beq t1, t0, ESQ_BLINKY  # se t1 = 1, então o blinky vai pra esquerda
	addi t0, t0, 1		# t0 = 2(down)
	beq t1, t0, DOWN_BLINKY   # se t1 = 2, então o blinky vai pra baixo
	addi t0, t0, 1		# t0 = 3(right)
	beq t1, t0, DIR_BLINKY   # se t1 = 3, então o blinky vai pra direita	
	
INVERTE_B:
	li t0, 17		# t0 = 17
	rem t1,s4, t0		# t1 = s4%17
	li t0, 0		# t0 = 0(up)
	beq t1, t0, DOWN_BLINKY # se t1 = 0, então o blinky está indo pra cima, logo ele inverte e va pra baixo(DOWN_BLINKY)
	addi t0, t0, 1		# t0 = 1(left)
	beq t1, t0, DIR_BLINKY  # se t1 = 1, então o blinky está indo pra esquerda, logo ele inverte e va pra baixo(DIR_BLINKY)
	addi t0, t0, 1		# t0 = 2(down)
	beq t1, t0, UP_BLINKY   # se t1 = 2, então o blinky está indo pra baixo, logo ele inverte e va pra baixo(UP_BLINKY)
	addi t0, t0, 1		# t0 = 3(right)
	beq t1, t0, UP_BLINKY   # se t1 = 3, então o blinky está indo pra direita, logo ele inverte e va pra baixo(ESQ_BLINKY)

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

	la a6, InimigoAssustado	# a6 = label da imagem a ser impressa (parametro da função de movimentação)
	mv t6, s4		# t6 = movimentação do alien no presente
	li s4, 51		# volta s4 para 51(a movimentação já esta guardada em t6 e o calculo irá adicionar em s4 posteriormente)
	
	j SETUP_TARGET		
	
BLINKY_DEATH: 			# target: dentro da caixa
	
	li t4, 0xFF009BC8	# t4 = endereço do target do Blinky(caixa)
	mv t6, s4		# t6 = movimentação do alien no presente
	li s4, 68		# volta s4 para 68(a movimentação já esta guardada em t6 e o calculo irá adicionar em s4 posteriormente)
	
	la t0,POS_BLINKY	# carrega o endereço de "POS_BLINKY" no registrador t0
	lw a4,0(t0)		# le a word guardada em "POS_BLINKY" para a4 (a4 = posição atual do Blinky)
	
	la a6, Inimigo1		# a6 = label da imagem a ser impressa (parametro da função de movimentação)
	j SETUP_TARGET		# pula para o setup do scatter_mode
	
# Inicializa os dados do alien a ser movimentado (pinky) 
	
PINK_SCATTER:			# target: canto superior esquerdo
	
	li t4, 0xFF000000	# t4 = endereço do target do Pink 
	mv t6, s9		# t6 = movimentação do alien no presente
	li s9, 17		# volta s9 para 17(a movimentação já esta guardada em t6 e o calculo irá adicionar em s9 posteriormente)
	
	la t0,POS_PINK		# carrega o endereço de "POS_PINK" no registrador t0
	lw a4,0(t0)		# le a word guardada em "POS_PINK" para t1 (t1 = posição atual do Pink)
	
	la a6, Inimigo2		# a6 = label da imagem a ser impressa (parametro da função de movimentação)
	
	j SETUP_TARGET		# pula para o setup do scatter_mode
	
PINK_CHASE:			# target: frente do robozinho (s3 = 1  esq) (s3 = 2 cima/esquerda) (s3 = 3 baixo) (s3 = 4  dir) s3 = 0 não há movimento
	
	la t0,POS_ROBOZINHO	# carrega o endereço de "POS_ROBOZINHO" no registrador t0
	lw t1,0(t0)		# le a word guardada em "POS_ROBOZINHO" para t1 (t1 = posição atual do Robozinho)
	
	li t0, 1
	beq s3, t0, ADD_ESQ	# s3 = 1, entao o robozinho esta indo para a esquerda
	li t0, 2
	beq s3, t0, ADD_CIMA	# s3 = 2, entao o robozinho esta indo para cima
	li t0, 3
	beq s3, t0, ADD_BAIXO	# s3 = 3, entao o robozinho esta indo para baixo
	li t0, 4
	beq s3, t0, ADD_DIR	# s3 = 4, entao o robozinho esta indo para a direita
	
	jal CONT_PINK		# se o robozinho nao esta se movendo, ele vai diretamente até a posição dele

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
	
	li t0, 0xFF000000	# t1 = endereço minimo 0xFF000000
	blt t1, t0, FORA_MEM_P	# se o endereço for para fora da memoria(ser menor que 0xff000000), então o PINK se aproxima do ROBOZINHO
	li t0, 0xFF012BFF	# t1 = endereço máximo 0xFF012BFF
	bge t1, t0, FORA_MEM_P	# se o endereço for para fora da memoria(ser maior que 0xff012bff), então o PINK se aproxima do ROBOZINHO
	j CONT_2_PINK		# pula para a continuação do código caso o endereço esteja dentro da memória
	
FORA_MEM_P:
	
	la t0,POS_ROBOZINHO	# carrega o endereço de "POS_ROBOZINHO" no registrador t0
	lw t1,0(t0)		# le a word guardada em "POS_ROBOZINHO" para t1 (t1 = posição atual do Robozinho)
	
CONT_2_PINK:

	mv t4, t1
	mv t6, s9		# t6 = movimentação do alien no presente
	li s9, 34		# volta s9 para 34(a movimentação já esta guardada em t6 e o calculo irá adicionar em s9 posteriormente)
	
	la t0,POS_PINK		# carrega o endereço de "POS_PINK" no registrador t0
	lw a4,0(t0)		# le a word guardada em "POS_PINK" para a4 (t0 = posição atual do Pink)
	
	la a6, Inimigo2		# a6 = label da imagem a ser impressa (parametro da função de movimentação)
	
	j SETUP_TARGET		# pula para o setup do scatter_mode
	
PINK_FRIGHTENED:		# target: aleatório(exceto no primeiro movimento que inverte a direção do alien)

	la t0,POS_PINK		# carrega o endereço de "POS_PINK" no registrador t0
	lw a4,0(t0)		# le a word guardada em "POS_PINK" para a4 (a4 = posição atual do PINK)
	
	mv t4, a4		# t4 = a4(endereço futuro do target)		

	li t0, 179		# t0 = 179
	rem t1, s0, t0		# t1 = s0%179
	beq t1, zero, INVERTE_P	# se esta no primeiro segundo do movimento, inverte a direção do alien, se não, ve um movimento aleatório para ele
	
	li t0, 821		# t0 = 821(numero grande primo)
	mul t0, s0, t0		# t0 = s0*t0
	li t1, 4		# t1 = 4
	rem t1, t0, t1		# t1 = t0%t1
	
	li t0, 0		# t0 = 0(up)
	beq t1, t0, UP_PINK 	# se t1 = 0, então o pink vai pra cima
	addi t0, t0, 1		# t0 = 1(left)
	beq t1, t0, ESQ_PINK    # se t1 = 1, então o pink vai pra esquerda
	addi t0, t0, 1		# t0 = 2(down)
	beq t1, t0, DOWN_PINK   # se t1 = 2, então o pink vai pra baixo
	addi t0, t0, 1		# t0 = 3(right)
	beq t1, t0, DIR_PINK    # se t1 = 3, então o pink vai pra direita	
	
INVERTE_P:
	li t0, 17		# t0 = 17
	rem t1, s9, t0		# t1 = s9%17
	li t0, 0		# t0 = 0(up)
	beq t1, t0, DOWN_PINK # se t1 = 0, então o pink está indo pra cima, logo ele inverte e va pra baixo(DOWN_PINK)
	addi t0, t0, 1		# t0 = 1(left)
	beq t1, t0, DIR_PINK  # se t1 = 1, então o pink está indo pra esquerda, logo ele inverte e va pra baixo(DIR_PINK)
	addi t0, t0, 1		# t0 = 2(down)
	beq t1, t0, UP_PINK   # se t1 = 2, então o pink está indo pra baixo, logo ele inverte e va pra baixo(UP_PINK)
	addi t0, t0, 1		# t0 = 3(right)
	beq t1, t0, ESQ_PINK   # se t1 = 3, então o pink está indo pra direita, logo ele inverte e va pra baixo(ESQ_PINK)

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

	la a6, InimigoAssustado	# a6 = label da imagem a ser impressa (parametro da função de movimentação)
	mv t6, s9		# t6 = movimentação do alien no presente
	li s9, 51		# volta s4 para 51(a movimentação já esta guardada em t6 e o calculo irá adicionar em s4 posteriormente)
	
	j SETUP_TARGET	
	
PINK_DEATH:			# target: dentro da caixa
	
	li t4, 0xFF009BC8	# t4 = endereço do target do Pink(caixa) 
	mv t6, s9		# t6 = movimentação do alien no presente
	li s9, 68		# volta s9 para 68(a movimentação já esta guardada em t6 e o calculo irá adicionar em s9 posteriormente)
	
	la t0,POS_PINK		# carrega o endereço de "POS_PINK" no registrador t0
	lw a4,0(t0)		# le a word guardada em "POS_PINK" para t1 (t1 = posição atual do Pink)
	
	la a6, Inimigo2		# a6 = label da imagem a ser impressa (parametro da função de movimentação)
	
	j SETUP_TARGET		# pula para o setup do scatter_mode	
	
# Inicializa os dados do alien a ser movimentado (inky) 

INKY_SCATTER:			# target : canto inferior direito
	
	li t4, 0xFF012BFF	# t4 = endereço do target do Inky 
	mv t6, s10		# t6 = movimentação do alien no presente
	li s10, 17		# volta s10 para 17(a movimentação já esta guardada em t6 e o calculo irá adicionar em s10 posteriormente)
	
	la t0,POS_INKY		# carrega o endereço de "POS_INKY" no registrador t0
	lw a4,0(t0)		# le a word guardada em "POS_INKY" para t1 (t1 = posição atual do Inky)
	
	la a6, Inimigo3		# a6 = label da imagem a ser impressa (parametro da função de movimentação)
	
	j SETUP_TARGET		# pula para o setup do scatter_mode
	
INKY_CHASE:			# target : "cerca" o robozinho baseado na posição do blinky 		
	
	# t1: x robo t2: y robo t3: x blinky t4: y blinky
	
	la t0,POS_ROBOZINHO	# carrega o endereço de "POS_ROBOZINHO" no registrador t0
	lw t1,0(t0)		# le a word guardada em "POS_ROBOZINHO" para t1 (t1 = posição atual do Robozinho
	la t0,POS_BLINKY	# carrega o endereço de "POS_POS_BLINKY no registrador t0
	lw t3, 0(t0)		# le a word guardada em "POS_BLINKY" para t3 (t3 = posição atual do BLINKY)
	
	mv t0, t1		# guarda em t0 o endereço hexa do robozinho
	
	li t6, 0xFF000000	# t1 = endereço base do Bitmap Display
	li t5, 320		# t2 = numero de colunas da tela
	
	sub t1, t1, t6		# subtrai de t1 o endereço base
	mv t2, t1		# carrega em t2 o valor de t1 (posição do target sem o endereço base)
	rem t1, t1, t5 		# t1 = posição x do robo (coluna do pixel de posição)
	div t2, t2, t5		# t2 = posição y do robo (coluna do pixel de posição)
	
	sub t3, t3, t6		# subtrai de t3 o endereço base
	mv t4, t3		# carrega em t4 o valor de t3 (posição do target sem o endereço base)
	rem t3, t3, t5 		# t3 = posição x do alien (coluna do pixel de posição)
	div t4, t4, t5		# t4 = posição y do alien (coluna do pixel de posição)
	
	sub t5, t1, t3		# t5 = variação da posição X entre o robo(t1) e o alien(t3)
	neg t5, t5 		# inverte o vetor X que liga o Blinky ao robo

	sub t6, t2, t4		# t6 = variação da posição Y entre o robo(t2) e o alien(t4)
	neg t6, t6		# inverte o vetor Y que liga o Blinky ao robo
	
	add t0, t0, t5		# adiciona ao endereço base a coluna 
	li t1, 5120		# t1 = 5120(320*16)
	mul t6, t6, t1		# multiplica a quantidade de linhas abaixo/acima por 5120
	add t0, t0, t6		# adiciona ao endereço base a linha
	
	li t1, 0xFF000000	# t1 = endereço minimo 0xFF000000
	blt t0, t1, FORA_MEM	# se o endereço for para fora da memoria(ser menor que 0xff000000), então o INKY se aproxima do BLINKY
	li t1, 0xFF012BFF	# t1 = endereço máximo 
	bge t0, t1, FORA_MEM	# se o endereço for para fora da memoria(ser maior que 0xff012bff), então o INKY se aproxima do BLINKY
	
	mv t4, t0		# t4 = endereço do target do Inky	
	mv t6, s10		# t6 = movimentação do alien no presente
	li s10, 34		# volta s10 para 34(a movimentação já esta guardada em t6 e o calculo irá adicionar em s10 posteriormente)
	
	la t0,POS_INKY		# carrega o endereço de "POS_INKY" no registrador t0
	lw a4,0(t0)		# le a word guardada em "POS_INKY" para t1 (t1 = posição atual do Inky)
	
	la a6, Inimigo3		# a6 = label da imagem a ser impressa (parametro da função de movimentação)
	
	j SETUP_TARGET		# pula para o setup do scatter_mode
	
 FORA_MEM:
 
 	la t0,POS_BLINKY	# carrega o endereço de "POS_ROBOZINHO" no registrador t0
	lw t1,0(t0)		# le a word guardada em "POS_ROBOZINHO" para t1 (t1 = posição atual do Robozinho)
	
	mv t4, t1		# t4 = endereço do target do Blinky(robozinho) 	
	mv t6, s10		# t6 = movimentação do alien no presente
	li s10, 34		# volta s10 para 34(a movimentação já esta guardada em t6 e o calculo irá adicionar em s10 posteriormente)
	
	la t0,POS_INKY		# carrega o endereço de "POS_INKY" no registrador t0
	lw a4,0(t0)		# le a word guardada em "POS_INKY" para t1 (t1 = posição atual do Inky)
	
	la a6, Inimigo3		# a6 = label da imagem a ser impressa (parametro da função de movimentação)
	
	j SETUP_TARGET		# pula para o setup do scatter_mode
	
INKY_FRIGHTENED:		# target: aleatório(exceto no primeiro movimento que inverte a direção do alien)

	la t0,POS_INKY		# carrega o endereço de "POS_INKY" no registrador t0
	lw a4,0(t0)		# le a word guardada em "POS_INKY" para a4 (a4 = posição atual do INKY)
	
	mv t4, a4		# t4 = a4(endereço futuro do target)		

	li t0, 179		# t0 = 179
	rem t1, s0, t0		# t1 = so%179
	beq t1, zero, INVERTE_I	# se esta no primeiro segundo do movimento, inverte a direção do alien, se não, ve um movimento aleatório para ele
	
	li t0, 811		# t0 = 811(numero grande primo)
	mul t0, s0, t0		# t0 = s0*t0
	li t1, 4		# t1 = 4
	rem t1, t0, t1		# t1 = t0%t1
	
	li t0, 0		# t0 = 0(up)
	beq t1, t0, UP_INKY 	# se t1 = 0, então o inky vai pra cima
	addi t0, t0, 1		# t0 = 1(left)
	beq t1, t0, ESQ_INKY    # se t1 = 1, então o inky vai pra esquerda
	addi t0, t0, 1		# t0 = 2(down)
	beq t1, t0, DOWN_INKY   # se t1 = 2, então o inky vai pra baixo
	addi t0, t0, 1		# t0 = 3(right)
	beq t1, t0, DIR_INKY    # se t1 = 3, então o inky vai pra direita	
	
INVERTE_I:
	li t0, 17		# t0 = 17
	rem t1,s10, t0		# t1 = s10%17
	li t0, 0		# t0 = 0(up)
	beq t1, t0, DOWN_INKY   # se t1 = 0, então o inky está indo pra cima, logo ele inverte e va pra baixo(DOWN_INKY)
	addi t0, t0, 1		# t0 = 1(left)
	beq t1, t0, DIR_INKY    # se t1 = 1, então o inky está indo pra esquerda, logo ele inverte e va pra baixo(DIR_INKY)
	addi t0, t0, 1		# t0 = 2(down)
	beq t1, t0, UP_INKY     # se t1 = 2, então o inky está indo pra baixo, logo ele inverte e va pra baixo(UP_INKY)
	addi t0, t0, 1		# t0 = 3(right)
	beq t1, t0, ESQ_INKY     # se t1 = 3, então o inky está indo pra direita, logo ele inverte e va pra baixo(ESQ_INKY)

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

	la a6, InimigoAssustado	# a6 = label da imagem a ser impressa (parametro da função de movimentação)
	mv t6, s10		# t6 = movimentação do alien no presente
	li s10, 51		# volta s4 para 51(a movimentação já esta guardada em t6 e o calculo irá adicionar em s4 posteriormente)
	
	j SETUP_TARGET		
	
INKY_DEATH:			# target : dentro da caixa
	
	li t4, 0xFF009BC8	# t4 = endereço do target do Inky(caixa)
	mv t6, s10		# t6 = movimentação do alien no presente
	li s10, 68		# volta s10 para 68(a movimentação já esta guardada em t6 e o calculo irá adicionar em s10 posteriormente)
	
	la t0,POS_INKY		# carrega o endereço de "POS_INKY" no registrador t0
	lw a4,0(t0)		# le a word guardada em "POS_INKY" para t1 (t1 = posição atual do Inky)
	
	la a6, Inimigo3		# a6 = label da imagem a ser impressa (parametro da função de movimentação)
	
	j SETUP_TARGET		# pula para o setup do scatter_mode
	
# Inicializa os dados do alien a ser movimentado (clyde)
	
CLYDE_SCATTER:			# target: canto inferior esquerdo

	li t4, 0xFF012B40	# t4 = endereço do target do Clyde
	mv t6, s11		# t6 = movimentação do alien no presente
	li s11, 17		# volta s11 para 17(a movimentação já esta guardada em t6 e o calculo irá adicionar em s11 posteriormente)
	
	la t0,POS_CLYDE		# carrega o endereço de "POS_CLYDE" no registrador t0
	lw a4,0(t0)		# le a word guardada em "POS_CLYDE" para t1 (t1 = posição atual do Clyde)
	
	la a6, Inimigo4		# a6 = label da imagem a ser impressa (parametro da função de movimentação)
	
	j SETUP_TARGET		# pula para o setup do scatter_mode

CLYDE_CHASE:			# target: pac-man, quando chega perto de certo range escolhe uma direção aleatoria

	la t0,POS_ROBOZINHO	# carrega o endereço de "POS_ROBOZINHO" no registrador t0
	lw t1,0(t0)		# le a word guardada em "POS_ROBOZINHO" para t1 (t1 = posição atual do Robozinho
	
	li t6, 0xFF000000	# t1 = endereço base do Bitmap Display
	li t5, 320		# t2 = numero de colunas da tela
	
	sub t1, t1, t6		# subtrai de t1 o endereço base
	mv t2, t1		# carrega em t2 o valor de t1 (posição do target sem o endereço base)
	rem t1, t1, t5 		# t1 = posição x do robo (coluna do pixel de posição)
	div t2, t2, t5		# t2 = posição y do robo (coluna do pixel de posição)
	
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
	blt t1, t0, RANDOM	# se o clyde está próximo do robozinho, ele assume um movimento aleatório, se nao, ele vai atras do robozinho
	
	la t0,POS_ROBOZINHO	# carrega o endereço de "POS_ROBOZINHO" no registrador t0
	lw t1,0(t0)		# le a word guardada em "POS_ROBOZINHO" para t1 (t1 = posição atual do Robozinho)
	
	mv t4, t1		# t4 = endereço do target do Clyde(robozinho)
	mv t6, s11		# t6 = movimentação do alien no presente
	li s11, 34		# volta s11 para 34(a movimentação já esta guardada em t6 e o calculo irá adicionar em s11 posteriormente)
	
	la t0,POS_CLYDE		# carrega o endereço de "POS_CLYDE" no registrador t0
	lw a4,0(t0)		# le a word guardada em "POS_CLYDE" para t1 (t1 = posição atual do Clyde)
	
	la a6, Inimigo4		# a6 = label da imagem a ser impressa (parametro da função de movimentação)
	
	j SETUP_TARGET		# pula para o setup do scatter_mode
							
RANDOM:
	mv t4, a4		# guarda em t4 a posição atual do clyde
	
	mv t0, s0		# pega um numero aleatorio(contador)
	li t2, 4		# t2 = 4
	rem t1, t0, t2		# pega o resto pela divisao por 4 e armazena em t1
	
	li t0, 0
	beq t0, t1, TARGET_UP  	# se o resto der igual a 0, pega como target logo acima dele
	addi t0, t0, 1		# adiciona 1 em t0
	beq t0, t1, TARGET_L  	# se o resto der igual a 0, pega como target logo à esquerda dele
	addi t0, t0, 1		# adiciona 1 em t0
	beq t0, t1, TARGET_DW  	# se o resto der igual a 0, pega como target logo abaixo dele
	addi t0, t0, 1		# adiciona 1 em t0
	beq t0, t1, TARGET_R  	# se o resto der igual a 0, pega como target logo à direita dele
	
TARGET_UP:
	li t0, 5120		
	sub t4, t4, t0          # t4 = endereço do target target logo acima dele
	jal SETUP_RANDOM
TARGET_L:
	addi t4, t4, -16	# t4 = endereço do target logo à esquerda dele 
	jal SETUP_RANDOM
TARGET_DW:
	li t0, 5120		
	add t4, t4, t0          # t4 = endereço do target target logo acima dele
	jal SETUP_RANDOM
TARGET_R:
	addi t4, t4, 16		# t4 = endereço do target logo à direita dele

SETUP_RANDOM:

	mv t6, s11		# t6 = movimentação do alien no presente
	li s11, 34		# volta s11 para 34(a movimentação já esta guardada em t6 e o calculo irá adicionar em s11 posteriormente)
	
	la t0,POS_CLYDE		# carrega o endereço de "POS_CLYDE" no registrador t0
	lw a4,0(t0)		# le a word guardada em "POS_CLYDE" para t1 (t1 = posição atual do Clyde)
	
	la a6, Inimigo4		# a6 = label da imagem a ser impressa (parametro da função de movimentação)
	j SETUP_TARGET		# pula para o setup do scatter_mode
	
CLYDE_FRIGHTENED:		# target: aleatório(exceto no primeiro movimento que inverte a direção do alien)

	la t0,POS_CLYDE		# carrega o endereço de "POS_CLYDE" no registrador t0
	lw a4,0(t0)		# le a word guardada em "POS_CLYDE" para a4 (a4 = posição atual do CLYDE)
	
	mv t4, a4		# t4 = a4(endereço futuro do target)		

	li t0, 179		# t0 = 179
	rem t1, s0, t0		# t1 = so%179
	beq t1, zero, INVERTE_C	# se esta no primeiro segundo do movimento, inverte a direção do alien, se não, ve um movimento aleatório para ele
	
	li t0, 811		# t0 = 809(numero grande primo)
	mul t0, s0, t0		# t0 = s0*t0
	li t1, 4		# t1 = 4
	rem t1, t0, t1		# t1 = t0%t1
	
	li t0, 0		# t0 = 0(up)
	beq t1, t0, UP_CLYDE 	# se t1 = 0, então o clyde vai pra cima
	addi t0, t0, 1		# t0 = 1(left)
	beq t1, t0, ESQ_CLYDE   # se t1 = 1, então o clyde vai pra esquerda
	addi t0, t0, 1		# t0 = 2(down)
	beq t1, t0, DOWN_CLYDE  # se t1 = 2, então o clyde vai pra baixo
	addi t0, t0, 1		# t0 = 3(right)
	beq t1, t0, DIR_CLYDE   # se t1 = 3, então o clyde vai pra direita	
	
INVERTE_C:
	li t0, 17		# t0 = 17
	rem t1,s11, t0		# t1 = s11%17
	li t0, 0		# t0 = 0(up)
	beq t1, t0, DOWN_CLYDE  # se t1 = 0, então o clyde está indo pra cima, logo ele inverte e va pra baixo(DOWN_CLYDE)
	addi t0, t0, 1		# t0 = 1(left)
	beq t1, t0, DIR_CLYDE   # se t1 = 1, então o clyde está indo pra esquerda, logo ele inverte e va pra baixo(DIR_CLYDE)
	addi t0, t0, 1		# t0 = 2(down)
	beq t1, t0, UP_CLYDE    # se t1 = 2, então o clyde está indo pra baixo, logo ele inverte e va pra baixo(UP_CLYDE)
	addi t0, t0, 1		# t0 = 3(right)
	beq t1, t0, ESQ_CLYDE   # se t1 = 3, então o clyde está indo pra direita, logo ele inverte e va pra baixo(ESQ_CLYDE)

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

	la a6, InimigoAssustado	# a6 = label da imagem a ser impressa (parametro da função de movimentação)
	mv t6, s11		# t6 = movimentação do alien no presente
	li s11, 51		# volta s4 para 51(a movimentação já esta guardada em t6 e o calculo irá adicionar em s4 posteriormente)
	j SETUP_TARGET
	
CLYDE_DEATH:			# target: dentro da caixa

	li t4, 0xFF009BC8	# t4 = endereço do target do Clyde(caixa)
	mv t6, s11		# t6 = movimentação do alien no presente
	li s11, 68		# volta s11 para 68(a movimentação já esta guardada em t6 e o calculo irá adicionar em s11 posteriormente)
	
	la t0,POS_CLYDE		# carrega o endereço de "POS_CLYDE" no registrador t0
	lw a4,0(t0)		# le a word guardada em "POS_CLYDE" para t1 (t1 = posição atual do Clyde)
	
	la a6, Inimigo4		# a6 = label da imagem a ser impressa (parametro da função de movimentação)
	
# Inicializa os dados para o scatter mode, no qual sera calculado o caminho mais curto ate o target (|a0 - t4| + |a1 - t5|) = (|x_alien - x_target|) + (|y_alien - y_target|)

# Função que calcula o target do alien com relação a posição do Robozinho
# Calculo de distancia: distancia de manhattan : (|x_alien - x_target|) + (|y_alien - y_target|)
# t4: endereço do target
# t6 : estado de movimentação atual do alien
# a0 : endereço x do alien
# a1 : endereço y do alien
# a4 : posição hexa do alien
# a6 : label do inimigo	
	
SETUP_TARGET:

	li t5, 17		# t5 = 17
	rem t6, t6, t5		# t6 = resto de t6 por 17(t6 guardava a movimentação do alien antes de resetar para 17/34/51 e agora está setado para 0,1,2 ou 3)

	li t1, 0xFF000000	# t1 = endereço base do Bitmap Display 
	li t2, 320		# t2 = numero de colunas da tela
	
	sub t4, t4, t1		# subtrai de t4 o endereço base
	mv t5, t4		# carrega em t5 o valor de t4 (posição do target sem o endereço base)
	rem t4, t4, t2 		# t4 = posição x do target (coluna do pixel de posição)
	div t5, t5, t2		# t5 = posição y do target (coluna do pixel de posição)
	
	addi a1, a1, -4		# a1 = posição y do alien 4 linhas acima
	jal ra, LOOP_TARGET	# calcula a distancia de manhattan entre o target e a direção de cima do alien e retorna em a2
	mv t0, a2		# guarda em t0 a distancia entre target e a posição acima do alien
	
	addi a1, a1, 4		# volta a1 para a posição original
	addi a0, a0, -4 	# a0 = posição x do alien 4 colunas a esquerda
	jal ra, LOOP_TARGET	# calcula a distancia de manhattan entre o target e a direção esquerda do alien e retorna em a2
	mv t1, a2		# guarda em t1 a distancia entre target e a posição a esquerda do alien
	
	addi a0, a0, 4		# volta a0 para a posição original
	addi a1, a1, 4		# a1 = posição y do alien 4 linhas abaixo
	jal ra, LOOP_TARGET	# calcula a distancia de manhattan entre o target e a direção esquerda do alien e retorna em a2
	mv t2, a2		# guarda em t2 a distancia entre target e a posição abaixo do alien
	
	addi a1, a1, -4		# volta a1 para a posição original
	addi a0, a0, 4 		# a0 = posição x do alien 4 colunas a direita
	jal ra, LOOP_TARGET 	# calcula a distancia de manhattan entre o target e a direção esquerda do alien e retorna em a2
	mv t3, a2		# guarda em t1 a distancia entre target e a posição a direita do alien
	
	addi a0, a0, -4		# volta a0 para a posição original
	
	la t5, CONTADOR_ASSUSTADO	# le o CONTADOR_ASSUSTADO
	lw t4, 0(t5)		# carrega em t4 o valor do CONTADOR_ASSUSTADO 
	
	li t5, 0		# t5 = 0(primeiro loop do blinky no frightened mode)
	bge t4, t5, VERIF_MODE	# se ele estiver no modo assustado, verifica se ele está em um dos primeiros ticks do fantasma no modo assustado
	j CONT_TARGET
	
VERIF_MODE:
	li t5, 4		# te = 4(proximo tick do primeiro alien)
	blt t4, t5, MENOR	# se sim, então ele pode virar 180 graus
	
CONT_TARGET:
	
#	li t4, 116		# verifica se o alien está dentro da caixa(caso esteja, ele nao pode ir para baixo)
#	beq a1, t4, VERIF_MOV1  # se ele estiver na linha da caixa, vamos ver se ele está entre as colunas
	
	li t4, 96		#verifica se o alien está logo em cima da caixa(caso esteja, ele nao pode ir para cima)
	beq a1, t4, VERIF_MOV2  # se ele estiver na linha da caixa, vamos ver se ele está entre as colunas
		
	jal VERIF_MOV
	
#VERIF_MOV1:
#	li t4, 216		# borda direita da caixa(200 + 16)
#	li t5, 184		# borda esquerda da caixa(200 - 16)
#	bge a0, t4, VERIF_MOV	# se a0 está na esquerda da borda esquerda, nao esta dentro da caixa
#	blt a0, t5, VERIF_MOV	# se a0 está na direita da borda direita, nao esta dentro da caixa
	
#	li t2, 560		# carrega em t2 um valor grande para ele nao ir para baixo
#	jal VERIF_MOV		# pula para verificar o movimento
	
VERIF_MOV2:
	li t4, 216		# borda direita da caixa(200 + 16)
	li t5, 184		# borda esquerda da caixa(200 - 16)
	bge a0, t4, VERIF_MOV	# se a0 está na esquerda da borda esquerda, nao esta dentro da parte de cima da caixa
	blt a0, t5, VERIF_MOV	# se a0 está na direita da borda esquerda, nao esta dentro da parte de cima da caixa
	
	li t0, 560		# carrega em t0 um valor grande epara ele nao ir para cima
	li t2, 560		# carrega em t2 um valor grande para ele nao ir para baixo
	
VERIF_MOV:
	
	li t4, 0		# t4 = 0 significa que o alien está andando para cima		
	beq t6, t4, N_BAIXO	# logo ele não pode ir pra baixo
	addi t4, t4, 1		# t4 = 1 significa que o alien está andando para a esquerda	
	beq t6, t4, N_DIREITA   # logo ele não pode ir pra a direita
	addi t4, t4, 1		# t4 = 2 significa que o alien está andando para baixo
	beq t6, t4, N_CIMA	# logo ele não pode ir pra cima
	addi t4, t4, 1		# t4 = 3 significa que o alien está andando para a direita
	beq t6, t4, N_ESQUERDA  # logo ele não pode ir pra a esquerda
	
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
	
# Calcula a distância de cada posição relativa do alien até o target

LOOP_TARGET:

	sub a2, a0, t4		# a2 = a0 - t4 (a2 = x_alien - x_target)
	bge a2, zero, CONT	# se a2 for positivo, vai para o calculo da subtração entre "y_alien" e "y_target"
	neg a2, a2		# calcula o módulo do resultado caso a subtração entre "x_alien" e "x_target" seja menor que zero
	
CONT:	sub a3, a1, t5		# a3 = a1 - t5 (a3 = y_alien - y_target)	
	bge a3, zero, CONT2	# se a3 for positivo, vai para o calculo da soma de a2 e a3
	neg a3, a3		# calcula o módulo do resultado caso a subtração entre "y_alien" e "y_target" seja menor que zero
	
CONT2:  add a2, a2, a3		# a2 = distância de manhatan da posição acima, abaixo, a esquerda ou a direita do alien
	ret			# retorna para verificar outra posição

# Uma vez calculadas as distãncias entre o target e as possiveis direções de movimentação do alien, faz um condicional para ver qual o menor registrador entre os 4 (t0, t1, t2, t3)
# prioridades de opção em caso de empate: cima > esquerda > baixo > direita

MENOR:	blt t1, t0, COMP1	# continua se t0 é menor
	blt t3, t2, COMP2	# continua se t2 é menor
	blt t2, t0, VDCA	# se t2 é menor, então o alien verifica colisão em baixo
	j VUCA			# se não, ele verifica colisão acima
	
COMP1:	blt t3, t2, COMP3	# já que t1 é menor, resta ver qual é menor: t2 ou t3, se t3 for menor, cai no mesmo loop de COMP2, só que comparando com o t1
	blt t2, t1, VDCA	# se t2 é menor que o t1, então verifica colisão em baixo
	j VLCA			# se não, ele verifica colisão na esquerda
	
COMP2:	blt t3, t0, VRCA	# já que t3 é menor, resta ver qual é menor: t0 ou t3, se t3 for menor, o alien verifica colisão na direita
	j VUCA			# se não, verifica colisão acima
	
COMP3:	blt t3, t1, VRCA	# já que t3 é menor, resta ver qual é menor: t1 ou t3, se t3 for menor, o alien verifica colisão na direita
	j VLCA			# se não, verifica colisão na esquerda

# Verifica a colisao do mapa (VLCA, VUCA, VDCA e VRCA carregam 5 ou 6 pixels de detecção de colisão em cada direção, e VERC_A verifica se algum desses pixels detectou uma colisão adiante)

#	   @7       @8          @9          @10         @11
#	@6 #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  @12
#	   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  
#	   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  
#	@5 #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  @13
#	   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  
#	   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  
#	@4 #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  @14
#	   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #			# representação do alien 16x16 com "#"
#	   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  			# os "@x" são os pixels de colisão carregados ao redor do alien (o endereço de "@x" é calculado em relação ao endereço em POS_ALIEN, sendo "@22" igual a própria posição)
#	@3 #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  @15			# OBS: os pixels de colisão detectam colisões apenas em relação ao mapa desenhado no Frame 1 da memória VGA (mapa de colisão)
#	   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #			# se tiver colisão, carrega "tX" com o maior valor possivel e volta para o loop MENOR
#	   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #
#	@2 #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  @16
#	   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #
#	   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #
#	@1 #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  @17
#	   @22(POS) @21	        @20         @19         @18

# Carrega pixels de colisão acima (@7, @8, @9, @10, @11)

VUCA:	li t6, 1		# t6 = 1 (indica que o alien esta verificando se e possivel ir para cima)
	mv a1, a4		# a1 = a4 (endereço da posição do alien)
	
	li a2, -5440		# a2 = -5440
	add a1,a1,a2		# volta a1 1 linha e 1 pixel (carrega em a1 o endereÃ§o do pixel "@1")
	jal a3, VERC_A		# vÃ¡ para VERC_A (verifica se o pixel "@1" detectou uma colisÃ£o)
	
	li a2, -5437		
	add a1,a1,a2		# volta a1 4 linhas e 1 pixel (carrega em t5 o endereÃ§o do pixel "@2")
	jal a3, VERC_A		# vÃ¡ para VERC_A (verifica se o pixel "@1" detectou uma colisÃ£o)
	
	li a2, -5433		# a2 = -2241
	add a1,a1,a2		# volta a1 7 linhas e 1 pixel (carrega em t5 o endereÃ§o do pixel "@3")
	jal a3, VERC_A		# vÃ¡ para VERC_A (verifica se o pixel "@1" detectou uma colisÃ£o)
	
	li a2, -5429		# a2 = -3201
	add a1,a1,a2		# volta a1 10 linhas e 1 pixel (carrega em a1 o endereÃ§o do pixel "@4")
	jal a3, VERC_A		# vÃ¡ para VERC_A (verifica se o pixel "@1" detectou uma colisÃ£o)
	
	li a2, -5425		# a2 = -5121
	add a1,a1,a2		# volta a1 13 linhas e 1 pixel (carrega em a1 o endereÃ§o do pixel "@5")
	jal a3, VERC_A		# vÃ¡ para VERC_A (verifica se o pixel "@1" detectou uma colisÃ£o)
	
	beq t6, zero, CUA	# se t6 for igual a zero, então houve colisão
	j SETUP_DELETE		# se não, ele pode se mover tranquilamente
	
CUA:	li t0, 561		# carrega t0 com um valor que não consiga ser menor que t1, t2 ou t3
	j MENOR			# volta para calcular qual o menor entre t1, t2 e t3
	
# Carrega pixels de colisão a esquerda (@1, @2, @3, @4, @5, @6)

VLCA:	li t6, 2		# t6 = 2 (indica que o alien esta verificando se e possivel ir para a esquerda)
	mv a1, a4		# a1 = a4 (endereço da posição do alien) 	
	
	addi a1,a1,-321		# volta a1 1 linha e 1 pixel (carrega em a1 o endereÃ§o do pixel "@1")
	jal a3, VERC_A		# vÃ¡ para VERC_A (verifica se o pixel "@1" detectou uma colisÃ£o)
			
	addi a1,a1,-1281	# volta a1 4 linhas e 1 pixel (carrega em t5 o endereÃ§o do pixel "@2")
	jal a3, VERC_A		# vÃ¡ para VERC_A (verifica se o pixel "@1" detectou uma colisÃ£o)
	
	li a2,-2241		# a2 = -2241
	add a1,a1,a2		# volta a1 7 linhas e 1 pixel (carrega em t5 o endereÃ§o do pixel "@3")
	jal a3, VERC_A		# vÃ¡ para VERC_A (verifica se o pixel "@1" detectou uma colisÃ£o)
	
	li a2,-3201		# a2 = -3201
	add a1,a1,a2		# volta a1 10 linhas e 1 pixel (carrega em a1 o endereÃ§o do pixel "@4")
	jal a3, VERC_A		# vÃ¡ para VERC_A (verifica se o pixel "@1" detectou uma colisÃ£o)
	
	li a2,-4161		# a2 = -5121
	add a1,a1,a2		# volta a1 13 linhas e 1 pixel (carrega em a1 o endereÃ§o do pixel "@5")
	jal a3, VERC_A		# vÃ¡ para VERC_A (verifica se o pixel "@1" detectou uma colisÃ£o)
	
	li a2,-5121		# a2 = -5121
	add a1,a1,a2		# volta a1 16 linhas e 1 pixel (carrega em a1 o endereÃ§o do pixel "@6")
	jal a3, VERC_A		# vÃ¡ para VERC_A (verifica se o pixel "@1" detectou uma colisÃ£o)
	
	beq t6, zero, CLA	# se t6 for igual a zero, então houve colisão
	j SETUP_DELETE		# se não, ele pode se mover tranquilamente
	
CLA:	li t1, 561		# carrega t1 com um valor que não consiga ser menor que t0, t2 ou t3
	j MENOR			# volta para calcular qual o menor entre t0, t2 e t3

# Carrega pixels de colisão abaixo (@22, @21, @20, @19, @18)

VDCA:	li t6, 3		# t6 = 3 (indica que o alien esta verificando se e possivel ir para baixo)
	mv a1, a4		# a1 = a4 (endereço da posição do alien)
	jal a3, VERC_A		# vÃ¡ para VERC_A (verifica se o pixel "@1" detectou uma colisÃ£o)
			
	addi a1,a1,3		# volta a1 4 linhas e 1 pixel (carrega em t5 o endereÃ§o do pixel "@2")
	jal a3, VERC_A		# vÃ¡ para VERC_A (verifica se o pixel "@1" detectou uma colisÃ£o)
	
	addi a1,a1,7		# volta a1 7 linhas e 1 pixel (carrega em t5 o endereÃ§o do pixel "@3")
	jal a3, VERC_A		# vÃ¡ para VERC_A (verifica se o pixel "@1" detectou uma colisÃ£o)
	
	addi a1,a1,11		# volta a1 10 linhas e 1 pixel (carrega em a1 o endereÃ§o do pixel "@4")
	jal a3, VERC_A		# vÃ¡ para VERC_A (verifica se o pixel "@1" detectou uma colisÃ£o)
	
	addi a1,a1,15		# volta a1 13 linhas e 1 pixel (carrega em a1 o endereÃ§o do pixel "@5")
	jal a3, VERC_A		# vÃ¡ para VERC_A (verifica se o pixel "@1" detectou uma colisÃ£o)
	
	beq t6, zero, CDA	# se t6 não for igual a zero, então houve colisão
	j SETUP_DELETE		# se não, ele pode se mover tranquilamente
	
CDA:	li t2, 561		# carrega t2 com um valor que não consiga ser menor que t0, t1 ou t3
	j MENOR			# volta para calcular qual o menor entre t0, t1 e t3
	
# Carrega pixels de colisão a direita (@17, @16, @15, @14, @13, @12)

VRCA:	li t6, 4		# t6 = 4 (indica que o alien esta verificando se e possivel ir para a direita)
	mv a1, a4		# a1 = a4 (endereço da posição do alien)
	
	addi a1,a1,-304		# volta a1 1 linha e 1 pixel (carrega em a1 o endereÃ§o do pixel "@1")
	jal a3, VERC_A		# vÃ¡ para VERC_A (verifica se o pixel "@1" detectou uma colisÃ£o)
			
	addi a1,a1,-1264	# volta a1 4 linhas e 1 pixel (carrega em t5 o endereÃ§o do pixel "@2")
	jal a3, VERC_A		# vÃ¡ para VERC_A (verifica se o pixel "@1" detectou uma colisÃ£o)
	
	li a2,-2224		# a2 = -2241
	add a1,a1,a2		# volta a1 7 linhas e 1 pixel (carrega em t5 o endereÃ§o do pixel "@3")
	jal a3, VERC_A		# vÃ¡ para VERC_A (verifica se o pixel "@1" detectou uma colisÃ£o)
	
	li a2,-3184		# a2 = -3201
	add a1,a1,a2		# volta a1 10 linhas e 1 pixel (carrega em a1 o endereÃ§o do pixel "@4")
	jal a3, VERC_A		# vÃ¡ para VERC_A (verifica se o pixel "@1" detectou uma colisÃ£o)
	
	li a2,-4144		# a2 = -5121
	add a1,a1,a2		# volta a1 13 linhas e 1 pixel (carrega em a1 o endereÃ§o do pixel "@5")
	jal a3, VERC_A		# vÃ¡ para VERC_A (verifica se o pixel "@1" detectou uma colisÃ£o)
	
	li a2,-5104		# a2 = -5121
	add a1,a1,a2		# volta a1 16 linhas e 1 pixel (carrega em a1 o endereÃ§o do pixel "@6")
	jal a3, VERC_A		# vÃ¡ para VERC_A (verifica se o pixel "@1" detectou uma colisÃ£o)
	
	beq t6, zero, CRA	# se t6 não for igual a zero, então houve colisão
	j SETUP_DELETE		# se não, ele pode se mover tranquilamente
	
CRA:	li t3, 561		# carrega t3 com um valor que não consiga ser menor que t0, t1 ou t2
	j MENOR			# volta para calcular qual o menor entre t0, t1 e t2
	
# Verifica a colisão em casa pixel

VERC_A:	li a0,0x100000		# a0 = 0x100000
	add a1,a1,a0		# soma 0x100000 a a1 (transforma o conteudo de a em um endereÃ§o do Frame 1)
	lbu a0,0(a1)		# carrega em a0 um byte do endereÃ§o a1 (cor do pixel de a1) -> OBS: o load byte deve ser "unsigned" 
				# Ex: 0d200 = 0xc8 = 0b11001000. como o MSB desse byte Ã© 1, ele seria interpretado como -56 e nÃ£o 200 (t6 = 0xffffffc8)
	li a1,200		# a1 = 200
	beq a0,a1, COLIDIU_A	# se a0 = 200, vÃ¡ para COLIDIU_A (se a cor do pixel for azul, termina a iteraÃ§Ã£o e impede movimento do Robozinho)
	li a1,3			# a1 = 3
	beq a0,a1, COLIDIU_A	# se a0 = 200, vÃ¡ para COLIDIU_A (se a cor do pixel for azul, termina a iteraÃ§Ã£o e impede movimento do Robozinho)
	li a1,7			# a1 = 7	
	beq a0,a1, COLIDIU_A	# se a0 = 200, vÃ¡ para COLIDIU_A (se a cor do pixel for azul, termina a iteraÃ§Ã£o e impede movimento do Robozinho)
	mv a1, a4		# a1 = a4
	jalr x0, a3, 0 		# retorna para verificar se outro pixel detectou colisÃ£o
	
COLIDIU_A:
	li t6, 0		# colidiu, logo t6 recebe o valor de 0
	mv a1, a4		# a1 = a4
	jalr x0, a3, 0 		# retorna para verificar se outro pixel detectou colisÃ£o
	
# Deleta o personagem caso haja movimento

SETUP_DELETE:
	
	mv t1,a4		# t1 = a4 (posição atual do alien - pixel inicial da linha)
	addi t2,a4,16		# t2 = a4 + 16 (posição atual do alien - pixel inicial da linha)
	mv a5,t6		# a5 = t6 (direção atual de movimentação do alien)
	
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
DELFS1:	la t3,mapa1		# carrega em t3 o endereço dos dados do mapa1
DELFS2:	addi t3,t3,8		# t3 = endereço do primeiro pixel do mapa1 (depois das informações de nlin ncol)
	li t0,0xFF000000	# t0 = 0xFF000000 (carrega em t0 o endereço base da memoria VGA)
	sub t0,t1,t0		# t0 = t1 - 0xFF000000 (subtrai o endereço base de t1, posição atual do alien)
	add t3,t3,t0		# t3 = t3 + t0 (carrega em t3 o endereço do pixel do mapa1 no segmento de dados sobre o qual o alien esta localizado)
	
DELLOOP_A:
	beq t1,t2,ENTER2_A	# se t1 atingir o fim da linha de pixels, quebre linha
	lw t0,0(t3)		# le uma word do endereço t3 (le 4 pixels do mapa1 no segmento de dados)
	sw t0,0(t1)		# escreve a word (4 pixels do mapa1) na memória VGA
	addi t1,t1,4		# soma 4 ao endereço t1
	addi t3,t3,4		# soma 4 ao endereço t3
	j DELLOOP_A		# volta a verificar a condiçao do loop

ENTER2_A:
	addi t1,t1,304		# t1 (a4) pula para o pixel inicial da linha de baixo da memoria VGA
	addi t3,t3,304		# t1 pula para o pixel inicial da linha de baixo do segmento de dados 
	addi t2,t2,320		# t2 (a4 + 16) pula para o pixel final da linha de baixo da memoria VGA
	addi t5,t5,1          	# atualiza o contador de quebras de linha
	beq t5,t6,SETUP_MOV	# termina o carregamento da imagem se 16 quebras de linha ocorrerem e vai para o loop de carregamento da imagem
	j DELLOOP_A		# pula para delloop

# ve em qual direção foi o movimento para printar o personagem

SETUP_MOV:

	mv t3, a6		# volta o t3 com a label de a6
	addi t3, t3, 8		# s0 = endereço do primeiro pixel da imagem (depois das informações de nlin ncol)
	
	li t5,0
	li t6,16		# inicializa o contador de quebra de linha para 16 quebras de linha
	
	li t0, 1			# t0 = 1
	beq a5, t0, MOV_UP_A		# se a5 = 1, então vai para MOV_UP_A
	
	li t0, 2			# t0 = 2
	beq a5, t0, MOV_LEFT_A		# se a5 = 2, então vai para MOV_LEFT_A
	
	li t0, 3			# t0 = 3
	beq a5, t0, MOV_DOWN_A		# se a5 = 3, então vai para MOV_DOWN_A
	
	li t0, 4			# t0 = 4
	beq a5, t0, MOV_RIGHT_A		# se a5 = 4, então vai para MOV_RIGHT_A

MOV_UP_A: 

	mv t1, a4		# t1 = a4 (posição atual do alien - pixel inicial da linha)
	li t4, 0		# salva em t4 a movimentação atual do alien
	addi t2,a4,16		# t2 = a4 + 16 (posição atual do alien - pixel final da linha)
	
	li t0, 6400		# t0 = 6400
	sub t1,t1, t0		# volta t1 20 linhas (pixel inicial 4 linhas acima) 
	sub t2, t2, t0		# volta t2 20 linhas (pixel final 4 linhas acima)
	
	j LOOP2_MA		# pule para LOOP2_MA (loop que printa o alien na tela)
	
MOV_LEFT_A:

	mv t1, a4		# t1 = a4 (posição atual do alien - pixel inicial da linha)
	li t4, 1		# salva em t4 a movimentação atual do alien
	addi t2,a4,16		# t2 = a4 + 16 (posição atual do alien - pixel final da linha)
	
	li t0, 5124		# t0 = 5124
	sub t1,t1, t0		# volta t1 16 linhas e vai 4 pixels para a esquerda (pixel inicial - 4)
	sub t2, t2, t0		# volta t1 16 linhas e vai 4 pixels para a esquerda (pixel final - 4)
	
	j LOOP2_MA		# pule para LOOP2_MA (loop que printa o alien na tela)
	
MOV_DOWN_A:

	mv t1, a4		# t1 = a4 (posição atual do alien - pixel inicial da linha)
	li t4, 2		# salva em t4 a movimentação atual do alien
	addi t2,a4,16		# t2 = a4 + 16 (posição atual do alien - pixel final da linha)
	
	li t0, 3840		# t0 = 3840
	sub t1,t1, t0		# volta t1 12 linhas (pixel inicial 4 linhas abaixo) 
	sub t2, t2, t0		# volta t2 12 linhas (pixel final 4 linhas abaixo)
	
	j LOOP2_MA		# pule para LOOP2_MA (loop que printa o alien na tela)
	
MOV_RIGHT_A:

	mv t1, a4		# t1 = a4 (posição atual do alien - pixel inicial da linha)
	li t4, 3		# salva em t4 a movimentação atual do alien
	addi t2,a4,16		# t2 = a4 + 16 (posição atual do alien - pixel final da linha)
	
	li t0, 5116		# t0 = 5116
	sub t1,t1, t0		# volta t1 16 linhas e vai 4 pixels para a direita (pixel inicial + 4) 
	sub t2, t2, t0		# volta t1 16 linhas e vai 4 pixels para a direita (pixel final + 4)
	
	j LOOP2_MA		# pule para LOOP2_MA (loop que printa o alien na tela)

LOOP2_MA:
	beq t1,t2,ENTER_MA	# se t1 atingir o fim da linha de pixels, quebre linha
	lw t0,0(t3)		# le uma word do endereço t3 (le 4 pixels da imagem)
	sw t0,0(t1)		# escreve a word na memória VGA no endereço t1 (desenha 4 pixels na tela do Bitmap Display)
	addi t1,t1,4		# soma 4 ao endereço t1
	addi t3,t3,4		# soma 4 ao endereço t3
	j LOOP2_MA 		# volta a verificar a condiçao do loop
	
ENTER_MA:
	addi t1,t1,304		# t1 pula para o pixel inicial da linha de baixo
	addi t2,t2,320		# t2 pula para o pixel final da linha de baixo
	addi t5,t5,1          	# atualiza o contador de quebras de linha
	beq t5,t6,FIM_MOV	# termina o carregamento da imagem se 16 quebras de linha ocorrerem
	j LOOP2_MA		# pule para LOOP2_MA

# Verifica qual alien foi movimentado baseado em s7, atualiza a posição dele e retorna para ver se mais um alien deve ser movimentado

FIM_MOV:

	li t0,1				# t0 = 1
	beq s7, t0, BLINKY_MOV		# se s7 = 1, então vai para BLINKY_MOV
	
	li t0,2				# t0 = 2
	beq s7, t0, PINK_MOV		# se s7 = 2, então vai para PINK_MOV
	
	li t0,3				# t0 = 3
	beq s7, t0, INKY_MOV		# se s7 = 3, então vai para INKY_MOV
	
	li t0,4				# t0 = 4
	beq s7, t0, CLYDE_MOV		# se s7 = 4, então vai para CLYDE_MOV
	
# Atualiza a posição do alien movimentado	
	
BLINKY_MOV:
	la t0, POS_BLINKY   	# carrega o endereço de "POS_ROBOZINHO" no registrador t0 
    	sw t1, 0(t0)       	# guarda a word armazenada em t1 (posição atual do Roboziho) em "POS_ROBOZINHO"
    	add s4, s4 ,t4		# adiciona ao movimento do alien o movimento atual(ex.: s4 = 17 + t4)	
	jalr x0, a7, 0		# volta para o loop dos aliens
PINK_MOV:
	la t0, POS_PINK   	# carrega o endereço de "POS_ROBOZINHO" no registrador t0 
    	sw t1, 0(t0)       	# guarda a word armazenada em t1 (posição atual do Roboziho) em "POS_ROBOZINHO"	
    	add s9, s9, t4		# adiciona ao movimento do alien o movimento atual(ex.: s9 = 17 + t4)
	jalr x0, a7, 0		# volta para o loop dos aliens
INKY_MOV:
	la t0, POS_INKY   	# carrega o endereço de "POS_ROBOZINHO" no registrador t0 
    	sw t1, 0(t0)       	# guarda a word armazenada em t1 (posição atual do Roboziho) em "POS_ROBOZINHO"	
    	add s10, s10, t4	# adiciona ao movimento do alien o movimento atual(ex.: s10 = 17 + t4)
	jalr x0, a7, 0		# volta para o loop dos aliens
CLYDE_MOV:
	la t0, POS_CLYDE   	# carrega o endereço de "POS_ROBOZINHO" no registrador t0 
    	sw t1, 0(t0)       	# guarda a word armazenada em t1 (posição atual do Roboziho) em "POS_ROBOZINHO"
    	add s11, s11, t4	# adiciona ao movimento do alien o movimento atual(ex.: s11 = 17 + t4)
	jalr x0, a7, 0		# volta para o loop dos aliens
	
# Parte do codigo que lida com a movimentação do Robozinho

ROBOZINHO:

	li a7,104		# carrega em a7 o serviço 104 do ecall (print string on bitmap display)
	la a0,STR		# carrega em a0 o endereço da string a ser printada (STR: "PONTOS: ")
	li a1,0			# carrega em a1 a coluna a partir da qual a string vai ser printada (coluna 0)
       	li a2,2			# carrega em a2 a linha a partir da qual a string vai ser printada (linha 2)
	li a3,0x00FF		# carrega em a3 a cor de fundo (0x00 - preto) e a cor dos caracteres (0xFF - branco)
	li a4,0 		# carrega em a4 o frame onde a string deve ser printada (Frame 0 da memoria VGA)
	ecall			# realiza o ecall
	
	li a7,101		# carrega em a7 o serviço 101 do ecall (print integer on bitmap display)
	mv a0,s1		# carrega em a0 o valor do inteiro a ser printado (a0 = s1 = pontuação atual do jogador)
	li a1,60		# carrega em a1 a coluna a partir da qual o inteiro vai ser printado (coluna 60)
        li a2,2			# carrega em a1 a linha a partir da qual o inteiro vai ser printado (linha 2)
	li a3,0x00FF		# carrega em a3 a cor de fundo (0x00 - preto) e a cor dos caracteres (0xFF - branco)
	li a4,0			# carrega em a4 o frame onde o inteiro deve ser printado (Frame 0 da memoria VGA)
	ecall			# realiza o ecall
	
	li t0,1
	beq s6,t0,VERVIC1
	j VERVIC2
	
VERVIC1:li t0,103
	beq s1,t0,FASE2
	j FASE
	
VERVIC2:li t0,142
	#beq s1,t0,WINGAME
	j FASE
	
FASE:	li t0,0xFF200000	# carrega o endereço de controle do KDMMIO ("teclado")
	lw t1,0(t0)		# le uma word a partir do endereço de controle do KDMMIO
	andi t1,t1,0x0001	# mascara todos os bits de t1 com exceçao do bit menos significativo
   	beq t1,zero,MOVE   	# se o BMS de t1 for 0 (não há tecla pressionada), pule para MOVE (continua o movimento atual do Robozinho)
 
  	lw t1,4(t0)		# le o valor da tecla pressionada e guarda em t1
  	li t2,1			# t2 = 1 (significa que o movimento a ser verificado veio de uma ação do jogador)
  	
  	li t0,97		# carrega 97 (valor hex de "a") para t0		
  	beq t1,t0,VLCO		# se t1 for igual a 97 (valor hex de "a"), vá para VLCO (verify left colision)
  	
  	li t0,119		# carrega 119 (valor hex de "w") para t0
  	beq t1,t0,VUCO		# se t6 for igual a 119 (valor hex de "w"), vá para VUCO (verify up colision)
  	
  	li t0,115		# carrega 115 (valor hex de "s") para t0
  	beq t1,t0,VDCO		# se t1 for igual a 115 (valor hex de "s"), vá para VDCO (verify down colision)
  	
  	li t0,100  		# carrega 100 (valor hex de "d") para t0
	beq t1,t0,VRCO		# se t1 for igual a 100 (valor hex de "d"), vá para VRCO (verify right colision)
	
MOVE:  	li t2,2			# t2 = 2 (significa que o movimento a ser verificado não veio de uma ação do jogador)

	li t0,0			# carrega 0 para t0
  	beq s3,t0,FIM		# se s3 for igual a 0 (valor de movimento atual nulo), vá para FIM
  	
  	li t0,1			# carrega 1 para t0
  	beq s3,t0,VLCO		# se s3 for igual a 1 (valor de movimento atual para a esquerda), vá para VLCO (verify left colision)
  	
  	li t0,2			# carrega 2 para t0
  	beq s3,t0,VUCO		# se s3 for igual a 2 (valor de movimento atual para cima), vá para VUCO (verify up colision)
  	
  	li t0,3  		# carrega 3 para t0
	beq s3,t0,VDCO		# se s3 for igual a 3 (valor de movimento atual para baixo), vá para VDCO (verify down colision)
	
	li t0,4  		# carrega 4 para t0
	beq s3,t0,VRCO		# se s3 for igual a 4 (valor de movimento atual para a direita), vá para VRCO (verify right colision)
	
# Verifica a colisao do mapa (VLCO, VUCO, VDCO e VRCO carregam 5 ou 6 pixels de detecção de colisão em cada direção, e VERC verifica se algum desses pixels detectou uma colisão adiante)

#	   @7       @8          @9          @10         @11
#	@6 #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  @12
#	   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  
#	   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  
#	@5 #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  @13
#	   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  
#	   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  
#	@4 #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  @14
#	   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #			# representação do Robozinho 16x16 com "#"
#	   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  			# os "@x" são os pixels de colisão carregados ao redor do Robozinho (o endereço de "@x" é calculado em relação ao endereço em POS_ROBOZINHO, sendo "@22" igual a própria posição)
#	@3 #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  @15			# OBS: os pixels de colisão detectam colisões apenas em relação ao mapa desenhado no Frame 1 da memória VGA (mapa de colisão)
#	   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #
#	   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #
#	@2 #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  @16
#	   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #
#	   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #
#	@1 #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  @17
#	   @22(POS) @21	        @20         @19         @18

# Carrega pixels de colisão a esquerda (@1, @2, @3, @4, @5, @6)

VLCO:   la t0,POS_ROBOZINHO	# carrega o endereço de "POS_ROBOZINHO" no registrador t0
	lw t1,0(t0)		# le a word guardada em "POS_ROBOZINHO" para t1 (t1 = posição atual do Robozinho)
	addi t1,t1,-321		# volta t1 1 linha e 1 pixel (carrega em t1 o endereço do pixel "@1")
	jal ra, VERC		# vá para VERC (verifica se o pixel "@1" detectou uma colisão)
			
	addi t1,t1,-1281	# volta t1 4 linhas e 1 pixel (carrega em t1 o endereço do pixel "@2")
	jal ra, VERC		# vá para VER (verifica se o pixel "@2" detectou uma colisão)
	
	li t0,-2241		# t0 = -2241
	add t1,t1,t0		# volta t1 7 linhas e 1 pixel (carrega em t1 o endereço do pixel "@3")
	jal ra, VERC		# vá para VERC (verifica se o pixel "@3" detectou uma colisão)
	
	li t0,-3201		# t0 = -3201
	add t1,t1,t0		# volta t1 10 linhas e 1 pixel (carrega em t1 o endereço do pixel "@4")
	jal ra, VERC		# vá para VERC (verifica se o pixel "@4" detectou uma colisão)
	
	li t0,-4161		# t0 = -5121
	add t1,t1,t0		# volta t1 13 linhas e 1 pixel (carrega em t1 o endereço do pixel "@5")
	jal ra, VERC		# vá para VERC (verifica se o pixel "@5" detectou uma colisão)
	
	li t0,-5121		# t0 = -5121
	add t1,t1,t0		# volta t1 16 linhas e 1 pixel (carrega em t1 o endereço do pixel "@6")
	jal ra, VERC		# vá para VERC (verifica se o pixel "@6" detectou uma colisão)
	
	li s3,1			# se nenhuma colisão foi detectada, movimentação atual = 1 (esquerda)
	j VLP			# se nenhuma colisão foi detectada, vá para VLP (Verify Left Point)
	
# Carrega pixels de colisão acima (@7, @8, @9, @10, @11)

VUCO:	la t0,POS_ROBOZINHO	# carrega o endereço de "POS_ROBOZINHO" no registrador t0
	lw t1,0(t0)		# le a word guardada em "POS_ROBOZINHO" para t1 (t1 = posição atual do Robozinho)
	li t0,-5440		# t0 = -5440
	add t1,t1,t0		# volta t1 17 linhas (carrega em t1 o endereço do pixel "@7")
	jal ra, VERC		# vá para VERC (verifica se o pixel "@7" detectou uma colisão)
	
	li t0,-5437		# t0 = -5437
	add t1,t1,t0		# t1 volta 17 linhas e vai 3 pixels pra frente (carrega em t1 o endereço do pixel "@8")
	jal ra, VERC		# vá para VERC (verifica se o pixel "@8" detectou uma colisão)
	
	li t0,-5433		# t0 = -5433
	add t1,t1,t0		# t1 volta 17 linhas e vai 7 pixels pra frente (carrega em t1 o endereço do pixel "@9")
	jal ra, VERC		# vá para VERC (verifica se o pixel "@9" detectou uma colisão)
	
	li t0,-5429		# t0 = -5429
	add t1,t1,t0		# t1 volta 17 linhas e vai 11 pixels pra frente (carrega em t1 o endereço do pixel "@10")
	jal ra, VERC		# vá para VERC (verifica se o pixel "@10" detectou uma colisão)
	
	li t0,-5425		# t0 = -5425
	add t1,t1,t0		# t1 volta 17 linhas e vai 15 pixels pra frente (carrega em t1 o endereço do pixel "@11")
	jal ra, VERC		# vá para VERC (verifica se o pixel "@11" detectou uma colisão)

	li s3,2			# se nenhuma colisão foi detectada, movimentação atual = 2 (cima)
	j VUP			# se nenhuma colisão foi detectada, vá para VUP (Verify Up Point)
	
# Carrega pixels de colisão abaixo (@22, @21, @20, @19, @18)
 
VDCO:	la t0,POS_ROBOZINHO	# carrega o endereço de "POS_ROBOZINHO" no registrador t0
	lw t1,0(t0)		# le a word guardada em "POS_ROBOZINHO" para t1 (t1 = posição atual do Robozinho)
	jal ra, VERC		# vá para VERC (verifica se o pixel "@22" detectou uma colisão)
	
	addi t1,t1,3		# t1 vai 3 pixels pra frente (carrega em t1 o endereço do pixel "@21")
	jal ra, VERC		# vá para VERC (verifica se o pixel "@21" detectou uma colisão)
	
	addi t1,t1,7		# t1 vai 7 pixels pra frente (carrega em t1 o endereço do pixel "@20")
	jal ra, VERC		# vá para VERC (verifica se o pixel "@20" detectou uma colisão)
	
	addi t1,t1,11		# t1 vai 11 pixels pra frente (carrega em t1 o endereço do pixel "@19")
	jal ra, VERC		# vá para VERC (verifica se o pixel "@19" detectou uma colisão)
	
	addi t1,t1,15		# t1 vai 15 pixels pra frente (carrega em t1 o endereço do pixel "@18")
	jal ra, VERC		# vá para VERC (verifica se o pixel "@18" detectou uma colisão)
	
	li s3,3			# se nenhuma colisão foi detectada, movimentação atual = 3 (baixo)
	j VDP			# se nenhuma colisão foi detectada, vá para VDP (Verify Down Point)
	
# Carrega pixels de colisão a direita (@17, @16, @15, @14, @13, @12)
 
VRCO:	la t0,POS_ROBOZINHO	# carrega o endereço de "POS_ROBOZINHO" no registrador t0
	lw t1,0(t0)		# le a word guardada em "POS_ROBOZINHO" para t1 (t1 = posição atual do Robozinho)
	addi t1,t1,-304		# t1 volta 1 linha e vai 16 pixels pra frente (carrega em t1 o endereço do pixel "@17")
	jal ra, VERC		# vá para VERC (verifica se o pixel "@17" detectou uma colisão)
	
	addi t1,t1,-1264	# t1 volta 4 linhas e vai 16 pixels pra frente (carrega em t1 o endereço do pixel "@16")
	jal ra, VERC 		# vá para VERC (verifica se o pixel "@16" detectou uma colisão)
	
	li t0,-2224		# t0 = -2224
	add t1,t1,t0		# t1 volta 7 linhas e vai 16 pixels pra frente (carrega em t1 o endereço do pixel "@15")
	jal ra, VERC		# vá para VERC (verifica se o pixel "@15" detectou uma colisão)
	
	li t0,-3184		# t0 = -3184
	add t1,t1,t0		# t1 volta 10 linhas e vai 16 pixels pra frente (carrega em t1 o endereço do pixel "@14")
	jal ra, VERC		# vá para VERC (verifica se o pixel "@14" detectou uma colisão)
	
	li t0,-4144		# t0 = -4144
	add t1,t1,t0		# t1 volta 13 linhas e vai 16 pixels pra frente (carrega em t1 o endereço do pixel "@13")
	jal ra, VERC		# vá para VERC (verifica se o pixel "@13" detectou uma colisão)
	
	li t0,-5104		# t0 = -5104
	add t1,t1,t0		# t1 volta 16 linhas e vai 16 pixels pra frente (carrega em t1 o endereço do pixel "@12")
	jal ra, VERC		# vá para VERC (verifica se o pixel "@12" detectou uma colisão)
	
	li s3,4			# se nenhuma colisão foi detectada, movimentação atual = 4 (direita)
	j VRP			# se nenhuma colisão foi detectada, vá para VRP (Verify Right Point)
	
# Verifica se algum dos pixels de colisão detectou alguma colisão
 
VERC:	li t0,0x100000		# t0 = 0x100000
	add t1,t1,t0		# soma 0x100000 a t1 (transforma o conteudo de t1 em um endereço do Frame 1)
	lbu t0,0(t1)		# carrega em t0 um byte do endereço t1 (cor do pixel de t1) -> OBS: o load byte deve ser "unsigned" 
				# Ex: 0d200 = 0xc8 = 0b11001000. como o MSB desse byte é 1, ele seria interpretado como -56 e não 200 (t0 = 0xffffffc8)
	li t1,200		# t1 = 200
	beq t0,t1,VERWAY	# se t0 = 200, vá para VERWAY (se a cor do pixel for azul, verifica se o movimento do Robozinho foi causado ou não pelo jogador)
	
	li t1,240		# t1 = 240
	beq t0,t1,VERWAY	# se t0 = 240, vá para VERWAY (se a cor do pixel for o da porta da caixa dos aliens, verifica se o movimento do Robozinho foi causado ou não pelo jogador)
	
	li t1,3			# t1 = 3
	beq t0,t1,LPORTAL	# se t0 = 3, vá para LPORTAL (se a cor do pixel for vermelho-3, o Robozinho teletransporta)
	
	li t1,7			# t1 = 7
	beq t0,t1,RPORTAL	# se t0 = 7, vá para RPORTAL (se a cor do pixel for vermelho-7, o Robozinho teletransporta)
	
	la t0,POS_ROBOZINHO	# carrega o endereço de "POS_ROBOZINHO" no registrador t0
	lw t1,0(t0)		# le a word guardada em "POS_ROBOZINHO" para t1 (t1 = posição atual do Robozinho)
	ret 			# retorna para verificar se outro pixel detectou colisão
	
# Verifica se o movimento atual do Robozinho foi ou não causado pelo jogador. Se foi, vai para uma segunda checagem de colisão (se a direção escolhida pelo jogador não é permitida, o jogo verifica se a direção atual de movimento do Robozinho ainda é permitida)

VERWAY: li t0,2			# t0 = 2
	beq t2,t0,FIM		# se t2 = 2 (movimento não causado pelo jogador), vá para FIM (não precisa checar segunda colisão)
	
	li t2,2			# atualiza o valor de t2 para indicar que o movimento a ser checado não é mais causado pelo jogador
  	
  	li t0,1			# carrega 1 para t0
  	beq s3,t0,VLCO		# se s3 for igual a 1 (valor de movimento atual para a esquerda), vá para VLCO (verify left colision)
  	
  	li t0,2			# carrega 2 para t0
  	beq s3,t0,VUCO		# se s3 for igual a 2 (valor de movimento atual para cima), vá para VUCO (verify up colision)
  	
  	li t0,3  		# carrega 3 para t0
	beq s3,t0,VDCO		# se s3 for igual a 3 (valor de movimento atual para baixo), vá para VDCO (verify down colision)
	
	li t0,4  		# carrega 4 para t0
	beq s3,t0,VRCO		# se s3 for igual a 4 (valor de movimento atual para a direita), vá para VRCO (verify right colision)
	
# Realiza a movimentação do Robozinho atraves dos portais

LPORTAL: j FIM

RPORTAL: j FIM
	
# Verifica a colisão com pontos e incrementa o contador de pontos (extremamente não otimizado, mas eh oq ta tendo pra hj)

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
#	   	#  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #			# representação do Robozinho 16x16 com "#"
#	   	#  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  		# os "@x" são as linhas/colunas de detecção de pontos carregadas ao redor do Robozinho (o endereço de "@x" é calculado em relação ao endereço em POS_ROBOZINHO)
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

# Carrega colunas de detecção de pontos a esquerda (L - @1 @2 @3 @4)

VLP: 	la t0,POS_ROBOZINHO	# carrega o endereço de "POS_ROBOZINHO" no registrador t0
	lw t1,0(t0)		# le a word guardada em "POS_ROBOZINHO" para t1 (t1 = posição atual do Robozinho)
	li t0,-5120		# t0 = -5120
	addi t1,t1,-1		# volta t1 1 pixel (carrega em t1 o endereço inicial da coluna "@1" uma linha abaixo)
	add t0,t1,t0		# t0 = t1 - 5120 (carrega em t0 o endereço final da coluna "@1", pois volta t1 16 linhas)
	li t2,-320		# t2 = -320 (carrega em t2 o "offset" de um pixel para o outro)
	li t3,4			# t3 = 4 (carrega em t3 um contador para verificar apenas 4 colunas)
	jal ra, VERP		# vá para VERP (verifica se há ponto na coluna "@1")
	
	addi t1,t1,-2		# volta t1 2 pixels (carrega em t1 o endereço inicial da coluna "@2" uma linha abaixo)
	li t0,-5120		# t0 = -5120
	add t0,t1,t0		# t0 = t1 - 5120 (carrega em t0 o endereço final da coluna "@2", pois volta t1 16 linhas)
	jal ra, VERP		# vá para VERP (verifica se há ponto na coluna "@2")
	
	addi t1,t1,-3		# volta t1 3 pixels (carrega em t1 o endereço inicial da coluna "@3" uma linha abaixo)
	li t0,-5120		# t0 = -5120
	add t0,t1,t0		# t0 = t1 - 5120 (carrega em t0 o endereço final da coluna "@3", pois volta t1 16 linhas)
	jal ra, VERP		# vá para VERP (verifica se há ponto na coluna "@3")
	
	addi t1,t1,-4		# volta t1 4 pixels (carrega em t1 o endereço inicial da coluna "@4" uma linha abaixo)
	li t0,-5120		# t0 = -5120
	add t0,t1,t0		# t0 = t1 - 5120 (carrega em t0 o endereço final da coluna "@4", pois volta t1 16 linhas)
	jal ra, VERP		# vá para VERP (verifica se há ponto na coluna "@4")
	
# Carrega linhas de detecção de pontos acima (U - @1 @2 @3 @4)
	
VUP:	la t0,POS_ROBOZINHO	# carrega o endereço de "POS_ROBOZINHO" no registrador t0
	lw t1,0(t0)		# le a word guardada em "POS_ROBOZINHO" para t1 (t1 = posição atual do Robozinho)
	li t0, -5441		# t0 = -5441
	add t1,t1,t0		# volta t1 1 pixel e 17 linhas (carrega em t1 o endereço inicial da linha "@1" um pixel para a esquerda)
	addi t0,t1,16		# t0 = t1 + 16 (carrega em t0 o endereço final da linha "@1", pois avança t1 16 pixels)
	li t2,1			# t2 = 1 (carrega em t2 o "offset" de um pixel para o outro)
	li t3,4			# t3 = 4 (carrega em t3 um contador para verificar 4 linhas)
	jal ra, VERP		# vá para VERP (verifica se há ponto na linha "@1")
	
	li t0, -5761		# t0 = -5761
	add t1,t1,t0		# volta t1 1 pixel e 18 linhas (carrega em t1 o endereço inicial da linha "@2" um pixel para a esquerda)
	addi t0,t1,16		# t0 = t1 + 16 (carrega em t0 o endereço final da linha "@2", pois avança t1 16 pixels)
	jal ra, VERP		# vá para VERP (verifica se há ponto na linha "@2")
	
	li t0, -6081		# t0 = -6081
	add t1,t1,t0		# volta t1 1 pixel e 19 linhas (carrega em t1 o endereço inicial da linha "@3" um pixel para a esquerda)
	addi t0,t1,16		# t0 = t1 + 16 (carrega em t0 o endereço final da linha "@3", pois avança t1 16 pixels)
	jal ra, VERP		# vá para VERP (verifica se há ponto na linha "@3")
	
	li t0, -6401		# t0 = -6401
	add t1,t1,t0		# volta t1 1 pixel e 20 linhas (carrega em t1 o endereço inicial da linha "@4" um pixel para a esquerda)
	addi t0,t1,16		# t0 = t1 + 16 (carrega em t0 o endereço final da linha "@4", pois avança t1 16 pixels)
	jal ra, VERP		# vá para VERP (verifica se há ponto na coluna "@4")
	
# Carrega linhas de detecção de pontos abaixo (D - @1 @2 @3 @4)
	
VDP:	la t0,POS_ROBOZINHO	# carrega o endereço de "POS_ROBOZINHO" no registrador t0
	lw t1,0(t0)		# le a word guardada em "POS_ROBOZINHO" para t1 (t1 = posição atual do Robozinho)
	addi t1,t1,-1		# volta t1 1 pixel (carrega em t1 o endereço inicial da linha "@1" um pixel para a esquerda)
	addi t0,t1,16		# t0 = t1 + 16 (carrega em t0 o endereço final da linha "@1", pois avança t1 16 pixels)
	li t2,1			# t2 = 1 (carrega em t2 o "offset" de um pixel para o outro)
	li t3,4			# t3 = 4 (carrega em t3 um contador para verificar 4 linhas)
	jal ra, VERP		# vá para VERP (verifica se há ponto na linha "@1")
			
	addi t1,t1,319		# volta t1 1 pixel e avança t1 1 linha (carrega em t1 o endereço inicial da linha "@2" um pixel para a esquerda)
	addi t0,t1,16		# t0 = t1 + 16 (carrega em t0 o endereço final da linha "@2", pois avança t1 16 pixels)
	jal ra, VERP		# vá para VERP (verifica se há ponto na linha "@2")
			
	addi t1,t1,639		# volta t1 1 pixel e avança t1 2 linhas (carrega em t1 o endereço inicial da linha "@3" um pixel para a esquerda)
	addi t0,t1,16		# t0 = t1 + 16 (carrega em t0 o endereço final da linha "@3", pois avança t1 16 pixels)
	jal ra, VERP		# vá para VERP (verifica se há ponto na linha "@3")
			
	addi t1,t1,959		# volta t1 1 pixel e avança t1 3 linhas (carrega em t1 o endereço inicial da linha "@4" um pixel para a esquerda)
	addi t0,t1,16		# t0 = t1 + 16 (carrega em t0 o endereço final da linha "@4", pois avança t1 16 pixels)
	jal ra, VERP		# vá para VERP (verifica se há ponto na linha "@4")
	
# Carrega colunas de detecção de pontos a direita (R - @1 @2 @3 @4)

VRP:	la t0,POS_ROBOZINHO	# carrega o endereço de "POS_ROBOZINHO" no registrador t0
	lw t1,0(t0)		# le a word guardada em "POS_ROBOZINHO" para t1 (t1 = posição atual do Robozinho)
	addi t1,t1,16		# avança t1 16 pixels (carrega em t1 o endereço inicial da coluna "@1" uma linha abaixo)
	li t0,-5120		# t0 = -5120
	add t0,t1,t0		# t0 = t1 - 5120 (carrega em t0 o endereço final da coluna "@1", pois volta t1 16 linhas)
	li t2,-320		# t2 = -320 (carrega em t2 o "offset" de um pixel para o outro)
	li t3,4			# t3 = 4 (carrega em t3 um contador para verificar 4 colunas)
	jal ra, VERP		# vá para VERP (verifica se há ponto na coluna "@1")
	
	addi t1,t1,17		# avança t1 17 pixels (carrega em t1 o endereço inicial da coluna "@2" uma linha abaixo)
	li t0,-5120		# t0 = -5120
	add t0,t1,t0		# t0 = t1 - 5120 (carrega em t0 o endereço final da coluna "@2", pois volta t1 16 linhas)
	jal ra, VERP		# vá para VERP (verifica se há ponto na coluna "@2")
	
	addi t1,t1,18		# avança t1 18 pixels (carrega em t1 o endereço inicial da coluna "@3" uma linha abaixo)
	li t0,-5120		# t0 = -5120
	add t0,t1,t0		# t0 = t1 - 5120 (carrega em t0 o endereço final da coluna "@3", pois volta t1 16 linhas)
	jal ra, VERP		# vá para VERP (verifica se há ponto na coluna "@3")
	
	addi t1,t1,19		# avança t1 19 pixels (carrega em t1 o endereço inicial da coluna "@4" uma linha abaixo)
	li t0,-5120		# t0 = -5120
	add t0,t1,t0		# t0 = t1 - 5120 (carrega em t0 o endereço final da coluna "@4", pois volta t1 16 linhas)
	jal ra, VERP		# vá para VERP (verifica se há ponto na coluna "@4")

# Verifica se algum dos pixels de pontuação detectou algum ponto
 
VERP:	add t1,t1,t2		# t1 = t1 + offset (pula para o pixel seguinte da linha\coluna)
	lbu t4,0(t1)		# carrega em t4 um byte do endereço t1 (cor do pixel de t1)
	li t5,63		# t5 = 63 (cor amarela)
	beq t4,t5,PONTO		# se t4 = 63, vá para PONTO (atualiza o contador de pontos e termina a busca por pontos a serem coletados)
	li t5,127
	beq t4,t5,SPRPNT
	beq t1,t0,NXTLINE	# se t1 = t0, vá para NXTLINE (se o endereço analisado for o último da linha/coluna, pule para a linha/coluna seguinte)
	j VERP			# pule para VERP (se nenhum ponto foi detectado, volte para o início do loop)
	
NXTLINE:addi t3,t3,-1		# t3 = t3 - 1 (reduz o contador de linhas/colunas analisadas)
	beq t3,zero,DELETE	# se t3 = 0, vá para DELETE (se nenhum ponto for encontrado, apenas mova o Robozinho)
	la t0,POS_ROBOZINHO	# carrega o endereço de "POS_ROBOZINHO" no registrador t0
	lw t1,0(t0)		# le a word guardada em "POS_ROBOZINHO" para t1 (t1 = posição atual do Robozinho)
	ret 			# retorna para verificar se outro pixel detectou pontos 
	
PONTO:  addi s1,s1,1		# incrementa o contador de pontos (a sessão a seguir toca uma triade de mi maior para cada ponto coletado)

	li a0,68		# a0 = 68 (carrega sol sustenido para a0)
	li a1,100		# a1 = 100 (nota de duração de 100 ms)
	li a2,35		# a2 = 35 (timbre "electric bass")
	li a3,50		# a3 = 50 (volume da nota)
	li a7,31		# a7 = 31 (carrega em a7 o ecall "MidiOut")
	ecall			# realiza o ecall
	
	li a0,71		# a0 = 71 (carrega si para a0)
	li a1,100		# a1 = 100 (nota de duração de 100 ms)
	li a2,32		# a2 = 32 (timbre "guitar harmonic")
	li a3,50		# a3 = 50 (volume da nota)
	li a7,31		# a7 = 31 (carrega em a7 o ecall "MidiOut")
	ecall			# realiza o ecall
	
	li a0,76		# a0 = 76 (carrega mi para a0)
	li a1,100		# a1 = 100 (nota de duração de 100 ms)
	li a2,32		# a2 = 32 (timbre "guitar harmonic")
	li a3,50		# a3 = 50 (volume da nota)
	li a7,31		# a7 = 31 (carrega em a7 o ecall "MidiOut")
	ecall			# realiza o ecall
	
	addi t3,t3,-1		# t3 = t3 - 1 (reduz o contador de linhas/colunas analisadas)
	beq t3,zero,DELPNT	# se t3 = 0, vá para DELPNT (se o ponto foi encontrado na última linha/coluna analisada, deve-se apagar o restante do ponto)
	j DELETE		# pule para DELETE (se o ponto foi encontrado nas 3 primeiras linhas/colunas, apenas mova o Robozinho)

DELPNT:	li t3,1			# carrega 1 para t3
  	beq s3,t3,DELLFT	# se s3 for igual a 1 (valor de movimento atual para a esquerda), vá para DELLFT
  	
  	li t3,2			# carrega 2 para t3
  	beq s3,t3,DELUP		# se s3 for igual a 2 (valor de movimento atual para cima), vá para DELUP
  	
  	li t3,3  		# carrega 3 para t3
	beq s3,t3,DELDWN	# se s3 for igual a 3 (valor de movimento atual para baixo), vá para DELDWN
	
	li t3,4  		# carrega 4 para t3
	beq s3,t3,DELRGHT	# se s3 for igual a 4 (valor de movimento atual para a direita), vá para DELRGHT
	
DELLFT: addi t1,t1,-1		# t1 = t1 - 1 (carrega o endereço do pixel inferior esquerdo do ponto detectado)
	sb zero,0(t1)		# grava 0 no conteúdo do endereço t1 (apaga o pixel carregado anteriormente da memoria VGA/tela)
	addi t1,t1,-320		# t1 = t1 - 320 (carrega o endereço do pixel superior esquerdo do ponto detectado)
	sb zero,0(t1)		# grava 0 no conteúdo do endereço t1 (apaga o pixel carregado anteriormente da memoria VGA/tela)
	
	li t3,0xFF000000	# t3 = 0xFF000000 (carrega em t3 o endereço base da memoria VGA)
	sub t3,t1,t3		# t3 = t1 - 0xFF000000 (subtrai o endereço base de t1, posição do pixel a ser apagado)
	
	li t4,1
	beq s6,t4,DELL1
	la t5,mapa2
	j DELL2
	
DELL1:	la t5,mapa1		# carrega em t5 o endereço dos dados do mapa1 
DELL2:	addi t5,t5,8		# t5 = endereço do primeiro pixel do mapa1 (depois das informações de nlin ncol)
	add t5,t5,t3		# t5 = t5 + t3 (carrega em t5 o endereço do pixel do mapa1 a ser apagado) 
	sb zero,0(t5)		# grava 0 no conteúdo do endereço t5 (apaga o pixel carregado anteriormente do mapa1 no segmento de dados)
		
	addi t1,t1,320		# t1 = t1 + 320 (carrega o endereço do pixel inferior esquerdo do ponto detectado)
	li t3,0xFF000000	# t3 = 0xFF000000 (carrega em t3 o endereço base da memoria VGA)
	sub t3,t1,t3		# t3 = t1 - 0xFF000000 (subtrai o endereço base de t1, posição do pixel a ser apagado)
	
	li t4,1
	beq s6,t4,DELL3
	la t5,mapa2
	j DELL4
	
DELL3:	la t5,mapa1		# carrega em t5 o endereço dos dados do mapa1 
DELL4:	addi t5,t5,8		# t5 = endereço do primeiro pixel do mapa1 (depois das informações de nlin ncol)
	add t5,t5,t3		# t5 = t5 + t3 (carrega em t5 o endereço do pixel do mapa1 a ser apagado)
	sb zero,0(t5)		# grava 0 no conteúdo do endereço t5 (apaga o pixel carregado anteriormente do mapa1 no segmento de dados)
	
	j DELETE 		# pule para DELETE
	
DELUP:	addi t1,t1,-320		# t1 = t1 - 320 (carrega o endereço do pixel superior esquerdo do ponto detectado)
	sb zero,0(t1)		# grava 0 no conteúdo do endereço t1 (apaga o pixel carregado anteriormente da memoria VGA/tela)
	addi t1,t1,1		# t1 = t1 + 1 (carrega o endereço do pixel superior direito do ponto detectado)
	sb zero,0(t1)		# grava 0 no conteúdo do endereço t1 (apaga o pixel carregado anteriormente da memoria VGA/tela)
	
	li t3,0xFF000000	# t3 = 0xFF000000 (carrega em t3 o endereço base da memoria VGA)
	sub t3,t1,t3		# t3 = t1 - 0xFF000000 (subtrai o endereço base de t1, posição do pixel a ser apagado)
	
	li t4,1
	beq s6,t4,DELU1
	la t5,mapa2
	j DELU2
	
DELU1:	la t5,mapa1		# carrega em t5 o endereço dos dados do mapa1 
DELU2:	addi t5,t5,8		# t5 = endereço do primeiro pixel do mapa1 (depois das informações de nlin ncol)
	add t5,t5,t3		# t5 = t5 + t3 (carrega em t5 o endereço do pixel do mapa1 a ser apagado) 
	sb zero,0(t5)		# grava 0 no conteúdo do endereço t5 (apaga o pixel carregado anteriormente do mapa1 no segmento de dados)
	
	addi t1,t1,-1		# t1 = t1 - 1 (carrega o endereço do pixel superior esquerdo do ponto detectado)
	li t3,0xFF000000	# t3 = 0xFF000000 (carrega em t3 o endereço base da memoria VGA)
	sub t3,t1,t3		# t3 = t1 - 0xFF000000 (subtrai o endereço base de t1, posição do pixel a ser apagado)
	
	li t4,1
	beq s6,t4,DELU3
	la t5,mapa2
	j DELU4
	
DELU3:	la t5,mapa1		# carrega em t5 o endereço dos dados do mapa1 
DELU4:	addi t5,t5,8		# t5 = endereço do primeiro pixel do mapa1 (depois das informações de nlin ncol)
	add t5,t5,t3		# t5 = t5 + t3 (carrega em t5 o endereço do pixel do mapa1 a ser apagado)
	sb zero,0(t5)		# grava 0 no conteúdo do endereço t5 (apaga o pixel carregado anteriormente do mapa1 no segmento de dados)
	
	j DELETE 		# pule para DELETE
	
DELDWN:	addi t1,t1,320		# t1 = t1 + 320 (carrega o endereço do pixel inferior esquerdo do ponto detectado)
	sb zero,0(t1)		# grava 0 no conteúdo do endereço t1 (apaga o pixel carregado anteriormente da memoria VGA/tela)
	addi t1,t1,1		# t1 = t1 + 1 (carrega o endereço do pixel inferior direito do ponto detectado)
	sb zero,0(t1)		# grava 0 no conteúdo do endereço t1 (apaga o pixel carregado anteriormente da memoria VGA/tela)
	
	li t3,0xFF000000	# t3 = 0xFF000000 (carrega em t3 o endereço base da memoria VGA)
	sub t3,t1,t3		# t3 = t1 - 0xFF000000 (subtrai o endereço base de t1, posição do pixel a ser apagado)
	
	li t4,1
	beq s6,t4,DELD1
	la t5,mapa2
	j DELD2
	
DELD1:	la t5,mapa1		# carrega em t5 o endereço dos dados do mapa1 
DELD2:	addi t5,t5,8		# t5 = endereço do primeiro pixel do mapa1 (depois das informações de nlin ncol)
	add t5,t5,t3		# t5 = t5 + t3 (carrega em t5 o endereço do pixel do mapa1 a ser apagado) 
	sb zero,0(t5)		# grava 0 no conteúdo do endereço t5 (apaga o pixel carregado anteriormente do mapa1 no segmento de dados)
	
	addi t1,t1,-1		# t1 = t1 - 1 (carrega o endereço do pixel inferior esquerdo do ponto detectado)
	li t3,0xFF000000	# t3 = 0xFF000000 (carrega em t3 o endereço base da memoria VGA)
	sub t3,t1,t3		# t3 = t1 - 0xFF000000 (subtrai o endereço base de t1, posição do pixel a ser apagado)
	
	li t4,1
	beq s6,t4,DELD3
	la t5,mapa2
	j DELD4
	
DELD3:	la t5,mapa1		# carrega em t5 o endereço dos dados do mapa1 
DELD4:	addi t5,t5,8		# t5 = endereço do primeiro pixel do mapa1 (depois das informações de nlin ncol)
	add t5,t5,t3		# t5 = t5 + t3 (carrega em t5 o endereço do pixel do mapa1 a ser apagado)
	sb zero,0(t5)		# grava 0 no conteúdo do endereço t5 (apaga o pixel carregado anteriormente do mapa1 no segmento de dados)
	
	j DELETE 		# pule para DELETE

DELRGHT:addi t1,t1,1		# t1 = t1 + 1 (carrega o endereço do pixel inferior direito do ponto detectado)
	sb zero,0(t1)		# grava 0 no conteúdo do endereço t1 (apaga o pixel carregado anteriormente da memoria VGA/tela)
	addi t1,t1,-320		# t1 = t1 + 1 (carrega o endereço do pixel superior direito do ponto detectado)
	sb zero,0(t1)		# grava 0 no conteúdo do endereço t1 (apaga o pixel carregado anteriormente da memoria VGA/tela)
	
	li t3,0xFF000000	# t3 = 0xFF000000 (carrega em t3 o endereço base da memoria VGA)
	sub t3,t1,t3		# t3 = t1 - 0xFF000000 (subtrai o endereço base de t1, posição do pixel a ser apagado)
	
	li t4,1
	beq s6,t4,DELR1
	la t5,mapa2
	j DELR2
	
DELR1:	la t5,mapa1		# carrega em t5 o endereço dos dados do mapa1 
DELR2:	addi t5,t5,8		# t5 = endereço do primeiro pixel do mapa1 (depois das informações de nlin ncol)
	add t5,t5,t3		# t5 = t5 + t3 (carrega em t5 o endereço do pixel do mapa1 a ser apagado) 
	sb zero,0(t5)		# grava 0 no conteúdo do endereço t5 (apaga o pixel carregado anteriormente do mapa1 no segmento de dados)
	
	addi t1,t1,320		# t1 = t1 + 320 (carrega o endereço do pixel inferior direito do ponto detectado)
	li t3,0xFF000000	# t3 = 0xFF000000 (carrega em t3 o endereço base da memoria VGA)
	sub t3,t1,t3		# t3 = t1 - 0xFF000000 (subtrai o endereço base de t1, posição do pixel a ser apagado)
	
	li t4,1
	beq s6,t4,DELR3
	la t5,mapa2
	j DELR4
	
DELR3:	la t5,mapa1		# carrega em t5 o endereço dos dados do mapa1 
DELR4:	addi t5,t5,8		# t5 = endereço do primeiro pixel do mapa1 (depois das informações de nlin ncol)
	add t5,t5,t3		# t5 = t5 + t3 (carrega em t5 o endereço do pixel do mapa1 a ser apagado)
	sb zero,0(t5)		# grava 0 no conteúdo do endereço t5 (apaga o pixel carregado anteriormente do mapa1 no segmento de dados)
	
	j DELETE 		# pule para DELETE
	
SPRPNT:	addi s1,s1,1		# incrementa o contador de pontos (a sessão a seguir toca uma triade de mi maior para cada ponto coletado)
	
	li s0,-1
	
	la t0,CONTADOR_ASSUSTADO
	li t3,-1		
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
	li a1,100		# a1 = 100 (nota de duração de 100 ms)
	li a2,35		# a2 = 35 (timbre "electric bass")
	li a3,50		# a3 = 50 (volume da nota)
	li a7,31		# a7 = 31 (carrega em a7 o ecall "MidiOut")
	ecall			# realiza o ecall
	
	li a0,59		# a0 = 59 (carrega si para a0)
	li a1,100		# a1 = 100 (nota de duração de 100 ms)
	li a2,32		# a2 = 32 (timbre "guitar harmonic")
	li a3,50		# a3 = 50 (volume da nota)
	li a7,31		# a7 = 31 (carrega em a7 o ecall "MidiOut")
	ecall			# realiza o ecall
	
	li a0,64		# a0 = 64 (carrega mi para a0)
	li a1,100		# a1 = 100 (nota de duração de 100 ms)
	li a2,32		# a2 = 32 (timbre "guitar harmonic")
	li a3,50		# a3 = 50 (volume da nota)
	li a7,31		# a7 = 31 (carrega em a7 o ecall "MidiOut")
	ecall			# realiza o ecall
	
	li t3,1			# carrega 1 para t3
  	beq s3,t3,DELLFTS	# se s3 for igual a 1 (valor de movimento atual para a esquerda), vá para DELLFT
  	
  	li t3,2			# carrega 2 para t3
  	beq s3,t3,DELUPS		# se s3 for igual a 2 (valor de movimento atual para cima), vá para DELUP
  	
  	li t3,3  		# carrega 3 para t3
	beq s3,t3,DELDWNS	# se s3 for igual a 3 (valor de movimento atual para baixo), vá para DELDWN
	
	li t3,4  		# carrega 4 para t3
	beq s3,t3,DELRGHTS	# se s3 for igual a 4 (valor de movimento atual para a direita), vá para DELRGHT
	
DELLFTS: 
	addi t1,t1,-3		# t1 = t1 - 1 (carrega o endereço do pixel inferior esquerdo do ponto detectado)
	la t3,vertpoint		# carrega a imagem que vai sobrepor o robozinho com pixels pretos
	addi t3,t3,8		# t3 = endereço do primeiro pixel da imagem (depois das informações de nlin ncol)

	li t5,0	
	li t6,4			# reinicia o contador para 16 quebras de linha
	
	li t4,960		# t4 = 5120
	sub t1,t1,t4		# volta t1 16 linhas (pixel inicial da primeira linha)
	mv t2,t1 		# t2 = POS_ROBOZINHO	
	addi t2,t2,2		# t2 = POS_ROBOZINHO + 16 (pixel final da primeira linha)
	
	mv t0,t1		# t0 = t1
	li t4,0xFF000000	# t4 = 0xFF000000 (carrega em t4 o endereço base da memoria VGA)
	sub t0,t0,t4		# t0 = t0 - 0xFF000000 (subtrai o endereço base de t0, posição atual do Robozinho)
	li t4,1
	beq s6,t4,LOAD1L
	la t4,mapa2
	j LOAD2L
LOAD1L:	la t4,mapa1		# carrega em t4 o endereço dos dados do mapa1
LOAD2L:	addi t4,t4,8		# t4 = endereço do primeiro pixel do mapa1 (depois das informações de nlin ncol)
	add t4,t4,t0		# t4 = t4 + t0 (carrega em t4 o endereço do pixel do mapa1 no segmento de dados sobre o qual o Robozinho esta localizado)
	
	
DELLOOPL:beq t1,t2,ENTER2L	# se t1 atingir o fim da linha de pixels, quebre linha
	lb t0,0(t3)		# le um byte de "Robozinho1preto" para t0
	sb t0,0(t1)		# escreve o byte (pixel preto\invisivel) na memória VGA
	sb t0,0(t4)
	
	addi t1,t1,1		# soma 1 ao endereço t1
	addi t3,t3,1		# soma 1 ao endereço t3
	addi t4,t4,1		# soma 1 ao endereço t4
	j DELLOOPL		# volta a verificar a condiçao do loop
	
ENTER2L:addi t1,t1,318		# t1 pula para o pixel inicial da linha de baixo na memoria VGA
	addi t4,t4,318		# t4 pula para o pixel inicial da linha de baixo no segmento de dados
	addi t2,t2,320		# t2 pula para o pixel final da linha de baixo na memoria VGA
	addi t5,t5,1          	# atualiza o contador de quebras de linha
	beq t5,t6,DELETE	# termina o carregamento da imagem se 16 quebras de linha ocorrerem
	j DELLOOPL		# pula para delloop
	
DELUPS:	la t3,horpoint		# carrega a imagem que vai sobrepor o robozinho com pixels pretos
	addi t3,t3,8		# t3 = endereço do primeiro pixel da imagem (depois das informações de nlin ncol)

	li t5,0	
	li t6,2			# reinicia o contador para 16 quebras de linha
	
	li t4,960		# t4 = 5120
	sub t1,t1,t4		# volta t1 16 linhas (pixel inicial da primeira linha)
	mv t2,t1 		# t2 = POS_ROBOZINHO	
	addi t2,t2,4		# t2 = POS_ROBOZINHO + 16 (pixel final da primeira linha)
	
	mv t0,t1		# t0 = t1
	li t4,0xFF000000	# t4 = 0xFF000000 (carrega em t4 o endereço base da memoria VGA)
	sub t0,t0,t4		# t0 = t0 - 0xFF000000 (subtrai o endereço base de t0, posição atual do Robozinho)
	li t4,1
	beq s6,t4,LOAD1U
	la t4,mapa2
	j LOAD2U
LOAD1U:	la t4,mapa1		# carrega em t4 o endereço dos dados do mapa1
LOAD2U:	addi t4,t4,8		# t4 = endereço do primeiro pixel do mapa1 (depois das informações de nlin ncol)
	add t4,t4,t0		# t4 = t4 + t0 (carrega em t4 o endereço do pixel do mapa1 no segmento de dados sobre o qual o Robozinho esta localizado)
	
	
DELLOOPU:beq t1,t2,ENTER2U	# se t1 atingir o fim da linha de pixels, quebre linha
	lb t0,0(t3)		# le um byte de "Robozinho1preto" para t0
	sb t0,0(t1)		# escreve o byte (pixel preto\invisivel) na memória VGA
	sb t0,0(t4)
	
	addi t1,t1,1		# soma 1 ao endereço t1
	addi t3,t3,1		# soma 1 ao endereço t3
	addi t4,t4,1		# soma 1 ao endereço t4
	j DELLOOPU		# volta a verificar a condiçao do loop
	
ENTER2U:addi t1,t1,316		# t1 pula para o pixel inicial da linha de baixo na memoria VGA
	addi t4,t4,316		# t4 pula para o pixel inicial da linha de baixo no segmento de dados
	addi t2,t2,320		# t2 pula para o pixel final da linha de baixo na memoria VGA
	addi t5,t5,1          	# atualiza o contador de quebras de linha
	beq t5,t6,DELETE	# termina o carregamento da imagem se 16 quebras de linha ocorrerem
	j DELLOOPU		# pula para delloop
	
DELDWNS:la t3,horpoint		# carrega a imagem que vai sobrepor o robozinho com pixels pretos
	addi t3,t3,8		# t3 = endereço do primeiro pixel da imagem (depois das informações de nlin ncol)

	li t5,0	
	li t6,2			# reinicia o contador para 16 quebras de linha
	
	li t4,640		# t4 = 5120
	add t1,t1,t4		# volta t1 16 linhas (pixel inicial da primeira linha)
	mv t2,t1 		# t2 = POS_ROBOZINHO	
	addi t2,t2,4		# t2 = POS_ROBOZINHO + 16 (pixel final da primeira linha)
	
	mv t0,t1		# t0 = t1
	li t4,0xFF000000	# t4 = 0xFF000000 (carrega em t4 o endereço base da memoria VGA)
	sub t0,t0,t4		# t0 = t0 - 0xFF000000 (subtrai o endereço base de t0, posição atual do Robozinho)
	li t4,1
	beq s6,t4,LOAD1D
	la t4,mapa2
	j LOAD2D
LOAD1D:	la t4,mapa1		# carrega em t4 o endereço dos dados do mapa1
LOAD2D:	addi t4,t4,8		# t4 = endereço do primeiro pixel do mapa1 (depois das informações de nlin ncol)
	add t4,t4,t0		# t4 = t4 + t0 (carrega em t4 o endereço do pixel do mapa1 no segmento de dados sobre o qual o Robozinho esta localizado)
	
	
DELLOOPD:beq t1,t2,ENTER2D	# se t1 atingir o fim da linha de pixels, quebre linha
	lb t0,0(t3)		# le um byte de "Robozinho1preto" para t0
	sb t0,0(t1)		# escreve o byte (pixel preto\invisivel) na memória VGA
	sb t0,0(t4)
	
	addi t1,t1,1		# soma 1 ao endereço t1
	addi t3,t3,1		# soma 1 ao endereço t3
	addi t4,t4,1		# soma 1 ao endereço t4
	j DELLOOPU		# volta a verificar a condiçao do loop
	
ENTER2D:addi t1,t1,316		# t1 pula para o pixel inicial da linha de baixo na memoria VGA
	addi t4,t4,316		# t4 pula para o pixel inicial da linha de baixo no segmento de dados
	addi t2,t2,320		# t2 pula para o pixel final da linha de baixo na memoria VGA
	addi t5,t5,1          	# atualiza o contador de quebras de linha
	beq t5,t6,DELETE	# termina o carregamento da imagem se 16 quebras de linha ocorrerem
	j DELLOOPD		# pula para delloop

DELRGHTS:
	addi t1,t1,2		# t1 = t1 - 1 (carrega o endereço do pixel inferior esquerdo do ponto detectado)
	la t3,vertpoint		# carrega a imagem que vai sobrepor o robozinho com pixels pretos
	addi t3,t3,8		# t3 = endereço do primeiro pixel da imagem (depois das informações de nlin ncol)

	li t5,0	
	li t6,4			# reinicia o contador para 16 quebras de linha
	
	li t4,960		# t4 = 5120
	sub t1,t1,t4		# volta t1 16 linhas (pixel inicial da primeira linha)
	mv t2,t1 		# t2 = POS_ROBOZINHO	
	addi t2,t2,2		# t2 = POS_ROBOZINHO + 16 (pixel final da primeira linha)
	
	mv t0,t1		# t0 = t1
	li t4,0xFF000000	# t4 = 0xFF000000 (carrega em t4 o endereço base da memoria VGA)
	sub t0,t0,t4		# t0 = t0 - 0xFF000000 (subtrai o endereço base de t0, posição atual do Robozinho)
	li t4,1
	beq s6,t4,LOAD1R
	la t4,mapa2
	j LOAD2R
LOAD1R:	la t4,mapa1		# carrega em t4 o endereço dos dados do mapa1
LOAD2R:	addi t4,t4,8		# t4 = endereço do primeiro pixel do mapa1 (depois das informações de nlin ncol)
	add t4,t4,t0		# t4 = t4 + t0 (carrega em t4 o endereço do pixel do mapa1 no segmento de dados sobre o qual o Robozinho esta localizado)
	
	
DELLOOPR:beq t1,t2,ENTER2R	# se t1 atingir o fim da linha de pixels, quebre linha
	lb t0,0(t3)		# le um byte de "Robozinho1preto" para t0
	sb t0,0(t1)		# escreve o byte (pixel preto\invisivel) na memória VGA
	sb t0,0(t4)
	
	addi t1,t1,1		# soma 1 ao endereço t1
	addi t3,t3,1		# soma 1 ao endereço t3
	addi t4,t4,1		# soma 1 ao endereço t4
	j DELLOOPR		# volta a verificar a condiçao do loop
	
ENTER2R:addi t1,t1,318		# t1 pula para o pixel inicial da linha de baixo na memoria VGA
	addi t4,t4,318		# t4 pula para o pixel inicial da linha de baixo no segmento de dados
	addi t2,t2,320		# t2 pula para o pixel final da linha de baixo na memoria VGA
	addi t5,t5,1          	# atualiza o contador de quebras de linha
	beq t5,t6,DELETE	# termina o carregamento da imagem se 16 quebras de linha ocorrerem
	j DELLOOPR		# pula para delloop
	
# Printa preto em cima da posição do personagem (apaga o personagem anterior)
	
DELETE:	la t3,Robozinho1preto	# carrega a imagem que vai sobrepor o robozinho com pixels pretos
	addi t3,t3,8		# t3 = endereço do primeiro pixel da imagem (depois das informações de nlin ncol)

	li t5,0	
	li t6,16		# reinicia o contador para 16 quebras de linha
	
	li t4,5120		# t4 = 5120
	la t0,POS_ROBOZINHO	# carrega o endereço de "POS_ROBOZINHO" no registrador t0
	lw t1,0(t0)		# le a word guardada em "POS_ROBOZINHO" para t1 (t1 = posição atual do Robozinho)
	sub t1,t1,t4		# volta t1 16 linhas (pixel inicial da primeira linha)
	mv t2,t1 		# t2 = POS_ROBOZINHO	
	addi t2,t2,16		# t2 = POS_ROBOZINHO + 16 (pixel final da primeira linha)
	
	mv t0,t1		# t0 = t1
	li t4,0xFF000000	# t4 = 0xFF000000 (carrega em t4 o endereço base da memoria VGA)
	sub t0,t0,t4		# t0 = t0 - 0xFF000000 (subtrai o endereço base de t0, posição atual do Robozinho)
	li t4,1
	beq s6,t4,LOAD1
	la t4,mapa2
	j LOAD2
LOAD1:	la t4,mapa1		# carrega em t4 o endereço dos dados do mapa1
LOAD2:	addi t4,t4,8		# t4 = endereço do primeiro pixel do mapa1 (depois das informações de nlin ncol)
	add t4,t4,t0		# t4 = t4 + t0 (carrega em t4 o endereço do pixel do mapa1 no segmento de dados sobre o qual o Robozinho esta localizado)
	
	
DELLOOP:beq t1,t2,ENTER2	# se t1 atingir o fim da linha de pixels, quebre linha
	lb t0,0(t3)		# le um byte de "Robozinho1preto" para t0
	sb t0,0(t1)		# escreve o byte (pixel preto\invisivel) na memória VGA
	
	li a5,199		# a5 = 199 (valor de um pixel invisivel)
	bgeu t0, a5, INVSBL	# se t0 >= 199, ou seja, se t0 for um pixel invisivel, pule para INVSBL (note que t0 nunca sera realmente maior que 199, mas não existe "bequ")
	sb t0,0(t4)		# se t0 < 199, ou seja, se t0 for um pixel preto, escreve o byte (pixel preto) no endereço t4 do mapa1 no segmento de dados 
	
INVSBL:	addi t1,t1,1		# soma 1 ao endereço t1
	addi t3,t3,1		# soma 1 ao endereço t3
	addi t4,t4,1		# soma 1 ao endereço t4
	j DELLOOP		# volta a verificar a condiçao do loop
	
ENTER2:	addi t1,t1,304		# t1 pula para o pixel inicial da linha de baixo na memoria VGA
	addi t4,t4,304		# t4 pula para o pixel inicial da linha de baixo no segmento de dados
	addi t2,t2,320		# t2 pula para o pixel final da linha de baixo na memoria VGA
	addi t5,t5,1          	# atualiza o contador de quebras de linha
	beq t5,t6,VERIFY	# termina o carregamento da imagem se 16 quebras de linha ocorrerem
	j DELLOOP		# pula para delloop 
	
# Verifica qual a tecla pressionada para movimentar o Robozinho
	
VERIFY: addi s0,s0,1		# incrementa o contador de estados do Robozinho (se s0 for par -> Robozinho1; se s0 for impar -> Robozinho2)

	li t0,2			# t0 = 2
	rem t1,s0,t0		# t1 = resto da divisão s0/2 
	beq t1,zero,MI		# se t1 = 0 (se s0 for par), vá para MI (toque a nota MI)
	
	li a0,34		# a0 = 34 (carrega si bemol para a0)
	li a1,100		# a1 = 100 (nota de duração de 100 ms)
	li a2,33		# a2 = 33 (timbre "acoustic bass")
	li a3,90		# a3 = 90 (volume da nota)
	li a7,31		# a7 = 31 (carrega em a7 o ecall "MidiOut")
	ecall			# realiza o ecall
	
	j SIB			# pule para SIB (acaba de tocar a nota SIb)
	
MI:	li a0,40		# a0 = 40 (carrega mi para a0)
	li a1,100		# a1 = 100 (nota de duração de 100 ms)
	li a2,33		# a2 = 33 (timbre "acoustic bass")
	li a3,90		# a3 = 90 (volume da nota)
	li a7,31		# a7 = 31 (carrega em a7 o ecall "MidiOut")
	ecall			# realiza o ecall

SIB:	li t0,1			# carrega 1 para t0
  	beq s3,t0,MOVLFT	# se s3 for igual a 1 (valor de movimento atual para a esquerda), vá para MOVLFT
  	
  	li t0,2			# carrega 2 para t0
  	beq s3,t0,MOVUP		# se s3 for igual a 2 (valor de movimento atual para cima), vá para MOVUP
  	
  	li t0,3  		# carrega 3 para t0
	beq s3,t0,MOVDWN	# se s3 for igual a 3 (valor de movimento atual para baixo), vá para MOVDWN
	
	li t0,4  		# carrega 4 para t0
	beq s3,t0,MOVRGHT	# se s3 for igual a 4 (valor de movimento atual para a direita), vá para MOVRGHT
	
# Carrega em t2 o offset correspondente a cada direção de movimento
	
MOVLFT: li t2,5124		# t2 = 5124 (volta t1 16 linhas e vai 4 pixels para a esquerda -> pixel inicial - 4) 
	j MOVROB		# pule para MOVROB (movimenta o Robozinho)

MOVUP:	li t2,6400		# t2 = 6400 (volta t1 20 linhas -> pixel inicial 4 linhas acima)
	j MOVROB		# pule para MOVROB (movimenta o Robozinho)

MOVDWN:	li t2,3840		# t2 = 3840 (volta t1 12 linhas -> pixel inicial 4 linhas abaixo)
	j MOVROB		# pule para MOVROB (movimenta o Robozinho)

MOVRGHT:li t2,5116		# t2 = 5116 (volta t1 16 linhas e vai 4 pixels para a direita -> pixel inicial + 4)
	j MOVROB		# pule para MOVROB (movimenta o Robozinho)
		
# Printa o personagem de acordo com sua direção atual de movimento (definida pelo registrador t2)	
	
MOVROB:	la t0,POS_ROBOZINHO	# carrega o endereço de "POS_ROBOZINHO" no registrador t0
	lw t1,0(t0)		# le a word guardada em "POS_ROBOZINHO" para t1 (t1 = posição atual do Robozinho)
	sub t1,t1,t2		# volta t1 16 linhas e vai 4 pixels pra frente (pixel inicial + 4) 
	mv t2,t1 		# t2 = t1
	addi t2,t2,16		# t2 = t2 + 16 (pixel final da primeira linha + 4)
	
	li t4,2			# t4 = 2 (para verificar a paridade de s0)
	rem t3,s0,t4		# t3 = resto da divisão inteira s0/2
	
	la t0,CONTADOR_ASSUSTADO
	lw t5,0(t0)
	li t0,-1
	
	beq t3,zero,PAR3	# se t3 = 0, va para PAR3 (se s0 for par, imprime o Robozinho1, se for impar, imprime o Robozinho2)

	beq t5,t0,FRACO2
	la t3,Robozinho2forte
	j NEXT3
	
FRACO2:	la t3,Robozinho2	# t3 = endereço dos dados do Robozinho2 (boca aberta)
	j NEXT3			# pula para NEXT3
	
PAR3:	beq t5,t0,FRACO1
	la t3,Robozinho1forte
	j NEXT3
	
FRACO1:	la t3,Robozinho1	# t3 = endereço dos dados do Robozinho1 (boca fechada)
	
NEXT3:	addi t3,t3,8		# t3 = endereço do primeiro pixel da imagem (depois das informações de nlin ncol)

	li t5,0
	li t6,16		# reinicia contador para 16 quebras de linha	
	
LOOP3: 	beq t1,t2,ENTER3	# se t1 atingir o fim da linha de pixels, quebre linha
	lw t0,0(t3)		# le uma word do endereço t3 (le 4 pixels da imagem)
	sw t0,0(t1)		# escreve a word na memória VGA no endereço t1 (desenha 4 pixels na tela do Bitmap Display)
	addi t1,t1,4		# soma 4 ao endereço t1
	addi t3,t3,4		# soma 4 ao endereço t3
	j LOOP3			# volta a verificar a condiçao do loop
	
ENTER3:	addi t1,t1,304		# t1 pula para o pixel inicial da linha de baixo
	addi t2,t2,320		# t2 pula para o pixel final da linha de baixo
	addi t5,t5,1            # atualiza o contador de quebras de linha
	beq t5,t6,FIMMOV	# termine o carregamento da imagem se 16 quebras de linha ocorrerem
	j LOOP3			# pula para loop 3
	
# Se o Robozinho tiver se movimentado, espera 80 ms para a próxima iteração (visa reduzir a velocidade do Robozinho)
    
FIMMOV:	la t0, POS_ROBOZINHO    # carrega o endereço de "POS_ROBOZINHO" no registrador t0 
    	sw t1, 0(t0)       	# guarda a word armazenada em t1 (posição atual do Roboziho) em "POS_ROBOZINHO"
    	
	j MAINL			# retorna ao loop principal
	
# Se o Robozinho não tiver se movimentado, espera 2 ms para a próxima iteração (visa reduzir o "flick" do contador de pontos)
	
FIM:	j MAINL			# retorna ao loop principal

###########################
##### DADOS DA FASE 2 #####
###########################

FASE2:  li s6,2

	li a0,3000
	li a7,32           	# define a chamada de syscal para pausa
   	ecall               	# realiza uma pausa de 3 s
   	
# Carrega a imagem1 (mapa2) no frame 0
	
IMG1_2:	la t4, mapa2		# t4 cerrega endereÃ§o do mapa a fim de comparaÃ§Ã£o
	li s1,0xFF000000	# s1 = endereco inicial da Memoria VGA - Frame 0
	li s2,0xFF012C00	# s2 = endereco final da Memoria VGA - Frame 0
	la s0,mapa2		# s0 = endereÃ§o dos dados do mapa 1
	mv t3, s0		# t3 = endereÃ§o inicial armazenado a fins de comparaÃ§Ã£o
	addi s0,s0,8		# s0 = endereÃ§o do primeiro pixel da imagem (depois das informaÃ§Ãµes de nlin ncol)
	
LOOP1_2: 
	beq s1,s2,IMAGEM_2	# se s1 = Ãºltimo endereÃ§o da Memoria VGA, saia do loop
	lw t0,0(s0)		# le uma word do endereÃ§o s0 (le 4 pixels da imagem)
	sw t0,0(s1)		# escreve a word na memÃ³ria VGA no endereÃ§o s1 (desenha 4 pixels na tela do Bitmap Display)
	addi s1,s1,4		# soma 4 ao endereÃ§o s1 
	addi s0,s0,4		# soma 4 ao endereÃ§o s0
	j LOOP1_2		# volta a verificar a condiÃ§ao do loop

# Carrega a imagem2 (Robozinho1 - imagem 16x16) no frame 0

IMG2_2:	li s1,0xFF00A0C8	# s1 = endereco inicial da primeira linha do Robozinho - Frame 0
	li s2,0xFF00A0D8	# s2 = endereco final da primeira linha do Robozinho (inicial +16) - Frame 0
	la s0,Robozinho1	# s0 = endereÃ§o dos dados do Robozinho1 (boca fechada)
	mv t3, s0		# t3 = endereÃ§o inicial armazenado a fins de comparaÃ§Ã£o
	addi s0,s0,8		# s0 = endereÃ§o do primeiro pixel da imagem (depois das informaÃ§Ãµes de nlin ncol)
	j PRINT16_2
	
# Carrega a imagem3 (ALIEN1 - imagem16x16)

IMG3_2:	li s1,0xFF0064C8	# s1 = endereco inicial da primeira linha do alien 1 - Frame 0 
	li s2,0xFF0064D8	# s2 = endereco final da primeira linha do alien 1 (inicial +16) - Frame 0      
	la s0,Inimigo1          # s0 = endereÃ§o dos dados do alien1
	mv t3, s0		# t3 = endereÃ§o inicial armazenado a fins de comparaÃ§Ã£o
	addi s0,s0,8		# s0 = endereÃ§o do primeiro pixel da imagem (depois das informaÃ§Ãµes de nlin ncol)
	j PRINT16_2
	
# Carrega a imagem4 (ALIEN2 - imagem16x16)

IMG4_2:	li s1,0xFF0087C8	# s1 = endereco inicial da primeira linha do alien 2 - Frame 0
	li s2,0xFF0087D8	# s2 = endereco final da primeira linha do alien 2 - Frame 0
	la s0,Inimigo2          # s0 = endereÃ§o dos dados do alien2
	mv t3, s0		# t3 = endereÃ§o inicial armazenado a fins de comparaÃ§Ã£o
	addi s0,s0,8		# s0 = endereÃ§o do primeiro pixel da imagem (depois das informaÃ§Ãµes de nlin ncol)
	j PRINT16_2

# Carrega a imagem5 (ALIEN3 - imagem16x16)

IMG5_2:	li s1,0xFF0087B8	# s1 = endereco inicial da primeira linha do alien 3 - Frame 0
	li s2,0xFF0087C8	# s2 = endereco final da primeira linha do alien 3 - Frame 0
	la s0,Inimigo3          # s0 = endereÃ§o dos dados do alien3
	mv t3, s0		# t3 = endereÃ§o inicial armazenado a fins de comparaÃ§Ã£o
	addi s0,s0,8		# s0 = endereÃ§o do primeiro pixel da imagem (depois das informaÃ§Ãµes de nlin ncol)
	j PRINT16_2
	
# Carrega a imagem6 (ALIEN4 - imagem16x16)

IMG6_2:	li s1,0xFF0087D8	# s1 = endereco inicial da primeira linha do alien 4 - Frame 0
	li s2,0xFF0087E8	# s2 = endereco final da primeira linha do alien 4 - Frame 0
	la s0, Inimigo4         # s0 = endereÃ§o dos dados do alien4 
	mv t3, s0		# t3 = endereÃ§o inicial armazenado a fins de comparaÃ§Ã£o
	addi s0,s0,8		# s0 = endereÃ§o do primeiro pixel da imagem (depois das informaÃ§Ãµes de nlin ncol)
	j PRINT16_2
	
# Carrega a imagem7 (mapa1 - colisao) no frame 1
	
IMG7_2:	li s1,0xFF100000	# s1 = endereco inicial da Memoria VGA - Frame 1
	li s2,0xFF112C00	# s2 = endereco final da Memoria VGA - Frame 1
	la s0,mapa2colisao	# s0 = endereÃ§o dos dados da colisao do mapa 1
	mv t3, s0		# t3 = endereÃ§o inicial armazenado a fins de comparaÃ§Ã£o
	addi s0,s0,8		# s0 = endereÃ§o do primeiro pixel da imagem (depois das informaÃ§Ãµes de nlin ncol)
	
LOOPCOL_2:
	beq s1,s2,SETUP_MAIN_2	# se s1 = Ãºltimo endereÃ§o da Memoria VGA, saia do loop
	lw t0,0(s0)		# le uma word do endereÃ§o s0 (le 4 pixels da imagem)
	sw t0,0(s1)		# escreve a word na memÃ³ria VGA no endereÃ§o s1 (desenha 4 pixels na tela do Bitmap Display)
	addi s1,s1,4		# soma 4 ao endereÃ§o s1 
	addi s0,s0,4		# soma 4 ao endereÃ§o s0
	j LOOPCOL_2		# volta a verificar a condiÃ§ao do loop
	
# Compara os endereÃ§os para ver qual a proxima imagem a ser printada

IMAGEM_2: 
	beq t3, t4, IMG2_2 	# se t3 contiver o endereÃ§o "mapa1", vÃ¡ para IMG2 (imprime a imagem2)
	
	la t4, Robozinho1	# t4 = endereÃ§o dos dados do Robozinho1
	beq t3, t4, IMG3_2	# se t3 contiver o endereÃ§o "Robozinho1", vÃ¡ para IMG3 (imprime a imagem3)
	
	la t4, Inimigo1		# t4 = endereÃ§o dos dados do alien 1
	beq t3, t4, IMG4_2	# se t3 contiver o endereÃ§o "Inimigo1", vÃ¡ para IMG4 (imprime a imagem4)
	
	la t4, Inimigo2		# t4 = endereÃ§o dos dados do alien 2
	beq t3, t4, IMG5_2	# se t3 contiver o endereÃ§o "Inimigo2", vÃ¡ para IMG5 (imprime a imagem5)
	
	la t4, Inimigo3		# t4 = endereÃ§o dos dados do alien 3
	beq t3, t4, IMG6_2	# se t3 contiver o endereÃ§o "Inimigo3", vÃ¡ para IMG6 (imprime a imagem6)
	
	la t4, Inimigo4		# t4 = endereÃ§o dos dados do alien 4
	beq t3, t4, IMG7_2	# se t3 contiver o endereÃ§o "Inimigo4", vÃ¡ para IMG7 (imprime a imagem7)	
	
# Loop que imprime imagens 16x16

PRINT16_2:
	li t1,0
	li t2,16		#inicializa o contador de quebra de linha para 16 quebras de linha
	
LOOP2_2: 	
	beq s1,s2,ENTER_2	# se s1 atingir o fim da linha de pixels, quebre linha
	lw t0,0(s0)		# le uma word do endereÃ§o s0 (le 4 pixels da imagem)
	sw t0,0(s1)		# escreve a word na memÃ³ria VGA no endereÃ§o s1 (desenha 4 pixels na tela do Bitmap Display)
	addi s1,s1,4		# soma 4 ao endereÃ§o s1
	addi s0,s0,4		# soma 4 ao endereÃ§o s0
	j LOOP2_2 		# volta a verificar a condiÃ§ao do loop
	
ENTER_2:	
	addi s1,s1,304		# s1 pula para o pixel inicial da linha de baixo
	addi s2,s2,320		# s2 pula para o pixel final da linha de baixo
	addi t1,t1,1          	# atualiza o contador de quebras de linha
	beq t1,t2,IMAGEM_2	# termina o carregamento da imagem se 17 quebras de linha ocorrerem
	j LOOP2_2
	
# Setup dos dados necessarios para o main loop

SETUP_MAIN_2:

	li s0,2			# s0 = 2 (zera o contador de movimentações do Robozinho)
	li s1,0			# s1 = 0 (zera o contador de pontos coletados)
	li s2,3			# s2 = 3 (inicializa o contador de vidas do Robozinho com 3)
	li s3,0			# s3 = 0 (zera o estado de movimentação atual do Robozinho)
	li s5,0			# s5 = 0 (zera o estado de persrguição dos aliens)
	li s6,2			# s6 = 2 (fase 2)
	li s7,0			# s7 = 0 (zera o verificador de aliens)
	li s4,17		# s4 = 17 (zera o estado de movimentação atual do inimigo1 : chase_mode)
	li s9,17		# s9 = 17 (zera o estado de movimentação atual do inmimigo2 : chase_mode)
	li s10,17 		# s10 = 17 (zera o estado de movimentação atual do inimigo3 : chase_mode)
	li s11,17 		# s11 = 17 (zera o estado de movimentação atual do inimigo4 : chase_mode)
	
	li t1,0xFF00B4C8
	la t0,POS_ROBOZINHO    # carrega o endereço de "POS_ROBOZINHO" no registrador t0 
    	sw t1,0(t0)       	# guarda a word armazenada em t1 (posição atual do Roboziho) em "POS_ROBOZINHO"
    	
    	li t1,0xFF0078C8
	la t0,POS_BLINKY    # carrega o endereço de "POS_ROBOZINHO" no registrador t0 
    	sw t1,0(t0)       	# guarda a word armazenada em t1 (posição atual do Roboziho) em "POS_ROBOZINHO"
    	
    	li t1,0xFF009BC8
	la t0,POS_PINK    # carrega o endereço de "POS_ROBOZINHO" no registrador t0 
    	sw t1,0(t0)       	# guarda a word armazenada em t1 (posição atual do Roboziho) em "POS_ROBOZINHO"
    	
    	li t1,0xFF009BB8
	la t0,POS_INKY    # carrega o endereço de "POS_ROBOZINHO" no registrador t0 
    	sw t1,0(t0)       	# guarda a word armazenada em t1 (posição atual do Roboziho) em "POS_ROBOZINHO"
    	
    	li t1,0xFF009BD8
	la t0,POS_CLYDE    # carrega o endereço de "POS_ROBOZINHO" no registrador t0 
    	sw t1,0(t0)       	# guarda a word armazenada em t1 (posição atual do Roboziho) em "POS_ROBOZINHO"
	
	j MAINL
	
	
.data 

.include "SYSTEMv24.s"		# permite a utilização dos ecalls "1xx