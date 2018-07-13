lparameters parSklad,parBeg,parEnd,parNsk

* готовим excel
local loExcel
wait window nowait 'Excel открывается...'
loExcel = createobject('Excel.Application')
loExcel.Workbooks.Add()
loExcel.Workbooks.Open(sys(5)+sys(2003)+'\limit04.xls')
loExcel.DisplayAlerts = .f.

* заголовок
loExcel.Cells(3,2).value = 'Склад:  '+get_dosp2(parSklad)
loExcel.Cells(4,2).value = 'период с '+dtoc(parBeg)+' по '+dtoc(parEnd)
loExcel.Cells(5,2).value = iif(parNsk = -1,'по всем материалам','по карточке №'+get_mater_by_nsk(parNsk))

* подготовить переменные
local npp,nsk,naimmat,cena,ed,prihod,rashod,voztech,vozvtor,ost,stroka
local lnKodm
store '' to npp,nsk,naimmat,cena,ed,prihod,rashod,voztech,vozvtor,ost



* создать курсор
create cursor cout (;
		npp		n(8),;
		nsk		n(8),;
		naimmat c(68),;
		cena	n(10,2),;
		ed		c(10),;
		prihod	n(12,3),;
		rashod	n(12,3),;
		voztech	n(12,3),;
		vozvtor n(12,3),;
		ost		n(12,3);
	)
	
* подготовить вспомогательный курсор	
select 0
create cursor cpom (;
		kol			n(12,3),;
		dat			d,;
		nsk			n(8),;
		sklad_id	n(8);
		)
	
* заполняем курсор	
local lcProgress,lnNsk
lcProgress = ''
npp = 1
if parNsk = -1
    wait window nowait 'Выбираем материалы'
    select dist kodm,get_mater(kodm) as naim from v_matras_o ;
        where ;
        between(dat,parBeg,parEnd) and;
        nsk <> 0 and ;
        sklad_id = parSklad;
        order by naim ;
        into cursor c100
    * заполнить cpom
    wait window nowait 'Собираем вспомогательные данные' 
	select * from v_matras_o ;
		where ;
		between(dat,parBeg,parEnd) and;
		nsk <> 0 and ;
		sklad_id = parSklad;   
		into cursor c115
	scan all
		insert into cpom ;
			(kol,dat,nsk);
			values;
			(c115.kol,c115.dat,c115.nsk)
	endscan	
	use in c115	
else
    wait window nowait 'Выбираем материалы'
    select dist kodm,get_mater(kodm) as naim from v_matras_o ;
        where ;
        between(dat,parBeg,parEnd) and;
        sklad_id = parSklad and;
        nsk = parNsk ;
        order by naim ;
        into cursor c100
    * заполнить cpom
    wait window nowait 'Собираем вспомогательные данные' 
	select * from v_matras_o ;
		where ;
		between(dat,parBeg,parEnd) and;
		nsk <> 0 and ;
		nsk = parNsk and ;
		sklad_id = parSklad;   
		into cursor c115
	scan all
		insert into cpom ;
			(kol,dat,nsk);
			values;
			(c115.kol,c115.dat,c115.nsk)
	endscan	
	use in c115	
endif

select c100
scan all
	
	lcProgress = str(100*recno()/reccount())+'%'
	wait window nowait 'Выполнено '+lcProgress
	store 0 to prihod,rashod,voztech,vozvtor,ost
	
	lnNsk = get_nsk_by_kodm(c100.kodm)
	* prihod
	if lnNsk <> 0
	    wait window nowait 'Вычисляем приход '+lcProgress
	    select sum(kol) as sumkol ;
	        from ostatok ;
	        where ;
	        sklad_id 	= parSklad and ;
	        nsk			= lnNsk and ;
	        between(dat,parBeg,parEnd) ;
	        into cursor c200
	    if reccount()>0
	        prihod = c200.sumkol
	    else
	        prihod = 0
	    endif
	    use in c200
	else
	    prihod = 0
	endif
	
	* rashod
	wait window nowait 'Вычисляем расход '+lcProgress 
	select sum(kol) as sumkol ;
		from cpom;
		where;
		between(dat,parBeg,parEnd) and;
		nsk = lnNsk ;
		into cursor c120
	if reccount()>0
		rashod = c120.sumkol
	else
		rashod = 0
	endif	
	use in c120	
	
	* voztech
	wait window nowait 'Технологические отходы '+lcProgress 
	select sum(ra*rb) as sumplo from ostatki;
		where;
		between(dat_o,parBeg,parEnd) and;
		nsk = lnNsk and;
		pri = 2;
		into cursor c120
	if reccount()>0		
		voztech = c120.sumplo*get_mater_tm(c100.kodm)*get_mater_uv(c100.kodm)/1000000
	else
		voztech = 0
	endif	
	use in c120	
	
	* vozvtor
	wait window nowait 'Вторсырье '+lcProgress 
	select sum(ra*rb) as sumplo from ostatki;
		where;
		between(dat_o,parBeg,parEnd) and;
		nsk = lnNsk and;
		pri > 2;
		into cursor c120
	if reccount()>0
		vozvtor = c120.sumplo*get_mater_tm(c100.kodm)*get_mater_uv(c100.kodm)/1000000
	else
		vozctor = 0
	endif	
	use in c120	
				
	
	insert into cout ;
		(npp,nsk,naimmat,;
		cena,ed,;
		prihod,rashod,voztech,vozvtor,ost);
		values;
		(m.npp,get_nsk_by_kodm(c100.kodm),get_mater(c100.kodm),;
		get_cena_from_ostatok(c100.kodm),get_mater_ei(c100.kodm),;
		prihod,rashod,voztech,vozvtor,ost)
	npp = npp+1	
endscan 	
use in c100
		
	
* выводим курсор	
stroka = 8
select cout
scan all
	wait window nowait 'Вывод данных '+str(100*recno()/reccount())+'%' 
	loExcel.Cells(stroka,1).value = cout.npp
	loExcel.Cells(stroka,2).value = cout.nsk
	loExcel.Cells(stroka,3).value = cout.naimmat
	loExcel.Cells(stroka,4).value = cout.cena
	loExcel.Cells(stroka,5).value = alltrim(cout.ed)
	loExcel.Cells(stroka,6).value = cout.prihod
	loExcel.Cells(stroka,7).value = cout.rashod
	loExcel.Cells(stroka,8).value = cout.voztech
	loExcel.Cells(stroka,9).value = cout.vozvtor
	loExcel.Cells(stroka,10).value = cout.ost
	
	* formats
	loExcel.Range(loExcel.Cells(stroka,1),loExcel.Cells(stroka,10)).Select
	loExcel.Selection.Borders(9).LineStyle = 1 
	loExcel.Selection.Borders(7).LineStyle = 1 
	loExcel.Selection.Borders(10).LineStyle = 1 
	loExcel.Selection.Borders(8).LineStyle = 1 
	loExcel.Selection.Borders(11).LineStyle = 1 
	loExcel.Selection.VerticalAlignment = -4160
	
	loExcel.Range(loExcel.Cells(stroka,3),loExcel.Cells(stroka,3)).Select
	loExcel.Selection.WrapText = .t.
	
	loExcel.Range(loExcel.Cells(stroka,2),loExcel.Cells(stroka,2)).Select
	loExcel.Selection.Font.Bold = .t.
	loExcel.Selection.HorizontalAlignment = -4108
	
	loExcel.Range(loExcel.Cells(stroka,4),loExcel.Cells(stroka,4)).Select
	loExcel.Selection.NumberFormat = "0.00"
	
	loExcel.Range(loExcel.Cells(stroka,5),loExcel.Cells(stroka,5)).Select
	loExcel.Selection.HorizontalAlignment = -4108
	
	loExcel.Range(loExcel.Cells(stroka,6),loExcel.Cells(stroka,10)).Select
	loExcel.Selection.NumberFormat = "0.000"
	
	stroka = stroka + 1
endscan
use in cout
* показать 
loExcel.visible = .t.
wait window nowait 'Отчет готов'