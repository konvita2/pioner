* копирование узла
lparameters parshw,parpoznd,parshw1,parplus

public lcc
lcc = 0

* создать курсор кодов
create cursor ckod (kod int)

openuzel(parshw,parpoznd)

* по курсору записать в новое изделие узлы
local hh,rr,mcou
hh = sqlconnect('sqldb','sa','111')
if hh>0
	select ckod
	mcou = reccount()
	scan all
		rr = sqlexec(hh,'select * from kt where kod=?ckod.kod','cdc')
		if rr = -1
			eodbc('copyuzel sele')
		endif
		
		local mpozn,mkornd,mres
		mres = 0
		mpozn = get_izd_ribf_by_kod(parshw1)
		mkornd = iif(parplus=1,'*'+alltrim(cdc.kornd),alltrim(cdc.kornd))
		rr = sqlexec(hh,'exec my_add_ktfull ?cdc.d_u,?cdc.kornw,?mpozn,?cdc.poznw,?cdc.poznd,'+;
						'?mkornd,?cdc.gr,?cdc.sort,?cdc.kodm,?cdc.ei,?cdc.rozma,?cdc.rozmb,'+;
						'?cdc.nrmd,?cdc.wag,?cdc.mz,?cdc.kol,?cdc.koli,?cdc.kttp,?cdc.datz,'+;
						'?cdc.kpi,?parshw1,?cdc.naimd,?cdc.kolz,?cdc.ndok,?cdc.naimw,?cdc.razr,'+;
						'?cdc.mar1,?cdc.mar2,?cdc.mar3,?cdc.mar4,?cdc.mar5,?cdc.mar6,?cdc.mar7,'+;
						'?cdc.mar8,?cdc.mar9,?cdc.mar10,?cdc.mar11,?cdc.mar12,?cdc.mar13,?cdc.mar14,'+;
						'?cdc.mar15,?cdc.mar16,?cdc.mar17,?cdc.mar18,?cdc.mar19,?cdc.mar20,'+;
						'?cdc.pu,?cdc.zo,?cdc.eskiz,?cdc.plopok,?cdc.pokr,?cdc.kodm1,?cdc.mark,'+;
						'?cdc.kodzag,?cdc.twer,?cdc.normwr,?cdc.normwr0,?cdc.gplopok,?cdc.gpokr,'+;
						'?cdc.tocha,?cdc.tochb,?cdc.kol1,?cdc.ei1,?cdc.primech,?cdc.pri1,'+;
						'?cdc.pri2,?cdc.mark1,?@mres')
		if rr = -1
			eodbc('copyuzel exec')
		endif						
		
	endscan
	
	wait window 'Скопировано ' + alltrim(str(mcou)) + ' позиций'   
	
else
	eodbc('copyuzel conn')
endif
release hh,rr

* удалить курсор
use in ckod


*////////////////////////////////////////////////////////
*/открыть узел
procedure openuzel(parshw,parpoznd)
local hh,rr

	lcc = lcc + 1

	hh = sqlconnect('sqldb','sa','111')
	if hh>0
		* главный узел
		rr = sqlexec(hh,'select top 1 * from kt where d_u=2 and shw=?parshw and kornd=kornw '+;
						'and rtrim(poznd)=rtrim(?parpoznd)','cdc')
		if rr = -1
			eodbc('openuzel sele1')
		endif				
		
		select cdc
		scan all
			insert into ckod (kod) values (cdc.kod)
		endscan 
		
		use in cdc
		
		* детали, покупные, вспомогательные
		rr = sqlexec(hh,'select * from kt where (d_u=1 or d_u=4 or d_u=5) and '+;
						'shw=?parshw and rtrim(poznw)=rtrim(?parpoznd)','cdc')
		if rr = -1
			eodbc('openuzel sele2')
		endif
		
		select cdc
		scan all
			insert into ckod (kod) values (cdc.kod)
		endscan 
		use in cdc				
		
		* входящие узлы
		local mdd
		mdd = 'cdc'+alltrim(str(lcc))
		rr = sqlexec(hh,'select * from kt where d_u=2 and '+;
						'shw=?parshw and rtrim(poznw)=rtrim(?parpoznd) and kornd<>kornw',;
						mdd)
		if rr = -1
			eodbc('openuzel sele3')
		endif
		
		select (mdd)
		local m.poznd,m.kod
		scan all
			select (mdd)
			scatter fields poznd,kod memvar
			insert into ckod (kod) values (m.kod)
			openuzel(parshw,m.poznd)
		endscan 
		use in (mdd)		
	else
		eodbc('openuzel conn')
	endif

	lcc = lcc - 1
	
endproc 