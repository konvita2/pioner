* данная функция проверяет является ли parNost1 предком 
* parNost2
lparameters parKodm,parNlista,parNost1,parNost2
local res,svWA,curnost,prinost
res = .f.
svWA=select() 

curnost=parNost2
do while curnost <> -1
	select * from ostatki ;
		where ;
			kod = parKodm and ;
			nlista = parNlista and ;
			nost = curnost ;
		into cursor c115
	if reccount()>0
		if c115.inost = parNost1
			res = .t.
			use in c115
			exit
		else
			curnost = c115.inost
		endif	
	else
		wait window 'ОШИБКА! Неправильно указан номер остатка.'
		use in c115
		exit
	endif	
enddo

select (svWA)
return res