* подготовить параметры (может быть)

* закрыть все
close tables all 	&& надеюсь - это не заблокирует дальнейшую работу
					&& после завершения работы необходимо позакрывать все снова

* подготовить рабочие области и индексы для них
* sele 55 - есть
* sele 88 - есть
* sele 33 - есть
* 

* рабочие области
sele 2
use kt

sele 3
use obor

sele 11
use ww

sele 8
use izd

sele 1
use dosp

set safety off
set deleted on

* дальнейший цикл
sele 55 
use rd exclu
if .not.file ('rd.cdx')
   inde on str(nd_1,3)+str(nd_2,3) tag in12
   inde on str(mes,2)+str(den,2)   tag iden
endif
   sele 88
   use kt_1 EXCL
   ZAP
   *dele all
   if .not.file ('kt_1.cdx')
      inde on poznd tag ipoznd
   endif
   set order to ipoznd
koef=0.1


*!*	defi wind wkp from 10,5 to 15,44 shad colo w+/w
*!*	acti wind wkp
*!*	do while .t.
*!*	   @ 0,0 prom '        формировать цикл              '
*!*	   @ 1,0 prom '      переформировать цикл            '
*!*	   @ 2,0 prom '              печатать                '
*!*	   @ 3,0 prom ' Выход                                '
*!*	   menu to m_kp
*!*	   do case
*!*	      case m_kp=4.or.m_kp=0.or.last()=27                 && Выход
*!*	           exit
*!*	      case m_kp=1
*!*	           do fp_c
*!*	      case m_kp=2
*!*	           do fp_c
*!*	      case m_kp=3
*!*	           do p_c
*!*	   endcase
*!*	enddo

do while .t.
	do form f_kp7win_1 to m.m_kp
	do	case	
		case	m.m_kp = 1		&& формировать
			do fp_c		
		case	m.m_kp = 2		&& переформировать
			do fp_c
		case	m.m_kp = -1		&& выход
			exit
	endcase
enddo

sele 33
use
sele 55
use
sele 77
use
retu


* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc fp_c
sele 33
use kp EXCL
ZAP
sele 77
use tmp EXCL
ZAP
if .not.file ('tmp.cdx')
   inde on shwz+str(normw,6) tag i77 desc
   inde on shwz+str(pu,2)    tag isp
   inde on shwz+kornd        tag isk
endif

*!*	defi wind w_kp from 10,5 to 15,44 shad colo w+/w
*!*	acti wind w_kp
*!*	   @ 0,0 prom '     только по изделиям               '
*!*	   @ 1,0 prom ' учитывать детали общего применения   '
*!*	menu to iz_det
*!*	rele wind w_kp

do form f_kp7win_2 to m.iz_det

sele 2
set filt to
sele 3
set filt to
sele 11
set filt to
sele 8
set order to idata_p
SET filt to !empt(data_p)
kol_izd=0
*sele * from izd order by ;
*                 str(year(data_p),4)+str(mont(data_p),2)+str(day(data_p),2) ;
*                 into curs c_izd
*sele c_izd

* ПРОВЕРКА 1
* проверка наличия введенных приритетов запуска узлов
go top
do while .not.eof()			&& цикл по изделиям
   IZDshw =KOD
   IZDSHWZ=SHWZ
   *sele shw,d_u,kol,pu from kt where ;
   *      shw=c_izd.kod and (d_u=2.or.d_u=3) and kol#0 and pu#0 ;
   *      into curs c_kt
   sele 2	
   set order to isP
   set key to STR(izdshw,6)
   *set filt to shw=izdshw.and.(d_u=2.or.d_u=3).and.kol#0.and.pu#0
   *brow
   go top
   indu=0
   do while .not.eof()
      *if (d_u=2.or.d_u=3).and.kol#0.and.pu#0.and.mar1#0
      && подсчитываем число узлов и изделий для данного изделия с приоритетом запуска
      && и непустым маршрутом
      if (d_u=2.or.d_u=3) .and. pu # 0 .and. mar1 # 0
         indu=indu+1
         *wait 'indu='+str(indu,3)+' '+kornd wind
      endif
      skip
   enddo
   if indu=0
   *if reсс() = 0
       	kol_izd=kol_izd+1
   		wait 'НЕ ВВЕДЕН ПРИОРИТЕТ УЗЛОВ ИЗДЕЛИЯ - '+STR(IZDshw,3) wind
   endif
      
   *use in c_kt
   * ПРОВЕРКА 1.1
   * проверка наличия производственной базы по шифру запуска
   sele 11		&& WW
   set FILT to SHWZ=izdshwz
   go top
   if eof()
      wait 'НЕ СФОРМИРОВАНА ПРОИЗВОДСТВЕННАЯ БАЗА ПО ШИФРУ ЗАПУСКА ';
           +IZDSHWZ  ;
           wind
      kol_izd=kol_izd+1
   else
      set filt to !empt(kodo) and empt(invn)
      go top
      if !eof()
         wait 'НЕ ВВЕДЕН ИНВЕНT. N ОБОРУДОВАНИЯ В ПРОИЗВОДСТВ.БАЗЕ '+STR(IZDshw,3) wind
         *brow fiel shwz,poznd,kodo,invn
      endif
   endif
   SELE 8
   *SELE c_izd
   SKIP
ENDDO
IF KOL_IZD>0
   wait 'РАСЧЕТ НЕВОЗМОЖЕН!!!' wind
   RETU
ENDIF
 
*!*	*** debug
*!*	susp
*!*	debug 

* set curs off
fl='oshibki.txt'
* defi wind good_ from 6,12 to 20,75 shad colo w+/bg
* acti wind good_
set print to &fl
* set device to scre
*!*	@ 1,1 say 'Ждите...'
*!*	@ 2,7 say 'начало подготовительного этапа'
wait 'Начало подготовительного этапа' nowait wind
set device to printer

@ 0,0 say 'Начало подготовительного этапа'

*** debug
*set print to
*susp
*debug
 
if m_kp=1
   * подготовка режима формирования
   wait 'Подготовка режима формирования' wind nowait
   * сделать ZAP в базе плана
   sele 33
   *use kp
   if .not.file ('kp.cdx')
      inde on shwz+kornd+invn        tag iski
      inde on shwz+kornd+str(chas,4) tag iskc
      inde on shwz+kornd             tag isk
      inde on invn+str(chas,4)       tag iic
      inde on invn                   tag iinvn
   endif
   *update ww set DATA_N = 0, ;
      * DATA_O  = 0, ;
      * VN      = 0, ;
      * VO      = 0, ;
      * DATA_ND = 0, ;
      * DATA_OD = 0, ;
      * VND     = 0, ;
      * VOD     = 0
   *sele 11
   *set filt to
   *go top
   *do while .not.eof()
      * обнулить даты запуска-окончания обработки деталей файла производственной базi
   *   repl DATA_N  with 0
   *   repl DATA_O  with 0
   *   repl VN      with 0
   *   repl VO      with 0
   *   repl DATA_ND with 0
   *   repl DATA_OD with 0
   *   repl VND     with 0
   *   repl VOD     with 0
   *   skip
   *enddo
else
   * подготовка режима переформирования
   wait 'Подготовка режима переформирования' wind nowait
   do while .t.
      do wwodmes
      if last()=27
         retu
      endif
      do wwodden
      if last()=27
         retu
      endif
      sele 55
      set order to iden
      set filt to mes=bmes.and.den=bdata
      go top
      if .not.eof()
         datana=nd_1
         exit
      else
         wait 'ЭТО ВЫХОДНОЙ, ПОВТОРИТЕ ВВОД' wind
         if last()=27
            retu
         endif
         set filt to
         brow
      endif
   enddo
   * дополнительний файл-план для перерасчета
   sele 33
   use kpd EXCL
   *dele all
   ZAP
   if .not.file ('kpd.cdx')
      inde on shwz+kornd+invn        tag iski
      inde on shwz+kornd+str(chas,4) tag iskc
      inde on shwz+kornd             tag isk
      inde on invn+str(chas,4)       tag iic
      inde on invn                   tag iinvn
   endif
   *update ww set ;
      * DATA_ND = 0, ;
      * DATA_OD = 0, ;
      * VND     = 0, ;
      * VOD     = 0
   sele 11
   set filt to
   go top
   do while .not.eof()
      * обнулить дополнительные даты запуска деталей
      repl DATA_ND with 0
      repl DATA_OD with 0
      repl VND     with 0
      repl VOD     with 0
      skip
   enddo
endif

*** debug
susp	 
debug	 

* ******************************************************
sele 77
set order to i77
sele 2
set key to

sele 3
set filt to
set order to iinvn
set key to
*sele invn,owr,osm,tochka from obor order by invn into curs c_obor
*sele c_obor
go top
do while .not.eof()
*  подготовка-формирование временнiх точек файла-плана КР
   if wr>0
      oinvn=invn
      owr  =roun(wr/koef,0)
      osm  =sm
      repl tochka with 0
      sele 33                   && kp
      indsm=1
      do while indsm<=osm
         if m_kp=2
            ind=datana/koef
         else
            ind=1
         endif
         do while ind<=owr
            *insert into kp chas values ind, ;
            *               invn values oinvn
            *               sm   values indsm
            appe blan
            repl chas with ind
            repl invn with oinvn
            repl sm   with indsm
            ind=ind+1
         enddo
         indsm=indsm+1
      enddo
   endif
   sele 3
   *sele c_obor
   skip
enddo
*sele 33
*brow
max_td=0
if iz_det = 2
   * выборка деталей входящих в несколько узлов
   * подготовка временного файла POZND деталей и их количества
   kdon=0
   sele 2
   set order to i_d
   set key to
   go top
   do while .not.eof()
      if !empt(poznd) AND !EMPT(MAR1)
         poznd_kt=poznd
         shw_kt  =shw
         sele 8
         set order to idata_p
         set key to
         go top
         if !empt(data_p) and kod=shw_kt
            sele 88
            set filt to allt(poznd)=allt(poznd_kt)
            go top
            if eof()
               appe blan
               repl poznd with poznd_kt
               repl kol with 1
            else
               repl kol with kol+1
            endif
         endif
      endif
      sele 2
      skip
   enddo
   sele 88
   set filt to
   dele for kol<2
   pack
   * проверить КТ на несособлюдение маршрутов детали в разнiх изделиях
      _kol=0
   sele 88
   go top
   *brow fiel poznd,kol
   do while .not.eof()
      poznd88=allt(poznd)
      *wait wind poznd88
      sele 2
      *set order to i_du
      *set key to poznd88+str(1,1)
      set filt to allt(poznd)=allt(poznd88)
      go top
      noo=0
      do while .not.eof()
         shw_kt=shw
         sele 8
         SET filt to !empt(data_p) and kod = shw_kt
         go top
         if !eof()
            noo=noo+1
            sele 2
            izd_shw=shw
            if noo=1
               @prow()+3,0 say 'изделие '+space(19)+str(izd_shw,2) ;
                      +' '+poznd+' '+kornd+' '+STR(MAR1,3)+STR(MAR2,3)+STR(MAR3,3)+STR(MAR4,3)+STR(MAR5,3)+STR(MAR6,3)+STR(MAR7,3)+STR(MAR8,3)+STR(MAR9,3)+STR(MAR10,3)
               dime mara[10]
               store 0 to mara
               mara[1] = mar1
               mara[2] = mar2
               mara[3] = mar3
               mara[4] = mar4
               mara[5] = mar5
               mara[6] = mar6
               mara[7] = mar7
               mara[8] = mar8
               mara[9] = mar9
               mara[10]= mar10
               *         IF allt(POZND88)='ДП 1.5.02.00.12'
               *            WAIT WIND '374 '+STR(MAR1,3)+STR(MAR2,3)+STR(MAR3,3)+STR(MAR4,3)+STR(MAR5,3)+STR(MAR6,3)+STR(MAR7,3)+STR(MAR8,3)+STR(MAR9,3)+STR(MAR10,3)
               *         ENDIF
            else
               if mar1 # mara[1] or ;
                  mar2 # mara[2] or ;
                  mar3 # mara[3] or ;
                  mar4 # mara[4] or ;
                  mar5 # mara[5] or ;
                  mar6 # mara[6] or ;
                  mar7 # mara[7] or ;
                  mar8 # mara[8] or ;
                  mar9 # mara[9] or ;
                  mar10# mara[10]
                  *   IF allt(POZND88)='ДП 1.5.02.00.12'
                  *      WAIT WIND '374 '+STR(MAR1,3)+STR(MAR2,3)+STR(MAR3,3)+STR(MAR4,3)+STR(MAR5,3)+STR(MAR6,3)+STR(MAR7,3)+STR(MAR8,3)+STR(MAR9,3)+STR(MAR10,3)
                  *   ENDIF
                  @prow()+1,0 say 'несоблюдение маршрутов изд.'+str(shw,2) ;
                         +' '+poznd+' '+kornd+' '+STR(MAR1,3)+STR(MAR2,3)+STR(MAR3,3)+STR(MAR4,3)+STR(MAR5,3)+STR(MAR6,3)+STR(MAR7,3)+STR(MAR8,3)+STR(MAR9,3)+STR(MAR10,3)
                  _kol=_kol+1
               endif
            endif
         endif
         *wait  'skip' wind
         sele 2
         skip
      enddo
      sele 88
      skip
   enddo
   *wait wind str(_kol)
   if _kol>0
      wait 'несоблюдение маршрутов РАСЧЕТ НЕВОЗМОЖЕН!!!' wind
      rele wind good_
      do pech
      retu
   endif

   *brow fiel poznd,kol
   kdon=recc()
endif
* заполнение временного файла ТМР
sele 8
set order to idata_p
SET filt to !empt(data_p)
go top
*brow
kol_izd=0
do while .not.eof()
   kol_izd=kol_izd+1
   izdshw   =kod
   izdshwz  =shwz
   izddata_p=data_p
   sele 2
   set order to ishw
   *set key to izdshw
   set filt to shw=izdshw.and.mar1#0
   go top
   *brow
   do while .not.eof()
      if mar1#0
         ktshw  =shw
         ktpoznd=poznd
         ktkornd=kornd
         ktdu   =d_u
         ktpu   =pu
         dime mara[10]
         store 0 to mara
         mara[1]=mar1
         mara[2]=mar2
         mara[3]=mar3
         mara[4]=mar4
         mara[5]=mar5
         mara[6]=mar6
         mara[7]=mar7
         mara[8]=mar8
         mara[9]=mar9
         mara[10]=mar10
         ind =1
         wro =0
         wwnw=0
         do while ind<=10
            if mara[ind]=0
               exit
            endif
            sele 11
            set filt to
            set order to iskm
            *set filt to shwz=izdshwz.and.kornd=ktkornd.and.mar=mara[ind]
            set key to izdshwz+ktkornd+str(mara[ind],4)
            *inde on shwz+kornd+str(mar,4)                tag iskm
            go top
            koza=0
            *   brow fiel shwz,kornd,mar,kolz,kzp,tpz,normw
            if .not.eof()
               do while .not.eof()
                  kr=iif(krno=0,1,krno)
                  wro=wro+(normw*(kolz-kzp)+tpz)/kr
                  wwnw=wwnw+(normw*(kolz-kzp)+tpz)/kr
                  koza=koza+1
                  skip
               enddo
               if ind<=9
                  sele 1
                  set order to ivk
                  seek str(2,4)+str(mara[ind+1],4)
                  if foun()
                     wro=wro+us*60
                     if wro>999999
                        @prow()+1,0 say 'переполнение по кор.№ '+ktkornd+' T='+str(wro,12)
                        *wait 'переполнение по кор.№ '+ktkornd+' T='+str(wro,12) wind
                     endif
                  else
                     @prow()+1,0 say 'нет в DOSP следующего маршрута'+str(mara[ind+1],3)
                     *wait 'нет в DOSP следующего маршрута'+str(mara[ind+1],3) wind
                  endif
               endif
            endif
            ind=ind+1
         enddo
         *wait wind 'wro='+str(wro,8,3)
         *if last()=27
         *   retu
         *endif
         if wro>0
*  формирование файлa ТМР - узлы и детали для планирования
            sele 77
            appe blan
            repl shwz   with izdshwz
            repl POZND  with KTPOZND
            repl data_p with izddata_p
            repl kornd  with ktkornd
            repl normw  with roun(wro/60,0)
            repl d_u    with ktdu
            repl nw     with roun(wwnw/60,2)
            repl pu     with ktpu
         endif
      endif
      sele 2
      skip
   enddo
   sele 8
   skip
   *wait ' sele 8 skip' wind
enddo
*sele 77
*brow
*retu
set device to scre
@ 3,7 say 'закончен подготовительный этап'
@ 4,0 say 'обрабатывыется '+str(kol_izd,3)+' изделий'
set device to print

if iz_det = 2
   if kdon > 0
      set device to scre
      @  7,7 say 'плaнирование деталей общего применения'
      *wait 'плaнирование деталей общего применения'  wind
      @ 9,7 say '                                   '
      @11,7 say '                           '
      set device to prin
      sele 88
      go top
      *BROW
      do while .not.eof()
         poznd_=poznd
         set device to scre
         @ 8,7 say 'деталь '+poznd_
         set device to prin
         sele 2
         set order to i_d
         set key to && poznd_
         SET FILT TO allt(POZND)=allt(POZND_) AND MAR1#0 and d_u=1
         go top
         dime mara[10]
         store 0 to mara
         mara[1]=mar1
         mara[2]=mar2
         mara[3]=mar3
         mara[4]=mar4
         mara[5]=mar5
         mara[6]=mar6
         mara[7]=mar7
         mara[8]=mar8
         mara[9]=mar9
         mara[10]=mar10
         *   IF POZND_='ДП 1.5.02.06.02' and izdshw=8
         *      WAIT WIND STR(MAR1,3)+STR(MAR2,3)+STR(MAR3,3)+STR(MAR4,3)+STR(MAR5,3)+STR(MAR6,3)+STR(MAR7,3)+STR(MAR8,3)+STR(MAR9,3)+STR(MAR10,3)
         *   ENDIF
         ind=1
         wro=0
         w_do=0
         do while ind<=10
            if mara[ind]=0
               exit
            endif
            sele 2
            GO TOP
            do while .not.eof()
               if mar1=mara[ind] or mar2=mara[ind] ;
                                 or mar3=mara[ind] ;
                                 or mar4=mara[ind] ;
                                 or mar5=mara[ind] ;
                                 or mar6=mara[ind] ;
                                 or mar7=mara[ind] ;
                                 or mar8=mara[ind] ;
                                 or mar9=mara[ind] ;
                                 or mar10=mara[ind]
                  *IF POZND_='ДП 1.5.02.06.02'
                  *   WAIT WIND 'IND='+STR(IND,2)+' mara[ind]='+STR(MARA[IND],4)
                  *ENDIF
                  kornd_kt=kornd
                  poznd_kt=poznd
                  shw_kt  =shw
                  sele 8
                  set filt to !empt(data_p) and kod=shw_kt
                  go top
                  if .not.eof()
                     izdshw =kod
                     izdshwz=shwz
                     sele 2
                     *IF POZND_='ДП 1.5.02.00.12'
                     *   brow fiel shw,kornd,mar1
                     *endif
                     tmpkornd=kornd
                     tmppoznd=poznd
                     priu=0
                     do qqq7
                     if ind<10
                        sele 1
                        set order to ivk
                        *wait 'ind='+str(ind,3) wind
                        seek str(2,4)+str(mara[ind+1],4)
                        if foun()
                           wro=wro+us*60
                           *IF POZND_='ДП 1.5.02.00.12'
                           *   wait ' dosp wro='+str(wro,3)+' us='+str(us,5,1) wind
                           *endif
                           if wro>9999
                              @prow()+1,0 say  'переполнение по кор.№ '+ktkornd+' T='+str(wro,12)
                           endif
                        else
                           @prow()+1,0 say 'нет в DOSP следующего маршрута'+str(mara[ind+1],3)
                        endif
                     endif
                  endif
               endif
               sele 2
               skip
            enddo
            ind=ind+1
            *IF POZND_='ДП 1.5.02.06.02'
            *   WAIT WIND 'ind=ind+1 IND='+STR(IND,2)
            *ENDIF
         enddo
         *IF POZND_='ДП 1.5.02.06.02'
         *   wait ' sele 88 skip' wind
         *ENDIF
         sele 88
         skip
      enddo
      SELE 2
      SET FILT TO
   else
      set device to scre
      @  7,7 say 'нет деталей общего применения         '
      wait 'НЕТ ДЕТАЛЕЙ ОБЩЕГО ПРИМЕНЕНИЯ         ' wind
      @ 8,7 say space(14)
      @ 9,7 say '                                   '
      @11,7 say '                           '
      set device to prin
   endif
endif
*конец деталей общего применения         '
sele 8
SET filt to !empt(data_p)
go top
npp=0
do while .not.eof()
   set device to scre
   npp=npp+1
   @ 5,0 say str(npp,2)+' изделие '+shwz+' '+ribf+' '+im
   *         @ 6,7 say ' узел  '+u[i_u])
   *wait 'планированиe деталей и узлов ' wind
   @ 7,7 say 'планированиe деталей и узлов                   '
   @ 8,7 say space(14)
   @ 9,7 say '                                   '
   @11,7 say '                           '
   set device to prin
   izdshw =kod
   izdshwz=shwz
   sele 2
   set filt to
   set order to isP
   set key to STR(izdshw,6)
   *set filt to shw=izdshw.and.(d_u=2.or.d_u=3).and.kol#0.and.pu#0
   *brow
   go top
   indu=0
   do while .not.eof()
      *if (d_u=2.or.d_u=3).and.kol#0.and.pu#0.and.mar1#0
      if (d_u=2.or.d_u=3).and.pu#0.and.mar1#0
         indu=indu+1
         *wait 'indu='+str(indu,3)+' '+kornd wind
      endif
      skip
   enddo
   if indu=0
      wait wind 'НЕТ УЗЛОВ В ИЗДЕЛИИ '+izdshwz
      retu
   endif
   dime u[indu]
   store ' ' to u
   go top
   i=0
   do while .not.eof()
      *if (d_u=2.or.d_u=3).and.kol#0.and.pu#0.and.mar1#0
      if (d_u=2.or.d_u=3).and.pu#0.and.mar1#0
         i=i+1
         u[i]=kornd
         *wait 'i='+str(i,2)+' u[i]='+u[i] wind
      endif
      skip
   enddo
   set key to
   i_u=1
   priu=0
   max_td = 0
   max_tu = 0
   *wait 'indu='+str(indu,2) wind
   *wait 'цикл по узлам ' wind
   do while i_u<=indu           && цикл по узлам
      max_tu = iif(max_td>max_tu,max_td,max_tu)
      max_td = 0
      set devi to scre
      @ 6,7 say ' узел  '+u[i_u]
      set devi to prin
      kol_do_t=at('.',u[i_u])
      *wait 'i_u='+str(i_u,3)+' '+allt(u[i_u]);
      *                               +' '+left(u[i_u],kol_do_t) wind
      do while .t.
         sele 77                && TMP
         set order to i77
         set key to
         if priu=0
            set filt to shwz=izdshwz;
                   .and.left(kornd,kol_do_t)=left(u[i_u],kol_do_t);
                   .and.d_u=1
         endif
         if priu=1
            set filt to shwz=izdshwz.and.kornd=u[i_u].and.d_u=2
            *if left(u[i_u],2) = '5.'
            *   brow
            *endif
         endif
         go top
         do while .not.eof()
            tmpkornd = kornd
            tmppoznd = poznd
            set devi to scre
            @ 8,7 say iif(priu=0,'деталь '+kornd,' узел  '+kornd)
            set devi to prin
            sele 2
            set order to i7
            *set key to str(izdshw,6)+allt(tmppoznd)+tmpkornd
            set filt to shw=izdshw and allt(poznd)=allt(tmppoznd) and kornd=tmpkornd
            go top
            *if tmpkornd='5.0'
            *   brow
            *endif
            if .not.eof()
               poznd_kt=poznd
               KORND_KT=KORND
               sele 88
               set filt to allt(poznd)=allt(poznd_kt)
               go top

               if eof()
                  dime mara[10]
                  store 0 to mara,wrm
                  sele 2
                  mara[1]=mar1
                  mara[2]=mar2
                  mara[3]=mar3
                  mara[4]=mar4
                  mara[5]=mar5
                  mara[6]=mar6
                  mara[7]=mar7
                  mara[8]=mar8
                  mara[9]=mar9
                  mara[10]=mar10
                  ind=1
                  wro=0
                  w_do=0
                  do while ind<=10
                     if mara[ind]=0
                        exit
                     endif
            *if tmpkornd='5.0'
            *   wait wind 'do qqq'
            *endif
            sele 2
            set filt to
                     do qqq
                     if ind<10
                        sele 1
                        set order to ivk
                        *wait 'ind='+str(ind,3) wind
                        seek str(2,4)+str(mara[ind+1],4)
                        if foun()
                           wro=wro+us*60
                           if wro>99999
                              *wait 'переполнение по кор.№ '+ktkornd+' T='+str(wro,12) wind
                              @prow()+1,0 say 'переполнение по кор.№ '+ktkornd+' T='+str(wro,12)
                           endif
                        else
                           @prow()+1,0 say  'нет в DOSP следующего маршрута'+str(mara[ind+1],3)
                        endif
                     endif
                     ind=ind+1
                  enddo
               ELSE
                  SELE 33
                  set order to iskc
                  set filt to
                  set key to izdshwz+kornd_kt
                  GO BOTT
                  MAX_Td=IIF(CHAS>MAX_Td,CHAS,MAX_Td)
                  *if kornd_kt='1.49'
                  *   wait wind 'max_td='+str(max_td,5)+' chas='+str(chas,5)
                  *endif
                  *brow
                  *if last()=27
                  *   retu
                  *endif
                  set key to
               endif
               sele 88
               set filt to
            endif
            sele 77
            skip
         enddo          && конец файла TMP
         priu=priu+1
         if priu>1
            exit
         endif
      enddo
      priu=0
      i_u=i_u+1
   enddo                && конец цикла по узлам

   set device to scre
   @  9,7 say 'Конец  плaнирование деталей и узлов'
   @ 11,7 say 'начало плaнирование изделия'
   *wait 'начало плaнирование изделия' wind
   set device to print
   max_ti=max_tu

      wait 'пошло изделие '+str(izdshw,2)+' max_ti='+str(max_ti,5) wind

   priu=2
   sele 77
   set order to i77
   set filt to
   set key to izdshwz
   *set filt to shwz=izdshwz.and.d_u=3
   go top
   do while .not.eof()
      if d_u=3
         tmpkornd=kornd
         tmppoznd=tmppoznd
         sele 2
         set order to i7
         *set key to str(izdshw,6)+tmpkornd
         set filt to shw=izdshw and d_u=3
         go top
         *brow fiel kornd,d_u
         dime mara[10]
         store 0 to mara
         if .not.eof()
            mara[1]=mar1
            mara[2]=mar2
            mara[3]=mar3
            mara[4]=mar4
            mara[5]=mar5
            mara[6]=mar6
            mara[7]=mar7
            mara[8]=mar8
            mara[9]=mar9
            mara[10]=mar10
         endif
         ind=1
         wro=0
         w_do=0
         do while ind<=10
            if mara[ind]=0
               exit
            endif
            priu=2
            do qqq
            if ind<10
               sele 1
               set order to ivk
               *wait 'ind='+str(ind,3) wind
               seek str(2,4)+str(mara[ind+1],4)
               if foun()
                  wro=wro+us*60
                  *   wait ' dosp wro='+str(wro,3)+' us='+str(us,5,1);
                  *   wind
                  if wro>999999
                     @prow()+1,0 say  'переполнение по кор.№ '+ktkornd+' T='+str(wro,12)
                  endif
               else
                  @prow()+1,0 say 'нет в DOSP следующего маршрута'+str(mara[ind+1],3)
               endif
            endif
            ind=ind+1
         enddo
      endif
      sele 77
      skip
   enddo          && конец файла TMP
   *wait ' sele 8 skip' wind
   sele 8
   skip
enddo
set device to scre
@ 12,7 say 'закончено плaнирование изделий'
rele wind good_
set print to
set device to screen
sele 33
use
USE KP EXCL
DELE FOR EMPT(KORND)
PACK
BROW
if m_kp=2
   sele 33
   use kp
   SET FILT TO
   set curs off
   deac wind w3
   defi wind good_ from 16,20 to 20,60 shad colo w+/bg
   acti wind good_
   @ 0,1 say 'ВРЕМЯ ОБРАБОТКИ в Производственной базе'
   @ 1,1 say 'формируется   Ждите...'
   SELE 11
   SET FILT TO
   sele 8
   set key to
   go top
   do while .not.eof()
      mshwz=shwz
      sele 77
      set order to isp
      set filt to shwz=mshwz
      go top
      do while .not.eof()
         tmpkornd = kornd
         tmppoznd = poznd
         tmpshwz  = shwz
         sele 3
         set order to iinvn
         set key to
         go top
         do while .not.eof()
            obormarka=marka
            oborpodr =podr
            oborinvn =invn
            sele 33
            set order to iski
            set key to mshwz+tmpkornd+oborinvn
            go top
            if .not.eof()
               min_t=100000
               max_t=0
               kpinvn=space(7)
               do while .not.eof()
                  if !empt(kornd)
                     *max_t=iif(chas>max_t,chas,max_t)
                     if chas>max_t
                        max_t =chas
                        kpinvn=invn
                     endif
                     min_t=iif(chas<min_t,chas,min_t)
                  endif
                  skip
               enddo
               min_t=iif(min_t=100000,0,min_t)
               sele 55
               set order to in12
               set filt to max_t/10=>nd_1.and.max_t/10=<nd_2
               go top
               if .not.eof()
                  datawi=den
               else
                  datawi=0
               endif
               set filt to min_t/10=>nd_1.and.min_t/10=<nd_2
               go top
               if .not.eof()
                  datana=den
               else
                  datana=0
              endif
               sele 77
               BVN=MIN_T
               BVO=MAX_T
               min_ch=min_t-int(min_t/80)*80
               min1n=val(left(str(min_ch,2),1))
               min2n=val(righ(str(min_ch,2),1))
               wr_n=8+min1n+iif(min1n<4,0,1)+min2n*0.06
               max_ch=max_t-int(max_t/80)*80
               min1p=val(left(str(max_ch,2),1))
               min2p=val(righ(str(max_ch,2),1))
               wr_o=8+min1p+iif(min1p<4,0,1)+min2p*0.06
               sele 11
               set order to inar
               set key to tmpshwz+tmpkornd+str(oborpodr,4)+obormarka
               go top
               do while .not.eof()
                  repl DATA_Nd with datana
                  repl DATA_od with datawi
                  repl VNd     with wr_n
                  repl VOd     with wr_o
                  skip
               enddo
            endif
            sele 3
            skip
         enddo
         sele 77
         skip
      enddo
      sele 8
      skip
   enddo
   rele wind good_
endif
do pech
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc qqq
*IF TMPKORND='1.12' and izdshw=8
*   WAIT WIND 'qqq '+IZDSHWZ+' '+TMPKORND+' MAR='+STR(MARA(IND),4)
*ENDIF
sele 11
set order to ikzr
*set filt to
*   inde on shwz+kornd+str(mar,4)+str(nto,4)     tag ikzr
set filt to shwz=izdshwz.and.kornd=tmpkornd ;
                        .and.mar=mara[ind] ;
                        .and.kzp#kolz ;
                        .and.normw>0 ;
                        .AND.!EMPT(KODO)
*set key to izdshwz+tmpkornd+str(mara[ind],4)
go top
*IF TMPKORND='1.12' and izdshw=8
*   BROW FIEL SHWZ,KORND,MAR,KZP,KOLZ,NORMW,KODO
*ENDIF
koza=0
do while .not.eof()
   if !empt(kodo).and.kzp#kolz.and.normw>0
      wwkodo=kodo
      wwmar =mar
      mnto  =nto
      kr=iif(krno=0,1,krno)
      *wro=(normw*(kolz-kzp)+tpz)/kr+iif(koza>0,12,0)
      wro=(normw*(kolz-kzp)+tpz)/kr
      www=wro
      wroi=0
      do while .t.
         skip
         if kodo=wwkodo
            mnto=nto
            kr=iif(krno=0,1,krno)
            wro1=(normw*(kolz-kzp)+tpz)/kr
            wroi=wroi+wro1
         else
            skip-1
            exit
         endif
      enddo
      www=roun((www+wroi)/60/koef,0)
      if www<1
         www=1
      endif
      *IF TMPKORND='1.12'
      *   WAIT WIND allt(str(izdshw))+' '+IZDSHWZ+' '+TMPpOzND+' www='+STR(www,8,4)+' '+wwkodo
      *ENDIF
      sele 3
      set order to ipm
      set key to str(wwmar,4)+wwkodo
      go top
      mint=0
      kolza=0
      if .not.eof()
         oinvn=invn
         do while .not.eof()
            kolza=kolza+1
            skip
         enddo
         go top
         if kolza>1
            *wait 'kolza='+str(kolza,3) wind
            dime t_o[kolza]
            store 0 to t_o
            i_t=0
            go top
            do while .not.eof()
               i_t=i_t+1
               t_o[i_t]=tochka
               *wait 'i_t='+str(i_t,2)+' t_o[i_t]='+str(t_o[i_t],4) wind
               skip
            enddo
            i_t_=1
            mint=100000
            do while .t.
               mint=iif(mint>t_o[i_t_],t_o[i_t_],mint)
               i_t_=i_t_+1
               if i_t_>i_t
                  exit
               endif
            enddo
            go top
            do while .t.
               if tochka#mint
                  skip
               else
                  oinvn=invn
                  exit
               endif
            enddo
         endif
         sele 33
         set order to iic
         set key to oinvn
         go top
         max_toch=max_td
         do while .not.eof()
            if chas<=max_toch
               *if left(tmpkornd,2)='5.'
               *   @ 0,0 say tmpkornd+' max_toch='+str(max_toch,5)+' chas='+str(chas,5)
               *endif
               skip
            else
                exit
            endif
            mmm=max_toch
         enddo
         *brow
         if .not.eof()
            if !empt(kornd)
               skip
               if eof()
                  @prow()+1,0 say  'нема куди писать KP !!!'+oinvn
                  *brow
                  exit
               endif
            else
               nz=recn()
            endif
            tochka=chas       && 1-я  пустая строка
            kpz=0
            do while .t.
               if eof()
                  wait 'конец !!!' wind
                  retu
               else
                  okno=1
                  do while .t.
                     if empt(kornd)
                        kpz=kpz+1
                        if kpz<w_do+www
                           skip
                           if eof()
                              *wait 'по инв.№ '+oinvn;
                              @prow()+1,0 say 'по инв.№ '+oinvn;
                              +' нет достаточного окна для T=';
                              +str(w_do+www,6)+' '+tmpkornd
                              okno=0
                              exit
                           endif
                        else
                           exit
                        endif
                     else
                        kpz=0
                        nz=recn()+1
                        exit
                     endif
                  enddo
                  if kpz=w_do+www
                     NAZAD=W_DO+WWW
                     DO WHILE .t.
                        nazad=nazad-1
                        if nazad>0
                           SKIP-1
                           if bof()
                              wait 'bof(!!!) '+tmpkornd+' NAZAD='+str(NAZAD,3) WIND
                              *brow
                           endif
                        else
                           exit
                        endif
                     ENDDO
                     if w_do>0
                        ido=1
                        do while ido<=w_do
                           if eof()
                              wait 'не может такого быть !!!' wind
                           endif
                           skip
                           ido=ido+1
                        enddo
                     endif
                     t_o=0
                     do while .t.
                        if www>0
                           t_o=www
                           if !empt(shwz)
                              wait 'затирается запись ';
                                   +izdshwz+' '+tmpkornd;
                                   +' chas='+str(chas,3);
                                   +' '+oinvn wind
                              *brow
                              rele wind good_
                              retu
                           endif
                           repl shwz  with izdshwz
                           repl kornd with tmpkornd
                           kpchas=chas
                           
                              *IF TMPKORND='1.47'
                              *   wait 'max_t='+str(max_t)+' chas='+str(chas,4) WIND
                              *ENDIF
                           max_td =iif(chas>max_td,chas,max_td)
                           
                           www=www-1
                           sele 3
                           repl tochka with kpchas
                           sele 33
                           skip
                        else
                           exit
                        endif
                     enddo
                     w_do=w_do+t_o
                  endif
               endif
               if okno=0
                  exit
               endif
               if kpz#0
                  exit
               else
                  go nz
               endif
            enddo
         else
            *wait 'invn='+oinvn+' с нач.точкой'+str(max_ti,4)+' нет в KP' wind
            @prow()+1,0 say 'invn='+oinvn+' с нач.точкой'+str(max_ti,4)+' нет в KP'
         endif
      else
         *wait 'нет в рабочем состоянии !!! '+wwkodo+' маршрут '+str(wwmar,4) wind
         @prow()+1,0 say 'нет в рабочем состоянии !!! '+wwkodo+' маршрут '+str(wwmar,4)
      endif
   endif
   sele 11
   koza=koza+1
   skip
enddo
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc qqq7

sele 11
set order to i7
   *inde on str(shw,6)+poznd+str(nto,4)+kodo tag i7
set filt to shwz=izdshwz.and.kornd=tmpkornd ;
                        .and.mar=mara[ind] ;
                        .and.kzp#kolz ;
                        .and.normw>0 ;
                        .AND.!EMPT(KODO)
go top
*IF TMPKORND='1.12'
*   BROW FIEL SHWZ,nto,MAR,KZP,KOLZ,NORMW,KODO,INVN
*ENDIF
koza=0
do while .not.eof()
   wwkodo=kodo
   wwmar =mar
   mnto  =nto
   kr=iif(krno=0,1,krno)
   wro=(normw*(kolz-kzp)+tpz)/kr
   www=wro
   wroi=0
   do while .t.
      skip
      if kodo=wwkodo
         mnto=nto
         kr=iif(krno=0,1,krno)
         wro1=(normw*(kolz-kzp)+tpz)/kr
         wroi=wroi+wro1
      else
         skip-1
         exit
      endif
   enddo
   www=roun((www+wroi)/60/koef,0)
   if www<1
      www=1
   endif
   *IF TMPKORND='1.12'
   *   WAIT WIND allt(str(izdshw))+' '+IZDSHWZ+' '+TMPpOzND+' www='+STR(www,8,4)+' '+wwkodo
   *ENDIF


   sele 3
   set order to ipm
   set key to str(wwmar,4)+wwkodo
   go top
   mint=0
   kolza=0
   if .not.eof()
      oinvn=invn
      do while .not.eof()
         kolza=kolza+1
         skip
      enddo
      go top
      if kolza>1
         *wait 'kolza='+str(kolza,3) wind
         dime t_o[kolza]
         store 0 to t_o
         i_t=0
         go top
         do while .not.eof()
            i_t=i_t+1
            t_o[i_t]=tochka
            *wait 'i_t='+str(i_t,2)+' t_o[i_t]='+str(t_o[i_t],4) wind
            skip
         enddo
         i_t_=1
         mint=100000
         do while .t.
            mint=iif(mint>t_o[i_t_],t_o[i_t_],mint)
            i_t_=i_t_+1
            if i_t_>i_t
               exit
            endif
         enddo
         go top
         do while .t.
            if tochka#mint
               skip
            else
               oinvn=invn
               exit
            endif
         enddo
      endif
      *brow fiel invn,marka,tochka
      sele 33
      set order to iic
      set key to oinvn
      go top
      *brow
      if last()=27
         retu
      endif
      *max_toch=max_td
      do while .not.eof()
         if !empt(shwz)
            *wait 'затирается запись ';
            *+izdshwz+' '+tmpkornd;
            *+' chas='+str(chas,3);
            *+' '+oinvn wind
            **brow
            *rele wind good_
            *retu
            repl shwz  with izdshwz
            repl kornd with tmpkornd
            kpchas=chas
            sele 3
            repl tochka with kpchas
            max_td =iif(kpchas>max_td,kpchas,max_td)
            *wait wind 'max_td='+str(max_td,4)
            www=www-1
            if www=0
               exit
            endif
         endif
         sele 33
         skip
      enddo
   else
      *wait 'нет в рабочем состоянии !!! '+wwkodo+' маршрут '+str(wwmar,4) wind
      @prow()+1,0 say 'нет в рабочем состоянии !!! '+wwkodo+' маршрут '+str(wwmar,4)
   endif
   sele 11
   koza=koza+1
   skip
enddo
sele 11
set filt to
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
