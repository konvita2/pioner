local lcFile,lcFound

* получить имя файла для обмена
m.lcFile = getnastr('ostatpath')

if empty(m.lcFile)
	wait 'Не удалось найти имя файла в файле nastr! Закачка не может быть выполнена.' window nowait	
	return
endif

*** удаляем в базе остатков строки по датам существующим в файле обмена
select dist dat from (lcFile) into cursor c11
scan all
	wait window nowait 'Удаляем остатки за '+dtoc(c11.dat) 
	*delete from ostatok where dat = c11.dat

	hh = sqlconnect('sqldb','sa','111')
	if hh > 0
		local rr1
		local pdat
		
		pdat = dtot(c11.dat)
		
		rr1 = sqlexec(hh,'delete from ostatok where dat = ?pdat')
		
		sqldisconnect(hh)
	else
		eodbc()
	endif

endscan
use in c11

local mrecc

*** перебираем строки файла обмена
select kodskl,kodspektr,kodtmz,dat,sum(kol) as sumkol from (lcFile) ;
	where kodspektr <> 0 ;
	group by kodskl,kodspektr,kodtmz,dat;
	into cursor c10
mrecc = reccount()
scan all

	*wait window nowait 'Закачано '+str(100*recno()/reccount())+'%' 
	waitproc(recno(),reccount(),'Закачано')

	local newid
*!*		select id from ostatok order by id into cursor c11
*!*		if reccount()>0
*!*			go bottom 
*!*			newid = 1 + c11.id
*!*		else
*!*			newid = 1
*!*		endif
*!*		use in c11
	
	*newid = get_newkod('ostatok')
	
	local mpartdate,yy,mm,dd

	*mpartdate = c10.partdate
	
	
*!*		insert into ostatok ;
*!*			(id,sklad_id,nsk,;
*!*			kodm,kol,cena,;
*!*			dat,partname,partdate);
*!*			values;
*!*			(newid,c10.kodskl,c10.kodtmz,;
*!*			c10.kodspektr,c10.kol,c10.cost,;
*!*			c10.dat,c10.partname,mpartdate)
*!*			
*!*		*///////////	 
	hh = sqlconnect('sqldb','sa','111')
	if hh > 0
		local rr		
		local psklad_id,pnsk,pkodm,pkol,pcena,pdat,ppartname,ppartdate
		
		psklad_id	= c10.kodskl
		pkodm		= c10.kodspektr
		pnsk		= c10.kodtmz
		pkol		= c10.sumkol
		pcena		= 0
		pdat		= c10.dat
		ppartname	= ''
		ppartdate	= {^1900-01-01}
		
		rr = sqlexec(hh,'insert into ostatok (sklad_id,nsk,kodm,kol,dat,cena,partname,partdate) '+;
			'values (?psklad_id,?pnsk,?pkodm,?pkol,?pdat,0,?ppartname,?ppartdate)')
		if rr <=0
			eodbc('loadspr new ins')
		endif			
	
		sqldisconnect(hh)
	else
		eodbc('loadspr new conn')
	endif

endscan 
use in c10

wait window nowait 'Закачано '+str(mrecc)+' записей'

putnastr('obmentime',ftime(lcFile),'')

return 
