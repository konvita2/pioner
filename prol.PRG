npp=1
Wait Window Nowait '«‡ÔÛÒÍ‡ÂÏ Excel'
loexcel = Createobject('Excel.Application')
loexcel.workbooks.Open(Sys(5)+Sys(2003)+'\prol.xls')
loexcel.displayalerts = .F.
nnom=7
*
hhh = SQLConnect('sqldb','sa','111')

If hhh > 0
	rrr = SQLExec(hhh,"Select * From DOSP WHERE VID=2 AND KOD<>0 Order By im",'C_DOSP')
	If rrr = -1
		eodbc('f_wkp ff p_c OBOR')
	Endif
	SQLDisconnect(hhh)
Else
	eodbc('f_wkp ff p_c obor conn')
Endif
Select C_DOSP
Go Top

irabot=0
iprost=0
iwr   =0

Scan
	*!*		WAIT WINDOW STR(c_dosp.kod)

	hh = SQLConnect('sqldb','sa','111')
	If hh > 0
		rr = SQLExec(hh,'Select * From NAR where mar=?c_dosp.kod','C_NAR')
		If rr = -1
			eodbc('kp_1 sele kp')
		Endif
		SQLDisconnect(hhh)
	Else
		eodbc('kp_1  kp conn')
	ENDIF
	
	
	**   sum(shwzras.kol1 * mater.cena) as sumkol1 from shwzras,mater ;
	** where shwzras.kodm = mater.kodm and alltrim(shwz) == alltrim(mshwz) and du = 5 into cursor c18
	
	
	TT=0
	select SUM(NORMWW*KZP) AS TT from C_NAR into cursor  C_TT	
	use in C_TT
	Select c_nar
	If Reccount() > 0
		KOLZA = Reccount()
		npp=npp+1
		loexcel.cells(nnom,1).Value = npp
		loexcel.cells(nnom,2).Value = Alltrim(Str(C_DOSP.KOD,4))+' '+Alltrim(C_DOSP.IM)
		loexcel.cells(nnom,3).Value = KOLZA
		loexcel.cells(nnom,4).Value = TT
		
		*!*			loexcel.cells(nnom,6).Value = c_kp_1.vr
		*!*			loexcel.cells(nnom,7).Value = int(c_kp_1.CHAS/80)
		*!*			loexcel.cells(nnom,8).Value = (c_kp_1.CHAS - int(c_kp_1.CHAS/80)*80) / 10
		*!*			loexcel.cells(nnom,9).Value = ((c_kp_1.CHAS - int(c_kp_1.CHAS/80)*80) / 10) * 6

		nnom = nnom + 1
		*!*			loexcel.cells(nnom,3).Value = c_obor.NAIM
		*!*			nnom = nnom + 1
	endif
	
	Use In c_nar
	Select C_DOSP
Endscan

Wait Window Nowait 'Œ“◊≈“ √Œ“Œ¬ !'
loexcel.Visible = .T.

