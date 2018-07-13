proc wto

Wait Window Nowait 'Запускаем Excel'
loexcel = Createobject('Excel.Application')
loexcel.workbooks.Open(Sys(5)+Sys(2003)+'\e_wto.xls')
loexcel.displayalerts = .F.
Local nnom
nnom = 5
*!*	  @prow()+1,0 say '                   ВЕДОМОСТЬ'
*!*	   @prow()+1,0 say '              тестирования(проверки) оборудования' 
*!*	   @prow()+1,0 say '              по состоянию на '+dtoc(date())+' г.'
*!*	   @prow()+1,0 say '--------------------------------------------------------------------------------'
*!*	   @prow()+1,0 say ' № : Учетн.: Оборудование                          : Плановый :Фактич. :Точность'
*!*	   @prow()+1,0 say 'п/п:   №   :                                       :   срок   : срок   :измерен.'
*!*	   @prow()+1,0 say '   :       :                                       : проверки :проверки:        '
*!*	   @prow()+1,0 say '--------------------------------------------------------------------------------'

npp=0
*wait 'mshwz='+mshwz wind
hhh = SQLConnect('sqldb','sa','111')
If hhh > 0
	rrr = SQLExec(hhh,'select * from obor where year(datap)>1900 order by invn ','COBOR')
*!*		rrr = SQLExec(hhh,'select * from obor order by invn ','COBOR')

If rrr = -1
		eodbc('wto obor Sele')
	Endif
	SQLDisconnect(hhh)
Else
	eodbc('wto obor conn')
Endif
SCAN all
   npp=npp+1
   *WAIT wind 'npp='+STR(npp) 
*!*	   @prow()+1,0 say str(npp,3)+' '+cobor.invn+' '+cobor.marka+' '+cobor.naim+' ';
*!*	                     +dtoc(cobor.datap)+' '+dtoc(cobor.datab) 
*!*	                    


npp=npp+1
			loexcel.cells(nnom,1).Value = npp
			loexcel.cells(nnom,2).Value = cobor.invn
			loexcel.cells(nnom,3).Value = alltrim(cobor.marka)+alltrim(cobor.naim)
			loexcel.cells(nnom,4).Value = cobor.datap
			loexcel.cells(nnom,5).Value = cobor.datab
			nnom = nnom + 1
			ENDSCAN 
USE IN cobor

Wait Window Nowait 'ОТЧЕТ ГОТОВ !'
loexcel.Visible = .T.
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


