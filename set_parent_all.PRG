* Установить для всех записей KT поле parent

public pgl_level,pgl_porad
local lcMsg,svParent

* готовим протокол
do warn_open with 'preptree.log'
do warn with 'Начинаем формирование дерева KT'
do warn with '*****************************************'

* выбираем все изделия
select dist kod from izd where kod=23 into cursor cc_izd
scan all
	*wait 'Код изделия = '+alltrim(str(cc_izd.kod)) nowait window 
	do warn with 'Изделие Код='+alltrim(str(cc_izd.kod)) 
	
	* ищем изделие в kt
	select * from kt where d_u = 3 and shw = cc_izd.kod into cursor cc_kt
	if reccount()=1
		* инициализируем переменные
		m.pgl_level = 0
		m.pgl_porad = 1
		* нашли строку изделия в kt
		do warn with 'ИЗДЕЛИЕ   ' + cc_kt.poznd + '   ' + cc_kt.naimd 
		update kt set parent = cc_izd.kod*1000000, porad = cc_izd.kod*1000000+m.pgl_porad ;
			where kod = cc_kt.kod		
		m.pgl_porad = m.pgl_porad + 1
		m.svParent = cc_kt.kod
		do open_node with m.svParent, cc_izd.kod		
	else
		if reccount()>1
			do warn with 'ОШИБКА! В KT для одного изделия с кодом '+alltrim(str(cc_izd.kod))+' найдено более 1 записи с d_u = 3!'
		else
			do warn with 'ОШИБКА! В KT для изделия с кодом '+alltrim(str(cc_izd.kod))+' не найдено ни одной записи с d_u = 3!'		
		endif		
	endif 
	use in cc_kt

endscan
use in cc_izd

wait window nowait 'Формирование дерева КТС завершено.' 

do warn_close
MODIFY command preptree.log

***********************************************
* процедура раскрытия узла
procedure open_node
lparam lprKod, lprShw
local lcCursName,svPoznw,svParent,lcMsg,svKod

	* определить уровень
	m.pgl_level = m.pgl_level + 1
	
	* контроль уровня
	* wait window 'ВНИМАНИЕ. Уровень узла превысил 100!'
		
	* создать имя курсора
	m.lcCursName = 'cct'+alltrim(str(m.pgl_level))
	
	* debug
	* wait 'Изделие '+str(m.lprShw)+'   Level '+allt(str(m.pgl_level)) + '  ' + m.lcCursName nowait wind
	
	* вывести ход работы
	lcRabota = alltrim(str(100*recno('cc_izd')/reccount('cc_izd')))+'%'
	wait window nowait 'Выполняется переформирование дерева КТС. Выполнено '+lcRabota 
		
	* получить обозначение узла
	select * from kt where kt.kod = m.lprKod into cursor c_707
	if recc() > 0
		m.svPoznw = c_707.poznd
	else
		m.svPoznw = ''		
	endif 
	use in c_707
	
	* проверить корректность полученных данных
	if empty(m.svPoznw)
		wait 'ОШИБКА! Произошел переход на запись с пустым обозначением узла или запись с указанным кодом не найдена!' wind		
		return to master
	endif
	
	* обработать детали
	select * from kt where (d_u = 1) and kt.shw = m.lprShw and kt.poznw = m.svPoznw into cursor c_707
	scan all
		* записать в протокол
		m.lcMsg = 'ДЕТАЛЬ    ' + c_707.poznd + '  ' + c_707.naimd
		@ prow(),4*m.pgl_level say m.lcMsg
		* записать в базу		
		update kt set parent = m.lprKod, porad = m.lprShw*1000000+m.pgl_porad where kod = c_707.kod		
		m.pgl_porad = m.pgl_porad+1
	endscan
	use in c_707
	
	* обработать узлы
	select * from kt ;
		where d_u = 2 and kt.shw = m.lprShw and kt.poznw = m.svPoznw and kt.kornw <> kt.kornd ;
		into cursor (m.lcCursName)
	scan all
		scatter memvar
		m.svKod = m.kod
		* записать в протокол
		m.lcMsg = 'ВУЗОЛ     ' + m.poznd + '  ' + m.naimd
		@ prow(),4*m.pgl_level say m.lcMsg
		* записать в базу
		update kt set parent = m.lprKod, porad = m.lprShw*1000000+m.pgl_porad where kod = m.kod
		m.pgl_porad = m.pgl_porad+1
		* раскрыть текущий узел
		do open_node with m.svKod,m.lprShw		
	endscan	
	use in (m.lcCursName)	
	
	* уменьшить уровень
	m.pgl_level = m.pgl_level - 1
		
	* (ВЫХОД только здесь!)
	return
endproc