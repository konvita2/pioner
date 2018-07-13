proc ppp
local lddats
lddats=''
DO FORM f_wwod_data to lddats
IF Empty(lddats)
  RETURN -1
ENDIF
datan=ctod(subs(lddats,1,10))
datak=ctod(subs(lddats,11))
*wait wind dtoc(datan)+' '+dtoc(datak) 

DO FORM f_dosp5_vib TO v_dosp5_kod
IF Empty(v_dosp5_kod)
  RETURN -1
ENDIF
*WAIT WINDOW STR(v_dosp5_kod)
SELECT * from dosp WHERE vid=5 AND kod=v_dosp5_kod INTO CURSOR cdosp
*brow

fl='w.txt'

 WAIT WINDOW "Документ формируется..." NOWAIT 

set  print to &fl
set  device to print
@prow()+1,0 say ' '
@prow()+1,0 say '                         ПЛАН'
@prow()+1,0 say '              производства по профессии '+cdosp.im
@prow()+1,0 say '              на период '+dtoc(datan)+' - '+dtoc(datak)
@prow()+1,0 say '---------------------------------------------------------------------------------'
@prow()+1,0 say '                Изделие          Шифр   Партия   Трудоемкость   Кол-во      Дата '
@prow()+1,0 say '                                запуска запуска базов. текущ.   рабочих   запуска'
@prow()+1,0 say '                                                час      час   план факт    Дата '
@prow()+1,0 say '                                                 еловекочасы              выпуска'
@prow()+1,0 say '---------------------------------------------------------------------------------'
itb=0
icb=0
itt=0
ict=0
sele * from izd order by shwz into curs c_izd
SCAN all
   *wait
   *wait 'shwz='+c_izd.shwz+' prof='+str(prof,4) WINDOW nowait
   *brow fiel shwz,kodp
   *SELECT shwz,kodp,setka,rr,kol,normw FROM ww ;
   *        where shwz=c_izd.shwz and kodp=v_dosp_kod
  
   SELECT * FROM ww ;
          where shwz=c_izd.shwz ;
          and kodp = v_dosp5_kod ;
          into curs cww
   WAIT WINDOW c_izd.shwz nowait
   *brow fiel shwz,kodp,normw,kol
   tb=0
   cb=0
   tt=0
   ct=0
   if recc() > 0
      SCAN all
         trud=cww.normw*cww.kol/60
         tb=tb+trud
         if cdosp.us#0
            chch=cww.normw*cww.kol*100/60/cdosp.us
         else
            chch=0
         endif
         cb=cb+chch
         
         trud=cww.normw*cww.kzp/60
         tt=tt+trud
         if cdosp.us#0
            chch=cww.normw*cww.kzp*100/60/cdosp.us
         else
            chch=0
         endif
         ct=ct+chch
      endscan
   ENDIF
   USE IN cww
      @prow()+1,10 say c_izd.ribf+' '+c_izd.shwz+str(c_izd.partz1,5)+' '+str(tb,10,1)+' '+str(tt,9,1)+space(10)+dtoc(c_izd.data_p)
      @prow()+1,0 say c_izd.im+str(c_izd.partz2,5)+' '+str(cb,9,1)+' '+str(ct,9,1)+space(10)+dtoc(c_izd.data_z)
      itb=itb+tb
      icb=icb+cb
      itt=itt+tt
      ict=ict+ct
      
ENDSCAN 
USE IN c_izd
@prow()+2,4 say 'ИТОГО'
      @prow()+1,43 say str(itb,10,2)+' '+str(itt,10,2)
      @prow()+1,43 say str(icb,10,2)+' '+str(ict,10,2)
USE IN cdosp
SET PRINTER to
set device to screen
   WAIT WINDOW "Формирование документа окончено." NOWAIT  
		    * loWord=CreateObject("Word.Application")       
            *loWord.Application.visible=.T.
            *WITH  loWord
           * 	.Documents.open("D:\work\vitaly\rotor\w.txt")
           * 	.DisplayAlerts=.F.
           * ENDWITH 
           * RELEASE loWord  

LOCAL loWord
loWord = CREATEOBJECT ('Word.Application')  
WITH loWord
	.DOcuments.Open(sys(5)+SYS(2003)+'\w.txt',.f.,.t.,.f.,'','',.t.,'','',4,1251)
	.DisplayAlerts = .F.
ENDWITH
loWord.Visible = .t.
*loWord.activeWindow.SelectedSheets.PrintPreview

retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

