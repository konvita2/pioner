proc pzo

*do period
local lddats
lddats=space(20)

DO FORM f_wwod_data to lddats
IF Empty(lddats)
  RETURN -1
ENDIF

datan=ctod(subs(lddats,1,10))
datak=ctod(subs(lddats,11))
*wait wind dtoc(datan)+' '+dtoc(datak) 

   DO FORM f_obor_vib TO v_obor_marka
   *wait window v_obor_marka
   IF Empty(v_obor_marka)
      RETURN -1
   ENDIF

   sele * from obor where marka=v_obor_marka into curs cobor  && OBOR
   *brow
   fl='pzo.txt'
   SET print to &fl
   set  device to print
   
   WAIT WINDOW "Документ формируется..." NOWAIT 
   
   @prow()+1,0 say ' '
   @prow()+1,0 say '                        ПЛАН'
   @prow()+1,0 say '               производства подразделения по оборудованию '+cobor.marka
   @prow()+1,0 say '               на период '+dtoc(datan)+' - '+dtoc(datak)
   
   
   @prow()+1,0 say '--------------------------------------------------------------------------------' 
   @prow()+1,0 say '                   Шифр   Партия     Базовая     Текущая   Наличие    Дата      '
   @prow()+1,0 say '    ИЗДЕЛИЕ       запуска запуска    трудоем.    трудоем.            запуска    ' 
   @prow()+1,0 say '                                       час         час                 Дата     '
   @prow()+1,0 say '                                    станкочасы           Потребность выпуска    '
   @prow()+1,0 say '--------------------------------------------------------------------------------'
   
   LOCAL ibt, ibc, itt, itc
   STORE 0 TO ibt, ibc, itt, itc 
   LOCAL iibt,iibc,iitt,iitc
   STORE 0 TO iibt,iibc,iitt,iitc
   sele * from IZD order by shwz into curs c_izd
   SELECT c_izd
   go top
   do while .not.eof()
      WAIT WINDOW 'ИЗДЕЛИЕ '+shwz nowait  
      sele * from WW ;
           where ;
           shwz = c_izd.shwz ; 
           and ALLTRIM(kodo)==ALLTRIM(cobor.marka) ;
           into curs cww
      SELECT cww
      go top
      
      if RECCOUNT() > 0
            ibt=0
            ibc=0
            itt=0
            itc=0
            ttrud=0
            tchch=0
         do while .not.eof()
           
            if kzp>0
               ttrud=cww.normw*cww.kzp/60
               tchch=cww.normw*cww.kzp*100/60/cobor.wr
            endif
            trud=cww.normw*cww.kolz/60
            *WAIT WINDOW 'trud='+STR(trud) NOWAIT 
            chch=cww.normw*cww.kolz*100/60/cobor.wr
            ibt=ibt+trud
            ibc=ibc+chch
            itt=itt+ttrud
            itc=itc+tchch
            SELECT cww
            skip
         ENDDO
         USE IN cww
         @prow()+1,0 say c_izd.ribf+' '+c_izd.shwz+'   '+str(c_izd.partz1,5)+' '+str(ibt,9,2)+' '+str(itt,10,2)+space(12)+dtoc(c_izd.data_p)
         @prow()+1,0 say LEFT(c_izd.im,31)+' '+str(c_izd.partz2,5)+' '+str(ibc,9,2)+' '+str(itc,10,2)+space(12)+dtoc(c_izd.data_z)
         iibt=iibt+ibt
         iibc=iibc+ibc
         iitt=iitt+itt
         iitc=iitc+itc
      endif
      sele c_izd
      skip
   ENDDO
   USE IN c_izd
   @prow(),3 say 'ИТОГО '
   @prow(),37 say str(iibt,10,2)+' '+str(iitt,10,2)
   @prow(),37 say str(iibc,10,2)+' '+str(iitc,10,2)
   USE IN cobor
   
   SET print to
   set device to screen
   WAIT WINDOW "Формирование документа окончено." NOWAIT  
		    * loWord=CreateObject("Word.Application")       
            *loWord.Application.visible=.T.
            *WITH  loWord
           * 	.Documents.open(sys(5)+sys(2003)+'\pzo.txt')
           * 	*.Documents.open("D:\work\vitaly\rotor\pzo.txt")
           * 	.DisplayAlerts=.F.
           * ENDWITH 
           * RELEASE loWord  
           
LOCAL loWord
loWord = CREATEOBJECT ('Word.Application')  
WITH loWord
	.DOcuments.Open(sys(5)+SYS(2003)+'\pzo.txt',.f.,.t.,.f.,'','',.t.,'','',4,1251)
	.DisplayAlerts = .F.
ENDWITH
loWord.Visible = .t.
*loWord.activeWindow.SelectedSheets.PrintPreview
RELEASE loWord
           
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

*	 


















