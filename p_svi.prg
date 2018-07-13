* = = = //proc p_svi
local mribf
do form f_izd_vib to mribf
if empt(mribf)
    return -1
endif
select * from izd where ribf = mribf into cursor c_izd
sele * from KT ;
    where pozn = mribf and d_u=2 and !empt(mar1) ;
    order by poznd ;
    into curs c_kt
*   brow fiel d_u,poznw,kornd,poznd,kol
if reccount() = 0
    wait window 'НЕТ УЗЛОВ В ВЫБРАННОМ ИЗДЕЛИИ '+mribf +' НЕЧЕГО ФОРМИРОВАТЬ'
    retu-1
endif

ind = reccount()

local arra u[ind]
local arra d[ind]
local arra nu[ind]
store ' ' to u,d,nu
go top
i=0
scan

    i=i+1
    d[i]=poznd
    u[i]=poznw
    nu[i]=naimw

endscan
use in c_kt
*i=1
*fl='wr.txt'
*defi wind good from 16,20 to 20,60 shad colo w+/bg
*acti wind good
*@ 0,1 say '” ©« '+fl+' д®а¬ЁагҐвбп'
*@ 1,1 say '†¤ЁвҐ...'
*set print to &fl
*set device to print
*do while !empt(u[i])
*   @prow()+1,25 say str(i,2)+' '+u[i]+' '+d[i]
*   i=i+1
*enddo
*deac wind good
*set print to
*set device to screen
*deac wind qood
*do pech
fl='svi.txt'

wait window "Документ формируется..." nowait

set print to &fl
set device to print

sele * from KT ;
    where ;
    pozn=mribf ;
    and d_u=3 ;
    into curs c_kt

do shap
k_s=0
@prow()+1,0 say 'ИЗДЕЛИЕ'
do kol_str
scatter memv
do pipi
use in c_kt

sele * from KT ;
    where ;
    pozn = mribf ;
    and d_u  = 2 ;
    and pozn = poznw ;
    and !empt(kol)  ;
    and !empt(poznd) ;
    order by poznd ;
    into curs c_kt
*brow
@prow()+1,0 say 'УЗЛЫ'
do kol_str

scan
    scatter memv
    do pipi
endscan

use in c_kt

sele * from KT ;
    where ;
    pozn = mribf ;
    and d_u  = 1 ;
    and pozn = poznw ;
    and !empt(mar1)  ;
    and !empt(poznd) ;
    order by kornd ;
    into curs c_kt
if reccount() > 0
    @prow()+1,0 say 'ДЕТАЛИ'
    do kol_str
    scan
        scatter memv
        do pipi
    endscan
endif
use in c_kt

sele * from KT ;
    where ;
    pozn = mribf ;
    and d_u  = 1 ;
    and pozn = poznw ;
    and !empt(kol)  ;
    and empt(poznd) ;
    and left(kornd,2)='1.' ;
    order by kornd ;
    into curs c_kt
if reccount() > 0

    @prow()+1,0 say 'ПОКУПНЫЕ'
    do kol_str
    scan
        scatter memv
        do pipi
    endscan
endif
use in c_kt
*     конец изделия
i=1
do while i<ind
    *wait 'i='+str(i,2)+' '+u[i] wind
    sele * from KT ;
        where ;
        pozn = mribf ;
        and d_u  = 2 ;
        and !empt(mar1)  ;
        and poznd=d[i] ;
        order by kornd ;
        into curs c_kt
    if reccount() = 0
        wait 'НЕТ В ИЗДЕЛИИ УЗЛА '+d[i] wind
    else
        ii = reccount()
        local arra uzi[ii]
        store ' ' to uzi
        ii=0
        scan
            ii=ii+1
            *uzi[ii]=poznw
            uzi[ii]=poznd
        endscan

        go top

        @prow()+1,10 say '***     '+u[i]+' '+nu[i]+'***'
        do kol_str
        scan
            *wait 'pipi poznd='+poznd wind
            scatter memv
            do pipi
            *nzap=recn()
            sele * from KT ;
                where ;
                pozn = mribf ;
                and d_u  = 2 ;
                and poznw=d[i] ;
                and empt(mar1)  ;
                order by kornd ;
                into curs c_ktuz
            if recc () > 0
                @prow()+1,0 say 'УЗЛЫ'
                scan
                    scatter memv
                    do pipi
                endscan
            endif
            use in c_ktuz

        endscan
        use in c_kt

        sele * from KT ;
            where ;
            pozn = mribf ;
            and poznw=d[i] ;
            and d_u  = 1 ;
            and !empty(poznd) ;
            and !empt(kol)  ;
            order by kornd ;
            into curs c_kt
        if recc () > 0
            @prow()+1,0 say 'ДЕТАЛИ'
            do kol_str
            scan
                scatter memv
                do pipi
            endscan
        endif
        use in c_kt

        sele * from KT ;
            where ;
            pozn = mribf ;
            and poznw=d[i] ;
            and d_u  = 1 ;
            and empty(poznd) ;
            and !empt(kol)  ;
            order by kornd ;
            into curs c_ktpok
        if recc () > 0
            @prow()+1,0 say 'ПОКУПНЫЕ'
            do kol_str
            scan
                scatter memv
                do pipi
            endscan
        endif
        use in c_ktpok
    endif
    i=i+1
enddo
use in c_izd
set print to
set device to screen

do opentxt with 'svi.txt','hor'

* закоментировано виталий 05/06/06
* ====================================
*!*	local loWord
*!*	loWord = createobject ('Word.Application')
*!*	with loWord
*!*	    .DisplayAlerts = .f.
*!*	    .Documents.open(sys(5)+sys(2003)+'\svi.txt',.f.,.f.,.f.,'','',.t.,'','',0,1251)
*!*	endwith
*!*	loWord.visible = .t.
*loWord.activeWindow.SelectedSheets.PrintPreview
* ====================================

retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc pipi
    if empt(kornd)
        @prow()+1,0 say kornW+' '+poznw
    else
        @prow()+1,0 say kornd+' '+poznd
    endif
    @prow(),40 say iif(!empt(kol),str(kol,3),'   ')
    if kodm#0
        roz=0
        if kolz>1
            roz=(rozma-40)/kolz
        endif

        if rozmb=0
            @prow(),44 say iif(WAG#0,str(WAG,10,5),space(10))+' ' +;
                iif(roz#0,'40+'+allt(str(roz,6,1))+'*N',str(rozma,6,1))
            @prow(),72 say space(3) +' '+left(ei,4)+' '+iif(nrmd#0, str(nrmd,8,5), '')+;
                ' '+iif(normwr#0,str(normwr,8,5),'')
        else
            @prow(),44 say iif(WAG#0,str(WAG,10,5),space(10))+' '+ ;
                iif(rozma#0,str(rozma,6,1),space(6))+ ;
                iif(rozmb#0,+'x'+allt(str(rozmb,6,1)),space(7))
            @prow(),72 say iif(kolz#0,str(kolz,3,1),space(3))+' '+left(ei,4)+' '+ ;
                iif(nrmd#0,str(nrmd,8,5),'')+;
                ' '+iif(normwr#0,str(normwr,8,5),'')
        endif
    endif
    do kol_str
    if empt(kornd)
        @prow()+1,10 say left(naimw,24)
    else
        @prow()+1,10 say left(naimd,24)
    endif
    @prow(),39 say iif(!empt(koli),str(koli,4),'    ')+'          '+substr(kttp,1,16)+space(1)+iif(mz#0,str(mz,10,5),space(10))+' '+iif(nrmd#0,str(nrmd*koli,7,3),'')
    do kol_str
    if kodm#0
        mkodm =kodm
        mpoznw=poznw
        ikodm='НЕТ В КАТАЛОГЕ'
        sele naim,kodm from MATER where kodm=mkodm into curs c_mater
        if recc() > 0
            ikodm=naim
        endif
        *sele c_kt
        @prow()+1,10 say str(kodm,4)+' '+ikodm
        use in c_mater
        do kol_str
    endif
    if !empt(mar1)
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
        @prow()+1,10 say str_p
        do kol_str
    endif
    retu
    * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc shap
    @prow()+1,0 say '                СВОДНАЯ ВЕДОМОСТЬ ИЗДЕЛИЯ (СВИ) '+allt(c_izd.im)+' '+c_izd.ribf
    @prow()+1,0 say '__________________________________________________________________________________________________'
    @prow()+1,0 say ' № поз.:     Обозначение,         Количество  Масса  Длина,ширина,    К-во   ЕИ  Норма     Норма  '
    @prow()+1,0 say '       :     Наименование,         в сборке,   (кг)  Типовый процесс  дет.в      расхода   расхода'
    @prow()+1,0 say '       :     Код материала,         изделии                           загот.       на        на   '
    @prow()+1,0 say '       :  Наименование материала,                                     масса      деталь    деталь '
    @prow()+1,0 say '       :       Марка,ГОСТ                                             (кг)      (изделие)  раскрой'
    @prow()+1,0 say '__________________________________________________________________________________________________'
    @prow()+1,0 say '____________Маршрут_______________________________________________________________________________'
    retu
    * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc kol_str
    k_s=k_s+1
    if k_s>60
        @prow()+1,0 say chr(12)
        do shap
        k_s=0
    endif
    retu

