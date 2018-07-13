local loexcel
local mizd

local mizdkod

#define FALSE .f.
zad='НЕТ В СПРАВОЧНИКЕ'
publ arra m[20],mm[20]
local iinormw,iirasz,iitpz,iMRASZ,iiinormw,iiirasz,iiitpz,iiMRASZ
stor 0 to m
store 0 to iinormw,iirasz,iitpz,iMRASZ,iiinormw,iiirasz,iiitpz,iiMRASZ
do form f_izd_vib to cRibf

*!*	select * from izd where ribf = cRibf into cursor c_izd
*!*	m.Naim_izd = c_izd.im
*!*	m.ribf = c_izd.ribf

m.naim_izd = get_izd_im_by_ribf(cRibf)
m.ribf = cRibf
m.mizdkod = get_izd_kod_by_ribf(cRibf)

wait window nowait 'Запускаем Excel'
loexcel = createobject('Excel.Application')
loexcel.workbooks.open(sys(5)+sys(2003)+'\wnw.xls')
loexcel.displayalerts = .f.

*!*	loexcel.visible = .t.


local firstpass
*!*	firstpass = .t.
firstpass = 0
local nnom
nnom = 11

local hh,rr
hh = sqlconnect('sqldb','sa','111')
if hh > 0
	rr = sqlexec(hh,'select * from kt where shw=?m.mizdkod','cddkt')
	if rr = -1
		eodbc('wnw_ sele1')
	endif
	sqldisconnect(hh)
else
	eodbc('wnw_ conn1')
endif
release hh,rr

select distinct ;
	kornw,poznw,naimw,kornd,poznd,naimd, ;
	mar1,mar2,mar3,mar4,mar5,mar6,mar7,mar8,mar9,mar10,mar11,mar12,mar13,mar14,mar15,mar16,mar17,mar18,mar19,mar20, ;
	kodm,rozma,rozmb,kolz;
	from cddKT where !empt(mar1) and !empt(poznd) and d_u <= 3 ;
	order by KORNW,KORND into cursor CKT
select CKT
go top
*BROW FIEL SHW,NAIMW,POZNW,KORNW,POZND,NAIMD,MAR1,MAR2
if recc() > 0
	do while !eof()
	
		select ckt
		wait window nowait 'Выполнено ' + alltrim(str(100*recno()/reccount())) + '%' 
	
		nau=naimw
		riu=poznw
		knu=kornw
		nad=naimd
		rid=poznd
		knd=kornd

		m[1]=mar1
		m[2]=mar2
		m[3]=mar3
		m[4]=mar4
		m[5]=mar5
		m[6]=mar6
		m[7]=mar7
		m[8]=mar8
		m[9]=mar9
		m[10]=mar10
		m[11]=mar11
		m[12]=mar12
		m[13]=mar13
		m[14]=mar14
		m[15]=mar15
		m[16]=mar16
		m[17]=mar17
		m[18]=mar18
		m[19]=mar19
		m[20]=mar20
		str_p=str(mar1,4)+'-'+iif(mar2#0,allt(str(mar2,4)),'')
		if mar3#0
			str_p=str_p+'-'+allt(str(mar3,4))
		endif
		if mar4#0
			str_p=str_p+'-'+allt(str(mar4,4))
		endif
		if mar5#0
			str_p=str_p+'-'+allt(str(mar5,4))
		endif
		if mar6#0
			str_p=str_p+'-'+allt(str(mar6,4))
		endif
		if mar7#0
			str_p=str_p+'-'+allt(str(mar7,4))
		endif
		if mar8#0
			str_p=str_p+'-'+allt(str(mar8,4))
		endif
		if mar9#0
			str_p=str_p+'-'+allt(str(mar9,4))
		endif
		if mar10#0
			str_p=str_p+'-'+allt(str(mar10,4))
		endif
		if mar11#0
			str_p=str_p+'-'+allt(str(mar11,4))
		endif
		if mar12#0
			str_p=str_p+'-'+allt(str(mar12,4))
		endif
		if mar13#0
			str_p=str_p+'-'+allt(str(mar13,4))
		endif
		if mar14#0
			str_p=str_p+'-'+allt(str(mar14,4))
		endif
		if mar15#0
			str_p=str_p+'-'+allt(str(mar15,4))
		endif
		if mar16#0
			str_p=str_p+'-'+allt(str(mar16,4))
		endif
		if mar17#0
			str_p=str_p+'-'+allt(str(mar17,4))
		endif
		if mar18#0
			str_p=str_p+'-'+allt(str(mar18,4))
		endif
		if mar19#0
			str_p=str_p+'-'+allt(str(mar19,4))
		endif
		if mar20#0
			str_p=str_p+'-'+allt(str(mar20,4))
		endif
		store 0 to mm
		ind =1
		do while ind < 21
			if !empty(m[ind])
				ii=1
				do while ii < 21
					*!*	      			WAIT WINDOW 'ind='+STR(ind,2)+' m[ind]='+STR(m[ind],4)+' ii='+STR(ii,2)+' mm[ii]='+STR(mm[ii],4)
					if mm[ii] = 0
						mm[ii] = m[ind]
					endif
					if m[ind] = mm[ii]
						exit
					endif
					*!*	    	  		WAIT WINDOW 'ind='+STR(ind,2)+' m[ind]='+STR(m[ind],4)+' ii='+STR(ii,2)+' mm[ii]='+STR(mm[ii],4)
					ii=ii+1
				enddo
			endif
			ind = ind + 1
		enddo

		mkodm=kodm
		mrozma=rozma
		mrozmb=rozmb
		mkolz =kolz
		nmat=space(52)
*!*			if mkodm#0
*!*				select KODM,NAIM from MATER where KODM=MKODM into cursor C_MAT
*!*				if recc() > 0
*!*					nmat=naim
*!*				endif
*!*				use in C_MAT
*!*			endif

		nmat = get_mater(mkodm)

		*!*	      	if firstpass=1
		loExcel.ActiveWindow.SelectedSheets.HPageBreaks.add(loExcel.range(loExcel.Cells(nnom,1),loExcel.Cells(nnom,1)))
		*!*						*** вывести шапку
		loExcel.range(loExcel.Cells(1,1),loExcel.Cells(8,9)).select
		loExcel.selection.copy
		loExcel.range(loExcel.Cells(nnom,1),loExcel.Cells(nnom,1)).select
		loExcel.selection.PasteSpecial(-4104,-4142,.f.,.f.)
		*!*				firstpass = 0
		*!*			endif
		*!*
		*!*					*** прописать заголовки
		au='норм времени и расценок на изделие : '+alltrim(m.ribf)+' '+ALLTRIM(naim_izd)
		loexcel.cells(nnom+1,1).value = au
		loExcel.range(loExcel.Cells(nnom+1,1),loExcel.Cells(nnom+1,7)).select
		loExcel.selection.merge
		loExcel.selection.font.Bold = .t.
		loExcel.selection.font.size = 8

		au='узел(деталь) кор. № '+iif(empt(knd),allt(knu)+' '+allt(nau)+' '+allt(riu),allt(knd)+' '+allt(nad)+' '+allt(rid))
		loexcel.cells(nnom+2,1).value = au
		loExcel.range(loExcel.Cells(nnom+2,1),loExcel.Cells(nnom+2,7)).select
		loExcel.selection.merge
		loExcel.selection.font.Bold = .t.
		loExcel.selection.font.size = 8

		au = allt(nmat)+' '+str(mrozma,6,1)+'x'+allt(str(mrozmb,6,1))+str(mkolz,6,1)
		loExcel.Cells(nnom+4,1).value = au
		loExcel.range(loExcel.Cells(nnom+4,1),loExcel.Cells(nnom+4,7)).select
		loExcel.selection.merge
		loExcel.selection.font.Bold = .t.
		loExcel.selection.font.size = 8

		loExcel.Cells(nnom+5,1).value = 'Mаршрут '+str_p
		loExcel.range(loExcel.Cells(nnom+5,1),loExcel.Cells(nnom+5,7)).select
		loExcel.selection.merge
		loExcel.selection.font.Bold = .t.
		loExcel.selection.font.size = 8
		nnom = nnom + 8

		ind=1
		do while ind < 21
			if empty(mm[ind])
				exit
			endif
*!*				select poznd,mar,NORMW,RR,SETKA,NTO,KTO,KODO,TPZ,KRNO from TE ;
*!*					where poznd=rid and mar=mm[ind] ;
*!*					order by nto ;
*!*					into cursor CTE
			
			local hh,rr
			hh = sqlconnect('sqldb','sa','111')
			if hh > 0
				local fff
				fff = mm[ind]
				rr = sqlexec(hh,'select poznd,mar,normw,rr,setka,nto,kto,kodo,tpz,krno '+;
								'from te where rtrim(poznd)=rtrim(?rid) and mar=?fff '+;
								'order by nto','cte')
				if rr = -1
					eodbc('wnw_ sele3')
				endif							
				sqldisconnect(hh)
			else
				eodbc('wnw_ conn3')
			endif			
			release hh,rr
			
			select cte
			if recc() > 0

				local inormw,irasz,itpz,mrasz
				local nkto as string
				local nkodo as string

				select distinct nto,kto,kodo,krno,rr from cte into cursor c80
				scan all

					inormw = 0
					irasz = 0
					itpz = 0
					mrasz = 0

					local msum
					msum = 0
					select * from cte where nto = c80.nto into cursor c90
					scan all
						msum = msum + c90.normw
						itpz = itpz + c90.tpz

						mrasz=0
						*sele dengi from tarif where vidts = c90.setka and 
						*rr = c90.rr into curs ctar
						
						local h,r
						h = sqlconnect('sqldb','sa','111')
						if h > 0
							r = sqlexec(h,	'select dengi from tarif where vidts=?c90.setka '+;
											'and rr=?c90.rr','ctar')
							if r = -1
								eodbc('wnw_ sele5')
							endif					
							sqldisconnect(h)
						else
							eodbc('wnw_ conn5')
						endif
						release h,r
						
						select ctar
						if reccount()>0
							mrasz = dengi * c90.normw
							irasz = irasz + mrasz
						endif
						use in ctar

						nkto = get_kto_naim_by_kod(c80.kto)
						nkodo = alltrim(c80.kodo)



					endscan
					use in c90
					inormw = msum
					loexcel.cells(nnom,1).value = m[ind]
					loexcel.cells(nnom,2).value = c80.nto
					loExcel.Cells(nnom,3).value = nkto
					loExcel.Cells(nnom,4).value = nkodo

					loExcel.Cells(nnom,5).value = c80.krno
					loExcel.Cells(nnom,6).value = c80.rr
					loExcel.Cells(nnom,7).value = iif(itpz<>0,alltrim(str(itpz,9,3)),'')
					loExcel.Cells(nnom,8).value = iif(inormw<>0,alltrim(str(inormw,9,3)),'')
					loExcel.Cells(nnom,9).value = iif(irasz<>0,alltrim(str(irasz,9,2))  ,'')

					nnom = nnom + 1
					iitpz    = iitpz    + itpz
					iinormw  = iinormw  + inormw
					iirasz   = iirasz   + irasz
					iiitpz   = iiitpz   + itpz
					iiinormw = iiinormw + inormw
					iiirasz  = iiirasz  + irasz



				endscan
				use in c80



*!*					*******************
*!*					if cte.poznd='ДЖ-012.05.01.002' and cte.mar=211
*!*						brow
*!*					endif
*!*					store 0 to inormw,irasz,itpz,MRASZ
*!*					*wait '1 scat poznd='+poznd+' nto='+str(nto,4) wind

*!*					*skip
*!*					go top
*!*					do while .not.eof()

*!*						scatter memvar

*!*						*wait 'перед if m.nto='+str(m.nto,4)+' nto='+str(nto,4) wind
*!*						inormw=inormw+m.normw
*!*						itpz  =itpz  +m.tpz
*!*						if m.poznd='ДЖ-012.05.01.002' and m.mar=211
*!*							wait wind 'm.normw='+str(m.normw,9,4)+'   inormw='+str(inormw,9,4)
*!*						endif
*!*						*wait 'inormw='+str(inormw,7,2) wind
*!*						MRASZ=0
*!*						sele dengi from TARIF where vidts=m.setka and RR=m.rr into curs ctar
*!*						*brow
*!*						if reccount()>0
*!*							MRASZ=dengi*m.normw
*!*							irasz =irasz +mrasz
*!*						endif
*!*						use in ctar
*!*						select CTE
*!*						if nto#m.nto
*!*							store ' ' to nkto
*!*							select IM,vid,kod from DOSP where VID=7 and KOD = m.kto into cursor cdosp7
*!*							nkto=alltrim(cdosp7.im)
*!*							use in cdosp7

*!*							store ' ' to nkodo
*!*							select MARKA from OBOR where MARKA=m.kodo into cursor cobor
*!*							nkodo=alltrim(cobor.marka)
*!*							use in cobor

*!*							*!*							*** print line
*!*							loexcel.cells(nnom,1).value = m[ind]
*!*							loexcel.cells(nnom,2).value = m.nto
*!*							loExcel.Cells(nnom,3).value = nkto
*!*							loExcel.Cells(nnom,4).value = nkodo
*!*							*!*							loExcel.Range(loExcel.Cells(nnom,3),loExcel.Cells(nnom,4)).Select
*!*							*!*							loExcel.Selection.NumberFormat = '0.000'
*!*							*!*
*!*							loExcel.Cells(nnom,5).value = m.krno
*!*							loExcel.Cells(nnom,6).value = m.rr
*!*							loExcel.Cells(nnom,7).value = iif(itpz<>0,alltrim(str(itpz,9,3)),'')
*!*							loExcel.Cells(nnom,8).value = iif(inormw<>0,alltrim(str(inormw,9,3)),'')
*!*							loExcel.Cells(nnom,9).value = iif(irasz<>0,alltrim(str(irasz,9,2))  ,'')
*!*							nnom = nnom + 1
*!*							iitpz    = iitpz    + itpz
*!*							iinormw  = iinormw  + inormw
*!*							iirasz   = iirasz   + irasz
*!*							iiitpz   = iiitpz   + itpz
*!*							iiinormw = iiinormw + inormw
*!*							iiirasz  = iiirasz  + irasz
*!*							store 0 to inormw,irasz,itpz
*!*						endif
*!*						select CTE
*!*						skip
*!*						*scat memv
*!*						***if !eof()
*!*						*skip
*!*						***endif
*!*					enddo
*!*					store ' ' to nkto
*!*					select IM,vid,kod from DOSP where VID=7 and KOD = m.kto into cursor cdosp7
*!*					nkto=alltrim(cdosp7.im)
*!*					use in cdosp7
*!*					store ' ' to nkodo
*!*					select MARKA from OBOR where MARKA=m.kodo into cursor cobor
*!*					nkodo=alltrim(cobor.marka)
*!*					use in cobor

				*!*							*** print line
*!*					loexcel.cells(nnom,1).value = m[ind]
*!*					loexcel.cells(nnom,2).value = m.nto
*!*					loExcel.Cells(nnom,3).value = nkto
*!*					loExcel.Cells(nnom,4).value = nkodo
*!*					loExcel.Cells(nnom,5).value = m.krno
*!*					loExcel.Cells(nnom,6).value = m.rr
*!*					loExcel.Cells(nnom,7).value = iif(itpz<>0,alltrim(str(itpz,9,3)),'')
*!*					loExcel.Cells(nnom,8).value = iif(inormw<>0,alltrim(str(inormw,9,3)),'')
*!*					loExcel.Cells(nnom,9).value = iif(irasz<>0,alltrim(str(irasz,9,2))  ,'')
*!*					nnom = nnom + 1
*!*					iitpz    = iitpz    + itpz
*!*					iinormw  = iinormw  + inormw
*!*					iirasz   = iirasz   + irasz
*!*					iiitpz   = iiitpz   + itpz
*!*					iiinormw = iiinormw + inormw
*!*					iiirasz  = iiirasz  + irasz

			endif
			use in cte
			ind = ind + 1
		enddo
		loExcel.Cells(nnom,3).value = 'ИТОГО по детали(узлу)'
		loExcel.Cells(nnom,7).value = alltrim(str(iitpz,9,3))
		loExcel.Cells(nnom,8).value = alltrim(str(iinormw,9,3))
		loExcel.Cells(nnom,9).value = alltrim(str(iirasz,9,2))
		store 0 to iinormw,iirasz,iitpz,iMRASZ
		nnom = nnom + 1
		select ckt
		skip
	enddo
endif
nnom = nnom + 1
loExcel.Cells(nnom,3).value = 'ИТОГО ПО ИЗДЕЛИЮ'
loExcel.Cells(nnom,7).value = alltrim(str(iiitpz,9,3))
loExcel.Cells(nnom,8).value = alltrim(str(iiinormw,9,3))
loExcel.Cells(nnom,9).value = alltrim(str(iiirasz,9,2))
use in ckt
wait window nowait 'ОТЧЕТ ГОТОВ !'
loexcel.visible = .t.

use in cddkt



*!*				local mmar,gonextmar
*!*				local ssumtpz,ssumop,ssumcena
*!*
*!*				store 0 to ssumtpz,ssumop,ssumcena
*!*
*!*				mmar = cmar.kod
*!*				wait window nowait 'Участок '+str(cmar.kod,5)+' : '+alltrim(cmar.im)
*!*				*** пропустить участок если его нет в КТС
*!*				gonextmar = .f.
*!*				select * from kt ;
*!*					where shw = mizd and ;
*!*					inlist(mmar,mar1,mar2,mar3,mar4,mar5,mar6,mar7,mar8,mar9,mar10,mar11,mar12,mar13,mar14,mar15,mar16,mar17,mar18,mar19,mar20);
*!*					into cursor c100
*!*				if reccount()=0
*!*					gonextmar = .t.
*!*				else
*!*					*** пропустить участок если его нет в te
*!*					select * from te,kt where te.poznd == kt.poznd and te.mar = mmar and kt.shw = mizd into cursor c101
*!*					if reccount()=0
*!*						gonextmar = .t.
*!*					endif
*!*					use in c101
*!*				endif
*!*				use in c100
*!*				if !gonextmar
*!*					*** новая строка (не в первом случае)
*!*					if !firstpass
*!*						loExcel.ActiveWindow.SelectedSheets.HPageBreaks.Add(loExcel.Range(loExcel.Cells(nnom,1),loExcel.Cells(nnom,1)))
*!*						*** вывести шапку
*!*						loExcel.Range(loExcel.Cells(1,1),loExcel.Cells(11,5)).Select
*!*						loExcel.Selection.Copy
*!*						loExcel.Range(loExcel.Cells(nnom,1),loExcel.Cells(nnom,1)).Select
*!*						loExcel.Selection.PasteSpecial(-4104,-4142,.f.,.f.)
*!*					endif
*!*					firstpass = .f.
*!*					*** прописать заголовки
*!*					if thisform.opvid.value = 1
*!*						loexcel.cells(nnom+5,4).value = 'ПО ОБОРУДОВАНИЮ'
*!*						loExcel.Range(loExcel.Cells(nnom+5,4),loExcel.Cells(nnom+5,4)).Select
*!*						loExcel.Selection.Font.Bold = .t.
*!*						loExcel.Selection.Font.Size = 11
*!*					else
*!*						loexcel.cells(nnom+5,4).value = 'ПО ПРОФЕССИЯМ'
*!*						loExcel.Range(loExcel.Cells(nnom+5,4),loExcel.Cells(nnom+5,4)).Select
*!*						loExcel.Selection.Font.Bold = .t.
*!*						loExcel.Selection.Font.Size = 11
*!*					endif
*!*
*!*					*** написать в заголовке изделие
*!*					loExcel.Cells(nnom+6,1).value = 'Изделие: '+get_izd_ribf_by_kod(mizd)+' '+get_izd_im_by_kod(mizd)
*!*
*!*					*** написать в заголовке участок
*!*					loExcel.Cells(nnom+7,1).value = 'Участок: '+str(cmar.kod,5)+' '+cmar.im
*!*					nnom = nnom+11
*!*					*** выбираем профессии
*!*					select * from dosp where vid = 5 and kod <> 0 order by im into cursor cprof
*!*					scan all
*!*						*** пропустить профессию если она не используется
*!*						local gonext
*!*						gonext = .f.
*!*						select * from te where mar = cmar.kod and kodp = cprof.kod into cursor c100
*!*						if reccount()=0
*!*							gonext = .t.
*!*						endif
*!*						use in c100
*!*						if !gonext
*!*							*** временные переменные
*!*							local d,tr,cena
*!*							store 0 to d,tr,cena
*!*							*** для подсчета переменные
*!*							local sumcena,sumtpz,sumop
*!*							store 0 to sumcena,sumtpz,sumop
*!*							*** выбираем из te
*!*							select kt.koli, te.*;
*!*								from force te inner join kt on alltrim(te.poznd) == alltrim(kt.poznd);
*!*								where ;
*!*								te.kodp = cprof.kod and;
*!*								te.mar  = cmar.kod and;
*!*								kt.shw = mizd;
*!*								into cursor cte
*!*							scan all
*!*								tr = cte.koli * cte.normw
*!*								d = get_dengi(cte.setka,cte.rr)
*!*								cena = tr*d
*!*								*** накапливаем сумму
*!*								sumcena = sumcena + cena
*!*								sumop = sumop + tr
*!*								sumtpz = sumtpz + cte.tpz
*!*							endscan
*!*							use in cte
*!*							***
*!*							*** print line
*!*							loexcel.cells(nnom,1).value = cprof.kod
*!*							loexcel.cells(nnom,2).value = cprof.im
*!*
*!*							loExcel.Cells(nnom,3).value = sumtpz
*!*							loExcel.Cells(nnom,4).value = sumop
*!*							loExcel.Range(loExcel.Cells(nnom,3),loExcel.Cells(nnom,4)).Select
*!*							loExcel.Selection.NumberFormat = '0.000'
*!*
*!*							loExcel.Cells(nnom,5).value = sumcena
*!*							loExcel.Range(loExcel.Cells(nnom,5),loExcel.Cells(nnom,5)).Select
*!*							loExcel.Selection.NumberFormat = '0.00'
*!*							*** накапливаем суммы
*!*							ssumtpz  = ssumtpz + round(sumtpz,3)
*!*							ssumop   = ssumop + round(sumop,3)
*!*							ssumcena = ssumcena + round(sumcena,2)
*!*
*!*							*** inc counter
*!*							nnom = nnom+1
*!*						endif
*!*					endscan
*!*					*** выводим итоги по маршруту
*!*					loExcel.Cells(nnom,2).Value = 'ИТОГО'
*!*
*!*					loExcel.Cells(nnom,3).value = ssumtpz
*!*					loExcel.Cells(nnom,4).value = ssumop
*!*					loExcel.Cells(nnom,5).value = ssumcena
*!*
*!*					nnom = nnom+1
*!*					***
*!*					use in cprof
