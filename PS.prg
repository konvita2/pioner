proc ps
k_s=0
*wait 'proc ps' wind
do f1izd
if last()=27
   retu
endif
set excl on
sele 77
use kt_svi
zap
if .not.file ('kt_svi.cdx')
   inde on poznd tag ipoznd
endif

sele 2
set filt to
set order to ipoznd
*set filt to shw=mshw.and.!empt(poznd).and.!empt(kol)
set key to str(mshw,6)
go top
do while .not.eof()
   if !empt(poznd).and.!empt(kol).and.zo=0
      scat memv
      sele 77
      set order to ipoznd
      seek m.poznd
      if .not.foun()
         appe blan
         gath memv
      endif
   endif
   sele 2
   skip
enddo
go top
fl='ps.txt'
acti wind good
@ 0,1 say 'Файл '+fl+' формируется'
@ 1,1 say 'Ждите...'
set print to &fl
set device to print
DO SHAP1
sele 77
set key to
go top
npp=0
do while .not.eof()
   scat memv
   sele 2
   set key to str(mshw,6)+m.poznd
   go top
   do while.not.eof()
      if kol#0.and.zo=0
         npp=npp+1
         do pipi
      endif
      skip
   enddo
   sele 77
   skip
enddo
sele 2
set order to ipoznd
*set filt to shw=mshw.and.empt(poznd).and.!empt(kodm)
set key to str(mshw,6)
go top
do while .not.eof()
   if empt(poznd).and.!empt(kodm).and.zo=0
      npp=npp+1
      do pipi
   endif
   skip
enddo


@prow(),1 say chr(12)
do shap2
k_s=0
sele 77
set key to
go top
npp=0
do while .not.eof()
   scat memv
   sele 2
   set key to str(mshw,6)+m.poznd
   go top
   do while.not.eof()
      if kol#0.and.zo=0
         npp=npp+1
         do pipi2
      endif
      skip
   enddo
   sele 77
   skip
enddo
sele 2
set order to ipoznd
*set filt to shw=mshw.and.empt(poznd).and.!empt(kodm)
set key to str(mshw,6)
go top
do while .not.eof()
   if empt(poznd).and.!empt(kodm).and.zo=0
      npp=npp+1
      do pipi2
   endif
   skip
enddo
sele 77
use
deac wind good
set print to
set device to screen
deac wind qood
do pech
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc pipi
koko=0
m_kd1=''
m_kd2=''
m_td1=''
m_td2=''
mkodm=kodm
ktpoznd=poznd
if mkodm<m.glMater
   sele 4
   set order to ikodm
   seek mkodm
   if foun()
      m_kd=naim
      koko=at('\',m_kd)
      if koko#0
         m_kd1=rfix(left(m_kd,koko-1),40)
         m_kd2=subs(m_kd,koko+1)
      endif
   endif
else
   sele 29
   set order to ikodm
   seek mkodm
   if foun()
      m_kd1=left(naim,40)
*      @prow()+1,0 say '!!!'+m_kd1
   endif
endif
sele 5
set order to ipoznd
seek ktpoznd
if foun()
   tekodm=kodm
   sele 4
   set order to ikodm
   seek tekodm
   if foun()
      m_td=naim
      koko=at('\',m_td)
      if koko#0
         m_td1=rfix(left(m_td,koko-1),40)
         m_td2=subs(m_td,koko+1)
*  @prow()+1,0 say '!!!'+m_td1+' '+m_td2
      endif
   endif
else
   sele 29
   set order to ikodm
   seek mkodm
   if foun()
      m_td1=left(naim,40)
*      @prow()+1,0 say '!!!'+m_td1
   endif
endif
sele 2
@prow()+1,0 say STR(NPP,3)+' '+kornd+' '+left(poznd,14)+' '+left(naimd,14)+' '+left(poznw,14);
                     +' '+str(kol,3)+' '+str(koli,4);
                     +' '+iif(wag#0,str(wag,10,5),space(10));
                     +' '+m_kd1 &&;
                     *+' '+m_td1
   do kol_str with 1
if mkodm#0.and.koko#0
   @prow()+1,77 say rfix(m_kd2,30) &&+' '+m_td2
   do kol_str with 1
endif
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc pipi2
koko=0
str_p=''
*if kodm#0
   mkodm =kodm
   dmm   =0
   tmm   =0
   cena4 =0
   cena29=0
   if kodm<m.glMater
      sele 4
      set order to ikodm
      seek mkodm
      if foun()
         m_kd=naim
         koko=at('\',m_kd)
         DMm  =DM
         TMm  =TM
         cena4=cena
      endif
   else
      sele 29
      set order to ikodm
      seek mkodm
      if foun()
         cena29=cena
      endif
   endif
   sele 2
   ktpoznd=poznd
   if !empt(mar1)
      str_p=str(mar1,4)+'-'+iif(mar2#0,allt(str(mar2,4)),'')
   endif
   if mar3#0
      str_p=str_p+'-'+allt(str(mar3,4))
   endif
   if mar4#0
      str_p=str_p+'-'+allt(str(mar4,4))
   endif
   if mar5#0
      str_p=str_p+'-'+allt(str(mar5,4))
   endif
   if mar6#0
      str_p=str_p+'-'+allt(str(mar6,4))
   endif
   if mar7#0
      str_p=str_p+'-'+allt(str(mar7,4))
   endif
   if mar8#0
      str_p=str_p+'-'+allt(str(mar8,4))
   endif
   if mar9#0
      str_p=str_p+'-'+allt(str(mar9,4))
   endif
   if mar10#0
      str_p=str_p+'-'+allt(str(mar10,4))
   endif
   sele 5
   set order to ipoznd
   seek ktpoznd
   te_cena=0
   if foun()
      tekodm=kodm
      if tekodm<m.glMater
         sele 4
         set order to ikodm
         seek tekodm
         tecena=0
         if foun()
            te_cena=cena
         endif
      endif
   endif
   sele 5
   set key to ktpoznd
   go top
   inormw=0
   irasz =0
   if .not.eof()
      do while .not.eof()
         tesetka=setka
         terr   =rr
         tenormw=normw
         sele 10
         set order to vidts
         seek str(tesetka,2)+str(terr,1)
         if foun()
            MRASZ=dengi*tenormw/60
            irasz=irasz+mrasz
         endif
         inormw=inormw+tenormw
         sele 5
         skip
      enddo
   endif
   roz=0
   sele 2
   if kolz>1
      roz=(rozma-40)/kolz
   endif
   tecena=iif(te_cena#0,te_cena,cena4)
   tecena=iif(tecena#0,tecena,cena29)
   @prow()+1,0 say STR(NPP,3)+' '+iif(dmm#0,str(dmm,6,1),space(6));
                          +' '+iif(tmm#0,str(tmm,4,1),space(4));
                          +' '+iif(roz#0,str(roz,6,1)+'    '+str(rozma,6,1),iif(rozma#0,str(rozma,6,1),space(6))+space(11));
                          +' '+iif(kolz#0,str(kolz,5,1),space(5));
                          +'   '+left(ei,4);
                          +' '+iif(nrmd#0,str(NRMD,8,5),space(8));
                          +' '+iif(nrmd#0,str(roun(wag/NRMD,2),4,2),space(4));
                          +' '+space(8);
                          +' '+rfix(str_p,31);
                          +' '+iif(inormw#0,str(inormw,6,3),space(6));
                          +' '+iif(tecena#0,str(tecena,6,2),space(6));
                          +' '+iif(nrmd*tecena#0,str(nrmd*tecena,6,2),space(6));
                          +' '+iif(irasz+nrmd*tecena#0,str(irasz+nrmd*tecena,6,2),'')
   do kol_str with 2
   if mkodm#0.and.koko#0
      @prow()+1,75 say ' '
      do kol_str with 2
   endif
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc shap1
@prow()+1,0 say  'Koнструкторсько-технологiчна специфiкацiя до виробу '+allt(mim)+' '+mpozn
@prow()+1,0 say '--------------------------------------------------------------------------------------------------------------------------:'
@prow()+1,0 say ' № : Кор  :   Позначення  : Hайменування :Куди входить:Кiлькiсть :   Маса   :   Матерiал згiдно КД     :Матерiал згiдно ТД:'
@prow()+1,0 say 'п/п:      :               :              :(позначення):----------:          :--------------------------:------------------:'
@prow()+1,0 say '   :  N   :               :              :            :У зб.:У ви:          :Сортам:Матерiал           :Сортам:Матерiал   :'
@prow()+1,0 say '   :      :               :              :            :один :робi:    кг    :      :                   :      :           :'
@prow()+1,0 say '--------------------------------------------------------------------------------------------------------------------------:'
@prow()+1,0 say ' 1 :   2  :      3        :      4       :      5     :   6 :  7 :     8    :   9  :         10        :  11  :     12    :'
@prow()+1,0 say '--------------------------------------------------------------------------------------------------------------------------:'
*@prow()+1,0 say ' '
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc shap2
@prow()+1,0 say '---------------------------------------------------------------------------------------------------------------------------------:'
@prow()+1,0 say ' № :               Розмiри              : Один.: Норма :Коеф.:Покриття:          М А Р Ш Р У Т      : Трудо-: Варт.: Варт.: Варт.:'
@prow()+1,0 say 'з/п:------------------------------------:норму-:витрат :викор:--------:-----------------------------:  мiст-: один.:матер :деталi:'
@prow()+1,0 say '   :   :     :        :   :       :К-ть :вання :       : мат.:вид: пл :  :  :  :  :  :  :  :  :  :  : кiсть :вимiру:деталi:      :'
@prow()+1,0 say '   :   :     :        :   :       :дет.у:      :       :     :   :    :  :  :  :  :  :  :  :  :  :  :       : матер:      :      :'
@prow()+1,0 say '   : D :  H  :   L    : S :  Lгр  : заг.:      :       :     :   :м кв:  :  :  :  :  :  :  :  :  :  :   хв  :  грн : грн  : грн  :'
@prow()+1,0 say '---------------------------------------------------------------------------------------------------------------------------------:'
@prow()+1,0 say ' 1 : 12:  13 :    14  :15 :    16 : 17  :  18  :   19  :  20 : 21 : 22:23:24:25:26:27:27:28:29:30:31:   32  :  33  :  34  :  35  :'
@prow()+1,0 say '---------------------------------------------------------------------------------------------------------------------------------:'
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc kol_str
para N_shapki
k_s=k_s+1
*@prow()+1,0 say 'k_s='+str(k_s,4)
if k_s>32
   @prow()+1,0 say chr(12)
   if N_shapki=1
      do shap1
   else
      do shap2
   endif
   k_s=0
endif
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *