proc nzps

*do f1podr
DO FORM f_dosp2_vib TO v_dosp2_kod
*WAIT WINDOW STR(v_dosp2_kod)

if !empt(v_dosp2_kod)
   SELECT * from dosp WHERE vid=2 AND kod=v_dosp2_kod INTO CURSOR cdosp
   mpodr = v_dosp2_kod
   fl='w.txt'
   
   WAIT WINDOW "Документ формируется..." NOWAIT 
   
   set  print to &fl
   set  device to print
   @prow()+1,0 say '                            ВЕДОМОСТЬ'
   @prow()+1,0 say '                    незавершенного производства '
   @prow()+1,0 say '                    цеха (участка) '+allt(str(mpodr))
   @prow()+1,0 say '----------------------------------------------------------------------------------------'
   @prow()+1,0 say 'Кор.№  Наименование         Трудоемкость н\час. Расценка грн.коп.   %    Матер. затраты '
   @prow()+1,0 say '                             базовая  фактич.    базовая  фактич.  гот. базовые  фактич.'
   @prow()+1,0 say '----------------------------------------------------------------------------------------'
   
   iiinormf = 0
   iiiraszf = 0
   iiimatf  = 0
   iiinormt = 0
   iiiraszt = 0
   iiimatt  = 0
   mar_     = mpodr
   
   sele * from izd where !empt(shwz) into curs c_izd
   SCAN all
        
      iinormf=0
      iiraszf=0
      iimatf =0
      iinormt=0
      iiraszt=0
      iimatt =0
      sele * from kt where ;
              shw=c_izd.kod and (mar1=mar_;
                              or mar2=mar_;
                              or mar3=mar_;
                              or mar4=mar_;
                              or mar5=mar_;
                              or mar6=mar_;
                              or mar7=mar_;
                              or mar8=mar_;
                              or mar9=mar_;
                              or mar10=mar_) ;
            into curs ckt                  
      if recc() > 0
         inormf=0
         iraszf=0
         imatf =0
         inormt=0
         iraszt=0
         imatt =0
         if empt(kornd)
            kn=kornd
         else
            kn=kornw
         endif
         sele * from ww ;
                where ;
                shwz = c_izd.shwz and mar=mpodr and kodm > 0 and kodm < m.glMater;
                into curs cww
         if recc() > 0
            *if c_izd.shwz='КЛ-Р-2-4'
            *   brow fiel mar,kodm
            *endif

            *if empt(kornd)
            *   nom=kornw
            *   nam=poznw
            *else
            *   nom=kornd
            *   nam=poznd
            *endif
            SCAN all

            	sele kodm,cena from OSTATOK ; 
                     where kodm = cww.kodm ;
                     into curs c_ostatok
                if recc() > 0
                   *wait wind 'МАТЕРИАЛ '+str(c_ostatok.kodm,5)
                   mcena=c_ostatok.cena
                else
                   mcena=0
                endif
                use in c_ostatok
            
                imatf = imatf + mcena*cww.kzp/1000
                imatt = imatt + mcena*cww.kolz/1000
                IF cww.kzp > 0
                   wwnormw=(cww.normw+cww.tpz/cww.kzp)*cww.kzp/60
                ELSE
                   wwnormw=0
                ENDIF 
                IF cww.kolz > 0
                   wwnormt=(cww.normw+cww.tpz/cww.kolz)*cww.kolz/60
                ELSE
                   wwnormt=0
                ENDIF 
               
                sele * FROM TARIF WHERE VIDTS = Cww.setka AND RR = Cww.rr ;
                       INTO CURS CTARIF
                MRASZf=0
                MRASZt=0
                if RECC() > 0
                   MRASZf=dengi*wwnormw
                   MRASZt=dengi*wwnormt
                ENDIF
                USE IN CTARIF
               
                inormf = inormf + wwnormw
                iraszf = iraszf + mraszf
                inormt = inormt + wwnormt
                iraszt = iraszt + mraszt
                *skip
            *enddo
            endscan
            
            pr=0
            if iraszt#0
               pr=iraszf/iraszt*100
            endif
            *@prow()+1,0 say nom+' '+nam+' '+str(inormt,8,2)+' '+str(inormf,8,2)+' '+str(iraszt,8,2)+' '+str(iraszf,8,2)+' '+str(pr,5,2)+' '+str(imatf,8,3)+' '+str(imatt,8,3)
            iinormf=iinormf+inormf
            iiraszf=iiraszf+iraszf
            iimatf =iimatf +imatf
            iinormt=iinormt+inormt
            iiraszt=iiraszt+iraszt
            iimatt =iimatt +imatt
         endif
      endif
      pr=0
      if iiraszt#0
         pr=iiraszf/iiraszt*100
      endif
      @prow()+1,0 say c_izd.shwz+' '+c_izd.ribf ;
                                      +' '+str(iinormt,8,2) ;
                                      +' '+str(iinormf,8,2) ;
                                      +' '+str(iiraszt,8,2) ;
                                      +' '+str(iiraszf,8,2) ;
                                      +' '+str(pr,5,2) ;
                                      +' '+str(iimatf,8,3) ;
                                      +' '+str(iimatt,8,3)
      @prow()+1,0 say dtoc(c_izd.data_p)+' '+dtoc(c_izd.data_z)+' '+c_izd.im+' '+str(c_izd.partz1)+' '+str(c_izd.partz2)
      iiinormf=iiinormf+iinormf
      iiiraszf=iiiraszf+iiraszf
      iiimatf =iiimatf +iimatf
      iiinormt=iiinormt+iinormt
      iiiraszt=iiiraszt+iiraszt
      iiimatt =iiimatt +iimatt

   ENDSCAN 
   USE IN c_izd
   pr=0
   if iiiraszt#0
      pr=iiiraszf/iiiraszt*100
   endif
   @prow(),24 say 'ИТОГО'
   @prow(),30 say str(iiinormt,8,2)+' '+str(iiinormf,8,2)+' '+str(iiiraszt,8,2)+' '+str(iiiraszf,8,2)+' '+str(pr,5,2)+' '+str(iiimatf,8,3)+' '+str(iiimatt,8,3)
   
   SET prin to
   set device to screen
   WAIT WINDOW "Формирование документа окончено." NOWAIT  
	        loWord=CreateObject("Word.Application")       
            loWord.Application.visible=.T.
            WITH  loWord
            	.Documents.open(sys(5)+sys(2003)+"\w.txt",.f.,.f.,.f.,'','',.t.,'','',0,1251)
            	.DisplayAlerts=.F.
            ENDWITH 
            RELEASE loWord  
endif
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

