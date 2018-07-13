Local mshw,md_u
Local mgrkod,mgrnaim
Local msortkod,msortnaim
Local mmatkod,mmatnaim


* ФОРМИРОВАНИЕ СВОДНОГО ОТЧЕТА ИСПОЛЬЗОВАНИЯ РАБОЧЕГО ВРЕМЕНИ

****************************************************
************* sir

Wait Window Nowait 'Excel открывается'
Local loExcel
loExcel = Createobject("Excel.Application")
*loExcel.Workbooks.Add()
loExcel.WorkBooks.Open(Sys(5)+Sys(2003)+'\sir.xls')
loExcel.DisplayAlerts = .F.

*** з а г о л о в о к

*** с т р о к и
Local npp	&& номер позиции
Local nomstr	&& номер строки
npp = 1
nomstr = 11
Local hh
hh = SQLConnect('sqldb','sa','111')
If hh > 0
	Local res1
	res1 = SQLExec(hh,"select * from MAKO where kttp <> ''",'CMAKO')
	If res1 = -1
		eodbc('SIR sele MAKO')
		Return-1
	Endif
	SQLDisconnect(hh)
Else
	Wait Window 'Не удалось подключиться к БД'
Endif
Select cmako
*!*	Brow
Scan All
	nomstr = nomstr + 1

	loExcel.Cells(nomstr,1).Value = npp
*!*		loExcel.Cells(nomstr,2).Value = get_izd_im_by_shwz(cmako.shwz)
	A=get_izd_im_by_shwz(cmako.shwz)

*!*		WAIT WINDOW 'get_izd_im_by_shwz(cmako.shwz)'+A


	Local hh
	hh = SQLConnect('sqldb','sa','111')
	If hh > 0
		Local res1
		res1 = SQLExec(hh,'select  * from WW where RTRIM(shwz)=?rtrim(cmako.shwz)  and d_u=3')
		brow
		loExcel.Cells(nomstr,2).Value = RTRIM(sqlresult.poznw)
		res1 = SQLExec(hh,'select  * from WW where LEFT(kttp,14)=?LEFT(cmako.kttp,14)')
		kolon8w = normw8
		If res1 = -1
			eodbc('SIR sele WW')
			Return-1
		Endif
		KOLON3W =  Reccount()
		res1 = SQLExec(hh,'select  * from WW where LEFT(kttp,14)=?LEFT(cmako.kttp,14) AND KZP > 0')
		KOLON3n =  Reccount()
		KOLON6W = 0
		res1 = SQLExec(hh,'select  SUM(normw1*kzp,normw2,normw3) as kolon6W from WW where LEFT(kttp,14)=?LEFT(cmako.kttp,14) AND KZP > 0')
		kolon7w = 0
		res1 = SQLExec(hh,'select  SUM(normw1*kzp) as kolon7w from WW where LEFT(kttp,14)=?LEFT(cmako.kttp,14) AND KZP > 0')

		kolon7n = 0
		res1 = SQLExec(hh,'select  SUM(normw2,normw3) as kolon7n from WW where LEFT(kttp,14)=?LEFT(cmako.kttp,14) AND KZP > 0')


		kolon9W = 0
		res1 = SQLExec(hh,'select  SUM(normw4) as kolon9W from WW where LEFT(kttp,14)=?LEFT(cmako.kttp,14) AND KZP > 0')

		KOLON9N = 0
		res1 = SQLExec(hh,'select  SUM(normw5) as kolon9n from WW where LEFT(kttp,14)=?LEFT(cmako.kttp,14) AND KZP > 0')


		KOLON11W = 0
		res1 = SQLExec(hh,'select  SUM(normw6) as kolon11W from WW where LEFT(kttp,14)=?LEFT(cmako.kttp,14) AND KZP > 0')
		KOLON11N = 0
		res1 = SQLExec(hh,'select  SUM(normw7) as kolon11N from WW where LEFT(kttp,14)=?LEFT(cmako.kttp,14) AND KZP > 0')

		SQLDisconnect(hh)
	Else
		Wait Window 'Не удалось подключиться к БД'
	Endif
	loExcel.Cells(nomstr,3).Value = KOLON3W
	loExcel.Cells(nomstr,4).Value = cmako.NOM
	loExcel.Cells(nomstr,5).Value = cmako.wsego_stoim
	loExcel.Cells(nomstr,6).Value = KOLON6W
	loExcel.Cells(nomstr,7).Value = kolon7w
	loExcel.Cells(nomstr,8).Value = kolon8w
	loExcel.Cells(nomstr,9).Value = kolon9W
	If KOLON3W = KOLON3n
		loExcel.Cells(nomstr,10).Value = cmako.wsego_stoim
	Else
		loExcel.Cells(nomstr,10).Value = kolon6w * cmako.STOIM_1_CHAS
	Endif
	loExcel.Cells(nomstr,11).Value = KOLON11W


	nomstr = nomstr + 1
	loExcel.Cells(nomstr,2).Value = cmako.shwz
	loExcel.Cells(nomstr,3).Value = KOLON3n
	LOCAL mmm
	mmm=''
	hh = SQLConnect('sqldb','sa','111')
	If hh > 0
		rr = SQLExec(hh,'select im from dosp where vid=9 and sim = ?cmako.kttp')
		If rr = -1
			eodbc()
		Else
			Select sqlresult
			Go Top
			mmm = sqlresult.im
		Endif
	Else
		eodbc()
	Endif
	loExcel.Cells(nomstr,4).Value = mmm
	loExcel.Cells(nomstr,5).Value = cmako.trud
	loExcel.Cells(nomstr,6).Value = cmako.STOIM_1_CHAS
	loExcel.Cells(nomstr,7).Value = kolon7n
	loExcel.Cells(nomstr,9).Value = KOLON9N


	If KOLON3W = KOLON3n
		If kolo6w > 0
			loExcel.Cells(nomstr,10).Value = cmako.wsego_stoim / kolon6w
		Endif
	Else
		loExcel.Cells(nomstr,10).Value =  cmako.STOIM_1_CHAS
	Endif

	loExcel.Cells(nomstr,11).Value = KOLON11N


*!*			* naimd
*!*			loExcel.Cells(nom,3).Value = cc80.naimd

*!*			*** ed
*!*			*!*				WAIT WINDOW 'osn  get_mater_ei'
*!*			loExcel.Cells(nom,4).Value = Alltrim(get_mater_ei1(cc_dkt.materkodm))

*!*			* koli
*!*			loExcel.Range(loExcel.Cells(nom,5),loExcel.Cells(nom,5)).Select
*!*			loExcel.Selection.HorizontalAlignment = -4108   		&& center
*!*			loExcel.Cells(nom,5).Value = cc80.koli
*!*			* wag
*!*			loExcel.Range(loExcel.Cells(nom,6),loExcel.Cells(nom,6)).Select
*!*			loExcel.Selection.NumberFormat = '0.000'
*!*			loExcel.Cells(nom,6).Value = cc80.wag
*!*			* rozma
*!*			If cc80.rozma <> 0
*!*				loExcel.Cells(nom,7).Value = Str(cc80.rozma) + ' (-' + Alltrim(Str(cc80.tocha,5,2)) + ')'
*!*			Else
*!*				loExcel.Cells(nom,7).Value = ''
*!*			Endif
*!*			loExcel.Range(loExcel.Cells(nom,7),loExcel.Cells(nom,7)).Select
*!*			loExcel.Selection.HorizontalAlignment = -4152
*!*			* rozmb
*!*			If cc80.rozmb <> 0
*!*				loExcel.Cells(nom,8).Value = Str(cc80.rozmb) + ' (-' + Alltrim(Str(cc80.tochb,5,2)) + ')'
*!*			Else
*!*				loExcel.Cells(nom,8).Value = ''
*!*			Endif
*!*			loExcel.Range(loExcel.Cells(nom,8),loExcel.Cells(nom,8)).Select
*!*			loExcel.Selection.HorizontalAlignment = -4152
*!*			* kolz
*!*			loExcel.Cells(nom,9).Value = cc80.kolz
*!*			* nrmd
*!*			loExcel.Cells(nom,10).Value = cc80.nrmd
*!*			*!*				* normwr
*!*			*!*				loExcel.Cells(nom,11).value = cc80.normwr
*!*			*!*				* normwr0
*!*			*!*				loExcel.Cells(nom,12).value = cc80.normwr0
*!*			*!*				* set format
*!*			*!*				loExcel.Range(loExcel.Cells(nom,1),loExcel.Cells(nom,12)).Select
*!*			loExcel.Selection.VerticalAlignment = -4160

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
	Select cmako
Endscan
Use In cmako
loExcel.Visible = .T.
Retu
***************************************************
************* dsn2
If Thisform.txtVid.Value = 2
	Wait Window Nowait 'Excel открывается'
	Local loExcel
	loExcel = Createobject("Excel.Application")
*loExcel.Workbooks.Add()
	loExcel.WorkBooks.Open(Sys(5)+Sys(2003)+'\dsn2.xls')
	loExcel.DisplayAlerts = .F.

*** з а г о л о в о к
* изделие
	loExcel.Cells(2,1).Value = get_izd_ribf_by_kod(mshw) + ' ' + get_izd_im_by_kod(mshw)
* вид
	Do Case
	Case	Thisform.txtVid.Value = 1
		loExcel.Cells(3,3).Value = 'Основные'
	Case	Thisform.txtVid.Value = 2
		loExcel.Cells(3,3).Value = 'Комплектующие'
	Case	Thisform.txtVid.Value = 3
		loExcel.Cells(3,3).Value = 'Вспомогательные'
	Endcase
* группа, сортамент, материал
	Local mat
	mat = ''
	If Thisform.txtVidMat.Value = 2
		mat = Str(mmatkod) + ' ' + mmatnaim
	Else
		If Thisform.txtVidGr.Value = 2
			If Thisform.txtVidSort.Value = 2
				mat = Alltrim(mgrnaim) + ' / ' + msortnaim
			Else
				mat = mgrnaim
			Endif
		Else
			mat = 'По всем материалам'
		Endif
	Endif
*** коды заготовок
*!*		if thisform.txtVidZag.Value = 2
*!*			mat = mat + '(по кодам заготовок '+get_dosp56(val(thisform.txtKodzag.Value))+')'
*!*		endif		loExcel.Cells(4,3).value = mat
*** с т р о к и
	Local npp	&& номер позиции
	Local NOM	&& номер строки
	npp = 1
	NOM = 6

	Select cc_dkt
	Scan All
*** wwn

*** вывести материал
		loExcel.Cells(NOM,1).Value = ;
			cc_dkt.materkod + ' (' + Alltrim(Str(cc_dkt.materkodm)) + ') ' +;
			alltrim(cc_dkt.maternaim)
		loExcel.Range(loExcel.Cells(NOM,1),loExcel.Cells(NOM,6)).Select
		loExcel.Selection.Merge
		loExcel.Selection.Font.Bold = .T.
		NOM = NOM+1

*** выбираем и выводим детали
		Select * From c_kt;
			where materkodm = cc_dkt.materkodm;
			order By kornd;
			into Cursor cc80
		Scan All
*** выводим детали
* kornd
			loExcel.Range(loExcel.Cells(NOM,1),loExcel.Cells(NOM,1)).Select
			loExcel.Selection.NumberFormat = '@'
			loExcel.Selection.HorizontalAlignment = -4108   		&& center
			loExcel.Cells(NOM,1).Value = Alltrim(cc80.kornd)
* poznd
			loExcel.Cells(NOM,2).Value = cc80.poznd
* naimd
			loExcel.Cells(NOM,3).Value = cc80.naimd

*** ed
*!*				WAIT WINDOW 'kompl  get_mater_ei'
			loExcel.Cells(NOM,4).Value = Alltrim(get_mater_ei(cc_dkt.materkodm))

* koli
			loExcel.Range(loExcel.Cells(NOM,5),loExcel.Cells(NOM,5)).Select
			loExcel.Selection.HorizontalAlignment = -4108   		&& center
			loExcel.Cells(NOM,5).Value = cc80.koli
* nrmd
			loExcel.Cells(NOM,6).Value = cc80.nrmd
* set format
			loExcel.Range(loExcel.Cells(NOM,1),loExcel.Cells(NOM,6)).Select
			loExcel.Selection.VerticalAlignment = -4160

			loExcel.Selection.BorderS(7).LineStyle = 1
			loExcel.Selection.BorderS(7).Weight = 2
			loExcel.Selection.BorderS(8).LineStyle = 1
			loExcel.Selection.BorderS(8).Weight = 2
			loExcel.Selection.BorderS(9).LineStyle = 1
			loExcel.Selection.BorderS(9).Weight = 2
			loExcel.Selection.BorderS(10).LineStyle = 1
			loExcel.Selection.BorderS(10).Weight = 2
*!*				loExcel.Selection.Borders(11).LineStyle = 1
*!*				loExcel.Selection.Borders(11).Weight = 2
*** increase nom
			NOM = NOM+1
		Endscan
		Use In cc80
	Endscan
	loExcel.Visible = .T.
Endif


*********************************************************
************* dsn3
If Thisform.txtVid.Value = 3
	Wait Window Nowait 'Excel открывается'
	Local loExcel
	loExcel = Createobject("Excel.Application")
*loExcel.Workbooks.Add()
	loExcel.WorkBooks.Open(Sys(5)+Sys(2003)+'\dsn3.xls')
	loExcel.DisplayAlerts = .F.

*** з а г о л о в о к
* изделие
	loExcel.Cells(2,1).Value = get_izd_ribf_by_kod(mshw) + ' ' + get_izd_im_by_kod(mshw)
* вид
	Do Case
	Case	Thisform.txtVid.Value = 1
		loExcel.Cells(3,3).Value = 'Основные'
	Case	Thisform.txtVid.Value = 2
		loExcel.Cells(3,3).Value = 'Комплектующие'
	Case	Thisform.txtVid.Value = 3
		loExcel.Cells(3,3).Value = 'Вспомогательные'
	Endcase
* группа, сортамент, материал
	Local mat
	mat = ''
	If Thisform.txtVidMat.Value = 2
		mat = Str(mmatkod) + ' ' + mmatnaim
	Else
		If Thisform.txtVidGr.Value = 2
			If Thisform.txtVidSort.Value = 2
				mat = Alltrim(mgrnaim) + ' / ' + msortnaim
			Else
				mat = mgrnaim
			Endif
		Else
			mat = 'По всем материалам'
		Endif
	Endif
*** коды заготовок
*!*		if thisform.txtVidZag.Value = 2
*!*			mat = mat + '(по кодам заготовок '+get_dosp56(val(thisform.txtKodzag.Value))+')'
*!*		endif		loExcel.Cells(4,3).value = mat
*** с т р о к и
	Local npp	&& номер позиции
	Local NOM	&& номер строки
	npp = 1
	NOM = 6

	Select cc_dkt
	Scan All
*** wwn

*** вывести материал
		loExcel.Cells(NOM,1).Value = ;
			cc_dkt.materkod + ' (' + Alltrim(Str(cc_dkt.materkodm)) + ') ' +;
			alltrim(cc_dkt.maternaim)
		loExcel.Range(loExcel.Cells(NOM,1),loExcel.Cells(NOM,6)).Select
		loExcel.Selection.Merge
		loExcel.Selection.Font.Bold = .T.
		NOM = NOM+1

*** выбираем и выводим детали
		Select * From c_kt;
			where materkodm = cc_dkt.materkodm;
			order By kornd;
			into Cursor cc80
		Scan All
*** выводим детали
* kornd
			loExcel.Range(loExcel.Cells(NOM,1),loExcel.Cells(NOM,1)).Select
			loExcel.Selection.NumberFormat = '@'
			loExcel.Selection.HorizontalAlignment = -4108   		&& center
			loExcel.Cells(NOM,1).Value = Alltrim(cc80.kornd)
* poznd
			loExcel.Cells(NOM,2).Value = cc80.poznd
* naimd
			loExcel.Cells(NOM,3).Value = cc80.naimd

*** ed
*!*				WAIT WINDOW 'wspom  get_mater_ei1'
			loExcel.Cells(NOM,4).Value = Alltrim(get_mater_ei1(cc_dkt.materkodm))

* koli
			loExcel.Range(loExcel.Cells(NOM,5),loExcel.Cells(NOM,5)).Select
			loExcel.Selection.HorizontalAlignment = -4108   		&& center
			loExcel.Cells(NOM,5).Value = cc80.koli
* nrmd
			loExcel.Range(loExcel.Cells(NOM,6),loExcel.Cells(NOM,6)).Select
			loExcel.Selection.NumberFormat = '0.000000'
			loExcel.Cells(NOM,6).Value = cc80.nrmd
* set format
			loExcel.Range(loExcel.Cells(NOM,1),loExcel.Cells(NOM,6)).Select
			loExcel.Selection.VerticalAlignment = -4160

			loExcel.Selection.BorderS(7).LineStyle = 1
			loExcel.Selection.BorderS(7).Weight = 2
			loExcel.Selection.BorderS(8).LineStyle = 1
			loExcel.Selection.BorderS(8).Weight = 2
			loExcel.Selection.BorderS(9).LineStyle = 1
			loExcel.Selection.BorderS(9).Weight = 2
			loExcel.Selection.BorderS(10).LineStyle = 1
			loExcel.Selection.BorderS(10).Weight = 2
*!*				loExcel.Selection.Borders(11).LineStyle = 1
*!*				loExcel.Selection.Borders(11).Weight = 2
*** increase nom
			NOM = NOM+1
		Endscan
		Use In cc80
	Endscan


	loExcel.Visible = .T.
Endif


Use In cc_dkt
Use In c_kt

Use In cddkt
