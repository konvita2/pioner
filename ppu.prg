proc ppu                && Ї« ­ Ї® гз бвЄг
*publ datan,datak,mpozn,mkodp,nkodp,mus
*do period
local lddats
lddats=space(20)

DO FORM f_wwod_data to lddats
datan=ctod(subs(lddats,1,10))
datak=ctod(subs(lddats,11))
*wait wind dtoc(datan)+' '+dtoc(datak) 
IF Empty(lddats)
  RETURN -1
ENDIF

*do f1podr
DO FORM f_dosp2_vib TO v_dosp2_kod
if empt(v_dosp2_kod)
   return - 1
endif
*WAIT WINDOW STR(v_dosp2_kod)
SELECT * from dosp WHERE vid=2 AND kod=v_dosp2_kod INTO CURSOR c_dosp_2

fl='ppu.txt'


WAIT WINDOW "Документ формируется..." NOWAIT 


set  print to &fl
set  device to print
@prow()+1,0 say ' '
@prow()+1,0 say '                         ПЛАН'
@prow()+1,0 say '              производства по участкам'+str(c_dosp_2.kod,4)+' '+ALLTRIM(c_dosp_2.im)
@prow()+1,0 say '              на период '+dtoc(datan)+' - '+dtoc(datak)
@prow()+1,0 say '------------------------------------------------------------------------------------'
@prow()+1,0 say '                Изделие          Шифр   Партия    Трудоемкость    Кол-во      Дата  '
@prow()+1,0 say '                                запуска запуска базовая текущая    рабочих   запуска'
@prow()+1,0 say '                                                 час      час    план факт    Дата  '
@prow()+1,0 say '                                                  человекочасы               выпуска'
@prow()+1,0 say '------------------------------------------------------------------------------------'

itb=0
icb=0
itt=0
ict=0

sele * from izd WHERE PARTZ1 # 0 order by im into curs c_izd
SELECT c_izd
GO top
*SCAN all
DO WHILE .not.eof()   
   WAIT WINDOW 'ИЗДЕЛИЕ '+c_izd.shwz NOWAIT 
   sele * from dosp where vid = 5 and kod > 0 order by im into curs c_dosp_5
   SCAN all 
   WAIT WINDOW 'ПРОФЕССИЯ '+C_DOSP_5.IM NOWAIT
   
   sele * from ww ;
              where ;
              shwz=c_izd.shwz and kodp=c_dosp_5.kod and mar=c_dosp_2.kod  ;
              into curs cww
   
         *brow fiel shwz,kodp
   tb=0
   cb=0
   tt=0
   ct=0
   if recc() > 0
      *brow
      SCAN all
           trud = CWW.normw * CWW.kol / 60
           tb   = tb + trud
           if C_DOSP_5.us # 0
              chch = CWW.normw * CWW.kol * 100 / 60 / C_DOSP_5.us
           else
              chch=0
           endif
           cb=cb+chch
            
           if CWW.KZP > 0
              trud = CWW.normw * CWW.kzp / 60
              tt   = tt + trud
              if CDOSP.us # 0
                 chch = CWW.normw * CWW.kzp * 100 / 60 / C_DOSP_5.us
              else
                 chch = 0
              endif
              ct = ct + chch
           endif
      ENDSCAN
               
      @prow()+1,0 say c_dosp_5.im
      @prow()+1,10 say c_izd.ribf+' '+c_izd.shwz+' '+str(c_izd.partz1,5)+' '+str(tb,10,2)+' '+str(tt,8,2)+space(10)+dtoc(c_izd.data_p)
      @prow()+1,0 say LEFT(c_izd.im,38)+space(2)+str(c_izd.partz2,5)+' '+str(cb,10,2)+' '+str(ct,8,2)+space(10)+dtoc(c_izd.data_z)
      itb=itb+tb
      icb=icb+cb
      itt=itt+tt
      ict=ict+ct
   endif
         *sele 1
         *skip
   ENDSCAN
   USE IN c_dosp_5
   *enddo
   sele c_izd
   skip
*endscan
enddo
use in c_dosp_2
use in c_izd
@prow()+2,4 say 'ИТОГО'
      @prow()+1,43 say str(itb,10,2)+' '+str(itt,10,2)
      @prow()+1,43 say str(icb,10,2)+' '+str(ict,10,2)

SET PRINTER to
set device to screen

 WAIT WINDOW "Формирование документа окончено." NOWAIT  
		     loWord=CreateObject("Word.Application")       
            loWord.Application.visible=.T.
            WITH  loWord
            	.Documents.open(sys(5)+sys(2003)+"\ppu.txt",.f.,.t.,.f.,'','',.t.,'','',4,1251)
            	.DisplayAlerts=.F.
            ENDWITH 
            RELEASE loWord  

retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
PROCEDURE RETU_
cancel
retu