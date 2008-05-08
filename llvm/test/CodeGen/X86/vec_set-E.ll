; RUN: llvm-as < %s | llc -march=x86 -mattr=+sse2 | grep movq

define i32 @t(float %X) nounwind  {
	%tmp11 = insertelement <4 x float> undef, float %X, i32 0
	%tmp12 = insertelement <4 x float> %tmp11, float %X, i32 1
	%tmp27 = insertelement <4 x float> %tmp12, float 0.000000e+00, i32 2
	%tmp28 = insertelement <4 x float> %tmp27, float 0.000000e+00, i32 3
	store <4 x float> %tmp28, <4 x float>* null, align 16
	ret i32 0
}
