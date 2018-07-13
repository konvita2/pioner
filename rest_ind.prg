
* восстановить индексы

set exclu on

close tables all

sele 1
use dosp
if .not.file ('dosp.cdx')
   inde  on str(vid,4)+str(kod,4) tag ivk
   inde  on str(vid,4)+str(kod,4)+str(us,6,2) tag ivku
   inde  on str(vid,4)+im          tag ivi
   inde  on str(vid,4)+sim         tag ivs
   inde  on str(vid,4)+str(us,6,2) tag ivu
endif
if .not.file ('dosp.dbf')
  namfil='DOSP.dbf'
  *do avar
endif
set filt to

sele 2
use kt
if .not.file ('kt.cdx')
   inde  on shw                    tag ishw
   inde  on POZNW+STR(D_u,1)+KORNW tag iPOZNW
   inde  on str(shw,6)+STR(PU,3)   tag iSP
   inde  on str(shw,6)+kornd       tag ikornd
   inde  on str(shw,6)+kornw+kornd tag ikn
   inde  on str(shw,6)+poznw+poznd tag ipoz
   inde  on str(shw,6)+poznw       tag iu
   inde  on str(shw,6)+poznd       tag ipoznd
   inde  on str(shw,6)+poznd+kornd       tag i7
   inde  on poznd                  tag i_d
   inde  on poznd+str(d_u,1)       tag i_du
   inde  on pozn+str(kodm,4)       tag ipm
   inde  on kodm                   tag ikodm
endif

sele 11
use ww
if .not.file ('ww.cdx')
   inde on data_z                   tag itd
   inde on shwz                     tag ishwz
   inde on kornw                    tag ikornw
   inde on shwz+poznd               tag isp
   inde on shwz+kornd               tag isk
   inde on shwz+poznd+str(mar,4)    tag ispm
   inde on shwz+str(mar,4)          tag ism
   inde on str(shw,6)+poznd+str(nto,4)+kodo tag i7
   inde on str(shw,6)+str(kodm,4)+str(mar,4)+str(kto,5) tag ippz
   inde on shwz+poznd+str(mar,4)+str(nto,4)     tag ipzr
   inde on shwz+kornd+str(mar,4)+str(nto,4)     tag ikzr
   inde on shwz+kornd+str(mar,4)+kodo           tag inar
   inde on shwz+kornd+str(nto,4)                tag iskn
   inde on shwz+kornd+str(mar,4)                tag iskm
   inde on shwz+str(kodp,4)+str(mar,4)          tag ippz
   inde on kodm                                 tag ikodm
   inde on kodp                                 tag ikodp
   inde on poznd+kttp+str(nto,4)                tag ipks
   inde on kodo+str(vo,5,2)                     tag ikv
   inde on invn+str(data_n,2)+str(vn,5,2)       tag ikdn
   inde on invn+str(data_nd,2)+str(vnd,5,2)     tag ikdnd
endif

sele 8
use izd
if .not.file ('izd.cdx')
   inde  on KOD  tag iKOD
   inde  on ribf tag ir
   inde  on im   tag iim
   inde  on shwz tag ishwz
   inde on str(year(data_p),4)+str(mont(data_p),2)+str(day(data_p),2) tag idata_p
endif 

sele 3
use obor
if .not.file ('obor.cdx')
   inde on STR(VID,4)+MARKA   tag iVID
   inde on naim  tag in
   inde on marka tag ikodo
   inde on invn  tag iinvn
   inde on podr  tag ipodr
   inde on str(podr,4)+marka tag ipm
endif
