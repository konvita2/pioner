* koliz - по новому
* розраховати кількість у виробі простою рекурсією

public pgl_level, pgl_porad, pgl_multi, pgl_shw
local lcRibf,fn

local hh,rr

* готуємо протокол роботи
set device to print
fn = sys(3)+'.txt'
set print to (fn)
@ prow(),0 say "Протокол расчета количества в изделии"

* иниц porad та level
m.pgl_level = 0
m.pgl_porad = 1
m.pgl_multi = 1

hh = sqlconnect('sqldb','sa','111')
if hh <= 0
	eodbc('new_koliz conn')
endif

* вибрати вироб
do form f_izd_vib_sql to m.lcRibf
if !empty(m.lcRibf)
	* знайти код виробу
	m.pgl_shw = get_izd_kod_by_ribf(lcRibf)
	
	
	*////////////////////////////////////
	* проверка на то что в узлах нет kol=1
	wait window nowait 'Выполняется проверка' 
	local hhh,rrr,er
	er = .f.
	hhh = sqlconnect('sqldb','sa','111')
	if hhh>0
		rrr = sqlexec(hhh,'select * from kt where d_u=2 and kol=0 and shw=?pgl_shw','cda')
		if rrr = -1
			eodbc('new_koliz test sele')
		endif
		
		select cda
		scan all
			wait window 'ВНИМАНИЕ! Кол = 0 для узла ' + alltrim(cda.kornd) + '!' 
		endscan 
		
		select cda
		if reccount()>0
			er = .t.
		endif
	
		use in cda
		sqldisconnect(hhh)
	else
		eodbc('new_koliz test conn')
	endif
	release hhh,rrr
	
	if er
		wait window 'РАСЧЕТ НЕВОЗМОЖЕН! Исправьте ошибки.' 	
		sqldisconnect(hh)
		return
	endif
	WAIT WINDOW pgl_shw
	* прибрати порядок
	*update kt set koli = 0 where shw = m.pgl_shw
	local h1,r1
	h1 = sqlconnect('sqldb','sa','111')
	if h1 > 0
		r1 = sqlexec(h1,'update ktfull set koli=0 where shw = ?pgl_shw')
		if r1 = -1
			eodbc('new_koliz upd1')
		endif	
		sqldisconnect(h1)
	else
		eodbc('new_koliz conn1')
	endif
	
	* kol=0 для kornd = kornw
	*update kt set kol=0 where shw = m.pgl_shw and kornd = kornw and d_u = 2
	local h1,r1
	h1 = sqlconnect('sqldb','sa','111')
	if h1 > 0
		r1 = sqlexec(h1,'update ktfull set kol=0 where shw = ?pgl_shw and kornd=kornw and '+;
						'd_u=2')
		if r1 = -1
			eodbc('new_koliz upd2')
		endif	
		sqldisconnect(h1)
	else
		eodbc('new_koliz conn11')
	endif
	
	* починаємо розрахунок
	*select * from kt where shw = m.pgl_shw and d_u = 3 into cursor cc_100
	local h1,r1
	h1 = sqlconnect('sqldb','sa','111')
	if h1 > 0
		r1 = sqlexec(h1,'select * from kt where shw=?pgl_shw and d_u=3','cc_100')
		if r1 = -1
			eodbc('new_koliz sele11')
		endif	
		sqldisconnect(h1)
	else
		eodbc('new_koliz conn2')
	endif	
	if recc() > 0
		* пишемо у виріб
		@ prow(),0 say "издел " + cc_100.pozn + '(kol = ' + allt(str(cc_100.kol)) + ;
			'   koli = ' + allt(str(cc_100.kol)) + ')'
		if cc_100.kol = 0	
			@ prow(),0 say "ВНИМАНИЕ! kol = 0"	
		endif
		***update kt set koli = kol where kod = cc_100.kod
		local h1,r1
		h1 = sqlconnect('sqldb','sa','111')
		if h1 > 0
			r1 = sqlexec(h1,'update ktfull set koli=kol where kod=?cc_100.kod')
			if r1 = -1
				eodbc('new_koliz upd3')
			endif		
			sqldisconnect(h1)
		else
			eodbc('new_koliz conn3')
		endif
		
		* міняємо multi
		m.pgl_multi = m.pgl_multi * cc_100.kol
		* відкриваємо вузол
		do open_node with cc_100.kod
	else
				
	endif
	use in cc_100
else
	return	

endif
release pgl_level, pgl_porad, pgl_multi

* вивести нерозраховані рядки
@ prow(),0 say ''
@ prow(),0 say '********** koli = 0 ********************'
* select * from kt where shw = m.pgl_shw and koli = 0 into cursor c_710
local h1,r1
h1 = sqlconnect('sqldb','sa','111')
if h1 > 0
	r1 = sqlexec(h1,'select * from kt where shw=?pgl_shw and koli=0','c_710')
	if r1 = -1
		eodbc('new_koliz sele4')
	endif
	sqldisconnect(h1)
else
	eodbc('new_koliz conn4')
endif
scan all
	@ prow(),0 say 'd_u='+allt(str(c_710.d_u))+' '+c_710.kornd+' '+c_710.naimd 
endscan
use in c_710

sqldisconnect(hh)
	
set print to
set device to screen
modi file (fn)
erase (fn)

**********************************************
procedure open_node
lparam lprKod
local svPoznw,curName,svKol,svKod

	* збільшити рівень
	m.pgl_level = m.pgl_level + 1
	
	* debug
	wait "Уровень "+allt(str(m.pgl_level)) wind nowait

	* отримати svPoznw
	*select * from kt where kod = m.lprKod into cursor c_704
	local h1,r1
	h1 = sqlconnect('sqldb','sa','111')
	if h1 > 0
		r1 = sqlexec(h1,'select * from kt where kod=?lprkod','c_704')
		if r1 = -1
			eodbc('new_koliz sele5')	
		endif	
		sqldisconnect(h1)
	else
		eodbc('new_koliz conn5')
	endif	
	if recc() > 0
		m.svPoznw = c_704.poznd
	else
		wait 'new_koliz: open_node: неправильно передан параметр'
		cancel
	endif
	use in c_704
	
	* отримати ім'я для поточного курсора
	m.curName = 'cct'+allt(str(m.pgl_level))
	
	* розрахувати деталі
*!*		select * from kt ;
*!*			where (d_u = 1 or d_u = 4 or d_u = 5) and poznw = svPoznw and shw = m.pgl_shw ;
*!*				into cursor (curName)
	local h1,r1
	h1 = sqlconnect('sqldb','sa','111')
	if h1 > 0
		r1 = sqlexec(h1,'select * from kt where (d_u=1 or d_u=4 or d_u=5) and '+;
						'rtrim(poznw)=rtrim(?svPoznw) and shw=?pgl_shw',curname)
		if r1 = -1
			eodbc('new_koliz sele6')	
		endif	
		sqldisconnect(h1)
	else
		eodbc('new_koliz conn6')
	endif	
	
	scan all
		scatter memvar		
		
		local jj
		do	case
			case	m.d_u=1
				jj = 'деталь '
			case	m.d_u=4
				jj = 'покупн '
			case	m.d_u=5
				jj = 'вспомг '
		endcase 
		
		@ prow(),0 say space(4*m.pgl_level) + jj + m.poznd + '  ' + m.kornd + ;
			'(kol = ' + allt(str(m.kol)) + '   koli = ' + allt(str(kol * m.pgl_multi)) + ')'
		if m.kol = 0	
			@ prow(),0 say "ВНИМАНИЕ! kol = 0"	
		endif	
		*update kt set koli = kol * m.pgl_multi + koli where kod = m.kod
		local h1,r1
		h1 = sqlconnect('sqldb','sa','111')
		if h1 > 0
			r1 = sqlexec(h1,'update ktfull set koli = kol*?pgl_multi + koli where kod=?m.kod')
			if r1 = -1
				eodbc('new_koliz upd7')	
			endif	
			sqldisconnect(h1)
		else
			eodbc('new_koliz conn7')
		endif	
	
	endscan	
	use	in (curName)
	
	* розрахувати і відкрити вузли	
*!*		select * from kt ;
*!*			where d_u = 2 and shw = m.pgl_shw and poznw = m.svPoznw and kornw <> kornd ;
*!*			into cursor (curName)
	local h1,r1
	h1 = sqlconnect('sqldb','sa','111')
	if h1 > 0
		r1 = sqlexec(h1,'select * from kt where d_u=2 and shw=?pgl_shw and '+;
						'rtrim(poznw)=rtrim(?svpoznw) '+;
						'and kornw<>kornd',curname)
		if r1 = -1
			eodbc('new_koliz sele8')	
		endif	
		sqldisconnect(h1)
	else
		eodbc('new_koliz conn8')
	endif			
	scan all
		scatter memvar
		m.svKol = m.kol
		m.svKod = m.kod
		
		*debug
*!*			if alltrim(m.kornd) == '2.3'
*!*				susp
*!*			endif
*!*			
		@ prow(),0 say space(4*m.pgl_level)+'узел  ' + m.poznd + '  ' + m.kornd + ;
			'(kol = ' + allt(str(m.kol)) + '   koli = ' + allt(str(kol * m.pgl_multi)) + ')'
		if m.svKol = 0	
			@ prow(),0 say "ВНИМАНИЕ! kol = 0"	
		endif	
		*update kt set koli = kol * m.pgl_multi + koli where kod = m.kod
		local h1,r1
		h1 = sqlconnect('sqldb','sa','111')
		if h1 > 0
			r1 = sqlexec(h1,'update ktfull set koli = kol * ?pgl_multi + koli where kod=?m.kod')
			if r1 = -1
				eodbc('new_koliz sele9')	
			endif	
			sqldisconnect(h1)
		else
			eodbc('new_koliz conn9')
		endif		
		
*!*			select * from kt ;
*!*				where d_u = 2 and kt.shw = m.pgl_shw and kt.kornd = kt.kornw and kt.poznd = m.poznd ;
*!*				into cursor c_705
		
		local h1,r1
		h1 = sqlconnect('sqldb','sa','111')
		if h1 > 0
			r1 = sqlexec(h1,'select * from kt where d_u=2 and kt.shw=?pgl_shw and '+;
							'kt.kornd=kt.kornw and kt.poznd=?m.poznd','c_705')
			if r1 = -1
				eodbc('new_koliz sele10')	
			endif	
			sqldisconnect(h1)
		else
			eodbc('new_koliz conn10')
		endif	
		
		if recc() > 0
			*update kt set kol = m.kol, koli = m.kol * m.pgl_multi + koli where kod = c_705.kod				
			local h1,r1
			h1 = sqlconnect('sqldb','sa','111')
			if h1 > 0
				r1 = sqlexec(h1,'update ktfull set kol=?m.kol, koli=?m.kol*?m.pgl_multi+koli '+;
								'where kod=?c_705.kod')
				if r1 = -1
					eodbc('new_koliz upd12')	
				endif	
				sqldisconnect(h1)
			else
				eodbc('new_koliz conn12')
			endif		
		else
			@ prow(),0 say space(4*m.pgl_level) + 'ОШИБКА! Не найден "брат".'
		endif	
		use in c_705	
		m.pgl_multi = m.pgl_multi * m.svKol
		do open_node with m.svKod
		m.pgl_multi = m.pgl_multi / m.svKol
	endscan	
	use	in (curName)
	
	* зменшити рівень (вихід має бути лише тут)
	m.pgl_level = m.pgl_level - 1

	return
endproc
 