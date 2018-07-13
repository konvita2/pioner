
* константы
marmin = 31
marmax = 57

* процедура формирования таблицы koop
local lcShwz
do form f_izd_vib_shwz to lcShwz
if !empty(lcShwz)
	* проверить не занесено ли это изделие уже
	local a[1]
	select count(*) as rrr from koop ;
		where alltrim(shwz) == alltrim(lcShwz) ;
		into array a
	if a[1]	= 0
		* сформировать 
		do add_koop_by_izd with lcShwz
	else
		wait window 'Изделие с шифром запуска '+;
			alltrim(lcShwz)+' уже занесено в базу кооперации!' 
	endif	
endif

return

* ============================================
* подпрограмма переноса по конкретному изделию  
procedure add_koop_by_izd(par_izd_shwz)
	wait window nowait 'Формируется изделие '+alltrim(par_izd_shwz)+' в базе кооперации!' 
	select * from ww ;
		where ;
			between(mar,marmin,marmax) and ;
			alltrim(shwz) == alltrim(par_izd_shwz) ;
		order by ;
			poznd ;
		into cursor c110
	scan all
		select c110
		scatter memvar 
		* init some fields
		m.st = 0
		m.kodpr = ''
		m.ndog = ''
		m.tel = 0
		m.nto = 0
		*m.data_pol = date()
		*m.data_nd = date()
		*m.data_od = date()
		*m.data_o = date()
		release data_pol,data_nd,data_od,data_o
		m.post = 0
		m.pol = 0
		* generate new id
		local b[1]
		select count(*) as rrr from koop into array b
		if b[1]>0
			select max(id) as maxid from koop into array b
			m.id = b[1]+1
		else
			m.id = 1
		endif
		* insert
		insert into koop from memvar 		
	endscan
	wait window nowait 'Добавлено '+str(reccount())+' записей' 				
	use in c110		 		
endproc 