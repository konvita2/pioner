proc pz
local partz

do form f_izd_vib_shwz to mshwz

if empt(mshwz)
	return -1
endif

*подготовить справку
create cursor cca ;
	(st c(80))

*
select * from izd where shwz=mshwz into cursor c_izd

partz = c_izd.partz2-c_izd.partz1+1

fl='w.txt'

wait window "Документ формируется..." nowait

set  print to &fl
set  device to print
@prow()+1,0 say '                   ВЕДОМОСТЬ'
@prow()+1,0 say 'прямых затрат на детали и узлы изделия '+c_izd.im
@prow()+1,0 say '--------------------------------------------------------------------------'
@prow()+1,0 say '  №                    Кол-во  Зарплата  Материалы Комплектация    Всего  '
@prow()+1,0 say ' п/п  Деталь(узел)     в узле                                      на ед. '
@prow()+1,0 say '                       (изд.)                                      на изд.'
@prow()+1,0 say '--------------------------------------------------------------------------'
iicena=0
iism  =0
iisp  =0
iina_i=0
npp=0
*wait 'mshwz='+mshwz wind
sele * from KT ;
	where ;
	shw=c_izd.kod and (kodm > 0 and d_u=1 or d_u<>1 and kodm=0) and kol>0 ;
	order by kornd ;
	into curs ckt
scan all
	wait window 'ДЕТАЛЬ (УЗЕЛ) '+ckt.poznd nowait
	scat memv
	ssm=0
	ssp=0

	if m.kodm < m.glMater and m.kodm>0
* sm /обычн/
		sele * from ostatok ;
			where kodm = m.kodm into curs costatok
		if recc() > 0
			if costatok.cena<>0
				ssm = costatok.cena * m.nrmd * m.kol
			else
				insert into cca (st) values ;
					('цена 0  '+ckt.poznd+' '+str(costatok.kodm)+' '+get_mater(costatok.kodm))
			endif
		else
			insert into cca (st) values ;
				('нет     '+ckt.poznd+' '+str(m.kodm)+' '+get_mater(ckt.kodm))
		endif
		use in costatok
	else
		if m.kodm>0
* sp /покуп/
			sele * from ostatok ;
				where kodm = m.kodm into curs costatok
			if reccount()>0
				if costatok.cena<>0
					ssp = costatok.cena * m.kol
				else
					insert into cca (st) values ;
						('цена 0  '+ckt.poznd+' '+str(costatok.kodm)+' '+get_mater(costatok.kodm))
				endif
			else
				insert into cca (st) values ;
					('нет     '+ckt.poznd+' '+str(m.kodm)+' '+get_mater(costatok.kodm))
			endif
			use in costatok
		endif
	endif

	icena=0

	sele * from TE ;
		where ;
		poznd = m.poznd into curs cte
	if recc() > 0
		scan all
			local lnNormw
			m.lnNormw = cte.normw+cte.tpz/(cte.kol*partz)

			tr=m.lnNormw

			sele * from TARIF where VIDTS = cte.setka and RR = cte.RR ;
				into curs CTARIF
			d = 0
			if recc() > 0
				d=dengi
			endif
			use in CTARIF

			cena = tr * d / 60
			icena = icena + cena
*@prow()+1,0 say 'icena= '+str(icena,6,2)+' tr='+str(tr,5,3)+' d='+str(d,6,3)


		endscan
		npp=npp+1
		na_1=icena+ssm+ssp

		if m.kodm >= m.glMater
			m.naimd = substr(get_mater(m.kodm),1,20)
		endif

		@prow()+1,0 say str(npp,3)+' '+m.poznd+' '+str(int(m.kol),3)+' ';
			+str(icena,10,2)+' '+str(ssm,10,2)+' '+str(ssp,10,2)+' ';
			+str(na_1,10,2)
		@prow()+1,4 say left(m.naimd,21)+' '+str(int(m.koli),3);
			+' '+str(icena*m.koli,10,2);
			+' '+str(ssm*m.koli,10,2);
			+' '+str(ssp*m.koli,10,2);
			+' '+str(na_1*m.koli,10,2)
		iicena=iicena+icena*m.koli
		iism  =iism  +ssm   *m.koli
		iisp  =iisp  +ssp   *m.koli
		iina_i=iina_i+na_1 *m.koli
	endif

endscan
use in ckt
use in c_izd
@prow()+3,4 say 'ИТОГО'
@prow(),29 say str(iicena,10,2)+' '+str(iism,10,2)+' '+str(iisp,10,2)+' '+str(iina_i,10,2)

* вывод справки
@prow()+1,1 say ''
@prow()+1,1 say '=========================================================================================='
@prow()+1,1 say 'НЕКОРРЕКТНОСТЬ В ОСТАТКАХ (отсутствует цена или нет в перечне)'
@prow()+1,1 say '=========================================================================================='
select cca
if reccount()>0
	scan all
		@prow()+1,1 say cca.st
	endscan
endif

set printer to
set device to screen
wait window "Формирование документа окончено." nowait
loWord=createobject("Word.Application")
loWord.application.visible=.t.
with  loWord
	.Documents.open(sys(5)+sys(2003)+"\w.txt",.f.,.t.,.f.,'','',.t.,'','',4,1251)
	.DisplayAlerts=.f.
endwith
release loWord
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
