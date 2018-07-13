
local nom
local locnom

nom = 1

*** ВЫВОД ТАБЛИЦЫ В EXCEL
wait window nowait 'Запуск Excel'
local loexcel
loexcel = createobject('Excel.Application')
loexcel.workbooks.add()
loexcel.workbooks.open(sys(5)+sys(2003)+'\pttform.xls')
loexcel.displayalerts = .f.

* выбираем строки
select * from ptt order by id into cursor c500
scan all
	***
	wait window nowait 'Вывод в Excel ' + str(100*recno()/reccount()) + '%'

	***
	if nom = 1	&& вывести форму а
		loExcel.sheets('f').select
		loExcel.range(loExcel.cells(1,1),loExcel.cells(33,110)).select
		loExcel.selection.copy
		loExcel.sheets('Лист3').select
		loExcel.range(loExcel.cells(1,1),loExcel.cells(1,1)).select
		loExcel.Selection.PasteSpecial(-4122,-4142,.f.,.f.)
		loExcel.range(loExcel.cells(1,1),loExcel.cells(1,1)).select
		loExcel.Selection.PasteSpecial(-4104,-4142,.f.,.f.)
		loExcel.range(loExcel.cells(1,1),loExcel.cells(1,1)).select
		loExcel.Selection.PasteSpecial(8,-4142,.f.,.f.)
		* set col 1 width = 0
		loExcel.range(loExcel.cells(1,1),loExcel.cells(1,1)).select
		loExcel.selection.ColumnWidth = 0
		
		* заполнить заголовок формы 1
		loExcel.cells(8,54).value = alltrim(c500.poznd)
		loExcel.cells(8,93).value = alltrim(c500.kttp)
		loExcel.cells(11,44).value = alltrim(c500.naimd)
		loExcel.cells(13,36).value = alltrim(c500.kodms)
		loExcel.cells(15,6).value = c500.kod
		loExcel.cells(15,19).value = alltrim(c500.eb)
		loExcel.cells(15,23).value = c500.md
		loExcel.cells(15,30).value = '1'
		loExcel.cells(15,36).value = (c500.rash)
		loExcel.cells(15,43).value = (c500.kim)
		loExcel.cells(15,48).value = (c500.kz)
		loExcel.cells(15,61).value = (c500.pir)
		loExcel.cells(15,82).value = (c500.kd)
		loExcel.cells(15,88).value = (c500.mz)
		
	endif
	
	***
	if (nom - 14) % 16 = 0	and nom > 1	&& вывести форму а1
		
		* расчет верхней точки для вывода рамки формы 1б		
		local topnom
		topnom = nom + 20 + 15*(int(nom/14)-1)
		locnom = 13
	
		loExcel.sheets('f1').select
		loExcel.range(loExcel.cells(1,1),loExcel.cells(31,110)).select
		loExcel.selection.copy
		loExcel.sheets('Лист3').select
		loExcel.range(loExcel.cells(topnom,1),loExcel.cells(topnom,1)).select
		loExcel.Selection.PasteSpecial(-4122,-4142,.f.,.f.)
		loExcel.range(loExcel.cells(topnom,1),loExcel.cells(topnom,1)).select
		loExcel.Selection.PasteSpecial(-4104,-4142,.f.,.f.)
		loExcel.range(loExcel.cells(topnom,1),loExcel.cells(topnom,1)).select
		loExcel.Selection.PasteSpecial(8,-4142,.f.,.f.)
		
		loExcel.ActiveWindow.SelectedSheets.HPageBreaks.Add(loExcel.Range(loExcel.Cells(topnom,1),loExcel.Cells(topnom,1)))
		* set col 1 width = 0
		*loExcel.range(loExcel.cells(1,1),loExcel.cells(1,1)).select
		*loExcel.selection.ColumnWidth = 0
		
		* заполнить заголовок формы 1б
		loExcel.cells(topnom+5,87).value = alltrim(c500.pozn)
		loExcel.cells(topnom+7,71).value = alltrim(c500.poznd)
		loExcel.cells(topnom+7,93).value = alltrim(c500.kttp)
	
	endif 
	
	
	* выводим строки с 1 по 13
	if nom >= 1 and nom <= 13
		do	case
			case	c500.buk = 'А'
				loExcel.cells(nom+18,1).value = 'А' + alltrim(str(nom))
				
				loExcel.cells(nom+18,6).value = c500.ceh
				loExcel.cells(nom+18,18).value = c500.oper
				loExcel.cells(nom+18,23).value = c500.knop
				loExcel.cells(nom+18,52).value = c500.od
				
				* formats
				loExcel.range(loExcel.cells(nom+18,1),loExcel.cells(nom+18,110)).select
				loExcel.selection.numberformat = '@'
				loExcel.selection.font.size = 10
				loExcel.selection.rowheight = 18
				
				loExcel.range(loExcel.cells(nom+18,6),loExcel.cells(nom+18,9)).select
				loExcel.selection.merge
				
				loExcel.range(loExcel.cells(nom+18,18),loExcel.cells(nom+18,22)).select
				loExcel.selection.merge
				
				
			case	c500.buk = 'Б'
				loExcel.cells(nom+18,1).value = 'Б' + alltrim(str(nom))
				
				loExcel.cells(nom+18,6).value = c500.knob
				loExcel.cells(nom+18,56).value = c500.prof
				loExcel.cells(nom+18,63).value = c500.p
				loExcel.cells(nom+18,67).value = c500.ut
				loExcel.cells(nom+18,72).value = c500.kp
				loExcel.cells(nom+18,76).value = c500.koid
				loExcel.cells(nom+18,96).value = c500.tpz
				loExcel.cells(nom+18,103).value = c500.tsht
				
				* formats
				loExcel.range(loExcel.cells(nom+18,1),loExcel.cells(nom+18,110)).select
				loExcel.selection.numberformat = '@'
				loExcel.selection.font.size = 10
				loExcel.selection.rowheight = 18
				
				loExcel.range(loExcel.cells(nom+18,6),loExcel.cells(nom+18,51)).select
				loExcel.selection.merge
				
				loExcel.range(loExcel.cells(nom+18,56),loExcel.cells(nom+18,62)).select
				loExcel.selection.merge
				
				loExcel.range(loExcel.cells(nom+18,63),loExcel.cells(nom+18,66)).select
				loExcel.selection.merge
				
				loExcel.range(loExcel.cells(nom+18,67),loExcel.cells(nom+18,71)).select
				loExcel.selection.merge
				
				loExcel.range(loExcel.cells(nom+18,72),loExcel.cells(nom+18,75)).select
				loExcel.selection.merge
				
				loExcel.range(loExcel.cells(nom+18,76),loExcel.cells(nom+18,80)).select
				loExcel.selection.merge
				
				loExcel.range(loExcel.cells(nom+18,81),loExcel.cells(nom+18,85)).select
				loExcel.selection.merge
				
				loExcel.range(loExcel.cells(nom+18,96),loExcel.cells(nom+18,102)).select
				loExcel.selection.merge
				
				loExcel.range(loExcel.cells(nom+18,103),loExcel.cells(nom+18,110)).select
				loExcel.selection.merge
			
			case	c500.buk = 'К'
				loExcel.cells(nom+18,1).value = c500.buk + alltrim(str(nom))
				
				loExcel.cells(nom+18,6).value = c500.ss
				
				loExcel.cells(nom+18,86).value = c500.a
			
			otherwise
				loExcel.cells(nom+18,1).value = c500.buk + alltrim(str(nom))
				
				loExcel.cells(nom+18,6).value = c500.ss
				
				* formats
				loExcel.range(loExcel.cells(nom+18,6),loExcel.cells(nom+18,110)).select
				loExcel.selection.merge
				loExcel.selection.numberformat = '@'
				loExcel.selection.font.size = 10
				loExcel.selection.rowheight = 18
				
			
		endcase 
		
	
	endif	
	
	* выводим строки с 13 и далее
	if nom > 13
		local nn
		nn = topnom + locnom
		
		do	case
			case	c500.buk = 'А'
				loExcel.cells(nn,1).value = 'А' + alltrim(str(nom))
				
				loExcel.cells(nn,6).value = c500.ceh
				loExcel.cells(nn,18).value = c500.oper
				loExcel.cells(nn,23).value = c500.knop
				loExcel.cells(nn,52).value = c500.od
				
				* formats
				loExcel.range(loExcel.cells(nn,1),loExcel.cells(nn,110)).select
				loExcel.selection.numberformat = '@'
				loExcel.selection.font.size = 10
				loExcel.selection.rowheight = 18
				
				loExcel.range(loExcel.cells(nn,6),loExcel.cells(nn,9)).select
				loExcel.selection.merge
				
				loExcel.range(loExcel.cells(nn,18),loExcel.cells(nn,22)).select
				loExcel.selection.merge
				
				
			case	c500.buk = 'Б'
				loExcel.cells(nn,1).value = 'Б' + alltrim(str(nom))
				
				loExcel.cells(nn,6).value = c500.knob
				loExcel.cells(nn,56).value = c500.prof
				loExcel.cells(nn,63).value = c500.p
				loExcel.cells(nn,67).value = c500.ut
				loExcel.cells(nn,72).value = c500.kp
				loExcel.cells(nn,76).value = c500.koid
				loExcel.cells(nn,96).value = c500.tpz
				loExcel.cells(nn,103).value = c500.tsht
				
				* formats
				loExcel.range(loExcel.cells(nn,1),loExcel.cells(nn,110)).select
				loExcel.selection.numberformat = '@'
				loExcel.selection.font.size = 10
				loExcel.selection.rowheight = 18
				
				loExcel.range(loExcel.cells(nn,6),loExcel.cells(nn,51)).select
				loExcel.selection.merge
				
				loExcel.range(loExcel.cells(nn,56),loExcel.cells(nn,62)).select
				loExcel.selection.merge
				
				loExcel.range(loExcel.cells(nn,63),loExcel.cells(nn,66)).select
				loExcel.selection.merge
				
				loExcel.range(loExcel.cells(nn,67),loExcel.cells(nn,71)).select
				loExcel.selection.merge
				
				loExcel.range(loExcel.cells(nn,72),loExcel.cells(nn,75)).select
				loExcel.selection.merge
				
				loExcel.range(loExcel.cells(nn,76),loExcel.cells(nn,80)).select
				loExcel.selection.merge
				
				loExcel.range(loExcel.cells(nn,81),loExcel.cells(nn,85)).select
				loExcel.selection.merge
				
				loExcel.range(loExcel.cells(nn,96),loExcel.cells(nn,102)).select
				loExcel.selection.merge
				
				loExcel.range(loExcel.cells(nn,103),loExcel.cells(nn,110)).select
				loExcel.selection.merge

			case	c500.buk = 'К'
			
			otherwise
				loExcel.cells(nn,1).value = c500.buk + alltrim(str(nom))
				
				loExcel.cells(nn,6).value = c500.ss
				
				* formats
				loExcel.range(loExcel.cells(nn,6),loExcel.cells(nn,110)).select
				loExcel.selection.merge
				loExcel.selection.numberformat = '@'
				loExcel.selection.font.size = 10
				loExcel.selection.rowheight = 18
				
			
		endcase 
		 
		locnom = locnom + 1	
	
	endif
	
	* следующая итерация
	nom = nom + 1
endscan 
use in c500

*
loExcel.visible = .t.