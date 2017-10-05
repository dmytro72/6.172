.text
	.file	"loop.c"
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3               # -- Begin function main
.LCPI0_0:
	.quad	4472406533629990549     # double 1.0000000000000001E-9
	.text
	.globl	main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
.Lfunc_begin0:
	.file	1 "loop.c"
	.loc	1 49 0                  # loop.c:49:0
	.cfi_startproc
# BB#0:
	.loc	1 56 18 prologue_end    # loop.c:56:18
	pushq	%rbp
.Lcfi0:
	.cfi_def_cfa_offset 16
	pushq	%r15
.Lcfi1:
	.cfi_def_cfa_offset 24
	pushq	%r14
.Lcfi2:
	.cfi_def_cfa_offset 32
	pushq	%rbx
.Lcfi3:
	.cfi_def_cfa_offset 40
	subq	$12328, %rsp            # imm = 0x3028
.Lcfi4:
	.cfi_def_cfa_offset 12368
.Lcfi5:
	.cfi_offset %rbx, -40
.Lcfi6:
	.cfi_offset %r14, -32
.Lcfi7:
	.cfi_offset %r15, -24
.Lcfi8:
	.cfi_offset %rbp, -16
	#DEBUG_VALUE: main:argc <- %EDI
	#DEBUG_VALUE: main:argv <- %RSI
.Ltmp0:
	#DEBUG_VALUE: main:total <- 0
	#DEBUG_VALUE: main:seed <- 0
	movl	$0, 12(%rsp)
.Ltmp1:
	#DEBUG_VALUE: main:j <- 0
	.loc	1 0 18 is_stmt 0        # loop.c:0:18
	leaq	8224(%rsp), %rdi
.Ltmp2:
	#DEBUG_VALUE: main:A <- [%RDI+0]
	xorl	%ebx, %ebx
.Ltmp3:
	.loc	1 62 14 is_stmt 1       # loop.c:62:14
	xorl	%esi, %esi
.Ltmp4:
	movl	$4096, %edx             # imm = 0x1000
	callq	memset
.Ltmp5:
	.loc	1 0 14 is_stmt 0        # loop.c:0:14
	leaq	4128(%rsp), %rdi
.Ltmp6:
	#DEBUG_VALUE: main:B <- [%RDI+0]
	.loc	1 63 14 is_stmt 1       # loop.c:63:14
	xorl	%esi, %esi
	movl	$4096, %edx             # imm = 0x1000
	callq	memset
.Ltmp7:
	.loc	1 0 14 is_stmt 0        # loop.c:0:14
	leaq	32(%rsp), %rdi
.Ltmp8:
	#DEBUG_VALUE: main:C <- [%RDI+0]
	.loc	1 64 14 is_stmt 1       # loop.c:64:14
	xorl	%esi, %esi
	movl	$4096, %edx             # imm = 0x1000
	callq	memset
.Ltmp9:
	.loc	1 0 14 is_stmt 0        # loop.c:0:14
	leaq	16(%rsp), %rsi
.Ltmp10:
	#DEBUG_VALUE: gettime:s <- [%RSP+16]
	.file	2 "./." "fasttime.h"
	.loc	2 72 3 is_stmt 1        # ././fasttime.h:72:3
	movl	$1, %edi
	callq	clock_gettime
	.loc	2 77 10                 # ././fasttime.h:77:10
	movq	16(%rsp), %r15
.Ltmp11:
	#DEBUG_VALUE: main:time1 <- [DW_OP_LLVM_fragment 0 64] %R15
	#DEBUG_VALUE: tdiff:start <- [DW_OP_LLVM_fragment 0 64] %R15
	movq	24(%rsp), %r14
.Ltmp12:
	#DEBUG_VALUE: main:i <- 0
	#DEBUG_VALUE: main:time1 <- [DW_OP_LLVM_fragment 64 64] %R14
	#DEBUG_VALUE: tdiff:start <- [DW_OP_LLVM_fragment 64 64] %R14
	.p2align	4, 0x90
.LBB0_1:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_2 Depth 2
	#DEBUG_VALUE: main:time1 <- [DW_OP_LLVM_fragment 64 64] %R14
	#DEBUG_VALUE: main:j <- 0
	.loc	1 70 29                 # loop.c:70:29
	xorl	%eax, %eax
.Ltmp13:
	.p2align	4, 0x90
.LBB0_2:                                #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	#DEBUG_VALUE: main:time1 <- [DW_OP_LLVM_fragment 64 64] %R14
	.loc	1 71 32                 # loop.c:71:32
	movdqa	4128(%rsp,%rax,4), %xmm0
	movdqa	4144(%rsp,%rax,4), %xmm1
	movdqa	4160(%rsp,%rax,4), %xmm2
	movdqa	4176(%rsp,%rax,4), %xmm3
	.loc	1 71 25 is_stmt 0       # loop.c:71:25
	paddd	8224(%rsp,%rax,4), %xmm0
	paddd	8240(%rsp,%rax,4), %xmm1
	.loc	1 71 18                 # loop.c:71:18
	movdqa	%xmm0, 32(%rsp,%rax,4)
	movdqa	%xmm1, 48(%rsp,%rax,4)
	.loc	1 71 25                 # loop.c:71:25
	paddd	8256(%rsp,%rax,4), %xmm2
	paddd	8272(%rsp,%rax,4), %xmm3
	.loc	1 71 18                 # loop.c:71:18
	movdqa	%xmm2, 64(%rsp,%rax,4)
	movdqa	%xmm3, 80(%rsp,%rax,4)
.Ltmp14:
	.loc	1 70 29 is_stmt 1       # loop.c:70:29
	addq	$16, %rax
	cmpq	$1024, %rax             # imm = 0x400
	jne	.LBB0_2
.Ltmp15:
# BB#3:                                 #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: main:time1 <- [DW_OP_LLVM_fragment 64 64] %R14
	#DEBUG_VALUE: main:i <- %EBX
	.loc	1 69 25                 # loop.c:69:25
	incl	%ebx
.Ltmp16:
	.loc	1 69 19 is_stmt 0       # loop.c:69:19
	cmpl	$100000, %ebx           # imm = 0x186A0
.Ltmp17:
	.loc	1 69 5                  # loop.c:69:5
	jne	.LBB0_1
.Ltmp18:
# BB#4:
	#DEBUG_VALUE: main:time1 <- [DW_OP_LLVM_fragment 64 64] %R14
	.loc	1 0 5                   # loop.c:0:5
	leaq	16(%rsp), %rsi
.Ltmp19:
	#DEBUG_VALUE: gettime:s <- [%RSP+16]
	.loc	2 72 3 is_stmt 1        # ././fasttime.h:72:3
	movl	$1, %edi
	callq	clock_gettime
	.loc	2 77 10                 # ././fasttime.h:77:10
	movq	16(%rsp), %rbx
.Ltmp20:
	#DEBUG_VALUE: main:time2 <- [DW_OP_LLVM_fragment 0 64] %RBX
	#DEBUG_VALUE: tdiff:end <- [DW_OP_LLVM_fragment 0 64] %RBX
	.loc	2 83 21                 # ././fasttime.h:83:21
	subq	%r15, %rbx
.Ltmp21:
	.loc	2 77 10                 # ././fasttime.h:77:10
	movq	24(%rsp), %rbp
.Ltmp22:
	#DEBUG_VALUE: main:time2 <- [DW_OP_LLVM_fragment 64 64] %RBP
	#DEBUG_VALUE: tdiff:end <- [DW_OP_LLVM_fragment 64 64] %RBP
	.loc	2 83 56                 # ././fasttime.h:83:56
	subq	%r14, %rbp
.Ltmp23:
	.loc	2 0 56 is_stmt 0        # ././fasttime.h:0:56
	leaq	12(%rsp), %rdi
.Ltmp24:
	#DEBUG_VALUE: main:seed <- [%RSP+12]
	.loc	1 78 16 is_stmt 1       # loop.c:78:16
	callq	rand_r
	.loc	1 78 30 is_stmt 0       # loop.c:78:30
	movl	%eax, %ecx
	sarl	$31, %ecx
	shrl	$22, %ecx
	addl	%eax, %ecx
	andl	$-1024, %ecx            # imm = 0xFC00
	subl	%ecx, %eax
	.loc	1 78 14                 # loop.c:78:14
	cltq
	movl	32(%rsp,%rax,4), %r14d
.Ltmp25:
	#DEBUG_VALUE: main:total <- %R14D
	.loc	2 83 10 is_stmt 1       # ././fasttime.h:83:10
	xorps	%xmm1, %xmm1
	cvtsi2sdq	%rbx, %xmm1
	.loc	2 83 43 is_stmt 0       # ././fasttime.h:83:43
	xorps	%xmm0, %xmm0
	cvtsi2sdq	%rbp, %xmm0
	.loc	2 83 42                 # ././fasttime.h:83:42
	mulsd	.LCPI0_0(%rip), %xmm0
	.loc	2 83 36                 # ././fasttime.h:83:36
	addsd	%xmm1, %xmm0
.Ltmp26:
	#DEBUG_VALUE: main:elapsedf <- %XMM0
	.loc	1 83 5                  # loop.c:83:5
	movl	$.L.str, %edi
	movl	$1024, %esi             # imm = 0x400
	movl	$100000, %edx           # imm = 0x186A0
	movl	$.L.str.1, %ecx
	movl	$.L.str.2, %r8d
	movb	$1, %al
	callq	printf
.Ltmp27:
	.loc	1 87 5 is_stmt 1        # loop.c:87:5
	movl	%r14d, %eax
	addq	$12328, %rsp            # imm = 0x3028
.Ltmp28:
	popq	%rbx
	popq	%r14
.Ltmp29:
	popq	%r15
	popq	%rbp
	retq
.Ltmp30:
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc
	.file	3 "/usr/include/x86_64-linux-gnu/bits" "types.h"
	.file	4 "/usr/include" "time.h"
                                        # -- End function
	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"Elapsed execution time: %f sec; N: %d, I: %d, __OP__: %s, __TYPE__: %s\n"
	.size	.L.str, 72

	.type	.L.str.1,@object        # @.str.1
.L.str.1:
	.asciz	"+"
	.size	.L.str.1, 2

	.type	.L.str.2,@object        # @.str.2
.L.str.2:
	.asciz	"uint32_t"
	.size	.L.str.2, 9

	.file	5 "/usr/include" "stdint.h"
	.section	.debug_str,"MS",@progbits,1
.Linfo_string0:
	.asciz	"clang version 5.0.0 (https://github.com/wsmoses/Cilk-Clang.git fb75307c6d666c74eb6a5a8a0340d6a17886c87d) (https://github.com/wsmoses/Parallel-IR.git d90005755cdcff0ac95bf5549f2e5f599b376bad)" # string offset=0
.Linfo_string1:
	.asciz	"loop.c"                # string offset=191
.Linfo_string2:
	.asciz	"/afs/athena.mit.edu/user/m/k/mkyhuang/6.172/homework3/homework3" # string offset=198
.Linfo_string3:
	.asciz	"gettime"               # string offset=262
.Linfo_string4:
	.asciz	"tv_sec"                # string offset=270
.Linfo_string5:
	.asciz	"long int"              # string offset=277
.Linfo_string6:
	.asciz	"__time_t"              # string offset=286
.Linfo_string7:
	.asciz	"tv_nsec"               # string offset=295
.Linfo_string8:
	.asciz	"__syscall_slong_t"     # string offset=303
.Linfo_string9:
	.asciz	"timespec"              # string offset=321
.Linfo_string10:
	.asciz	"fasttime_t"            # string offset=330
.Linfo_string11:
	.asciz	"s"                     # string offset=341
.Linfo_string12:
	.asciz	"tdiff"                 # string offset=343
.Linfo_string13:
	.asciz	"double"                # string offset=349
.Linfo_string14:
	.asciz	"start"                 # string offset=356
.Linfo_string15:
	.asciz	"end"                   # string offset=362
.Linfo_string16:
	.asciz	"main"                  # string offset=366
.Linfo_string17:
	.asciz	"int"                   # string offset=371
.Linfo_string18:
	.asciz	"A"                     # string offset=375
.Linfo_string19:
	.asciz	"unsigned int"          # string offset=377
.Linfo_string20:
	.asciz	"uint32_t"              # string offset=390
.Linfo_string21:
	.asciz	"sizetype"              # string offset=399
.Linfo_string22:
	.asciz	"B"                     # string offset=408
.Linfo_string23:
	.asciz	"C"                     # string offset=410
.Linfo_string24:
	.asciz	"argc"                  # string offset=412
.Linfo_string25:
	.asciz	"argv"                  # string offset=417
.Linfo_string26:
	.asciz	"char"                  # string offset=422
.Linfo_string27:
	.asciz	"total"                 # string offset=427
.Linfo_string28:
	.asciz	"seed"                  # string offset=433
.Linfo_string29:
	.asciz	"j"                     # string offset=438
.Linfo_string30:
	.asciz	"time1"                 # string offset=440
.Linfo_string31:
	.asciz	"i"                     # string offset=446
.Linfo_string32:
	.asciz	"time2"                 # string offset=448
.Linfo_string33:
	.asciz	"elapsedf"              # string offset=454
	.section	.debug_loc,"",@progbits
.Ldebug_loc0:
	.quad	.Lfunc_begin0-.Lfunc_begin0
	.quad	.Ltmp2-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	85                      # super-register DW_OP_reg5
	.quad	0
	.quad	0
.Ldebug_loc1:
	.quad	.Lfunc_begin0-.Lfunc_begin0
	.quad	.Ltmp4-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	84                      # DW_OP_reg4
	.quad	0
	.quad	0
.Ldebug_loc2:
	.quad	.Ltmp0-.Lfunc_begin0
	.quad	.Ltmp25-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	16                      # DW_OP_constu
	.byte	0                       # 0
	.byte	159                     # DW_OP_stack_value
	.quad	.Ltmp25-.Lfunc_begin0
	.quad	.Ltmp29-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	94                      # super-register DW_OP_reg14
	.quad	0
	.quad	0
.Ldebug_loc3:
	.quad	.Ltmp0-.Lfunc_begin0
	.quad	.Ltmp24-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	16                      # DW_OP_constu
	.byte	0                       # 0
	.byte	159                     # DW_OP_stack_value
	.quad	.Ltmp24-.Lfunc_begin0
	.quad	.Ltmp28-.Lfunc_begin0
	.short	2                       # Loc expr size
	.byte	119                     # DW_OP_breg7
	.byte	12                      # 12
	.quad	0
	.quad	0
.Ldebug_loc4:
	.quad	.Ltmp1-.Lfunc_begin0
	.quad	.Lfunc_end0-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	17                      # DW_OP_consts
	.byte	0                       # 0
	.byte	159                     # DW_OP_stack_value
	.quad	0
	.quad	0
.Ldebug_loc5:
	.quad	.Ltmp10-.Lfunc_begin0
	.quad	.Ltmp12-.Lfunc_begin0
	.short	2                       # Loc expr size
	.byte	119                     # DW_OP_breg7
	.byte	16                      # 16
	.quad	0
	.quad	0
.Ldebug_loc6:
	.quad	.Ltmp11-.Lfunc_begin0
	.quad	.Ltmp12-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	95                      # DW_OP_reg15
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.quad	.Ltmp12-.Lfunc_begin0
	.quad	.Ltmp25-.Lfunc_begin0
	.short	6                       # Loc expr size
	.byte	95                      # DW_OP_reg15
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.byte	94                      # DW_OP_reg14
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.quad	0
	.quad	0
.Ldebug_loc7:
	.quad	.Ltmp11-.Lfunc_begin0
	.quad	.Ltmp12-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	95                      # DW_OP_reg15
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.quad	.Ltmp12-.Lfunc_begin0
	.quad	.Ltmp12-.Lfunc_begin0
	.short	6                       # Loc expr size
	.byte	95                      # DW_OP_reg15
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.byte	94                      # DW_OP_reg14
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.quad	0
	.quad	0
.Ldebug_loc8:
	.quad	.Ltmp12-.Lfunc_begin0
	.quad	.Ltmp15-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	17                      # DW_OP_consts
	.byte	0                       # 0
	.byte	159                     # DW_OP_stack_value
	.quad	.Ltmp15-.Lfunc_begin0
	.quad	.Ltmp16-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	83                      # super-register DW_OP_reg3
	.quad	0
	.quad	0
.Ldebug_loc9:
	.quad	.Ltmp19-.Lfunc_begin0
	.quad	.Ltmp28-.Lfunc_begin0
	.short	2                       # Loc expr size
	.byte	119                     # DW_OP_breg7
	.byte	16                      # 16
	.quad	0
	.quad	0
.Ldebug_loc10:
	.quad	.Ltmp20-.Lfunc_begin0
	.quad	.Ltmp21-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	83                      # DW_OP_reg3
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.quad	.Ltmp22-.Lfunc_begin0
	.quad	.Ltmp23-.Lfunc_begin0
	.short	6                       # Loc expr size
	.byte	83                      # DW_OP_reg3
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.byte	86                      # DW_OP_reg6
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.quad	0
	.quad	0
.Ldebug_loc11:
	.quad	.Ltmp20-.Lfunc_begin0
	.quad	.Ltmp21-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	83                      # DW_OP_reg3
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.quad	.Ltmp22-.Lfunc_begin0
	.quad	.Ltmp23-.Lfunc_begin0
	.short	6                       # Loc expr size
	.byte	83                      # DW_OP_reg3
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.byte	86                      # DW_OP_reg6
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.quad	0
	.quad	0
.Ldebug_loc12:
	.quad	.Ltmp26-.Lfunc_begin0
	.quad	.Ltmp27-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	97                      # DW_OP_reg17
	.quad	0
	.quad	0
	.section	.debug_abbrev,"",@progbits
	.byte	1                       # Abbreviation Code
	.byte	17                      # DW_TAG_compile_unit
	.byte	1                       # DW_CHILDREN_yes
	.byte	37                      # DW_AT_producer
	.byte	14                      # DW_FORM_strp
	.byte	19                      # DW_AT_language
	.byte	5                       # DW_FORM_data2
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	16                      # DW_AT_stmt_list
	.byte	23                      # DW_FORM_sec_offset
	.byte	27                      # DW_AT_comp_dir
	.byte	14                      # DW_FORM_strp
	.ascii	"\264B"                 # DW_AT_GNU_pubnames
	.byte	25                      # DW_FORM_flag_present
	.byte	17                      # DW_AT_low_pc
	.byte	1                       # DW_FORM_addr
	.byte	18                      # DW_AT_high_pc
	.byte	6                       # DW_FORM_data4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	2                       # Abbreviation Code
	.byte	46                      # DW_TAG_subprogram
	.byte	1                       # DW_CHILDREN_yes
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	58                      # DW_AT_decl_file
	.byte	11                      # DW_FORM_data1
	.byte	59                      # DW_AT_decl_line
	.byte	11                      # DW_FORM_data1
	.byte	39                      # DW_AT_prototyped
	.byte	25                      # DW_FORM_flag_present
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	32                      # DW_AT_inline
	.byte	11                      # DW_FORM_data1
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	3                       # Abbreviation Code
	.byte	52                      # DW_TAG_variable
	.byte	0                       # DW_CHILDREN_no
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	58                      # DW_AT_decl_file
	.byte	11                      # DW_FORM_data1
	.byte	59                      # DW_AT_decl_line
	.byte	11                      # DW_FORM_data1
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	4                       # Abbreviation Code
	.byte	22                      # DW_TAG_typedef
	.byte	0                       # DW_CHILDREN_no
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	58                      # DW_AT_decl_file
	.byte	11                      # DW_FORM_data1
	.byte	59                      # DW_AT_decl_line
	.byte	11                      # DW_FORM_data1
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	5                       # Abbreviation Code
	.byte	19                      # DW_TAG_structure_type
	.byte	1                       # DW_CHILDREN_yes
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	11                      # DW_AT_byte_size
	.byte	11                      # DW_FORM_data1
	.byte	58                      # DW_AT_decl_file
	.byte	11                      # DW_FORM_data1
	.byte	59                      # DW_AT_decl_line
	.byte	11                      # DW_FORM_data1
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	6                       # Abbreviation Code
	.byte	13                      # DW_TAG_member
	.byte	0                       # DW_CHILDREN_no
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	58                      # DW_AT_decl_file
	.byte	11                      # DW_FORM_data1
	.byte	59                      # DW_AT_decl_line
	.byte	11                      # DW_FORM_data1
	.byte	56                      # DW_AT_data_member_location
	.byte	11                      # DW_FORM_data1
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	7                       # Abbreviation Code
	.byte	36                      # DW_TAG_base_type
	.byte	0                       # DW_CHILDREN_no
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	62                      # DW_AT_encoding
	.byte	11                      # DW_FORM_data1
	.byte	11                      # DW_AT_byte_size
	.byte	11                      # DW_FORM_data1
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	8                       # Abbreviation Code
	.byte	5                       # DW_TAG_formal_parameter
	.byte	0                       # DW_CHILDREN_no
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	58                      # DW_AT_decl_file
	.byte	11                      # DW_FORM_data1
	.byte	59                      # DW_AT_decl_line
	.byte	11                      # DW_FORM_data1
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	9                       # Abbreviation Code
	.byte	46                      # DW_TAG_subprogram
	.byte	1                       # DW_CHILDREN_yes
	.byte	17                      # DW_AT_low_pc
	.byte	1                       # DW_FORM_addr
	.byte	18                      # DW_AT_high_pc
	.byte	6                       # DW_FORM_data4
	.byte	64                      # DW_AT_frame_base
	.byte	24                      # DW_FORM_exprloc
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	58                      # DW_AT_decl_file
	.byte	11                      # DW_FORM_data1
	.byte	59                      # DW_AT_decl_line
	.byte	11                      # DW_FORM_data1
	.byte	39                      # DW_AT_prototyped
	.byte	25                      # DW_FORM_flag_present
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	63                      # DW_AT_external
	.byte	25                      # DW_FORM_flag_present
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	10                      # Abbreviation Code
	.byte	5                       # DW_TAG_formal_parameter
	.byte	0                       # DW_CHILDREN_no
	.byte	2                       # DW_AT_location
	.byte	23                      # DW_FORM_sec_offset
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	58                      # DW_AT_decl_file
	.byte	11                      # DW_FORM_data1
	.byte	59                      # DW_AT_decl_line
	.byte	11                      # DW_FORM_data1
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	11                      # Abbreviation Code
	.byte	52                      # DW_TAG_variable
	.byte	0                       # DW_CHILDREN_no
	.byte	2                       # DW_AT_location
	.byte	24                      # DW_FORM_exprloc
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	58                      # DW_AT_decl_file
	.byte	11                      # DW_FORM_data1
	.byte	59                      # DW_AT_decl_line
	.byte	11                      # DW_FORM_data1
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	12                      # Abbreviation Code
	.byte	52                      # DW_TAG_variable
	.byte	0                       # DW_CHILDREN_no
	.byte	2                       # DW_AT_location
	.byte	23                      # DW_FORM_sec_offset
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	58                      # DW_AT_decl_file
	.byte	11                      # DW_FORM_data1
	.byte	59                      # DW_AT_decl_line
	.byte	11                      # DW_FORM_data1
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	13                      # Abbreviation Code
	.byte	29                      # DW_TAG_inlined_subroutine
	.byte	1                       # DW_CHILDREN_yes
	.byte	49                      # DW_AT_abstract_origin
	.byte	19                      # DW_FORM_ref4
	.byte	17                      # DW_AT_low_pc
	.byte	1                       # DW_FORM_addr
	.byte	18                      # DW_AT_high_pc
	.byte	6                       # DW_FORM_data4
	.byte	88                      # DW_AT_call_file
	.byte	11                      # DW_FORM_data1
	.byte	89                      # DW_AT_call_line
	.byte	11                      # DW_FORM_data1
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	14                      # Abbreviation Code
	.byte	52                      # DW_TAG_variable
	.byte	0                       # DW_CHILDREN_no
	.byte	2                       # DW_AT_location
	.byte	23                      # DW_FORM_sec_offset
	.byte	49                      # DW_AT_abstract_origin
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	15                      # Abbreviation Code
	.byte	29                      # DW_TAG_inlined_subroutine
	.byte	1                       # DW_CHILDREN_yes
	.byte	49                      # DW_AT_abstract_origin
	.byte	19                      # DW_FORM_ref4
	.byte	85                      # DW_AT_ranges
	.byte	23                      # DW_FORM_sec_offset
	.byte	88                      # DW_AT_call_file
	.byte	11                      # DW_FORM_data1
	.byte	89                      # DW_AT_call_line
	.byte	11                      # DW_FORM_data1
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	16                      # Abbreviation Code
	.byte	5                       # DW_TAG_formal_parameter
	.byte	0                       # DW_CHILDREN_no
	.byte	2                       # DW_AT_location
	.byte	23                      # DW_FORM_sec_offset
	.byte	49                      # DW_AT_abstract_origin
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	17                      # Abbreviation Code
	.byte	1                       # DW_TAG_array_type
	.byte	1                       # DW_CHILDREN_yes
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	18                      # Abbreviation Code
	.byte	33                      # DW_TAG_subrange_type
	.byte	0                       # DW_CHILDREN_no
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	55                      # DW_AT_count
	.byte	5                       # DW_FORM_data2
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	19                      # Abbreviation Code
	.byte	36                      # DW_TAG_base_type
	.byte	0                       # DW_CHILDREN_no
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	11                      # DW_AT_byte_size
	.byte	11                      # DW_FORM_data1
	.byte	62                      # DW_AT_encoding
	.byte	11                      # DW_FORM_data1
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	20                      # Abbreviation Code
	.byte	15                      # DW_TAG_pointer_type
	.byte	0                       # DW_CHILDREN_no
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	0                       # EOM(3)
	.section	.debug_info,"",@progbits
.Lcu_begin0:
	.long	526                     # Length of Unit
	.short	4                       # DWARF version number
	.long	.debug_abbrev           # Offset Into Abbrev. Section
	.byte	8                       # Address Size (in bytes)
	.byte	1                       # Abbrev [1] 0xb:0x207 DW_TAG_compile_unit
	.long	.Linfo_string0          # DW_AT_producer
	.short	12                      # DW_AT_language
	.long	.Linfo_string1          # DW_AT_name
	.long	.Lline_table_start0     # DW_AT_stmt_list
	.long	.Linfo_string2          # DW_AT_comp_dir
                                        # DW_AT_GNU_pubnames
	.quad	.Lfunc_begin0           # DW_AT_low_pc
	.long	.Lfunc_end0-.Lfunc_begin0 # DW_AT_high_pc
	.byte	2                       # Abbrev [2] 0x2a:0x18 DW_TAG_subprogram
	.long	.Linfo_string3          # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	69                      # DW_AT_decl_line
                                        # DW_AT_prototyped
	.long	66                      # DW_AT_type
	.byte	1                       # DW_AT_inline
	.byte	3                       # Abbrev [3] 0x36:0xb DW_TAG_variable
	.long	.Linfo_string11         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	70                      # DW_AT_decl_line
	.long	77                      # DW_AT_type
	.byte	0                       # End Of Children Mark
	.byte	4                       # Abbrev [4] 0x42:0xb DW_TAG_typedef
	.long	77                      # DW_AT_type
	.long	.Linfo_string10         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	66                      # DW_AT_decl_line
	.byte	5                       # Abbrev [5] 0x4d:0x21 DW_TAG_structure_type
	.long	.Linfo_string9          # DW_AT_name
	.byte	16                      # DW_AT_byte_size
	.byte	4                       # DW_AT_decl_file
	.byte	120                     # DW_AT_decl_line
	.byte	6                       # Abbrev [6] 0x55:0xc DW_TAG_member
	.long	.Linfo_string4          # DW_AT_name
	.long	110                     # DW_AT_type
	.byte	4                       # DW_AT_decl_file
	.byte	122                     # DW_AT_decl_line
	.byte	0                       # DW_AT_data_member_location
	.byte	6                       # Abbrev [6] 0x61:0xc DW_TAG_member
	.long	.Linfo_string7          # DW_AT_name
	.long	128                     # DW_AT_type
	.byte	4                       # DW_AT_decl_file
	.byte	123                     # DW_AT_decl_line
	.byte	8                       # DW_AT_data_member_location
	.byte	0                       # End Of Children Mark
	.byte	4                       # Abbrev [4] 0x6e:0xb DW_TAG_typedef
	.long	121                     # DW_AT_type
	.long	.Linfo_string6          # DW_AT_name
	.byte	3                       # DW_AT_decl_file
	.byte	139                     # DW_AT_decl_line
	.byte	7                       # Abbrev [7] 0x79:0x7 DW_TAG_base_type
	.long	.Linfo_string5          # DW_AT_name
	.byte	5                       # DW_AT_encoding
	.byte	8                       # DW_AT_byte_size
	.byte	4                       # Abbrev [4] 0x80:0xb DW_TAG_typedef
	.long	121                     # DW_AT_type
	.long	.Linfo_string8          # DW_AT_name
	.byte	3                       # DW_AT_decl_file
	.byte	175                     # DW_AT_decl_line
	.byte	2                       # Abbrev [2] 0x8b:0x23 DW_TAG_subprogram
	.long	.Linfo_string12         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	82                      # DW_AT_decl_line
                                        # DW_AT_prototyped
	.long	174                     # DW_AT_type
	.byte	1                       # DW_AT_inline
	.byte	8                       # Abbrev [8] 0x97:0xb DW_TAG_formal_parameter
	.long	.Linfo_string14         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	82                      # DW_AT_decl_line
	.long	66                      # DW_AT_type
	.byte	8                       # Abbrev [8] 0xa2:0xb DW_TAG_formal_parameter
	.long	.Linfo_string15         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	82                      # DW_AT_decl_line
	.long	66                      # DW_AT_type
	.byte	0                       # End Of Children Mark
	.byte	7                       # Abbrev [7] 0xae:0x7 DW_TAG_base_type
	.long	.Linfo_string13         # DW_AT_name
	.byte	4                       # DW_AT_encoding
	.byte	8                       # DW_AT_byte_size
	.byte	9                       # Abbrev [9] 0xb5:0x11e DW_TAG_subprogram
	.quad	.Lfunc_begin0           # DW_AT_low_pc
	.long	.Lfunc_end0-.Lfunc_begin0 # DW_AT_high_pc
	.byte	1                       # DW_AT_frame_base
	.byte	87
	.long	.Linfo_string16         # DW_AT_name
	.byte	1                       # DW_AT_decl_file
	.byte	49                      # DW_AT_decl_line
                                        # DW_AT_prototyped
	.long	467                     # DW_AT_type
                                        # DW_AT_external
	.byte	10                      # Abbrev [10] 0xce:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc0            # DW_AT_location
	.long	.Linfo_string24         # DW_AT_name
	.byte	1                       # DW_AT_decl_file
	.byte	49                      # DW_AT_decl_line
	.long	467                     # DW_AT_type
	.byte	10                      # Abbrev [10] 0xdd:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc1            # DW_AT_location
	.long	.Linfo_string25         # DW_AT_name
	.byte	1                       # DW_AT_decl_file
	.byte	49                      # DW_AT_decl_line
	.long	512                     # DW_AT_type
	.byte	11                      # Abbrev [11] 0xec:0x10 DW_TAG_variable
	.byte	4                       # DW_AT_location
	.byte	145
	.asciz	"\240\300"
	.long	.Linfo_string18         # DW_AT_name
	.byte	1                       # DW_AT_decl_file
	.byte	50                      # DW_AT_decl_line
	.long	474                     # DW_AT_type
	.byte	11                      # Abbrev [11] 0xfc:0xf DW_TAG_variable
	.byte	3                       # DW_AT_location
	.byte	145
	.ascii	"\240 "
	.long	.Linfo_string22         # DW_AT_name
	.byte	1                       # DW_AT_decl_file
	.byte	51                      # DW_AT_decl_line
	.long	474                     # DW_AT_type
	.byte	11                      # Abbrev [11] 0x10b:0xe DW_TAG_variable
	.byte	2                       # DW_AT_location
	.byte	145
	.byte	32
	.long	.Linfo_string23         # DW_AT_name
	.byte	1                       # DW_AT_decl_file
	.byte	52                      # DW_AT_decl_line
	.long	474                     # DW_AT_type
	.byte	12                      # Abbrev [12] 0x119:0xf DW_TAG_variable
	.long	.Ldebug_loc2            # DW_AT_location
	.long	.Linfo_string27         # DW_AT_name
	.byte	1                       # DW_AT_decl_file
	.byte	53                      # DW_AT_decl_line
	.long	487                     # DW_AT_type
	.byte	12                      # Abbrev [12] 0x128:0xf DW_TAG_variable
	.long	.Ldebug_loc3            # DW_AT_location
	.long	.Linfo_string28         # DW_AT_name
	.byte	1                       # DW_AT_decl_file
	.byte	56                      # DW_AT_decl_line
	.long	498                     # DW_AT_type
	.byte	12                      # Abbrev [12] 0x137:0xf DW_TAG_variable
	.long	.Ldebug_loc4            # DW_AT_location
	.long	.Linfo_string29         # DW_AT_name
	.byte	1                       # DW_AT_decl_file
	.byte	55                      # DW_AT_decl_line
	.long	467                     # DW_AT_type
	.byte	12                      # Abbrev [12] 0x146:0xf DW_TAG_variable
	.long	.Ldebug_loc6            # DW_AT_location
	.long	.Linfo_string30         # DW_AT_name
	.byte	1                       # DW_AT_decl_file
	.byte	67                      # DW_AT_decl_line
	.long	66                      # DW_AT_type
	.byte	12                      # Abbrev [12] 0x155:0xf DW_TAG_variable
	.long	.Ldebug_loc8            # DW_AT_location
	.long	.Linfo_string31         # DW_AT_name
	.byte	1                       # DW_AT_decl_file
	.byte	55                      # DW_AT_decl_line
	.long	467                     # DW_AT_type
	.byte	12                      # Abbrev [12] 0x164:0xf DW_TAG_variable
	.long	.Ldebug_loc10           # DW_AT_location
	.long	.Linfo_string32         # DW_AT_name
	.byte	1                       # DW_AT_decl_file
	.byte	75                      # DW_AT_decl_line
	.long	66                      # DW_AT_type
	.byte	12                      # Abbrev [12] 0x173:0xf DW_TAG_variable
	.long	.Ldebug_loc12           # DW_AT_location
	.long	.Linfo_string33         # DW_AT_name
	.byte	1                       # DW_AT_decl_file
	.byte	80                      # DW_AT_decl_line
	.long	174                     # DW_AT_type
	.byte	13                      # Abbrev [13] 0x182:0x1d DW_TAG_inlined_subroutine
	.long	42                      # DW_AT_abstract_origin
	.quad	.Ltmp10                 # DW_AT_low_pc
	.long	.Ltmp12-.Ltmp10         # DW_AT_high_pc
	.byte	1                       # DW_AT_call_file
	.byte	67                      # DW_AT_call_line
	.byte	14                      # Abbrev [14] 0x195:0x9 DW_TAG_variable
	.long	.Ldebug_loc5            # DW_AT_location
	.long	54                      # DW_AT_abstract_origin
	.byte	0                       # End Of Children Mark
	.byte	15                      # Abbrev [15] 0x19f:0x15 DW_TAG_inlined_subroutine
	.long	42                      # DW_AT_abstract_origin
	.long	.Ldebug_ranges0         # DW_AT_ranges
	.byte	1                       # DW_AT_call_file
	.byte	75                      # DW_AT_call_line
	.byte	14                      # Abbrev [14] 0x1aa:0x9 DW_TAG_variable
	.long	.Ldebug_loc9            # DW_AT_location
	.long	54                      # DW_AT_abstract_origin
	.byte	0                       # End Of Children Mark
	.byte	15                      # Abbrev [15] 0x1b4:0x1e DW_TAG_inlined_subroutine
	.long	139                     # DW_AT_abstract_origin
	.long	.Ldebug_ranges1         # DW_AT_ranges
	.byte	1                       # DW_AT_call_file
	.byte	80                      # DW_AT_call_line
	.byte	16                      # Abbrev [16] 0x1bf:0x9 DW_TAG_formal_parameter
	.long	.Ldebug_loc7            # DW_AT_location
	.long	151                     # DW_AT_abstract_origin
	.byte	16                      # Abbrev [16] 0x1c8:0x9 DW_TAG_formal_parameter
	.long	.Ldebug_loc11           # DW_AT_location
	.long	162                     # DW_AT_abstract_origin
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	7                       # Abbrev [7] 0x1d3:0x7 DW_TAG_base_type
	.long	.Linfo_string17         # DW_AT_name
	.byte	5                       # DW_AT_encoding
	.byte	4                       # DW_AT_byte_size
	.byte	17                      # Abbrev [17] 0x1da:0xd DW_TAG_array_type
	.long	487                     # DW_AT_type
	.byte	18                      # Abbrev [18] 0x1df:0x7 DW_TAG_subrange_type
	.long	505                     # DW_AT_type
	.short	1024                    # DW_AT_count
	.byte	0                       # End Of Children Mark
	.byte	4                       # Abbrev [4] 0x1e7:0xb DW_TAG_typedef
	.long	498                     # DW_AT_type
	.long	.Linfo_string20         # DW_AT_name
	.byte	5                       # DW_AT_decl_file
	.byte	51                      # DW_AT_decl_line
	.byte	7                       # Abbrev [7] 0x1f2:0x7 DW_TAG_base_type
	.long	.Linfo_string19         # DW_AT_name
	.byte	7                       # DW_AT_encoding
	.byte	4                       # DW_AT_byte_size
	.byte	19                      # Abbrev [19] 0x1f9:0x7 DW_TAG_base_type
	.long	.Linfo_string21         # DW_AT_name
	.byte	8                       # DW_AT_byte_size
	.byte	7                       # DW_AT_encoding
	.byte	20                      # Abbrev [20] 0x200:0x5 DW_TAG_pointer_type
	.long	517                     # DW_AT_type
	.byte	20                      # Abbrev [20] 0x205:0x5 DW_TAG_pointer_type
	.long	522                     # DW_AT_type
	.byte	7                       # Abbrev [7] 0x20a:0x7 DW_TAG_base_type
	.long	.Linfo_string26         # DW_AT_name
	.byte	6                       # DW_AT_encoding
	.byte	1                       # DW_AT_byte_size
	.byte	0                       # End Of Children Mark
	.section	.debug_ranges,"",@progbits
.Ldebug_ranges0:
	.quad	.Ltmp19-.Lfunc_begin0
	.quad	.Ltmp20-.Lfunc_begin0
	.quad	.Ltmp21-.Lfunc_begin0
	.quad	.Ltmp22-.Lfunc_begin0
	.quad	0
	.quad	0
.Ldebug_ranges1:
	.quad	.Ltmp20-.Lfunc_begin0
	.quad	.Ltmp21-.Lfunc_begin0
	.quad	.Ltmp22-.Lfunc_begin0
	.quad	.Ltmp24-.Lfunc_begin0
	.quad	.Ltmp25-.Lfunc_begin0
	.quad	.Ltmp26-.Lfunc_begin0
	.quad	0
	.quad	0
	.section	.debug_macinfo,"",@progbits
.Lcu_macro_begin0:
	.byte	0                       # End Of Macro List Mark
	.section	.debug_pubnames,"",@progbits
	.long	.LpubNames_end0-.LpubNames_begin0 # Length of Public Names Info
.LpubNames_begin0:
	.short	2                       # DWARF Version
	.long	.Lcu_begin0             # Offset of Compilation Unit Info
	.long	530                     # Compilation Unit Length
	.long	181                     # DIE offset
	.asciz	"main"                  # External Name
	.long	139                     # DIE offset
	.asciz	"tdiff"                 # External Name
	.long	42                      # DIE offset
	.asciz	"gettime"               # External Name
	.long	0                       # End Mark
.LpubNames_end0:
	.section	.debug_pubtypes,"",@progbits
	.long	.LpubTypes_end0-.LpubTypes_begin0 # Length of Public Types Info
.LpubTypes_begin0:
	.short	2                       # DWARF Version
	.long	.Lcu_begin0             # Offset of Compilation Unit Info
	.long	530                     # Compilation Unit Length
	.long	66                      # DIE offset
	.asciz	"fasttime_t"            # External Name
	.long	110                     # DIE offset
	.asciz	"__time_t"              # External Name
	.long	467                     # DIE offset
	.asciz	"int"                   # External Name
	.long	487                     # DIE offset
	.asciz	"uint32_t"              # External Name
	.long	498                     # DIE offset
	.asciz	"unsigned int"          # External Name
	.long	77                      # DIE offset
	.asciz	"timespec"              # External Name
	.long	121                     # DIE offset
	.asciz	"long int"              # External Name
	.long	174                     # DIE offset
	.asciz	"double"                # External Name
	.long	128                     # DIE offset
	.asciz	"__syscall_slong_t"     # External Name
	.long	522                     # DIE offset
	.asciz	"char"                  # External Name
	.long	0                       # End Mark
.LpubTypes_end0:

	.ident	"clang version 5.0.0 (https://github.com/wsmoses/Cilk-Clang.git fb75307c6d666c74eb6a5a8a0340d6a17886c87d) (https://github.com/wsmoses/Parallel-IR.git d90005755cdcff0ac95bf5549f2e5f599b376bad)"
	.section	".note.GNU-stack","",@progbits
	.section	.debug_line,"",@progbits
.Lline_table_start0:
