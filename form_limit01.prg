lparameters parBeg,parEnd

* готовим excel
local loExcel
wait window nowait 'Excel открывается...'
loExcel = createobject('Excel.Application')
loExcel.Workbooks.Add()
loExcel.Workbooks.Open(sys(5)+sys(2003)+'\limit01.xls')
loExcel.DisplayAlerts = .f.

local npp,stroka
local nkart,matnaim,povert,kol,od,dovg,shir,datapover,oznaka
store '' to nkart,matnaim,povert,kol,od,dovg,shir,datapover,oznaka

* выводим заголовок
wait window nowait 'Выводим заголовок'
local ss
ss = 'период с '+dtoc(parBeg)+' по '+dtoc(parEnd)
loExcel.Cells(3,3).value = ss
loExcel.Range(loExcel.Cells(3,3),loExcel.Cells(3,3)).Select
loExcel.Selection.Font.Size = 11
loExcel.Selection.Font.Bold = .t.

*
stroka = 6
npp = 0
select * from ostatki ;
	where between(dat_o,parBeg,parEnd) ;
		and !empty(doc) ;
	into cursor c100
scan all
	* counter
	wait window nowait 'Выполнено '+str(100*recno()/reccount())+'%' 
	* npp
	npp = npp + 1
	* nkart
	nkart = str(c100.nsk)
	* matnaim
	matnaim = get_mater(c100.kod)
	* povert 
	povert = c100.doc
	* kol
	kol = 1	
	* od
	od = get_mater_ei(c100.kod)
	* dovg
	dovg = c100.ra	
	* shir
	shir = c100.rb
	* datapover (может брать из соответствующей лимитки?) 
	datapover = dtoc(c100.dat_o)
	* oznaka
	oznaka = c100.pri
	* output
	loExcel.Cells(stroka,1).value = npp
	loExcel.Cells(stroka,2).value = nkart
	loExcel.Cells(stroka,3).value = matnaim
	loExcel.Cells(stroka,4).value = povert
	loExcel.Cells(stroka,5).value = kol
	loExcel.Cells(stroka,6).value = od
	loExcel.Cells(stroka,7).value = dovg
	loExcel.Cells(stroka,8).value = shir
	loExcel.Cells(stroka,9).value = datapover
	loExcel.Cells(stroka,10).value = oznaka	
	* set formats
	loExcel.Range(loExcel.Cells(stroka,1),loExcel.Cells(stroka,11)).Select
	loExcel.Selection.Borders(9).LineStyle = 1 
	loExcel.Selection.Borders(7).LineStyle = 1 
	loExcel.Selection.Borders(10).LineStyle = 1 
	loExcel.Selection.Borders(8).LineStyle = 1 
	loExcel.Selection.Borders(11).LineStyle = 1 
	loExcel.Selection.VerticalAlignment = -4160
	*loExcel.Selection.Borders(12).LineStyle = 1 
	loExcel.Range(loExcel.Cells(stroka,3),loExcel.Cells(stroka,3)).Select
	loExcel.Selection.WrapText = .t.
	loExcel.Range(loExcel.Cells(stroka,2),loExcel.Cells(stroka,2)).Select
	loExcel.Selection.HorizontalAlignment = -4108
	loExcel.Range(loExcel.Cells(stroka,4),loExcel.Cells(stroka,4)).Select
	loExcel.Selection.HorizontalAlignment = -4108
	*
	stroka = stroka + 1
endscan
use in c100

loExcel.visible = .t.
wait window nowait 'Отчет готов' 
