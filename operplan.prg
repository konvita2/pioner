* запустить оперативное планирование
local lbCont,lcFilter

* открыть форму запроса
do form f_ww_operplan to m.lcFilter

m.lbCont = .t.
* цикл
do while m.lbCont
	* открыть форму просмотра производственной базы
	if !empty(m.lcFilter)
		do form f_ww_prosm with 2,m.lcFilter		
		do form f_ww_operplan to m.lcFilter
	else
		m.lbCont = .f.	
	endif	
enddo