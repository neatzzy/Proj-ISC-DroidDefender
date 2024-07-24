# Teste dos syscalls 1xx que usam o SYSTEMv21.s
# Conectar o BitMap Display e o KD MMIO para executar
# na DE1-SoC e no Rars deve ter o mesmo comportamento sem alterar nada
# Usar no minimo o RARSv15_Custom2 (misa)
# 2022/1

.include "../MACROSv21.s"

.data
msg1: 	.string "Organizacao Arquitetura de Computadores                 2022/2"
msg2: 	.string "Digite seu Nome:"
msg3: 	.string "Digite sua Idade:"
msg4: 	.string "Digite seu peso:"
msg5: 	.string "Numero Randomico:"
msg6: 	.string "Tempo do Sistema:"
msg7:   .string "Desempenho: Texec = I x CPI x T  (ms)"
msg7b:  .string "Desempenho: Texec = C x T  (ms)"
msg8:   .string "Texec =      ms"
msg9:	.string "I     ="
msg9b:	.string "C     ="
msg10:	.string "CPI   ="
msg11:	.string "T     =                 ms"
msg12:	.string "Freq  =                 MHz"
buffer: .string "                                "
isaRV32IMFD: .string "ISA: RV32IMFD"
isaRV32IMF:  .string "ISA: RV32IMF "
isaRV32IM:   .string "ISA: RV32IM  "
isaRV32I:    .string "ISA: RV32I   "
isaRV32X:    .string "ISA: ISA Desconhecida"

.text 



#### Exemplo de calculo de Texec, I, CPI e T
		csrr	s0,instret
		csrr	s1,cycle
		csrr	s2,time
		jal CLSV		# Procedimentos a serem analisados
		jal CLSV
		jal CLSV
		csrr	t2,time		
		csrr	t1,cycle
		csrr	t0,instret
		sub	s0,t0,s0	# I
		sub	s1,t1,s1	# ciclos
		addi	s1,s1,2		# 2 corrige as 2 instruções a mais
		sub	s2,t2,s2	# texec (ms)
		NAOTEM_F(s8,PULA0)	# ver MACROS.s
		fcvt.s.w ft0,s0		# I
		fcvt.s.w ft1,s1		# ciclos
		fcvt.s.w ft2,s2		# texec
		
		fdiv.s	ft3,ft1,ft2	# F = Ciclos/texec  em kHz
		fdiv.s	ft4,ft1,ft0	# CPI = Ciclos/I
		li 	t0,1000
		fcvt.s.w ft5,t0
		fdiv.s	ft3,ft3,ft5	# F/1000  em MHz
####	
PULA0:	ebreak				# para o processador
	jal CLS	
	jal PRINTSTR
	jal INPUTSTR
	jal INPUTINT
	NAOTEM_F(t0,PULA1)		
	jal INPUTFP	 
PULA1:	jal RAND
	jal TIME
	jal TIPOISA
	jal DESEMP
	jal TOCAR
	jal SLEEP
	jal DRAW
	# ecall exit
	li a7,10
	ecall
				
	# ecall Clear Screen
CLS:	li a0,0x00
	li a7,148
	li a1,0
	ecall
	ret
				
		# ecall print string
PRINTSTR: 	li a7,104
		la a0,msg1
		li a1,0
		li a2,0
		li a3,0x0038
		li a4,0
		ecall
		ret		
	
		# ecall print string
INPUTSTR:	li a7,104
		la a0,msg2
		li a1,0
		li a2,24
		li a3,0x0038
		li a4,0
		ecall	
		# ecall read string
		li a7,108
		la a0,buffer
		li a1,32
		ecall
		# ecall print string	
		li a7,104
		la a0,buffer
		li a1,144
		li a2,24
		li a3,0x0038
		li a4,0
		ecall
		ret
	
		# ecall print string	
INPUTINT:	li a7,104
		la a0,msg3
		li a1,0
		li a2,32
		li a3,0x0038
		li a4,0
		ecall
		# syscall read int
		li a7,105
		ecall
		mv t0,a0
		# ecall print int	
	 	li a7,101
		mv a0,t0
		li a1,152
		li a2,32
		li a3,0x0038
		li a4,0
		ecall
		ret
	
		# ecall print string	
INPUTFP: 	li a7,104
		la a0,msg4
		li a1,0
		li a2,40
		li a3,0x0038
		li a4,0
		ecall
		# ecall read float
		li a7,106
		ecall
		# ecall print float
		li a7,102
		li a1,144
		li a2,40
		li a3,0x0038
		li a4,0
		ecall
		ret
	
	
# Imprime a ISA utilizada
TIPOISA:	csrr t0,misa	
		li t1,0x40001128
		bne t0,t1, testaRV32IMF
		la a0,isaRV32IMFD
		j PrintISA
testaRV32IMF:	li t1,0x40001120
		bne t0,t1, testaRV32IM
		la a0,isaRV32IMF
		j PrintISA
testaRV32IM:	li t1,0x40001100
		bne t0,t1, testaRV32I
		la a0,isaRV32IM
		j PrintISA
testaRV32I:	li t1,0x40000100
		bne t0,t1, testaRV32X
		la a0,isaRV32I
		j PrintISA
testaRV32X:	la a0,isaRV32X
					
		# ecall print string
PrintISA: 	li a7,104
		li a1,0
		li a2,72
		li a3,0x0038
		li a4,0
		ecall
		ret	
	
# Leitura estimador de desempenho
	# syscall print string	
DESEMP:	li a7,104
	la a0,msg7		# Desempenho: Texec=IxCPIxT
	TEM_F(s8,PULA4)
	la a0,msg7b		# Desempenho: Texec=CxT
PULA4:	li a1,0
	li a2,80
	li a3,0x0038
	li a4,0
	ecall

	li a7,104
	la a0,msg8		# Texec=
	li a1,0
	li a2,88
	li a3,0x0038
	li a4,0
	ecall	

	li a7,101		# texec
	mv a0,s2
	li a1,64
	li a2,88
	li a3,0x0038
	li a4,0
	ecall	


	li a7,104
	la a0,msg9		# I=
	li a1,0
	li a2,96
	li a3,0x0038
	li a4,0
	ecall	

	li a7,101		# I
	mv a0,s0
	li a1,64
	li a2,96
	li a3,0x0038
	li a4,0
	ecall			


	
	li a7,104
	la a0,msg9b		# C=
	li a1,0
	li a2,104
	li a3,0x0038
	li a4,0
	ecall	

	li a7,101		# C
	mv a0,s1
	li a1,64
	li a2,104
	li a3,0x0038
	li a4,0
	ecall	
	
	NAOTEM_F(s8,FIMDES)

	li a7,104
	la a0,msg10		# CPI=
	li a1,0
	li a2,112
	li a3,0x0038
	li a4,0
	ecall
																
	li a7,102		
	fmv.s fa0,ft4		# CPI
	li a1,64
	li a2,112
	li a3,0x0038
	li a4,0
	ecall
	
	li a7,104
	la a0,msg11		# T=
	li a1,0
	li a2,120
	li a3,0x0038
	li a4,0
	ecall
														
	li a7,102
	fdiv.s fa0,ft2,ft1	# T=1/F
	li a1,64
	li a2,120
	li a3,0x0038
	li a4,0
	ecall

	li a7,104
	la a0,msg12		# Freq=
	li a1,0
	li a2,128
	li a3,0x0038
	li a4,0
	ecall
														
	li a7,102
	fmv.s fa0,ft3		# F
	li a1,64
	li a2,128
	li a3,0x0038
	li a4,0
	ecall
	
FIMDES:	ret	

# Contatos imediatos do terceiro grau
TOCAR:	li a0,62
	li a1,500
	li a2,16
	li a3,127
	li a7,133
	ecall
	li a0,64
	li a1,500
	li a2,16
	li a3,127
	li a7,133
	ecall
	li a0,61
	li a1,500
	li a2,16
	li a3,127
	li a7,133
	ecall
	li a0,50
	li a1,500
	li a2,16
	li a3,127
	li a7,133
	ecall
	li a0,55
	li a1,800
	li a2,16
	li a3,127
	li a7,131
	ecall
	ret

	# syscall print string	
RAND:	li a7,104
	la a0,msg5
	li a1,0
	li a2,48
	li a3,0x0038
	li a4,0
	ecall
	# ecall Rand
	li a7,141
	ecall
	# ecall print int em hex
	li a7,134
	li a1,148
	li a2,48
	li a3,0x0038
	li a4,0
	ecall
	ret

	# ecall print string	
TIME:	li a7,104
	la a0,msg6
	li a1,0
	li a2,56
	li a3,0x0038
	li a4,0
	ecall
	# ecall read time
	li a7,130
	ecall
	mv t0,a0
	mv t1,a1
	#ecall print int unsigned
	mv a0,t1
	li a7,136
	li a1,148
	li a2,56
	li a3,0x0038
	li a4,0
	ecall
	#ecall print int unsigned
	mv a0,t0
	li a7,136
	li a1,236
	li a2,56
	li a3,0x0038
	li a4,0
	ecall
	ret

# syscall sleep
SLEEP:	li t0,5		# Contagem regressiva
	# ecall sleep
LOOPHMS:li a0,1000   # 1 segundo
	li a7,132
	ecall
	addi t0,t0,-1
	# ecall print int seg
	mv a0,t0
	li a7,101
	li a1,156
	li a2,144
	li a3,0x0038
	li a4,0
	ecall
	bne t0,zero,LOOPHMS	
	ret

# CLS Clear Screen Randomico
	# ecall Rand
CLSV:	li a7,141
	ecall
	# ecall Clear Screen
	li a7,148
	li a1,0
	ecall
	ret

# DrawLines Bresenham
DRAW:		li t2,0	
		li t0,1
		li s4,320
		li s5,240
LOOPDRAW: li t1,0
	  li s0,0
	  li s1,0
	  li s2,319
	  li s3,239
	  li t1,0	  
FOR1:	bge t1,s4, SAI1
	# ecall draw line
	mv a0,s0
	mv a1,s1
	mv a2,s2
	mv a3,s3
	mv a4,t2
	li a5,0
	li a7,47
	ecall
	addi s0,s0,1
	addi s2,s2,-1
	add t2,t2,t0
	addi t1,t1,1
	j FOR1
SAI1:	li s2,0
	li s1,0
	li s0,319
	li s3,239
	li t1,0
FOR2:	bge t1,s5, SAI2
	# ecall draw line
	mv a0,s0
	mv a1,s1
	mv a2,s2
	mv a3,s3
	mv a4,t2
	li a5,0
	li a7,47
	ecall
	addi s1,s1,1
	addi s3,s3,-1
	add t2,t2,t0
	addi t1,t1,1
	j FOR2
SAI2:	addi t0,t0,1
	j LOOPDRAW


.include "../SYSTEMv21.s"






