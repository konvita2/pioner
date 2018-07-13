***************************************************************
* ïîëó÷èòü ïî êîäó íàèìåíîâàíèå òåõó÷àñòêà
* èñïîëüçóåòñÿ äëÿ âåäîìîñòè ğàñöåõîâêè
function fpr1
parameters par1
local resu,svwa
m.svwa = select()
select * from v_dosp2 where kod = m.par1 into cursor curs1
if reccount() > 0
	m.resu = curs1.im
else
	m.resu = ""
endif
use in curs1
select (svwa)
return m.resu
endfunc

***************************************************************
* ôóíêöèÿ äëÿ ôîğìèğîâàíèÿ êîäà ìàòåğèàëà ïî
* ãğóïïå, ñîğòàìåíòó, ïîñòàâêå è õèìñîñòàâó
function fpr2
lparameters pgr,psort,psp,psh
local cs,cs1,i,c
cs = 0
* gr
cs = str(pgr,5)
* sort
cs = cs + str(psort,5)
* sp
cs = cs + str(psp,5)
* sh
cs = cs + str(psh,5)
* çàìåíèòü ïğîáåëû íóëÿìè
cs1 = ""
for i=1 to len(cs)
	c = substr(cs,i,1)
	if c = " "
		c = "0"
	endif
	cs1 = cs1 + c
endfor
return cs1
endfunc

************************************************************
* îïğåäåëÿåò ìîæíî ëè âûïîëíèòü óäàëåíèå ıëåìåíòà
* òàáëèöû mater ñ êîäîì iKodm
function candeletemater(ikodm)
local lres,a[1]
m.lres = .t.

* âğåìåííî
return .t.

* ïğîâåğÿåì îòñóòñòâèå â kt
select count(*) from kt where kodm = m.ikodm into array a
if a[1] > 0
	messagebox("Óäàëÿòü çàïèñü òàáëèöû íåëüçÿ ò.ê. íà íåå åñòü ññûëêè â Ê.Ò.Ñ.!","ÂÍÈÌÀÍÈÅ!")
	return .f.
endif

* ïğîâğÿåì íåò ëè ññûëîê â áóõ îñòàòêàõ
select * from ostatok where kodm = m.ikodm into cursor c900
if reccount()>0
	messagebox('Óäàëÿòü çàïèñü íåëüçÿ ò.ê. äëÿ íåå åñòü êàğòî÷êà â áóõ. îñòàòêàõ')
	return .f.
endif
use in c900

* ïğîâåğÿåì åùå ÷òî-òî, íî ıòî íà áóäóùåå
* ...

return m.lres
endfunc

****************************************************************
* ãåíåğèğîâàòü íàèìåíîâàíèå ìàòåğèàëà
function generatematernaim(pr_sp,pr_sh)
local cspnaim,cshnaim,igrus
m.cspnaim = ""
m.cshnaim = ""
* ïîëó÷èòü íàèìåíîâàíèå ïîñòàâêè
select * from db!v_sp where (kod = m.pr_sp) into cursor curs11
if reccount() > 0
	m.cspnaim = curs11.im
endif
use in curs11
* ïîëó÷èòü íàèìåíîâàíèå õèìñîñòàâà
select * from db!v_sh where (kod = m.pr_sh) into cursor curs11
if reccount()>0
	m.cshnaim = " \ " + curs11.im
endif
use in curs11
return alltrim(m.cspnaim) + alltrim(m.cshnaim)
endfunc

****************************************************************
* Ïîëó÷èòü íàèìåíîâàíèå ïîäğàçäåëåíèÿ èëè ïîñòàâùèêà äëÿ
* çàïğîñà v_rash
function rashod_f1(pr_priz,pr_kodpp)
local lcres,svwa,a
m.lcres = ""
m.svwa = select()
if m.pr_priz = 1
	select * from db!v_dosp2 where kod = m.pr_kodpp into cursor c116
	if reccount() > 0
		m.lcres = c116.im
	else
		m.lcres = space(40)
	endif
	use in c116
else
	select * from db!post where alltrim(okpo) == str(m.pr_kodpp) into cursor c116
	if reccount() > 0
		m.lcres = c116.im
	else
		m.lcres = space(40)
	endif
	use in c116
endif
select (svwa)
m.a = m.lcres
return m.a
endfunc

****************************************************************
* Ïîëó÷èòü íàèìåíîâàíèå èçäåëèÿ ïî êîäó SHWZ
* èñïîëüçóåòñÿ â çàïğîñå v_rash
function rashod_f2(pr_shwz)
local lcres
m.lcres = space(40)
if not empty(m.pr_shwz)
	select * from db!izd where shwz == m.pr_shwz into cursor c117
	if reccount() > 0
		m.lcres = c117.im
	endif
	use in c117
endif
return m.lcres
endfunc

* ñòàğûé âàğèàíò
*!*	************************************************************
*!*	* ãåíåğèğîâàòü íàèìåíîâàíèå ìàòåğèàëà
*!*	FUNCTION GenerateMaterNaim(gr,sort,sp,sh,tm,shp,dp,dm,nsort)
*!*		LOCAL Res,kuku,im_sort,nsp,nsh
*!*		* ïîëó÷èòü íàèìåíîâàíèå ñîğòàìåíòà
*!*		SELECT * FROM db!v_sort WHERE (kod = m.sort) AND (us = m.gr) INTO CURSOR curs11
*!*		IF RECCOUNT()> 0
*!*			m.im_sort = curs11.im
*!*		ELSE
*!*			m.im_sort = ""
*!*		ENDIF
*!*		USE IN curs11
*!*		* ïîëó÷èòü íàèìåíîâàíèå ñòàíäàğòà ïîñòàâêè
*!*		SELECT * FROM db!v_sp WHERE (kod = m.sp) AND (us = m.sort) INTO CURSOR curs11
*!*		IF RECCOUNT()> 0
*!*			m.nsp = curs11.im
*!*		ELSE
*!*			m.nsp = ""
*!*		ENDIF
*!*		USE IN curs11
*!*		* ïîëó÷èòü íàèìåíîâàíèå õèìñîñòàâà
*!*		SELECT * FROM db!v_sh WHERE (kod = m.sh) AND (us = m.gr) INTO CURSOR curs11
*!*		IF RECCOUNT()> 0
*!*			m.nsh = curs11.im
*!*		ELSE
*!*			m.nsh = ""
*!*		ENDIF
*!*		USE IN curs11
*!*		*
*!*		m.Res = ''
*!*	   	m.kuku=''
*!*		if m.sort=1.or.m.sort=4.or.m.sort=16
*!*	      	m.kuku=allt(str(m.tm,6,2))+'x'+allt(str(m.shp,6))+'x'+allt(str(m.dp,5))
*!*	   	endif
*!*	   	if m.sort=5
*!*	      	m.kuku=allt(str(m.tm,6,2))+'x'+allt(str(m.dp,5))
*!*	   	endif
*!*	   	if m.sort=2.or.m.sort=13.or.m.sort=15
*!*	      	m.kuku=allt(str(m.dm,5,1))+'x'+allt(str(m.dp,5))
*!*	   	endif
*!*	   	if (m.sort=>6.and.m.sort=<12).or.m.sort=14
*!*	      	m.kuku=allt(str(m.nsort,5,1))+'x'+allt(str(m.dp,5))
*!*	   	endif
*!*	   	m.Res = allt(m.im_sort)+' '+m.kuku+' '+allt(m.nsp)+' '+allt(m.nsh)
*!*	   	RETURN m.Res
*!*	ENDFUNC

****************************************
****************************************
*** ĞÎÁÎÒÀ Ç ÔÀÉËÎÌ ÏĞÎÒÎÊÎËÀ
*** (òèì÷àñîâèé ïğîòîêîë äëÿ
***  êîğîòêèõ çàäà÷)
****************************************
****************************************

****************************************
* ñòâîğèòè ôàéë ïğîòîêîëó
procedure create_prot
fclose(fcreate("protocol.txt"))
endproc

****************************************
* âèäàëèòè ôàéë ïğîòîêîëó
procedure delete_prot
local lnfile

if file("protocol.txt")
	delete file "protocol.txt"
	do create_prot
else
	do create_prot
endif
endproc

****************************************
* çàïèñàòü ó ôàéë ïğîòîêîëà
procedure write_prot(pr_str)
local lnfile
lnfile = fopen("protocol.txt",2)
if m.lnfile # -1
	fseek(m.lnfile,0,2)
	fwrite(m.lnfile,m.pr_str+chr(13))
	fclose(m.lnfile)
else
	wait 'procs:write_prot Íå âäàëîñÿ â³äêğèòè ôàéë ïğîòîêîëó!' window
endif
endproc

*****************************************
* ôóíêö³ÿ ùî âèçíà÷àº ÷è ïîğîæí³é ôàéë
* ïğîòîêîëó
function isempty_prot
if fsize("protocol.txt") = 0
	return .t.
else
	return .f.
endif
endfunc

****************************************
* Ğîçğàõóíîê íîğìè ÷àñó íà äåòàëü
* âèêîğèñòîâóºòüñÿ îêğåìî òà ïğè âèáîğ³
* ìàòåğ³àëó â f_kt_vvod
* Ïàğàìåòğè
* mm0 = ğåæèì ğîáîòè ïğîöåäóğè 15 - ğîáîòà ó ğåæèì³ ïåğåğàõóíêó âñ³õ
procedure nrmd_old(mm0,kt_rozma, kt_rozmb, kt_kodm, mus, nrmd, mz)
** äëÿ âñåõ us 1 ïî 8 âêëş÷èòåëüíî â ôîìóëàõ rozma è rozmb ìåíÿòü ìåæäó ñîáîé
*è ïğèíèìàòü ND ,áîëøåãî çíà÷åíèÿ  nd1 è nd2 áğàòü òîëüêî öåëûå ÷èñëà
*WAIT 'sort='+str(sort,2)+' mus='+str(mus,1);
*            +' m.kt_rozma='+str(m.kt_rozma,4);
*            +' m.kt_rozmb='+str(m.kt_rozmb,4);
*            +' mtm='+str(mtm,4) WIND
local nd1,nd2,nd,mtm
local shr,rasch
* rasch - ôîğìóëà äëÿ ğàñ÷åòà èç ïîëÿ obor (1,2,3)

m.nrmd  = 0
m.mz	= 0

*susp


* ñòâîğèòè ó ïàì'ÿò³ çì³íí³ ç mater
select * from mater where kodm = m.kt_kodm into cursor c213
if reccount() > 0
	scatter memvar
	m.mtm = m.tm
	
else
	wait 'ÌÀÒÅĞ²ÀË Ç ÊÎÄÎÌ '+str(m.kt_kodm,4)+' ÍÅ ÇÍÀÉÄÅÍÎ !' window
	use in c213
	m.nrmd = -1
	m.mz   = -1
	return
endif
use in c213

* ïîëó÷èòü ôîğìóëó ğàñ÷åòà
select * from db!v_sort where kod = sort into cursor c22
if reccount()>0
	rasch = alltrim(c22.obor)
else
	rasch = ''
endif
use in c22

************************************
* ïîäãîòîâèòü øèğèíó ğåçà shr
do  case
	case mtm<10
		shr = 5
	case mtm>=10.and.mtm<16	
		shr = 5
	case mtm>=16.and.mtm<20
		shr = 6
	case mtm>=20.and.mtm<30
		shr = 7
	case mtm>=30.and.mtm<40
		shr = 10
	case mtm>=40.and.mtm<50
		shr = 12
	case mtm>=50
		shr = 14				
endcase
************************************
if inlist(sort,1,16,367,497,19,24,183,424,311)
&& 1 ÂÀĞÈÀÍÒ
	nd1=0
	if dp=0.or.shp=0
		if mm0=15
			if m.dp = 0
				write_prot('ÂÂÅÄÈÒÅ ÄËÈÍÓ ÏÎÑÒÀÂÊÈ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ ÏÎ ÊÎÄÓ '+str(M.kodm,4))
			else
				write_prot('ÂÂÅÄÈÒÅ ØÈĞÈÍÓ ÏÎÑÒÀÂÊÈ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ ÏÎ ÊÎÄÓ '+str(M.kodm,4))
			endif
			return
		else
			if m.dp = 0
				wait 'ÂÂÅÄÈÒÅ ÄËÈÍÓ ÏÎÑÒÀÂÊÈ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ' window
			else
				wait 'ÂÂÅÄÈÒÅ øèğèíó ÏÎÑÒÀÂÊÈ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ' window
			endif
			return
		endif
	endif
	nd2=0
	if mus=1
*nd1=Int(dp/m.kt_rozmA)
*nd2=Int(shp/m.kt_rozmB)
		m.nrmd=1.02*m.kt_rozma*m.kt_rozmb*tm*uv/1000000
	endif
*If mUS=2.And.mtm<=5.and.m.kt_rozmA>90.And.m.kt_rozmB<90
*nd1=Int(dp/m.kt_rozmA)
*nd2=Int((shp-90)/m.kt_rozmB)
*wait 'nd1='+str(nd1,6)+' nd2='+str(nd2,6) wind
*Endif
*If mUS=3.And.mtm<=5.And.m.kt_rozmA<89.And.m.kt_rozmB<89
*nd1=Int((dp-90)/m.kt_rozmA)
*nd2=Int((shp-90)/m.kt_rozmB)
*Endif
*!*			If mUS=4.And.mtm=>6.And.mtm<=30.And.m.kt_rozmA>=130.And.m.kt_rozmB>=130
*!*				nd1=Int(dp/m.kt_rozmA)
*!*				nd2=Int(shp/m.kt_rozmB)
*!*			Endif
*!*			If mUS=5.And.mtm=>6.And.mtm<=30.And.m.kt_rozmA>=130.And.m.kt_rozmB<=129
*!*				nd1=Int(dp/m.kt_rozmA)
*!*				nd2=Int((shp-130)/m.kt_rozmB)
*!*			Endif
*!*			If mUS=6.And.mtm=>6.And.mtm<=30.And.m.kt_rozmA<129.And.m.kt_rozmB<=130
*!*				nd1=Int((dp-130)/m.kt_rozmA)
*!*				nd2=Int((shp-130)/m.kt_rozmB)
*!*			Endif
*!*			If mUS=7.And.mtm<=50
*!*				nd1=Int(dp/(m.kt_rozmA+10))
*!*				nd2=Int(shp/(m.kt_rozmB+10))
*!*			Endif
	if mus=7
*nd1=Int(dp/(m.kt_rozmA+15))
*nd2=Int(shp/(m.kt_rozmB+15))
		m.nrmd=1.02*(m.kt_rozma+shr*2)*(m.kt_rozmb+shr*2)*tm*uv/1000000
	endif
	nd=nd1*nd2
*wait 'nd='+str(nd,6)+'DP='+str(dp,6)+' SHP='+str(shp,6)+' TM='+str(tm,2)+'  UV='+str(uv,6) wind

*wait 'M.NRMD='+str(M.NRMD,10,5) wind
*wait 'M.kolz='+str(m.kolz,5) wind
	m.mz=m.kt_rozma*m.kt_rozmb*tm*uv/1000000

*!*	&& 2 ÂÀĞÈÀÍÒ
*!*		if mus=1.and.mtm<=5.and.m.kt_rozma>=90.and.m.kt_rozmb>=90
*!*			nd1=int(dp/m.kt_rozmb)
*!*			nd2=int(shp/m.kt_rozma)
*!*		endif
*!*		if mus=2 .and. mtm<=5 .and. m.kt_rozma>90.and.m.kt_rozmb<90
*!*			nd1=int(shp/m.kt_rozma)
*!*			nd2=int((dp-90)/m.kt_rozmb)
*!*		endif
*!*		if mus=3.and.mtm<=5.and.m.kt_rozma<89.and.m.kt_rozmb<89
*!*			nd1=int((dp-90)/m.kt_rozmb)
*!*			nd2=int((shp-90)/m.kt_rozma)
*!*		endif
*!*		if mus=4.and.mtm=>6.and.mtm<=30.and.m.kt_rozma>=130.and.m.kt_rozmb>=130
*!*			nd1=int(dp/m.kt_rozmb)
*!*			nd2=int(shp/m.kt_rozma)
*!*		endif
*!*		if mus=5.and.mtm=>6.and.mtm<=30.and.m.kt_rozma>=130.and.m.kt_rozmb<=129
*!*			nd1=int(dp/m.kt_rozmb)
*!*			nd2=int((shp-130)/m.kt_rozma)
*!*		endif
*!*		if mus=6.and.mtm=>6.and.mtm<=30.and.m.kt_rozma<129.and.m.kt_rozmb>=130
*!*			nd1=int((dp-130)/m.kt_rozmb)
*!*			nd2=int(shp/m.kt_rozma)
*!*		endif
*!*		if mus=7.and.mtm<=50
*!*			nd1=int(dp/(m.kt_rozmb+10))
*!*			nd2=int(shp/(m.kt_rozma+10))
*!*		endif
*!*		if mus=8.and.mtm>50
*!*			nd1=int(dp/(m.kt_rozmb+15))
*!*			nd2=int(shp/(m.kt_rozma+15))
*!*		endif
*!*		nd_2=nd1*nd2
*!*		mnrmd=dp*shp*tm*uv/1000000/nd_2
*!*	*MMZ=ROZMA*ROZMB*TM*UV/1000000
*!*		if nd_2>nd
*!*	*m.mmz =mmz
*!*			m.nrmd=mnrmd
*!*		endif
endif
**** ÄËß ÂÑÅÕ ÑÎĞÒÀÌÅÍÒÎÂ ÁÎËÅÅ 2 US=9 ÍÈÆÅÏÅĞÅ×ÈÑËÅÍÍÎÅ
*****ÂÇßÒÜ ÇÀ ÎÑÍÎÂÓ ÍÎ ÁÅÇ  ( 10 È 15 Â ÔÎĞÌÓËÅ))
if mus=2
	if inlist(sort,2,13,15,416,7,4,5,6,8,12,14,3,18,187,184)
		if dm=0.or.uv=0.or.dp=0
			if mm0=15
				do case
				case dm = 0
					write_prot('ÂÂÅÄÈÒÅ ÄÈÀÌÅÒĞ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ ÏÎ ÊÎÄÓ '+str(M.kodm,4))
				case uv = 0
					write_prot('ÂÂÅÄÈÒÅ ÓÄÅËÜÍÛÉ ÂÅÑ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ ÏÎ ÊÎÄÓ '+str(M.kodm,4))
				case dp = 0
					write_prot('ÂÂÅÄÈÒÅ ÄËÈÍÓ ÏÎÑÒÀÂÊÈ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ ÏÎ ÊÎÄÓ '+str(M.kodm,4))
				endcase
				return
			else
				do case
				case dm = 0
					wait 'ÂÂÅÄÈÒÅ ÄÈÀÌÅÒĞ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ' window
				case uv = 0
					wait 'ÂÂÅÄÈÒÅ ÓÄÅËÜÍÛÉ ÂÅÑ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ' window
				case dp = 0
					wait 'ÂÂÅÄÈÒÅ ÄËÈÍÓ ÏÎÑÒÀÂÊÈ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ' window
				endcase
				return
			endif
		endif
** ÄËß SORT=2 (ÊĞÓÃ) US=10 ÏÎĞ.ÃÀÇ ÈËÈ ÎÒĞ.ÏÈËÀÌÈ   çàïèñûâàòü îáîçíà÷åíèå DM X DP
		
		if rasch == '1'
			m.nrmd=1.02*3.14*dm*dm*uv*(m.kt_rozma+1.5)/4000000
			m.mz=3.14*dm*dm*uv*m.kt_rozma/4000000
		else
			if rasch == '2'
				m.nrmd=1.02*ps*(m.kt_rozma+1.5)/1000
				m.mz=ps*m.kt_rozma/1000
			endif	
		endif			
	endif

	if sort = 7
		if dm=0.or.uv=0.or.dp=0
			if mm0=15
				do case
				case dm = 0
					write_prot('ÂÂÅÄÈÒÅ ÄÈÀÌÅÒĞ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ ÏÎ ÊÎÄÓ '+str(M.kodm,4))
				case uv = 0
					write_prot('ÂÂÅÄÈÒÅ ÓÄÅËÜÍÛÉ ÂÅÑ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ ÏÎ ÊÎÄÓ '+str(M.kodm,4))
				case dp = 0
					write_prot('ÂÂÅÄÈÒÅ ÄËÈÍÓ ÏÎÑÒÀÂÊÈ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ ÏÎ ÊÎÄÓ '+str(M.kodm,4))
				endcase
				return
			else
				do case
				case dm = 0
					wait 'ÂÂÅÄÈÒÅ ÄÈÀÌÅÒĞ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ' window
				case uv = 0
					wait 'ÂÂÅÄÈÒÅ ÓÄÅËÜÍÛÉ ÂÅÑ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ' window
				case dp = 0
					wait 'ÂÂÅÄÈÒÅ ÄËÈÍÓ ÏÎÑÒÀÂÊÈ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ' window
				endcase
				return
			endif
		endif
** ÄËß SORT=2 (ÊĞÓÃ) US=10 ÏÎĞ.ÃÀÇ ÈËÈ ÎÒĞ.ÏÈËÀÌÈ   çàïèñûâàòü îáîçíà÷åíèå DM X DP
		nd=int(dp/(m.kt_rozma+3))
		m.nrmd=1.02*3.14*dm*dm*uv*(m.kt_rozma+5)/4000000
		m.mz=3*dm*dm*uv*m.kt_rozma/4000000
	endif

	if sort=4
** ÄËß ÏÎËÎÑÛ   SORT=4
		if tm=0.or.uv=0.or.dp=0
			if mm0=15
				do case
				case tm = 0
					write_prot('ÂÂÅÄÈÒÅ ÒÎËÙÈÍÓ ÌÀÒÅĞÈÀËÎÂ ÏÎ ÊÎÄÓ '+str(M.kodm,4))
				case uv = 0
					write_prot('ÂÂÅÄÈÒÅ ÓÄÅËÜÍÛÉ ÂÅÑ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ ÏÎ ÊÎÄÓ '+str(M.kodm,4))
				case dp = 0
					write_prot('ÂÂÅÄÈÒÅ ÄËÈÍÓ ÏÎÑÒÀÂÊÈ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ ÏÎ ÊÎÄÓ '+str(M.kodm,4))
				endcase
				return
			else
				do case
				case tm = 0
					wait 'ÂÂÅÄÈÒÅ ÒÎËÙÈÍÓ ÌÀÒÅĞÈÀËÎÂ' window
				case uv = 0
					wait 'ÂÂÅÄÈÒÅ ÓÄÅËÜÍÛÉ ÂÅÑ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ' window
				case dp = 0
					wait 'ÂÂÅÄÈÒÅ ÄËÈÍÓ ÏÎÑÒÀÂÊÈ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ' window
				endcase
				return
			endif
		endif
		nd=int(dp/(m.kt_rozma+3))

		m.nrmd=tm*uv*dp/nd/1000000
		m.mz=tm*uv*m.kt_rozma/1000000
*** çàïèñûâàòü  îáîçíà÷åíèå ïîëîñû tm x pol x dp
	endif
	if sort=5
** ÄËß SORT=5(ÊÂÀÄĞÀÒ ) çàïèñûâàòü îáîçíà÷åíèå tm  x dp
		if tm=0.or.uv=0.or.dp=0
			if mm0=15
				do case
				case tm = 0
					write_prot('ÂÂÅÄÈÒÅ ÒÎËÙÈÍÓ ÌÀÒÅĞÈÀËÎÂ ÏÎ ÊÎÄÓ '+str(M.kodm,4))
				case uv = 0
					write_prot('ÂÂÅÄÈÒÅ ÓÄÅËÜÍÛÉ ÂÅÑ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ ÏÎ ÊÎÄÓ '+str(M.kodm,4))
				case dp = 0
					write_prot('ÂÂÅÄÈÒÅ ÄËÈÍÓ ÏÎÑÒÀÂÊÈ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ ÏÎ ÊÎÄÓ '+str(M.kodm,4))
				endcase
				return
			else
				do case
				case tm = 0
					wait 'ÂÂÅÄÈÒÅ ÒÎËÙÈÍÓ ÌÀÒÅĞÈÀËÎÂ' window
				case uv = 0
					wait 'ÂÂÅÄÈÒÅ ÓÄÅËÜÍÛÉ ÂÅÑ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ' window
				case dp = 0
					wait 'ÂÂÅÄÈÒÅ ÄËÈÍÓ ÏÎÑÒÀÂÊÈ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ' window
				endcase
				return
			endif
		endif
		nd=int(dp/(m.kt_rozma+3))
		m.nrmd=tm*tm*uv*dp/nd/1000000
		m.mz=  tm*tm*uv*m.kt_rozma/1000000
	endif
	if sort=6.or.(sort>=8.and.sort<=12).or.sort=14.or.sort=3.or.sort=18.or.sort=187.or.sort=184
		nd=int(dp/(m.kt_rozma+3))
*** ÄËß ÂÑÅÕ SORT>=6,ÊĞÎÌÅ SORT=1,2,4,5  ÇÀÏÈÑÛÂÀÒÜ ÎÁÎÇÍÀ×ÅÍÈÅ NSORT X DP
		if ps=0.or.uv=0.or.dp=0
			if mm0=15
				do case
				case ps = 0
					write_prot('ÂÂÅÄÈÒÅ ÂÅÑ ÏÎÃÎÍÍÎÃÎ ÌÅÒĞÀ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ ÏÎ ÊÎÄÓ '+str(M.kodm,4))
				case uv = 0
					write_prot('ÂÂÅÄÈÒÅ ÓÄÅËÜÍÛÉ ÂÅÑ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ ÏÎ ÊÎÄÓ '+str(M.kodm,4))
				case dp = 0
					write_prot('ÂÂÅÄÈÒÅ ÄËÈÍÓ ÏÎÑÒÀÂÊÈ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ ÏÎ ÊÎÄÓ '+str(M.kodm,4))
				endcase
				return
			else
				do case
				case ps = 0
					wait 'ÂÂÅÄÈÒÅ ÂÅÑ ÏÎÃÎÍÍÎÃÎ ÌÅÒĞÀ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ' window
				case uv = 0
					wait 'ÂÂÅÄÈÒÅ ÓÄÅËÜÍÛÉ ÂÅÑ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ' window
				case dp = 0
					wait 'ÂÂÅÄÈÒÅ ÄËÈÍÓ ÏÎÑÒÀÂÊÈ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ' window
				endcase
				return
			endif
		endif
		m.nrmd=dp*ps/nd/1000000
		m.mz=m.kt_rozma*ps/1000000
	endif
endif


if mus=3
	if inlist(sort,2,13,15,416)
		if dm=0.or.uv=0.or.dp=0
			if mm0=15
				do case
				case dm = 0
					write_prot('ÂÂÅÄÈÒÅ ÄÈÀÌÅÒĞ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ ÏÎ ÊÎÄÓ '+str(M.kodm,4))
				case uv = 0
					write_prot('ÂÂÅÄÈÒÅ ÓÄÅËÜÍÛÉ ÂÅÑ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ ÏÎ ÊÎÄÓ '+str(M.kodm,4))
				case dp = 0
					write_prot('ÂÂÅÄÈÒÅ ÄËÈÍÓ ÏÎÑÒÀÂÊÈ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ ÏÎ ÊÎÄÓ '+str(M.kodm,4))
				endcase
				return
			else
				do case
				case dm = 0
					wait 'ÂÂÅÄÈÒÅ ÄÈÀÌÅÒĞ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ' window
				case uv = 0
					wait 'ÂÂÅÄÈÒÅ ÓÄÅËÜÍÛÉ ÂÅÑ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ' window
				case dp = 0
					wait 'ÂÂÅÄÈÒÅ ÄËÈÍÓ ÏÎÑÒÀÂÊÈ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ' window
				endcase
				return
			endif
		endif
		if rasch == '1'
			m.nrmd=1.02*3.14*dm*dm*uv*(m.kt_rozma+5)/4000000
			m.mz=3.14*dm*dm*uv*m.kt_rozma/4000000		
		else
			if rasch == '2'
				m.nrmd=1.02*ps*(m.kt_rozma+5)/1000
				m.mz=ps*m.kt_rozma/1000
			endif	
		endif		
		
	endif
endif


if mus=4
	if inlist(sort,2,13,15,416,4,69,178,471,472,9,7,152,361)
		if dm=0.or.uv=0.or.dp=0
			if mm0=15
				do case
				case dm = 0
					write_prot('ÂÂÅÄÈÒÅ ÄÈÀÌÅÒĞ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ ÏÎ ÊÎÄÓ '+str(M.kodm,4))
				case uv = 0
					write_prot('ÂÂÅÄÈÒÅ ÓÄÅËÜÍÛÉ ÂÅÑ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ ÏÎ ÊÎÄÓ '+str(M.kodm,4))
				case dp = 0
					write_prot('ÂÂÅÄÈÒÅ ÄËÈÍÓ ÏÎÑÒÀÂÊÈ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ ÏÎ ÊÎÄÓ '+str(M.kodm,4))
				endcase
				return
			else
				do case
				case dm = 0
					wait 'ÂÂÅÄÈÒÅ ÄÈÀÌÅÒĞ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ' window
				case uv = 0
					wait 'ÂÂÅÄÈÒÅ ÓÄÅËÜÍÛÉ ÂÅÑ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ' window
				case dp = 0
					wait 'ÂÂÅÄÈÒÅ ÄËÈÍÓ ÏÎÑÒÀÂÊÈ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ' window
				endcase
				return
			endif
		endif
		if alltrim(rasch) = '1'
			m.nrmd=1.02*3.14*dm*dm*uv*m.kt_rozma/4000000
			m.mz=3.14*dm*dm*uv*m.kt_rozma/4000000
		else
			m.nrmd=1.02*ps*m.kt_rozma/1000
			m.mz=3.14*ps*m.kt_rozma/1000
		endif	
	endif
endif


if mus=10
	if inlist(sort,2,13,15,416,6,9,171,11,3,238,297,8)
		if dm=0.or.uv=0.or.dp=0
			if mm0=15
				do case
				case dm = 0
					write_prot('ÂÂÅÄÈÒÅ ÄÈÀÌÅÒĞ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ ÏÎ ÊÎÄÓ '+str(M.kodm,4))
				case uv = 0
					write_prot('ÂÂÅÄÈÒÅ ÓÄÅËÜÍÛÉ ÂÅÑ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ ÏÎ ÊÎÄÓ '+str(M.kodm,4))
				case dp = 0
					write_prot('ÂÂÅÄÈÒÅ ÄËÈÍÓ ÏÎÑÒÀÂÊÈ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ ÏÎ ÊÎÄÓ '+str(M.kodm,4))
				endcase
				return
			else
				do case
				case dm = 0
					wait 'ÂÂÅÄÈÒÅ ÄÈÀÌÅÒĞ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ' window
				case uv = 0
					wait 'ÂÂÅÄÈÒÅ ÓÄÅËÜÍÛÉ ÂÅÑ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ' window
				case dp = 0
					wait 'ÂÂÅÄÈÒÅ ÄËÈÍÓ ÏÎÑÒÀÂÊÈ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ' window
				endcase
				return
			endif
		endif
		if alltrim(rasch) == '1'
			m.nrmd=1.02*3.14*dm*dm*uv*(m.kt_rozma+7)/4000000
			m.mz=3.14*dm*dm*uv*m.kt_rozma/4000000
		else
			m.nrmd=1.02*ps*(m.kt_rozma+7)/4000000
			m.mz=ps*m.kt_rozma/4000000
		endif	
	endif
endif


*!*	if mus=10
*!*		if sort=2.or.sort=13.or.sort=15
*!*	** ÄËß SORT=2 (ÊĞÓÃ) US=10 ÍÀ (áîëãàğêîé)ÏĞÅÑÍÎÆÍÈÖÀÕ   çàïèñûâàòüîáîçíà÷åíèå DM X DP
*!*			if dm=0.or.uv=0.or.dp=0
*!*				if mm0=15
*!*					do case
*!*					case dm = 0
*!*						write_prot('ÂÂÅÄÈÒÅ ÄÈÀÌÅÒĞ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ ÏÎ ÊÎÄÓ '+str(M.kodm,4))
*!*					case uv = 0
*!*						write_prot('ÂÂÅÄÈÒÅ ÓÄÅËÜÍÛÉ ÂÅÑ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ ÏÎ ÊÎÄÓ '+str(M.kodm,4))
*!*					case dp = 0
*!*						write_prot('ÂÂÅÄÈÒÅ ÄËÈÍÓ ÏÎÑÒÀÂÊÈ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ ÏÎ ÊÎÄÓ '+str(M.kodm,4))
*!*					endcase
*!*					return
*!*				else
*!*					do case
*!*					case dm = 0
*!*						wait 'ÂÂÅÄÈÒÅ ÄÈÀÌÅÒĞ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ' window
*!*					case uv = 0
*!*						wait 'ÂÂÅÄÈÒÅ ÓÄÅËÜÍÛÉ ÂÅÑ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ' window
*!*					case dp = 0
*!*						wait 'ÂÂÅÄÈÒÅ ÄËÈÍÓ ÏÎÑÒÀÂÊÈ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ' window
*!*					endcase
*!*					return
*!*				endif
*!*			endif
*!*			nd=int(dp/(10+m.kt_rozma))
*!*			m.nrmd=3.14*dm*dm*uv*dp/nd/4000000
*!*			m.mz=3.14*dm*dm*uv*m.kt_rozma/4000000
*!*		endif

*!*		if sort=7
*!*			if dm=0.or.uv=0.or.dp=0
*!*				if mm0=15
*!*					do case
*!*					case dm = 0
*!*						write_prot('ÂÂÅÄÈÒÅ ÄÈÀÌÅÒĞ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ ÏÎ ÊÎÄÓ '+str(M.kodm,4))
*!*					case uv = 0
*!*						write_prot('ÂÂÅÄÈÒÅ ÓÄÅËÜÍÛÉ ÂÅÑ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ ÏÎ ÊÎÄÓ '+str(M.kodm,4))
*!*					case dp = 0
*!*						write_prot('ÂÂÅÄÈÒÅ ÄËÈÍÓ ÏÎÑÒÀÂÊÈ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ ÏÎ ÊÎÄÓ '+str(M.kodm,4))
*!*					endcase
*!*					return
*!*				else
*!*					do case
*!*					case dm = 0
*!*						wait 'ÂÂÅÄÈÒÅ ÄÈÀÌÅÒĞ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ' window
*!*					case uv = 0
*!*						wait 'ÂÂÅÄÈÒÅ ÓÄÅËÜÍÛÉ ÂÅÑ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ' window
*!*					case dp = 0
*!*						wait 'ÂÂÅÄÈÒÅ ÄËÈÍÓ ÏÎÑÒÀÂÊÈ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ' window
*!*					endcase
*!*					return
*!*				endif
*!*			endif
*!*			nd=int(dp/(10+m.kt_rozma))
*!*			m.nrmd=3*dm*dm*uv*dp/nd/4000000/2*sqrt(3)
*!*			m.mz=3*dm*dm*uv*m.kt_rozma/4000000/2*sqrt(3)
*!*		endif

*!*		if sort=4
*!*	** ÄËß ÏÎËÎÑÛ   SORT=4
*!*			if tm=0.or.uv=0.or.dp=0
*!*				if mm0=15
*!*					do case
*!*					case tm = 0
*!*						write_prot('ÂÂÅÄÈÒÅ ÒÎËÙÈÍÓ ÌÀÒÅĞÈÀËÎÂ ÏÎ ÊÎÄÓ '+str(M.kodm,4))
*!*					case uv = 0
*!*						write_prot('ÂÂÅÄÈÒÅ ÓÄÅËÜÍÛÉ ÂÅÑ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ ÏÎ ÊÎÄÓ '+str(M.kodm,4))
*!*					case dp = 0
*!*						write_prot('ÂÂÅÄÈÒÅ ÄËÈÍÓ ÏÎÑÒÀÂÊÈ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ ÏÎ ÊÎÄÓ '+str(M.kodm,4))
*!*					endcase
*!*					return
*!*				else
*!*					do case
*!*					case tm = 0
*!*						wait 'ÂÂÅÄÈÒÅ ÒÎËÙÈÍÓ ÌÀÒÅĞÈÀËÎÂ' window
*!*					case uv = 0
*!*						wait 'ÂÂÅÄÈÒÅ ÓÄÅËÜÍÛÉ ÂÅÑ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ' window
*!*					case dp = 0
*!*						wait 'ÂÂÅÄÈÒÅ ÄËÈÍÓ ÏÎÑÒÀÂÊÈ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ' window
*!*					endcase
*!*					return
*!*				endif
*!*			endif
*!*			nd=int(dp/(5+m.kt_rozma))
*!*	*M.NRMD=TM*POL*UV*DP/ND/1000000
*!*	*M.MZ=TM*POL*UV*m.kt_rozmA/1000000
*!*			m.nrmd=tm*uv*dp/nd/1000000
*!*			m.mz=tm*uv*m.kt_rozma/1000000
*!*	*** çàïèñûâàòü  îáîçíà÷åíèå ïîëîñû tm x pol x dp
*!*		endif
*!*		if sort=5
*!*	** ÄËß SORT=5(ÊÂÀÄĞÀÒ ) çàïèñûâàòü îáîçíà÷åíèå tm  x dp
*!*			if tm=0.or.uv=0.or.dp=0
*!*				if mm0=15
*!*					do case
*!*					case tm = 0
*!*						write_prot('ÂÂÅÄÈÒÅ ÒÎËÙÈÍÓ ÌÀÒÅĞÈÀËÎÂ ÏÎ ÊÎÄÓ '+str(M.kodm,4))
*!*					case uv = 0
*!*						write_prot('ÂÂÅÄÈÒÅ ÓÄÅËÜÍÛÉ ÂÅÑ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ ÏÎ ÊÎÄÓ '+str(M.kodm,4))
*!*					case dp = 0
*!*						write_prot('ÂÂÅÄÈÒÅ ÄËÈÍÓ ÏÎÑÒÀÂÊÈ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ ÏÎ ÊÎÄÓ '+str(M.kodm,4))
*!*					endcase
*!*					return
*!*				else
*!*					do case
*!*					case tm = 0
*!*						wait 'ÂÂÅÄÈÒÅ ÒÎËÙÈÍÓ ÌÀÒÅĞÈÀËÎÂ' window
*!*					case uv = 0
*!*						wait 'ÂÂÅÄÈÒÅ ÓÄÅËÜÍÛÉ ÂÅÑ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ' window
*!*					case dp = 0
*!*						wait 'ÂÂÅÄÈÒÅ ÄËÈÍÓ ÏÎÑÒÀÂÊÈ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ' window
*!*					endcase
*!*					return
*!*				endif
*!*			endif
*!*			nd=int(dp/(5+m.kt_rozma))
*!*			m.nrmd=tm*tm*uv*dp/nd/1000000
*!*			m.mz=  tm*tm*uv*m.kt_rozma/1000000
*!*		endif
*!*		if (sort=>6.and.sort=<12).or.sort=14.or.sort=3.or.sort=18.or.sort=187.or.sort=184
*!*			nd=int(dp/(5+m.kt_rozma))
*!*	*** ÄËß ÂÑÅÕ SORT>=6,ÊĞÎÌÅ SORT=1,2,4,5  ÇÀÏÈÑÛÂÀÒÜ ÎÁÎÇÍÀ×ÅÍÈÅ NSORT X DP
*!*			if ps=0.or.uv=0.or.dp=0
*!*				if mm0=15
*!*					do case
*!*					case ps = 0
*!*						write_prot('ÂÂÅÄÈÒÅ ÂÅÑ ÏÎÃÎÍÍÎÃÎ ÌÅÒĞÀ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ ÏÎ ÊÎÄÓ '+str(M.kodm,4))
*!*					case uv = 0
*!*						write_prot('ÂÂÅÄÈÒÅ ÓÄÅËÜÍÛÉ ÂÅÑ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ ÏÎ ÊÎÄÓ '+str(M.kodm,4))
*!*					case dp = 0
*!*						write_prot('ÂÂÅÄÈÒÅ ÄËÈÍÓ ÏÎÑÒÀÂÊÈ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ ÏÎ ÊÎÄÓ '+str(M.kodm,4))
*!*					endcase
*!*					return
*!*				else
*!*					do case
*!*					case ps = 0
*!*						wait 'ÂÂÅÄÈÒÅ ÂÅÑ ÏÎÃÎÍÍÎÃÎ ÌÅÒĞÀ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ' window
*!*					case uv = 0
*!*						wait 'ÂÂÅÄÈÒÅ ÓÄÅËÜÍÛÉ ÂÅÑ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ' window
*!*					case dp = 0
*!*						wait 'ÂÂÅÄÈÒÅ ÄËÈÍÓ ÏÎÑÒÀÂÊÈ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ' window
*!*					endcase
*!*					return
*!*				endif
*!*			endif
*!*			m.nrmd=dp*ps/nd/1000000
*!*			m.mz=m.kt_rozma*ps/1000000
*!*		endif
*!*	endif

if mus = 20
	if inlist(sort,74,75,43)
** ÄËß ÑÒÅÊËÎÒÊÀÍÈ È ÑÒÅÊËÎÑÅÒÊÈ   SORT=75 èëè 75
		if dp=0 .or. shp = 0
			if mm0=15
				do case
				case dp = 0
					write_prot('ÂÂÅÄÈÒÅ ÄËÈÍÓ ÏÎÑÒÀÂÊÈ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ ÏÎ ÊÎÄÓ '+str(M.kodm,4))
				case shp = 0
					write_prot('ÂÂÅÄÈÒÅ ØÈĞÈÍÓ ÏÎÑÒÀÂÊÈ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ ÏÎ ÊÎÄÓ '+str(M.kodm,4))
				endcase
				return
			else
				do case
				case dp = 0
					wait 'ÂÂÅÄÈÒÅ ÄËÈÍÓ ÏÎÑÒÀÂÊÈ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ' window
				case shp = 0
					wait 'ÂÂÅÄÈÒÅ ØÈĞÈÍÓ ÏÎÑÒÀÂÊÈ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ' window
				endcase
				return
			endif
		endif

		local nd11,nd22

		nd1 = int(dp/m.kt_rozma)
		nd2 = int(shp/m.kt_rozmb)

		nd11 = int(shp/m.kt_rozma)
		nd22 = int(dp/m.kt_rozmb)

		if nd1*nd2 > nd11*nd22
			m.nrmd = dp*shp / (nd1*nd2) / 1000000
		else
			m.nrmd = dp*shp / (nd11*nd22) / 1000000
		endif

		m.mz = m.kt_rozmb * m.kt_rozma / 1000000

		release nd11,nd22

	endif
endif

if mus = 21
	if inlist(sort,73,72)
** ÄËß SORT=73 èëè 72
		if dp=0
			if mm0=15
				do case
				case dp = 0
					write_prot('ÂÂÅÄÈÒÅ ÄËÈÍÓ ÏÎÑÒÀÂÊÈ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ ÏÎ ÊÎÄÓ '+str(M.kodm,4))
				endcase
				return
			else
				do case
				case dp = 0
					wait 'ÂÂÅÄÈÒÅ ÄËÈÍÓ ÏÎÑÒÀÂÊÈ Â ÊÀÒÀËÎÃ ÌÀÒÅĞÈÀËÎÂ' window
				endcase
				return
			endif
		endif
		nd = int(dp/m.kt_rozma)
		m.nrmd = dp/nd/1000
		m.mz = m.kt_rozma / 1000
*** çàïèñûâàòü  îáîçíà÷åíèå ïîëîñû tm x pol x dp
	endif
endif


return
endproc

****************************************
* Îòğèìàòè çà kod_kt - us
function get_us_by_kt(pr_kt_kod)
	local lnres,lcmes
	m.lnres = 0
	*select * from kt where kod = m.pr_kt_kod into cursor c214

	local hh,rr
	hh = sqlconnect('sqldb','sa','111')
	if hh > 0

		rr = sqlexec(hh,'select * from kt where kod = m.pr_kt_kod','c214')
		if rr = -1
			eodbc('get_us_by_kt sele')
		endif

		if reccount() > 0
			if c214.kodm1 > 0 .and. c214.kodm1 < m.glmater
				select * from mater where kodm = c214.kodm1 into cursor c215
				if reccount() > 0
					***
					if c215.sort = 1 .and. ;
							inlist(c215.gr,1,4,6,7) .and. ;
							c215.tm <= 5 ;
							then
						if c214.rozma > 90 .and. c214.rozmb > 90
							m.lnres = 1
						endif

						if c214.rozma > 90 .and. c214.rozmb < 90
							m.lnres = 2
						endif

						if c214.rozma < 90 .and. c214.rozmb < 90
							m.lnres = 3
						endif
					endif
					***
					if c215.sort = 1 .and. ;
							inlist(c215.gr,1,4,6,7) .and. ;
							c215.tm > 5 .and. c215.tm <= 12 ;
							then
						if c214.rozma > 130 .and. c214.rozmb > 130
							m.lnres = 4
						endif

						if c214.rozma > 130 .and. c214.rozmb < 130
							m.lnres = 5
						endif

						if c214.rozma < 130 .and. c214.rozmb < 130
							m.lnres = 6
						endif
					endif
					***
					if 	c215.sort = 1 .and. ;
							inlist(c215.gr,1,4,6,7) .and. ;
							c215.tm > 12 ;
							then
						m.lnres = 7
					endif
					***
					if inlist(c215.sort,2,3,4,5,11,13,14,17)
						m.lnres = 8
					endif
				else
					m.lcmes =  	'procs : get_us_by_kod : Íå '+ ;
						'âäàëîñÿ çíàéòè ìàòåğ³àë ç êîäîì='+ ;
						str(c214.kodm1,5)+' äëÿ kt='+ ;
						str(c214.kod,5)
					write_prot(m.lcmes)
				endif
				use in c215
			endif
		else
			wait "procs : get_us_by_kt : Íå âäàëîñÿ çíàéòè â kt êîä " + ;
				str(m.pr_kt_kod) window
		endif
		use in c214

	else
		eodbc('get_us_by_kt conn')
	endif

	return m.lnres
endfunc


****************************************
* âûòÿãèâàåì èç kornd ëåâóş ÷àñòü
function l_kornd(par_kornd)
local lnres,lnpointpos,lctemp
m.lnpointpos = at('.',m.par_kornd)
m.lctemp = left(m.par_kornd,m.lnpointpos-1)
if !empty(m.lctemp)
	m.lnres = val(m.lctemp)
else
	m.lnres = 0
endif
return m.lnres
endfunc


****************************************
* âûòÿãèâàåì èç kornd ïğàâóş ÷àñòü
* îò òî÷êè äî íåöèôğîâîãî ñèìâîëà
function r_kornd(par_kornd)
local lnres,lnstart,lna,lctemp1,lctemp2
m.lnstart = at('.',m.par_kornd)+1
* èùåì êîíåö öèôğîâîé ÷àñòè
m.lctemp1 = ''
for m.lna=m.lnstart to m.lnstart+3
	m.lctemp2 = substr(m.par_kornd,m.lna,1)
	if isdigit(m.lctemp2)
		m.lctemp1 = m.lctemp1+m.lctemp2
	else
		exit
	endif
endfor
if !empty(m.lctemp1)
	m.lnres = val(m.lctemp1)
else
	m.lnres = 0
endif
return m.lnres
endfunc


****************************************
function str866(nfil)
n_f=fopen(nfil,2)
fseek(n_f,29)
iosb=fwrite(n_f,"e")
fclose(n_f)
return iosb
endproc

* ===================================================
* ïîëó÷èòü âåñ ëèñòîâîãî ìàòåğèàëà óêàçàííîãî ğàçìåğà
function get_ves_by_kodm_ra_rb
lparameters parkodm, parra, parrb
local res
m.res = 0

select * from mater where kodm = parkodm into cursor c113
if reccount()>0
	m.res = parra * parrb * c113.tm * c113.uv / 1000000
endif
use in c113

return m.res
endfunc


* ====================================================
* çàïèñàòü â ôàéë ïğîòîêîëà ñîáûòèå
*   parEvent - òåêñòîâîå ñîîáùåíèå â æóğíàë ïğîòîêîëà
procedure setprot(parEvent)
	local mid,mmachine,mevent,mdt
	* define id
	select id from log order by id into cursor c100
	if reccount()>0
		mid = 1 + c100.id
	else
		mid = 1
	endif
	use in c100
	* define mmachine
	mmachine = sys(0)
	* define mdt
	mdt = datetime()
	* write
	insert into log ;
		(id,machine,event,dt);
		values;
		(mid,mmachine,parEvent,mdt)
endproc 
