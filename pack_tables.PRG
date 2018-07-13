*** Упаковка таблиц

wait window nowait 'Упаковка таблиц'

close tables all
set safety off 
use brut exclusive
pack
use

use dosp exclusive 
pack
use

use instr exclusive 
pack
use

use izd exclusive 
pack
use

use kadry exclusive 
pack
use

use kp exclusive 
pack
use

use kpd exclusive 
pack
use

use kt exclusive 
pack
use

use kto exclusive 
pack
use

use ktu exclusive 
pack
use

use kt_1 exclusive 
pack
use

use lang exclusive 
pack
use

use mater exclusive 
pack
use

use matras exclusive 
pack
use

use matrast exclusive 
pack
use

use nar exclusive
pack
use

use nastr exclusive 
pack
use

use obor exclusive 
pack
use

use ostatok exclusive 
pack
use

use ostatok exclusive 
pack
use

use post exclusive 
pack
use

use press exclusive 
pack
use

use rd exclusive 
pack
use

use sprav exclusive 
pack
use

use tarif exclusive 
pack
use

use te exclusive 
pack
use

use techos exclusive 
pack
use

use temp exclusive 
pack
use

use tmp exclusive 
pack
use

use tto exclusive 
pack
use

use usp exclusive 
pack
use

use ww exclusive 
pack
use

update normmat set id = recno()

wait window nowait 'Простановка идентификаторов'
*** Проставить идентификаторы nozap
* brut
do set_nozap with 'brut'
* dosp
do set_nozap with 'dosp'
* instr
do set_nozap with 'instr'
* kadry
do set_nozap with 'kadry'
* kto 
do set_nozap with 'kto'
* ktu
do set_nozap with 'ktu'
* obor
do set_nozap with 'obor'
* post
do set_nozap with 'post'
* press
do set_nozap with 'post'
* rd
do set_nozap with 'rd'
* sprav
do set_nozap with 'sprav'
* tarif
do set_nozap with 'tarif'
* tto
do set_nozap with 'tto'
* ttp
do set_nozap with 'ttp'
* usp
do set_nozap with 'usp'
* ww
do set_nozap with 'ww'

* izd (id)
update izd set id = recno()

* normmat (id)
update normmat set id = recno()



close tables all

wait window nowait 'Обработка закончена...'