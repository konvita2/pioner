* определить брать ли участок для мсл
lparameters parShwz,parKornd,parMar

local res,hh,rr
dimension mas(1,20)

res = .f.

hh = sqlconnect('sqldb','sa','111')
if hh > 0
	
	rr = sqlexec(hh,'select top 1 mar1,mar2,mar3,mar4,mar5,mar6,mar7,mar8,mar9,mar10,'+;
		'mar11,mar12,mar13,mar14,mar15,mar16,mar17,mar18,mar19,mar20 from ktshwz where '+;
		'rtrim(shwz)=rtrim(?parShwz) and rtrim(kornd)=rtrim(?parKornd)','ccs')
	if rr = -1
		eodbc('is_ww_mar_by_kt sele')
	else
		mas[1] = ccs.mar1
		mas[2] = ccs.mar2
		mas[3] = ccs.mar3
		mas[4] = ccs.mar4
		mas[5] = ccs.mar5
		mas[6] = ccs.mar6
		mas[7] = ccs.mar7
		mas[8] = ccs.mar8
		mas[9] = ccs.mar9
		mas[10] = ccs.mar10
		mas[11] = ccs.mar11
		mas[12] = ccs.mar12
		mas[13] = ccs.mar13
		mas[14] = ccs.mar14
		mas[15] = ccs.mar15
		mas[16] = ccs.mar16
		mas[17] = ccs.mar17
		mas[18] = ccs.mar18
		mas[19] = ccs.mar19
		mas[20] = ccs.mar20
		
		for i=1 to 20 
			if mas[i] = 0
				exit 
			endif
			
			if mas[i] = parMar
				res = .t.
				exit
			endif
		endfor
				
	endif
	sqldisconnect(hh)
else
	eodbc('is_ww_mar_by_kt conn')
endif

return res