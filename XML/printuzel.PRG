* ������ ����
*!*	lparameters parshw,parpoznd,parshw1,parplus		+',parshw1 '+parshw1

Lparameters parshw,parpoznw
*!*	WAIT WINDOW '������� ��������� parshw,parpoznd '+STR(parshw)+' '+parpoznw
Public lcc
lcc = 0
*!*	RETURN
Wait Window Nowait '��������� Excel'
loexcel = Createobject('Excel.Application')
loexcel.workbooks.Open(Sys(5)+Sys(2003)+'\��.xls')
loexcel.displayalerts = .F.
Local firstpass, mshwz, mim, mribf

firstpass = .T.

Local hhh
hhh = SQLConnect('sqldb','sa','111')
If hhh > 0
&& ������� ������ �� ������, ������� ���� � ������������
*!*				 AND YEAR(WW.DATA_Z)>2010 AND YEAR(izdfull.DATA_Z)>2010
	rrr = SQLExec(hhh,"select SHWZ,im,ribf from izdfull where KOD = ?parshw AND ;
					SHWZ<>''",'c_izdfull')
	If rrr = -1
		eodbc('IZDfull selection')
		SQLDisconnect(hhh)
		Return
	Else
		Brow
	Endif
	mshwz	= c_izdfull.shwz
	mim		= c_izdfull.im
	mribf	= c_izdfull.ribf
	SELE c_izdfull
	Scan All
*!*	&& ������� ������ �� ������� � ���, ������� �������� ��� ����� �� � ������� ����
		rrr = SQLExec(hhh,'select DISTINCT KORNW,naimw,poznw from ktfull where ;
			shw = ?parshw AND poznw=?parpoznw','c_ktfull')
		If rrr = -1
			eodbc('ktfull selection')
			SQLDisconnect(hhh)
			Return
		Else
			Brow
		Endif

		If Reccount() > 0
			nom = 1
			npn = 357
			sklad_otkuda = 2
			sklad_kuda = 5
			loexcel.Cells(nom,1).Value =   '�� '
			loexcel.Cells(nom,2).Value =   '��������� (�������������) � '+Str(npn,7)
			loexcel.Cells(nom,4).Value =   ' ����� ����������'
			loexcel.Cells(nom,5).Value =   ' ����� �����������'
			loexcel.Cells(nom,6).Value =   ' ����� ����������'
*!*						loexcel.Cells(nom+1,4).Value = ' '
			loexcel.Cells(nom+1,2).Value = '�� '+Dtoc(Date())
			loexcel.Cells(nom+1,4).Value = LEFT(Time(Date()),5)

			loexcel.Cells(nom+1,5).Value = ' ���� �'+Str(sklad_otkuda,4)
			loexcel.Cells(nom+1,6).Value = ' ���� �'+Str(sklad_kuda,4)
 *!*						WAIT WINDOW Alltrim(c_shwz.ribf) + ' ' + Alltrim(c_shwz.im)
			loexcel.Cells(nom+2,2).Value = Alltrim(c_ktfull.poznw)+' '+alltrim(c_ktfull.naimw)
			loexcel.Cells(nom+2,4).Value = Alltrim(mribf) + ' ' + Alltrim(mim)
			loexcel.Cells(nom+3,2).Value = '��� ������� ' + Alltrim(mshwz)
*!*					*** ������� �����
			loexcel.Range(loexcel.Cells(5,1),loexcel.Cells(7,9)).Select
			loexcel.Selection.Copy
			loexcel.Range(loexcel.Cells(nom+5,1),loexcel.Cells(nom+5,9)).Select
			loexcel.Selection.PasteSpecial(-4104,-4142,.F.,.F.)
			nom = nom + 7
*!*						nom=8
			NPP=1
			Wait Window 'npp='+Str(NPP)+' nom='+Str(nom) Nowait
*!*				MAR_3 = c_ktfull.MAR3
*!*				Wait Wind 'MAR3='+Str(MAR_3) Nowait &&
*!*				razmer = Alltrim(Str(c_ktfull.rozma))+'x'+Alltrim(Str(c_ktfull.rozmb))
			SELECT c_ktfull
			Scan All
&& ������� ������ �� �����(����), �� ������� ���� ���������� � ���������������� ���� �� ���������� ������ � ������������������ �������
				&& and shwz=?mSHWZ 
				rrr = SQLExec(hhh,'select * from WW where POZNW = ?parpoznw','c_mar')
				If rrr = -1
					eodbc('fr_nakl WW C_MAR selection')
					SQLDisconnect(hhh)
					Return
				Else
					WAIT WINDOW 'C_MAR'
					Brow
				Endif

				Select C_MAR
				Go Top
				Scan All
					NPP = NPP + 1
					nom = nom + 1
					loexcel.Cells(nom,1).Value = NPP
					Wait Window C_MAR.naimd Nowait &&
					loexcel.Cells(nom,2).Value = Alltrim(C_MAR.poznd) +' ' + Alltrim(C_MAR.naimd)
					loexcel.Cells(nom,3).Value = get_mater(C_MAR.kodm)
					razmer = Alltrim(Str(c_mar.rozma))+'x'+Alltrim(Str(c_mar.rozmb))
					loexcel.Cells(nom,4).Value =  razmer
*!*	*!*
*!*						rrr = SQLExec(hhh,'select data_n,vn from WW where MAR = sklad_kuda-1 AND SHWZ=?mSHWZ ORDER BY NTO','c_mar4')
*!*	*!*							BROWSE
*!*	*!*							Return
*!*						If rrr = -1
*!*							eodbc('fr_nakl WW C_MAR selection')
*!*							SQLDisconnect(hhh)
*!*							Return
*!*						Else
*!*						Endif
*!*						data_na=''
*!*						If c_mar4.data_n > 0 Or c_mar4.vn > 0
*!*							data_na =  Alltrim(Str(c_mar4.data_n))+' '+Alltrim(Str(c_mar4.vn,2))
*!*						Endif
*!*						Use In c_mar4
*!*						loexcel.Cells(nom,5).Value = data_na
					loexcel.Cells(nom,6).Value = C_MAR.kolz-C_MAR.kzp
					nom = nom + 1
					loexcel.Cells(nom,2).Value = marshrut
					loexcel.Cells(nom,3).Value =  ALLTRIM(STR(sklad_otkuda))  ' + Alltrim(get_dosp2(sklad_otkuda))
					loexcel.Cells(nom,4).Value = Alltrim(Str(C_MAR.mar)) + ' ' + Alltrim(get_dosp2(C_MAR.mar))
					nom = nom + 4
				Endscan
				Use In C_MAR
			ENDSCAN 
		Endif
		
	Endscan
*!*		Use In C_SHWZ
*!*		nom=nom+2
*!*		loexcel.Cells(nom,4).Value = '������ ������ �� ����' DATAn + VN NTO=5 IZ WW PO POZNW UZLA  	????????
*!
*!*		wait window '����������� ' + alltrim(str(mcou)) + ' �������' ?????????????????
*!
*		10 KOL MESTO NRMD* (KOLZ-KZP)
Else
	eodbc('fr_nakl connection')
	Return
Endif
Release hh,rr
loexcel.Visible = .T.

*!*	SELECT DISTINCT ww.poznw, ktfull.kornw, ktfull.naimw, ww.shwz, ktfull.shw
*!*	FROM         ww INNER JOIN
*!*	                      ktfull ON ww.shw = ktfull.shw AND ww.poznw = ktfull.poznw CROSS JOIN
*!*	                      izdfull
*!*	WHERE     (ww.shwz <> '') AND (ww.poznw <> '') AND (ktfull.shw > 0)