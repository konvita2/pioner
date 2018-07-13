local lcShwz
* Экспорт лимитно-заборных карт

close tables all
wait window nowait 'Очистка файла limit.dbf'
set safety off 
select 0
use limit exclusive 
zap
use

wait window nowait 'Перекачка информации об ЛЗК'
select ; 
		mm.doc as ndoc, mm.dat as dat, mm.sklad_id as sklad1, ;
		mm.post_id as sklad2, mm.vid as vid, mm.cherez as cherez, ;
		mt.kodm as kodm, mt.nsk as nsk, mt.kol as kol, ;
		mt.cena as cena, mt.shwz as shwz, mt.ei as ei, ;
		mt.note as note, 1000000*mm.id+mt.id as did, mt.izm as izm, ;
		9999 as shw, 999999.999 as kol1, space(30) as oboz ;		
	from matras mm,matrast mt ;
	where mm.id = mt.head_id ;
	order by did ;
	into table cc_exp  
* изменить числовые поля
update cc_exp set shw = 0, kol1 = 0, oboz = ''	
* добавление полей
scan all for !empty(shwz)
	select * from izd where alltrim(shwz) == alltrim(cc_exp.shwz) ;
		into cursor cc_izd
	if reccount() > 0
		select cc_exp
		replace shw  with cc_izd.kod
		replace kol1 with cc_izd.partz2 - cc_izd.partz1 + 1
		replace oboz with cc_izd.ribf	
	endif	
	use in cc_izd
endscan	
* сброс в экспорт	
scan all	
	scatter memvar	
	insert into limit from memvar
endscan	
use in cc_exp	

close tables all

wait window nowait 'Перекачка ЛЗК завершена!'
