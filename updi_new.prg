* новый вариант ведомости вхождени€

local cRibf, ikoli,m.kodm
do form f_izd_vib to m.cRibf

if empty(m.cRibf)
	return
endif

* готовим Excel
local loExcel,lnRow,npp,ikoli
wait window nowait 'Excel открываетс€...'
loExcel = createobject("Excel.Application")
* свойства €чеек
with loExcel
	.Workbooks.Add()
	.Workbooks.Open(sys(5)+sys(2003)+'\UPDI.XLS')
	.DisplayAlerts = .F.
	with .Range('A2:F2')
		.Value = allt(m.naim)+' '+m.ribf
    	.Merge
	endwith
	m.lnRow = 6
	m.npp = 0
	m.ikoli = 0
	
	* выводим комплектующие
    select dist kodm from kt ;
    	where ;
    		alltrim(pozn) == alltrim(m.cRibf) ;
    		and kol > 0 ;
    		and empty(poznd) ;
    		and kodm <> 0 ;
    	order by kodm ;
    	into cursor c_kt
    .cells(m.lnRow,2).value = ' ќћѕЋ≈ “”ёў»≈' 	
    .cells(m.lnRow,2).font.italic = .t.
    .cells(m.lnRow,2).font.underline = .t.
    scan all
    	select * from kt ;
    		where ;
    			alltrim(pozn) == alltrim(m.cRibf) ;
    			and kodm = c_kt.kodm ;
    			and empty(poznd) ;
    			and d_u = 1 ;
		order by kodm ;
		into cursor c_kodm
	scan all
		* выводим записи
				

	endscan	    
	* выводим итоги
	if reccount()>0
		* выводим »“ќ√ќ

	else
		* выводим просто пустую тонкую строчку

	endif	
    endscan	
    use in c_kt	
	
	* выводим обычные

*!*		***	
*!*		* выбираем список poznd 
*!*		select dist poznd from kt ;
*!*			where alltrim(pozn) == alltrim(m.cRibf) and kol > 0 ;
*!*			order by poznd into cursor c_poznd
*!*		scan all
*!*			wait window nowait "¬нос€тс€ данные: запись " +;
*!*				alltrim(str(recno())) + " из " + alltrim(str(recc())) 
*!*			if !empty(c_poznd.poznd)	
*!*				select * from kt where poznd == c_poznd.poznd and kol > 0 ;
*!*					order by poznd into cursor c_res
*!*			else
*!*				select * from kt ;
*!*					where pozn = m.cRibf and kol > 0 and poznd == c_poznd.poznd ;
*!*					order by kodm into cursor c_res
*!*			endif		
*!*			scan all
*!*				m.npp = m.npp+1
*!*				* пишем строки
*!*				* npp
*!*				with .Cells(m.lnRow,1)
*!*					.Value = alltrim(str(m.npp))
*!*					.ColumnWidth = 5
*!*				endwith			
*!*				* poznd
*!*				if empty(с_poznd.poznd)
*!*					.Cells(lnRow,2).Value = get_mater(m.kodm)		
*!*				else
*!*					.Cells(lnRow, 2).Value =  allt(m.poznd) +' '+allt(m.naimd) 
*!*				endif
*!*				
*!*			endscan	
*!*			if reccount()>0
*!*			
*!*			endif
*!*			use in c_res	
*!*				
*!*			
*!*			
*!*			
*!*		
*!*		endscan	
*!*		use in c_poznd	
*!*		
endwith

loExcel.Visible = .t.
wait window timeout 0.5 "ќтчет готов"
loExcel.Visible = .t.
loExcel.ActiveWindow.SelectedSheets.PrintPreview
release loExcel