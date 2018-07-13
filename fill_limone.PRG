* создать список лимиток одной позиции
* по шифру запуска
lparameters pShwz

local hh,rr,sq
local sMsg
local mkol,mdat,mkoltech

hh=sqlcn()
if hh>0
	* проверить наличие такого ШЗ 
	sq = 'select top 1 * from limone where shwz=?pShwz'
	rr = sqlexec(hh,sq,'sres')
	if rr = -1
		eodbc('fill_limone sele1')		
	else
		if reccount('sres')>0
			sMsg = 'Уже есть лимитки с шифром запуска ' + pShwz + '. При повторном создании будут удалены созданные ранее. Вы согласны?' 
			if messagebox(sMsg,4) <> 6
				return
			else
				* !!! удаление лимиток
				wait window nowait 'Удаление ранее созданных лимиток' 
				sq = 'delete from limone where shwz=?pShwz'
				rr = sqlexec(hh,sq)	
				if rr = -1
					eodbc('fill_limone dele1')
					return
				endif
			endif
		endif		
	endif	
	
	* формирование лимиток
	
	sq = 'select sh.*,mater.ei as ei,mater.ei1 as eitech,mater.v1000 as matarv1000 '+;
		 'from shwzras02 sh left join mater on sh.kodm=mater.kodm where shwz=?pShwz'
	rr = sqlexec(hh,sq,'cshwzras02')
	if rr = -1
		eodbc('fill_limone sele2')
		return
	endif

	sq = 'select * from shwzras where shwz=?pShwz'
	rr = sqlexec(hh,sq,'cshwzras')
	if rr = -1
		eodbc('fill_limone sele3')
		return
	endif
	
	select * from cshwzras order by mar1 into cursor ca
	select ca
	scan all
		waitproc(recno(),reccount(),'Выполнено ')		
		select sh.*, mm.ei as materei, mm.ei1 as materei1 from cshwzras02 sh left join mater mm on sh.kodm = mm.kodm ;
		   where sh.kodm=ca.kodm and mar1=ca.mar1 order by mar2 into cursor cb
		select cb   
		scan all
			* определить количество
			mkol = cb.kol1 * cb.kolizd
			mdat = datetime()			
		
			sq = 'insert into limone '+;
				'(shwz,kodm,kolzat,kol,datvvod,status,ei,eitech,koltech,mar1,mar2) '+;
				'values '+;
				'(?cb.shwz,?cb.kodm,?mkol,0,?mdat,0,?cb.materei1,?cb.materei,0,?cb.mar1,?cb.mar2)'
			rr = sqlexec(hh,sq)
			if rr = -1
				eodbc('fill_limone insert')
				return
			endif			
		endscan	
	endscan	
	sqldisconnect(hh)
	wait window nowait 'Фирмирование лимиток завершено' 
else
	eodbc('fill_limone conn')
endif