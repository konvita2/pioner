*!*	Local mshw,md_u
*!*	Local mgrkod,mgrnaim
*!*	Local msortkod,msortnaim

Public Array marshr[20]
marshr = ''

Local mmatkod,mmatnaim
Local MSHWZ,MPOZND
MSHWZ = '001.001.027.010.17'
MPOZND = 'SW-24-00-01'

* ÔÎÐÌÈÐÎÂÀÍÈÅ ÑÂÎÄÍÎÃÎ ÎÒ×ÅÒÀ ÈÑÏÎËÜÇÎÂÀÍÈß ÐÀÁÎ×ÅÃÎ ÂÐÅÌÅÍÈ

****************************************************
************* sir

Wait Window Nowait 'Excel îòêðûâàåòñÿ'
Local loExcel
loExcel = Createobject("Excel.Application")
*loExcel.Workbooks.Add()
loExcel.WorkBooks.Open(Sys(5)+Sys(2003)+'\navigator.xls')
loExcel.DisplayAlerts = .F.

Local npp	&& íîìåð ïîçèöèè
Local nomstr	&& íîìåð ñòðîêè
npp = 0
*!*	nomstr = 1
*** ç à ã î ë î â î ê
loExcel.Cells(1 ,4).Value =   'ÎÒ×ÅÒ '
Local hh
hh = SQLConnect('sqldb','sa','111')
If hh > 0
	Local res1
	res1 = SQLExec(hh,'select * from WW where SHWZ = ?MSHWZ AND POZND = ?MPOZND ORDER BY NTO','CWW')
	If res1 = -1
		eodbc('SIR sele WW')
		Return-1
	Endif
	SQLDisconnect(hh)
Else
	Wait Window 'Íå óäàëîñü ïîäêëþ÷èòüñÿ ê ÁÄ'
Endif

loExcel.Cells(2,1).Value =   'ÏÎ ÍÀÂÈÃÀÖÈÈ óçëà(äåòàëè) '+ Rtrim(MPOZND)+ ' '+ Rtrim(cww.naimd)
loExcel.Cells(3,1).Value =   'çàêàç '+ Rtrim(MSHWZ)
loExcel.Cells(4,1).Value =   'êîëè÷åòâî â çàêàçå '+ Rtrim(Str(cww.kolz))

Local hhh
hhh = SQLConnect('sqldb','sa','111')
If hhh > 0
	rrr = SQLExec(hhh,'select kttp,mar1,mar2,mar3,mar4,mar5,mar6,mar7,mar8,mar9,mar10,mar11,mar12, ;
							mar13,mar14,mar15,mar16,mar17,mar18,mar19,mar20,rozma,rozmb from ktfull where poznd=?mpoznd ','c_ktfull')
	If rrr = -1
		eodbc('ktfull selection')
		SQLDisconnect(hhh)
		Return
	Endif
	If Reccount() > 0
*!*			Browse
	Endif
Else
	eodbc('fr_nakl connection')
	Return
Endif
marshr[20] = c_ktfull.mar20
marshr[19] = c_ktfull.mar19
marshr[18] = c_ktfull.mar18
marshr[17] = c_ktfull.mar17
marshr[16] = c_ktfull.mar16
marshr[15] = c_ktfull.mar15
marshr[14] = c_ktfull.mar14
marshr[13] = c_ktfull.mar13
marshr[12] = c_ktfull.mar12
marshr[11] = c_ktfull.mar11
marshr[10] = c_ktfull.mar10
marshr[9]  = c_ktfull.mar9
marshr[8]  = c_ktfull.mar8
marshr[7]  = c_ktfull.mar7
marshr[6]  = c_ktfull.mar6
marshr[5]  = c_ktfull.mar5
marshr[4]  = c_ktfull.mar4
marshr[3]  = c_ktfull.MAR3
marshr[2]  = c_ktfull.mar2
marshr[1]  = c_ktfull.mar1
marshrut=''
ind=1
*!*		WAIT WINDOW 'MASHRUT'
Do While .T.
	If marshr[IND] > 0
		If ind = 1
			marshrut = marshrut + Alltrim(Str(marshr[IND]))
		Else
			marshrut = marshrut + '-'+ Alltrim(Str(marshr[IND]))
		Endif
*!*			Wait Window '  IND='+Str(ind)+'    MASHRUT = '+ Str(marshr[IND])
	Endif
	ind=ind+1
	If ind > 20
		Exit
	Endif
Enddo

loExcel.Cells(5,1).Value = 'ìàðøðóò ' + marshrut

*!*	hhh = SQLConnect('sqldb','sa','111')
*!*	If hhh > 0
*!*		rrr = SQLExec(hhh,'select IM,ROZMA,ROZMBozma,rozmb from ktfull where poznd=?mpoznd ','c_ktfull')
*!*		If rrr = -1
*!*			eodbc('ktfull selection')
*!*			SQLDisconnect(hhh)
*!*			Return
*!*		Endif
*!*		If Reccount() > 0
*!*			Browse
*!*		Endif
*!*	Else
*!*		eodbc('fr_nakl connection')
*!*		Return
*!*	Endif

loExcel.Cells(6,1).Value = 'ìàòåðèàë ' +GET_MATER(CWW.KODM)+' ðàçìåð '+ ALLTRIM(STR(c_ktfull.ROZMA))+IIF(c_ktfull.ROZMB>0,ALLTRIM(STR(c_ktfull.ROZMB)),'')
*** ñ ò ð î ê è



Select cww
*!*	BROWSE
nomstr = 9
Scan All
	nomstr = nomstr + 1
	npp = npp + 1
	loExcel.Cells(nomstr,1).Value = npp
	loExcel.Cells(nomstr,2).Value = cww.NTO
	loExcel.Cells(nomstr,3).Value = cww.DATA_N1
	loExcel.Cells(nomstr,4).Value = cww.NORMW * cww.KZP + cww.TPZ
	loExcel.Cells(nomstr,5).Value = cww.DATA_N3
	loExcel.Cells(nomstr,6).Value = cww.normw8
	loExcel.Cells(nomstr,7).Value = cww.DATA_N4
	loExcel.Cells(nomstr,8).Value = cww.DATA_N5
	loExcel.Cells(nomstr,9).Value = cww.NORMW4
	loExcel.Cells(nomstr,10).Value = cww.NORMW6


	nomstr = nomstr + 1

*!*		loExcel.Cells(nomstr,2).Value = cmako.shwz&&VID7 ×ÅÐÅÇ KTO

	loExcel.Cells(nomstr,3).Value = DATA_N2
	loExcel.Cells(nomstr,4).Value = NORMW1 * KZP
	loExcel.Cells(nomstr,5).Value = NORMW2
	loExcel.Cells(nomstr,7).Value = NORMW3
	loExcel.Cells(nomstr,8).Value = DATA_N6
	loExcel.Cells(nomstr,9).Value = NORMW5
	loExcel.Cells(nomstr,10).Value = NORMW7



*!*			loExcel.Selection.BorderS(7).LineStyle = 1
*!*			loExcel.Selection.BorderS(7).Weight = 2
*!*			loExcel.Selection.BorderS(8).LineStyle = 1
*!*			loExcel.Selection.BorderS(8).Weight = 2
*!*			loExcel.Selection.BorderS(9).LineStyle = 1
*!*			loExcel.Selection.BorderS(9).Weight = 2
*!*			loExcel.Selection.BorderS(10).LineStyle = 1
*!*			loExcel.Selection.BorderS(10).Weight = 2
*!*			*!*				loExcel.Selection.Borders(11).LineStyle = 1
*!*			*!*				loExcel.Selection.Borders(11).Weight = 2
*!*			*** increase nom

*!*			SELECT cww
*!*		Endscan
*!*		Use In cww
	Select cww
Endscan
Use In cww
loExcel.Visible = .T.
Retu
***************************************************
*
