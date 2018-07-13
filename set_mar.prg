* синхронизировать маршруты для узлов 

do warn_open with 'log.txt'

select * from kt ;
	where d_u = 2 and mar1 = 0 ;
	into cursor c_kt
scan all
	select * from kt ;
		where d_u = 2 and poznd = c_kt.poznd and mar1 <> 0 ;
		into cursor c_res
	if recc() > 0
		update kt set ;
			mar1	=	c_res.mar1, ;
			mar2	=	c_res.mar2, ;
			mar3	=	c_res.mar3, ;
			mar4	=	c_res.mar4, ;
			mar5	=	c_res.mar5, ;
			mar6	=	c_res.mar6, ;
			mar7	=	c_res.mar7, ;
			mar8	=	c_res.mar8, ;
			mar9	=	c_res.mar9, ;
			mar10 	=	c_res.mar10 ;			
			where kod = c_kt.kod
		do warn with 'Проставлены в POZND='+c_kt.poznd	
	else
		do warn with 'Не найден маршрут для POZND = '+c_kt.poznd
	endif	
	use in c_res
endscan
use in c_kt
	
do warn_close	
modi comm log.txt