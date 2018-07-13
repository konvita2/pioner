* запускается один раз
* исправляет ошибку в te
* rozma и rozmb выравниваем по kt
dimension a[1]

do create_prot

select * from te order by poznd into cursor c200
scan all
	wait window nowait 'Запись '+alltrim(str(recno()))+' из '+alltrim(str(reccount()))
	select * from kt ;
		where alltrim(poznd) == alltrim(c200.poznd) and !empty(poznd) ;
		into cursor c300
	if reccount()>0
		if reccount()=1
			update te set ;
				rozma = c300.rozma, ;
				rozmb = c300.rozmb ;
			where kod = c200.kod	
		else
			select count(*) from kt ;
				where alltrim(poznd) == alltrim(c200.poznd) and !empty(poznd) ;
				group by rozma,rozmb ;
				into array a
			if a[1]>1		
				do write_prot with 'POZND = '+c200.poznd+' больше одной записи в kt и разные размеры'
			endif	
		endif	
	endif	
	use in c300	
endscan
use in c200