	.text
	.file	"sha256-x86.c"
	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4, 0x0                          # -- Begin function sha256_process_x86
.LCPI0_0:
	.byte	3                               # 0x3
	.byte	2                               # 0x2
	.byte	1                               # 0x1
	.byte	0                               # 0x0
	.byte	7                               # 0x7
	.byte	6                               # 0x6
	.byte	5                               # 0x5
	.byte	4                               # 0x4
	.byte	11                              # 0xb
	.byte	10                              # 0xa
	.byte	9                               # 0x9
	.byte	8                               # 0x8
	.byte	15                              # 0xf
	.byte	14                              # 0xe
	.byte	13                              # 0xd
	.byte	12                              # 0xc
.LCPI0_1:
	.long	1116352408                      # 0x428a2f98
	.long	1899447441                      # 0x71374491
	.long	3049323471                      # 0xb5c0fbcf
	.long	3921009573                      # 0xe9b5dba5
.LCPI0_2:
	.long	961987163                       # 0x3956c25b
	.long	1508970993                      # 0x59f111f1
	.long	2453635748                      # 0x923f82a4
	.long	2870763221                      # 0xab1c5ed5
.LCPI0_3:
	.long	3624381080                      # 0xd807aa98
	.long	310598401                       # 0x12835b01
	.long	607225278                       # 0x243185be
	.long	1426881987                      # 0x550c7dc3
.LCPI0_4:
	.long	1925078388                      # 0x72be5d74
	.long	2162078206                      # 0x80deb1fe
	.long	2614888103                      # 0x9bdc06a7
	.long	3248222580                      # 0xc19bf174
.LCPI0_5:
	.long	3835390401                      # 0xe49b69c1
	.long	4022224774                      # 0xefbe4786
	.long	264347078                       # 0xfc19dc6
	.long	604807628                       # 0x240ca1cc
.LCPI0_6:
	.long	770255983                       # 0x2de92c6f
	.long	1249150122                      # 0x4a7484aa
	.long	1555081692                      # 0x5cb0a9dc
	.long	1996064986                      # 0x76f988da
.LCPI0_7:
	.long	2554220882                      # 0x983e5152
	.long	2821834349                      # 0xa831c66d
	.long	2952996808                      # 0xb00327c8
	.long	3210313671                      # 0xbf597fc7
.LCPI0_8:
	.long	3336571891                      # 0xc6e00bf3
	.long	3584528711                      # 0xd5a79147
	.long	113926993                       # 0x6ca6351
	.long	338241895                       # 0x14292967
.LCPI0_9:
	.long	666307205                       # 0x27b70a85
	.long	773529912                       # 0x2e1b2138
	.long	1294757372                      # 0x4d2c6dfc
	.long	1396182291                      # 0x53380d13
.LCPI0_10:
	.long	1695183700                      # 0x650a7354
	.long	1986661051                      # 0x766a0abb
	.long	2177026350                      # 0x81c2c92e
	.long	2456956037                      # 0x92722c85
.LCPI0_11:
	.long	2730485921                      # 0xa2bfe8a1
	.long	2820302411                      # 0xa81a664b
	.long	3259730800                      # 0xc24b8b70
	.long	3345764771                      # 0xc76c51a3
.LCPI0_12:
	.long	3516065817                      # 0xd192e819
	.long	3600352804                      # 0xd6990624
	.long	4094571909                      # 0xf40e3585
	.long	275423344                       # 0x106aa070
.LCPI0_13:
	.long	430227734                       # 0x19a4c116
	.long	506948616                       # 0x1e376c08
	.long	659060556                       # 0x2748774c
	.long	883997877                       # 0x34b0bcb5
.LCPI0_14:
	.long	958139571                       # 0x391c0cb3
	.long	1322822218                      # 0x4ed8aa4a
	.long	1537002063                      # 0x5b9cca4f
	.long	1747873779                      # 0x682e6ff3
.LCPI0_15:
	.long	1955562222                      # 0x748f82ee
	.long	2024104815                      # 0x78a5636f
	.long	2227730452                      # 0x84c87814
	.long	2361852424                      # 0x8cc70208
.LCPI0_16:
	.long	2428436474                      # 0x90befffa
	.long	2756734187                      # 0xa4506ceb
	.long	3204031479                      # 0xbef9a3f7
	.long	3329325298                      # 0xc67178f2
	.text
	.globl	sha256_process_x86
	.p2align	4, 0x90
	.type	sha256_process_x86,@function
sha256_process_x86:                     # @sha256_process_x86
	.cfi_startproc
# %bb.0:
	vpshufd	$177, (%rdi), %xmm0             # xmm0 = mem[1,0,3,2]
	vpshufd	$27, 16(%rdi), %xmm1            # xmm1 = mem[3,2,1,0]
	vpalignr	$8, %xmm1, %xmm0, %xmm5         # xmm5 = xmm1[8,9,10,11,12,13,14,15],xmm0[0,1,2,3,4,5,6,7]
	vpblendd	$12, %xmm0, %xmm1, %xmm4        # xmm4 = xmm1[0,1],xmm0[2,3]
	cmpl	$64, %edx
	jb	.LBB0_3
# %bb.1:
	vmovdqa	.LCPI0_0(%rip), %xmm3           # xmm3 = [3,2,1,0,7,6,5,4,11,10,9,8,15,14,13,12]
	vmovdqa64	.LCPI0_1(%rip), %xmm20  # xmm20 = [1116352408,1899447441,3049323471,3921009573]
	vmovdqa64	.LCPI0_2(%rip), %xmm21  # xmm21 = [961987163,1508970993,2453635748,2870763221]
	vmovdqa64	.LCPI0_3(%rip), %xmm22  # xmm22 = [3624381080,310598401,607225278,1426881987]
	vmovdqa64	.LCPI0_4(%rip), %xmm23  # xmm23 = [1925078388,2162078206,2614888103,3248222580]
	vmovdqa64	.LCPI0_5(%rip), %xmm24  # xmm24 = [3835390401,4022224774,264347078,604807628]
	vmovdqa64	.LCPI0_6(%rip), %xmm25  # xmm25 = [770255983,1249150122,1555081692,1996064986]
	vmovdqa	.LCPI0_7(%rip), %xmm10          # xmm10 = [2554220882,2821834349,2952996808,3210313671]
	vmovdqa	.LCPI0_8(%rip), %xmm11          # xmm11 = [3336571891,3584528711,113926993,338241895]
	vmovdqa	.LCPI0_9(%rip), %xmm12          # xmm12 = [666307205,773529912,1294757372,1396182291]
	vmovdqa	.LCPI0_10(%rip), %xmm13         # xmm13 = [1695183700,1986661051,2177026350,2456956037]
	vmovdqa	.LCPI0_11(%rip), %xmm14         # xmm14 = [2730485921,2820302411,3259730800,3345764771]
	vmovdqa	.LCPI0_12(%rip), %xmm15         # xmm15 = [3516065817,3600352804,4094571909,275423344]
	vmovdqa64	.LCPI0_13(%rip), %xmm16 # xmm16 = [430227734,506948616,659060556,883997877]
	vmovdqa64	.LCPI0_14(%rip), %xmm17 # xmm17 = [958139571,1322822218,1537002063,1747873779]
	vmovdqa64	.LCPI0_15(%rip), %xmm18 # xmm18 = [1955562222,2024104815,2227730452,2361852424]
	vmovdqa64	.LCPI0_16(%rip), %xmm19 # xmm19 = [2428436474,2756734187,3204031479,3329325298]
	.p2align	4, 0x90
.LBB0_2:                                # =>This Inner Loop Header: Depth=1
	vmovdqu	(%rsi), %xmm0
	vmovdqu	16(%rsi), %xmm7
	vmovdqu	32(%rsi), %xmm8
	vmovdqu	48(%rsi), %xmm9
	vpshufb	%xmm3, %xmm0, %xmm6
	vpaddd	%xmm20, %xmm6, %xmm0
	vmovdqa	%xmm4, %xmm1
	sha256rnds2	%xmm0, %xmm5, %xmm1
	vpshufd	$14, %xmm0, %xmm0               # xmm0 = xmm0[2,3,0,0]
	vmovdqa	%xmm5, %xmm2
	sha256rnds2	%xmm0, %xmm1, %xmm2
	vpshufb	%xmm3, %xmm7, %xmm7
	vpaddd	%xmm21, %xmm7, %xmm0
	sha256rnds2	%xmm0, %xmm2, %xmm1
	vpshufd	$14, %xmm0, %xmm0               # xmm0 = xmm0[2,3,0,0]
	sha256rnds2	%xmm0, %xmm1, %xmm2
	sha256msg1	%xmm7, %xmm6
	vpshufb	%xmm3, %xmm8, %xmm8
	vpaddd	%xmm22, %xmm8, %xmm0
	sha256rnds2	%xmm0, %xmm2, %xmm1
	vpshufd	$14, %xmm0, %xmm0               # xmm0 = xmm0[2,3,0,0]
	sha256rnds2	%xmm0, %xmm1, %xmm2
	sha256msg1	%xmm8, %xmm7
	vpshufb	%xmm3, %xmm9, %xmm9
	vpaddd	%xmm23, %xmm9, %xmm0
	sha256rnds2	%xmm0, %xmm2, %xmm1
	valignd	$1, %xmm8, %xmm9, %xmm26        # xmm26 = xmm8[1,2,3],xmm9[0]
	vpaddd	%xmm26, %xmm6, %xmm6
	sha256msg2	%xmm9, %xmm6
	vpshufd	$14, %xmm0, %xmm0               # xmm0 = xmm0[2,3,0,0]
	sha256rnds2	%xmm0, %xmm1, %xmm2
	sha256msg1	%xmm9, %xmm8
	vpaddd	%xmm24, %xmm6, %xmm0
	sha256rnds2	%xmm0, %xmm2, %xmm1
	valignd	$1, %xmm9, %xmm6, %xmm26        # xmm26 = xmm9[1,2,3],xmm6[0]
	vpaddd	%xmm26, %xmm7, %xmm7
	sha256msg2	%xmm6, %xmm7
	vpshufd	$14, %xmm0, %xmm0               # xmm0 = xmm0[2,3,0,0]
	sha256rnds2	%xmm0, %xmm1, %xmm2
	sha256msg1	%xmm6, %xmm9
	vpaddd	%xmm25, %xmm7, %xmm0
	sha256rnds2	%xmm0, %xmm2, %xmm1
	valignd	$1, %xmm6, %xmm7, %xmm26        # xmm26 = xmm6[1,2,3],xmm7[0]
	vpaddd	%xmm26, %xmm8, %xmm8
	sha256msg2	%xmm7, %xmm8
	vpshufd	$14, %xmm0, %xmm0               # xmm0 = xmm0[2,3,0,0]
	sha256rnds2	%xmm0, %xmm1, %xmm2
	sha256msg1	%xmm7, %xmm6
	vpaddd	%xmm10, %xmm8, %xmm0
	sha256rnds2	%xmm0, %xmm2, %xmm1
	valignd	$1, %xmm7, %xmm8, %xmm26        # xmm26 = xmm7[1,2,3],xmm8[0]
	vpaddd	%xmm26, %xmm9, %xmm9
	sha256msg2	%xmm8, %xmm9
	vpshufd	$14, %xmm0, %xmm0               # xmm0 = xmm0[2,3,0,0]
	sha256rnds2	%xmm0, %xmm1, %xmm2
	sha256msg1	%xmm8, %xmm7
	vpaddd	%xmm11, %xmm9, %xmm0
	sha256rnds2	%xmm0, %xmm2, %xmm1
	valignd	$1, %xmm8, %xmm9, %xmm26        # xmm26 = xmm8[1,2,3],xmm9[0]
	vpaddd	%xmm26, %xmm6, %xmm6
	sha256msg2	%xmm9, %xmm6
	vpshufd	$14, %xmm0, %xmm0               # xmm0 = xmm0[2,3,0,0]
	sha256rnds2	%xmm0, %xmm1, %xmm2
	sha256msg1	%xmm9, %xmm8
	vpaddd	%xmm6, %xmm12, %xmm0
	sha256rnds2	%xmm0, %xmm2, %xmm1
	valignd	$1, %xmm9, %xmm6, %xmm26        # xmm26 = xmm9[1,2,3],xmm6[0]
	vpaddd	%xmm26, %xmm7, %xmm7
	sha256msg2	%xmm6, %xmm7
	vpshufd	$14, %xmm0, %xmm0               # xmm0 = xmm0[2,3,0,0]
	sha256rnds2	%xmm0, %xmm1, %xmm2
	sha256msg1	%xmm6, %xmm9
	vpaddd	%xmm7, %xmm13, %xmm0
	sha256rnds2	%xmm0, %xmm2, %xmm1
	valignd	$1, %xmm6, %xmm7, %xmm26        # xmm26 = xmm6[1,2,3],xmm7[0]
	vpaddd	%xmm26, %xmm8, %xmm8
	sha256msg2	%xmm7, %xmm8
	vpshufd	$14, %xmm0, %xmm0               # xmm0 = xmm0[2,3,0,0]
	sha256rnds2	%xmm0, %xmm1, %xmm2
	sha256msg1	%xmm7, %xmm6
	vpaddd	%xmm14, %xmm8, %xmm0
	sha256rnds2	%xmm0, %xmm2, %xmm1
	valignd	$1, %xmm7, %xmm8, %xmm26        # xmm26 = xmm7[1,2,3],xmm8[0]
	vpaddd	%xmm26, %xmm9, %xmm9
	sha256msg2	%xmm8, %xmm9
	vpshufd	$14, %xmm0, %xmm0               # xmm0 = xmm0[2,3,0,0]
	sha256rnds2	%xmm0, %xmm1, %xmm2
	sha256msg1	%xmm8, %xmm7
	vpaddd	%xmm15, %xmm9, %xmm0
	sha256rnds2	%xmm0, %xmm2, %xmm1
	valignd	$1, %xmm8, %xmm9, %xmm26        # xmm26 = xmm8[1,2,3],xmm9[0]
	vpaddd	%xmm26, %xmm6, %xmm6
	sha256msg2	%xmm9, %xmm6
	vpshufd	$14, %xmm0, %xmm0               # xmm0 = xmm0[2,3,0,0]
	sha256rnds2	%xmm0, %xmm1, %xmm2
	sha256msg1	%xmm9, %xmm8
	vpaddd	%xmm16, %xmm6, %xmm0
	sha256rnds2	%xmm0, %xmm2, %xmm1
	valignd	$1, %xmm9, %xmm6, %xmm26        # xmm26 = xmm9[1,2,3],xmm6[0]
	vpaddd	%xmm26, %xmm7, %xmm7
	sha256msg2	%xmm6, %xmm7
	vpshufd	$14, %xmm0, %xmm0               # xmm0 = xmm0[2,3,0,0]
	sha256rnds2	%xmm0, %xmm1, %xmm2
	sha256msg1	%xmm6, %xmm9
	vpaddd	%xmm17, %xmm7, %xmm0
	sha256rnds2	%xmm0, %xmm2, %xmm1
	vpalignr	$4, %xmm6, %xmm7, %xmm6         # xmm6 = xmm6[4,5,6,7,8,9,10,11,12,13,14,15],xmm7[0,1,2,3]
	vpaddd	%xmm6, %xmm8, %xmm6
	sha256msg2	%xmm7, %xmm6
	vpshufd	$14, %xmm0, %xmm0               # xmm0 = xmm0[2,3,0,0]
	sha256rnds2	%xmm0, %xmm1, %xmm2
	vpaddd	%xmm18, %xmm6, %xmm0
	sha256rnds2	%xmm0, %xmm2, %xmm1
	vpalignr	$4, %xmm7, %xmm6, %xmm7         # xmm7 = xmm7[4,5,6,7,8,9,10,11,12,13,14,15],xmm6[0,1,2,3]
	vpaddd	%xmm7, %xmm9, %xmm7
	sha256msg2	%xmm6, %xmm7
	vpshufd	$14, %xmm0, %xmm0               # xmm0 = xmm0[2,3,0,0]
	sha256rnds2	%xmm0, %xmm1, %xmm2
	vpaddd	%xmm19, %xmm7, %xmm0
	sha256rnds2	%xmm0, %xmm2, %xmm1
	vpshufd	$14, %xmm0, %xmm0               # xmm0 = xmm0[2,3,0,0]
	sha256rnds2	%xmm0, %xmm1, %xmm2
	vpaddd	%xmm5, %xmm2, %xmm5
	vpaddd	%xmm4, %xmm1, %xmm4
	addq	$64, %rsi
	addl	$-64, %edx
	cmpl	$63, %edx
	ja	.LBB0_2
.LBB0_3:
	vpshufd	$27, %xmm5, %xmm0               # xmm0 = xmm5[3,2,1,0]
	vpshufd	$177, %xmm4, %xmm1              # xmm1 = xmm4[1,0,3,2]
	vpblendd	$12, %xmm1, %xmm0, %xmm2        # xmm2 = xmm0[0,1],xmm1[2,3]
	vpalignr	$8, %xmm0, %xmm1, %xmm0         # xmm0 = xmm0[8,9,10,11,12,13,14,15],xmm1[0,1,2,3,4,5,6,7]
	vmovdqu	%xmm2, (%rdi)
	vmovdqu	%xmm0, 16(%rdi)
	retq
.Lfunc_end0:
	.size	sha256_process_x86, .Lfunc_end0-sha256_process_x86
	.cfi_endproc
                                        # -- End function
	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4, 0x0                          # -- Begin function genHash
.LCPI1_0:
	.byte	3                               # 0x3
	.byte	2                               # 0x2
	.byte	1                               # 0x1
	.byte	0                               # 0x0
	.byte	7                               # 0x7
	.byte	6                               # 0x6
	.byte	5                               # 0x5
	.byte	4                               # 0x4
	.byte	11                              # 0xb
	.byte	10                              # 0xa
	.byte	9                               # 0x9
	.byte	8                               # 0x8
	.byte	15                              # 0xf
	.byte	14                              # 0xe
	.byte	13                              # 0xd
	.byte	12                              # 0xc
.LCPI1_1:
	.long	1116352408                      # 0x428a2f98
	.long	1899447441                      # 0x71374491
	.long	3049323471                      # 0xb5c0fbcf
	.long	3921009573                      # 0xe9b5dba5
.LCPI1_2:
	.long	2600822924                      # 0x9b05688c
	.long	1359893119                      # 0x510e527f
	.long	3144134277                      # 0xbb67ae85
	.long	1779033703                      # 0x6a09e667
.LCPI1_3:
	.long	1541459225                      # 0x5be0cd19
	.long	528734635                       # 0x1f83d9ab
	.long	2773480762                      # 0xa54ff53a
	.long	1013904242                      # 0x3c6ef372
.LCPI1_4:
	.long	961987163                       # 0x3956c25b
	.long	1508970993                      # 0x59f111f1
	.long	2453635748                      # 0x923f82a4
	.long	2870763221                      # 0xab1c5ed5
.LCPI1_5:
	.long	3624381080                      # 0xd807aa98
	.long	310598401                       # 0x12835b01
	.long	607225278                       # 0x243185be
	.long	1426881987                      # 0x550c7dc3
.LCPI1_6:
	.long	1925078388                      # 0x72be5d74
	.long	2162078206                      # 0x80deb1fe
	.long	2614888103                      # 0x9bdc06a7
	.long	3248222580                      # 0xc19bf174
.LCPI1_7:
	.long	3835390401                      # 0xe49b69c1
	.long	4022224774                      # 0xefbe4786
	.long	264347078                       # 0xfc19dc6
	.long	604807628                       # 0x240ca1cc
.LCPI1_8:
	.long	770255983                       # 0x2de92c6f
	.long	1249150122                      # 0x4a7484aa
	.long	1555081692                      # 0x5cb0a9dc
	.long	1996064986                      # 0x76f988da
.LCPI1_9:
	.long	2554220882                      # 0x983e5152
	.long	2821834349                      # 0xa831c66d
	.long	2952996808                      # 0xb00327c8
	.long	3210313671                      # 0xbf597fc7
.LCPI1_10:
	.long	3336571891                      # 0xc6e00bf3
	.long	3584528711                      # 0xd5a79147
	.long	113926993                       # 0x6ca6351
	.long	338241895                       # 0x14292967
.LCPI1_11:
	.long	666307205                       # 0x27b70a85
	.long	773529912                       # 0x2e1b2138
	.long	1294757372                      # 0x4d2c6dfc
	.long	1396182291                      # 0x53380d13
.LCPI1_12:
	.long	1695183700                      # 0x650a7354
	.long	1986661051                      # 0x766a0abb
	.long	2177026350                      # 0x81c2c92e
	.long	2456956037                      # 0x92722c85
.LCPI1_13:
	.long	2730485921                      # 0xa2bfe8a1
	.long	2820302411                      # 0xa81a664b
	.long	3259730800                      # 0xc24b8b70
	.long	3345764771                      # 0xc76c51a3
.LCPI1_14:
	.long	3516065817                      # 0xd192e819
	.long	3600352804                      # 0xd6990624
	.long	4094571909                      # 0xf40e3585
	.long	275423344                       # 0x106aa070
.LCPI1_15:
	.long	430227734                       # 0x19a4c116
	.long	506948616                       # 0x1e376c08
	.long	659060556                       # 0x2748774c
	.long	883997877                       # 0x34b0bcb5
.LCPI1_16:
	.long	958139571                       # 0x391c0cb3
	.long	1322822218                      # 0x4ed8aa4a
	.long	1537002063                      # 0x5b9cca4f
	.long	1747873779                      # 0x682e6ff3
.LCPI1_17:
	.long	1955562222                      # 0x748f82ee
	.long	2024104815                      # 0x78a5636f
	.long	2227730452                      # 0x84c87814
	.long	2361852424                      # 0x8cc70208
.LCPI1_18:
	.long	2428436474                      # 0x90befffa
	.long	2756734187                      # 0xa4506ceb
	.long	3204031479                      # 0xbef9a3f7
	.long	3329325298                      # 0xc67178f2
	.text
	.globl	genHash
	.p2align	4, 0x90
	.type	genHash,@function
genHash:                                # @genHash
	.cfi_startproc
# %bb.0:
	pushq	%r14
	.cfi_def_cfa_offset 16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	subq	$136, %rsp
	.cfi_def_cfa_offset 160
	.cfi_offset %rbx, -24
	.cfi_offset %r14, -16
	movq	%rdi, %rbx
	vxorps	%xmm0, %xmm0, %xmm0
	vmovaps	%xmm0, 112(%rsp)
	callq	strlen@PLT
	cmpq	$56, %rax
	jae	.LBB1_2
# %bb.1:
	movq	%rax, %r14
	leaq	64(%rsp), %rdi
	movl	$55, %edx
	movq	%rbx, %rsi
	callq	strncpy@PLT
	movb	$-128, 64(%rsp,%r14)
	shlb	$3, %r14b
	movb	%r14b, 127(%rsp)
	vmovdqa	64(%rsp), %xmm0
	vmovdqa	80(%rsp), %xmm6
	vmovdqa	96(%rsp), %xmm7
	vmovdqa	.LCPI1_0(%rip), %xmm8           # xmm8 = [3,2,1,0,7,6,5,4,11,10,9,8,15,14,13,12]
	vpshufb	%xmm8, %xmm0, %xmm1
	vpaddd	.LCPI1_1(%rip), %xmm1, %xmm0
	vmovdqa	.LCPI1_2(%rip), %xmm2           # xmm2 = [2600822924,1359893119,3144134277,1779033703]
	vmovdqa	.LCPI1_3(%rip), %xmm3           # xmm3 = [1541459225,528734635,2773480762,1013904242]
	vmovdqa	%xmm3, %xmm4
	sha256rnds2	%xmm0, %xmm2, %xmm4
	vpshufd	$14, %xmm0, %xmm0               # xmm0 = xmm0[2,3,0,0]
	vmovdqa	%xmm2, %xmm5
	sha256rnds2	%xmm0, %xmm4, %xmm5
	vpshufb	%xmm8, %xmm6, %xmm6
	vpaddd	.LCPI1_4(%rip), %xmm6, %xmm0
	sha256rnds2	%xmm0, %xmm5, %xmm4
	vpshufd	$14, %xmm0, %xmm0               # xmm0 = xmm0[2,3,0,0]
	sha256rnds2	%xmm0, %xmm4, %xmm5
	sha256msg1	%xmm6, %xmm1
	vpshufb	%xmm8, %xmm7, %xmm7
	vpaddd	.LCPI1_5(%rip), %xmm7, %xmm0
	sha256rnds2	%xmm0, %xmm5, %xmm4
	vpshufd	$14, %xmm0, %xmm0               # xmm0 = xmm0[2,3,0,0]
	sha256rnds2	%xmm0, %xmm4, %xmm5
	sha256msg1	%xmm7, %xmm6
	vmovdqa	112(%rsp), %xmm0
	vpshufb	%xmm8, %xmm0, %xmm8
	vpaddd	.LCPI1_6(%rip), %xmm8, %xmm0
	sha256rnds2	%xmm0, %xmm5, %xmm4
	vpalignr	$4, %xmm7, %xmm8, %xmm9         # xmm9 = xmm7[4,5,6,7,8,9,10,11,12,13,14,15],xmm8[0,1,2,3]
	vpaddd	%xmm1, %xmm9, %xmm1
	sha256msg2	%xmm8, %xmm1
	vpshufd	$14, %xmm0, %xmm0               # xmm0 = xmm0[2,3,0,0]
	sha256rnds2	%xmm0, %xmm4, %xmm5
	sha256msg1	%xmm8, %xmm7
	vpaddd	.LCPI1_7(%rip), %xmm1, %xmm0
	sha256rnds2	%xmm0, %xmm5, %xmm4
	vpalignr	$4, %xmm8, %xmm1, %xmm9         # xmm9 = xmm8[4,5,6,7,8,9,10,11,12,13,14,15],xmm1[0,1,2,3]
	vpaddd	%xmm6, %xmm9, %xmm6
	sha256msg2	%xmm1, %xmm6
	vpshufd	$14, %xmm0, %xmm0               # xmm0 = xmm0[2,3,0,0]
	sha256rnds2	%xmm0, %xmm4, %xmm5
	sha256msg1	%xmm1, %xmm8
	vpaddd	.LCPI1_8(%rip), %xmm6, %xmm0
	sha256rnds2	%xmm0, %xmm5, %xmm4
	vpalignr	$4, %xmm1, %xmm6, %xmm9         # xmm9 = xmm1[4,5,6,7,8,9,10,11,12,13,14,15],xmm6[0,1,2,3]
	vpaddd	%xmm7, %xmm9, %xmm7
	sha256msg2	%xmm6, %xmm7
	vpshufd	$14, %xmm0, %xmm0               # xmm0 = xmm0[2,3,0,0]
	sha256rnds2	%xmm0, %xmm4, %xmm5
	sha256msg1	%xmm6, %xmm1
	vpaddd	.LCPI1_9(%rip), %xmm7, %xmm0
	sha256rnds2	%xmm0, %xmm5, %xmm4
	vpalignr	$4, %xmm6, %xmm7, %xmm9         # xmm9 = xmm6[4,5,6,7,8,9,10,11,12,13,14,15],xmm7[0,1,2,3]
	vpaddd	%xmm9, %xmm8, %xmm8
	sha256msg2	%xmm7, %xmm8
	vpshufd	$14, %xmm0, %xmm0               # xmm0 = xmm0[2,3,0,0]
	sha256rnds2	%xmm0, %xmm4, %xmm5
	sha256msg1	%xmm7, %xmm6
	vpaddd	.LCPI1_10(%rip), %xmm8, %xmm0
	sha256rnds2	%xmm0, %xmm5, %xmm4
	vpalignr	$4, %xmm7, %xmm8, %xmm9         # xmm9 = xmm7[4,5,6,7,8,9,10,11,12,13,14,15],xmm8[0,1,2,3]
	vpaddd	%xmm1, %xmm9, %xmm1
	sha256msg2	%xmm8, %xmm1
	vpshufd	$14, %xmm0, %xmm0               # xmm0 = xmm0[2,3,0,0]
	sha256rnds2	%xmm0, %xmm4, %xmm5
	sha256msg1	%xmm8, %xmm7
	vpaddd	.LCPI1_11(%rip), %xmm1, %xmm0
	sha256rnds2	%xmm0, %xmm5, %xmm4
	vpalignr	$4, %xmm8, %xmm1, %xmm9         # xmm9 = xmm8[4,5,6,7,8,9,10,11,12,13,14,15],xmm1[0,1,2,3]
	vpaddd	%xmm6, %xmm9, %xmm6
	sha256msg2	%xmm1, %xmm6
	vpshufd	$14, %xmm0, %xmm0               # xmm0 = xmm0[2,3,0,0]
	sha256rnds2	%xmm0, %xmm4, %xmm5
	sha256msg1	%xmm1, %xmm8
	vpaddd	.LCPI1_12(%rip), %xmm6, %xmm0
	sha256rnds2	%xmm0, %xmm5, %xmm4
	vpalignr	$4, %xmm1, %xmm6, %xmm9         # xmm9 = xmm1[4,5,6,7,8,9,10,11,12,13,14,15],xmm6[0,1,2,3]
	vpaddd	%xmm7, %xmm9, %xmm7
	sha256msg2	%xmm6, %xmm7
	vpshufd	$14, %xmm0, %xmm0               # xmm0 = xmm0[2,3,0,0]
	sha256rnds2	%xmm0, %xmm4, %xmm5
	sha256msg1	%xmm6, %xmm1
	vpaddd	.LCPI1_13(%rip), %xmm7, %xmm0
	sha256rnds2	%xmm0, %xmm5, %xmm4
	vpalignr	$4, %xmm6, %xmm7, %xmm9         # xmm9 = xmm6[4,5,6,7,8,9,10,11,12,13,14,15],xmm7[0,1,2,3]
	vpaddd	%xmm9, %xmm8, %xmm8
	sha256msg2	%xmm7, %xmm8
	vpshufd	$14, %xmm0, %xmm0               # xmm0 = xmm0[2,3,0,0]
	sha256rnds2	%xmm0, %xmm4, %xmm5
	sha256msg1	%xmm7, %xmm6
	vpaddd	.LCPI1_14(%rip), %xmm8, %xmm0
	sha256rnds2	%xmm0, %xmm5, %xmm4
	vpalignr	$4, %xmm7, %xmm8, %xmm9         # xmm9 = xmm7[4,5,6,7,8,9,10,11,12,13,14,15],xmm8[0,1,2,3]
	vpaddd	%xmm1, %xmm9, %xmm1
	sha256msg2	%xmm8, %xmm1
	vpshufd	$14, %xmm0, %xmm0               # xmm0 = xmm0[2,3,0,0]
	sha256rnds2	%xmm0, %xmm4, %xmm5
	sha256msg1	%xmm8, %xmm7
	vpaddd	.LCPI1_15(%rip), %xmm1, %xmm0
	sha256rnds2	%xmm0, %xmm5, %xmm4
	vpalignr	$4, %xmm8, %xmm1, %xmm9         # xmm9 = xmm8[4,5,6,7,8,9,10,11,12,13,14,15],xmm1[0,1,2,3]
	vpaddd	%xmm6, %xmm9, %xmm6
	sha256msg2	%xmm1, %xmm6
	vpshufd	$14, %xmm0, %xmm0               # xmm0 = xmm0[2,3,0,0]
	sha256rnds2	%xmm0, %xmm4, %xmm5
	sha256msg1	%xmm1, %xmm8
	vpaddd	.LCPI1_16(%rip), %xmm6, %xmm0
	sha256rnds2	%xmm0, %xmm5, %xmm4
	vpalignr	$4, %xmm1, %xmm6, %xmm1         # xmm1 = xmm1[4,5,6,7,8,9,10,11,12,13,14,15],xmm6[0,1,2,3]
	vpaddd	%xmm1, %xmm7, %xmm1
	sha256msg2	%xmm6, %xmm1
	vpshufd	$14, %xmm0, %xmm0               # xmm0 = xmm0[2,3,0,0]
	sha256rnds2	%xmm0, %xmm4, %xmm5
	vpaddd	.LCPI1_17(%rip), %xmm1, %xmm0
	sha256rnds2	%xmm0, %xmm5, %xmm4
	vpalignr	$4, %xmm6, %xmm1, %xmm6         # xmm6 = xmm6[4,5,6,7,8,9,10,11,12,13,14,15],xmm1[0,1,2,3]
	vpaddd	%xmm6, %xmm8, %xmm6
	sha256msg2	%xmm1, %xmm6
	vpshufd	$14, %xmm0, %xmm0               # xmm0 = xmm0[2,3,0,0]
	vpaddd	.LCPI1_18(%rip), %xmm6, %xmm1
	sha256rnds2	%xmm0, %xmm4, %xmm5
	vmovdqa	%xmm1, %xmm0
	sha256rnds2	%xmm0, %xmm5, %xmm4
	vpshufd	$14, %xmm1, %xmm0               # xmm0 = xmm1[2,3,0,0]
	sha256rnds2	%xmm0, %xmm4, %xmm5
	vpaddd	%xmm2, %xmm5, %xmm0
	vmovdqa	%xmm0, 32(%rsp)                 # 16-byte Spill
	vpaddd	%xmm3, %xmm4, %xmm0
	vmovdqa	%xmm0, 48(%rsp)                 # 16-byte Spill
	leaq	.L.str.1(%rip), %rdi
	movq	%rbx, %rsi
	xorl	%eax, %eax
	callq	printf@PLT
	vmovaps	32(%rsp), %xmm0                 # 16-byte Reload
	vextractps	$3, %xmm0, %esi
	vextractps	$2, %xmm0, %edx
	vmovaps	48(%rsp), %xmm1                 # 16-byte Reload
	vextractps	$3, %xmm1, %ecx
	vextractps	$2, %xmm1, %r8d
	vextractps	$1, %xmm0, %r9d
	vextractps	$1, %xmm1, 8(%rsp)
	vmovss	%xmm1, 16(%rsp)
	vmovss	%xmm0, (%rsp)
	leaq	.L.str.2(%rip), %rdi
	xorl	%eax, %eax
	callq	printf@PLT
	addq	$136, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	retq
.LBB1_2:
	.cfi_def_cfa_offset 160
	movq	stderr@GOTPCREL(%rip), %rax
	movq	(%rax), %rcx
	leaq	.L.str(%rip), %rdi
	movl	$48, %esi
	movl	$1, %edx
	callq	fwrite@PLT
	movl	$1, %edi
	callq	exit@PLT
.Lfunc_end1:
	.size	genHash, .Lfunc_end1-genHash
	.cfi_endproc
                                        # -- End function
	.globl	loadTest                        # -- Begin function loadTest
	.p2align	4, 0x90
	.type	loadTest,@function
loadTest:                               # @loadTest
	.cfi_startproc
# %bb.0:
	testl	%edi, %edi
	je	.LBB2_2
	.p2align	4, 0x90
.LBB2_1:                                # =>This Inner Loop Header: Depth=1
	#APP
	rdrandq	%rax

	#NO_APP
	#APP
	rdrandq	%rax

	#NO_APP
	#APP
	rdrandq	%rax

	#NO_APP
	#APP
	rdrandq	%rax

	#NO_APP
	#APP
	rdrandq	%rax

	#NO_APP
	#APP
	rdrandq	%rax

	#NO_APP
	#APP
	rdrandq	%rax

	#NO_APP
	#APP
	rdrandq	%rax

	#NO_APP
	decl	%edi
	jne	.LBB2_1
.LBB2_2:
	retq
.Lfunc_end2:
	.size	loadTest, .Lfunc_end2-loadTest
	.cfi_endproc
                                        # -- End function
	.globl	main                            # -- Begin function main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	pushq	%rax
	.cfi_def_cfa_offset 32
	.cfi_offset %rbx, -24
	.cfi_offset %rbp, -16
	movq	8(%rsi), %rdi
	callq	genHash
	callq	clock@PLT
	movq	%rax, %rbx
	addq	$1000000, %rbx                  # imm = 0xF4240
	callq	clock@PLT
	xorl	%ebp, %ebp
	cmpq	%rbx, %rax
	jg	.LBB3_5
# %bb.1:
	xorl	%ebp, %ebp
	.p2align	4, 0x90
.LBB3_2:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB3_3 Depth 2
	movl	$1000, %eax                     # imm = 0x3E8
	.p2align	4, 0x90
.LBB3_3:                                #   Parent Loop BB3_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	#APP
	rdrandq	%rcx

	#NO_APP
	#APP
	rdrandq	%rcx

	#NO_APP
	#APP
	rdrandq	%rcx

	#NO_APP
	#APP
	rdrandq	%rcx

	#NO_APP
	#APP
	rdrandq	%rcx

	#NO_APP
	#APP
	rdrandq	%rcx

	#NO_APP
	#APP
	rdrandq	%rcx

	#NO_APP
	#APP
	rdrandq	%rcx

	#NO_APP
	decl	%eax
	jne	.LBB3_3
# %bb.4:                                #   in Loop: Header=BB3_2 Depth=1
	addl	$1000, %ebp                     # imm = 0x3E8
	callq	clock@PLT
	cmpq	%rbx, %rax
	jle	.LBB3_2
.LBB3_5:
	leaq	.L.str.3(%rip), %rdi
	movl	%ebp, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	xorl	%eax, %eax
	addq	$8, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end3:
	.size	main, .Lfunc_end3-main
	.cfi_endproc
                                        # -- End function
	.type	.L.str,@object                  # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"Unable to process messages > 55 characters long\n"
	.size	.L.str, 49

	.type	.L.str.1,@object                # @.str.1
.L.str.1:
	.asciz	"SHA256 hash of %s: "
	.size	.L.str.1, 20

	.type	.L.str.2,@object                # @.str.2
.L.str.2:
	.asciz	"%08x%08x%08x%08x%08x%08x%08x%08x\n"
	.size	.L.str.2, 34

	.type	.L.str.3,@object                # @.str.3
.L.str.3:
	.asciz	"%u SHA256 hashes per second\n"
	.size	.L.str.3, 29

	.ident	"clang version 18.1.1 (https://github.com/llvm/llvm-project.git dba2a75e9c7ef81fe84774ba5eee5e67e01d801a)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
