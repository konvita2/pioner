* переброска справочников из ОГТ в ПДО
set deleted on
set exclusive off

local hh
hh = sqlconnect('sqldb','sa','111')
if hh > 0
	* dosp
	local vid,kod,im,sim,us,obor
	local rr
	
	wait window nowait 'Удаление записей dosp' 
	rr = sqlexec(hh,'delete from dosp')
	
	select * from dosp into cursor c10
	scan all
		wait window nowait 'Сброс dosp '+str(100*recno()/reccount())+'%' 
		select c10
		scatter memvar 
		
		rr = sqlexec(hh,'insert into dosp (vid,kod,im,sim,us,obor) values (?vid,?kod,?im,?sim,?us,?obor)')
				
	endscan 
	use in c10
		
	* mater
	local nsk,gr,sort,sp,sh,kod,kodm,tm,dm,nsort,dp,shp,ps,ei,cena,kol,data_p,naim,oboz,uv,pol,tver,ostatok,saldo_o,data_o,sklad,ndok,kod_okp,post,pri,rekom,v1000,ei1
	local rr
	
	wait window nowait 'Удаление записей mater' 
	rr = sqlexec(hh,'delete from mater')
	
	select * from mater into cursor c10
	scan all
		wait window nowait 'Сброс mater '+str(100*recno()/reccount())+'%' 
		select c10
		scatter memvar
		
		local ms 
		ms = 'insert into mater (nsk,gr,sort,sp,sh,kod,kodm,tm,dm,nsort,dp,shp,ps,ei,cena,kol,naim,oboz,uv,pol,'+;
			'tver,ostatok,sklad,pri,rekom,v1000,ei1) values '+;
			'(?nsk,?gr,?sort,?sp,?sh,?kod,?kodm,?tm,?dm,?nsort,?dp,?shp,?ps,?ei,?cena,?kol,'+;
			'?naim,?oboz,?uv,?pol,?tver,?ostatok,?sklad,?pri,?rekom,?v1000,?ei1)'
		rr = sqlexec(hh,ms)
		if rr = -1			
			
			*wait window no'kodm = '+str(c10.kodm)
			return
		endif 	
	
	endscan 
	use in c10
	
	* izd (only for new )
	local pshwz,pribf
	select * from izd into cursor cci
	scan all
	
		wait window nowait 'Изделия ' + alltrim(str(100*recno()/reccount())) + '%' 				
		
		pshwz = cci.shwz
		pribf = cci.ribf
		
		rr = sqlexec(hh,'select * from izdfull '+;
				'where rtrim(shwz) = rtrim(?m.pshwz) and '+;
				'rtrim(ribf) = rtrim(?m.pribf)')
		if rr = -1
			return
		else
			select sqlresult
			if reccount()=0
				select cci
				scatter memvar 
			
				rr = sqlexec(hh,'insert into izdfull (kod,ribf,im,shwz,data_z,data_p,partz1,'+;
						'partz2,dat_td,cena) values '+;
						'(?m.kod,?m.ribf,?m.im,?m.shwz,?m.data_z,?m.data_p,?m.partz1,'+;
						'?m.partz2,?m.dat_td,?m.cena)')
				if rr = -1
					return
				else
					wait window nowait 'Добавление' 
					*** debug *** wait window 'Добавление '+pshwz 
				endif		
				
			endif
			
		endif		
	
	endscan 
	use in cci
		

	sqldisconnect(hh)
else
	wait window 'ошибка ODBC'
endif

