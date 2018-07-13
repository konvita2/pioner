 * перекачка данных из старой в новую
 * данные для перекачки лежат в папке gotov
 
close tables all
set confirm off 

* brut +++
wait window nowait 'brut'
use brut exclusive 
zap
append from gotov\brut
use in brut

*!*	* dosp +++
*!*	wait window nowait 'dosp'
*!*	use dosp exclusive 
*!*	zap
*!*	append from gotov\dosp
*!*	use in dosp

* instr +++
wait window nowait 'instr'
use instr exclusive 
zap
append from gotov\instr
use in instr 

* izd +++
wait window nowait 'izd'
use izd exclusive 
zap
append from gotov\izd
use in izd

* kadry +++
wait window nowait 'kadry'
use kadry exclusive 
zap
append from gotov\kadry
use in kadry

* kp +++
wait window nowait 'kp'
use kp exclusive 
zap
append from gotov\kp
use in kp

* kpd +++
wait window nowait 'kpd'
use kpd exclusive 
zap
append from gotov\kpd
use in kpd
* kt +++
wait window nowait 'kt'
use kt exclusive 
zap
append from gotov\kt
use in kt

* kt_1 +++
wait window nowait 'kt_1'
use kt_1 exclusive 
zap
append from gotov\kt_1
use in kt_1

* lang +++
wait window nowait 'lang'
use lang exclusive 
zap
append from gotov\lang
use in lang

* log +++
wait window nowait 'log'
use log exclusive 
zap
append from gotov\log
use in log

* mater +++
*!*	wait window nowait 'mater'
*!*	use mater exclusive 
*!*	zap
*!*	append from gotov\mater
*!*	use in mater

* matras +++
wait window nowait 'matras'
use matras exclusive 
zap
append from gotov\matras
use in matras

* matrast +++
wait window nowait 'matrast'
use matrast exclusive 
zap
append from gotov\matrast
use in matrast

* nar +++
wait window nowait 'nar'
use nar exclusive 
zap
append from gotov\nar
use in nar

* nastr +++
wait window nowait 'nastr'
use nastr exclusive 
zap
append from gotov\nastr
use in nastr

* obor +++ tempor
wait window nowait 'obor'
use obor exclusive 
zap
append from gotov\obor
use in obor

* ostatok +++
*!*	wait window nowait 'ostatok'
*!*	use ostatok exclusive 
*!*	zap
*!*	append from gotov\ostatok
*!*	use in ostatok

* post +++
wait window nowait 'post'
use post exclusive 
zap
append from gotov\post
use in post

* press +++ tempor
wait window nowait 'press'
use press exclusive 
zap
append from gotov\press
use in press

* rd +++
wait window nowait 'rd'
use rd exclusive 
zap
append from gotov\rd
use in rd

*!*	* sprav
*!*	wait window nowait 'sprav'
*!*	use sprav exclusive 
*!*	zap
*!*	append from gotov\sprav
*!*	use in sprav

* tarif +++
wait window nowait 'tarif'
use tarif exclusive 
zap
append from gotov\tarif
use in tarif

* te +++ tempor
wait window nowait 'te'
use te exclusive 
zap
append from gotov\te
use in te

* techos +++
wait window nowait 'techos'
use techos exclusive 
zap
append from gotov\techos
use in techos

* temp +++
wait window nowait 'temp'
use temp exclusive 
zap
append from gotov\temp
use in temp

* tmp +++
wait window nowait 'tmp'
use tmp exclusive 
zap
append from gotov\tmp
use in tmp

* usp +++ tempor
wait window nowait 'usp'
use usp exclusive 
zap
append from gotov\usp
use in usp

* ww +++ 
*!*	wait window nowait 'ww'
*!*	use ww exclusive 
*!*	zap
*!*	append from gotov\ww
*!*	use in ww

* newkod +++ 
wait window nowait 'newkod'
use newkod exclusive 
zap
append from gotov\newkod
use in newkod

* a_nar +++
wait window nowait 'a_nar'
use a_nar exclusive 
zap
append from gotov\a_nar
use in a_nar

* a_izd +++
wait window nowait 'a_izd'
use a_izd exclusive 
zap
append from gotov\a_izd
use in a_izd

* a_ww +++
wait window nowait 'a_ww'
use a_ww exclusive 
zap
append from gotov\a_ww
use in a_ww

* a_kt +++
wait window nowait 'a_kt'
use a_kt exclusive 
zap
append from gotov\a_kt
use in a_kt

* ktmodi +++
wait window nowait 'ktmodi'
use ktmodi exclusive 
zap
append from gotov\ktmodi
use in ktmodi

* temodi +++
wait window nowait 'temodi'
use temodi exclusive 
zap
append from gotov\temodi
use in temodi

* km


* koop +++
wait wind nowait 'koop'
use koop exclu 
zap
append from gotov\koop

* normmat +++
wait window nowait 'normmat'
use normmat exclusive 
zap
append from gotov\normmat
use in normmat

* normmat1 +++
wait window nowait 'normmat1'
use normmat1 exclusive 
zap
append from gotov\normmat1
use in normmat1

* shwzras +++
wait window nowait 'shwzras'
use shwzras exclusive
zap
append from gotov\shwzras
use in shwzras

* shwzras02 +++
wait window nowait 'shwzras02'
use shwzras02 exclusive
zap
append from gotov\shwzras02
use in shwzras02

* ostatki +++
wait wind nowa 'ostatki'
use ostatki exclusive
zap
append from gotov\ostatki
use in ostatki

* ostatki1 +++
wait wind nowait 'ostatki1'
use ostatki1 exclusive
zap
append from gotov\ostatki1
use in ostatki1

* raschet +++
wait wind nowait 'raschet'
use raschet exclu 
zap
append from gotov\raschet

* raschet1 +++
wait wind nowait 'raschet1'
use raschet1 exclu 
zap
append from gotov\raschet1

* ktsvar +++
wait wind nowait 'ktsvar'
use ktsvar exclu 
zap
append from gotov\ktsvar

* dvigen +++
*!*	wait wind nowait 'dvigen'
*!*	use dvigen exclu 
*!*	zap
*!*	append from gotov\dvigen

* ras +++
*!*	wait wind nowait 'ras'
*!*	use ras exclu 
*!*	zap
*!*	append from gotov\ras

* rast +++
*!*	wait wind nowait 'rast'
*!*	use rast exclu 
*!*	zap
*!*	append from gotov\rast

* wwlim +++
*!*	wait wind nowait 'wwlim'
*!*	use wwlim exclu 
*!*	zap
*!*	append from gotov\wwlim

* limit +++
wait wind nowait 'limit'
use limit exclu 
zap
append from gotov\limit

* pri +++
wait wind nowait 'pri'
use pri exclu 
zap
append from gotov\pri

* prit +++
wait wind nowait 'prit'
use prit exclu 
zap
append from gotov\prit

* saldo +++
wait wind nowait 'saldo'
use saldo exclu 
zap
append from gotov\saldo

* tb_temp1 +++
wait wind nowait 'tb_temp1'
use tb_temp1 exclu 
zap
append from gotov\tb_temp1

* temp1 +++
wait wind nowait 'temp1'
use temp1 exclu 
zap
append from gotov\temp1

* aaa1 +++
wait wind nowait 'aaa1'
use aaa1 exclu 
zap
append from gotov\aaa1

* test +++
wait wind nowait 'test'
use test exclu 
zap
append from gotov\test

* mech +++
wait wind nowait 'mech'
use mech exclu 
zap
append from gotov\mech

* 555 +++
wait wind nowait '555'
use 555 exclu 
zap
append from gotov\555

* tttm +++
wait wind nowait 'tttm'
use tttm exclu 
zap
append from gotov\tttm

* peo +++
wait wind nowait 'peo'
use peo exclu 
zap
append from gotov\peo

* svi +++
wait wind nowait 'svi'
use svi exclu 
zap
append from gotov\svi

* porezzak +++
wait wind nowait 'porezzak'
use porezzak exclu 
zap
append from gotov\porezzak

* porez +++
wait wind nowait 'porez'
use porez exclu 
zap
append from gotov\porez

* zatrsum +++
wait wind nowait 'zatrsum'
use zatrsum exclu 
zap
append from gotov\zatrsum

* zatraty +++
wait wind nowait 'zatraty'
use zatraty exclu 
zap
append from gotov\zatraty

* pz +++
wait wind nowait 'pz'
use pz exclu 
zap
append from gotov\pz

* pzt +++
wait wind nowait 'pzt'
use pzt exclu 
zap
append from gotov\pzt

* t1 +++
wait wind nowait 't1'
use t1 exclu 
zap
append from gotov\t1



* ===========================
* kto +++ tempor
wait window nowait 'kto'
use kto exclusive 
zap
append from gotov\kto
use in kto

*!*	* ktu +++ tempor
wait window nowait 'ktu'
use ktu exclusive 
zap
append from gotov\ktu
use in ktu

*!*	* tto +++ tempor
wait window nowait 'tto'
use tto exclusive 
zap
append from gotov\tto
use in tto

* peo1
wait window nowait 'peo1'
use peo1 exclusive 
zap
append from gotov\peo1
use in peo1

* peo2
wait window nowait 'peo2'
use peo2 exclusive 
zap
append from gotov\peo2
use in peo2


* temp2
* twer
* usp
* uu
* u_p
* vidoper
* vrem
* zatraty
* zatrsum



****************************************************

*** dosp


wait window nowait 'End of process'
 