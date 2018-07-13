function StrZero
*
parameters cl_num, cl_len, cl_dec
private cl_str
*
do case
case pcount() = 3
	cl_str = str(cl_num, cl_len, cl_dec)
case pcount() = 2
	cl_str = str(cl_num,cl_len)
otherwise
	cl_str = str(cl_num)
endcase

if "-" $ cl_str
	return "-" + replicate("0", len(cl_str) - len(ltrim(cl_str))) +;
		substr( cl_str, at("-", cl_str) + 1)
else
	return replicate("0", len(cl_str) - len(ltrim(cl_str))) + ltrim(cl_str)
endif