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
	.loc	1 58 18 prologue_end    # loop.c:58:18
	pushq	%rbp
.Lcfi0:
	.cfi_def_cfa_offset 16
	pushq	%r15
.Lcfi1:
	.cfi_def_cfa_offset 24
	pushq	%r14
.Lcfi2:
	.cfi_def_cfa_offset 32
	pushq	%r12
.Lcfi3:
	.cfi_def_cfa_offset 40
	pushq	%rbx
.Lcfi4:
	.cfi_def_cfa_offset 48
	subq	$8224, %rsp             # imm = 0x2020
.Lcfi5:
	.cfi_def_cfa_offset 8272
.Lcfi6:
	.cfi_offset %rbx, -48
.Lcfi7:
	.cfi_offset %r12, -40
.Lcfi8:
	.cfi_offset %r14, -32
.Lcfi9:
	.cfi_offset %r15, -24
.Lcfi10:
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
	leaq	4128(%rsp), %rdi
.Ltmp2:
	#DEBUG_VALUE: main:A <- [%RDI+0]
	xorl	%ebx, %ebx
.Ltmp3:
	.loc	1 64 14 is_stmt 1       # loop.c:64:14
	xorl	%esi, %esi
.Ltmp4:
	movl	$4096, %edx             # imm = 0x1000
	callq	memset
.Ltmp5:
	.loc	1 0 14 is_stmt 0        # loop.c:0:14
	leaq	32(%rsp), %rdi
.Ltmp6:
	#DEBUG_VALUE: main:C <- [%RDI+0]
	.loc	1 66 14 is_stmt 1       # loop.c:66:14
	xorl	%esi, %esi
	movl	$4096, %edx             # imm = 0x1000
	callq	memset
.Ltmp7:
	.loc	1 0 14 is_stmt 0        # loop.c:0:14
	leaq	16(%rsp), %rsi
.Ltmp8:
	#DEBUG_VALUE: gettime:s <- [%RSP+16]
	.file	2 "./." "fasttime.h"
	.loc	2 72 3 is_stmt 1        # ././fasttime.h:72:3
	movl	$1, %edi
	callq	clock_gettime
	.loc	2 77 10                 # ././fasttime.h:77:10
	movq	16(%rsp), %r15
.Ltmp9:
	#DEBUG_VALUE: main:time1 <- [DW_OP_LLVM_fragment 0 64] %R15
	#DEBUG_VALUE: tdiff:start <- [DW_OP_LLVM_fragment 0 64] %R15
	movq	24(%rsp), %r14
.Ltmp10:
	#DEBUG_VALUE: main:time1 <- [DW_OP_LLVM_fragment 64 64] %R14
	#DEBUG_VALUE: tdiff:start <- [DW_OP_LLVM_fragment 64 64] %R14
	.loc	2 0 10 is_stmt 0        # ././fasttime.h:0:10
	vpxor	%ymm0, %ymm0, %ymm0
.Ltmp11:
	.p2align	4, 0x90
.LBB0_1:                                # =>This Inner Loop Header: Depth=1
	#DEBUG_VALUE: main:time1 <- [DW_OP_LLVM_fragment 64 64] %R14
	.loc	1 75 19 is_stmt 1       # loop.c:75:19
	vpaddd	4128(%rsp,%rbx,4), %ymm0, %ymm0
.Ltmp12:
	.loc	1 73 29                 # loop.c:73:29
	addq	$8, %rbx
	cmpq	$1024, %rbx             # imm = 0x400
	jne	.LBB0_1
.Ltmp13:
# BB#2:
	#DEBUG_VALUE: main:time1 <- [DW_OP_LLVM_fragment 64 64] %R14
	.loc	1 75 19                 # loop.c:75:19
	vextracti128	$1, %ymm0, %xmm1
	vpaddd	%ymm1, %ymm0, %ymm0
	vpshufd	$78, %xmm0, %xmm1       # xmm1 = xmm0[2,3,0,1]
	vpaddd	%ymm1, %ymm0, %ymm0
	vphaddd	%ymm0, %ymm0, %ymm0
	vmovd	%xmm0, %r12d
	leaq	16(%rsp), %rsi
.Ltmp14:
	#DEBUG_VALUE: gettime:s <- [%RSP+16]
	.loc	2 72 3                  # ././fasttime.h:72:3
	movl	$1, %edi
	vzeroupper
	callq	clock_gettime
	.loc	2 77 10                 # ././fasttime.h:77:10
	movq	16(%rsp), %rbx
.Ltmp15:
	#DEBUG_VALUE: main:time2 <- [DW_OP_LLVM_fragment 0 64] %RBX
	#DEBUG_VALUE: tdiff:end <- [DW_OP_LLVM_fragment 0 64] %RBX
	.loc	2 83 21                 # ././fasttime.h:83:21
	subq	%r15, %rbx
.Ltmp16:
	.loc	2 77 10                 # ././fasttime.h:77:10
	movq	24(%rsp), %rbp
.Ltmp17:
	#DEBUG_VALUE: main:time2 <- [DW_OP_LLVM_fragment 64 64] %RBP
	#DEBUG_VALUE: tdiff:end <- [DW_OP_LLVM_fragment 64 64] %RBP
	.loc	2 83 56                 # ././fasttime.h:83:56
	subq	%r14, %rbp
.Ltmp18:
	.loc	2 0 56 is_stmt 0        # ././fasttime.h:0:56
	leaq	12(%rsp), %rdi
.Ltmp19:
	#DEBUG_VALUE: main:seed <- [%RSP+12]
	.loc	1 82 16 is_stmt 1       # loop.c:82:16
	callq	rand_r
	.loc	1 82 30 is_stmt 0       # loop.c:82:30
	movl	%eax, %ecx
	sarl	$31, %ecx
	shrl	$22, %ecx
	addl	%eax, %ecx
	andl	$-1024, %ecx            # imm = 0xFC00
	subl	%ecx, %eax
	.loc	1 82 14                 # loop.c:82:14
	cltq
	.loc	1 82 11                 # loop.c:82:11
	addl	32(%rsp,%rax,4), %r12d
.Ltmp20:
	#DEBUG_VALUE: main:total <- %R12D
	.loc	2 83 10 is_stmt 1       # ././fasttime.h:83:10
	vcvtsi2sdq	%rbx, %xmm2, %xmm0
	.loc	2 83 43 is_stmt 0       # ././fasttime.h:83:43
	vcvtsi2sdq	%rbp, %xmm2, %xmm1
	.loc	2 83 42                 # ././fasttime.h:83:42
	vmulsd	.LCPI0_0(%rip), %xmm1, %xmm1
	.loc	2 83 36                 # ././fasttime.h:83:36
	vaddsd	%xmm0, %xmm1, %xmm0
.Ltmp21:
	#DEBUG_VALUE: main:elapsedf <- %XMM0
	.loc	1 87 5 is_stmt 1        # loop.c:87:5
	movl	$.L.str, %edi
	movl	$1024, %esi             # imm = 0x400
	movl	$100000, %edx           # imm = 0x186A0
	movl	$.L.str.1, %ecx
	movl	$.L.str.2, %r8d
	movb	$1, %al
	callq	printf
.Ltmp22:
	.loc	1 91 5                  # loop.c:91:5
	movl	%r12d, %eax
	addq	$8224, %rsp             # imm = 0x2020
.Ltmp23:
	popq	%rbx
	popq	%r12
.Ltmp24:
	popq	%r14
.Ltmp25:
	popq	%r15
	popq	%rbp
	retq
.Ltmp26:
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
	.asciz	"/mit/mkyhuang/6.172/homework3/homework3" # string offset=198
.Linfo_string3:
	.asciz	"gettime"               # string offset=238
.Linfo_string4:
	.asciz	"tv_sec"                # string offset=246
.Linfo_string5:
	.asciz	"long int"              # string offset=253
.Linfo_string6:
	.asciz	"__time_t"              # string offset=262
.Linfo_string7:
	.asciz	"tv_nsec"               # string offset=271
.Linfo_string8:
	.asciz	"__syscall_slong_t"     # string offset=279
.Linfo_string9:
	.asciz	"timespec"              # string offset=297
.Linfo_string10:
	.asciz	"fasttime_t"            # string offset=306
.Linfo_string11:
	.asciz	"s"                     # string offset=317
.Linfo_string12:
	.asciz	"tdiff"                 # string offset=319
.Linfo_string13:
	.asciz	"double"                # string offset=325
.Linfo_string14:
	.asciz	"start"                 # string offset=332
.Linfo_string15:
	.asciz	"end"                   # string offset=338
.Linfo_string16:
	.asciz	"main"                  # string offset=342
.Linfo_string17:
	.asciz	"int"                   # string offset=347
.Linfo_string18:
	.asciz	"A"                     # string offset=351
.Linfo_string19:
	.asciz	"unsigned int"          # string offset=353
.Linfo_string20:
	.asciz	"uint32_t"              # string offset=366
.Linfo_string21:
	.asciz	"sizetype"              # string offset=375
.Linfo_string22:
	.asciz	"C"                     # string offset=384
.Linfo_string23:
	.asciz	"argc"                  # string offset=386
.Linfo_string24:
	.asciz	"argv"                  # string offset=391
.Linfo_string25:
	.asciz	"char"                  # string offset=396
.Linfo_string26:
	.asciz	"total"                 # string offset=401
.Linfo_string27:
	.asciz	"seed"                  # string offset=407
.Linfo_string28:
	.asciz	"j"                     # string offset=412
.Linfo_string29:
	.asciz	"time1"                 # string offset=414
.Linfo_string30:
	.asciz	"time2"                 # string offset=420
.Linfo_string31:
	.asciz	"elapsedf"              # string offset=426
.Linfo_string32:
	.asciz	"B"                     # string offset=435
.Linfo_string33:
	.asciz	"i"                     # string offset=437
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
	.quad	.Ltmp20-.Lfunc_begin0
	.short	2                       # Loc expr size
	.byte	16                      # DW_OP_constu
	.byte	0                       # 0
	.quad	.Ltmp20-.Lfunc_begin0
	.quad	.Ltmp24-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	92                      # super-register DW_OP_reg12
	.quad	0
	.quad	0
.Ldebug_loc3:
	.quad	.Ltmp0-.Lfunc_begin0
	.quad	.Ltmp19-.Lfunc_begin0
	.short	2                       # Loc expr size
	.byte	16                      # DW_OP_constu
	.byte	0                       # 0
	.quad	.Ltmp19-.Lfunc_begin0
	.quad	.Ltmp23-.Lfunc_begin0
	.short	2                       # Loc expr size
	.byte	119                     # DW_OP_breg7
	.byte	12                      # 12
	.quad	0
	.quad	0
.Ldebug_loc4:
	.quad	.Ltmp1-.Lfunc_begin0
	.quad	.Lfunc_end0-.Lfunc_begin0
	.short	2                       # Loc expr size
	.byte	17                      # DW_OP_consts
	.byte	0                       # 0
	.quad	0
	.quad	0
.Ldebug_loc5:
	.quad	.Ltmp8-.Lfunc_begin0
	.quad	.Ltmp11-.Lfunc_begin0
	.short	2                       # Loc expr size
	.byte	119                     # DW_OP_breg7
	.byte	16                      # 16
	.quad	0
	.quad	0
.Ldebug_loc6:
	.quad	.Ltmp9-.Lfunc_begin0
	.quad	.Ltmp10-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	95                      # DW_OP_reg15
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.quad	.Ltmp10-.Lfunc_begin0
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
	.quad	.Ltmp9-.Lfunc_begin0
	.quad	.Ltmp10-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	95                      # DW_OP_reg15
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.quad	.Ltmp10-.Lfunc_begin0
	.quad	.Ltmp11-.Lfunc_begin0
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
	.quad	.Ltmp14-.Lfunc_begin0
	.quad	.Ltmp23-.Lfunc_begin0
	.short	2                       # Loc expr size
	.byte	119                     # DW_OP_breg7
	.byte	16                      # 16
	.quad	0
	.quad	0
.Ldebug_loc9:
	.quad	.Ltmp15-.Lfunc_begin0
	.quad	.Ltmp16-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	83                      # DW_OP_reg3
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.quad	.Ltmp17-.Lfunc_begin0
	.quad	.Ltmp18-.Lfunc_begin0
	.short	6                       # Loc expr size
	.byte	83                      # DW_OP_reg3
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.byte	86                      # DW_OP_reg6
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.quad	0
	.quad	0
.Ldebug_loc10:
	.quad	.Ltmp15-.Lfunc_begin0
	.quad	.Ltmp16-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	83                      # DW_OP_reg3
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.quad	.Ltmp17-.Lfunc_begin0
	.quad	.Ltmp18-.Lfunc_begin0
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
	.quad	.Ltmp21-.Lfunc_begin0
	.quad	.Ltmp22-.Lfunc_begin0
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
	.byte	6                       # DW_FORM_data4
	.byte	27                      # DW_AT_comp_dir
	.byte	14                      # DW_FORM_strp
	.ascii	"\264B"                 # DW_AT_GNU_pubnames
	.byte	12                      # DW_FORM_flag
	.byte	17                      # DW_AT_low_pc
	.byte	1                       # DW_FORM_addr
	.byte	18                      # DW_AT_high_pc
	.byte	1                       # DW_FORM_addr
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
	.byte	12                      # DW_FORM_flag
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
	.byte	1                       # DW_FORM_addr
	.byte	64                      # DW_AT_frame_base
	.byte	10                      # DW_FORM_block1
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	58                      # DW_AT_decl_file
	.byte	11                      # DW_FORM_data1
	.byte	59                      # DW_AT_decl_line
	.byte	11                      # DW_FORM_data1
	.byte	39                      # DW_AT_prototyped
	.byte	12                      # DW_FORM_flag
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	63                      # DW_AT_external
	.byte	12                      # DW_FORM_flag
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	10                      # Abbreviation Code
	.byte	5                       # DW_TAG_formal_parameter
	.byte	0                       # DW_CHILDREN_no
	.byte	2                       # DW_AT_location
	.byte	6                       # DW_FORM_data4
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
	.byte	10                      # DW_FORM_block1
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
	.byte	6                       # DW_FORM_data4
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
	.byte	1                       # DW_FORM_addr
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
	.byte	6                       # DW_FORM_data4
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
	.byte	6                       # DW_FORM_data4
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
	.byte	6                       # DW_FORM_data4
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
	.long	534                     # Length of Unit
	.short	3                       # DWARF version number
	.long	.debug_abbrev           # Offset Into Abbrev. Section
	.byte	8                       # Address Size (in bytes)
	.byte	1                       # Abbrev [1] 0xb:0x20f DW_TAG_compile_unit
	.long	.Linfo_string0          # DW_AT_producer
	.short	12                      # DW_AT_language
	.long	.Linfo_string1          # DW_AT_name
	.long	.Lline_table_start0     # DW_AT_stmt_list
	.long	.Linfo_string2          # DW_AT_comp_dir
	.byte	1                       # DW_AT_GNU_pubnames
	.quad	.Lfunc_begin0           # DW_AT_low_pc
	.quad	.Lfunc_end0             # DW_AT_high_pc
	.byte	2                       # Abbrev [2] 0x2f:0x19 DW_TAG_subprogram
	.long	.Linfo_string3          # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	69                      # DW_AT_decl_line
	.byte	1                       # DW_AT_prototyped
	.long	72                      # DW_AT_type
	.byte	1                       # DW_AT_inline
	.byte	3                       # Abbrev [3] 0x3c:0xb DW_TAG_variable
	.long	.Linfo_string11         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	70                      # DW_AT_decl_line
	.long	83                      # DW_AT_type
	.byte	0                       # End Of Children Mark
	.byte	4                       # Abbrev [4] 0x48:0xb DW_TAG_typedef
	.long	83                      # DW_AT_type
	.long	.Linfo_string10         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	66                      # DW_AT_decl_line
	.byte	5                       # Abbrev [5] 0x53:0x21 DW_TAG_structure_type
	.long	.Linfo_string9          # DW_AT_name
	.byte	16                      # DW_AT_byte_size
	.byte	4                       # DW_AT_decl_file
	.byte	120                     # DW_AT_decl_line
	.byte	6                       # Abbrev [6] 0x5b:0xc DW_TAG_member
	.long	.Linfo_string4          # DW_AT_name
	.long	116                     # DW_AT_type
	.byte	4                       # DW_AT_decl_file
	.byte	122                     # DW_AT_decl_line
	.byte	0                       # DW_AT_data_member_location
	.byte	6                       # Abbrev [6] 0x67:0xc DW_TAG_member
	.long	.Linfo_string7          # DW_AT_name
	.long	134                     # DW_AT_type
	.byte	4                       # DW_AT_decl_file
	.byte	123                     # DW_AT_decl_line
	.byte	8                       # DW_AT_data_member_location
	.byte	0                       # End Of Children Mark
	.byte	4                       # Abbrev [4] 0x74:0xb DW_TAG_typedef
	.long	127                     # DW_AT_type
	.long	.Linfo_string6          # DW_AT_name
	.byte	3                       # DW_AT_decl_file
	.byte	139                     # DW_AT_decl_line
	.byte	7                       # Abbrev [7] 0x7f:0x7 DW_TAG_base_type
	.long	.Linfo_string5          # DW_AT_name
	.byte	5                       # DW_AT_encoding
	.byte	8                       # DW_AT_byte_size
	.byte	4                       # Abbrev [4] 0x86:0xb DW_TAG_typedef
	.long	127                     # DW_AT_type
	.long	.Linfo_string8          # DW_AT_name
	.byte	3                       # DW_AT_decl_file
	.byte	175                     # DW_AT_decl_line
	.byte	2                       # Abbrev [2] 0x91:0x24 DW_TAG_subprogram
	.long	.Linfo_string12         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	82                      # DW_AT_decl_line
	.byte	1                       # DW_AT_prototyped
	.long	181                     # DW_AT_type
	.byte	1                       # DW_AT_inline
	.byte	8                       # Abbrev [8] 0x9e:0xb DW_TAG_formal_parameter
	.long	.Linfo_string14         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	82                      # DW_AT_decl_line
	.long	72                      # DW_AT_type
	.byte	8                       # Abbrev [8] 0xa9:0xb DW_TAG_formal_parameter
	.long	.Linfo_string15         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	82                      # DW_AT_decl_line
	.long	72                      # DW_AT_type
	.byte	0                       # End Of Children Mark
	.byte	7                       # Abbrev [7] 0xb5:0x7 DW_TAG_base_type
	.long	.Linfo_string13         # DW_AT_name
	.byte	4                       # DW_AT_encoding
	.byte	8                       # DW_AT_byte_size
	.byte	9                       # Abbrev [9] 0xbc:0x11f DW_TAG_subprogram
	.quad	.Lfunc_begin0           # DW_AT_low_pc
	.quad	.Lfunc_end0             # DW_AT_high_pc
	.byte	1                       # DW_AT_frame_base
	.byte	87
	.long	.Linfo_string16         # DW_AT_name
	.byte	1                       # DW_AT_decl_file
	.byte	49                      # DW_AT_decl_line
	.byte	1                       # DW_AT_prototyped
	.long	475                     # DW_AT_type
	.byte	1                       # DW_AT_external
	.byte	10                      # Abbrev [10] 0xdb:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc0            # DW_AT_location
	.long	.Linfo_string23         # DW_AT_name
	.byte	1                       # DW_AT_decl_file
	.byte	49                      # DW_AT_decl_line
	.long	475                     # DW_AT_type
	.byte	10                      # Abbrev [10] 0xea:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc1            # DW_AT_location
	.long	.Linfo_string24         # DW_AT_name
	.byte	1                       # DW_AT_decl_file
	.byte	49                      # DW_AT_decl_line
	.long	520                     # DW_AT_type
	.byte	11                      # Abbrev [11] 0xf9:0xf DW_TAG_variable
	.byte	3                       # DW_AT_location
	.byte	145
	.ascii	"\240 "
	.long	.Linfo_string18         # DW_AT_name
	.byte	1                       # DW_AT_decl_file
	.byte	52                      # DW_AT_decl_line
	.long	482                     # DW_AT_type
	.byte	11                      # Abbrev [11] 0x108:0xe DW_TAG_variable
	.byte	2                       # DW_AT_location
	.byte	145
	.byte	32
	.long	.Linfo_string22         # DW_AT_name
	.byte	1                       # DW_AT_decl_file
	.byte	54                      # DW_AT_decl_line
	.long	482                     # DW_AT_type
	.byte	12                      # Abbrev [12] 0x116:0xf DW_TAG_variable
	.long	.Ldebug_loc2            # DW_AT_location
	.long	.Linfo_string26         # DW_AT_name
	.byte	1                       # DW_AT_decl_file
	.byte	55                      # DW_AT_decl_line
	.long	495                     # DW_AT_type
	.byte	12                      # Abbrev [12] 0x125:0xf DW_TAG_variable
	.long	.Ldebug_loc3            # DW_AT_location
	.long	.Linfo_string27         # DW_AT_name
	.byte	1                       # DW_AT_decl_file
	.byte	58                      # DW_AT_decl_line
	.long	506                     # DW_AT_type
	.byte	12                      # Abbrev [12] 0x134:0xf DW_TAG_variable
	.long	.Ldebug_loc4            # DW_AT_location
	.long	.Linfo_string28         # DW_AT_name
	.byte	1                       # DW_AT_decl_file
	.byte	57                      # DW_AT_decl_line
	.long	475                     # DW_AT_type
	.byte	12                      # Abbrev [12] 0x143:0xf DW_TAG_variable
	.long	.Ldebug_loc6            # DW_AT_location
	.long	.Linfo_string29         # DW_AT_name
	.byte	1                       # DW_AT_decl_file
	.byte	69                      # DW_AT_decl_line
	.long	72                      # DW_AT_type
	.byte	12                      # Abbrev [12] 0x152:0xf DW_TAG_variable
	.long	.Ldebug_loc9            # DW_AT_location
	.long	.Linfo_string30         # DW_AT_name
	.byte	1                       # DW_AT_decl_file
	.byte	79                      # DW_AT_decl_line
	.long	72                      # DW_AT_type
	.byte	12                      # Abbrev [12] 0x161:0xf DW_TAG_variable
	.long	.Ldebug_loc11           # DW_AT_location
	.long	.Linfo_string31         # DW_AT_name
	.byte	1                       # DW_AT_decl_file
	.byte	84                      # DW_AT_decl_line
	.long	181                     # DW_AT_type
	.byte	3                       # Abbrev [3] 0x170:0xb DW_TAG_variable
	.long	.Linfo_string32         # DW_AT_name
	.byte	1                       # DW_AT_decl_file
	.byte	53                      # DW_AT_decl_line
	.long	482                     # DW_AT_type
	.byte	3                       # Abbrev [3] 0x17b:0xb DW_TAG_variable
	.long	.Linfo_string33         # DW_AT_name
	.byte	1                       # DW_AT_decl_file
	.byte	57                      # DW_AT_decl_line
	.long	475                     # DW_AT_type
	.byte	13                      # Abbrev [13] 0x186:0x21 DW_TAG_inlined_subroutine
	.long	47                      # DW_AT_abstract_origin
	.quad	.Ltmp8                  # DW_AT_low_pc
	.quad	.Ltmp11                 # DW_AT_high_pc
	.byte	1                       # DW_AT_call_file
	.byte	69                      # DW_AT_call_line
	.byte	14                      # Abbrev [14] 0x19d:0x9 DW_TAG_variable
	.long	.Ldebug_loc5            # DW_AT_location
	.long	60                      # DW_AT_abstract_origin
	.byte	0                       # End Of Children Mark
	.byte	15                      # Abbrev [15] 0x1a7:0x15 DW_TAG_inlined_subroutine
	.long	47                      # DW_AT_abstract_origin
	.long	.Ldebug_ranges0         # DW_AT_ranges
	.byte	1                       # DW_AT_call_file
	.byte	79                      # DW_AT_call_line
	.byte	14                      # Abbrev [14] 0x1b2:0x9 DW_TAG_variable
	.long	.Ldebug_loc8            # DW_AT_location
	.long	60                      # DW_AT_abstract_origin
	.byte	0                       # End Of Children Mark
	.byte	15                      # Abbrev [15] 0x1bc:0x1e DW_TAG_inlined_subroutine
	.long	145                     # DW_AT_abstract_origin
	.long	.Ldebug_ranges1         # DW_AT_ranges
	.byte	1                       # DW_AT_call_file
	.byte	84                      # DW_AT_call_line
	.byte	16                      # Abbrev [16] 0x1c7:0x9 DW_TAG_formal_parameter
	.long	.Ldebug_loc7            # DW_AT_location
	.long	158                     # DW_AT_abstract_origin
	.byte	16                      # Abbrev [16] 0x1d0:0x9 DW_TAG_formal_parameter
	.long	.Ldebug_loc10           # DW_AT_location
	.long	169                     # DW_AT_abstract_origin
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	7                       # Abbrev [7] 0x1db:0x7 DW_TAG_base_type
	.long	.Linfo_string17         # DW_AT_name
	.byte	5                       # DW_AT_encoding
	.byte	4                       # DW_AT_byte_size
	.byte	17                      # Abbrev [17] 0x1e2:0xd DW_TAG_array_type
	.long	495                     # DW_AT_type
	.byte	18                      # Abbrev [18] 0x1e7:0x7 DW_TAG_subrange_type
	.long	513                     # DW_AT_type
	.short	1024                    # DW_AT_count
	.byte	0                       # End Of Children Mark
	.byte	4                       # Abbrev [4] 0x1ef:0xb DW_TAG_typedef
	.long	506                     # DW_AT_type
	.long	.Linfo_string20         # DW_AT_name
	.byte	5                       # DW_AT_decl_file
	.byte	51                      # DW_AT_decl_line
	.byte	7                       # Abbrev [7] 0x1fa:0x7 DW_TAG_base_type
	.long	.Linfo_string19         # DW_AT_name
	.byte	7                       # DW_AT_encoding
	.byte	4                       # DW_AT_byte_size
	.byte	19                      # Abbrev [19] 0x201:0x7 DW_TAG_base_type
	.long	.Linfo_string21         # DW_AT_name
	.byte	8                       # DW_AT_byte_size
	.byte	7                       # DW_AT_encoding
	.byte	20                      # Abbrev [20] 0x208:0x5 DW_TAG_pointer_type
	.long	525                     # DW_AT_type
	.byte	20                      # Abbrev [20] 0x20d:0x5 DW_TAG_pointer_type
	.long	530                     # DW_AT_type
	.byte	7                       # Abbrev [7] 0x212:0x7 DW_TAG_base_type
	.long	.Linfo_string25         # DW_AT_name
	.byte	6                       # DW_AT_encoding
	.byte	1                       # DW_AT_byte_size
	.byte	0                       # End Of Children Mark
	.section	.debug_ranges,"",@progbits
.Ldebug_ranges0:
	.quad	.Ltmp14-.Lfunc_begin0
	.quad	.Ltmp15-.Lfunc_begin0
	.quad	.Ltmp16-.Lfunc_begin0
	.quad	.Ltmp17-.Lfunc_begin0
	.quad	0
	.quad	0
.Ldebug_ranges1:
	.quad	.Ltmp15-.Lfunc_begin0
	.quad	.Ltmp16-.Lfunc_begin0
	.quad	.Ltmp17-.Lfunc_begin0
	.quad	.Ltmp19-.Lfunc_begin0
	.quad	.Ltmp20-.Lfunc_begin0
	.quad	.Ltmp21-.Lfunc_begin0
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
	.long	538                     # Compilation Unit Length
	.long	188                     # DIE offset
	.asciz	"main"                  # External Name
	.long	145                     # DIE offset
	.asciz	"tdiff"                 # External Name
	.long	47                      # DIE offset
	.asciz	"gettime"               # External Name
	.long	0                       # End Mark
.LpubNames_end0:
	.section	.debug_pubtypes,"",@progbits
	.long	.LpubTypes_end0-.LpubTypes_begin0 # Length of Public Types Info
.LpubTypes_begin0:
	.short	2                       # DWARF Version
	.long	.Lcu_begin0             # Offset of Compilation Unit Info
	.long	538                     # Compilation Unit Length
	.long	72                      # DIE offset
	.asciz	"fasttime_t"            # External Name
	.long	116                     # DIE offset
	.asciz	"__time_t"              # External Name
	.long	475                     # DIE offset
	.asciz	"int"                   # External Name
	.long	495                     # DIE offset
	.asciz	"uint32_t"              # External Name
	.long	506                     # DIE offset
	.asciz	"unsigned int"          # External Name
	.long	83                      # DIE offset
	.asciz	"timespec"              # External Name
	.long	127                     # DIE offset
	.asciz	"long int"              # External Name
	.long	181                     # DIE offset
	.asciz	"double"                # External Name
	.long	134                     # DIE offset
	.asciz	"__syscall_slong_t"     # External Name
	.long	530                     # DIE offset
	.asciz	"char"                  # External Name
	.long	0                       # End Mark
.LpubTypes_end0:

	.ident	"clang version 5.0.0 (https://github.com/wsmoses/Cilk-Clang.git fb75307c6d666c74eb6a5a8a0340d6a17886c87d) (https://github.com/wsmoses/Parallel-IR.git d90005755cdcff0ac95bf5549f2e5f599b376bad)"
	.section	".note.GNU-stack","",@progbits
	.section	.debug_line,"",@progbits
.Lline_table_start0:
