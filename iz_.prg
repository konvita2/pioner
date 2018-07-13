*** »«ќЋя÷»я
local mat_tm
mat_tm=0
sele * from te where kod=1 into curs c_te
   			scatter memv blan  
use in c_te
do form f_izd_vib to _izd
*wait window _izd

select * from KT where pozn==_izd ;
      and inlist(kodm1,14,371,372,698,493,469,374,370,373) ;
      into curs c_kt
scan all
     scatter memv
     *wait window c_kt.kodm1
     if c_kt.kodm1=14
        tp_=' «.02600.00009'
     endif 
     if c_kt.kodm1=373
        tp_=' «.02600.00001'
     endif 
     if c_kt.kodm1=493
        tp_=' «.02600.00002'
     endif 
     if c_kt.kodm1=371 or c_kt.kodm1=372
        tp_=' «.02600.00003'
     endif 
     if c_kt.kodm1=469  or c_kt.kodm1=374  or c_kt.kodm1=370
        tp_=' «.02600.00004'
     endif 
     if c_kt.kodm1=698  or c_kt.kodm1=203
        tp_=' «.02600.00010'
     endif 
     select * from KTO where namTTP=TP_ ;
         into cursor c_kto        
     if reccount() > 0
        *brow
        scan all
   			M.MAR=C_KTO.DU
            sele * from TTO ;
                  where ; 
                  left(ttp,8)=left(tp_,8) and op=c_kto.op ;
             into curs c_tto
	        	*brow       
		      M.NF   = c_tto.NFT
		      m.kto  = c_tto.kteh
   			  m.nto  = c_tto.nfm
		      m.rr   = c_tto.rr
		      m.kodp = c_tto.prof
		      m.setka= c_tto.stk
		      M.KRNO = C_TTO.IN
		      sele invn, marka from OBOR ;
		           where invn=c_tto.rabc ;
		           into curs c_obor
			  use in c_tto
		      if recc () > 0
		         m.kodo=marka
		      endif
		      use in c_obor
			  IF M.NF#0
			  	t=0
			  	m.normw=0
			  	do formula with m.nf,m.normw
			  		*wait 'формулa є='+str(m.nf,2)+' m.NORMW='+str(m.NORMW,7,5) window nowait
					if m.normw#0
					     sele te
					     APPEN BLAN
					     m.datw=date()
					     m.kttp=tp_
					     gather memv
					     
					     *brow
				    endif
			  ENDIF
			  
		endscan
	 endif   
	 use in c_kto      
endscan
*** ѕќ–≈« ј ћ≈“јЋЋј «ј√ќ“ќ¬ »
select * from KT where pozn==_izd ;
      and inlist(kodm1,14,203,698) ;
      and inlist(kttp,' «.10206.00017',' «.10206.00018',' «.10206.00016',' «.10206.00026',' «.10206.00027',' «.10206.00028') ;
      into curs c_kt
*brow
scan all
     scatter memv
     *wait window c_kt.kodm1
     select * from KTO where namTTP=c_kt.kttp ;
         into cursor c_kto        
     if reccount() > 0
        *brow
        scan all
   			
            sele * from TTO ;
                  where ; 
                  left(ttp,8)=left(C_KTO.NAMTTP,8) and op=c_kto.op ;
             into curs c_tto
	        	*brow       
		      M.NF   = c_tto.NFT
		      m.kto  = c_tto.kteh
   			  m.nto  = c_tto.nfm
		      m.rr   = c_tto.rr
		      m.kodp = c_tto.prof
		      m.setka= c_tto.stk
		      sele invn, marka from OBOR ;
		           where invn=c_tto.rabc ;
		           into curs c_obor
			  use in c_tto
		      if recc () > 0
		         m.kodo=marka
		      endif
		      use in c_obor
			  IF M.NF#0
			  	if c_kt.kodm1=14
			  	   m.us1=1
			  	   m.us2=16
			  	   m.us3=18
			  	   m.us4=17
			  	   m.us5=0
			  	   
			  	else
			  	   m.us1=1
			  	   m.us2=18
			  	   m.us3=17
			  	   m.us4=15
			  	   m.us5=0
			  	endif
			  	select kodm,tm from MATER where kodm=c_kt.kodm1 into cursor c_mater
			  	mat_tm=c_mater.tm
			  	use in c_mater
			  	t=0
			  	m.normw=0
			  	do formula_zag with ;
			  	   M.nf,1,c_kt.nrmd,4,c_kt.rozma,c_kt.ROZMB,0,0,0,mat_TM,0,0,m.us1,m.us2,m.us3,m.us4,m.us5,m.normw

			  		*wait 'формулa є='+str(m.nf,2)+' m.NORMW='+str(m.NORMW,7,5) window && nowait 
					if m.normw#0
					     sele te
					     APPEN BLAN
					     m.datw=date()
					     M.MAR =35
					     M.KRNO=2
					     gather memv
					     *ait window 'appe' nowait 
					     *brow
				    endif
			  ENDIF
			  
		endscan
	 endif   
	 use in c_kto      
endscan

use in c_kt
return
*                     ‘ќ–ћ”Ћџ ѕќ »«ќЋя÷»»
procedure formula
parameters n_f,t
*wait window 'proc formula rozma='+str(c_kt.rozma)+' rozmb='+str(c_kt.rozmb)+' kol='+str(c_kt.kol)+' kodm1='+str(c_kt.kodm1)
local rozma_,rozmb_,kol_,kodm_,k
rozma_=c_kt.rozma
rozmb_=c_kt.rozmb
kol_  =c_kt.kol
kodm_ =c_kt.kodm1
if kodm_=14
    k=1
endif
if kodm_=370
    k=1.3
endif
if kodm_=371
    k=0.6
endif
if kodm_=372
    k=0.6
endif
if kodm_=373
    k=0.8
endif
if kodm_=374
    k=1.4
endif
if kodm_=469
   k=1.5
endif
if kodm_=493
    k=1
endif


p=1
ns=1
no=1
nz=1

***	local u1,u2,u3,u4,u5,u6,u7,u8
***	u1=thisform.us1
***	u1=thisform.us1
***	u2=thisform.us2
***	u3=thisform.us3
***	u4=thisform.us4
***	u5=thisform.us5
***	u6=thisform.us6
***	u7=thisform.us7
***	u8=thisform.us8
   && м€гка€ часть  kodm=493, 469,374,370,373,372,371    
IF n_f=4
   T=T+0.0013*rozma_+0.002      && –ј«ћ. ќЌ“”–ј ѕќ ѕ–яћќЋ.ЎјЅЋ.
endif
if n_f=5      
   T=T+0.00092*P+0.0025*(rozma_**1.15+rozmb_**0.95)*K   &&5 разметка по шаблону 2 чел kodm=203 или 698
endif         

if n_f=13    
   T=T+0.95*NO+0.000011*rozma_**1.55*rozmb_**0.9  &&13сверловка смотри выше 2 чел   kodm=203 или 698
endif       
***  !!!!!!if n_f=13
       &&  таблички kodm=14
***    T=T+1.38    && 13,49,51 сверловка 2 отв.по шаблону комплекс всех работ
*** endif
iF n_f=32 and kodm_=14
   T=T+(0.006*(2*rozma_+2*rozmb_)**0.58)*2.9             &&  п–»“”ѕ. –ќћќ  ѕќ  ќЌ“”–” ЎјЅ≈–
endif
if n_f=33    
   T=T+0.0000081*rozma_**1.55*rozmb_**0.9   &&зачистка контура после вырубки смотри выше 2 чел.
   T=T+0.000002*rozma_**1.31*rozmb_**1.28   &&повороты обечайки  kodm=203 или 698
endif

iF n_f=37
   T=T+0.014*rozma_**0.31                     &&           ќЌ“–.»«ћ ћ.Ћ»Ќ
endif

IF n_f=39
   T=T+0.003*rozma_**0.54*4*K                    &&                    ЎјЅЋ
ENDIF

IF n_f=44
	if kodm_=371 or kodm_=372
	   T=T+0.15*rozma_**0.2
	else
	   T=T+0.03*rozmb_**0.15*rozma_**0.21*K
	endif
             &&  ¬Ќ≈ЎЌ»… ќ—ћќ“–
endif

if n_f=52      
   T=T+0.0075*P+0.002*(rozma_**1.4+rozmb_**1.1)  &&52 вырезка контура обечайки 2 чел. kodm=203 или 698
endif  

if n_f=53        
   *wait window 'nf=53 373 kodm='+str(kodm_,4)
   if kodm_=373
      T=T+0.0018*(rozma_**1.15+rozmb_**0.9)  && 53, раскрой сетки ножом  kodm=373 по шаблону (периметр)
   endif
endif

if n_f=54
   if kodm_=373
      T=T+0.0025*(rozma_**1.15+rozmb_**0.95)  && 54 раскрой сетки ножницами kodm=373 по шаблону (периметр)
   endif
endif

if n_f=55      
   T=T+0.53*Nz+0.0012*(rozma_**1.2+rozmb_**0.9)     &&55 установка табличек  2 чел. kodm=203 или 698
endif      

if n_f=56
   
   if kodm_=372
      T=T+0.0018*rozma_**0.7   &&56 отрезка петли kodm=372
   endif
   if kodm_=371
      T=T+0.0018*rozma_*0.7   && 56  отрезка крючка kodm=371
   endif 
   *wait window 'nf=56 kodm='+str(kodm_,4)+' kol='+str(kol_,4)+' rozma='+str(rozma_,4)+'  T='+str(t,8,4)
endif   

if n_f=57
   T=T+0.15*P/70 +0.00156*kol_*(rozma_**1.25+rozmb_**0.8)&& 57 накалывание мата с прошивкой   (аналог.+ толшина каждого сло€)*T=T+0.0055*L*LO**0.7*KM*N   &&повороты чехла (ширина.длина к-во поворотов)
    && cобрать по даной сборке  kodm=373, 374,370,469  (где –-периметр 373 
    T=T+0.000001*rozma_**1.55*rozmb_**0.9 &&57.1 повороты мата где р-ры 373 
endif
if n_f=58   
   T=T+0.0000046*rozma_**1.3*rozmb_**0.95 && 58 вкладывние прошитого мата в чехол (ширина.длина)
    && cобрать по даной сборке  kodm=493**, 469,374,370,373  (** ключевой код материала) 
endif           

if n_f=59
   T=T+0.0268*kol_*(rozma_**1.35+rozmb_**1.2) &&59 ѕошив чехла  (ширина,длина) kodm= 493
   T=T+0.000001*rozma_**1.1*rozmb_**0.8 &&57.1 повороты мата    &&повороты чехла (ширина.длина к-во поворотов)
endif  

if n_f=60   
   T=T+0.0359*rozmb_+0.002*rozma_**1.2  &&60 окончательна€ прошивка мата с застежками (ширина) и площ.
      && cобрать по даной сборке  kodm=493**, 469,374,370,373  (** ключевой код материала) 
   T=T+0.0000012*(rozma_**1.55*rozmb_**0.9) &&57.1 повороты мата   &&перекладывание с поворотом (длина ширина)
endif
 
if n_f=61
   
   if kodm_=371 or kodm_=372
	   T=T+0.2+0.000001*rozma_**1.2 && 61 перемещение
	else
	   T=T+0.5+0.000001*rozma_**1.25*rozmb_**0.9*K && 61 перемещение
	endif
   
    && cобрать по даной сборке  kodm=493**, 469,374,370,373  (** ключевой код материала) 
endif 

if n_f=62         
   T=T+0.0032*rozma_**1.25   &&62 отрезка пленки под упаковку ( при наличии KTO=832)или материала-??
endif 

if n_f=63
   T=T+0.0055*rozma_**1.3    &&63 вкладывание в пленку (длина, ширина толщина слоев)
endif

if n_f=64
   
   if kodm_=371 or kodm_=372
	   T=T+3.6+0.0000003*rozma_**1.55 && 64 маркирование мата площадь или размеры
	else
	   T=T+3.9+0.0000002*rozma_**1.55*rozmb_**0.9 && 64 маркирование мата площадь или размеры
	endif
endif         

if n_f=65         
   T=T+5.2    && 65.1 программирование
   T=T+2.68    &&65 чеканка
endif

if n_f=66 and kodm_=1041        
   T=T+0.62*Nz+0.001*(rozma_**1.55+rozmb_**0.9)  &&66 клепка к мату таблички (пл.мата и кол.заклеп kodm=1041
         && cобрать по даной сборке  kodm=1041 ключевой код материала)  
endif

if n_f=67       
   T=T+0.63*NS*0.000001*rozmb_**1.2*rozma_**1.25  &&67 сварка контактна€  (кол-во точе и р-ры) 3 чел.kodm=203 или 698
endif  

if n_f=68          
   T=T+0.78*NS*0.0000012*rozmb_**1.2*rozma_**1.25    &&68 зачистка точек сварки 2 чел. kodm=203 или 698
endif  

if n_f=69         
   T=T+0.0000085*rozmb_**0.9*rozma_**1.12    &&69 вальцовка по диаметру длина, ширина, 2 чел kodm=203 или 698
endif  

if n_f=70          
   T=T+0.0000095*rozmb_**0.85*rozma_**1.25    && 70 зиговка (аналогично + к-во штук) 2 чел kodm=203 или 698
endif  

if n_f=71          
   T=T+0.0000055*rozmb_**0.7*rozma_**0.95     && 71 гибка 1 ( к-во сторон) по длине 2 чел. kodm=203 или 698
endif  

if n_f=72
   T=T+0.0025*0.65*(rozma_**1.15+rozmb_**0.95)    &&72–аскрой ножом  по шаблону ткани  kodm=493 с поворотами
endif 

if n_f=73
   T=T+0.0045*0.35*(rozma_**1.15+rozmb_**0.95)    &&73–аскрой ножницами по шаблону ткани  kodm=493 с поворотами
endif 

if n_f=74
   if kodm_=374
      T=T+0.0055*(rozma_**1.55+rozmb_**0.9) *0.05 && 74раскрой волокнистой основы kodm=374 1,5 дюйм
    endif
   if kodm_=469
      T=T+0.0065*(rozma_**1.55+rozmb_**0.9)*0.05  && 74раскрой волокнистой основы kodm=469  2   дюймов
   endif 
   if kodm_=370
      T=T+0.0072*(rozma_**1.55+rozmb_**0.9)*0.05  && 74раскрой волокнистой основы kodm= 370  2,5 дюйма ( перыметр) 
   endif
endif

if n_f=75 
   T=T+0.008*rozma_**1.4             && 75 зав€зывние (длина, толщина слоев)
endif

if n_f=76    
   T=T+0.0000070*rozmb_**0.85*rozma_**1.15    && 76 гибка 2 с подкладкой 2 чел kodm=203 или 698
endif  

if n_f=77    
   T=T+0.00000075*rozmb_**0.9*rozma_**1.1     && 77 сплющивание окончательное 2 чел kodm=203 или 698
endif  

if n_f=80   
   T=T+0.0000013*rozma_**1.55*rozmb_**0.9    && 61  2 чел перемещение kodm=203 или 698
   T=T+0.0027*(rozma_**0.7+rozmb_**0.85)      &&61 2 чел складирование kodm= 203 или 698
endif

if n_f=81
   T=T    && 61  1 комплектаци€ деталей под сшивку мата
endif  

if n_f=82  
   T=T      &&61 1 пакетирование  деталей в мат дл€ последующей сшивки
 endif  

if n_f=83
    T=T    && 61  контроль формы контролером после предварительной пошивки чехла
endif

if n_f=84
   T=T    && перемещение чехла на укладывание мата 
endif   

if n_f=85
   T=T    && 61  2 комплектаци€ чехла и мата
endif   

if n_f=86
   T=T      &&61 2 контроль вкладывани€ мата в чехле
endif   

***	if n_f=87
***	   T=T+      &&61 2 перемещение вложенного мата в чехле
***	endif   

***	if n_f=88
***	   T=T+      &&61 2 контроль окончательно сшитого мата в чехле
***	endif      

***	if n_f=89
***	   T=T+      &&61 2 комплектаци€ всех частей дл€ сшивки мата в чехле
***	endif      

***	if n_f=90
***	   T=T+      &&61 2 комплектовка сшитого мата  дл€ упаковки
***	endif      

***	if n_f=91
***	   T=T+      &&61 2 контроль упаковки
***	endif      

***	if n_f=92
***	   T=T+      &&61 2 перемещение со складированием мата после упаковки
***	endif      

***	if n_f=97
***	   T=T+      &&61 2 комплектаци€ деталей под сварку
***	endif         

***	if n_f=98
***	   T=T+      &&61 2 контроль после контактной сварки обечаек
***	endif      

***	if n_f=99
***	   T=T+      &&61 2 комплектаци€ под сборку обечаек
***	endif      

***	if n_f=100
***	   T=T+      &&61 2 контроль собранных обечаек
***	endif   

      && учесть что в спецификации на м€гкую часть отсутствуют отдельно вход€щие детали ,
      && а есть только сборка по позиции мата и они обЇдиненные см. спецификацию    
      &&  таким образом необходимо иметь не только кор.ном. но и обозначение детали.  
      && дл€ ткани, сетки, вол.основы,петли и крючка   
      &&   
      &&   ¬ обечайках, табличках присутствует конкретный номер по обозначению, но не оговорены
      &&   элементы дл€ сверловки,гибки,вальцовки,зиговки,сварки.   
      &&   
      && необходимо учесть комплектацию при сборке
      &&   
      &&      “аким образом работа строитс€ на поиске в изделии соответствующего кода материала
      && и раскрутке по нем норм времени через TTO и KTO
      && 
      && «аготовительные работы на порезку материала дл€ ““ѕ є  «.10206.00017 (18;16;26;27;28)  kodm=14,203,698 в маршруте 35 работают по услови€х     
      && номер  1,18,17,15 дл€ kodm=203 и 698, количество резов =4 и услови€ 1,16,18,17 дл€  kodm=14 
      && при этом автоматически формируетс€ маршрут с TTO   
         
         
               
m.normw  = t
return
procedure formula_zag
*ThisForm.Pageframe1.Page3.txtNormw.Value = thisform.normw
***	wait window 'proc formula T='+str(m.normw,7,4)        nowait
***	thisform.formula(THISFORM.nf,thisform.msort,THISFORM.nrmd,thisform.KOLREZOW,thisform.rozma,;
***	thisform.ROZMB,thisform.DS,thisform.D,;
***	thisform.DBK,thisform.MTM,thisform.MDM,thisform.MPS,thisform.us1,thisform.us2,;
***	thisform.us3,thisform.us4,thisform.us5,thisform.normw)

* M.nf,1,c_kt.nrmd,4,c_kt.rozma,c_kt.ROZMB,0,0,0,mat_TM,0,0,m.us1,m.us2,m.us3,m.us4,m.us5,m.normw


para n_f,SO,WES,KRE,L,B,DS,D,DBK,T_M,D_M,S,u1,u2,u3,u4,u5,T
*wait 'formula n_f='+str(n_f,3)+' L='+str(L,5)+' b='+str(b,5,2)+' T_M='+str(T_M,5,2)+' u1='+str(u1,2) wind
local P
P=(L+B)*2
   A=L
   IF DS#0
      LT=DS
   ENDIF
   IF A#0.AND.B#0
      LT=2*(A+B)
   ENDIF
   IF D#0
      LT=D*3.14
   ENDIF
   IF DBK#0
      LT=DBK*3.14
   ENDIF
   IF D#0.AND.DBK#0
      LT=(D+DBK)*3.14
   ENDIF
IF n_f=1
   if t_m=<120
      N=0.08*t_m
   ELSE
      N=0.1*t_m
   ENDIF
   K1=1.11
   K10=1
   IF inlist(2,U1,U2,U3,U4,U5)
      K10=1.15
   ENDIF
   IF lt=<1000
      T=(4.68*10**-3*Lt+0.3)*K1**(N-1)*k10  && Lt<=1000
   else
      T=((3.48*10**-3*(Lt-1000))+4.98)*K1**(N-1)*k10   && Lt>1000
   ENDIF
ENDIF
IF n_f=2
   K1=1.07
   K10=1
   IF inlist(2,U1,U2,U3,U4,U5)
      K10=1.15
   ENDIF
   if t_m=<100
      N=0.1*t_m
   ELSE
      N=0.04*(t_m-100)+1
   ENDIF
   IF LT=<800
      T=((5.2*10**-3*(Lt-200))*K1**(N-1))*k10
   ELSE
      T=((3.85*10**-3*(Lt-800))*K1**(N-1))*k10
   ENDIF
ENDIF
IF n_f=3
   N=1
   IF T_M>5.AND.T_M=8
      N=0.67*(T_M-5)+1.0 && b<8
   ENDIF
   IF T_M>8.AND.T_M=<20
      N=0.5*(T_M-8)+3.0    && 8=<b>20
   ENDIF
   IF T_M>20.AND.T_M=<30
      N=0.2*(T_M-20)+9.0    && 20=<b>30
   ENDIF
   IF T_M>30
      N=0.1*(T_M-30)+11.0  && b>30
   ENDIF
   K1=1.04
   K6=1
   K9=1
   if inlist(10,U1,U2,U3,U4,U5)
      K6=1.2
   ENDIF
   IF inlist(11,U1,U2,U3,U4,U5)
      K9=1.1
   ENDIF
   IF inlist(12,U1,U2,U3,U4,U5)
      K9=1.15
   ENDIF
   IF inlist(13,U1,U2,U3,U4,U5)
      K9=0.575
   ENDIF
   IF L>300
      T=(((1.51*10**-3*(L-300)+0.48))*K1**(N-1))*k6*k9
   ELSE
      T=0.48*K1**(N-1)*k6*k9
   ENDIF
ENDIF
IF n_f=4
   K=1.19
   IF SO=2 or SO=7                    && KF=1-КРУГ KF=0.96-КВАДРАТ KF=0.95-УГОЛОК KF=0.93-ШВЕЛЛЕР KF=0.84-РЕЛЬС,ДВУТАВР
      KF=1
   ENDIF
   IF SO=5
      KF=0.96
   ENDIF
   IF SO=9
      KF=0.95
   ENDIF
   IF SO=6 or SO=8
      KF=0.93
   ENDIF
   IF SO=10
      KF=0.84
   ENDIF
   IF S<300
      NO=1
   ELSE
      NO=(0.0021*(S/KF-300))**0.8+1.0
   ENDIF
   IF L=<450
      T=(4.0*10**-4*L+0.11)*K**(NO-1)      && L<= 450 MM
   ELSE
      T=(1.84*10**-4*L+0.21)*K**(NO-1)    && L>450
   ENDIF
ENDIF
IF N_F=5
   K  = 1.19
   KR = 0.74
   kf = 1
   IF SO=2 or SO=7                    && KF=1-КРУГ KF=0.96-КВАДРАТ KF=0.95-УГОЛОК KF=0.93-ШВЕЛЛЕР KF=0.84-РЕЛЬС,ДВУТАВР
      KF=1
   ENDIF
   IF SO=5
      KF=0.96
   ENDIF
   IF SO=9
      KF=0.95
   ENDIF
   IF SO=6 or SO=8
      KF=0.93
   ENDIF
   IF SO=10
      KF=0.84
   ENDIF
   IF S<300
      NO=1
   ELSE
      NO=(0.0021*((S/KF)-300))**0.8+1.0
   ENDIF
   IF L=<450
      T=((1.84*10**-4*L+0.21)*K**(NO-1))*KR  && KR=0.74 L=<450
   ELSE
      T=((4.0*10-4*L+0.11)*K**(NO-1))*KR      && L<= 450 MM
   ENDIF
ENDIF

IF N_F=6
   K=1.19
   KR=1.23
   IF SO=2 or SO=7                    && KF=1-КРУГ KF=0.96-КВАДРАТ KF=0.95-УГОЛОК KF=0.93-ШВЕЛЛЕР KF=0.84-РЕЛЬС,ДВУТАВР
      KF=1
   ENDIF
   IF SO=5
      KF=0.96
   ENDIF
   IF SO=9
      KF=0.95
   ENDIF
   IF SO=6 or SO=8
      KF=0.93
   ENDIF
   IF SO=10
      KF=0.84
   ENDIF
   IF S<300
      NO=1
   ELSE
      NO=(0.0021*(S-300)/KF)**0.8+1.0
   ENDIF
   IF L=<450
      T=((1.84*10**-4*L+0.21)*K**(NO-1))*KR  && L=<450
   ELSE
      T=((4.0*10-4*L+0.11)*K**(NO-1))         && L>450 MM
   ENDIF
ENDIF
IF N_F=7
   IF SO=2 or SO=7                    && KF=1-КРУГ KF=0.96-КВАДРАТ KF=0.95-УГОЛОК KF=0.93-ШВЕЛЛЕР KF=0.84-РЕЛЬС,ДВУТАВР
      KF=1
   ENDIF
   IF SO=5
      KF=0.93
   ENDIF
   IF SO=4
      KF=0.75
   ENDIF
   IF SO=6 or SO=8
      KF=0.49
   ENDIF
   IF SO=10
      KF=0.53
   ENDIF
   IF SO=3
      KF=0.48
   ENDIF
   IF SO=11
      KF=0.68
   ENDIF
   IF SO=18
      KF=0.31
   ENDIF
   IF S<300
      NO=1
   ELSE
      NO=(0.0021*(S-300)/KF)**0.8+1.0
   ENDIF
   T=1.6*(0.29*10**-3*L+1.0)*NO  && ПО УПОРУ
ENDIF
IF n_f=8
   KR=1.05
   IF SO=2 or SO=7                    && KF=1-КРУГ KF=0.96-КВАДРАТ KF=0.95-УГОЛОК KF=0.93-ШВЕЛЛЕР KF=0.84-РЕЛЬС,ДВУТАВР
      KF=1
   ENDIF
   IF SO=5
      KF=0.93
   ENDIF
   IF SO=4
      KF=0.75
   ENDIF
   IF SO=6 or SO=8
      KF=0.49
   ENDIF
   IF SO=10
      KF=0.53
   ENDIF
   IF SO=3
      KF=0.48
   ENDIF
   IF SO=11
      KF=0.68
   ENDIF
   IF SO=18
      KF=0.31
   ENDIF
   IF S<300
      NO=1
   ELSE
      NO=(0.0021*(S-300)/KF)**0.8+1.0
   ENDIF
   T=1.6*(0.29*10**-3*L+1.0)*NO*KR  && ПО УПОРУ
ENDIF
IF n_f=9
   KR=0.25
   *IF SO=2.OR.SO=7                    && KF=1-КРУГ KF=0.96-КВАДРАТ KF=0.95-УГОЛОК KF=0.93-ШВЕЛЛЕР KF=0.84-РЕЛЬС,ДВУТАВР
      KF=1
   *ENDIF
   IF SO=5
      KF=0.93
   ENDIF
   IF SO=4
      KF=0.75
   ENDIF
   IF SO=6 or SO=8
      KF=0.49
   ENDIF
   IF SO=10
      KF=0.53
   ENDIF
   IF SO=3
      KF=0.48
   ENDIF
   IF SO=11
      KF=0.68
   ENDIF
   IF SO=18
      KF=0.31
   ENDIF
   IF S<300
      NO=1
   ELSE
      NO=(0.0021*(S-300)/KF)**0.8+1.0
   ENDIF
   T=1.6*(0.29*10**-3*L+1.0)*NO*KR  && ПО УПОРУ
ENDIF
IF n_f=10
   N=1.1
   IF S<50
      K=0.25
   ELSE
      IF S>50.AND.S=<240
         K=2.7*(0.00226*(S-50)**1.25)+0.25  && S=<240 MM
      ELSE
         K=2.7*(0.0017*(S-240)**0.94)+0.59  && S>240
      ENDIF
   ENDIF
   if l<250
      t=1.1*k
   else
      IF L=>250.and.l<1800
         T=2.7*((0.26*10**-4*(L-250)**0.86)+1.1)*K   && L<=1800  РАЗМЕТКА ПОД РЕЗКУ
      ELSE
         T=2.7*((0.356*10**-4*(L-1800)**1.1)+1.55)*K         && L>1800  KR=0.25
      endif   
   ENDIF
ENDIF
IF n_f=11
   KR=0.25
   IF S<50
      K=0.25
   ELSE
      IF S>50.AND.S=<240
         K=(0.00226*(S-50)**1.25)+0.25  && S=<240 MM
      ELSE
         K=(0.0017*(S-240)**0.94)+0.59  && S>240
      ENDIF
   ENDIF
   if l<250
      t=1.1*k*kr
   else   
      IF L=>250.and.l<1800
         T=2.7*((0.26*10**-4*(L-250)**0.86)+1.1)*K*KR   && L<=1800  РАЗМЕТКА ПОД РЕЗКУ
      ELSE
         T=2.7*((0.356*10**-4*(L-1800)**1.1)+1.55)*K*KR         && L>1800  KR=0.25
      endif   
   ENDIF
ENDIF
IF n_f=12
   KR=1.05
   IF S<50
      K=0.25
   ELSE
      IF S>50.AND.S=<240
         K=(0.00226*(S-50)**1.25)+0.25  && S=<240 MM
      ELSE
         K=(0.0017*(S-240)**0.94)+0.59  && S>240
      ENDIF
   ENDIF
   IF L<250
      T=1.1*K*KR
   ELSE   
      IF L=>250.AND.L<1800
            T=K*KR*((0.000026*(L-250)**0.86)+1.1)   && L<=1800  РАЗМЕТКА ПОД РЕЗКУ
      ELSE
         T=2.7*((0.356*10**-4*(L-1800)**1.1)+1.55)*K*KR         && L>1800  KR=0.25
      ENDIF
   ENDIF
ENDIF

IF n_f=13
   k6=1
   k8=1
   IF inlist(14,U1,U2,U3,U4,U5)
      IF inlist(3,U1,U2,U3,U4,U5)
         K6=0.79
      ENDIF
      IF inlist(1,U1,U2,U3,U4,U5)
         K8=0.7
      ENDIF
      IF S<125
         K7=1
      ELSE
         IF S>125.AND.s=<5400
            k7=(0.0018*(S-125)**0.65)+1.0  && S=<5400
         ELSE
            K7=0.0006*(S-5400)+5.25        && S>5400
         ENDIF
      ENDIF
      if l<130
         T=0.12*K7*K8*K6
      else
         IF l>130.and.L=<1800
            T=((1.84*10**-4*(L-130)**0.86)+0.12)*K7*K8*K6  && L=<1800
   *         wait '1.84**10-4='+str(1.84**10-4) wind
   *         wait '(L-130)**0.86='+str((L-130)**0.86) wind
   *         wait '1.84**10-4*(L-130)**0.86='+str(1.84**10-4*(L-130)**0.86) wind
   *         wait 'K7*K8*K6='+str(K7*K8*K6) wind
         ELSE
            t=(2.11*10**-4*(L-1800)+0.47)*K7*K8*K6  && L>1800   1-РАБ К8=0.7, ПРИ kodm=1 -2-РАБ К8=1.0 К6=0.79 ПРИ РЕЗКЕ С МЕРНОЙ ПОЛОСЫ  kodm=3
         ENDIF
     * wait 'formul 13 u=14 L='+str(l,5)+' K7'+str(k7,4,2)+' K8='+str(k8,4,2)+' K6='+str(k6,4,2)+' t='+str(t,7,3) wind
      ENDIF
   endif
   IF inlist(15,U1,U2,U3,U4,U5)
      IF inlist(1,U1,U2,U3,U4,U5)
         K8=1.4
      ENDIF
      K2=1
      IF T_M>3
         K2=(0.048*(T_M-3))**0.8+1.0    && B1>3 ТОЛЩИНА МАТЕРИАЛА ЛИСТА K2=>1
      ENDIF
      if kre=0
         K5=1
      else
         K5=(0.6*(KRE-1))**0.95+1.0   && N-КОЛ-ВО РЕЗОВ
      endif
       * N=(1.8*10**-3*(0.5*P-2200)*K2*K3*K4*K5  && P>=4400   К4(КОЭФ.НА РАЗМЕТКУ))=1-КЗ
       * N=(1.3*10**-3*(0.5*P-1200)*K2*K3*K4*K5  && P<4400   К4(КОЭФ.НА РАЗМЕТКУ))=1-КЗ
       * K5=((0.55*(N-1))**0.95)+1.0   && N-КОЛ-ВО РЕЗОВ
      *K2=((0.024*(B-6))**0.86)+0.62   && B-ТОЛЩИНА B>6 К2#0 >1
      *K3=((0.0000125*(B1-300)**0.56)+0.65   && B1-ШИРИНА РЕЗА>300 K4#0
      IF P<1000
         T=0.67*K8*K2*K5
      ELSE
         IF P>1000.AND.P=<3200
            T=(0.664*10**-3*(0.5*P-500)**0.84+0.67)*K8*K2*K5  && P<3200  К8=1.4-ПРИ РЕЗКЕ ДВУМЯ РАБОЧИМИ kodm=1, К4(КОЭФ.НА РАЗМЕТКУ))=1-КЗ
         ELSE
            T=((0.83*10**-3*(0.5*P-1600)**0.69+4.05)/2.8)*K8*K2*K5  && P>3200
         ENDIF
      ENDIF
      *wait 'formul 13 u=15 p='+str(p,5)+' K2'+str(k2,4,2)+' K8='+str(k8,4,2)+' K5='+str(k5,4,2)+' t='+str(t,7,3) wind
   ENDIF
   IF inlist(16,U1,U2,U3,U4,U5)
      K1=0.64
      IF B>130
         K1=(7.7*10**-4*(B-130))**0.75+0.64   && B1-ШИРИНА РЕЗА>130 K1#0
      ENDIF
      K2=1
      IF T_M>3
         K2=(0.032*(T_M-3))**0.7+1.0   && K2#0
      ENDIF
      IF KRE=0
         K5=1           && ™-в, гз®влҐ†ой®© ™ЃЂ-ҐЃ б™ЃбЃҐ
      ELSE
         K5=(0.6*(KRE-1))**0.95+1.0   &&
      ENDIF
      IF inlist(3,U1,U2,U3,U4,U5)
         K6=0.81
      ENDIF
      IF inlist(4,U1,U2,U3,U4,U5)
         K6=0.73
      ENDIF
      if inlist(1,U1,U2,U3,U4,U5)
         K8=0.7
      ENDIF
      IF L<130
         T=K1*K2*K5*K6*K8*1.1  && L<=130
         *wait 'L<130 formul 13 u=16 l='+str(l,5)+' K2'+str(k2,4,2)+' K8='+str(k8,4,2)+' K5='+str(k5,4,2)+' K6='+str(k6,4,2)+' t='+str(t,7,3) wind
      ELSE
         IF L>130.AND.L<=1800
            T=((1.74*10**-3*(L-130)*0.84)+1.1)*K1*K2*K5*K6*K8*1.1  && L<=1800   К4(КОЭФ.НА РАЗМЕТКУ))=1-КЗ K6=0.73 ПРИ kodm=3   K8=1.0 ПРИ kodm=1 ИНАЧЕ K8=0.7
         ELSE
            T=((0.83*10**-3*(L-1800)*1.55)+3.55)*K1*K2*K5*K6*K8  && P>1800   К4(КОЭФ.НА РАЗМЕТКУ))=1-КЗ
         ENDIF
      ENDIF
*      wait 'formul 13 u=16 l='+str(l,5)+' K2'+str(k2,4,2)+' K8='+str(k8,4,2)+' K5='+str(k5,4,2)+' K6='+str(k6,4,2)+' t='+str(t,7,3) wind
   ENDIF
ENDIF

IF n_f=14
   if inlist(14,U1,U2,U3,U4,U5)
      if b<300
         k3=0.35
      else
         K3=0.35-(0.0000125*(B-300)**0.56)   && B1-ШИРИНА РЕЗА>300 K4#0
      endif
      k6=1
      IF inlist(3,U1,U2,U3,U4,U5)
        K6=0.79
     ENDIF
     IF S<125
         K7=1
      ELSE
         IF S>125.AND.s=<5400
            k7=(0.0018*(S-125)**0.65)+1.0  && S=<5400
         ELSE
            K7=0.0006*(S-5400)+5.25        && S>5400
         ENDIF
      ENDIF
      k8=1
      IF inlist(1,U1,U2,U3,U4,U5)
         K8=0.7
      ENDIF
      IF L<130
         T=0.12*K3*K6*K7*K8  && L=<130
      ELSE
         IF L>130.AND.L=<1800
            T=((1.84*10**-4*(L-130)**0.86)+0.12)*K3*K6*K7*K8  && L=<1800
         ELSE
            t=(2.11*10**-4*(L-1800)+0.47)*K3*K6*K7*K8        && L>1800   1-РАБ К8=0.7  , ПРИ kodm=1 -2-РАБ К8=1.0 К6=0.79 ПРИ РЕЗКЕ С МЕРНОЙ ПОЛОСЫ  kodm=3
         ENDIF
      ENDIF
      *wait 'formul 14 u=14 L='+str(l,5)+' K7'+str(k7,4,2)+' K8='+str(k8,4,2)+' K6='+str(k6,4,2)+' K3='+str(k3,4,2)+' t='+str(t,7,3) wind
   endif
   k6=1
   k8=1
   IF inlist(15,U1,U2,U3,U4,U5)
      K2=1
      IF T_M>3
         K2=((0.048*(T_M-3))**0.8)+1.0     && B1>3 ТОЛЩИНА МАТЕРИАЛА ЛИСТА K2=>1
      ENDIF
      if b>300
         K3=0.35-(0.0000125*(B-300)**0.56)   && B1-ШИРИНА РЕЗА>300 K4#0
      else
         K3=0.35
      endif
      if KRE=0
         K5=1                                 && N-КОЛ-ВО РЕЗОВ
      else
         K5=((0.6*(KRE-1))**0.95)+1.0         && N-КОЛ-ВО РЕЗОВ
      endif
      IF inlist(1,U1,U2,U3,U4,U5)
         K8=1.4
      ENDIF
      *wait 'formul 14 u=15 p='+str(p,5)+' K2'+str(k2,4,2)+' K8='+str(k8,4,2)+' K5='+str(k5,4,2)+' K3='+str(k3,4,2)+' t='+str(t,7,3) wind
      IF P<=1000
         T=K8*K2*K3*K5*0.67
      ELSE
         IF P>1000.AND.P=<3200
          T=(0.664*10**-3*(0.5*P-500)**0.84+0.67)*K8*K2*K3*K5  && P<3200  К8=1.4-ПРИ РЕЗКЕ ДВУМЯ РАБОЧИМИ kodm=1, К4(КОЭФ.НА РАЗМЕТКУ))=1-КЗ
         ELSE
            T=((0.83*10**-3*(0.5*P-1600)**0.69+4.05)/2.8)*K8*K2*K3*K5  && P>3200
         ENDIF
      ENDIF
   ENDIF
   IF inlist(16,U1,U2,U3,U4,U5)
      K1=0.64
      IF B>130
         K1=(7.7*10**-4*(B-130)**0.75)+0.64   && B1-ШИРИНА РЕЗА>130 K1#0
      ENDIF
      K2=1
      IF T_M>3
         K2=((0.32*(T_M-3))**0.7)+1.0   && K2#0
      ENDIF
      if kre=0
         K5=1   &&
      else
         K5=0.6*(KRE-1)+1.0   &&
      endif
      IF inlist(3,U1,U2,U3,U4,U5)
         K6=0.81
      ENDIF
      IF inlist(4,U1,U2,U3,U4,U5)
         K6=0.73
      ENDIF
      IF inlist(1,U1,U2,U3,U4,U5)
         K8=0.7
      ENDIF
      if b>130
         K3=0.44-(9.5*10**-6*(B-130))**0.75
      else
         K3=0.44
      endif
      *wait 'formul 14 u=16 l='+str(l,5)+' K2'+str(k2,4,2)+' K8='+str(k8,4,2)+' K5='+str(k5,4,2)+' K6='+str(k6,4,2)+' K3='+str(k3,4,2)+' t='+str(t,7,3) wind
      IF L<130
         T=K1*K2*K3*K5*K6*K8  && L<=130
      ELSE
         IF L>130.AND.L<=1800
            T=((1.74*10**-3*(L-130)*0.84)+1.0)*K1*K2*K3*K5*K6*K8  && L<=1800   К4(КОЭФ.НА РАЗМЕТКУ))=1-КЗ K6=0.73 ПРИ kodm=3   K8=1.0 ПРИ kodm=1 ИНАЧЕ K8=0.7
         ELSE
            T=((0.83*10**-3*(L-1800)*1.55)+3.55)*K2*K3*K5*K6*K8  && P>1800   К4(КОЭФ.НА РАЗМЕТКУ))=1-КЗ
         ENDIF
      ENDIF
   ENDIF
ENDIF

IF n_f=15
   IF inlist(14,U1,U2,U3,U4,U5)
      if b>300
         K4=(0.0000125*(B-300)**0.56)+0.65   && B1-ШИРИНА РЕЗА>300 K4#0
      else
         k4=0.65
      endif
      k6=1
      IF inlist(3,U1,U2,U3,U4,U5)
         K6=0.79
      ENDIF
      IF S<125
         K7=1
      ELSE
         IF S>125.AND.s=<5400
            k7=(0.0018*(S-125)**0.65)+1.0  && S=<5400
         ELSE
            K7=0.0006*(S-5400)+5.25        && S>5400
         ENDIF
      ENDIF
      k8=1
      IF inlist(1,U1,U2,U3,U4,U5)
         K8=0.7
      ENDIF
      IF L<130
         T=0.12*K4*K6*K7*K8  && L=<130
      ELSE
         IF L>130.AND.L=<1800
            T=((1.84*10**-4*(L-130)**0.86)+0.12)*K4*K6*K7*K8  && L=<1800
         ELSE
            t=(2.11*10**-4*(L-1800)+0.47)*K4*K6*K7*K8        && L>1800   1-РАБ К8=0.7  , ПРИ kodm=1 -2-РАБ К8=1.0 К6=0.79 ПРИ РЕЗКЕ С МЕРНОЙ ПОЛОСЫ  kodm=3
         ENDIF
      ENDIF
      *wait 'formul 15 u=14 l='+str(l,5)+' K4'+str(k4,4,2)+' K6='+str(k6,4,2)+' K7='+str(k7,4,2)+' K8='+str(k8,4,2)+' t='+str(t,7,3) wind
   endif
   k6=1
   k8=1
   IF inlist(15,U1,U2,U3,U4,U5)
      IF inlist(1,U1,U2,U3,U4,U5)
         K8=1.4
      ENDIF
      K2=1
      IF T_M>3
         K2=((0.048*(T_M-3))**0.8)+1.0    && B1>3 ТОЛЩИНА МАТЕРИАЛА ЛИСТА K2=>1
      ENDIF
      if kre=0
         K5=1   && N-КОЛ-ВО РЕЗОВ
      else
           K5=((0.6*(KRE-1))**0.95)+1.0   && N-КОЛ-ВО РЕЗОВ
      endif
                                                    * N=(1.8*10**-3*(0.5*P-2200)*K2*K3*K4*K5  && P>=4400   К4(КОЭФ.НА РАЗМЕТКУ))=1-КЗ
                                                    * N=(1.3*10**-3*(0.5*P-1200)*K2*K3*K4*K5  && P<4400   К4(КОЭФ.НА РАЗМЕТКУ))=1-КЗ
                                                    * K5=((0.55*(N-1))**0.95)+1.0   && N-КОЛ-ВО РЕЗОВ
                                                    *K2=((0.024*(B-6))**0.86)+0.62   && B-ТОЛЩИНА B>6 К2#0 >1
      if b>300
         K4=(0.0000125*(B-300)**0.56)+0.65   && B1-ШИРИНА РЕЗА>300 K4#0
      else
         k4=0.65
      endif
      IF P<1000
         T=K8*K2*K4*K5*0.67
      ELSE
         IF P>1000.AND.P=<3200
            T=(0.664*10**-3*(0.5*P-500)**0.84+0.67)*K8*K2*K4*K5  && P<3200  К8=1.4-ПРИ РЕЗКЕ ДВУМЯ РАБОЧИМИ kodm=1, К4(КОЭФ.НА РАЗМЕТКУ))=1-КЗ
         ELSE
            T=((0.83*10**-3*(0.5*P-1600)**0.69+4.05)/2.8)*K8*K2*K4*K5  && P>3200
         ENDIF
      ENDIF
   ENDIF
   if inlist(16,U1,U2,U3,U4,U5)
      K1=0.64
      IF B>130
         K1=(7.7*10**-4*(B-130)**0.75)+0.64   && B1-ШИРИНА РЕЗА>130 K1#0
      ENDIF
      K2=1
      IF T_M>3
         K2=((0.032*(T_M-3))**0.7)+1.0   && K2#0
      ENDIF
      if kre=0
         K5=1
      else
         K5=0.6*(KRE-1)+1.0   &&
      endif
      IF inlist(3,U1,U2,U3,U4,U5)
         K6=0.81
      ENDIF
      IF inlist(4,U1,U2,U3,U4,U5)
         K6=0.73
      ENDIF
      IF inlist(1,U1,U2,U3,U4,U5)
         K8=0.7
      ENDIF
      IF L<=1800
         if b>130
            K4=(9.5*10**-6*(B-130))**0.75+0.56
         else
            k4=0.56
         endif
         IF L<130
            T=K1*K2*K4*K5*K6*K8  && L<130
         ELSE
            T=((1.74*10**-3*(L-130)*0.84)+1.1)*K1*K2*K4*K5*K6*K8  && L<=1800   К4(КОЭФ.НА РАЗМЕТКУ))=1-КЗ K6=0.73 ПРИ kodm=3   K8=1.0 ПРИ kodm=1 ИНАЧЕ K8=0.7
         ENDIF
      ELSE
         if b>130
            K4=(9.5*10**-6*(B-130))**0.75+0.56
         else
            k4=0.56
         endif
         T=((0.83*10**-3*(L-1800)*1.55)+3.55)*K2*K4*K5*K6*K8  && P>1800   К4(КОЭФ.НА РАЗМЕТКУ))=1-КЗ
      ENDIF
   ENDIF
ENDIF
IF n_f=16
   kp=1
   IF inlist(5,U1,U2,U3,U4,U5)
      kp=1.3
   ENDIF
   IF inlist(3,U1,U2,U3,U4,U5)
      k1=1
      if b>30
         K1=0.0045*(B-30)+1.0   && K1#0>1.0
      endif
      k2=1
      if t_m>4
         K2=0.097*(t_m-4)+1.0   && K2#0>1.0
      endif
      t=(0.332*10**-3*(L+660)*(K1-0.13))*K2*KP  &&  КP=1.3(КОЭФ.НА ПРАВКУ НА РЕБРО ПРИ kodm=5
   ENDIF
   IF inlist(19,U1,U2,U3,U4,U5)
      k8=1
      IF inlist(1,U1,U2,U3,U4,U5)
        k8=2
      endif
      if b>75
         K1=(0.008*(B-75)**0.86)+0.23   && B1-ШИРИНА РЕЗА>75 K1#0
      else
         k1=0.23
      endif
      if t_m=<2
         k2=1.06
      ELSE
         if t_m>2.and.t_m=<6
            K2=1.0-(t_m-2)+0.06          && ПРИ В<6
         else
            K2=(0.116*(t_m-6)**1.2)+1.0   && B-ТОЛЩИНА РЕЗА>=6 K2#0>1
         endif
      endif
      b1=1
      if b>1250
         b1=1.3
      endif
      t=(3.2*10**-3*b+b1)*K2*K1*k8  &&  BL=1.3 ПРИ В>=1250 ММ ИНАЧЕ=0
   ENDIF
   IF inlist(6,U1,U2,U3,U4,U5)
      k2=1
      if t_m>3
         K2=(0.122*(t_m-3)**1.15)+1.0   && B-ТОЛЩИНА РЕЗА>=3 K2#0>1
      endif
      b1=1
      if b>40
         b1=0.12
      endif
      t=(4.4*10**-4*b+b1+0.25)*K2*K8  &&  BL=1.3 ПРИ В>=40 ММ ИНАЧЕ=0  ВЫП.ПРИ kodm=6       К8=2.0 ПРИ РАБОТЕ 2-Х ЧЕЛОВЕК kodm=1
   ENDIF
endif
IF n_f=18
   IF SO=2 or SO=7                    && KF=1-КРУГ KF=0.96-КВАДРАТ KF=0.95-УГОЛОК KF=0.93-ШВЕЛЛЕР KF=0.84-РЕЛЬС,ДВУТАВР
      KF=1.02
   ENDIF
   IF SO=4
      KF=1.7
   ENDIF
   IF SO=5
      KF=1.11
   ENDIF
   IF SO=9
      KF=1.28
   ENDIF
   IF SO=6 or SO=8
      KF=1.79
   ENDIF
   IF SO=10
      KF=1.87
   ENDIF
   IF SO=18
      KF=2.89
   ENDIF
   if l<500 or s<600
      t=1.2*KF
   else
      t=(((3.0*10**-4*(L-500))**1.2+0.6)*((3.0*10**-4)*(S-600)**0.57)+0.6)*KF  &&  KF=1.87-БАЛКИ KF=2.89-РЕЛЬС KF=1.7-ПОЛОСА KF=1.79-ШВЕЛЛЕР KF=1.28-УГОЛОК KF=1.11-КВАДРАТ KF=1.02-КРУГ
   endif
ENDIF
IF n_f=19
   k8=1
   IF inlist(1,U1,U2,U3,U4,U5)
      k8=2
   endif
   IF SO=2
      KF=1.5
      IF S>=80
         KF=(0.00124*(S-80)**0.9)+1.5   && S<=80
      ENDIF
   ENDIF
   IF SO=7
      KF=1.61
      IF S>=85
         KF=(0.00125*(S-85)**0.9)+1.61   &&
      ENDIF
   ENDIF
   IF SO=5
      KF=1.75
      IF S>=100
         KF=(0.00125*(S-100)**0.9)+1.75   &&
      ENDIF
   ENDIF
   IF SO=6 or so=8
      KF=1.83
      IF S>=615
         KF=(0.00125*(S-615)**0.9)+1.83  &&
      ENDIF
   ENDIF
   IF SO=9
      KF=1.0
      IF S>=145
         KF=(0.00145*(S-145)**0.6)+1.0   &&
      ENDIF
   ENDIF
   if l<300
      t=0.25*KF*K8
   else
      if l>300 and l=<1500
         t=(0.292*10**-3*(L-300)+0.25)*KF*K8 &&  L<=1500    ПРИ kodm=1 K8=2
      else
         t=(0.35*10**-3*(L-1500)+0.6)*KF*K8  &&  L>1500     ПРИ kodm=1 K8=2
      endif
   endif
ENDIF
IF n_f=20
   k8=1
   IF inlist(1,U1,U2,U3,U4,U5)
      k8=2
   endif
   k11=1
   if inlist(5,U1,U2,U3,U4,U5)
      k11=1.5
   endif
   k1=1
   if b>60
      K1=(0.00475*(B-60)**0.94)+1.0   &&
   endif
   if t_m=<6
      k2=1
   else
      if t_m>6.and.t_m=<16
         K2=0.045*(t_m-6)+1.0    && ПРИ В<=16
      else
         K2=0.1*(t_m-16)+1.45   && ПРИ В>16
      endif   
   endif
   if l<120
      t=0.11*K1*K2*K8*K11
   else
      t=(3.69*10**-4*(L-120)+0.11)*K1*K2*K8*K11  && L РЕЗА>=120 K8=1.1 ПРИ РАБОТЕ 2-Х РАБ.K11=1.5 kodm=1.... ПРИ ПРАВКЕ НА РЕБРО kodm=6
   endif
ENDIF
IF n_f=21
   if t_m=<4
      k2=1
   else   
      if t_m>4.and.t_m=<12
         K2=1.0+(0.003*(t_m-4))**0.32   &&           &&ПРИ В=<12 И ПРИ В=4 К2=1.0
      else
         K2=(0.0074*(t_m-12)**1.3)+0.86    && ПРИ В>12
      endif
   endif
   t=(0.93*10**-3*P+0.25)*K2  &&
ENDIF
IF n_f=22
   IF inlist(17,U1,U2,U3,U4,U5)
      IF L<10
         T=0.024
      Else
         T=(2*(((L-10)**1/1.8)/1000+0.12))*0.1
      ENDIF
   endif
   IF inlist(18,U1,U2,U3,U4,U5)
      if l<=50
         T=0.007
      else
         T=(((L-50)**1/3.05)/1000+0.07)*0.1
      endif
   endif
ENDIF
IF n_f=24
   c=1
   IF inlist(7,U1,U2,U3,U4,U5)
      c=1.75
   endif
   kh=1
   IF inlist(8,U1,U2,U3,U4,U5)
      kh=1.8
   endif
   IF inlist(9,U1,U2,U3,U4,U5)
      kh=2.8
   endif
   kf=1
   IF SO=5
      KF=1.03
   ENDIF
   IF SO=7
      KF=1.14
   ENDIF
   IF SO=6 or so=8
      KF=0.41
   ENDIF
   IF SO=10
      KF=0.58
   ENDIF
   if so=2 or so=5 or so=7
      if l<250 or s<380
         t=1.4*KH*C
      else
         t=(((2.1*10**-4*(L-250))**0.7+0.4)*((KF*5.8*10**-4)*(S-380)**0.54)+1.0)*KH*C
      endif
   else
      if l<250 or s<380
         t=1.7*KH*C
      else
         t=(((1.51*10**-4*(L-250))**0.84+0.7)*((KF*1.8*10**-4)*(S-380)**0.9)+1.0)*KH*C  &&  KF=1.87-БАЛКИ KF=2.89-РЕЛЬС KF=1.7-ПОЛОСА KF=1.79-ШВЕЛЛЕР KF=1.28-УГОЛОК KF=1.11-КВАДРАТ KF=1.02-КРУГ
      endif
   endif
ENDIF
IF n_f=25
   c=1
   IF inlist(7,U1,U2,U3,U4,U5)
      c=1.75
   endif
   kh=1
   IF inlist(8,U1,U2,U3,U4,U5)
      kh=1.8
   endif
   IF inlist(9,U1,U2,U3,U4,U5)
      kh=2.8
   endif
   kf=1
   IF SO=5
      KF=1.03
   ENDIF
   IF SO=7
      KF=1.14
   ENDIF
   IF SO=6 or so=8
      KF=0.41
   ENDIF
   IF SO=10
      KF=0.58
   ENDIF
   if so=2 or so=5 or so=7
      if l<1200.or.s<1250
         t=2.8*KH*C
      else
         t=(((4.82*10**-4*(L-1200))**0.97+1.4)*((KF*6.7*10**-4)*(S-1250)**1.25)+1.4)*KH*C  &&  KF=1.87-БАЛКИ KF=2.89-РЕЛЬС KF=1.7-ПОЛОСА KF=1.79-ШВЕЛЛЕР KF=1.28-УГОЛОК KF=1.11-КВАДРАТ KF=1.02-КРУГ
      endif
   else
      if l<1200 or s<380
         t=3.8*KH*C
      else
         t=(((1.93*10**-4*(L-1200))**0.65+1.9)*((4.0*10**-4)*(S-380)**0.94)+1.9)*KH*C  &&  KF=1.87-БАЛКИ KF=2.89-РЕЛЬС KF=1.7-ПОЛОСА KF=1.79-ШВЕЛЛЕР KF=1.28-УГОЛОК KF=1.11-КВАДРАТ KF=1.02-КРУГ
      endif
   endif
ENDIF
IF n_f=26
   if lt=<1200
      t=0.415*10**-3*Lt+0.175  
   else
      t=0.225*10**-3*Lt+0.4  
   endif
ENDIF
IF n_f=27
   if WES<0.250
      t=0.09
   else
      t=(3.8*10**-3*(WES-0.250))**0.56+0.09  &&
   endif
ENDIF
IF n_f=28
   k10=1
   IF inlist(2,U1,U2,U3,U4,U5)
      k10=1.2
   endif
   k2=1
   if t_m>4.and.t_m=<10
      k2=1-0.042*(t_m-4)
   else
      k2=(0.0118*(t_m-10))**1.4+0.75
   endif
   *WAit ' wes='+str(wes,10,5)  wind
   IF WES<0.25
      t=1.24*10**-3*lt*k2*k10+0.09
   ELSE
      t=1.24*10**-3*LT*k10*k2+(3.8*10**-3*(WES-0.25))**0.56+0.09
   ENDIF
ENDIF
if n_f=30
   IF LT<10
      T=0.24
   Else
      T=((LT-10)**1/1.8)/1000+0.12
   ENDIF
endif
*thisform.normw  = T
*ThisForm.Pageframe1.Page2.txtNormw.Value = T
*wait window 'proc formula vrem='+str(thisform.normw,7,4)
m.normw=t
retu