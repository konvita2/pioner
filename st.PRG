proc st
    do form f_izd_vib_shwz to mshwz

    if !empt(mshwz)

        select * from izd where alltrim(shwz) == alltrim(mshwz) into cursor c_izd

        do form f_un with ' по ПРОФЕССИИ  ', 'ПО ОБОРУДОВАНИЮ  ' to p_o

        if p_o = 0
            retu - 1
        endif

        fl='w.txt'

        wait window "Документ формируется..." nowait

        set  print to &fl
        set  device to print
        if p_o=1
            @prow()+1,0 say '                                   УТВЕРЖДАЮ'
            @prow()+1,0 say ' 									Финансовый директор'
            @prow()+1,0 say ' 									ОАО "Дозавтоматика"'
            @prow()+1,0 say ' 									_______________'
            @prow()+1,0 say ' 									"__"__________20__г.'
            @prow()+1,0 say ' '
            @prow()+1,0 say '              СВОДНАЯ ВЕДОМОСТЬ'
            @prow()+1,0 say 'трудоемкости на изделие по ПРОФЕССИЯМ'
            @prow()+1,0 say c_izd.ribf+' '+c_izd.im
            @prow()+1,0 say '---------------------------------------------------------------------'
            @prow()+1,0 say 'Шифр Профессия                              Трудоемкость      З/п на '
            @prow()+1,0 say 'проф                                        ТПЗ        ОП    изделие '
            @prow()+1,0 say '                                            н/ч        н/ч    грн    '
            @prow()+1,0 say '---------------------------------------------------------------------'
            iitpz =0
            iiop  =0
            iicena=0
            *wait 'mshwz='+mshwz wind
            sele * from dosp ;
                where vid=5 and kod>0 ;
                order by im into curs cdosp
            scan all
                wait window 'ПРОФЕССИЯ '+cdosp.im nowait
                sele * from TE ;
                    where kodp = cdosp.kod into curs cte
                if reccount() > 0
                    mpoznd=poznd
                    itpz =0
                    iop  =0
                    icena=0
                    scan all

                        scat memv
                        sele * from kt where ;
                            shw=c_izd.kod and poznd=m.poznd ;
                            into curs ckt
                        if reccount() > 0
                            tr=koli*m.normw
                            sele * from TARIF where VIDTS = cte.setka and RR = cte.RR ;
                                into curs CTARIF
                            d = 0
                            if recc() > 0
                                d = dengi
                            endif
                            use in CTARIF
                            cena=tr*d
                            itpz =itpz +tpz
                            iop  =iop  +tr
                            icena=icena+cena
                        endif
                        use in ckt
                    endscan
                    use in cte
                    if itpz#0.or.iop#0.or.icena#0
                        @prow()+1,0 say str(cdosp.kod,5)+' '+left(cdosp.im,30);
                            +' '+str(itpz,10,2);
                            +' '+str(iop,10,2);
                            +' '+str(icena,10,2)
                    endif
                    iitpz =iitpz +itpz
                    iiop  =iiop  +iop
                    iicena=iicena+icena
                endif

            endscan
            @prow()+3,4 say 'ВСЕГО'
            @prow(),37 say str(iitpz,10,2)+' '+str(iiop,10,2)+' '+str(iicena,10,2)
*!*	            @prow()+3,4 say 'СТОИМОСТЬ 1 ЧАСА'+str(iicena/iiop,10,2)

			@prow()+5,1 say '        Разработал _________________/__________________/'
			@prow()+2,1 say '        Начальник ОТиЗ _____________/__________________/'
			@prow()+2,1 say '        Технолог ОГТ _______________/__________________/'

        else
            @prow()+1,0 say '              СВОДНАЯ ВЕДОМОСТЬ'
            @prow()+1,0 say 'трудоемкости на изделие по ОБОРУДОВАНИЮ'
            @prow()+1,0 say c_izd.ribf+' '+c_izd.im
            @prow()+1,0 say '--------------------------------------------------------------------------------'
            @prow()+1,0 say ' №   Оборудование                                     Трудоемкость         Цена '
            @prow()+1,0 say 'п\п                                                   ТПЗ        ОП             '
            @prow()+1,0 say '--------------------------------------------------------------------------------'

            npp   = 0
            iitpz = 0
            iiop  = 0
            iicena= 0
            *wait 'mshwz='+mshwz wind

            select distinct marka, naim from obor order by marka ;
                into cursor cobor
            *brow
            scan all

                wait window 'ОБОРУДОВАНИЕ '+cobor.marka nowait
                itpz =0
                iop  =0
                icena=0
                sele * from TE ;
                    where kodo = cobor.marka ;
                    into curs cte
                if reccount() > 0
                    itpz =0
                    iop  =0
                    icena=0
                    scan all
                        scat memv
                        sele * from kt ;
                            where ;
                            shw=c_izd.kod and poznd=m.poznd ;
                            into curs ckt
                        if reccount() > 0
                            tr=ckt.koli*m.normw

                            sele * from TARIF where VIDTS = m.setka and RR = m.RR ;
                                into curs CTARIF
                            d = 0
                            if recc() > 0
                                d=dengi
                            endif
                            use in CTARIF

                            cena=tr*d
                            itpz =itpz +tpz
                            iop  =iop  +tr
                            icena=icena+cena
                        endif
                        use in ckt

                    endscan
                    if itpz#0.or.iop#0.or.icena#0
                        npp = npp + 1
                        @prow()+1,0 say str(npp,3) +' '+cobor.marka+' '+cobor.naim+' ';
                            +str(itpz,10,2)+' '+str(iop,10,2)+' '+str(icena,10,2)
                    endif
                    iitpz =iitpz +itpz
                    iiop  =iiop  +iop
                    iicena=iicena+icena

                endif

            endscan
            use in cobor
            if itpz#0.or.iop#0.or.icena#0
                @prow()+1,0 say mkodo+' '+naimp+' ';
                    +str(itpz,10,2)+' '+str(iop,10,2)+' '+str(icena,10,2)
            endif
            @prow()+3,4 say 'ИТОГО'
            @prow(),48 say str(iitpz,10,2)+' '+str(iiop,10,2)+' '+str(iicena,10,2)

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
        use in c_izd
    endif

    retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
