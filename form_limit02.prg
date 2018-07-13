lparameters parBeg,parEnd,parNsk

* готовим excel
local loExcel
wait window nowait 'Excel открывается...'
loExcel = createobject('Excel.Application')
loExcel.Workbooks.Add()
loExcel.Workbooks.Open(sys(5)+sys(2003)+'\limit02.xls')
loExcel.DisplayAlerts = .f.

local stroka
local npp,nkart,nlzk,naimmat,od,normat,normap,razn,vozt,vozp
store '' to npp,nkart,nlzk,naimmat,od,normat,normap,razn,vozt,vozp

* заголовок
loExcel.Cells(4,2).value = 'период с '+dtoc(parBeg)+' по '+dtoc(parEnd)
if parNsk = -1
	loExcel.Cells(5,2).value = 'по всем материалам'
else
	loExcel.Cells(5,2).value = 'по материалу № карт. '+alltrim(str(parNsk))+' '+;
		get_mater_by_nsk(parNsk)
endif	
*****
stroka = 8
npp = 1
wait window nowait 'Выборка из ЛЗК' 
if parNsk = -1
    select dist nsk from v_matras_o order by kodm ;
        where between(dat,parBeg,parEnd) and !empty(shwz);
        into cursor c100
else
    select dist nsk from v_matras_o order by kodm ;
        where between(dat,parBeg,parEnd) and !empty(shwz);
        	and nsk = parNsk;
        into cursor c100
endif
*****	
local sum1,sum2
store 0 to sum1,sum2
scan all
	*
	wait window nowait 'Выбрано '+str(100*recno()/reccount())+'%' 
	*
	select * from v_matras_o ;
		where ;
			nsk = c100.nsk and ;
			between(dat,parBeg,parEnd) and ;
			!empty(shwz);
		into cursor c200
	* nkart
	nkart = c200.nsk
	* nlzk
	nlzk = c200.doc
	* naimmat
	naimmat = c200.mat_im
	* od
	od = get_mater_ei(c200.kodm)
	* normat
	normat = get_etalon_by_shwz_kodm(c200.shwz,c200.kodm)
	* normap
	normap = c200.kol
	* normap+
	local a[1]
	a[1] = 0
	select sum(ra*rb) as aaa from ostatki ;
		where nsk = c200.nsk and pri = 2 ;
			and between(dat_o,parBeg,parEnd) ;
		into array a
	normap = normap + a[1]*get_mater_uv(c200.kodm)*get_mater_tm(c200.kodm)/1000000
	* razn
	razn = normat - normap
	* vozt
	vozt = a[1]*get_mater_uv(c200.kodm)*get_mater_tm(c200.kodm)/1000000
	* vozp
	local a[1]
	select sum(ra*rb) from ostatki ;
		where nsk = c200.nsk and pri > 2 ;
			and between(dat_o,parBeg,parEnd) ;
		into array a
	vozp = a[1]*get_mater_uv(c200.kodm)*get_mater_tm(c200.kodm)/1000000
	use in c200
	* npp,nkart,nlzk,naimmat,od,normat,normap,razn,vozt,vozp
	* out	
	loExcel.Cells(stroka,1).value = npp
	loExcel.Cells(stroka,2).value = nkart
	loExcel.Cells(stroka,3).value = nlzk
	loExcel.Cells(stroka,4).value = naimmat
	loExcel.Cells(stroka,5).value = od
	loExcel.Cells(stroka,6).value = normat
	loExcel.Cells(stroka,7).value = normap
	loExcel.Cells(stroka,8).value = razn
	loExcel.Cells(stroka,9).value = vozt
	loExcel.Cells(stroka,10).value = vozp
	* sum
	sum1 = sum1 + normat
	sum2 = sum2 + normap
	* set formats
	loExcel.Range(loExcel.Cells(stroka,1),loExcel.Cells(stroka,10)).Select
	loExcel.Selection.Borders(9).LineStyle = 1 
	loExcel.Selection.Borders(7).LineStyle = 1 
	loExcel.Selection.Borders(10).LineStyle = 1 
	loExcel.Selection.Borders(8).LineStyle = 1 
	loExcel.Selection.Borders(11).LineStyle = 1 
	loExcel.Selection.VerticalAlignment = -4160
	
	loExcel.Range(loExcel.Cells(stroka,4),loExcel.Cells(stroka,4)).Select
	loExcel.Selection.WrapText = .t.	
	* next
	npp = npp+1
	stroka = stroka+1
endscan	

* itog
loExcel.Cells(stroka,6).value = sum1
loExcel.Cells(stroka,7).value = sum2
loExcel.Range(loExcel.Cells(stroka,6),loExcel.Cells(stroka,7)).Select
loExcel.Selection.Font.Bold = .t.

use in c100	


loExcel.visible = .t.
wait window nowait 'Отчет готов'
 