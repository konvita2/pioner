* Формирование сводной ведомости начислений
lparameters parMar, parBeg, parEnd

* подготовить курсор
create cursor cur_doc(;
	tabn	n(4),  ;
	fio 	c(30), ;
	imizd	c(70), ;
	ribf	c(30), ;
	shwz	c(18), ;
	partz	c(100),;
	trud	n(6,2),;
	summi	n(6,2) ;
	)

* заполнить курсор
* выбрать сотрудников
local hh,rr
hh = sqlcn()
if hh > 0
	rr = sqlexec(hh,"select distinct kadry.* from kadry inner join nar on kadry.tn=nar.tabn "+;
					"where nar.data_b between ?parBeg and ?parEnd",'kadryk')
	if rr = -1
		eodbc('fr_skritp_sql sele kadry')
	endif
	
*!*		rr = sqlexec(hh,"select * from nar where nar.data_b between ?parBeg and ?parEnd",'nark')
*!*		if rr = -1
*!*			eodbc('fr_skritp_sql sele nar')
*!*		endif
	sqldisconnect(hh)
else
	eodbc('fr_skritp_sql conn')
endif
release hh,rr

if m.parMar >= 0
	select fio,tn from kadryk ;
		where podr = m.parMar ;
		order by fio,tn ;
		into cursor cur_kadry
else
	select fio,tn from kadryk ;
		order by fio,tn ;
		into cursor cur_kadry
endif

* перебираем строки
local svTn
m.svTn = -1

local tabn,fio,imizd,ribf,shwz,partz,trud,summi

hh = sqlcn()
if hh > 0	
	scan all
		***select cur_kadry	
		
* выбираем строки по сотруднику за период
*!*			select * from nark ;
*!*				where ;
*!*				tabn = cur_kadry.tn and ;
*!*				between(data_b,parBeg,parEnd) and ;
*!*				regim <> 4 and regim <> 5 and regim <> 6 ;
*!*				order by shwz ;
*!*				into cursor cur_nar

		sq = 'select * from nar where tabn = ?cur_kadry.tn and '+;
			'regim <> 4 and regim <> 5 and regim <> 6 '+;
			'and data_b between ?parBeg and ?parEnd '+;
			'order by shwz '	
		wait window nowait 'Выборка ' + cur_kadry.fio 	
		rr = sqlexec(hh,sq,'cur_nar')
		if rr = -1
			eodbc('sele6')
		endif	

		scan all
		
			***waitproc(recno(),reccount(),'Выбор ' + cur_kadry.fio)
			wait window nowait 'Выбор ' + cur_kadry.fio + ' ' + str(recno()) + ' из ' + str(reccount()) 
			
			tabn = 0
			fio = ''
			imizd = ''
			ribf = ''
			shwz = ''
			partz = ''
			trud = 0
			summi = 0
		
			tabn = cur_kadry.tn
			fio = cur_kadry.fio
			shwz = cur_nar.shwz
			
			
			rr = sqlexec(hh,'select * from izd where shwz=?cur_nar.shwz','ccs')
			if rr = -1
				eodbc('sele7')
			else
				imizd = ccs.im
				ribf = ccs.ribf
				partz = str(ccs.partz1,4) + ' - ' + str(ccs.partz2,4) 	
				trud = cur_nar.kzp * cur_nar.normww/60 * cur_nar.procgot/100
				summi = cur_nar.kzp * cur_nar.rascenka * cur_nar.procgot/100
			endif
						
			insert into cur_doc from memvar	

		endscan
		use in cur_nar
	endscan
	use in cur_kadry

	sqldisconnect(hh)
else
	eodbc('sele5')
endif	

wait window nowait 'Группировка...' 
* группировать по shwz
select ;
	max(imizd) 	as mimizd, ;
	max(ribf)	as mribf, ;
	shwz, ;
	max(partz) 	as mpartz, ;
	sum(trud) as strud, ;
	sum(summi) as ssumm ;
	from cur_doc ;
	group by shwz ;
	into cursor c_doc

wait window nowait 'Excel...' 
* формировать Excel-документ
* готовим Excel-документ
local loExcel
loExcel = createobject('Excel.Application')
loExcel.Workbooks.add()
loExcel.Workbooks.open(sys(5)+sys(2003)+'\nachis.xls')
loExcel.DisplayAlerts = .f.

* выводим заголовок
if m.parMar <> -1
	loExcel.Cells(6,2).NumberFormat = '@'
	loExcel.Cells(6,2).value = get_dosp2(m.parMar)
else
	loExcel.Cells(6,2).NumberFormat = '@'
	loExcel.Cells(6,2).value = 'по предприятию'
endif

loExcel.Cells(7,2).NumberFormat = '@'
loExcel.Cells(7,2).value = ;
	'по заказам за период с '+dtoc(m.parBeg)+' по '+dtoc(m.parEnd)

* выводим строки
local lnRow
m.lnRow = 11
local lnItogTrud, lnItogSumm
m.lnItogTrud = 0
m.lnItogSumm = 0
select c_doc
scan all
	* ribf
	loExcel.Cells(m.lnRow,1).VerticalAlignment = -4160
	loExcel.Cells(m.lnRow,1).NumberFormat = '@'
	loExcel.Cells(m.lnRow,1).value = c_doc.mribf
	* imizd
	loExcel.Cells(m.lnRow,2).VerticalAlignment = -4160
	loExcel.Cells(m.lnRow,2).NumberFormat = '@'
	loExcel.Cells(m.lnRow,2).value = c_doc.mimizd
	* shwz
	loExcel.Cells(m.lnRow,3).VerticalAlignment = -4160
	loExcel.Cells(m.lnRow,3).NumberFormat = '@'
	loExcel.Cells(m.lnRow,3).value = c_doc.shwz
	* mpartz
	loExcel.Cells(m.lnRow,4).VerticalAlignment = -4160
	loExcel.Cells(m.lnRow,4).NumberFormat = '@'
	loExcel.Cells(m.lnRow,4).WrapText = .t.
	loExcel.Cells(m.lnRow,4).value = c_doc.mpartz
	* trud
	loExcel.Cells(m.lnRow,5).VerticalAlignment = -4160
	loExcel.Cells(m.lnRow,5).NumberFormat = '0.00'
	loExcel.Cells(m.lnRow,5).value = c_doc.strud
	m.lnItogTrud = m.lnItogTrud+c_doc.strud
	* summ
	loExcel.Cells(m.lnRow,6).VerticalAlignment = -4160
	loExcel.Cells(m.lnRow,6).NumberFormat = '0.00'
	loExcel.Cells(m.lnRow,6).value = c_doc.ssumm
	m.lnItogSumm = m.lnItogSumm+c_doc.ssumm
	* increment
	m.lnRow = m.lnRow+1
endscan

* итоги
local ln1
* полоска
for m.ln1 = 1 to 6
	loExcel.Cells(m.lnRow,m.ln1).borders(8).LineStyle = 1
	loExcel.Cells(m.lnRow,m.ln1).borders(8).Weight = 2
	loExcel.Cells(m.lnRow,m.ln1).font.Bold = .t.
endfor
* итоги непосредственно
loExcel.Cells(m.lnRow,4).NumberFormat = '@'
loExcel.Cells(m.lnRow,4).HorizontalAlignment= -4152
loExcel.Cells(m.lnRow,4).value = 'ИТОГО'

loExcel.Cells(m.lnRow,5).NumberFormat = '0.00'
loExcel.Cells(m.lnRow,5).HorizontalAlignment= -4152
loExcel.Cells(m.lnRow,5).value = m.lnItogTrud

loExcel.Cells(m.lnRow,6).NumberFormat = '0.00'
loExcel.Cells(m.lnRow,6).HorizontalAlignment= -4152
loExcel.Cells(m.lnRow,6).value = m.lnItogSumm


loExcel.Cells(m.lnRow + 3,2).value = 'Директор ___________________ '

* открыть Excel-отчет
loExcel.visible = .t.
wait window nowait 'Отчет готов'
loExcel.ActiveWindow.SelectedSheets.PrintPreview

* закрыть курсор
select cur_doc
use in c_doc
use in cur_doc

return

*************************************************
*************************************************
function get_naimdet(parShwz,parKornd)
local lcRes
local svWA

m.svWA = select(0)

*!*		select * from kt,izd ;
*!*			where ;
*!*				kt.shw = izd.kod and ;
*!*				kt.kornd = m.parKornd and ;
*!*				alltrim(izd.shwz) = alltrim(m.parShwz) ;
*!*			into cursor cc_kt
hh = sqlconnect('sqldb','sa','111')
if hh > 0
	rr = sqlexec(hh,"select * from kt,izd where kt.shw = izd.kod and kt.kornd = ?m.parKornd and rtrim(izd.shwz) = rtrim(?m.parShwz)",'cc_kt')
	if rr = -1
		eodbc('fr_skritp_sql sele kadry')
	endif
	sqldisconnect(hh)
else
	eodbc('fr_skritp_sql conn')
endif
release hh,rr
if reccount()>0
	m.lcRes = cc_kt.naimd
else
	m.lcRes = ''
endif
use in cc_kt

select (svWA)

return m.lcRes
endfunc
*************************************************

*!*	function get_izd_im_by_shwz(parShwz,parKornd)
*!*	lparameters parshwz

*!*	local res
*!*	res = space(40)

*!*	if !empty(parshwz)
*!*		local hh
*!*		hh = sqlconnect('sqldb','sa','111')
*!*		if hh > 0
*!*			local rr
*!*			rr = sqlexec(hh,'select * from izd where rtrim(shwz) = rtrim(?parshwz)','c049')
*!*			if rr = -1
*!*				eodbc('get_izd_im_by_shwz sele')
*!*			else
*!*				select c049
*!*				if reccount()>0
*!*					res = c049.im
*!*				endif
*!*				use in c049
*!*			endif
*!*			sqldisconnect(hh)
*!*		else
*!*			eodbc('get_izd_im_by_shwz conn')
*!*		endif
*!*	endif

*!*	return alltrim(res)
*!*	endfunc



*!*	lparameters parShwz
*!*	local res,hh,rr

*!*	res = ''

*!*	if !empty(parShwz)
*!*		hh = sqlconnect('sqldb','sa','111')
*!*		if hh <> -1
*!*			rr = sqlexec(hh,'select * from izd where rtrim(shwz)=rtrim(?parShwz)','c088')
*!*			if rr = -1
*!*				eodbc('get_izd_ribf_by_shwz sele')
*!*			else
*!*				select c088
*!*				if reccount()>0
*!*					res = alltrim(c088.ribf)
*!*				endif
*!*				use in c088
*!*			endif
*!*			sqldisconnect(hh)
*!*		else
*!*			eodbc('get_izd_ribf_by_shwz conn')
*!*		endif
*!*	endif

*!*	return res
