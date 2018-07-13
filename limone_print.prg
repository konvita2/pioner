* печать горчичников
* список поставляется в курсоре climonep
local mshwz
local nnom,cc
local mcode39

cc = 0
nnom=1

*** ВЫВОД ТАБЛИЦЫ В EXCEL
wait window nowait 'Запуск Excel'
local loexcel
loexcel = createobject('Excel.Application')
loexcel.workbooks.add()
loexcel.workbooks.open(sys(5)+sys(2003)+'\lzkrazone.xls')
loexcel.displayalerts = .f.


select climonep
scan all

	mshwz = alltrim(climonep.shwz)

	wait window nowait 'Выполнено '+alltrim(str(100*recno()/reccount()))+'%'

	* copy
	if nnom <> 1
		loexcel.range(loexcel.cells(1,1),loexcel.cells(10,8)).select
		loexcel.selection.copy
		loexcel.range(loexcel.cells(nnom,1),loexcel.cells(nnom,1)).select
		loexcel.selection.pastespecial(-4122,-4142,.f.,.f.)
		loexcel.selection.pastespecial(-4104,-4142,.f.,.f.)
	endif
	
	mcode39 = '*' + strtran(str(climonep.id,10),' ','0') + '*'
	
	loexcel.cells(nnom,1).value = 'Лист '+alltrim(str(recno()))+' из '+alltrim(str(reccount()))
	loexcel.cells(nnom+1,2).value = 'Лимитно-заборная карта №' + str(climonep.id) + ' по складу №'+alltrim(str(climonep.mar1))
	loexcel.cells(nnom+2,6).value = mcode39
	loexcel.cells(nnom+3,2).value = 'Дата ' +dtoc(date()) +'   план-запуск ' ;
		+ alltrim(str(get_izd_kolzap_by_shwz(mshwz)))+' шт.'
	loexcel.cells(nnom+4,2).value = 'Продукция: '+mshwz
	loexcel.cells(nnom+5,2).value = alltrim(get_izd_ribf_by_shwz(mshwz))+' '+alltrim(get_izd_im_by_shwz(mshwz))
	loexcel.cells(nnom+7,1).value = ''
	loexcel.cells(nnom+7,2).value = alltrim(str(climonep.kodm))
	loexcel.cells(nnom+7,3).value = alltrim(climonep.maternaim)
	loexcel.cells(nnom+7,4).value = alltrim(climonep.materei1)
	loexcel.cells(nnom+7,5).value = climonep.kolzat
	loexcel.cells(nnom+7,6).value = climonep.koltech
	
	nnom = nnom+8
	
	* 
	loexcel.cells(nnom,1).value = 'Уч.'
	loexcel.cells(nnom,2).value = climonep.mar2
	loexcel.cells(nnom,3).value = alltrim(climonep.mar2im)
	loexcel.cells(nnom,4).value = alltrim(climonep.materei1)
	loexcel.cells(nnom,5).value = climonep.kolzat
	loexcel.cells(nnom,6).value = climonep.koltech
	
	* форматы
	loexcel.range(loexcel.cells(nnom,1),loexcel.cells(nnom,8)).select
	loexcel.selection.horizontalalignment = -4108
	
	loExcel.range(loExcel.cells(nnom,3),loExcel.cells(nnom,3)).select
	loExcel.selection.horizontalalignment = -4131

	* рамка вокруг клеток
	loexcel.range(loexcel.cells(nnom,1),loexcel.cells(nnom,8)).select
	loexcel.selection.VerticalAlignment = -4160

	loexcel.selection.borders(9).linestyle = 1
	loexcel.selection.borders(7).linestyle = 1
	loexcel.selection.borders(10).linestyle = 1
	loexcel.selection.borders(8).linestyle = 1
	loexcel.selection.borders(11).linestyle = 1
	
	nnom = nnom + 2
	loExcel.cells(nnom,1).value = 'Отпустил _________'
	loExcel.cells(nnom,6).value = 'Принял _________'
	
	nnom = nnom+2    &&14
	cc = cc+1
	if cc % 5 = 0
		loexcel.activewindow.selectedsheets.hpagebreaks.add(loexcel.range(loexcel.cells(nnom,1),loexcel.cells(nnom,1)))
	endif

endscan

loexcel.visible = .t.
