proc pzr

do form f_izd_vib_shwz to mshwz
if empt(mshwz)
   return - 1
endif
sele * from izd where shwz = mshwz into curs c_izd

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
do form f_kwp to kol_w
kol_r=datak-datan+1-kol_w
rele wind god

DO FORM f_dosp2_vib TO v_dosp2_kod
if empt(v_dosp2_kod)
   return - 1
endif
SELECT * from dosp WHERE vid=2 AND kod=v_dosp2_kod INTO CURSOR cdosp
*brow

local arra m[10]
store 0 to m

fl='w.txt'

  WAIT WINDOW "Документ формируется..." NOWAIT   

set  print to &fl
set  device to print
@ prow()+1,0 say ' '
@ prow()+1,0 say '                      ПЛАН-ЗАДАНИЕ'
@ prow()+1,0 say 'на выполнение работ по участку '+allt(cdosp.im)
@ prow()+1,0 say '              на период '+dtoc(datan)+' - '+dtoc(datak)
@ prow()+1,0 say 'изделие '+allt(c_izd.im)+' '+allt(c_izd.ribf)+' '+mshwz+' '+' партия запуска '+allt(str(c_izd.partz1,4))+' - '+allt(str(c_izd.partz2,4))
@ prow()+1,0 say '-------------------------------------------------------------------------------'
@ prow()+1,0 say '№ опер.   Наименование                     Кол-во        Норма         ИТОГО  '
@ prow()+1,0 say 'узел,деталь :№ поз,по КД:                деталей        на 1 ед.         мин.  '
@ prow()+1,0 say '                                                        Расценка               '
@ prow()+1,0 say '                                                        на 1 ед.       грн.коп.'
@ prow()+1,0 say '-------------------------------------------------------------------------------'
sele * from kadry where podr=cdosp.kod into curs ckadry
sele ckadry
go top
kolr=0
ivr =0
itr =0
ir=0
in=0
SCAN all
   kolr=kolr+1
   ivr =ivr +vr
ENDSCAN 

sr_vr=ivr/kolr
*wait 'средняя выработка по кчастку '+str(cdosp.kod,3)+' ='+str(sr_vr,5,3) wind nowait
*  wait 'minwn '+minwn  wind
*  brow fiel kodo
mnvr=kolr * kol_r * 8.2 * sr_vr * 60
sele * from ww where ;
     shwz=mshwz.and.mar=cdosp.kod.and.pri=0 ;
     into curs cww
     sele cww
go top
*brow
if .not.eof()
   SCAN all
           
      SELECT shw,poznd,mar1,mar2,mar3,mar4,mar5,mar6,mar7,mar8,mar9,mar10 FROM kt ;
             WHERE shw=c_izd.kod AND poznd=cww.poznd AND !empt(mar1) ;
             INTO CURSOR c_kt
      go top
      if .not.eof()
         if cdosp.kod=mar1
            mara=0
         endif
         if cdosp.kod=mar2
            mara=mar1
         endif
         if cdosp.kod=mar3
            mara=mar2
         endif
         if cdosp.kod=mar4
            mara=mar3
         endif
         if cdosp.kod=mar5
            mara=mar4
         endif
         if cdosp.kod=mar6
            mara=mar5
         endif
         if cdosp.kod=mar7
            mara=mar6
         endif
         if cdosp.kod=mar8
            mara=mar7
         endif
         if cdosp.kod=mar9
            mara=mar8
         endif
         if cdosp.kod=mar10
            mara=mar9
         endif
      else
         wait 'нет в СВИ маршрута по детали '+cww.poznd wind
      endif
      USE IN c_kt
      sele shwz,mar,poznd,nto,kzp from ww ;
           where shwz=c_izd.shwz and mar=cdosp.kod ;
                                and poznd=cww.poznd ;
                                and nto=cww.nto ;
                                into curs ckzp
                            
      sum kzp to ikzp
      USE IN ckzp
      SELECT cww
      if empt(kornd)
         kn=kornw
         ri=poznw
      else
         kn=kornd
         ri=poznd
      endif
      mkto=kto
      sele * from dosp ;
           where vid=7 and kod=mkto ;
           into curs cdosp7
      if recc() > 0
         nkto=im
      else
         nkto=space(20)
      ENDIF
      USE IN cdosp7
      sele cww
      tr=normw*(kol-ikzp)
      nnn=kol-ikzp
      *WAIT 'nnn=kol-ikzp kol='+str(kol,3)+' ikzp='+str(ikzp,3)+'nnn='+str(nnn,3)  wind
      itr=itr+tr
      *wait 'nvr='+str(nvr,6)+' itr='+str(itr,6) wind
      if itr>mNVR
         *go bott
         exit
      ENDIF
      sele * from tarif ;
              where ;
              vidts = cww.setka and rr = cww.rr ;
              into curs ctarif
      if recc() > 0
         MRASZ=dengi*cww.normw/60
      endif
      r=mrasz*nnn
      ir=ir+r
      in=in+nnn*cww.normw
      if nnn#0
         @prow()+1,0 say str(cww.nto,4)+' '+LEFT(nkto,40)+' '+str(nnn,3);
                                   +'      '+str(cww.normw,9,3);
                                   +'      '+str(nnn*cww.normw,7,2)
         @prow()+1,0 say ri+' '+kn+space(27)+str(mrasz,10,4);
                                  +'      '+str(r,6,2)
      endif
      
   ENDSCAN 
   @prow()+1,69 say str(in,8,2)
   @prow()+1,69 say str(ir,8,2)
ENDIF
 
USE IN cdosp
set print to
set device to screen
WAIT WINDOW "Формирование документа окончено." NOWAIT  
*            loWord=CreateObject("Word.Application")       
*            loWord.Application.visible=.T.
*            WITH  loWord
*            	.DOcuments.Open(sys(5)+SYS(2003)+'\w.txt')
*            	.DisplayAlerts=.F.
*            ENDWITH 
            
            LOCAL loWord
loWord = CREATEOBJECT ('Word.Application')  
WITH loWord
	.DOcuments.Open(sys(5)+SYS(2003)+'\w.txt',.f.,.f.,.f.,'','',.t.,'','',0,1251)
	.DisplayAlerts = .F.
ENDWITH
loWord.Visible = .t.
*loWord.activeWindow.SelectedSheets.PrintPreview

            RELEASE loWord  

return

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

*loWord.activeWindow.SelectedSheets.PrintPreview
