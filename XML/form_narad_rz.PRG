* ����������� ����� �� ��������
lparameters parTabn,parBeg,parEnd

if parameters()=0
	wait window nowait '�� ������ ��������� � ��������!'
	return -1
endif

if parameters()=1
	m.parBeg = date()
	m.parEnd = date()
endif

if parTabn <> 0
	* �������� ������ ��� ������

	*!*		*** <<<
	*!*		select *,get_mater_by_poznd(poznd) as naimmat from nar ;
	*!*			where ;
	*!*				tabn = m.parTabn and ;
	*!*				between(data_b,m.parBeg,m.parEnd) and ;
	*!*				regim <> 4 and regim <> 5 and regim <> 6 and rascenka = 0 ;
	*!*			order by ;
	*!*				data_b,naimrab,poznd ;
	*!*			into cursor c_out
	*!*		*** >>>

	local hh,rr
	hh = sqlconnect('sqldb','sa','111')
	if hh>0
		rr = sqlexec(hh,'select * from nar where tabn=?parTabn and '+;
			'data_b >= ?parBeg and data_b <= ?parEnd and '+;
			'regim <> 4 and regim<>5 and regim<>6 and rascenka=0 '+;
			'','c_out1')
		if rr = -1
			eodbc('form_narad_rz sele')
		endif

		select *,get_mater_by_poznd(poznd) as naimmat from c_out1 order by data_b,naimrab,poznd	into cursor c_out

		sqldisconnect(hh)
	else
		eodbc('form_narad_rz conn')
	endif
	release hh,rr

	select c_out
	if reccount()>0
		*debug
		*browse

		*������� Excel
		local loExcel
		wait window nowait 'Excel �����������...'
		loExcel = createobject('Excel.Application')
		loExcel.Workbooks.add()
		loExcel.Workbooks.open(sys(5)+sys(2003)+'\rabzad.xls')
		loExcel.DisplayAlerts = .f.

		*������� ���������
		loExcel.range("C2").value = ;
			'���. �'+str(m.parTabn,5)+'  '+get_fio_by_tabn(m.parTabn)
		loExcel.range("C3").value = ;
			'�� ������ � '+dtoc(m.parBeg)+' �� '+dtoc(m.parEnd)

		m.lnRow = 6
		*���������� ������
		local lnItogSumm,lnItogTrud
		m.lnItogSumm = 0
		m.lnItogTrud = 0
		select c_out
		scan all
		
			waitproc(recno(),reccount(),'�������')
		
			loExcel.range(loExcel.Cells(m.lnRow,1),loExcel.Cells(m.lnRow,14)).select
			loExcel.selection.VerticalAlignment = -4160

			loExcel.Cells(m.lnRow,6).HorizontalAlignment = -4108
			loExcel.Cells(m.lnRow,6).VerticalAlignment = -4160
			loExcel.Cells(m.lnRow,1).NumberFormat = 'dd/mm/yyyy'
			loExcel.Cells(m.lnRow,1).value = c_out.data_b

			loExcel.Cells(m.lnRow,2).NumberFormat = '@'
			loExcel.Cells(m.lnRow,2).value = c_out.shwz

			if empty(c_out.naimrab)		&& ������ �� ��������
				loExcel.Cells(m.lnRow,3).NumberFormat = '@'
				loExcel.Cells(m.lnRow,3).value = c_out.kornd

				loExcel.Cells(m.lnRow,4).NumberFormat = '@'
				if int(c_out.mar/100) = 1
					loExcel.Cells(m.lnRow,4).value = ;
						c_out.poznd+'  '+chr(10)+get_naimdet(c_out.shwz,c_out.kornd)+;
						get_razmer(c_out.poznd)
				else
					loExcel.Cells(m.lnRow,4).value = ;
						c_out.poznd+'  '+chr(10)+get_naimdet(c_out.shwz,c_out.kornd)
				endif

				loExcel.Cells(m.lnRow,5).NumberFormat = '@'
				loExcel.Cells(m.lnRow,5).value = get_kto_naim_by_kod(c_out.kto)

				loExcel.Cells(m.lnRow,6).NumberFormat = '0'
				loExcel.Cells(m.lnRow,6).HorizontalAlignment= -4108
				loExcel.Cells(m.lnRow,6).value = c_out.nto

			else						&&������ ������
				loExcel.Cells(m.lnRow,3).NumberFormat = '@'
				loExcel.Cells(m.lnRow,3).value = c_out.naimrab
			endif

			loExcel.Cells(m.lnRow,7).NumberFormat = '0'
			loExcel.Cells(m.lnRow,7).HorizontalAlignment= -4108
			loExcel.Cells(m.lnRow,7).value = c_out.kzp

			loExcel.Cells(m.lnRow,8).NumberFormat = '0'
			loExcel.Cells(m.lnRow,8).HorizontalAlignment= -4108
			loExcel.Cells(m.lnRow,8).value = c_out.rr

			loExcel.Cells(m.lnRow,9).NumberFormat = '0.00'
			loExcel.Cells(m.lnRow,9).HorizontalAlignment= -4152
			loExcel.Cells(m.lnRow,9).value = c_out.normww

			loExcel.Cells(m.lnRow,10).NumberFormat = '0.00'
			loExcel.Cells(m.lnRow,10).HorizontalAlignment= -4152
			loExcel.Cells(m.lnRow,10).value = get_rascenka()*c_out.procgot/100

			loExcel.Cells(m.lnRow,11).NumberFormat = '0.00'
			loExcel.Cells(m.lnRow,11).HorizontalAlignment= -4152
			loExcel.Cells(m.lnRow,11).value = c_out.kzp*c_out.normww*c_out.procgot/100
			m.lnItogTrud = m.lnItogTrud + c_out.kzp*c_out.normww*c_out.procgot/100

			loExcel.Cells(m.lnRow,12).NumberFormat = '0.00'
			loExcel.Cells(m.lnRow,12).HorizontalAlignment= -4152
			loExcel.Cells(m.lnRow,12).value = get_rascenka()*c_out.kzp*c_out.procgot/100
			m.lnItogSumm = m.lnItogSumm + get_rascenka()*c_out.kzp*c_out.procgot/100

			m.lnRow = m.lnRow+1

			* ���������� 35 ������� (??? ��� ������� � �������������� �������)
			if empty(c_out.naimrab) .and. c_out.mar = 35		&& ������ �� ��������
				loExcel.Cells(m.lnRow,4).value = ;
					get_mater_by_poznd(c_out.poznd)
				m.lnRow = m.lnRow+1
			endif
		endscan

		local ln1
		* ������
		for m.ln1 = 1 to 14
			loExcel.Cells(m.lnRow,m.ln1).borders(8).LineStyle = 1
			loExcel.Cells(m.lnRow,m.ln1).borders(8).Weight = 1
		endfor

		* �����
		local ln1
		* ������
		for m.ln1 = 1 to 12
			loExcel.Cells(m.lnRow,m.ln1).borders(8).LineStyle = 1
			loExcel.Cells(m.lnRow,m.ln1).borders(8).Weight = 2
			loExcel.Cells(m.lnRow,m.ln1).font.Bold = .t.
		endfor
		* ����
		loExcel.Cells(m.lnRow,10).NumberFormat = '@'
		loExcel.Cells(m.lnRow,10).HorizontalAlignment= -4152
		loExcel.Cells(m.lnRow,10).value = '�����'

		loExcel.Cells(m.lnRow,11).NumberFormat = '0.00'
		loExcel.Cells(m.lnRow,11).HorizontalAlignment= -4152
		loExcel.Cells(m.lnRow,11).value = m.lnItogTrud

		loExcel.Cells(m.lnRow,12).NumberFormat = '0.00'
		loExcel.Cells(m.lnRow,12).HorizontalAlignment= -4152
		loExcel.Cells(m.lnRow,12).value = m.lnItogSumm

		* ��������� Excel
		loExcel.visible = .t.
		wait window nowait '����� �����'
		* loExcel.ActiveWindow.SelectedSheets.PrintPreview

	else
		wait window nowait '��� �� ������ ������ �� �������� '+get_fio_by_tabn(m.parTabn)
	endif
	use in c_out
else
	* ������� Excel-��������
	local loExcel,lnStartRow
	wait window nowait 'Excel �����������...'
	loExcel = createobject('Excel.Application')
	loExcel.Workbooks.add()
	loExcel.Workbooks.open(sys(5)+sys(2003)+'\rabzad.xls')
	loExcel.DisplayAlerts = .f.
	* ������
	m.lnStartRow = 0
	* �������� ������ �����������

	*!*		select * ;
	*!*			from kadry ;
	*!*			order by fio ;
	*!*			into cursor c_sotr

	local hh,rr
	hh = sqlconnect('sqldb','sa','111')
	if hh>0
		rr = sqlexec(hh,'select * from kadry order by fio','c_sotr')
		if rr = -1
			eodbc('form_narad_rz sele3')
		endif

		sqldisconnect(hh)
	else
		eodbc('form_narad_rz conn3')
	endif
	release hh,rr

	select c_sotr
	scan all

		select c_sotr
		waitproc(recno(),reccount(),alltrim(c_sotr.fio))

		* �������� ������ ��� ������

		*!*			select * from nar ;
		*!*				where ;
		*!*					tabn = c_sotr.tn and ;
		*!*					between(data_b,m.parBeg,m.parEnd) and ;
		*!*					regim <> 4 and regim <> 5 and regim <> 6 and rascenka = 0 ;
		*!*				order by ;
		*!*					data_b,naimrab,poznd ;
		*!*				into cursor c_out

		local hh,rr
		hh = sqlconnect('sqldb','sa','111')
		if hh>0
			rr = sqlexec(hh,'select * from nar where tabn=?c_sotr.tn and '+;
				'data_b >= ?parBeg and data_b <= ?parEnd and '+;
				'regim<>4 and regim<>5 and regim<>6 and rascenka=0','c_out')
			if rr = -1
				eodbc('form_narad_rz sele1')
			endif

			sqldisconnect(hh)
		else
			eodbc('form_narad_rz conn1')
		endif
		release hh,rr

		select c_out
		if reccount()>0
			*debug
			*browse

			* ������ ��������
			if m.lnStartRow > 0
				* ����� ��������
				loExcel.ActiveWindow.SelectedSheets.HPageBreaks.add(loExcel.range(loExcel.Cells(m.lnStartRow+1,1),loExcel.Cells(m.lnStartRow+1,1)))
				* ��������
				loExcel.range("A4:N5").select
				loExcel.selection.copy
				loExcel.range(loExcel.Cells(m.lnStartRow+4,1),loExcel.Cells(m.lnStartRow+4,1)).select
				loExcel.selection.PasteSpecial(-4104,-4142,.f.,.f.)
			endif

			* ������� ���������
			loExcel.Cells(m.lnStartRow+1,3).value = ;
				'������� �������'
			loExcel.Cells(m.lnStartRow+1,3).font.Bold = .t.
			loExcel.Cells(m.lnStartRow+1,3).font.Underline = 2
			loExcel.Cells(m.lnStartRow+2,3).value = ;
				'���. �'+str(c_sotr.tn,5)+'  '+get_fio_by_tabn(c_sotr.tn)
			loExcel.Cells(m.lnStartRow+2,3).font.Bold = .t.
			loExcel.Cells(m.lnStartRow+3,3).value = ;
				'�� ������ � '+dtoc(m.parBeg)+' �� '+dtoc(m.parEnd)
			loExcel.Cells(m.lnStartRow+3,3).font.Bold = .t.

			m.lnRow = 6 + m.lnStartRow
			*���������� ������
			local lnItogSumm,lnItogTrud
			m.lnItogSumm = 0
			m.lnItogTrud = 0
			select c_out
			scan all
			
				waitproc(recno(),reccount(),'������� ������� '+alltrim(c_sotr.fio))
			
				loExcel.range(loExcel.Cells(m.lnRow,1),loExcel.Cells(m.lnRow,14)).select
				loExcel.selection.VerticalAlignment = -4160

				loExcel.Cells(m.lnRow,6).HorizontalAlignment = -4108
				loExcel.Cells(m.lnRow,1).NumberFormat = 'dd/mm/yyyy'
				loExcel.Cells(m.lnRow,1).value = c_out.data_b

				loExcel.Cells(m.lnRow,2).NumberFormat = '@'
				loExcel.Cells(m.lnRow,2).value = c_out.shwz

				if empty(c_out.naimrab)		&& ������ �� ��������
					loExcel.Cells(m.lnRow,3).NumberFormat = '@'
					loExcel.Cells(m.lnRow,3).value = c_out.kornd

					loExcel.Cells(m.lnRow,4).NumberFormat = '@'
					if int(c_out.mar/100) = 1
						loExcel.Cells(m.lnRow,4).value = ;
							c_out.poznd+'  '+chr(10)+get_naimdet(c_out.shwz,c_out.kornd)+;
							get_razmer(c_out.poznd)
					else
						loExcel.Cells(m.lnRow,4).value = ;
							c_out.poznd+'  '+chr(10)+get_naimdet(c_out.shwz,c_out.kornd)
					endif

					loExcel.Cells(m.lnRow,5).NumberFormat = '@'
					loExcel.Cells(m.lnRow,5).value = get_kto_naim_by_kod(c_out.kto)

					loExcel.Cells(m.lnRow,6).NumberFormat = '0'
					loExcel.Cells(m.lnRow,6).HorizontalAlignment= -4108
					loExcel.Cells(m.lnRow,6).value = c_out.nto

				else						&&������ ������
					loExcel.Cells(m.lnRow,3).NumberFormat = '@'
					loExcel.Cells(m.lnRow,3).value = c_out.naimrab
				endif

				loExcel.Cells(m.lnRow,7).NumberFormat = '0'
				loExcel.Cells(m.lnRow,7).HorizontalAlignment= -4108
				loExcel.Cells(m.lnRow,7).value = c_out.kzp

				loExcel.Cells(m.lnRow,8).NumberFormat = '0'
				loExcel.Cells(m.lnRow,8).HorizontalAlignment= -4108
				loExcel.Cells(m.lnRow,8).value = c_out.rr

				loExcel.Cells(m.lnRow,9).NumberFormat = '0.00'
				loExcel.Cells(m.lnRow,9).HorizontalAlignment= -4152
				loExcel.Cells(m.lnRow,9).value = c_out.normww

				loExcel.Cells(m.lnRow,10).NumberFormat = '0.00'
				loExcel.Cells(m.lnRow,10).HorizontalAlignment= -4152
				loExcel.Cells(m.lnRow,10).value = get_rascenka()*c_out.procgot/100

				loExcel.Cells(m.lnRow,11).NumberFormat = '0.00'
				loExcel.Cells(m.lnRow,11).HorizontalAlignment= -4152
				loExcel.Cells(m.lnRow,11).value = c_out.kzp*c_out.normww*c_out.procgot/100
				m.lnItogTrud = m.lnItogTrud + c_out.kzp*c_out.normww*c_out.procgot/100

				loExcel.Cells(m.lnRow,12).NumberFormat = '0.00'
				loExcel.Cells(m.lnRow,12).HorizontalAlignment= -4152
				loExcel.Cells(m.lnRow,12).value = get_rascenka()*c_out.kzp*c_out.procgot/100
				m.lnItogSumm = m.lnItogSumm + get_rascenka()*c_out.kzp*c_out.procgot/100

				m.lnRow = m.lnRow+1

				* ���������� 35 �������
				if empty(c_out.naimrab) .and. c_out.mar = 35		&& ������ �� ��������
					loExcel.Cells(m.lnRow,4).value = ;
						get_mater_by_poznd(c_out.poznd)
					m.lnRow = m.lnRow+1
				endif

				m.lnStartRow = m.lnRow

				local ln1
				* ������
				for m.ln1 = 1 to 14
					loExcel.Cells(m.lnRow,m.ln1).borders(8).LineStyle = 1
					loExcel.Cells(m.lnRow,m.ln1).borders(8).Weight = 1
				endfor

			endscan

			* �����
			local ln1
			* ������
			for m.ln1 = 1 to 14
				loExcel.Cells(m.lnRow,m.ln1).borders(8).LineStyle = 1
				loExcel.Cells(m.lnRow,m.ln1).borders(8).Weight = 2
				loExcel.Cells(m.lnRow,m.ln1).font.Bold = .t.
			endfor
			* ����
			loExcel.Cells(m.lnRow,10).NumberFormat = '@'
			loExcel.Cells(m.lnRow,10).HorizontalAlignment= -4152
			loExcel.Cells(m.lnRow,10).value = '�����'

			loExcel.Cells(m.lnRow,11).NumberFormat = '0.00'
			loExcel.Cells(m.lnRow,11).HorizontalAlignment= -4152
			loExcel.Cells(m.lnRow,11).value = m.lnItogTrud

			loExcel.Cells(m.lnRow,12).NumberFormat = '0.00'
			loExcel.Cells(m.lnRow,12).HorizontalAlignment= -4152
			loExcel.Cells(m.lnRow,12).value = m.lnItogSumm

		endif
		use in c_out
	endscan
	use in c_sotr
	* ��������� Excel
	loExcel.visible = .t.
	wait window nowait '����� �����'
endif

return

*************************************************
*!*	function get_naimdet(parShwz,parKornd)
*!*		local lcRes
*!*		local svWA
*!*
*!*		m.svWA = select(0)
*!*
*!*		select * from kt,izd ;
*!*			where ;
*!*				kt.shw = izd.kod and ;
*!*				kt.kornd = m.parKornd and ;
*!*				alltrim(izd.shwz) == alltrim(m.parShwz) ;
*!*			into cursor cc_kt
*!*		if reccount()>0
*!*			m.lcRes = cc_kt.naimd
*!*		else
*!*			m.lcRes = ''
*!*		endif
*!*		use in cc_kt
*!*
*!*		select (svWA)

*!*		return alltrim(m.lcRes)
*!*	endfunc


*************************************************
function get_naimdet(parshwz,parkornd)
	local res,hh,rr

	res = ''

	hh = sqlconnect('sqldb','sa','111')
	if hh>0
		rr = sqlexec(hh,'select * from ktshwz where rtrim(shwz)=rtrim(?parshwz) and rtrim(kornd)=rtrim(?parkornd)','cc_kt')
		if rr = -1
			eodbc('get_naimdet sele')
		endif

		select cc_kt
		if reccount()>0
			res = alltrim(cc_kt.naimd)
		endif

		use in cc_kt
		sqldisconnect(hh)
	else
		eodbc('get_naimdet conn')
	endif

	return res
endfunc

*!*	*************************************************
*!*	function get_rascenka()
*!*		local lnRes
*!*		m.lnRes = 0
*!*		* select from ww
*!*		select * from ww ;
*!*			where ;
*!*				!empty(ww.shwz) and ;
*!*				alltrim(ww.shwz) == alltrim(c_out.shwz) and ;
*!*				ww.mar = c_out.mar and ;
*!*				ww.nto = c_out.nto ;
*!*			into cursor c800
*!*		if reccount()>0
*!*			select * from tarif ;
*!*				where ;
*!*					vidts = c800.setka and ;
*!*					rr = c800.rr ;
*!*				into cursor c900
*!*			if reccount()>0
*!*				m.lnRes = c900.dengi*c_out.normww/60
*!*			endif
*!*			use in c900
*!*		endif
*!*		use in c800
*!*		return m.lnRes
*!*	endfunc


******************************************************
function get_rascenka()
	local res,rr,hh,rr1
	res = 0

	hh = sqlconnect('sqldb','sa','111')
	if hh>0
		rr = sqlexec(hh,"select * from ww where rtrim(shwz)=rtrim(?c_out.shwz) and "+;
			"mar=?c_out.mar and nto=?c_out.nto",'c800')
		if rr = -1
			eodbc('get_rascenka sele')
		endif

		select c800
		if reccount()>0
			rr1 = sqlexec(hh,'select * from tarif where vidts=?c800.setka and rr=?c800.rr','c900')
			if rr1= -1
				eodbc('get_rascenka sele1')
			endif

			select c900
			if reccount()>0
				res = c900.dengi * c_out.normww
			endif
			use in c900
		endif

		use in c800
		sqldisconnect(hh)
	else
		eodbc('get_rascenka conn')
	endif

	return res
endfunc


*!*	*****************************************************
*!*	function get_rascenka_s()
*!*		local res
*!*		res = 0
*!*		select * from tarif ;
*!*			where ;
*!*				vidts = c_out.setka ;
*!*				and rr = c_out.rr ;
*!*			into cursor c800
*!*
*!*		use in c800
*!*
*!*		return res
*!*	endfunc


*/////////////////////////////////////////////////////
function get_rascenka_s()
	local res,rr,hh
	res = 0
	hh = sqlconnect('sqldb','sa','111')
	if hh>0
		rr = sqlexec(hh,'select * from tarif where vidts=?c_out.setka and rr=?c_out.rr','c800')
		if rr = -1
			eodbc('get_rascenka_s sele')
		endif
		select c800
		if reccount()>0

		endif
		use in 800
		sqldisconnect(hh)
	else
		eodbc('get_rascenka_s conn')
	endif
endfunc

