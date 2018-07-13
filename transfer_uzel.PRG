* процедура распространения структуры узла
*  parKornw - короткий номер распространяемого узла
*  parShw - код изделия
lparameters parKornw,parShw
local hh,rr
local mpoznw

hh = sqlconnect('sqldb','sa','111')
if hh > 0
	
	* select source record
	csql = "select poznw from kt where shw=?parShw and rtrim(kornw)=rtrim(?parKornw) and d_u=2 and kornw=kornd"
	rr = sqlexec(hh,csql,'crec')
	if rr = -1
		eodbc('transfer_uzel sele1')
		sqldisconnect(hh)
		return
	endif
	select crec
	go top && nenado
	mpoznw = crec.poznw
	
	* подготовить список записей которые надо переносить
	csql = "select * from kt where shw=?parShw and rtrim(kornw)=rtrim(?parKornw)"
	rr = sqlexec(hh,csql,'cist')	
	if rr = -1
		eodbc('transfer_uzel sele2')
		sqldisconnect(hh)
		return
	else
		* it's OK 
		* we can transfer set of records
		
		* prepare set of shw-kornw to be converted
		csql = "select distintc kornw,shw from kt where shw<>?parShw and kornw=kornw "+;
			"and d_u=2 and rtrim(poznw)=rtrim(?mpoznw) order by shw"
		rr = sqlexec(hh,csql,'creplace')
		if rr = -1
			eodbc('transfer_uzel sele3')
			sqldisconnect(hh)
			return
		endif
		
		* перебираем записи 
		select creplace
		scan all
			waitproc(recno(),reccount(),'Выбрано ')
			
			
		endscan
		
	
	endif
	sqldisconnect(hh)
else
	eodbc('transfer_uzel conn')
endif

