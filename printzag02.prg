* формирование отчета по заготовкам после порезки
* упорядочено по nlista-nost
* принимает параметры
* если parMod = 0 - выбираются все материалы
* если parMod = 1 - выбирается только указанный материал
* если parMod = 2 - выбирается только указанный лист 

lparameters parMod,parKodm,parNlista

* if no params
if parameters()=0
	parMod = 0
endif

* mode choice 
do	case
	case	parMod = 0
		select * from raschet;
			order by nlista,nost;
			into cursor cp 
	case	parMod = 1
		select * from raschet;
			where kod = parKodm;
			order by nlista,nost;
			into cursor cp	
	case	parMod = 2
		select * from raschet;
			where nlista = parNlista;
			order by nlista,nost;
			into cursor cp	
	otherwise 
		wait window 'printzag02: Неправильный параметр!' 
		return
endcase 
if reccount()>0
	local npp,ns,zag,otp
	* подготовить excel-документ
		wait window nowait 'Подготовка excel-документа' 
		local loExcel
		loExcel = createobject('Excel.Application')
		loExcel.Workbooks.Add()
		loExcel.Workbooks.Open(sys(5)+sys(2003)+'\rez2.xls')
		loExcel.DisplayAlerts = .f.	
	* caption
	* zag
	do	case
		case	parMod=0
			zag = 'По всем материалам'
		case	parMod=1
			zag = 'По материалу '+alltrim(str(parKodm))+' '+get_mater(parKodm)
		case	parMod=2
			zag = 'По номеру листа: лист №'+alltrim(str(parNlista))		
	endcase 
	* otp
	otp = 'Сформировано '+ttoc(datetime())
	* output
	loExcel.cells(1,2).value = otp
	loExcel.cells(3,2).value = zag	
	* scan
	npp = 1
	ns = 7
	
	brow
	
	scan all
		* message
		local mmm
		mmm = 'Выполнено '+alltrim(str(100*recno('cp')/reccount('cp')))+'%'
		wait window nowait mmm 
		* PREP VARS
		local nlis,nos,mater,izd,kornd,poznd,naimd,ra,rb,plan,fact
		* form vars
		nlis = cp.nlista
		nos = cp.nost	
		mater = '('+alltrim(str(cp.kod))+') '+get_mater(cp.kod)
		izd = get_izd_ribf_by_shwz(cp.shwz)+' // '+;
			  get_izd_im_by_shwz(cp.shwz)+' // '+;
			  alltrim(cp.shwz)
		kornd = cp.kornd	  	 
		poznd = get_poznd_by_kornd_and_shwz(cp.kornd,cp.shwz)
		naimd = get_naimd_by_kornd_and_shwz(cp.kornd,cp.shwz)
		ra = cp.rozma
		rb = cp.rozmb
		plan = cp.progr
		fact = cp.koli
		* OUTPUT TO FILE
		* npp
		loExcel.cells(ns,1).value = npp
		loExcel.cells(ns,1).select
		loExcel.selection.font.bold = .t.
		loExcel.selection.HorizontalAlignment = -4108
		* merge nlis nos
		loExcel.Range(loExcel.Cells(ns,2),loExcel.Cells(ns+1,2)).Select
		loExcel.Selection.Merge
		loExcel.Selection.NumberFormat = '@'
		loExcel.selection.HorizontalAlignment = -4108
		* nlis & nos
		loExcel.cells(ns,2).value = alltrim(str(nlis))+'/'+alltrim(str(nos))
		* edge nlis+nost
		loExcel.Range(loExcel.Cells(ns,2),loExcel.Cells(ns+1,2)).Select
		loExcel.Selection.Borders(7).LineStyle = 1
		loExcel.Selection.Borders(7).Weight = 1
		loExcel.Selection.Borders(10).LineStyle = 1
		loExcel.Selection.Borders(10).Weight = 1
		* mater
		loExcel.cells(ns,3).value = mater
		loExcel.cells(ns,3).select
		loExcel.selection.font.name = 'Arial Narrow'		
		* izd
		loExcel.cells(ns+1,3).value = izd		
		loExcel.cells(ns+1,3).select
		loExcel.selection.font.name = 'Arial Narrow'		
		* kornd
		loExcel.cells(ns,4).NumberFormat = '@'
		loExcel.cells(ns,4).value = alltrim(kornd)
		loExcel.cells(ns,4).select
		loExcel.selection.font.bold = .t.
		loExcel.selection.HorizontalAlignment = -4108
		* poznd
		loExcel.cells(ns,5).value = poznd
		* naimd
		loExcel.cells(ns+1,5).value = naimd
		* ra
		loExcel.cells(ns,6).value = ra
		* left edge
		loExcel.Range(loExcel.Cells(ns,6),loExcel.Cells(ns+1,6)).Select
		loExcel.Selection.Borders(7).LineStyle = 1
		loExcel.Selection.Borders(7).Weight = 1
		* rb
		loExcel.cells(ns,7).value = rb
		* right edge
		loExcel.Range(loExcel.Cells(ns,7),loExcel.Cells(ns+1,7)).Select
		loExcel.Selection.Borders(10).LineStyle = 1
		loExcel.Selection.Borders(10).Weight = 1
		* plan
		loExcel.cells(ns,8).value = plan
		loExcel.cells(ns,8).select
		loExcel.selection.HorizontalAlignment = -4108
		* fact
		loExcel.cells(ns,9).value = fact
		loExcel.cells(ns,9).select
		loExcel.selection.HorizontalAlignment = -4108
		* ves plan
		local ves
		ves = plan * ra * rb * get_mater_tm(cp.kod) * get_mater_uv(cp.kod) /1000000
		loExcel.cells(ns+1,8).value = ves
		loExcel.cells(ns+1,8).select
		loExcel.selection.HorizontalAlignment = -4108
		* ves fact
		local ves
		ves = fact * ra * rb * get_mater_tm(cp.kod) * get_mater_uv(cp.kod) /1000000
		loExcel.cells(ns+1,9).value = ves
		loExcel.cells(ns+1,9).select
		loExcel.selection.HorizontalAlignment = -4108
		* bottom line
		loExcel.Range(loExcel.Cells(ns+1,1),loExcel.Cells(ns+1,9)).Select
		loExcel.Selection.Borders(9).LineStyle = 1
		loExcel.Selection.Borders(9).Weight = 2
		* NEXT ITER
		npp = npp+1
		ns = ns+2
	endscan 
	
	ns = ns+2
	npp = 1
	* выводим итоги ниже отчета
	* =================================================
	wait window nowait 'Вычисление итогов...' 
	* новая страница
	loExcel.ActiveWindow.SelectedSheets.HPageBreaks.Add(loExcel.Range(loExcel.cells(ns,1),loExcel.cells(ns,1)))	
	* формируем выборку
	select kod,;
		sum(progr) as sss,;
		sum(progr) ;
			as sprogr,;
		sum(koli*ra*rb*get_mater_tm(kod)*get_mater_uv(kod)/1000000) ;
			as skoli ;
		from cp;
		order by kod;
		group by kod;
		into cursor ccp
	
	brow	
		
	if reccount()>0	
		* заголовок
		loExcel.cells(ns,1).value = 'ИТОГО ПО МАТЕРИАЛАМ'
		loExcel.cells(ns,1).select
		loExcel.selection.Font.Bold = .t.
		loExcel.selection.Font.underline = 2
		loExcel.selection.WrapText = .f.
		* заголовки колонок
		ns = ns+1
		loExcel.range(loExcel.cells(ns,3),loExcel.cells(ns,5)).select
		loExcel.selection.merge
		
		loExcel.cells(ns,1).value = '№№'
		loExcel.cells(ns,2).value = 'Код'
		loExcel.cells(ns,3).value = 'Наименование материала'
		loExcel.cells(ns,6).value = 'План (кг)'
		loExcel.cells(ns,7).value = 'Факт (кг)'
		
		loExcel.range(loExcel.cells(ns,1),loExcel.cells(ns,7)).select
		loExcel.selection.font.bold = .t.
		loExcel.selection.HorizontalAlignment = -4108
		* перебираем строки
		ns = ns + 1
		scan all
			loExcel.range(loExcel.cells(ns,3),loExcel.cells(ns,5)).select
			loExcel.selection.merge
			* номер строки
			loExcel.cells(ns,1).value = npp
			* код материала
			loExcel.cells(ns,2).value = ccp.kod
			* наименование материала
			loExcel.cells(ns,3).value = get_mater(ccp.kod)
			* количество план
			loExcel.cells(ns,6).value = alltrim(str(ccp.sprogr*ra*rb*get_mater_tm(kod)*get_mater_uv(kod)/1000000))
			* количество факт
			loExcel.cells(ns,7).value = alltrim(str(ccp.skoli))
			* форматы
			loExcel.range(loExcel.cells(ns,1),loExcel.cells(ns,2)).select
			loExcel.selection.HorizontalAlignment = -4108
			loExcel.range(loExcel.cells(ns,6),loExcel.cells(ns,7)).select
			loExcel.selection.HorizontalAlignment = -4108
			* след строка
			npp = npp+1
			ns = ns+1
		endscan
	endif
	use in ccp
	
	* open doc
	wait wind nowait 'Открытие excel-документа'
	loExcel.Visible = .t.
	wait window nowait 'Отчет готов'	
endif
use in cp




