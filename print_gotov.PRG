* печать готовых изделий в порядке убывания даты готовности
#define AGO 30  &&сколько дней от тек даты просматривать

local hh,rr,mday,md1,md2
mday = AGO
md2 = date()
md1 = md2 - mday
hh = sqlconnect('sqldb','sa','111')
if hh > 0 
	
	create cursor cc (dattd d,kod int,shwz c(20),ribf c(30),im c(80))
	rr = sqlexec(hh,"select * from izd where rtrim(shwz) <> '' and dat_td between ?md1 and ?md2 order by dat_td desc",'cdizd')
	if rr = -1
		eodbc('print_gotov sele')
	endif
	
	select cdizd
	scan all
		waitproc(recno(),reccount(),'Подготовка данных')				
		insert into cc (dattd,kod,shwz,ribf,im) values (cdizd.dat_td,cdizd.kod,cdizd.shwz,cdizd.ribf,cdizd.im)	
	endscan 	
	
	wait window nowait 'Запускаем Excel' 
	local ex as "excel.Application"
	ex = createobject('excel.Application')
	ex.Workbooks.Open(sys(5)+sys(2003)+'\dattd.xls')
	ex.DisplayAlerts = .F. 
	ex.Visible = .F. 
	
	* заголовок
	ex.Cells(3,2).Value = 'дата c ' + dtoc(md1) + ' по ' + dtoc(md2) 	
	
	* строки
	local nn
	nn = 5
	select cc
	scan all
		* formats
		ex.Range(ex.Cells(nn,1),ex.Cells(nn,5)).Select
		ex.Selection.verticalalignment = -4160
		ex.Selection.wraptext = .t.         
		ex.selection.borders(9).linestyle = 1
		ex.selection.borders(7).linestyle = 1
		ex.selection.borders(10).linestyle = 1
		ex.selection.borders(8).linestyle = 1
		ex.selection.borders(11).linestyle = 1
		
		ex.Range(ex.Cells(nn,3),ex.Cells(nn,3)).Select		
		ex.selection.horizontalalignment = -4108
    	
		* data
		ex.Cells(nn,1).Value = cc.dattd
		ex.Cells(nn,2).Value = cc.shwz
		ex.Cells(nn,3).Value = cc.kod
		ex.Cells(nn,4).Value = cc.ribf
		ex.Cells(nn,5).Value = cc.im
	
		nn = nn + 1
	endscan
	


	ex.Visible = .t.
	
	sqldisconnect(hh)
	use in cc
else
	eodbc('print_gotov conn')
endif



 