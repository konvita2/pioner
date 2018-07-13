proc swn

LOCAL mpodr
local lddats
lddats=space(20)

DO FORM f_wwod_data to lddats
datan=ctod(subs(lddats,1,10))
datak=ctod(subs(lddats,11))
*wait wind dtoc(datan)+' '+dtoc(datak) 
IF Empty(lddats)
  RETURN -1
ENDIF
if lastkey()#27
   *do f1podr
   DO FORM f_dosp2_vib TO v_dosp2_kod
   *brow
   if v_dosp2_kod # 0
      SELECT * from dosp WHERE vid=2 AND kod=v_dosp2_kod INTO CURSOR cdosp
      mpodr = v_dosp2_kod  
      fl='w.txt'
          
      WAIT WINDOW "Документ формируется..." NOWAIT 
      
      set  print to &fl
      set  device to print
      @prow()+1,0 say ' '
      @prow()+1,0 say '              СВОДНАЯ ВЕДОМОСТЬ'
      @prow()+1,0 say '              начисленной зарплаты '
      @prow()+1,0 say '                рабочих-сдельщиков участка(цеха) '+allt(cdosp.im)

      @prow()+1,0 say '              за период '+dtoc(datan)+' - '+dtoc(datak)
      @prow()+1,0 say '------------------------------------------------------------------------------------------------'
      @prow()+1,0 say ' Ф.И.О            Шифр     Партия      Изделие                                      Итого       '
      @prow()+1,0 say '                 пр-ва    запуска                                              труд.     сумма  '
      @prow()+1,0 say '                                                                                час.    грн.коп.'
      @prow()+1,0 say '------------------------------------------------------------------------------------------------'
      it=0
      id=0
      sele * from kadry ;
           where podr=mpodr ;
           order by fio ;
           into curs ckadry
      SCAN all
      
         sele * from izd into curs c_izd
         SCAN all
            
            sele * from nar ;
                 where shwz=c_izd.shwz ;
                 and tabn=ckadry.tn ;
                 and data_b=>datan ;
                 and data_b=<datak ;
                 into curs cnar
            if recc() > 0
               inormw=0
               irasz =0
               SCAN all
               *do while .not.eof()
                  scat memv
                  sele * from ww ;
                       where ;
                       shwz=m.shwz and kornd=m.kornd and mar=m.mar and nto=m.nto ;
                       into curs cww
                  
                  SCAN all
                     wwnormw=(normw+tpz/m.kzp)*m.kzp/60
                     inormw=inormw+wwnormw
                     wwsetka=setka
                     wwrr   =rr
                     wwtpz  =tpz
                     
                     sele * FROM TARIF WHERE VIDTS = Cww.setka AND RR = Cww.rr ;
                         INTO CURS CTARIF
                     if RECC() > 0
                        MRASZ=dengi*cww.normw
                        irasz=irasz+mrasz 
                     ENDIF
                     USE IN CTARIF
                     *sele 11
                     *skip
                  endscan
                 
               endscan
               @prow()+1,0 say left(bfio,14)+' '+mshwz+' '+str(mpartz1,4)+' '+str(mpartz2,4)+' '+nizd+' '+nribf+' '+str(inormw,9,3)+' '+str(irasz,10,4)
               it=it+inormw
               id=id+irasz
            endif
            
         endscan
         
      ENDSCAN 
      @prow(),75 say str(it,9,2)+'  '+str(id,8,2)
      USE IN cdosp
            
      SET PRINTER TO
      set device to screen
      WAIT WINDOW "Формирование документа окончено." NOWAIT  
		     loWord=CreateObject("Word.Application")       
            loWord.Application.visible=.T.
            WITH  loWord
            	.Documents.open(sys(5)+sys(2003)+"\w.txt",.f.,.t.,.f.,'','',.t.,'','',4,1251)
            	.DisplayAlerts=.F.
            ENDWITH 
            RELEASE loWord  
   endif
endif
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


