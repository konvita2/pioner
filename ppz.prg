proc ppz
do form f_izd_vib_shwz to mshwz
sele * from izd where shwz = mshwz into curs cizd
if last()#27
   fl='ppz.txt'
   
   WAIT WINDOW "Документ формируется..." NOWAIT   
    
   set  print to &fl
   set  device to print
   @ prow()+1,0 say ' '
   @ prow()+1,0 say '                               ПЛАН-ЗАДАНИЕ '
   @ prow()+1,0 say '                          на порезку заготовок '
   @ prow()+1,0 say '              к изделию '+allt(cizd.ribf)+' '+allt(cizd.im)+'  от '+dtoc(date())
   @ prow()+1,0 say '              № производственного заказа '+allt(mshwz)+' № партии запуска '+allt(str(cizd.partz1))+'-'+allt(str(cizd.partz2))
   @ prow()+1,0 say '---------------------------------------------------------------------------------------'
   @ prow()+1,0 say '№ скл.: Кол-во :   Материал                              :Разм.(мм):Норма вр: Норма   :'
   @ prow()+1,0 say 'карт. :в запус.: № поз.по КД Обознач.и наименование детали  ширина :        : расхода :'
   @ prow()+1,0 say '№ типового техпроцесса                                   :  длина  :Расценка:  (кг)   :'
   @ prow()+1,0 say '---------------------------------------------------------------------------------------'
      inormw=0
      iRASZ =0
   sele * from mater where kodm < m.glMater order by naim into curs cmater
    sele cmater
   go top
   do while .not.eof()
      mnaim  =naim
      mkodm  =kodm
      sele * from ww where ;
           shwz=mshwz and kodm=mkodm and mar=4 and kto=2101 and normw#0;
           into curs cww
      sele cww
      go top
      *brow
      if .not.eof()
         sele cww
         bil=0
         do while .not.eof()
            scat memv
            sele * from tarif where vidts=m.setka and rr=m.rr into curs ctarif
            if recc() > 0
               RASZ_=dengi*m.normw/60
            endif
            use in ctarif
            irasz =irasz +rasz_
            inormw=inormw+m.normw
            sele poznd,naimd from kt ;
                 where poznd = m.poznd into curs ckt
            if recc() > 0
               bnaimd=left(naimd,17)
            else
               bnaimd=m.poznd+' ­ -+- - --+'
            endif
            use in ckt
            sele cww
            if kolz>1
               roz=(rozma-40)/kolz*koli*(cizd.partz2-cizd.partz1+1)+40
            else
               roz=rozma
            endif
            *if bil=0
               @prow()+1,0 say str(kodm,4)+' '+STR(KOLI*(cizd.partz2-cizd.partz1+1),4);
                                          +' '+left(mnaim,50);
                                          +' '+str(roz,6,1);
                                          +' '+str(m.normw,7,3)
               bil=bil+1
            *endif
            @prow()+1,0 say kttp+' '+kornd;
                                +' '+poznd;
                                +' '+bnaimd;
                                +str(rozmb,6,1);
                                +' '+str(rasz_,7,2);
                                +' '+str(nrmd*KOLI*(cizd.partz2-cizd.partz1+1),10,5)
            skip
         enddo
         use in cww
      endif
      sele cmater
      skip
   enddo
   use in cmater
            @prow()+2,0 say 'ИТОГО '+space(62)+str(inormw,7,3)
            @prow()+1,68 say str(irasz,7,2)
   set print to
   set device to screen
   WAIT WINDOW "Формирование документа окончено." NOWAIT  
		     loWord=CreateObject("Word.Application")       
            loWord.Application.visible=.T.
            WITH  loWord
            	.Documents.open(sys(5)+sys(2003)+"\ppz.txt",.f.,.f.,.f.,'','',.t.,'','',0,1251)
            	.DisplayAlerts=.F.
            ENDWITH 
            RELEASE loWord  
endif
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *