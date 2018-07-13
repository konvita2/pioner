Public Array me[12]
me[1]='ﬂÕ¬¿–‹'
me[2]='‘≈¬–¿À‹'
me[3]='Ã¿–“'
me[4]='¿œ–≈À‹'
me[5]='Ã¿…'
me[6]='»ﬁÕ‹'
me[7]='»ﬁÀ‹'
me[8]='¿¬√”—“'
me[9]='—≈Õ“ﬂ¡–‹'
me[10]='Œ “‹¡–‹'
me[11]='ÕŒﬂ¡–‹'
me[12]='ƒ≈ ¿¡–‹'
Local mes_
Wait Window  '«‡ÔÛÒÍ‡ÂÏ Excel' Nowait
loexcel = Createobject('Excel.Application')
mes_=7
loexcel.workbooks.Open(Sys(5)+Sys(2003)+'\e_swri.xls')
loexcel.displayalerts = .F.

Local firstpass
firstpass = .T.

Local nnom
nnom = 1
If !firstpass
	loexcel.ActiveWindow.SelectedSheets.HPageBreaks.Add(loexcel.Range(loexcel.Cells(nnom,1),loexcel.Cells(nnom,1)))
	*** ‚˚‚ÂÒÚË ¯‡ÔÍÛ
	loexcel.Range(loexcel.Cells(1,1),loexcel.Cells(4,7)).Select
	loexcel.Selection.Copy
	loexcel.Range(loexcel.Cells(nnom,1),loexcel.Cells(nnom,1)).Select
	loexcel.Selection.PasteSpecial(-4104,-4142,.F.,.F.)
Endif
firstpass = .F.
loexcel.Cells(nnom+2,3).Value = ' '+me[mes_]+' '+Str(Year(Date()),4)+' „Ó‰'
nnom = nnom + 4

npp=0

Local hhh,rrr
hhh = SQLConnect('sqldb','sa','111')
If hhh > 0
	*!*				   Sele   pri,kodi,im,st,ns From Instr Where pri=1 Order By im into Curs c_instr
	rrr = SQLExec(hhh,'select * From Izu where kodi<>0  Order By im','c_instr')
	If rrr = -1
		eodbc('‚Â‰ÓÏÓÒÚ¸ ÂÊÛ˘Â„Ó  instr Select ')
	Endif
	SQLDisconnect(hhh)
Else
	eodbc('‚Â‰ÓÏÓÒÚ¸ ÂÊÛ˘Â„Ó instr conn')
Endif
Select c_instr
Go Top
Do While .Not.Eof()
	Wait Wind c_instr.im	Nowa 
	Scat Memv
	hhh = SQLConnect('sqldb','sa','111')
	If hhh > 0
		rrr = SQLExec(hhh,'Select poznd,kttp,nto From te where kodi=?m.kodi','c_te')
		If rrr = -1
			eodbc('f_wkp TE p_c kp')
		Endif
		SQLDisconnect(hhh)
	Else
		eodbc('f_wkp ff p_c TE conn')
	Endi
	Select c_te
	Go Top
*!*						wait window 'te'+STR(m.kodi) nowa 
*!*						brow
	tr=0
	Do While .Not.Eof()
		hhh = SQLConnect('sqldb','sa','111')
		If hhh > 0
			rrr = SQLExec(hhh,'Select poznd,kttp,nto,kolz,kzp,normw From ww where poznd=?c_te.poznd And nto=?c_te.nto','c_ww')
			If rrr = -1
				eodbc('f_wkp fp_c WW Sele')
			Endif
			SQLDisconnect(hhh)
		Else
			eodbc('f_wkp fp_c WW conn')
		Endif
*!*			Go Top
*!*			WAIT WINDOW  'ww'+STR(c_te.nto) nowa
*!*			brow
		If RECCOUNT() > 0
			kolz_kzp=kolz-kzp
		Else
			kolz_kzp=0
		Endif
		kolz_kzp=Iif(kolz_kzp=0,1,kolz_kzp)
		tr=tr+c_ww.normw * kolz_kzp
		Use In c_ww
*!*			WAIT WINDOW 'sele te skip' nowa
		SELECT  c_te
		Skip
	Enddo
	Use In c_te
	npp=npp+1
	
	If tr#0
		loexcel.Cells(nnom,1).Value = npp
		loexcel.Cells(nnom,2).Value = m.kodi
		loexcel.Cells(nnom,3).Value = im
		loexcel.Cells(nnom,6).Value = tr
		nnom = nnom + 1
	ENDIF
	Sele c_instr
	Skip
Enddo
Use In c_instr

Wait Window Nowait 'Œ“◊≈“ √Œ“Œ¬ !'
loexcel.Visible = .T.
