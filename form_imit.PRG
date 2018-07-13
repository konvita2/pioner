* параеметр - номер заказа
lparameters parNom

local hh,rr,nom,mcena,most
local curdu
local formul7

hh = sqlcn()
if hh > 0
	
	* выводим в Excel
	wait window nowait 'Запуск Excel' 
	local loExcel
	loExcel = createobject('Excel.Application')
	*loExcel.Workbooks.Add()
	loExcel.Workbooks.Open(sys(5)+sys(2003)+'\imitp.xls')
	loExcel.DisplayAlerts = .f.
	loExcel.Visible = .f. && !!!

	* № заказа
	loExcel.cells(3,2).value = parNom
	loExcel.cells(3,3).value = get_imitp_nam(parNom)
		
	loExcel.range(loExcel.cells(3,1),loExcel.cells(3,4)).font.size = 11
	loExcel.range(loExcel.cells(3,1),loExcel.cells(3,4)).font.bold = .t.
	loExcel.range(loExcel.cells(3,1),loExcel.cells(3,4)).font.italic = 11	
	
	* перечень заказов
	wait window nowait 'Выборка перечня заказов' 
	loExcel.cells(4,1).value = 'ПЕРЕЧЕНЬ ИЗДЕЛИЙ И УЗЛОВ'
	
	** formats
	loExcel.range(loExcel.cells(1,1),loExcel.cells(2,10)).font.bold = .t.
	loExcel.range(loExcel.cells(1,1),loExcel.cells(2,4)).font.size = 12
	
	loExcel.range(loExcel.cells(1,10),loExcel.cells(1,10)).font.size = 8
	loExcel.range(loExcel.cells(1,10),loExcel.cells(1,10)).HorizontalAlignment = -4152
	
	loExcel.cells(1,10).value = "Сформировано: " + ttoc(datetime())
	
	loExcel.range(loExcel.cells(4,1),loExcel.cells(4,1)).font.bold = .t.
	
	nnom = 5
	rr = sqlexec(hh,'select distinct shw from shwzimitp where nom=?parNom','cc_shw')
	if rr = -1
		eodbc('form_imit sele1')		
	else
		select cc_shw
		scan all
			local koll 
			koll = get_imittp_kolizd(parNom,cc_shw.shw)
		
			loExcel.cells(nnom,2).value = cc_shw.shw
			loExcel.cells(nnom,4).value = alltrim(str(koll)) + ' ед.' 
			loExcel.cells(nnom,5).value = get_izd_ribf_by_kod(cc_shw.shw)
			loExcel.cells(nnom,7).value = get_izd_im_by_kod(cc_shw.shw)
			
			** formats
			loExcel.range(loExcel.cells(nnom,4),loExcel.cells(nnom,4)).HorizontalAlignment = -4108
						
			nnom = nnom+1
			
			wait window nowait 'Выборка перечня узлов' 
			rr = sqlexec(hh,'select distinct poznw,naimw from shwzimitp '+;
							'where nom=?parNom and shw=?cc_shw.shw','cc_poznw')
			if rr = -1
				eodbc('form_imit sele2')				
			else	
				select cc_poznw
				scan all
					loExcel.cells(nnom,3).value = cc_poznw.poznw + ' ' + cc_poznw.naimw   	
					loExcel.cells(nnom,8).value = get_imitu_kol(parNom,cc_shw.shw,cc_poznw.poznw) * koll
					
					nnom = nnom+1
				endscan			
				use in cc_poznw				
			endif
			
		endscan		
		use in cc_shw
	endif
	
	wait window nowait 'Вывод заголовков' 
	
	* title
	nnom = nnom + 1
	loExcel.cells(nnom,1).value = 'Код'
	loExcel.cells(nnom,2).value = 'Карт'
	loExcel.cells(nnom,3).value = 'Наименование'
	loExcel.cells(nnom,4).value = 'Ед'
	loExcel.cells(nnom,5).value = 'Кол'
	loExcel.cells(nnom,6).value = 'Цена'
	loExcel.cells(nnom,7).value = 'Сумма'
	loExcel.cells(nnom,8).value = 'Кол налич'
	loExcel.cells(nnom,9).value = 'Кол дефиц'
	loExcel.cells(nnom,10).value = 'Сумма дефиц'
	
	loExcel.range(loExcel.cells(nnom,1),loExcel.cells(nnom,10)).HorizontalAlignment = -4108
	loExcel.range(loExcel.cells(nnom,1),loExcel.cells(nnom,10)).Borders(8).LineStyle = 1
	loExcel.range(loExcel.cells(nnom,1),loExcel.cells(nnom,10)).Borders(10).LineStyle = 1
	loExcel.range(loExcel.cells(nnom,1),loExcel.cells(nnom,10)).Borders(7).LineStyle = 1
	loExcel.range(loExcel.cells(nnom,1),loExcel.cells(nnom,10)).Borders(9).LineStyle = 1
	loExcel.range(loExcel.cells(nnom,1),loExcel.cells(nnom,10)).Borders(11).LineStyle = 1
	
	loExcel.range(loExcel.cells(nnom,1),loExcel.cells(nnom,10)).HorizontalAlignment = -4108
	loExcel.range(loExcel.cells(nnom,1),loExcel.cells(nnom,10)).VerticalAlignment = -4108
	loExcel.range(loExcel.cells(nnom,1),loExcel.cells(nnom,10)).Font.Bold = .t.
	loExcel.range(loExcel.cells(nnom,1),loExcel.cells(nnom,10)).WrapText = .t.
	
	nnom = nnom + 1
	
	local nom1,nom2
	nom1 = nnom
	
	formul7 = '=0+'
	formul10 = '=0+'
	
	* data
	wait window nowait 'Выборка перечня материалов' 
	rr = sqlexec(hh,'select shwzimitp.kodm, mater.naim as mnaim, avg(mater.v1000) as v1000, avg(shwzimitp.du) as du, '+;
					'sum(kol1*kolizd) as skol from shwzimitp,mater '+;
					'where nom=?parNom and shwzimitp.kodm = mater.kodm '+;
					'group by shwzimitp.kodm, mater.naim order by du, shwzimitp.kodm','cc_kodm')
	if rr = -1
		eodbc('form_imit sele3')
	else
	
		curdu = 0	
			
		select cc_kodm
		scan all		
			
			waitproc(recno(),reccount(),'Выбрано материалов')
		
			if curdu <> cc_kodm.du 
			
				* вывод итогов
				if curdu <> 0
					nom2 = nnom - 1 
					
					loExcel.cells(nnom,7).FormulaR1C1 = '=SUM(R' + alltrim(str(nom1)) + 'C:R' + alltrim(str(nom2)) + 'C)' 
					loExcel.cells(nnom,10).FormulaR1C1 = '=SUM(R' + alltrim(str(nom1)) + 'C:R' + alltrim(str(nom2)) + 'C)' 
					
					loExcel.range(loExcel.cells(nnom,7),loExcel.cells(nnom,10)).font.italic = .t.
					loExcel.range(loExcel.cells(nnom,7),loExcel.cells(nnom,10)).font.bold = .t.
					loExcel.range(loExcel.cells(nnom,7),loExcel.cells(nnom,10)).horizontalalignment = -4152
					loExcel.range(loExcel.cells(nnom,7),loExcel.cells(nnom,10)).NumberFormat = '0.00'						
					
					formul7 = formul7 + 'R' + alltrim(str(nnom)) + 'C7+'
					formul10 = formul10 + 'R' + alltrim(str(nnom)) + 'C10+' 
					
					nnom = nnom + 1
				endif			
			
				* вывод подзаголовков
				if inlist(cc_kodm.du,1,5)
					loExcel.cells(nnom,2).value = 'Основные и вспомогательные материалы'
				endif	
			
				if inlist(cc_kodm.du,4)
					loExcel.cells(nnom,2).value = 'Комплектующие материалы'
				endif	
			
				nnom = nnom + 1
				curdu = cc_kodm.du
				nom1 = nnom
			endif
		
			local mei,mei0,mei1,mkol
			mcena = get_mater_cena(cc_kodm.kodm)
			most = get_ostatok(cc_kodm.kodm)
			
			if cc_kodm.v1000 > 0
				mkol = (cc_kodm.skol / 1000) * cc_kodm.v1000
				mei = get_mater_ei1(cc_kodm.kodm) 				
			else
				mkol = cc_kodm.skol
				mei = get_mater_ei(cc_kodm.kodm)
			endif
			
*!*				if alltrim(mei0) == alltrim(mei1)
*!*					mkol = cc_kodm.skol
*!*				else
*!*				
*!*					mkol = 
*!*				endif
		
			loExcel.cells(nnom,1).value = cc_kodm.kodm
			loExcel.cells(nnom,2).value = get_nsk_by_kodm(cc_kodm.kodm)
			loExcel.cells(nnom,3).value = cc_kodm.mnaim  &&get_mater(cc_kodm.kodm)
			loExcel.cells(nnom,4).value = mei
			loExcel.cells(nnom,5).value = mkol
			loExcel.cells(nnom,6).value = mcena
			
			* loExcel.cells(nnom,7).value = mkol * mcena
			* insert formula instead of current
			loExcel.Range(loExcel.Cells(nnom,7),loExcel.Cells(nnom,7)).Select
			loExcel.ActiveCell.FormulaR1C1 = "=RC[-1]*RC[-2]"
			loExcel.Selection.NumberFormat = "0.00"	
			
			loExcel.cells(nnom,8).value = most
			loExcel.cells(nnom,9).value = iif(most < mkol,mkol - most,0)

			* loExcel.cells(nnom,10).value = (mkol - most) * mcena
			* insert formula instead of current
			loExcel.Range(loExcel.Cells(nnom,10),loExcel.Cells(nnom,10)).Select
			loExcel.ActiveCell.FormulaR1C1 = "=(RC[-5]-RC[-2])*RC[-4]"
			loExcel.Selection.NumberFormat = "0.00"		
			
			** formats
			*loExcel.range(loExcel.cells(nnom,1),loExcel.cells(nnom,10)).HorizontalAlignment = -4108
			loExcel.range(loExcel.cells(nnom,1),loExcel.cells(nnom,10)).Borders(8).LineStyle = 1
			loExcel.range(loExcel.cells(nnom,1),loExcel.cells(nnom,10)).Borders(10).LineStyle = 1
			loExcel.range(loExcel.cells(nnom,1),loExcel.cells(nnom,10)).Borders(7).LineStyle = 1
			loExcel.range(loExcel.cells(nnom,1),loExcel.cells(nnom,10)).Borders(9).LineStyle = 1
			loExcel.range(loExcel.cells(nnom,1),loExcel.cells(nnom,10)).Borders(11).LineStyle = 1
			
			loExcel.range(loExcel.cells(nnom,1),loExcel.cells(nnom,10)).VerticalAlignment = -4160
			
			loExcel.range(loExcel.cells(nnom,4),loExcel.cells(nnom,4)).HorizontalAlignment = -4108
			
			loExcel.range(loExcel.cells(nnom,3),loExcel.cells(nnom,3)).WrapText = .t.
			loExcel.range(loExcel.cells(nnom,3),loExcel.cells(nnom,3)).Font.Italic = .t.		
			loExcel.range(loExcel.cells(nnom,6),loExcel.cells(nnom,7)).Font.Italic = .t.		
			loExcel.range(loExcel.cells(nnom,6),loExcel.cells(nnom,7)).NumberFormat = '0.00000'
			loExcel.range(loExcel.cells(nnom,10),loExcel.cells(nnom,10)).Font.Italic = .t.		
			loExcel.range(loExcel.cells(nnom,10),loExcel.cells(nnom,10)).NumberFormat = '0.00'
				
			nnom=nnom+1
		endscan
		use in cc_kodm
	endif
	
	* завершающие подзаголовки
	nom2 = nnom-1
	
	loExcel.cells(nnom,7).FormulaR1C1 = '=SUM(R' + alltrim(str(nom1)) + 'C:R' + alltrim(str(nom2)) + 'C)' 
	loExcel.cells(nnom,10).FormulaR1C1 = '=SUM(R' + alltrim(str(nom1)) + 'C:R' + alltrim(str(nom2)) + 'C)' 
	
	loExcel.range(loExcel.cells(nnom,7),loExcel.cells(nnom,10)).font.italic = .t.
	loExcel.range(loExcel.cells(nnom,7),loExcel.cells(nnom,10)).font.bold = .t.
	loExcel.range(loExcel.cells(nnom,7),loExcel.cells(nnom,10)).horizontalalignment = -4152
	loExcel.range(loExcel.cells(nnom,7),loExcel.cells(nnom,10)).NumberFormat = '0.00'	
	
	formul7 = formul7 + 'R' + alltrim(str(nnom)) + 'C7'
	formul10 = formul10 + 'R' + alltrim(str(nnom)) + 'C10' 
					
	* итоги
	nnom = nnom + 2
	nom2 = nnom-1
	
	loExcel.cells(nnom,7).FormulaR1C1 = formul7 
	loExcel.cells(nnom,10).FormulaR1C1 = formul10
	
	loExcel.range(loExcel.cells(nnom,7),loExcel.cells(nnom,10)).font.italic = .t.
	loExcel.range(loExcel.cells(nnom,7),loExcel.cells(nnom,10)).font.bold = .t.
	loExcel.range(loExcel.cells(nnom,7),loExcel.cells(nnom,10)).horizontalalignment = -4152
	loExcel.range(loExcel.cells(nnom,7),loExcel.cells(nnom,10)).NumberFormat = '0.00'	

	loExcel.Visible = .t.

	sqldisconnect(hh)
else
	eodbc('form_imit conn')
endif