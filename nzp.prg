proc nzp
*publ imv,mpozn,mshw,mshwz,mdata_p,mdata_z
*do f1podr
DO FORM f_dosp2_vib TO v_dosp2_kod
if empt(v_dosp2_kod)
   return - 1
endif
SELECT * from dosp WHERE vid=2 AND kod=v_dosp2_kod INTO CURSOR cdosp
mpodr = v_dosp2_kod

do FORM f_izd_vib_shwz TO mshwz
SELECT * from izd WHERE shwz=mshwz INTO CURSOR c_izd
if last()#27
   fl='w.txt'
      
   WAIT WINDOW "Документ формируется..." NOWAIT 
      
   set  print to &fl
   set  device to print
   @prow()+1,0 say '                            ВЕДОМОСТЬ'
   @prow()+1,0 say '                    незавершенного производства '
   @prow()+1,0 say '                    цеха (участка) '+allt(str(mpodr))+' по изделию '+C_IZD.RIBF
   @prow()+1,0 say '                 производственный шифр'+allt(mshwz)+'  партия запуска '+allt(str(C_IZD.partz1))+' - '+allt(str(C_IZD.partz2))
   @prow()+1,0 say '                 дата запуска '+dtoc(C_IZD.data_z)+'     дата выпуска '+dtoc(C_IZD.data_p)
   @prow()+1,0 say ''
   @prow()+1,0 say '----------------------------------------------------------------------------------------'
   @prow()+1,0 say 'Кор.№  Наименование         Трудоемкость н\час. Расценка грн.коп.   %    Матер. затраты '
   @prow()+1,0 say '                             базовая  фактич.    базовая  фактич.  гот. базовые  фактич.'
   @prow()+1,0 say '----------------------------------------------------------------------------------------'
   sele * from kt where ;
          shw = C_IZD.KOD into curs ckt
   if recc() = 0
      wait mshwz+' - НЕТ ТАКОГО ИЗДЕЛИЯ В СВИ !!!' wind
   ELSE   
      *do while .not.eof()
      *BROW
      SCAN ALL   
         WAIT WINDOW 'ДЕТАЛЬ '+CKT.POZND NOWAIT
         sele * FROM WW ; && 11
              WHERE ;
              Shwz=mshwz and mar=mpodr and kornd=CKT.kornd ;
              INTO CURS CWW
         if RECC() > 0
            inormf=0
            iraszf=0
            imatf =0
            inormt=0
            iraszt=0
            imatt =0
            
            *mkodm=kodm
            sele kodm,cena from OSTATOK ;
                 where kodm= cww.kodm ;
                 into curs c_ostataok
            if recc() > 0
              mcena=cena
            else
               mcena=0
            endif
            imatt=mcena*CWW.kzp/1000
            imatf=mcena*CWW.kolz/1000
            SCAN ALL
            *do while .not.eof()
               IF cww.kzp > 0
                  wwnormw=(CWW.normw+CWW.tpz/CWW.kzp)*CWW.kzp/60
               ELSE
                  wwnormw = 0
               ENDIF
               IF cww.kolz > 0
                  wwnormt = (CWW.normw+CWW.tpz/CWW.kolz)*CWW.kolz/60
               ELSE
                  wwnormt = 0
               endif
               sele * FROM TARIF WHERE VIDTS = Cww.setka AND RR = Cww.rr ;
                      INTO CURS CTARIF
               if RECC() > 0
                  MRASZf=dengi*wwnormw
                  MRASZt=dengi*wwnormt
               ENDIF
               USE IN CTARIF
               inormf=inormf+wwnormw
               iraszf=iraszf+mraszf
               * iraszf=iraszf+kzp*mraszf
               inormt=inormt+wwnormt
               iraszt=iraszt+mraszt
               *sele CWW
               *skip
            ENDSCAN
            *enddo
            USE IN cww
            pr=0
            if iraszt#0
               pr=iraszf/iraszt*100
            endif
            @prow()+1,0 say Ckt.KORND+' '+Ckt.POZND+' '+str(inormt,8,2)+' '+str(inormf,8,2)+' '+str(iraszt,8,2)+' '+str(iraszf,8,2)+' '+str(pr,5,2)+' '+str(imatf,8,3)+' '+str(imatt,8,3)
         endif
         *sele CKT
         *skip
      ENDSCAN
      *enddo
      USE IN CKT
      
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

