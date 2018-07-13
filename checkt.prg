
fl='prow_kt.txt'
WAIT WINDOW 'Ôàéë îøèáîê '+fl+' ôîðìèðóåòñÿ, Æäèòå...' NOWAIT 
set print to &fl
set device to print
*@prow()+1,0 say ' '
*@prow()+1,0 say  '------------------------------------------------------------------------------'
*@prow()+1,0 say  'Êîð.N  Îáîçíà÷åíèå          Íàèìåíîâàíèå                          ì-ò ì-ò'
*@prow()+1,0 say  '------------------------------------------------------------------------------'
sele kod,ribf,im from izd into curs c_izd
sele c_izd
go top
do while .not.eof()
   m.shw=c_izd.kod
   @prow()+3,0 say  'ÈÇÄÅËÈÅ '+STR(c_izd.KOD,2)+' '+c_izd.RIBF+' '+c_izd.IM

   sele shw,poznw,poznd,kornd,kodm1,kol,d_u from kt ;
        where  shw=m.shw.and.d_u=1.and.kol=0 into curs c_kt
   if recc()>0
      @ prow(),0 say   '! ê³ëüê³ñòü íå ìîæå áóòè íóëüîâà '
      scan
         @ prow()+1,0 say 'ìàòåð-ë - '+str(c_kt.kodm1,4);
                                                      +' '+c_kt.kornd;
                                                      +' '+c_kt.poznd;
                                                      +' '+c_kt.poznw
      endscan
   endif
   use in c_kt
   *WAIT 'm.shw='+STR(m.shw,6) wind
   sele kornd,poznd,naimd,mar1,mar2,shw,d_u,kodm1 from kt;
        where shw=m.shw.and.d_u=1.and.kodm1=0 into curs c_kt
   if recc()>0
      @prow(),0 say  'ÂIÄÑÓÒÍIÑÒÜ ÌÀÒÅÐIÀËIÂ'
      scan
         @ prow(),0 say c_kt.kornd+' '+c_kt.poznd+' '+c_kt.naimd+str(c_kt.mar1,5)+str(c_kt.mar2,5)
      endscan
   endif
   use in c_kt
   sele shw,kodm1,kornd,poznd,naimd  from kt where shw=m.shw.and.kodm1#0;
        into curs c_kt
   sele c_kt
   if recc()>0
      sele kodm from mater where kodm=c_kt.kodm1 into curs c_mat
      if recc()>0
         sele c_kt
         scan
            @ prow(),0 say 'íåò â MATER êîäà '+str(c_kt.kodm1,5)+' '+c_kt.kornd+' '+c_kt.poznd+' '+c_kt.naimd
         endscan
      endif
      use in c_mat
   endif
   use in c_kt

   sele shw,d_u,rozma,rozmb,naimd,poznd,kornd,kodm1,mar1,mar2,mar3,mar4,mar5,mar6,mar7,mar8,mar9,mar10 from kt where ;
        shw=m.shw.and.d_u=1;
        .and.rozma=0;
        .and.!empt(poznd);
        .and.kodm1>0;
        .and.kodm1<m.glMater;
        into curs c_kt
   sele c_kt
   go top
   bil=0
   do while .not.eof()
      if mar1=510.or.mar1=580;
                .or.mar2=510.or.mar2=580;
                .or.mar3=510.or.mar3=580;
                .or.mar4=510.or.mar4=580;
                .or.mar5=510.or.mar5=580;
                .or.mar6=510.or.mar6=580;
                .or.mar7=510.or.mar7=580;
                .or.mar8=510.or.mar8=580;
                .or.mar9=510.or.mar9=580;
                .or.mar10=510.or.mar10=580
      else
         bil=bil+1
         if bil=1
            @prow(),0 say  'ÂIÄÑÓÒÍIÑÒÜ ÐÎÇÌIÐIÂ'
         endif
         @ prow(),0 say c_kt.kornd+' '+c_kt.poznd+' '+c_kt.naimd
      endif
   skip
enddo
   bil=0
   select distinct poznd from kt where shw=m.shw and d_u=2 into curs p_2
   sele p_2
   go top
   do while .not.eof()
      poznd_=poznd
      select kornd, poznd, naimd from kt where shw=M.shw and poznd=poznd_ and d_u=2;
        into curs c_3
      if recc()<2
         bil=bil+1
         if bil=1
            @prow()+1,0 say  '                      íåðîçêðèòèé âóçîë'
         endif
         @ prow()+1,0 say kornd+' '+poznd+' '+naimd
      endif
      sele p_2
      skip
   enddo
   sele c_izd
   skip
enddo
sele dist poznd from kt where !empt(poznd) into curs cdet
go top
do while .not.eof()
   poznd_=poznd
   sele poznd, naimd, poznw, naimw, pozn from kt where poznd=poznd_ and poznd#poznw  into curs c_
   go top
   if recc()> 1
      naimd_=naimd
      pipi=0
      *@ prow()+1,0 say poznd+' '+naimd+' '+str(recc(),3)
      do while .not.eof()
         if naimd#naimd_
            *wait 'buf '+naimd_+'-'+naimd wind
            if last()=27
               retu
            endif
            pipi=pipi+1
         endif
         skip
      enddo
      if pipi>1
         go top
         @ prow(),0 say ' '
         do while .not.eof()
            @ prow(),0 say left(poznd,16)+' '+naimd+' '+left(poznw,16)+' '+naimw+' '+left(pozn,16)
            skip
         enddo
      endif
   endif
   sele cdet
   skip
enddo
use in cdet
use in c_

sele dist poznd from kt where !empt(poznd) into curs cdet
go top
do while .not.eof()
   poznd_=poznd
   sele poznd, naimd, kodm, rozma, rozmb, kolz from kt where poznd=poznd_ and poznd#poznw  into curs c_
   go top
   if recc()> 1
      @ prow(),0 say ' '
      do while .not.eof()
         @ prow(),0 say poznd+' '+naimd;
                               +' '+str(kodm,4);
                               +' '+str(rozma,6,1);
                               +' '+str(rozmb,6,1);
                               +' '+str(kolz,3)
         skip
      enddo
   endif
   sele cdet
   skip
enddo
use in cdet
use in c_
deac wind good
set print to
set device to screen
deac wind qood
MODIFY FILE prow_kt.txt
retu

