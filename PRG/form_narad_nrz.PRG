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
	
*!*		* <<<
*!*		select * from nar ;
*!*			where ;
*!*				tabn = m.parTabn and ;
*!*				between(data_b,m.parBeg,m.parEnd) and ;
*!*				regim <> 4 and regim <> 5 and regim <> 6 and rascenka = 0 ;
*!*			order by ;
*!*				data_b,naimrab,poznd ;	
*!*			into cursor c_out
	* >>>
	
	local hh,rr
	hh = sqlconnect('sqldb','sa','111')
	if hh>0
		rr = sqlexec(hh,'select * from nar where tabn=?parTabn and data_b>=?parBeg and data_b<=?parEnd and '+;
						'regim<>4 and regim<>5 and regim<>6 and rascenka=0 order by data_b,naimrab,poznd','c_out')
		if rr = -1
			eodbc('form_narad_nrz sele')
		endif					
		sqldisconnect(hh)
	else
		eodbc('form_narad_nrz conn')
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
		loExcel.Workbooks.Add()
		loExcel.Workbooks.Open(sys(5)+sys(2003)+'\nrabzad.xls')
		loExcel.DisplayAlerts = .f.
		
		*������� ���������
		loExcel.Range("C2").Value = ;
			'���. �'+str(m.parTabn,5)+'  '+get_fio_by_tabn(m.parTabn) 
		loExcel.Range("C3").Value = ;
			'�� ������ � '+dtoc(m.parBeg)+' �� '+dtoc(m.parEnd)
		
		m.lnRow = 6
		*���������� ������
		local lnItogSumm,lnItogTrud
		m.lnItogSumm = 0
		m.lnItogTrud = 0
		select c_out
		scan all
		
			waitproc(recno(),reccount(),'�������')
		
			loExcel.Cells(m.lnRow,6).HorizontalAlignment = -4108
			loExcel.Cells(m.lnRow,1).NumberFormat = 'dd/mm/yyyy'
			loExcel.Cells(m.lnRow,1).Value = c_out.data_b		
			
			loExcel.Cells(m.lnRow,2).NumberFormat = '@'
			loExcel.Cells(m.lnRow,2).Value = c_out.shwz
			
			if empty(c_out.naimrab)		&& ������ �� ��������
				loExcel.Cells(m.lnRow,3).NumberFormat = '@'
				loExcel.Cells(m.lnRow,3).Value = c_out.kornd
				
				loExcel.Cells(m.lnRow,4).NumberFormat = '@'
				loExcel.Cells(m.lnRow,4).Value = ;
					c_out.poznd+'  '+chr(10)+get_naimdet(c_out.shwz,c_out.kornd)
					
				loExcel.Cells(m.lnRow,5).NumberFormat = '@'
				loExcel.Cells(m.lnRow,5).Value = get_kto_naim_by_kod(c_out.kto)
				
				loExcel.Cells(m.lnRow,6).NumberFormat = '0'
				loExcel.Cells(m.lnRow,6).HorizontalAlignment= -4108
				loExcel.Cells(m.lnRow,6).Value = c_out.nto
						
			else						&&������ ������
				loExcel.Cells(m.lnRow,3).NumberFormat = '@'
				loExcel.Cells(m.lnRow,3).Value = c_out.naimrab					
			endif	
			
			loExcel.Cells(m.lnRow,7).NumberFormat = '0'
			loExcel.Cells(m.lnRow,7).HorizontalAlignment= -4108
			loExcel.Cells(m.lnRow,7).Value = c_out.kzp
					
			loExcel.Cells(m.lnRow,8).NumberFormat = '0'
			loExcel.Cells(m.lnRow,8).HorizontalAlignment= -4108
			loExcel.Cells(m.lnRow,8).Value = c_out.rr
			
			loExcel.Cells(m.lnRow,9).NumberFormat = '0.00'
			loExcel.Cells(m.lnRow,9).HorizontalAlignment= -4152
			loExcel.Cells(m.lnRow,9).Value = c_out.normww
			
			loExcel.Cells(m.lnRow,10).NumberFormat = '0.00'
			loExcel.Cells(m.lnRow,10).HorizontalAlignment= -4152
			loExcel.Cells(m.lnRow,10).Value = c_out.rascenka*c_out.procgot/100	
			
			loExcel.Cells(m.lnRow,11).NumberFormat = '0.00'
			loExcel.Cells(m.lnRow,11).HorizontalAlignment= -4152
			loExcel.Cells(m.lnRow,11).Value = c_out.kzp*c_out.normww/60*c_out.procgot/100		
			m.lnItogTrud = m.lnItogTrud + c_out.kzp*c_out.normww/60*c_out.procgot/100		
			
			loExcel.Cells(m.lnRow,12).NumberFormat = '0.00'
			loExcel.Cells(m.lnRow,12).HorizontalAlignment= -4152
			loExcel.Cells(m.lnRow,12).Value = c_out.rascenka*c_out.kzp*c_out.procgot/100		
			m.lnItogSumm = m.lnItogSumm + c_out.rascenka*c_out.kzp*c_out.procgot/100		

			m.lnRow = m.lnRow+1
		endscan		
		
		local ln1
		* ������
		for m.ln1 = 1 to 14 
			loExcel.Cells(m.lnRow,m.ln1).Borders(8).LineStyle = 1
			loExcel.Cells(m.lnRow,m.ln1).Borders(8).Weight = 1		
		endfor		
		
		* �����
			local ln1
			* ������
			for m.ln1 = 1 to 12 
				loExcel.Cells(m.lnRow,m.ln1).Borders(8).LineStyle = 1
				loExcel.Cells(m.lnRow,m.ln1).Borders(8).Weight = 2		
				loExcel.Cells(m.lnRow,m.ln1).Font.Bold = .t.
			endfor
			* ����			
			loExcel.Cells(m.lnRow,10).NumberFormat = '@'
			loExcel.Cells(m.lnRow,10).HorizontalAlignment= -4152
			loExcel.Cells(m.lnRow,10).Value = '�����'
		
			loExcel.Cells(m.lnRow,11).NumberFormat = '0.00'
			loExcel.Cells(m.lnRow,11).HorizontalAlignment= -4152
			loExcel.Cells(m.lnRow,11).Value = m.lnItogTrud

			loExcel.Cells(m.lnRow,12).NumberFormat = '0.00'
			loExcel.Cells(m.lnRow,12).HorizontalAlignment= -4152
			loExcel.Cells(m.lnRow,12).Value = m.lnItogSumm

		* ��������� Excel
		loExcel.Visible = .t.
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
	loExcel.Workbooks.Add()
	loExcel.Workbooks.Open(sys(5)+sys(2003)+'\nrabzad.xls')
	loExcel.DisplayAlerts = .f.
	* ������
	m.lnStartRow = 0
	* �������� ������ �����������
	
	* <<<
*!*		select * ;
*!*			from kadry ;
*!*			order by fio ;
*!*			into cursor c_sotr
	* >>>
	
	local hh,rr
	hh = sqlconnect('sqldb','sa','111')
	if hh>0
		rr = sqlexec(hh,'select * from kadry order by fio','c_sotr')
		if rr = -1
			eodbc('form_narad_nrz sele1')
		endif	
		sqldisconnect(hh)
	else
		eodbc('form_narad_nrz conn1')
	endif
	release hh,rr	
		
	select c_sotr	
	scan all	
		* �������� ������ ��� ������
		
		* <<<
*!*			select * from nar ;
*!*				where ;
*!*					tabn = c_sotr.tn and ;
*!*					between(data_b,m.parBeg,m.parEnd) and ;
*!*					regim <> 4 and regim <> 5 and regim <> 6 and rascenka = 0 ;
*!*				order by ;
*!*					data_b,naimrab,poznd ;	
*!*				into cursor c_out
		* >>>
		
		local hh,rr
		hh = sqlconnect('sqldb','sa','111')
		if hh>0
			rr = sqlexec(hh,'select * from nar where tabn=?c_sotr.tn and regim<>4 and regim<>5 and '+;
							'regim<>6 and rascenka=0 '+;
							'and data_b>=?parBeg and data_b<=?parEnd '+;
							'order by data_b,naimrab,poznd','c_out')
			if rr = -1
				eodbc('form_narad_nrz sele2')
			endif						
			sqldisconnect(hh)
		else
			eodbc('form_narad_nrz conn2')
		endif
		release hh,rr	
			
		select c_out	
		if reccount()>0
			*debug
			*browse
			
			* ������ ��������
			if m.lnStartRow > 0			
				* ����� ��������
				loExcel.ActiveWindow.SelectedSheets.HPageBreaks.Add(loExcel.Range(loExcel.Cells(m.lnStartRow+1,1),loExcel.Cells(m.lnStartRow+1,1)))
				* ��������
				loExcel.Range("A4:N5").Select
				loExcel.Selection.Copy
				loExcel.Range(loExcel.Cells(m.lnStartRow+4,1),loExcel.Cells(m.lnStartRow+4,1)).Select
				loExcel.Selection.PasteSpecial(-4104,-4142,.f.,.f.)
			endif
			
			* ������� ���������
			loExcel.Cells(m.lnStartRow+1,3).Value = ;
				'������������� ������� �������'
			loExcel.Cells(m.lnStartRow+1,3).Font.Bold = .t.
			loExcel.Cells(m.lnStartRow+1,3).Font.Underline = 2
			loExcel.Cells(m.lnStartRow+2,3).Value = ;
				'���. �'+str(c_sotr.tn,5)+'  '+get_fio_by_tabn(c_sotr.tn) 
			loExcel.Cells(m.lnStartRow+2,3).Font.Bold = .t.				
			loExcel.Cells(m.lnStartRow+3,3).Value = ;
				'�� ������ � '+dtoc(m.parBeg)+' �� '+dtoc(m.parEnd)
			loExcel.Cells(m.lnStartRow+3,3).Font.Bold = .t.				
			
			m.lnRow = 6 + m.lnStartRow
			*���������� ������
			local lnItogSumm,lnItogTrud
			m.lnItogSumm = 0
			m.lnItogTrud = 0
			select c_out
			scan all
			
				waitproc(recno(),reccount(),'������� ������� '+alltrim(c_sotr.fio)) 
			
				loExcel.Cells(m.lnRow,6).HorizontalAlignment = -4108
				loExcel.Cells(m.lnRow,1).NumberFormat = 'dd/mm/yyyy'
				loExcel.Cells(m.lnRow,1).Value = c_out.data_b		
				
				loExcel.Cells(m.lnRow,2).NumberFormat = '@'
				loExcel.Cells(m.lnRow,2).Value = c_out.shwz
				
				if empty(c_out.naimrab)		&& ������ �� ��������
					loExcel.Cells(m.lnRow,3).NumberFormat = '@'
					loExcel.Cells(m.lnRow,3).Value = c_out.kornd
					
					loExcel.Cells(m.lnRow,4).NumberFormat = '@'
					loExcel.Cells(m.lnRow,4).Value = ;
						c_out.poznd+'  '+chr(10)+get_naimdet(c_out.shwz,c_out.kornd)
						
					loExcel.Cells(m.lnRow,5).NumberFormat = '@'
					loExcel.Cells(m.lnRow,5).Value = get_kto_naim_by_kod(c_out.kto)
					
					loExcel.Cells(m.lnRow,6).NumberFormat = '0'
					loExcel.Cells(m.lnRow,6).HorizontalAlignment= -4108
					loExcel.Cells(m.lnRow,6).Value = c_out.nto
							
				else						&&������ ������
					loExcel.Cells(m.lnRow,3).NumberFormat = '@'
					loExcel.Cells(m.lnRow,3).Value = c_out.naimrab					
				endif	
				
				loExcel.Cells(m.lnRow,7).NumberFormat = '0'
				loExcel.Cells(m.lnRow,7).HorizontalAlignment= -4108
				loExcel.Cells(m.lnRow,7).Value = c_out.kzp
						
				loExcel.Cells(m.lnRow,8).NumberFormat = '0'
				loExcel.Cells(m.lnRow,8).HorizontalAlignment= -4108
				loExcel.Cells(m.lnRow,8).Value = c_out.rr
				
				loExcel.Cells(m.lnRow,9).NumberFormat = '0.00'
				loExcel.Cells(m.lnRow,9).HorizontalAlignment= -4152
				loExcel.Cells(m.lnRow,9).Value = c_out.normww
				
				loExcel.Cells(m.lnRow,10).NumberFormat = '0.00'
				loExcel.Cells(m.lnRow,10).HorizontalAlignment= -4152
				loExcel.Cells(m.lnRow,10).Value = c_out.rascenka*c_out.procgot/100	
				
				loExcel.Cells(m.lnRow,11).NumberFormat = '0.00'
				loExcel.Cells(m.lnRow,11).HorizontalAlignment= -4152
				loExcel.Cells(m.lnRow,11).Value = c_out.kzp*c_out.normww/60*c_out.procgot/100		
				m.lnItogTrud = m.lnItogTrud + c_out.kzp*c_out.normww/60*c_out.procgot/100		
				
				loExcel.Cells(m.lnRow,12).NumberFormat = '0.00'
				loExcel.Cells(m.lnRow,12).HorizontalAlignment= -4152
				loExcel.Cells(m.lnRow,12).Value = c_out.rascenka*c_out.kzp*c_out.procgot/100		
				m.lnItogSumm = m.lnItogSumm + c_out.rascenka*c_out.kzp*c_out.procgot/100		

				m.lnRow = m.lnRow+1
				m.lnStartRow = m.lnRow

				local ln1
				* ������
				for m.ln1 = 1 to 14 
					loExcel.Cells(m.lnRow,m.ln1).Borders(8).LineStyle = 1
					loExcel.Cells(m.lnRow,m.ln1).Borders(8).Weight = 1		
				endfor

			endscan		
			
			* �����
				local ln1
				* ������
				for m.ln1 = 1 to 14 
					loExcel.Cells(m.lnRow,m.ln1).Borders(8).LineStyle = 1
					loExcel.Cells(m.lnRow,m.ln1).Borders(8).Weight = 2		
					loExcel.Cells(m.lnRow,m.ln1).Font.Bold = .t.
				endfor
				* ����			
				loExcel.Cells(m.lnRow,10).NumberFormat = '@'
				loExcel.Cells(m.lnRow,10).HorizontalAlignment= -4152
				loExcel.Cells(m.lnRow,10).Value = '�����'
			
				loExcel.Cells(m.lnRow,11).NumberFormat = '0.00'
				loExcel.Cells(m.lnRow,11).HorizontalAlignment= -4152
				loExcel.Cells(m.lnRow,11).Value = m.lnItogTrud

				loExcel.Cells(m.lnRow,12).NumberFormat = '0.00'
				loExcel.Cells(m.lnRow,12).HorizontalAlignment= -4152
				loExcel.Cells(m.lnRow,12).Value = m.lnItogSumm

		endif	
		use in c_out				
	endscan	
	use in c_sotr
	* ��������� Excel
	loExcel.Visible = .t.
	wait window nowait '����� �����'
endif	

return


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

*!*		return m.lcRes
*!*	endfunc  
		

