fl='rot.txt'
set cursor off
WAIT WINDOW '‘айл ошибок '+fl+'  формируетс€, ∆дите...' NOWAIT
set print to &fl
set device to print

npp=0
select gr,sort,sp,kodm,kod,naim from MATER where gr=0.or.sort=0;
                                 .or.sp=0;
                                 .or.kod='000000000000';
                                 .or.at(' ',kod)>0 ;
                                  order by kodm into curs k2
IF RECCOUNT()>0
   @prow(),0 say 'нуль в коде группы или сорт-та или стандарте поставки или 12-шифр !!! ' 
   scan
      @prow(),0 say str(k2.kodm,4)+' '+k2.kod+' '+k2.naim
   ENDSCAN
ENDIF 
USE IN K2

select dist kodm from mater order by kodm into curs CURSMAT
sele CURSMAT
go top
do while .not.eof()
   kodm_=kodm
   select kodm,naim from MATER where kodm=kodm_ order by kodm into curs k2
   if recc()>1
      @prow(),0 say '!!!  ƒ”ЅЋ»–”≈“—я код '+str(kodm_,4)
      scan
         @prow(),10 say k2.naim
      ENDSCAN 
   ENDIF
   USE IN K2
   sele CURSMAT
   skip
enddo
USE IN CURSMAT

select dist kod from MATER order by kod into curs CURSMAT
sele CURSMAT
go top
do while .not.eof()
   kod_=kod
   select kod,kodm,naim from MATER where kod=kod_ order by kod into curs k2
   if recc()>1
      @prow(),0 say '!!!  ƒ”ЅЋ»–”≈“—я 12-й код '+kod_
      scan
         @prow(),10 say str(k2.kodm,4)+' '+k2.naim
      ENDSCAN 
   ENDIF
   USE IN K2
   sele CURSMAT
   skip
enddo
USE IN CURSMAT


select dist naim from MATER order by naim into curs CURSMAT
sele CURSMAT
go top
do while .not.eof()
   naim_=naim
   select naim,kodm from MATER where naim=naim_ order by naim into curs k2
   if recc()>1
      @prow(),0 say '!!!  ƒ”ЅЋ»–”≈“—я наименование '+naim_
      do while .not.eof()
         @prow(),0 say '    код !!! '+str(kodm,4)
         skip
      ENDDO
   ENDIF
   USE IN K2
   sele CURSMAT
   skip
enddo
USE IN CURSMAT

sele * from mater order by kod into curs c_mat
scan
   scat memv
   sele * from dosp where vid=21.and.kod=c_mat.sort.and.us=c_mat.gr ;
        into curs c_dosp
   SELECT c_dosp
   IF RECCOUNT()=0
      npp=npp+1
      @prow(),0 say str(npp,4);
                     +' нет ссылки сорт-та '+str(c_mat.sort,3);
                     +' на группу '+str(c_mat.gr,2);
                     +' '+c_mat.kod;
                     +' '+c_mat.naim
   ENDIF
   USE IN c_dosp
   sele * from dosp where vid=22.and.kod=c_mat.sp.and.us=c_mat.sort into curs c_dosp
   if recc()=0
      *brow
      npp=npp+1
      @prow(),0 say str(npp,4);
                     +' нет ссылки станд.пост-ки '+str(c_mat.sp,4);
                     +' на сорт-т '+str(c_mat.sort,3);
                     +' '+c_mat.kod;
                     +' '+c_mat.naim
   ENDIF
   USE IN c_dosp
   IF c_mat.sh#0
      SELECT * from dosp WHERE vid=23.and.kod=c_mat.sh.and.us=c_mat.gr INTO CURSOR c_dosp
      if recc()=0
         npp=npp+1
         @prow(),0 say str(npp,4);
                     +' нет ссылки станд.’\Cостава '+str(c_mat.sh,4);
                     +' на группу '+str(c_mat.gr,3);
                     +' '+c_mat.kod;
                     +' '+c_mat.naim
      ENDIF
      USE IN c_dosp
   ENDIF
endscan

set print to
set device to screen
MODIFY FILE rot.txt

