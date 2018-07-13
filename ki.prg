Create Cursor cca (st c(100))

Insert Into cca (st) Values ( '                   ВЕДОМОСТЬ')
Insert Into cca (st) Values ( '              обучения работников по качеству')
Insert Into cca (st) Values ( '              по состоянию на '+Dtoc(Date()))
Insert Into cca (st) Values ( '-------------------------------------------------------------------------')
Insert Into cca (st) Values ( ' №  Ф.И.О              Профессия          Дата        Дата    К-во зарег.')
Insert Into cca (st) Values ( 'п/п                                        пред.      посл.     случаев  ')
Insert Into cca (st) Values ( '                                          обучения   обучения   брака    ')
Insert Into cca (st) Values ( '-------------------------------------------------------------------------')
npp=1

hhh = SQLConnect('sqldb','sa','111')
If hhh > 0
	rrr = SQLExec(hhh,'select * from kadry where tn <> 0 AND YEAR(DATAOB1)>1900 AND YEAR(DATAOB2)>1900 order by fio','ckadry')
	If rrr = -1
		eodbc('ki kadry Sele')
	Endif
	SQLDisconnect(hhh)
Else
	eodbc('ki kadry conn')
Endif
Select  ckadry
Scan All
	Scatter Memvar
	iprof = get_dosp5(m.prof)
	wait window nowait M.FIO
	Local a[1]
	ikzop = 0
	*!*		select sum(kzop) as sss from nar where tn = m.tn and !empt(shbr) into array a
	hhh = SQLConnect('sqldb','sa','111')
	If hhh > 0
		rrr = SQLExec(hhh,'select sum(kzop) as sum_kzop from nar where tabn = ?m.tn and shbr<>0','c_sum_kzop')
		
		If rrr = -1
			eodbc('ki nar Sele')
		Endif
		SQLDisconnect(hhh)
	Else
		eodbc('ki nar conn')
	Endif
	*!*		aa = a[1]
	If c_sum_kzop.sum_kzop <> .Null.
		ikzop = c_sum_kzop.sum_kzop
	Else
		ikzop = 0
	Endif


	Insert Into cca (st) Values (Str(npp,3)+' '+Left(m.fio,18)+' '+Left(iprof,18)+' '+Dtoc(dataob1)+' ';
		+Dtoc(dataob2)+' '+Str(ikzop,5))
	npp = npp+1
Endscan
Use In ckadry

Select cca
Report Form f_cca3 Preview
Use In cca
