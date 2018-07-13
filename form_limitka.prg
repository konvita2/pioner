* ФОРМИРОВАНИЕ ЛИМИТНО-ЗАБОРНОЙ КАРТЫ
* вызывает r_limitka
* использует параметры

lparam parHead
local nnpp,nv1000

delete from temp1
if used('temp1')
	use in temp1
endif
select 0
use temp1 exclusive
pack
use in temp1

*** создать курсор
*!*	create table temp ;
*!*		(npp n(5), nsk n(5), naim c(100), izd c(100), ;
*!*		shwz c(30), ei c(10), kol n(10,3), cena n(10,2))

*** заполнить курсор
*!*	select vm.*,vi.ribf as ribf from db!v_matrast vm, db!v_izd vi ;
*!*		where id = m.parHead and allt(vm.shwz) == allt(vi.shwz) and !empt(vi.shwz);
*!*		order by idd into cursor crep2

select vm.*,getribf(vm.shwz) as ribf, getzap(vm.shwz) as kolz ;
	from db!v_matrast vm ;
	where id = m.parHead ;
	order by idd into cursor crep2
if recc() > 0
	m.nnpp = 1
	select crep2
	scan all
		local lnNorma
		m.lnNorma = getnorma(crep2.ribf,crep2.kodm)
		insert into temp1 ;
				(npp, nsk, naim, ;
				izd, shwz, ei, ;
				kol, cena, v1000, note, norma, kolz) ;
			values ;
				(m.nnpp, crep2.nsk, crep2.naim, ;
				crep2.ribf, crep2.shwz, crep2.ei, ;
				crep2.kol, crep2.cena, crep2.v1000, crep2.note, m.lnNorma*crep2.kolz, crep2.kolz)  && temporary
	
		m.nnpp = m.nnpp + 1
	endscan
else
	wait 'ОШИБКА! Нет расхода с заданным кодом' nowait wind
endif
use in crep2

*** скидываем в temp
if used('temp1')
	use in temp1
endif
select 0
use temp1 again	

*** подготовить переменные для заголовка
local mrep_skladout, mrep_skladin, mrep_dat, mrep_komu, mrep_doc
local tmp1

select * from db!matras where id = m.parHead into cursor c_306
if recc() > 0
	***
	m.tmp1 = c_306.sklad_id
	select * from db!v_dosp2 where kod = m.tmp1 into cursor c_307
	if recc() > 0
		m.mrep_skladout = c_307.im
	else
		m.mrep_skladout = ''
	endif
	use in c_307	
	***
	if c_306.vid = 0	
		m.tmp1 = c_306.post_id
		select * from db!v_dosp2 where kod = m.tmp1 into cursor c_307
		if recc() > 0
			m.mrep_skladin = c_307.im
		else
			m.mrep_skladin = ''
		endif
		use in c_307	
	else
		m.tmp1 = c_306.post_id
		select * from db!v_post where kod = m.tmp1 into cursor c_307
		if recc() > 0
			m.mrep_skladin = c_307.im
		else
			m.mrep_skladin = '' 
		endif
		use in c_307
	endif	
	***
	m.mrep_dat = c_306.dat
	m.mrep_doc = c_306.doc
	m.mrep_komu = c_306.cherez
	
else
	m.mrep_skladout = ''	
endif
use in c_306

*** открыть отчет
SET DATE BRITISH 
report form r_limitka preview

*select crep1
*browse

*** удалить курсор
use in temp1

*** release
release mrep_skladout, mrep_skladin, mrep_dat, mrep_komu, mrep_doc


************************************************************
**** функция для получения кода изделия если не пустой shwz
FUNCTION getribf(par_shwz)
	LOCAL res,svwa
	m.svwa = SELECT()
	
	IF EMPTY(m.par_shwz)
		m.res = space(20)
	ELSE 
		SELECT * from izd ;
			WHERE ALLTRIM(shwz) == ALLTRIM(m.par_shwz) ;
			INTO CURSOR ct_izd
		IF RECCOUNT() > 0
			m.res = ct_izd.ribf
		ELSE 
			m.res = space(20)
		ENDIF 
		USE IN ct_izd		
	ENDIF 

	SELECT (m.svwa)
	RETURN m.res
ENDFUNC 


*************************************************************
**** Функция для получения нормы по материалу и изделию
function getnorma(par_ribf,par_kodm)
	local lnRes
	if m.par_kodm < m.glMater	&& обычные материалы
		select sum(nrmd*koli) as s1 ;
			from kt ;
			where ;
				d_u = 1 and ;
				!empty(poznd) and ;
				kodm < m.glMater and ;
				kodm = m.par_kodm and ;
				alltrim(pozn) == alltrim(m.par_ribf) ;
			into cursor ccc_sum		
		m.lnRes = ccc_sum.s1	
		use in ccc_sum
	else						&& комплектующие
		select sum(koli) as s1;
			from kt ;
			where ;
				d_u = 1 and ;
				empty(poznd) and ;
				kodm >= m.glMater and ;
				kodm = m.par_kodm and ;
				alltrim(pozn) == alltrim(m.par_ribf) ;
			into cursor ccc_sum	
		m.lnRes = ccc_sum.s1
		use in ccc_sum
	endif
	return m.lnRes
endfunc 


***************************************************************
**** Функция для получения количества в запуске
function getzap(par_shwz)
	local lnRes
	m.lnRes = 0
	select partz2-partz1+1 as kolzz ;
		from izd ;
		where alltrim(shwz) == alltrim(m.par_shwz) and !empty(shwz) ;
		into cursor ccc_zap
	if reccount()>0
		m.lnRes = ccc_zap.kolzz	
	endif
	use in ccc_zap	
	return m.lnRes	
endfunc