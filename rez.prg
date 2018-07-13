procedure rez
    *LOCAL KT_WW,variant_,y,kolwrad
    publ arra max_no[1]
    publ KT_WW,variant_,y,kolwrad,n_a,n_b
    store 0 to n_a,n_b,variant_
    do form f_un with 'РАССЧИТАТЬ','ПЕЧАТАТЬ ОСТАТКИ' to d_u
    
    granica = 130

    do case
        case	m.d_u = 1
        	do form f_porezka01 with m.granica to m.granica
        	if m.granica >= 0        	
	            do	form_ost
	        endif    
        case	m.d_u = 2
            do	p_o
        case	m.d_u < 1
            return
    endcase
    release KT_WW,variant_,y,kolwrad,n_a,n_b
    return
endproc

***********************************************
* ПЕЧАТЬ ОСТАТКОВ
proc p_o

    fl='rez.txt'

    wait window "Документ формируется..." nowait

    set print to &fl
    set device to print
    @prow()+1,0 say  'ТЕХНОЛОГИЧЕСКИЕ ОСТАТКИ ПО СОСТОЯНИЮ НА '+dtoc(date())
    @prow()+1,0 say  ''
    @prow()+1,0 say  '---------------------------------------------------'
    @prow()+1,0 say  ' N :    N    : Размеры     Bec                     '
    @prow()+1,0 say  'п/п:(остатка):                                     '
    @prow()+1,0 say  '---------------------------------------------------'
    npp=0
    iwes=0

    local svItog,svWes,svFirst,svKol

    sele naim,kodm,tm,uv from mater where sort=1 order by kodm ;
        into curs c_mater
    scan
        m.svFirst = .t.
        m.svItog = 0
        m.svKol = 0
        sele *, ra*rb*c_mater.tm*c_mater.uv/1000000 as wes from ostatki where pri=0 and kod=c_mater.kodm ;
            order by wes ;
            into curs c_ostatki
        if recc() > 0
            @prow()+1,0 say ''
            @prow()+1,0 say str(c_mater.kodm,4)+' '+c_mater.naim
            scan
                npp=npp+1
                scat memv

                * проверяем выводить ли ИТОГИ
                if !m.svFirst .and. round(m.svWes,3) <> round(m.wes,3)
                    * выводим итоги
                    @prow()+1,0 say '       Итого '+str(m.svKol,4)+' шт. '+str(m.svItog,10,3)
                    @prow()+1,0 say ''
                    m.svItog = 0
                    m.svKol = 0
                endif

                *wes=ra*rb*c_mater.tm*c_mater.uv/1000000
                iwes=iwes+wes
                svItog = svItog+wes
                svKol = svKol+1
                m.svWes = wes
                @prow()+1,0 say str(npp,3)+' '+str(m.nlista,5)+' '+str(m.nost,3) ;
                    +' '+rfix(allt(str(ra))+'x'+allt(str(rb)),9) ;
                    +' '+str(wes,8,3)

                m.svFirst = .f.

            endscan

            * выводим итоги
            @prow()+1,0 say '       Итого '+str(m.svKol,4)+' шт. '+str(m.svItog,10,3)
            @prow()+1,0 say '--------------------------------'

            @prow()+1,0 say 'ИТОГО '+space(18)+str(iwes,8,3)

        endif
        use in c_ostatki

    endscan
    use in c_mater
    set print to
    set device to screen
    local loWord
    loWord = createobject ('Word.Application')
    with loWord
        .DOcuments.open(sys(5)+sys(2003)+'\rez.txt',.f.,.f.,.f.,'','',.t.,'','',0,1251)
        .DisplayAlerts = .f.
    endwith
    loWord.visible = .t.
    *loWord.activeWindow.SelectedSheets.PrintPreview
    return

    * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
procedure form_ost

    do form f_un with 'ПО ВСЕМ МАТЕРИАЛАМ','ПО 1 МАТЕРИАЛУ' to wse_1

    if wse_1 < 1
        return -1
    endif

    if wse_1 = 2
        do form f_mater_vib with 'cho' to m.kodm
    endif

    do form f_un with 'ПО СВИ В ЗАПУСКЕ','ПО ПРОИЗВОДСТВУ' to KT_WW

    if KT_WW < 1
        return -1
    endif

    local array max_nozap[1]
    store 0 to max_nozap

    fl='rez.txt'

    wait window "Документ формируется..." nowait

    set print to &fl
    set device to print

    delete from raschet

    * сохранить расчитанные ранее ОСТАТКИ данные
    if file('t_sav')
        delete from t_sav
    endif
    select * from ostatki into table t_sav
    select 0

    npp      = 1
    ikt_wag  = 0
    ikt_nrmd = 0
    ikt_mz   = 0
    n_lista  = 0
    n_nost   = 0

    if wse_1=1
        sele * from mater where sort=1 and kodm>0 and kodm < m.glMater into curs c_mater
    else
        sele * from mater where kodm=m.kodm into curs c_mater
    endif

    scan
        mat_kod = kodm
        mat_kodm = kodm
        mat_naim = naim
        mat_dp = dp
        mat_shp = shp
        ra_=mat_dp
        rb_=mat_shp
        if ra_ = 0 or rb_ = 0   &&должны быть размеры
            wait window 'ПО КОДУ'+' '+str(kodm,4)+' !!! ВВЕДИ РАЗМЕРЫ ЛИСТА ' && NOWAIT
        endif
        
        bil = 0
        if KT_WW = 1
            sele * from KT ;
                where koli > 0 and kodm1 = mat_kodm order by nrmd into curs c_kt
        else
            sele * from WW ;
                where kol-kzp > 0 and kodm = mat_kodm order by nrmd into curs c_kt
        endif
        *brow fiel shw,poznw,poznd,kornd,kodm
        *brow
        scan

            sele * from IZD ;
                where kod = c_kt.shw and !empt(shwz) and !empt(data_p) ;
                into curs c_izd
            * brow
            if recc()> 0
                *BROW
                *   brow fiel poznd,kodm,rozma,rozmb,koli
                *   sele shw,poznd,kornd,kodm,rozma,rozmb,nrmd,koli from kt where ;
                *   order by kodm,nrmd desc into curs ckt
                izd_kod    = kod
                izd_ribf   = ribf
                izd_shwz   = shwz
                izd_partz1 = partz1
                izd_partz2 = partz2
                izd_naim  = im
                * это что-то для печати
                if bil=0
                    do shapka
                endif
                *
                sele c_kt
                * запомнить параметры детали
                if KT_WW = 1
                    kt_poznd = poznd
                    kt_naimd = naimd
                    kt_kornd = kornd
                    kt_kodm = kodm1
                    kt_rozma = rozma
                    kt_rozmb = rozmb
                    if rozma < rozmb
                        kt_rozma = rozmb
                        kt_rozmb = rozma
                    endif
                    kt_kolz = kolZ
                    kt_koliz = koli
                    kt_wag  = wag
                    kt_nrmd = nrmd
                    kt_mz   = mz
                else
                    kt_poznd = poznd
                    kt_kornd = kornd
                    kt_kodm = kodm
                    kt_rozma = rozma
                    kt_rozmb = rozmb
                    if rozma < rozmb
                        kt_rozma = rozmb
                        kt_rozmb = rozma
                    endif
                    kt_kolz = kolZ
                    kt_koliz = KOL-KZP
                    kt_wag  = wag
                    kt_nrmd = nrmd
                    kt_mz   = mz
                endif
                PROGR_=kt_koliz*(izd_partz2-izd_partz1+1)  && сколько нужно деталей для выпуска запланированного объема
                *WAIT WIND '!!!!! 73 '+poznd+' PROGR_='+STR(PROGR_,3)+' rozma='+ALLT(STR(rozma))+' rozmb='+ALLT(STR(rozmb))
                rezat_=PROGR_
                *sele kod,kodm,sort,dp,shp from mater where kodm=kt_kodm and sort=1 ;
                *sele * from ostatki where ;
                *            kod=mat_kod and ra>kt_rozma and rb>kt_rozmb into curs cost
                do while .t.
                	* выбираем непорезанные остатки где есть запас 130 мм по ширине и длине                	
                    sele * from ostatki ;
                        where kod = mat_kod and ra-m.granica > kt_rozma and rb-m.granica > kt_rozmb and pri = 0 ;
                        into curs c_ostatki
                    * если таких остатков несколько, попадаем только на первый (??? это правильно)   
                    go top
                    if .not.eof() && ...и вообще - если такое остаток есть
                        update ostatki set pri=1 where nozap=c_ostatki.nozap  && помечаем остаток как порезанный
                        ra_=c_ostatki.ra
                        rb_=c_ostatki.rb
                        n_lista=c_ostatki.nlista
                        n_nost =c_ostatki.nost
                        *wait wind '92 выборка с остатков RA_='+ALLT(STR(RA_))+' rb_='+ALLT(STR(RB_)) ;
                        * +' rozma='+ALLT(STR(kt_rozma))+' rozmb='+ALLT(STR(kt_rozmb))
                        *update ostatki set pri=1 where nlista=cost.nlista and nost=cost.nost
                    else && а если такого остатка нет...
                        publ arra max_nl[1]
                        store 0 to max_nl
                        * получаем новый номер листа (??? как же другие материалы)
                        select * from raschet into cursor c_n_lista
                        if reccount() > 0
                            sele max(nlista) from raschet into array max_nl
                            n_lista=max_nl[1]+1
                        else
                            n_lista=1
                        endif
                        use in c_n_lista
						*
                        n_nost = 0 			&& номер остатка
                        ra_ = mat_dp		&& размер из спр-ка материалов
                        rb_ = mat_shp
                        && это - ошибка в данных: подобран материал из которого невозможно вырезать заготовку
                        if ra_ < kt_rozma .or. rb_ < kt_rozmb
                            wait  'НЕПРИЕМЛЕМЫЕ РАЗМЕРЫ ЗАГОТОВКИ ' wind
                            wait wind 'МАТЕРИАЛ  RA_='+allt(str(mat_dp))+' rb_='+allt(str(mat_shp)) ;
                                +' ЗАГОТОВКА rozma='+allt(str(kt_rozma))+' rozmb='+allt(str(kt_rozmb))

                            return -1
                        endif
                        *   wait wind '200 выборка с листа  RA_='+ALLT(STR(mat_dp))+' rb_='+ALLT(STR(mat_shp)) ;
                        *    +' rozma='+ALLT(STR(kt_rozma))+' rozmb='+ALLT(STR(kt_rozmb))
                    endif
                    use in c_ostatki
                    n_a=0
                    RA_1=0
                    RB_1=0
                    RA_2=0
                    RB_2=0
                    RA_3=0
                    RB_3=0
                    Rx_1=0
                    Ry_1=0			&& координаты
                    Rx_2=0
                    Ry_2=0
                    Rx_3=0
                    Ry_3=0
                    n1a=0
                    n2a=0
                    vari='nou'
                    rez_=''
                    * вычислить n_a и n_b
                    n1a=int(ra_/kt_rozma)   && целое число заготовок из остатка
                    n2a=int(rb_/kt_rozmb)
                    n_a=n1a*n2a				&& всего можно вырезать заготовок с листа
                    N1b=int(rb_/kt_rozma)
                    N2b=int(ra_/kt_rozmb)
                    n_b=N1b*N2b                    
                    * определяем вид реза
                    if n_a > n_b
                    	rez_ = 'a'
                    else
                    	rez_ = 'b'
                    endif		                    
                    * определяем расположение
                    if rez_ = 'a'    && РЕЗКА ПО ДЛИНЕ
                        ***	1 заготовка с листа
                        *** ??? выходит, что мы определяем не сколько нужно, а сколько можно вырезать
                        if rezat_ = 1
                        	* debug
                            * wait window 'variant=1 ПО ДЛИНЕ'
                            variant_ = 1
                            vari = 'yes' && ??? 
                            RA_1 = ra_ - kt_rozma   &&1-й отход
                            Rx_1 = kt_rozma
                            RB_1 = kt_rozmb
                            Ry_1 = 0
                            RA_2 = ra_             && 2-й отход
                            Rx_2 = 0
                            RB_2 = rb_- kt_rozmb
                            Ry_2 = kt_rozmb
                        endif
                    else					&&	РЕЗКА ПО ШИРИНЕ
                        * wait wind '307 N_B='+allt(str(n_b)
                        if rezat_ = 1
                            * wait window 'variant=1 ПО ширине'
                            variant_=1
                            vari='yes'
                            RA_1 = ra_- kt_rozmb   &&1-й отход
                            Rx_1 = kt_rozmb
                            RB_1 = kt_rozma 
                            Ry_1 = 0
                            RA_2 = ra_             && 2-й отход
                            Rx_2 = 0
                            RB_2 = rb_ - kt_rozma
                            Ry_2 = kt_rozma
                        endif
                    endif
                    * заготовок  > 1
                    if vari='nou'
                        ***	больше 1 заготовка в 1 ряду
                        *** 2 variant
                        *** c 1 листа или остатка несколько деталей в 1 ряду и всего 1 ряд


                        if rez_ ='a'				   && РЕЗКА ПО ДЛИНЕ

                            n1a=int(ra_/kt_rozma)
                            n2a=int(rb_/kt_rozmb)
                            n_a=n1a*n2a

                            y = kt_rozma * kt_koliz / ra_
                            if y < 1
                                * wait window 'variant=2 ПО ДЛИНЕ'
                                variant_=2
                                kolwrad = int(ra_ / kt_rozma)					&& кол_во деталей в 1 ряду
                                RA_1 = ra_ - rezat_ * kt_rozma   &&1-й отход
                                RB_1 = kt_rozmb
                                RA_2 = ra_             && 2-й отход
                                RB_2 = rb_-kt_rozmb
                                Rx_1 = kt_rozma * rezat_  &&1-й отход
                                Ry_1 = 0
                                Rx_2 = 0             && 2-й отход
                                Ry_2 = kt_rozmb
                            else
                            	*
                                if mod(rezat_,n1a) = 0
	                                *
	                                y = rezat_ / n1a
	                            	*	                            	
                                    variant_=3
                                    *** 3 variant
                                    *** несколько рядов и они полные
                                    * wait window 'variant=3 ПО ДЛИНЕ'
                                    *y = int(kt_rozma * kt_koliz / ra_)
                                    RA_1 = ra_- n1a * kt_rozma && 1-й отход
                                    RB_1 = kt_rozmb * y
                                    RA_2 = ra_             && 2-й отход
                                    RB_2 = rb_- kt_rozmb * y
                                    Rx_1 = kt_rozma * rezat_ / y  && 1-й отход
                                    Ry_1 = 0
                                    Rx_2 = 0            && 2-й отход
                                    Ry_2 = kt_rozmb * y
                                else
                                    variant_=4
                                    *** 	4  variant
                                    *** несколько рядов и последний ряд неполный
                                    * wait window 'variant=4 ПО ДЛИНЕ'
                                    kolwrad = int(ra_ / kt_rozma)					&& кол_во деталей в 1 ряду
                                    kolne   = kt_koliz - (kolwrad * int(y)) 	&& кол_во деталей в последнем ряду
                                    RA_1 = ra_- kt_rozma * kolwrad  				&& 1-й отход
                                    RB_1 = kt_rozmb * int(y)
                                    RA_3 = ra_              && 3-й отход
                                    RB_3 = rb_ - kt_rozmb * int(y+1)
                                    Rx_1 = kt_rozma * kolwrad  && 1-й отход
                                    Ry_1 = 0
                                    Rx_3 = 0            && 3-й отход
                                    Ry_3 = kt_rozmb * int(y + 1)
                                    RA_2 = ra_ - kt_rozma*kolne                                && 2-й отход
                                    *RB_2 = rb_ - kt_rozmb * int(y + 1)
                                    RB_2 = kt_rozmb
                                    Rx_2 = kt_rozma * kolne
                                    Ry_2 = kt_rozmb * int(y)
                                endif
                            endif
                        else
&&	РЕЗКА ПО ШИРИНЕ
                            N1b=int(rb_/kt_rozma)
                            N2b=int(ra_/kt_rozmb)
                            n_b=N1b*N2b
                            y = (kt_rozma * kt_koliz)/rb_
                            kolwrad = int(rb_ / kt_rozma)					&& кол_во деталей в 1 ряду
                            if y < 1

                                variant_=2
                                * wait window 'variant=2 ПО шир'
                                RA_1= ra_ - kt_rozmb   &&1-й отход
                                RB_1= kt_rozma * rezat_
                                RA_2=ra_             && 2-й отход
                                RB_2= rb_- kt_rozma * rezat_
                                Rx_1 = kt_rozmb  &&1-й отход
                                Ry_1 = 0
                                Rx_2 = 0             && 2-й отход
                                Ry_2 = kt_rozma * rezat_
                            else
                                if mod(rezat_,n1b) = 0
                                    variant_=3
                                    *** 3 variant
                                    *** несколько рядов и они полные
                                    * wait window 'variant=3 ПО ширине'
                                    y = int(kt_rozmb * kt_koliz / ra_)
                                    kolwrad = int(rb_ / kt_rozma)
                                    RA_1 = ra_ - kt_koliz/kolwrad * kt_rozmb   && 1-й отход
                                    RB_1 = kt_rozma * kolwrad
                                    RA_2 = ra_             && 2-й отход
                                    RB_2 = rb_- N1b * kt_rozma
                                    Rx_1 = kt_rozmb * (kt_koliz / kolwrad)  && 1-й отход
                                    Ry_1 = 0
                                    Rx_2 = 0            && 2-й отход
                                    Ry_2 = kt_rozma * N1b
                                else
                                    variant_=4
                                    *** 	4  variant
                                    *** несколько рядов и последний ряд неполный
                                    * wait window 'variant=4 ПО шириНЕ'
                                    kolwrad = int(rb_ / kt_rozma)
                                    kolne   = kt_koliz - (kolwrad * int(y))

                                    RA_1 = ra_- kt_rozmb * int(y + 1)  				&& 1-й отход
                                    RB_1 = kt_rozma * kolne
                                    RA_2 = ra_ - kt_rozmb * int(y)             && 2-й отход
                                    RB_2 = (kolwrad - kolne) * kt_rozma
                                    RA_3 = ra_                                 && 3-й отход
                                    RB_3 = rb_ - kt_rozma * kolwrad
                                    * координаты
                                    Rx_1 = ra_ - RA_1 && 1-й отход
                                    Ry_1 = 0
                                    Rx_2 = ra_ - RA_2
                                    Ry_2 = RB_1
                                    Rx_3 = 0            && 2-й отход
                                    Ry_3 = RB_1 + RB_2
                                endif
                            endif
                        endif
                    endif
                    *!*	            IF ra_ > KT_ROZMA AND rb_ > KT_ROZMB    && РЕЗКА ПО ДЛИНЕ    аҐ§Є  Ї® ¤«Ё­Ґ
                    *!*	*!*	               N1a=int((ra_-130)/KT_ROZMA)
                    *!*	*!*	               N2a=int((rb_-130)/KT_ROZMB)
                    *!*	               N_A=N1a*N2a
                    *!*	               N1a=int(ra_/KT_ROZMA)
                    *!*	               N2a=int(rb_/KT_ROZMB)
                    *!*	               *wait wind '219 N_A='+ALLT(STR(N_A))
                    *!*	               *if n_a=0
                    *!*	               *   wait wind '120 N1A='+ALLT(STR(N1A))+' = ra_-130 '+ALLT(STR(ra_-130))+' / kt_rozma '+ALLT(STR(kt_rozma))
                    *!*	               *   wait wind '121 N2A='+ALLT(STR(N2A))+' = rb_-130 '+ALLT(STR(rb_-130))+' / kt_rozmb '+ALLT(STR(kt_rozmb))
                    *!*	               *   wait wind '122 N1A='+ALLT(STR(N1A))+' N2A='+ALLT(STR(N2A))+' N_A='+ALLT(STR(N_A))
                    *!*	               *endif
                    *!*	            endif
                    *!*	            n_b=0
                    *!*	            n1b=0
                    *!*	            n2b=0
                    *!*	            IF rb_ > KT_ROZMA AND ra_ > KT_ROZMB     && РЕЗКА ПО ШИРИНЕ 	аҐ§Є  Ї® иЁаЁ­Ґ
                    *!*	*!*	               N1b=int((rb_-130)/kt_ROZMA)
                    *!*	*!*	               N2b=int((ra_-130)/kt_ROZMB)
                    *!*						N1b=int(rb_/kt_ROZMA)
                    *!*	               N2b=int(ra_/kt_ROZMB)
                    *!*	               N_b=N1b*N2b
                    *!*	               *wait wind '233 N_B='+ALLT(STR(N_B))
                    *!*	               *if n_b=0
                    *!*	               *   wait wind '133 N1b='+ALLT(STR(N1b))+' = ra_-130 '+ALLT(STR(rb_-130))+' / kt_rozma '+ALLT(STR(kt_rozma))
                    *!*	               *   wait wind '134 N2b='+ALLT(STR(N2b))+' = rb_-130 '+ALLT(STR(rb_-130))+' / kt_rozmb '+ALLT(STR(kt_rozmb))
                    *!*	               *   wait wind '135 N1B='+ALLT(STR(N1B))+' N2B='+ALLT(STR(N2B))+' N_B='+ALLT(STR(N_B))
                    *!*	               *endif
                    *!*	            endif
                    w_r=iif(n_a>n_b,'w_a','w_b')  && вариант расчета
                    MAX_KOL=iif(n_a>n_b,n_a,n_b)  && max_kol макс. кол-во усл.заготовок с листа
                    if MAX_KOL=0
                        * wait wind '141 вариант расчета'+w_r;
                            +' max_kol='+allt(str(MAX_KOL));
                            +' rezat_='+allt(str(rezat_))
                        retu-1
                    endif
                    ****
                    if w_r == 'w_a'
                    	kolr = rezat_/n1a
                    else
                    	kolr = rezat_/n1b
                    endif	                    	
                    ****
                    if kolr > 1                     
*!*		                    if w_r='w_a'
*!*		                        **************  РЕЗ ПО ДЛИНЕ ЗАГОТОВКИ
*!*		                        if MAX_KOL < rezat_
*!*		                            rezat_=rezat_-MAX_KOL
*!*		                            koli_=MAX_KOL && rezat_
*!*		                            *AIT WIND '!!! 136 A max_kol<rezat_='+str(max_kol)+'<'+str(rezat_)
*!*		                            * есть ли остатки после резки полного листа
*!*		                            RA_1=ra_-n1a*kt_rozma   &&1-й отход
*!*		                            RB_1=kt_rozmb*n2a
*!*		                            RA_2=ra_             && 2-й отход
*!*		                            RB_2=rb_-n2a*kt_rozmb
*!*		                            **  переход на новый лист или отходы -KOLI=N_A или N_B
*!*		                            *WAIT WIND '146 ra_1='+STR(ra_1,5);
*!*		                            *        +' ra_1='+STR(ra_1,5);
*!*		                            *        +' rb_1='+STR(rb_1,5);
*!*		                            *        +' ra_2='+STR(ra_2,5);
*!*		                            *        +' rb_2='+STR(rb_2,5)
*!*		                        else
*!*		                            kolo=iif(mod(rezat_,n1a)>0,1,0)
*!*		                            kol_r=int(rezat_/n1a)+kolo        && kol_r количество рядов
*!*		                            *WAIT WIND '154 KOL_R=INT(rezat_/N1a)+kolo ';
*!*		                            *     +ALLT(STR(KOL_R))+'= rezat_ '+ALLT(STR(rezat_)) ;
*!*		                            *     +' n1a '+ALLT(STR(n1a)) ;
*!*		                            *     +' kolo '+ALLT(STR(kolo))
*!*		                            kol_d_wnzr=(n1a+rezat_)-kol_r*n1a  && kol_d_wnzr  кол-во в                            
*!*		                            *  неполностью резаном ряде
*!*		                            *kol_d_wnzr= kol_r*n1a - rezat_
*!*		                            *WAIT WIND ' 160 N1a='+str(n1a,2) ;
*!*		                            *       +' rezat_='+STR(rezat_,2);
*!*		                            *       +'kol_r='+str(kol_r,2);
*!*		                            *       +' !!!'+str(kol_d_wnzr,2)
*!*		                            if n1a = rezat_
*!*		                                RA_1=ra_-n1a*kt_rozma   &&1-й отход
*!*		                                RB_1=kt_rozmb
*!*		                                ***** koli=rezat_  на новый лист(остаток) не переходим
*!*		                                RB_3= rb_-kt_rozmb    &&  3-й отход
*!*		                                RA_3=ra_
*!*		                                *WAIT WIND '170 N1a=rezat_'+str(n1a,2) ;
*!*		                                *     +' ra_1='+STR(ra_1,5);
*!*		                                *     +' rb_1='+STR(rb_1,5);
*!*		                                *     +' ra_3='+STR(ra_3,5);
*!*		                                *     +' rb_3='+STR(rb_3,5);
*!*		                                *     +' rezat_='+STR(rezat_,2)
*!*		                                koli_=rezat_
*!*		                                rezat_=0
*!*		                            endif
*!*		                            if n1a < rezat_
*!*		                                *WAIT WIND '!!!!! 180 n1a< rezat_' ;
*!*		                                *     +' N1a='+allt(str(n1a)) ;
*!*		                                *     +' rezat_='+allt(str(rezat_))
*!*		                                RA_1=ra_-n1a*kt_rozma   &&1-й оход
*!*		                                RB_1=kol_r*kt_rozmb
*!*		                                kol_d_wnzr=(n1a+rezat_)-kol_r*n1a  && kol_d_wnzr  кол-во
*!*		                                *rezat_= n1a*kol_r -rezat_ -N1a+kol_d_wnzr
*!*		                                koli_=PROGR_-rezat_
*!*		                                rezat_=0
*!*		                                *WAIT WIND '!!!!! 189 ' ;
*!*		                                *     +' rezat_='+allt(str(rezat_)) ;
*!*		                                *     +' =  n1a*kol_r '+allt(str(n1a)) ;
*!*		                                *     +'*'+ allt(str(n1a*kol_r)) ;
*!*		                                *     +' kol_d_wnzr '+ALLT(STR(kol_d_wnzr))
*!*		                                *if last()=27
*!*		                                *   retu
*!*		                                *endif
*!*		                                RA_2=ra_-(kol_d_wnzr*kt_rozma)-(ra_-n1a*kt_rozma)    && 2-й отход
*!*		                                RB_2=kt_rozmb
*!*		                                RB_3= rb_-kol_r*kt_rozmb    &&  3-й отход
*!*		                                RA_3=ra_
*!*		                                *WAIT WIND '201 ';
*!*		                                *     +' ra_1='+allt(STR(ra_1));
*!*		                                *     +' rb_1='+allt(STR(rb_1));
*!*		                                *     +' ra_2='+allt(STR(ra_2));
*!*		                                *     +' rb_2='+allt(STR(rb_2));
*!*		                                *     +' ra_3='+allt(STR(ra_3));
*!*		                                *     +' rb_3='+allt(STR(rb_3))
*!*		                            endif
*!*		                            if n1a > rezat_ and rezat_ > 0
*!*		                                RA_1=ra_-rezat_*kt_rozma   &&1-й отход
*!*		                                RB_1=rezat_*kt_rozmb
*!*		                                RB_3= rb_-rezat_*kt_rozmb    &&  3-й  отход
*!*		                                RA_3=ra_
*!*		                                ***** koli=rezat_ на новый лист(остаток) не переходим
*!*		                                koli_=rezat_
*!*		                                rezat_=0
*!*		                                *WAIT WIND '217 N1a>rezat_'+str(n1a,2) ;
*!*		                                *     +' ra_1='+allt(STR(ra_1));
*!*		                                *     +' rb_1='+allt(STR(rb_1));
*!*		                                *     +' ra_3='+allt(STR(ra_3));
*!*		                                *     +' rb_3='+allt(STR(rb_3))
*!*		                            endif
*!*		                        endif
*!*		                    else
*!*		                        **********    РЕЗ ПО ШИРИНЕ ЗАГОТОВКИ
*!*		                        if MAX_KOL<= rezat_
*!*		                            rezat_=rezat_-MAX_KOL
*!*		                            koli_=MAX_KOL && rezat_
*!*		                            *AIT WIND '226 b max_kol<=rezat_='+str(max_kol)+'<'+str(rezat_)
*!*		                            * есть ли остатки после резки полного листа
*!*		                            RA_1=ra_-N2b*kt_rozmb   &&1-й отход
*!*		                            *WAIT WIND '232 ra_1='+allt(str(ra_1)) ;
*!*		                            *        +' =  ra_='+allt(STR(ra_));
*!*		                            *        +'   n1b='+allt(STR(n2b));
*!*		                            *        +'   kt_rozmb='+allt(STR(kt_rozmb))
*!*		                            RB_1=kt_rozma*N1b
*!*		                            *WAIT WIND '237 rb_1='+allt(str(rb_1)) ;
*!*		                            *        +'   kt_rozma='+allt(STR(kt_rozma));
*!*		                            *        +'   n1b='+allt(STR(n2b))
*!*		                            RA_2=ra_             && 2-й отход
*!*		                            *WAIT WIND '241 ra_2='+allt(str(ra_2)) ;
*!*		                            *        +'   ra_='+allt(STR(ra_))
*!*		                            RB_2=rb_-N1b*kt_rozma
*!*		                            *WAIT WIND '244 rb_2='+allt(str(rb_2)) ;
*!*		                            *        +' rb_='+allt(STR(rb_));
*!*		                            *        +' n1b='+allt(STR(n1b));
*!*		                            *        +' kt_rozma='+allt(STR(kt_rozma))
*!*		                            ***  переход на новый лист или отход  -KOLI=N_A или N_B
*!*		                        else
*!*		                            kolo=iif(mod(rezat_,N2b)>0,1,0)
*!*		                            kol_r=int(rezat_/N2b)+kolo    && kol_r кол-во рядов
*!*		                            *WAIT WIND '252 KOL_R=INT(rezat_/N2b)+kolo '+ALLT(STR(KOL_R))+'= rezat_ '+ALLT(STR(rezat_)) ;
*!*		                            *                  +' n1b '+ALLT(STR(n2b))+' kolo '+ALLT(STR(kolo))
*!*		                            kol_d_wnzr=(N2b+rezat_)-kol_r*N2b  && kol_d_wnzr  кол-во заготовок в незаконченном ряде
*!*		                            *WAIT WIND '255 N2b='+str(n2b,2) ;
*!*		                            *       +'rezat_='+str(rezat_,2);
*!*		                            *       +'kol_r='+str(kol_r,2);
*!*		                            *       +'!!! '+str(kol_d_wnzr,2)
*!*		                            if N2b=rezat_
*!*		                                RA_1=ra_-N2b*kt_rozmb   &&1-й отход
*!*		                                RB_1=kt_rozma
*!*		                                RB_3= rb_-kt_rozma    &&  3-й отход
*!*		                                RA_3=ra_
*!*		                                *WAIT WIND '264 N2b=rezat_'+str(n2b,2) ;
*!*		                                *        +' ra_1='+STR(ra_1,5);
*!*		                                *        +' rb_1='+STR(rb_1,5);
*!*		                                *        +' ra_3='+STR(ra_3,5);
*!*		                                *        +' rb_3='+STR(rb_3,5)
*!*		                                koli_=rezat_
*!*		                                rezat_=0
*!*		                            endif
*!*		                            if N2b<rezat_
*!*		                                RA_1=ra_-N2b*kt_rozmb   &&1-й отход
*!*		                                RB_1=kol_r*kt_rozma
*!*		                                kol_d_wnzr=(N2b+rezat_)-kol_r*N2b  && kol_d_wnzr  кол-во;
*!*		                                    RA_2=ra_-(kol_d_wnzr*kt_rozmb)-(ra_-N2b*kt_rozmb)    && 2-й отход
*!*		                                RB_2=kt_rozma
*!*		                                RB_3= rb_-kol_r*kt_rozma    &&  3-й отход
*!*		                                RA_3=ra_
*!*		                                koli_=rezat_
*!*		                                rezat_=0 &&rezat_ - n2b*kol_r - kol_d_wnzr
*!*		                                *WAIT WIND '282 N2b<rezat_'+str(n2b,2) ;
*!*		                                *        +' ra_1='+STR(ra_1,5);
*!*		                                *        +' rb_1='+STR(rb_1,5);
*!*		                                *        +' ra_2='+STR(ra_2,5);
*!*		                                *        +' rb_2='+STR(rb_2,5);
*!*		                                *        +' ra_3='+STR(ra_3,5);
*!*		                                *        +' rb_3='+STR(rb_3,5);
*!*		                                *        +' kol_d_wnzr ='+ALLT(STR(kol_d_wnzr))
*!*		                            endif
*!*		                            if N2b > rezat_ and rezat_ > 0
*!*		                                RA_1=ra_-rezat_*kt_rozmb   &&1-й отход
*!*		                                *WAIT WIND '293 RA_1=ra_-rezat_*kt_ROZMB ';
*!*		                                *        +' ra_1='+allt(STR(ra_1));
*!*		                                *        +' ra_='+allt(STR(ra_));
*!*		                                *        +' n2b='+allt(STR(n2b));
*!*		                                *        +' kt_rozmb='+allt(STR(kt_rozmb))

*!*		                                RB_1=kt_rozma
*!*		                                RB_3= rb_-kt_rozma    &&  3-й отход
*!*		                                RA_3=ra_
*!*		                                *WAIT WIND '302 N1a>rezat_'+str(n1a,2) ;
*!*		                                *        +' ra_1='+STR(ra_1,5);
*!*		                                *        +' rb_1='+STR(rb_1,5);
*!*		                                *        +' ra_3='+STR(ra_3,5);
*!*		                                *        +' rb_3='+STR(rb_3,5)
*!*		                                koli_=rezat_
*!*		                                rezat_=0
*!*		                            endif
*!*		                        endif
*!*		                    endif
			            koli_ = rezat_
	                    rezat_ = 0
	                else    
	                    koli_ = rezat_
	                    rezat_ = 0
	                endif    
                    do write_
                    if rezat_=0
                        exit
                    endif
                enddo
            endif
            use in c_izd

        endscan
        use in c_kt

    endscan
    use in c_mater
    @prow()+1,0 say 'ИТОГО КИС(по нормативу) '+str(roun(ikt_wag/ikt_nrmd,3),5,3)
    @prow()+1,0 say        ' '+'Масса по КД '+str(ikt_wag,8,3)
    @prow()+1,0 say        ' '+'Расход нормативный'+str(ikt_nrmd,8,3)
    @prow()+1,0 say        ' '+'Масса заготовок '+str(ikt_mz,8,3)
    clos data
    s_listow=0
    s_zag   =0
    w_listow=0
    w_zag   =0
    sele nlista,nost,kod from raschet where nost=0 into curs c_list
    scan
        nlista_=nlista
        kod_=kod
        sele kodm,dp,shp,tm,uv from mater where kodm=kod_ into curs c_MAT
        uv_mat=0
        if recc() > 0
            *brow
            s_mat=dp*shp
            wag_mat=dp*shp*tm*uv/1000000
            *wait  'wag_mat=dp*shp*tm*uv/1000000 ='+str(wag_mat,8,3) ;
            *                                   +' '+str(dp,4) ;
            *                                   +' '+str(shp,4) ;
            *                                   +' '+str(tm,5,2) ;
+ ' '+str(uv,3) wind
            uv_mat=uv
            w_listow=w_listow+wag_mat
            *wait  'Норма расхода по факту ='+str(w_listow,8,3)
        endif
        use in c_MAT
        sele rozma,rozmb,koli,nlista from raschet where nlista=nlista_ into curs c_ost_sum
        sum rozma*rozmb*koli to s1_zag
        wag_zag= s1_zag*uv_mat/1000000
        use in c_ost_sum
        s_listow=s_listow+s_mat
        s_zag   =s_zag   +s1_zag
        w_zag   =w_zag   +wag_zag

    endscan
    use in c_list
    @prow()+1,0 say 'Норма расхода по факту '+str(w_listow,8,3)
    *@prow()+1,0 say '«листов   площадь  '+str(s_listow,8,3)+' ўҐб '+str(w_listow,8,3)
    *@prow()+1,0 say 'заготовок площадь  '+str(s_zag,8,3)+' ўҐб '+str(w_zag,8,3)
    @prow()+1,0 say 'КИС по факту '+str(ikt_wag/w_listow,8,3)
    *use in cizd
    set print to
    set device to screen
    local loWord
    loWord = createobject ('Word.Application')
    with loWord
        .DOcuments.open(sys(5)+sys(2003)+'\rez.txt',.f.,.f.,.f.,'','',.t.,'','',0,1251)
        .DisplayAlerts = .f.
    endwith
    loWord.visible = .t.
    *loWord.activeWindow.SelectedSheets.PrintPreview
    *on key

    local lcMsg
    m.lcMsg = 	'Принять расчитанные значения? '+;
        'Если вы ответите ДА, предыдущие данные будут утеряны?'
    if messagebox(m.lcMsg,4,'ПОДТВЕРДИТЕ!') = 6

    else
        delete from ostatki
        use ostatki again
        append from t_sav
        use
    endif

    return


    * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc write_
	local lbFound,a1[1],mrx,mry
    store 0 to max_no
    select * from ostatki into cursor C_N_OST
    *browse
    if reccount()>0
        sele max(nost) from ostatki where nlista=n_lista into array max_no
        * wait window '766 max_no='+str(max_no[1])
        *n_nost =max_no[1]+1
    else
        n_nost=0
    endif
    * wait window '770 N_NOST='
    * wait window '770 n_NOST='+str(n_nost)
    use in C_N_OST
    
    ****
    
    *!*	SELE * FROM RASCHET INTO CURS CRAS
    *!*	SCAT MEMV BLAN
    *!*	USE IN CRAS
    *npp=npp+1
    *!*	   M.DATR=DATE()
    *!*	   M.NLISTA=n_lista
    *!*	   WAIT WINDOW '11111!!!!! N_NOST'+STR(N_NOST)

    *!*
    *!*	   M.NOST =n_nost
    *!*	      WAIT WINDOW '11111!!!!! M.NOST'+STR(M.NOST)
    *!*	   M.KORND=KT_KORND
    *!*	   M.KOD  =MAT_KOD
    *!*	   M.ROZMA=KT_ROZMA
    *!*	   M.ROZMB=KT_ROZMB
    *!*	   M.rezat=rezat_
    *!*	   M.SHWZ =IZD_SHWZ
    *!*	   m.progr=progr_
    *!*	   M.KOLi =koli_
    *!*	   M.RA   =ra_
    *!*	   M.Rb   =rb_
    *!*	   *m.pri  =???
    m.usl  =iif(n_a>n_b,1,2)
    * pri = ?????
    *shw  = ?????
    *mkod = ?????
    * 
	select * from ostatki where kod=mat_kod and nlista = n_lista and nost = n_nost ;
		into cursor temp001
	if reccount()>0
		mrx = temp001.rx
		mry = temp001.ry
		lbFound = .t.
	else
		mrx = 0
		mry = 0
		lbFound = .f.
	endif		
	use in temp001	    
	*    
    insert into  raschet (DATR, nlista,  nost,   kornd,    kod,   rozma,   rozmb,progr, koli,     shwz,   kolZ,ra, rb,   usl,  variant,rx,ry) ;
        values 	      (date(),n_lista,n_nost,kt_kornd,mat_kod,kt_rozma,kt_rozmb,PROGR_,koli_,izd_shwz,kt_kolz,ra_,rb_,m.usl,variant_,mrx,mry)
    ikt_wag  =ikt_wag  +kt_wag *koli_
    ikt_nrmd =ikt_nrmd +kt_nrmd*koli_
    ikt_mz   =ikt_mz   +kt_mz  *koli_
    
    ********************
    * пишем изменения по порезанному листу
    if lbFound 
    	* просто меняем признак
    	update ostatki set pri=1 where kod = mat_kod and nlista = n_lista and nost = n_nost    
    	* nozap
    	select * from ostatki ; 		    
    		where kod = mat_kod and nlista = n_lista and nost = n_nost ;
    		into cursor temp001
    	if reccount()>0
    		m.nozap = temp001.nozap
    	else
    		m.nozap = 1
    	endif	
    	use in temp001	
    else
    	m.nozap=1
    	* ищем новый nozap
    	select * from ostatki into cursor temp001
    	if reccount()>0
    		select max(nozap) from ostatki into array a1
    		m.nozap = a1[1]+1
    	else
    		m.nozap = 1
    	endif
    	use in temp001
    	* пишем новый остаток
    	insert into ostatki ;
    		(nozap,dat_o,kod,ra,rb,nlista,nost,pri,rx,ry) ;
    		values ;
    		(m.nozap,date(),mat_kod,ra_,rb_,n_lista,n_nost,1,0,0)    	    
    endif
    
    ********************
    * 1-й ост
    m.n_nost = m.n_nost+1
    if RA_1 > m.granica and RB_1 > m.granica
    	* размеры
    	if RA_1 > RB_1
    		m.ra = RA_1
    		m.rb = RB_1
    	else
    		m.ra = RB_1
    		m.rb = RA_1
    	endif
    	*
    	m.nozap = m.nozap+1
    	insert into ostatki ;
    		(nozap,dat_o,kod,ra,rb,nlista,nost,pri,rx,ry);
    		values;
    		(m.nozap,date(),mat_kod,m.ra,m.rb,n_lista,n_nost,0,Rx_1,Ry_1) 
    	**** записать в отчет	   
	    @prow()+1,0 say str(npp,3)+' '+str(n_lista,5)+' '+str(n_nost,3)+' '+rfix(allt(str(ra_))+'x';
	    	+allt(str(rb_)),9) ;
	        +' '+izd_ribf+' '+izd_shwz+' '+kt_poznd+' '+kt_kornd+' '+str(PROGR_,3)+' '+str(koli_,3) ;
	        +'    '+rfix(allt(str(kt_rozma))+'x'+allt(str(kt_rozmb)),9) 	;
	        +iif(RA_1>m.granica and RB_1>m.granica, ;
	        +' '+rfix(allt(str(RA_1))+'x'+allt(str(RB_1)),9);
	        +str(n_lista,5)+' '+str(n_nost,3),'')
	    @prow()+1,12 say ' '+izd_naim+' '+kt_naimd	    
	    npp = npp+1
    endif
    
    ********************
    * 2-й ост
    m.n_nost = m.n_nost+1
    if RA_2 > m.granica and RB_2 > m.granica
    	* размеры
    	if RA_2 > RB_2
    		m.ra = RA_2
    		m.rb = RB_2
    	else
    		m.ra = RB_2
    		m.rb = RA_2
    	endif
    	*
    	m.nozap = m.nozap+1
    	insert into ostatki ;
    		(nozap,dat_o,kod,ra,rb,nlista,nost,pri,rx,ry);
    		values;
    		(m.nozap,date(),mat_kod,m.ra,m.rb,n_lista,n_nost,0,Rx_2,Ry_2)    
    	**** записать в отчет	   
	    @prow()+1,0 say str(npp,3)+' '+str(n_lista,5)+' '+str(n_nost,3)+' '+rfix(allt(str(ra_))+'x';
	    	+allt(str(rb_)),9) ;
	        +' '+izd_ribf+' '+izd_shwz+' '+kt_poznd+' '+kt_kornd+' '+str(PROGR_,3)+' '+str(koli_,3) ;
	        +'    '+rfix(allt(str(kt_rozma))+'x'+allt(str(kt_rozmb)),9) 	;
	        +iif(RA_2 > m.granica and RB_2 > m.granica, ;
	        +' '+rfix(allt(str(RA_2))+'x'+allt(str(RB_2)),9);
	        +str(n_lista,5)+' '+str(n_nost,3),'')
	    @prow()+1,12 say ' '+izd_naim+' '+kt_naimd	    
	    npp = npp+1
    endif
    
    ********************
    * 3-й ост (если есть)
    * ....
    m.n_nost = m.n_nost+1
    if RA_3 > m.granica and RB_3 > m.granica
    	* размеры
    	if RA_3 > RB_3
    		m.ra = RA_3
    		m.rb = RB_3
    	else
    		m.ra = RB_3
    		m.rb = RA_3
    	endif
    	*
    	m.nozap = m.nozap+1
    	insert into ostatki ;
    		(nozap,dat_o,kod,ra,rb,nlista,nost,pri,rx,ry);
    		values;
    		(m.nozap,date(),mat_kod,m.ra,m.rb,n_lista,n_nost,0,Rx_3,Ry_3)    
    	**** записать в отчет	   
	    @prow()+1,0 say str(npp,3)+' '+str(n_lista,5)+' '+str(n_nost,3)+' '+rfix(allt(str(ra_))+'x';
	    	+allt(str(rb_)),9) ;
	        +' '+izd_ribf+' '+izd_shwz+' '+kt_poznd+' '+kt_kornd+' '+str(PROGR_,3)+' '+str(koli_,3) ;
	        +'    '+rfix(allt(str(kt_rozma))+'x'+allt(str(kt_rozmb)),9) 	;
	        +iif(RA_3 > m.granica and RB_3 > m.granica, ;
	        +' '+rfix(allt(str(RA_3))+'x'+allt(str(RB_3)),9);
	        +str(n_lista,5)+' '+str(n_nost,3),'')
	    @prow()+1,12 say ' '+izd_naim+' '+kt_naimd	    
	    npp = npp+1
    endif

	********************
*!*	    if RA_1>130 and RB_1>130
*!*	        n_nost =n_nost+1
*!*	        m.ra   =RA_1
*!*	        m.rb   =RB_1
*!*	        if RA_1 < RB_1
*!*	            m.ra   =RB_1
*!*	            m.rb   =RA_1
*!*	        endif
*!*	    endif

*!*	    select nozap from ostatki into cursor C_max_nozap
*!*	    if reccount()>0
*!*	        sele max(nozap) from ostatki into array max_nozap
*!*	        m.nozap = max_nozap[1]+1
*!*	    else
*!*	        m.nozap=1
*!*	    endif
*!*	    use in C_max_nozap
*!*	    *WAIT WINDOW ' m.nozap='+STR(M.NOZAP)
*!*	    *!*	   *m.pri  =???

*!*	    insert into ostatki  (nozap,dat_o,  kod, ra, rb, nlista,  nost) values ;
*!*	        (m.nozap,date(),kt_kodm,ra_,rb_,n_lista,n_nost)
*!*	    @prow()+1,0 say str(npp,3)+' '+str(n_lista,5)+' '+str(n_nost,3)+' '+rfix(allt(str(ra_))+'x'+allt(str(rb_)),9) ;
*!*	        +' '+izd_ribf+' '+izd_shwz+' '+kt_poznd+' '+kt_kornd+' '+str(PROGR_,3)+' '+str(koli_,3) ;
*!*	        +'    '+rfix(allt(str(kt_rozma))+'x'+allt(str(kt_rozmb)),9) 	&&;
*!*	        +iif(RA_1>130 and RB_1>130, ;
*!*	        +' '+rfix(allt(str(RA_1))+'x'+allt(str(RB_1)),9);
*!*	        +str(n_lista,5)+' '+str(n_nost,3),'')

*!*	    @prow()+1,12 say ' '+izd_naim+' '+kt_naimd


*!*	    if RA_2>130 and RB_2>130
*!*	        *!*	   M.NOST =m.nost+1

*!*	        n_nost =n_nost+1


*!*	        m.ra   =RA_2
*!*	        m.rb   =RB_2
*!*	        if RA_2<RB_2
*!*	            m.ra   =RB_2
*!*	            m.rb   =RA_2
*!*	        endif
*!*	        m.dat_o=date()
*!*	        select nozap from ostatki into cursor C_max_nozap
*!*	        if reccount()>0
*!*	            sele max(nozap) from ostatki into array max_nozap
*!*	            m.nozap = max_nozap[1]+1
*!*	        else
*!*	            m.nozap=1
*!*	        endif
*!*	        use in C_max_nozap
*!*	        wait window '855 m.nozap='+str(m.nozap)+'  n_NOST='+str(n_nost)
*!*	        *insert into ostatki from memv
*!*	        * pri = ???
*!*	        insert into ostatki  (nozap,dat_o, kod,     ra,  rb, nlista,   nost) values ;
*!*	            (m.nozap,date(),kt_kodm,m.ra,m.rb,n_lista,n_nost)
*!*	        *!*	   @prow(),104 say rfix(allt(str(ra_2))+'x'+allt(str(rb_2)),9) ;
*!*	        *!*	                              +str(M.NLISTA,5)+' '+str(m.nost,3)
*!*	    endif
*!*	    ********************
*!*	    if RA_3>130 and RB_3>130
*!*	        n_nost =n_nost+1
*!*	        select nozap from ostatki into cursor C_max_nozap
*!*	        if reccount()>0
*!*	            sele max(nozap) from ostatki into array max_nozap
*!*	            m.nozap = max_nozap[1]+1
*!*	        else
*!*	            m.nozap=1
*!*	        endif
*!*	        use in C_max_nozap
*!*	        wait window '859 m.nozap='+str(m.nozap)+'  n_NOST='+str(n_nost)
*!*	        m.ra   =RA_3
*!*	        m.rb   =RB_3
*!*	        if RA_3<RB_3
*!*	            m.ra   =RB_3
*!*	            m.rb   =RA_3
*!*	        endif
*!*	        m.dat_o=date()

*!*	        *insert into ostatki from memv
*!*	        * pri=???
*!*	        insert into ostatki  (nozap,dat_o, kod,     ra,  rb, nlista,  nost) values ;
*!*	            (m.nozap,date(),kt_kodm,m.ra,m.rb,n_lista,n_nost)
*!*	        if RA_2>130 and RB_2>130
*!*	            @prow()+1,0 say space(104) +rfix(allt(str(RA_3))+'x'+allt(str(RB_3)),9) ;
*!*	                +str(n_lista,5)+' '+str(n_nost,3)
*!*	        else
*!*	            @prow(),104 say rfix(allt(str(RA_3))+'x'+allt(str(RB_3)),9) ;
*!*	                +str(n_lista,5)+' '+str(n_nost,3)
*!*	        endif
*!*	    endif
	return 
endproc 
    * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc shapka
    @prow()+1,0 say  '            ВЕДОМОСТЬ'
    @prow()+1,0 say  ' оперативного РАСКРОЯ прямоугольных деталей с ЛИСТА '+str(mat_kod,4)+' '+allt(mat_naim)
    @prow()+1,0 say  ''
    @prow()+1,0 say  '-------------------------------------------------------------------------------------------------------------------------'
    @prow()+1,0 say  ' № :    №    : Размеры :   ИЗДЕЛИЕ                  : ЗАГОТОВКА                 :Прогр.:К-во : Размеры :Остатки :   №    '
    @prow()+1,0 say  '   :  листа  :         :                            :                           : за - :с по-:заготовки:L     В :остатка '
    @prow()+1,0 say  'п/п:(остатка):         :                            :                           :пуска :лосы :         :        :        '
    @prow()+1,0 say  '-------------------------------------------------------------------------------------------------------------------------'
    bil=bil+1
    return 
    * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
endproc 