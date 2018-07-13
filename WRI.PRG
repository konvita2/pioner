*!*	proc wio

Wait Window Nowait '«‡ÔÛÒÍ‡ÂÏ Excel'
loexcel = Createobject('Excel.Application')
loexcel.workbooks.Open(Sys(5)+Sys(2003)+'\e_wri.xls')
loexcel.displayalerts = .F.
Local nnom
nnom = 5


hhh = SQLConnect('sqldb','sa','111')
If hhh > 0
		rrr = SQLExec(hhh,'SELECT * from instr where year(datap)>1900 AND pri=1 order by im','CINSTR')
*!*		rrr = SQLExec(hhh,'SELECT * from instr where pri=1 order by im','CINSTR')
	If rrr = -1
		eodbc('wto obor Sele')
	Endif
	SQLDisconnect(hhh)
Else
	eodbc('wto obor conn')
Endif
Go Top

npp=0
Do While .Not.Eof()
*!*		npp=npp+1
*!*		@Prow()+1,0 Say Str(npp,3)+' '+Str(kodi,3)+' ';
*!*			+im+' '+Dtoc(datap)+' '+Dtoc(Datab)+' '+ti
	npp=npp+1
	loexcel.cells(nnom,1).Value = npp
	loexcel.cells(nnom,2).Value = kodi
	loexcel.cells(nnom,3).Value = im
	loexcel.cells(nnom,4).Value = datap
	loexcel.cells(nnom,5).Value = Datab
	loexcel.cells(nnom,6).Value = ti
	nnom = nnom + 1
	Sele cinstr
	Skip
Enddo

Use In cinstr
Wait Window Nowait 'Œ“◊≈“ √Œ“Œ¬ !'
loexcel.Visible = .T.
