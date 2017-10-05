	.text
	.file	"example4.c"
	.globl	test                    # -- Begin function test
	.p2align	4, 0x90
	.type	test,@function
test:                                   # @test
.Lfunc_begin0:
	.file	1 "example4.c"
	.loc	1 10 0                  # example4.c:10:0
	.cfi_startproc
# BB#0:
	#DEBUG_VALUE: test:a <- %RDI
	#DEBUG_VALUE: test:x <- %RDI
	xorpd	%xmm0, %xmm0
	xorl	%eax, %eax
.Ltmp0:
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:y <- 0.000000e+00
	xorpd	%xmm1, %xmm1
	.p2align	4, 0x90
.LBB0_1:                                # =>This Inner Loop Header: Depth=1
	#DEBUG_VALUE: test:x <- %RDI
	#DEBUG_VALUE: test:a <- %RDI
.Ltmp1:
	.loc	1 18 7 prologue_end     # example4.c:18:7
	addpd	(%rdi,%rax,8), %xmm0
	addpd	16(%rdi,%rax,8), %xmm1
	addpd	32(%rdi,%rax,8), %xmm0
	addpd	48(%rdi,%rax,8), %xmm1
	addpd	64(%rdi,%rax,8), %xmm0
	addpd	80(%rdi,%rax,8), %xmm1
	addpd	96(%rdi,%rax,8), %xmm0
	addpd	112(%rdi,%rax,8), %xmm1
.Ltmp2:
	.loc	1 17 26                 # example4.c:17:26
	addq	$16, %rax
	cmpq	$65536, %rax            # imm = 0x10000
	jne	.LBB0_1
# BB#2:
	#DEBUG_VALUE: test:x <- %RDI
	#DEBUG_VALUE: test:a <- %RDI
.Ltmp3:
	.loc	1 18 7                  # example4.c:18:7
	addpd	%xmm0, %xmm1
	movapd	%xmm1, %xmm0
	movhlps	%xmm0, %xmm0            # xmm0 = xmm0[1,1]
	addpd	%xmm1, %xmm0
.Ltmp4:
	.loc	1 20 3                  # example4.c:20:3
	retq
.Ltmp5:
.Lfunc_end0:
	.size	test, .Lfunc_end0-test
	.cfi_endproc
                                        # -- End function
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3               # -- Begin function main
.LCPI1_0:
	.quad	4607182418800017408     # double 1
	.text
	.globl	main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
.Lfunc_begin1:
	.loc	1 23 0                  # example4.c:23:0
	.cfi_startproc
# BB#0:
	subq	$524312, %rsp           # imm = 0x80018
.Lcfi0:
	.cfi_def_cfa_offset 524320
	movl	$1, %eax
.Ltmp6:
	#DEBUG_VALUE: i <- 0
	movsd	.LCPI1_0(%rip), %xmm0   # xmm0 = mem[0],zero
	.p2align	4, 0x90
.LBB1_1:                                # =>This Inner Loop Header: Depth=1
.Ltmp7:
	.loc	1 26 22 prologue_end    # example4.c:26:22
	xorps	%xmm1, %xmm1
	cvtsi2sdl	%eax, %xmm1
	.loc	1 26 15 is_stmt 0       # example4.c:26:15
	movapd	%xmm0, %xmm2
	divsd	%xmm1, %xmm2
	.loc	1 26 10                 # example4.c:26:10
	movsd	%xmm2, 8(%rsp,%rax,8)
	.loc	1 26 22                 # example4.c:26:22
	addsd	%xmm0, %xmm1
	.loc	1 26 15                 # example4.c:26:15
	movapd	%xmm0, %xmm2
	divsd	%xmm1, %xmm2
	.loc	1 26 10                 # example4.c:26:10
	movsd	%xmm2, 16(%rsp,%rax,8)
.Ltmp8:
	.loc	1 25 21 is_stmt 1       # example4.c:25:21
	addq	$2, %rax
	cmpq	$65537, %rax            # imm = 0x10001
.Ltmp9:
	.loc	1 25 3 is_stmt 0        # example4.c:25:3
	jne	.LBB1_1
.Ltmp10:
# BB#2:
	.loc	1 0 3                   # example4.c:0:3
	xorpd	%xmm0, %xmm0
	xorl	%eax, %eax
	xorpd	%xmm1, %xmm1
	.p2align	4, 0x90
.LBB1_3:                                # =>This Inner Loop Header: Depth=1
.Ltmp11:
	.loc	1 18 7 is_stmt 1        # example4.c:18:7
	addpd	16(%rsp,%rax,8), %xmm0
	addpd	32(%rsp,%rax,8), %xmm1
	addpd	48(%rsp,%rax,8), %xmm0
	addpd	64(%rsp,%rax,8), %xmm1
	addpd	80(%rsp,%rax,8), %xmm0
	addpd	96(%rsp,%rax,8), %xmm1
	addpd	112(%rsp,%rax,8), %xmm0
	addpd	128(%rsp,%rax,8), %xmm1
.Ltmp12:
	.loc	1 17 26                 # example4.c:17:26
	addq	$16, %rax
	cmpq	$65536, %rax            # imm = 0x10000
	jne	.LBB1_3
# BB#4:
.Ltmp13:
	.loc	1 18 7                  # example4.c:18:7
	addpd	%xmm0, %xmm1
	movapd	%xmm1, %xmm0
	movhlps	%xmm0, %xmm0            # xmm0 = xmm0[1,1]
	addpd	%xmm1, %xmm0
.Ltmp14:
	.loc	1 29 3                  # example4.c:29:3
	movapd	%xmm0, (%rsp)           # 16-byte Spill
	movl	$.L.str, %edi
	movb	$1, %al
	callq	printf
	.loc	1 30 3                  # example4.c:30:3
	movl	$.L.str.1, %edi
	movb	$1, %al
	movaps	(%rsp), %xmm0           # 16-byte Reload
	callq	printf
	.loc	1 31 1                  # example4.c:31:1
	xorl	%eax, %eax
	addq	$524312, %rsp           # imm = 0x80018
	retq
.Ltmp15:
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
	.cfi_endproc
	.file	2 "/afs/csail.mit.edu/proj/courses/6.172/tapir-3.0/lib/clang/5.0.0/include" "stddef.h"
                                        # -- End function
	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"The decimal floating point sum result is: %f\n"
	.size	.L.str, 46

	.type	.L.str.1,@object        # @.str.1
.L.str.1:
	.asciz	"The raw floating point sum result is: %a\n"
	.size	.L.str.1, 42

	.section	.debug_str,"MS",@progbits,1
.Linfo_string0:
	.asciz	"clang version 5.0.0 (https://github.com/wsmoses/Cilk-Clang.git fb75307c6d666c74eb6a5a8a0340d6a17886c87d) (https://github.com/wsmoses/Parallel-IR.git d90005755cdcff0ac95bf5549f2e5f599b376bad)" # string offset=0
.Linfo_string1:
	.asciz	"example4.c"            # string offset=191
.Linfo_string2:
	.asciz	"/mit/mkyhuang/6.172/homework3/recitation3" # string offset=202
.Linfo_string3:
	.asciz	"test"                  # string offset=244
.Linfo_string4:
	.asciz	"double"                # string offset=249
.Linfo_string5:
	.asciz	"a"                     # string offset=256
.Linfo_string6:
	.asciz	"i"                     # string offset=258
.Linfo_string7:
	.asciz	"long unsigned int"     # string offset=260
.Linfo_string8:
	.asciz	"size_t"                # string offset=278
.Linfo_string9:
	.asciz	"x"                     # string offset=285
.Linfo_string10:
	.asciz	"y"                     # string offset=287
.Linfo_string11:
	.asciz	"main"                  # string offset=289
.Linfo_string12:
	.asciz	"int"                   # string offset=294
.Linfo_string13:
	.asciz	"sizetype"              # string offset=298
.Linfo_string14:
	.asciz	"sum"                   # string offset=307
	.section	.debug_loc,"",@progbits
.Ldebug_loc0:
	.quad	.Lfunc_begin0-.Lfunc_begin0
	.quad	.Lfunc_end0-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	85                      # DW_OP_reg5
	.quad	0
	.quad	0
.Ldebug_loc1:
	.quad	.Lfunc_begin0-.Lfunc_begin0
	.quad	.Lfunc_end0-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	85                      # DW_OP_reg5
	.quad	0
	.quad	0
.Ldebug_loc2:
	.quad	.Ltmp0-.Lfunc_begin0
	.quad	.Lfunc_end0-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	16                      # DW_OP_constu
	.byte	0                       # 0
	.byte	159                     # DW_OP_stack_value
	.quad	0
	.quad	0
.Ldebug_loc3:
	.quad	.Ltmp0-.Lfunc_begin0
	.quad	.Lfunc_end0-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	16                      # DW_OP_constu
	.byte	0                       # 0
	.byte	159                     # DW_OP_stack_value
	.quad	0
	.quad	0
.Ldebug_loc4:
	.quad	.Ltmp6-.Lfunc_begin0
	.quad	.Lfunc_end1-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	17                      # DW_OP_consts
	.byte	0                       # 0
	.byte	159                     # DW_OP_stack_value
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
	.byte	17                      # DW_AT_low_pc
	.byte	1                       # DW_FORM_addr
	.byte	18                      # DW_AT_high_pc
	.byte	6                       # DW_FORM_data4
	.byte	64                      # DW_AT_frame_base
	.byte	24                      # DW_FORM_exprloc
	.byte	49                      # DW_AT_abstract_origin
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	3                       # Abbreviation Code
	.byte	5                       # DW_TAG_formal_parameter
	.byte	0                       # DW_CHILDREN_no
	.byte	2                       # DW_AT_location
	.byte	23                      # DW_FORM_sec_offset
	.byte	49                      # DW_AT_abstract_origin
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	4                       # Abbreviation Code
	.byte	52                      # DW_TAG_variable
	.byte	0                       # DW_CHILDREN_no
	.byte	2                       # DW_AT_location
	.byte	23                      # DW_FORM_sec_offset
	.byte	49                      # DW_AT_abstract_origin
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	5                       # Abbreviation Code
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
	.byte	63                      # DW_AT_external
	.byte	25                      # DW_FORM_flag_present
	.byte	32                      # DW_AT_inline
	.byte	11                      # DW_FORM_data1
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	6                       # Abbreviation Code
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
	.byte	7                       # Abbreviation Code
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
	.byte	8                       # Abbreviation Code
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
	.byte	9                       # Abbreviation Code
	.byte	55                      # DW_TAG_restrict_type
	.byte	0                       # DW_CHILDREN_no
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	10                      # Abbreviation Code
	.byte	15                      # DW_TAG_pointer_type
	.byte	0                       # DW_CHILDREN_no
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	11                      # Abbreviation Code
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
	.byte	12                      # Abbreviation Code
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
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	63                      # DW_AT_external
	.byte	25                      # DW_FORM_flag_present
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	13                      # Abbreviation Code
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
	.byte	14                      # Abbreviation Code
	.byte	11                      # DW_TAG_lexical_block
	.byte	1                       # DW_CHILDREN_yes
	.byte	17                      # DW_AT_low_pc
	.byte	1                       # DW_FORM_addr
	.byte	18                      # DW_AT_high_pc
	.byte	6                       # DW_FORM_data4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	15                      # Abbreviation Code
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
	.byte	16                      # Abbreviation Code
	.byte	29                      # DW_TAG_inlined_subroutine
	.byte	0                       # DW_CHILDREN_no
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
	.byte	6                       # DW_FORM_data4
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
	.byte	0                       # EOM(3)
	.section	.debug_info,"",@progbits
.Lcu_begin0:
	.long	315                     # Length of Unit
	.short	4                       # DWARF version number
	.long	.debug_abbrev           # Offset Into Abbrev. Section
	.byte	8                       # Address Size (in bytes)
	.byte	1                       # Abbrev [1] 0xb:0x134 DW_TAG_compile_unit
	.long	.Linfo_string0          # DW_AT_producer
	.short	12                      # DW_AT_language
	.long	.Linfo_string1          # DW_AT_name
	.long	.Lline_table_start0     # DW_AT_stmt_list
	.long	.Linfo_string2          # DW_AT_comp_dir
                                        # DW_AT_GNU_pubnames
	.quad	.Lfunc_begin0           # DW_AT_low_pc
	.long	.Lfunc_end1-.Lfunc_begin0 # DW_AT_high_pc
	.byte	2                       # Abbrev [2] 0x2a:0x38 DW_TAG_subprogram
	.quad	.Lfunc_begin0           # DW_AT_low_pc
	.long	.Lfunc_end0-.Lfunc_begin0 # DW_AT_high_pc
	.byte	1                       # DW_AT_frame_base
	.byte	87
	.long	98                      # DW_AT_abstract_origin
	.byte	3                       # Abbrev [3] 0x3d:0x9 DW_TAG_formal_parameter
	.long	.Ldebug_loc0            # DW_AT_location
	.long	110                     # DW_AT_abstract_origin
	.byte	4                       # Abbrev [4] 0x46:0x9 DW_TAG_variable
	.long	.Ldebug_loc1            # DW_AT_location
	.long	132                     # DW_AT_abstract_origin
	.byte	4                       # Abbrev [4] 0x4f:0x9 DW_TAG_variable
	.long	.Ldebug_loc2            # DW_AT_location
	.long	121                     # DW_AT_abstract_origin
	.byte	4                       # Abbrev [4] 0x58:0x9 DW_TAG_variable
	.long	.Ldebug_loc3            # DW_AT_location
	.long	143                     # DW_AT_abstract_origin
	.byte	0                       # End Of Children Mark
	.byte	5                       # Abbrev [5] 0x62:0x39 DW_TAG_subprogram
	.long	.Linfo_string3          # DW_AT_name
	.byte	1                       # DW_AT_decl_file
	.byte	10                      # DW_AT_decl_line
                                        # DW_AT_prototyped
	.long	155                     # DW_AT_type
                                        # DW_AT_external
	.byte	1                       # DW_AT_inline
	.byte	6                       # Abbrev [6] 0x6e:0xb DW_TAG_formal_parameter
	.long	.Linfo_string5          # DW_AT_name
	.byte	1                       # DW_AT_decl_file
	.byte	10                      # DW_AT_decl_line
	.long	162                     # DW_AT_type
	.byte	7                       # Abbrev [7] 0x79:0xb DW_TAG_variable
	.long	.Linfo_string6          # DW_AT_name
	.byte	1                       # DW_AT_decl_file
	.byte	11                      # DW_AT_decl_line
	.long	172                     # DW_AT_type
	.byte	7                       # Abbrev [7] 0x84:0xb DW_TAG_variable
	.long	.Linfo_string9          # DW_AT_name
	.byte	1                       # DW_AT_decl_file
	.byte	13                      # DW_AT_decl_line
	.long	167                     # DW_AT_type
	.byte	7                       # Abbrev [7] 0x8f:0xb DW_TAG_variable
	.long	.Linfo_string10         # DW_AT_name
	.byte	1                       # DW_AT_decl_file
	.byte	15                      # DW_AT_decl_line
	.long	155                     # DW_AT_type
	.byte	0                       # End Of Children Mark
	.byte	8                       # Abbrev [8] 0x9b:0x7 DW_TAG_base_type
	.long	.Linfo_string4          # DW_AT_name
	.byte	4                       # DW_AT_encoding
	.byte	8                       # DW_AT_byte_size
	.byte	9                       # Abbrev [9] 0xa2:0x5 DW_TAG_restrict_type
	.long	167                     # DW_AT_type
	.byte	10                      # Abbrev [10] 0xa7:0x5 DW_TAG_pointer_type
	.long	155                     # DW_AT_type
	.byte	11                      # Abbrev [11] 0xac:0xb DW_TAG_typedef
	.long	183                     # DW_AT_type
	.long	.Linfo_string8          # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	62                      # DW_AT_decl_line
	.byte	8                       # Abbrev [8] 0xb7:0x7 DW_TAG_base_type
	.long	.Linfo_string7          # DW_AT_name
	.byte	7                       # DW_AT_encoding
	.byte	8                       # DW_AT_byte_size
	.byte	12                      # Abbrev [12] 0xbe:0x63 DW_TAG_subprogram
	.quad	.Lfunc_begin1           # DW_AT_low_pc
	.long	.Lfunc_end1-.Lfunc_begin1 # DW_AT_high_pc
	.byte	1                       # DW_AT_frame_base
	.byte	87
	.long	.Linfo_string11         # DW_AT_name
	.byte	1                       # DW_AT_decl_file
	.byte	23                      # DW_AT_decl_line
	.long	289                     # DW_AT_type
                                        # DW_AT_external
	.byte	13                      # Abbrev [13] 0xd7:0xe DW_TAG_variable
	.byte	2                       # DW_AT_location
	.byte	145
	.byte	16
	.long	.Linfo_string5          # DW_AT_name
	.byte	1                       # DW_AT_decl_file
	.byte	24                      # DW_AT_decl_line
	.long	296                     # DW_AT_type
	.byte	7                       # Abbrev [7] 0xe5:0xb DW_TAG_variable
	.long	.Linfo_string14         # DW_AT_name
	.byte	1                       # DW_AT_decl_file
	.byte	28                      # DW_AT_decl_line
	.long	155                     # DW_AT_type
	.byte	14                      # Abbrev [14] 0xf0:0x1d DW_TAG_lexical_block
	.quad	.Ltmp7                  # DW_AT_low_pc
	.long	.Ltmp10-.Ltmp7          # DW_AT_high_pc
	.byte	15                      # Abbrev [15] 0xfd:0xf DW_TAG_variable
	.long	.Ldebug_loc4            # DW_AT_location
	.long	.Linfo_string6          # DW_AT_name
	.byte	1                       # DW_AT_decl_file
	.byte	25                      # DW_AT_decl_line
	.long	289                     # DW_AT_type
	.byte	0                       # End Of Children Mark
	.byte	16                      # Abbrev [16] 0x10d:0x13 DW_TAG_inlined_subroutine
	.long	98                      # DW_AT_abstract_origin
	.quad	.Ltmp11                 # DW_AT_low_pc
	.long	.Ltmp14-.Ltmp11         # DW_AT_high_pc
	.byte	1                       # DW_AT_call_file
	.byte	28                      # DW_AT_call_line
	.byte	0                       # End Of Children Mark
	.byte	8                       # Abbrev [8] 0x121:0x7 DW_TAG_base_type
	.long	.Linfo_string12         # DW_AT_name
	.byte	5                       # DW_AT_encoding
	.byte	4                       # DW_AT_byte_size
	.byte	17                      # Abbrev [17] 0x128:0xf DW_TAG_array_type
	.long	155                     # DW_AT_type
	.byte	18                      # Abbrev [18] 0x12d:0x9 DW_TAG_subrange_type
	.long	311                     # DW_AT_type
	.long	65536                   # DW_AT_count
	.byte	0                       # End Of Children Mark
	.byte	19                      # Abbrev [19] 0x137:0x7 DW_TAG_base_type
	.long	.Linfo_string13         # DW_AT_name
	.byte	8                       # DW_AT_byte_size
	.byte	7                       # DW_AT_encoding
	.byte	0                       # End Of Children Mark
	.section	.debug_ranges,"",@progbits
	.section	.debug_macinfo,"",@progbits
.Lcu_macro_begin0:
	.byte	0                       # End Of Macro List Mark
	.section	.debug_pubnames,"",@progbits
	.long	.LpubNames_end0-.LpubNames_begin0 # Length of Public Names Info
.LpubNames_begin0:
	.short	2                       # DWARF Version
	.long	.Lcu_begin0             # Offset of Compilation Unit Info
	.long	319                     # Compilation Unit Length
	.long	98                      # DIE offset
	.asciz	"test"                  # External Name
	.long	190                     # DIE offset
	.asciz	"main"                  # External Name
	.long	0                       # End Mark
.LpubNames_end0:
	.section	.debug_pubtypes,"",@progbits
	.long	.LpubTypes_end0-.LpubTypes_begin0 # Length of Public Types Info
.LpubTypes_begin0:
	.short	2                       # DWARF Version
	.long	.Lcu_begin0             # Offset of Compilation Unit Info
	.long	319                     # Compilation Unit Length
	.long	183                     # DIE offset
	.asciz	"long unsigned int"     # External Name
	.long	155                     # DIE offset
	.asciz	"double"                # External Name
	.long	289                     # DIE offset
	.asciz	"int"                   # External Name
	.long	172                     # DIE offset
	.asciz	"size_t"                # External Name
	.long	0                       # End Mark
.LpubTypes_end0:

	.ident	"clang version 5.0.0 (https://github.com/wsmoses/Cilk-Clang.git fb75307c6d666c74eb6a5a8a0340d6a17886c87d) (https://github.com/wsmoses/Parallel-IR.git d90005755cdcff0ac95bf5549f2e5f599b376bad)"
	.section	".note.GNU-stack","",@progbits
	.section	.debug_line,"",@progbits
.Lline_table_start0:
