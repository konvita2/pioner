LOCAL cshwz, ldbdata, lnbndok, lnNa_Odun

DO form f_izd_vib to cRibf
SELECT * from izd WHERE ribf = cRibf INTO CURSOR c_izd
ldbdata = date()
lnbndok = 1
fl='lzk.txt'
*    WAIT wind 'Файл '+fl+' формується. Чекайте'
    set print to &fl
    set device to print
    @ prow()+1,0 say ' Склад №'+space(60)+'Виправлення змiни i доповнення забороненi категорично'
    @ prow()+1,0 say ' ЛIМIТНО-ЗАБIРНА КАРТА № '+STR(lnbndok,6)+space(36)+' Змiни i доповнення вносять провiдний економiст ВМТП та'
    @ prow()+1,0 say ' Дата виписки '+dtoc(ldbdata)+space(43)+' начальник ВМТП з пiдписом'
    @ prow()+1,0 say ' Шифр заказу '+c_izd.shwz
    @ prow()+1,0 say ' Кiлькiсть виробiв '+str(c_izd.partz2-c_izd.partz1+1,4)+' N '+allt(str(c_izd.partz1,4))+'-'+allt(str(c_izd.partz2,4))
    @ prow()+1,0 say '----------------------------------------------------------------------------------------------------------------------------'
    @ prow()+1,0 say '   Код     :                                      :    :       :  До   :Oтримано:   Вiдпущено     :   Вiдпущено     :Всього:'
    @ prow()+1,0 say ' N склад.  : Найменування                         : Од.: Норма : отри- :ранiше  :-----------------:-----------------: вiдп.:'
    @ prow()+1,0 say '   карт.   :    ТМЦ                               :вим.: на од : мання :        :К-ть: Дата:Пiдпис:К-ть: Дата:Пiдпис:      :'
    @ prow()+1,0 say '----------------------------------------------------------------------------------------------------------------------------'
    @ prow()+1,0 say '     1     :          2                           : 3  :   4   :   5   :    6   :  7 :  8  :   9  : 10 :  11 :  12  :  13  :'
    @ prow()+1,0 say '----------------------------------------------------------------------------------------------------------------------------'
    npp=0
    SELECT * FROM kt
    sele kodm,pol,naim,kod,ei from mater order by gr,sort,pol,naim into curs c_mat 
    *sele kodm,pol,naim,kod,ei from mater where kodm=1404 order by gr,sort,pol,naim into curs c_mat 
    SELECT c_mat
    scan
    *GO top
    *brow
    *do while .not. eof()
      
	   *WAIT STR(c_izd.kod) wind
       *sele poznd,shw,kodm,zo,mar1,mar2,mar3,nrmd,kol,koli,sum (kolI*nrmd) as[NaOdun];
       *select poznd,shw,kodm,zo,mar1,mar2,mar3,nrmd,kol,koli;
       
       select * from kt where shw=C_IZD.KOD ;
                             and zo=0;
                              and mar1#602 and mar1#510;
	                          and (mar2<515.or.mar2>580);
	                          and (mar3<515.or.mar3>580);
	                          and kolz>0 ;
	                          and kodm=c_mat.kodm;
                              into curs  c_kt
                              SELECT c_kt
                             *BROWSE
                             *and kodm=c_mat.kodm;
                              
	    lnNa_Odun=0                 
	   SCAN
       	 lnNa_Odun=lnNa_Odun+c_kt.koli*c_kt.nrmd
       endscan
       IF c_mat.kodm=1404
          WAIT 'na='+STR(lnna_odun,8,4) WINDOW
          *BROWSE FIELDS c_kt.shw,c_kt.kodm,c_kt.koli,c_kt.nrmd
       ENDIF
       lnNa_Odun=0
             
       USE IN c_kt
       otp_=0
       kol_=c_izd.partz2-c_izd.partz1+1
       lnNa_Odun = 0
       *IF lnNa_Odun>0
           *WAIT '*lnNa_Odun>0 prow' wind
          otp_     =0
     	  m_kd1=space(40)
     	  m_kd2=space(40)
     	  m_kd=c_mat.naim
  	     koko=at('\',m_kd)
  	     if koko#0
    	      m_kd1=rfix(left(m_kd,koko-1),40)
      	    m_kd2=subs(m_kd,koko+1)
  	     ENDIF
          npp=npp+1
          @ prow()+1,1 say c_mat.kod;
                                    +' '+m_kd1;
                                    +' '+c_mat.ei;
                                    +' '+str(lnNa_Odun>0/kol_,10,4);
                                    +' '+STR(lnNa_Odun>0-otp_,10,4)
          @ prow(),0 say str(c_mat.kodm,4)+space(8)+m_kd2
          
       *ENDIF
   endscan                                       &&&& +' '+iif(otp_#0,str(otp_,10,3),'')

       *sele c_mat
       *skip
    *enddo
*	    @ prow()+1,0 say '   Начальник ВМТП                         В.Г.Линник'
*	    @ prow()+1,0 say '   Провiдний економiст                    О.А.Рубанова '
*	    @ prow()+1,0 say ''
*	    @ prow()+1,0 say ' Склад №'+space(60)+'Виправлення змiни i доповнення забороненi категорично'
*	    @ prow()+1,0 say ' ЛIМIТНО-ЗАБIРНА КАРТА № '+bndok+space(36)+' Змiни i доповнення вносять провiдний економiст ВМТП та'
*	    @ prow()+1,0 say ' Дата виписки '+dtoc(bdata)+space(43)+' начальник ВМТП з пiдписом'
*	    @ prow()+1,0 say 'Шифр заказу '+mshwz
*	    @ prow()+1,0 say 'Кiлькiсть виробiв '+str(mpartz2-mpartz1+1,4)+' N '+allt(str(mpartz1,4))+'-'+allt(str(mpartz2,4))
*	    @ prow()+1,0 say 'ДОДАТКОВО'
*	    @ prow()+1,0 say '-------------------------------------------------------------------------------------------------------------------------------------'
*	    @ prow()+1,0 say '   Код     :                                      :    :             :    До    :Oтримано:   Вiдпущено     :   Вiдпущено     :Всього:'
*	    @ prow()+1,0 say ' N склад.  : Найменування                         : Од.:    Норма    :  отри-   :ранiше  :-----------------:-----------------: вiдп.:'
*	    @ prow()+1,0 say '   карт.   :    ТМЦ                               :вим.:    на од    :   мання  :        :К-ть: Дата:Пiдпис:К-ть: Дата:Пiдпис:      :'
*	    @ prow()+1,0 say '-------------------------------------------------------------------------------------------------------------------------------------'
*	    @ prow()+1,0 say '     1     :          2                           : 3  :       4     :     5    :    6   :  7 :  8  :   9  : 10 :  11 :  12  :  13  :'
*	    @ prow()+1,0 say '-------------------------------------------------------------------------------------------------------------------------------------'
*	    npp=0
*	    summa=0
*	    sele c_dosp26
*	    *set order to ivi
*	    go top
*	    do while .not. eof()
*	       gr_ =kod
*	       imgr=im
*	       *@ prow()+1,0 say imgr
*	       sele v_dosp
*	       set order to ivi
*	       set key to str(21,4)
*	       go top
*	       do while .not.eof()
*	          sort_=kod
*	          imsort=im
*	          *@ prow()+1,0 say '!!!!! '+imsort
*	          sele v_kt
*	          set order to igsZ
*	          *set key to STR(mshw,6)+str(gr_,3)+str(sort_,3)+STR(1,1)
*	          set filt to shw=mshw.and.gr=gr_;
*	                              .and.sort=sort_;
*	                              .and.zo=1;
*	                              .and.mar1#63;
*	                              .and.(mar2<51.or.mar2>59);
*	                              .and.(mar3<51.or.mar3>59)
*	          go top
*	          *BROW
*	          scat memv
*	          otp_=0
*	          if .not.eof()
*	             otp_=0
*	             bil=0
*	             na_1=0
*	             skip
*	             do while .not.eof()
*	                if m.kolz#0
*	                   na_1=na_1+m.kolI*m.nrmd
*	                endif
*	                *IF M.KODM=1122
*	                *   wait 'm.kolI*m.nrmd/m.kolz=';
*	                *   +' '+str(m.kolI,3);
*	                *   +' '+str(m.nrmd,8,3);
*	                *   +' '+str(m.kolz,3);
*	                *   +' =  '+str(na_1,8,3);
*	                *    wind
*	                *endif
*	                if kodm#m.kodm
*	                   sele v_rashod
*	                   set filt to
*	                   set order to isk
*	                   set key to mshwz+str(m.kodm,4)
*	                   go top
*	                   sum kol to otp_
*	                   *if eof()
*	                   *   WAIT 'm.kodm='+str(m.kodm,4)+' MSHWZ='+MSHWZ+' нет в RASHOD!!' WIND
*	                   *else
*	                   *   wait 'm.kodm='+str(m.kodm,4)+' otp_='+str(otp_,6,2) wind
*	                   *endif
*	                   *brow
*	                   *wait 'm.kodm='+str(m.kodm,4)+' otp_='+str(otp_,6,2) wind
*	                   sele v_mater
*	                   set order to ikodm
*	                   seek m.kodm
*	                   mater_=naim
*	                   ei_   =ei
*	                   kod_  =kod
*	                   m_kd1=space(40)
*	                   m_kd2=space(40)
*	                   m_kd=naim
*	                   koko=at('\',m_kd)
*	                   if koko#0
*	                      m_kd1=rfix(left(m_kd,koko-1),40)
*	                      m_kd2=subs(m_kd,koko+1)
*	                   endif
*	                   npp=npp+1
*	                   if bil=0
*	                      @ prow()+1,0 say allt(imgr)+' '+allt(imsort)
*	                      bil=1
*	                   endif
*	                   kol_=mpartz2-mpartz1+1
*	                   @ prow()+1,0 say kod_;
*	                                    +' '+m_kd1;
*	                                    +' '+ei_;
*	                                    +' '+str(na_1/kol_,10,4);
*	                                    +' '+str(na_1-otp_,10,4);
*	                                    +' '+iif(otp_#0,str(otp_,10,3),'')
*	                   @ prow()+1,0 say str(m.kodm,4)+space(8)+m_kd2
*	                   na_1=0
*	                   otp_=0
*	                endif
*	                sele v_kt
*	                scat memv
*	                skip
*	             enddo
*	                if m.kolz#0
*	                   na_1=na_1+m.kolI*m.nrmd
*	                endif
*	                *IF M.KODM=1122
*	                *   wait 'enddo m.kolI*m.nrmd/m.kolz=';
*	                *   +' '+str(m.kolI,3);
*	                *   +' '+str(m.nrmd,8,3);
*	                *   +' '+str(m.kolz,3);
*	                *   +' =  '+str(na_1,8,3);
*	                *    wind
*	                *endif
*	             if kodm#m.kodm
*	                sele v_rashod
*	                set filt to
*	                set order to isk
*	                set key to mshwz+str(m.kodm,4)
*	                go top
*	                sum kol to otp_

*	                   *go top
*	                   *if eof()
*	                   *   WAIT 'm.kodm='+str(m.kodm,4)+' MSHWZ='+MSHWZ+' нет в RASHOD!!' WIND
*	                   *else
*	                   *   wait 'm.kodm='+str(m.kodm,4)+' otp_='+str(otp_,6,2) wind
*	                   *endif
*	                *brow
*	                sele v_mater
*	                set order to ikodm
*	                seek m.kodm
*	                mater_=oboz
*	                kod_  =kod
*	                ei_   =ei
*	                m_kd1=space(40)
*	                m_kd2=space(40)
*	                m_kd=naim
*	                koko=at('\',m_kd)
*	                if koko#0
*	                   m_kd1=rfix(left(m_kd,koko-1),40)
*	                   m_kd2=subs(m_kd,koko+1)
*	                endif
*	                npp=npp+1
*	                if bil=0
*	                   @ prow()+1,0 say allt(imgr)+' '+allt(imsort)
*	                   bil=1
*	                endif
*	                @ prow()+1,0 say kod_;
*	                                    +' '+m_kd1;
*	                                    +' '+ei_;
*	                                    +' '+str(na_1/(mpartz2-mpartz1+1),10,4);
*	                                    +' '+str(na_1-otp_,10,4);
*	                                    +' '+iif(otp_#0,str(otp_,10,3),'')
*	                   @ prow()+1,0 say str(m.kodm,4)+space(8)+m_kd2
*	                na_1=0
*	                otp_=0
*	             endif
*	          endif
*	          sele с_dosp21
*	          skip
*	       enddo
*	       sele c_dosp26
*	       skip
*	    enddo
*	    @ prow()+1,0 say '   Начальник ВМТП                         В.Г.Линник'
*	    @ prow()+1,0 say '   Провiдний економiст                    О.А.Рубанова '
*	    @ prow()+1,0 say ''
    set print to
    set device to screen
    
*    do pech
    

