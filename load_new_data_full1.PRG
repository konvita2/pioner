 * перекачка всех данных из старой в новую
 * данные для перекачки лежат в папке gotov
 
close tables all
set confirm off 

* kt +++
wait window nowait 'Loading file kt'
use kt exclusive 
zap
append from gotov\kt
use in kt

* ww +++
*!*	wait window nowait 'Loading file ww'
*!*	use ww exclusive 
*!*	zap
*!*	append from gotov\ww
*!*	use in ww

* nar +++
*!*	wait window nowait 'Loading file nar'
*!*	use nar exclusive 
*!*	zap
*!*	append from gotov\nar
*!*	use in nar

* pzt +++
*!*	wait window nowait 'Loading file pzt'
*!*	use pzt exclusive 
*!*	zap
*!*	append from gotov\pzt
*!*	use in pzt

* newkod +++
wait window nowait 'Loading file newkod'
use newkod exclusive 
zap
append from gotov\newkod
use in newkod

* a_izd +++
wait window nowait 'Loading file a_izd'
use a_izd exclusive 
zap
append from gotov\a_izd
use in a_izd

* izd +++
wait window nowait 'Loading file izd'
use izd exclusive 
zap
append from gotov\izd
use in izd

* nastr +++
wait window nowait 'Loading file nastr'
use nastr exclusive 
zap
append from gotov\nastr
use in nastr

* plancalc +++
wait window nowait 'Loading file plancalc'
use plancalc exclusive 
zap
append from gotov\plancalc
use in plancalc

* shwzras +++
wait window nowait 'Loading file shwzras'
use shwzras exclusive 
zap
append from gotov\shwzras
use in shwzras

* shwzras02 +++
wait window nowait 'Loading file shwzras02'
use shwzras02 exclusive 
zap
append from gotov\shwzras02
use in shwzras02

* dosp +++
*!*	wait window nowait 'Loading file dosp'
*!*	use dosp exclusive 
*!*	zap
*!*	append from gotov\dosp
*!*	use in dosp

* pz +++
*!*	wait window nowait 'Loading file pz'
*!*	use pz exclusive 
*!*	zap
*!*	append from gotov\pz
*!*	use in pz

* wwlim +++
*!*	wait window nowait 'Loading file wwlim'
*!*	use wwlim exclusive 
*!*	zap
*!*	append from gotov\wwlim
*!*	use in wwlim

* te +++
wait window nowait 'Loading file te'
use te exclusive 
zap
append from gotov\te
use in te

* usp +++
wait window nowait 'Loading file usp'
use usp exclusive 
zap
append from gotov\usp
use in usp

* uo +++
wait window nowait 'Loading file uo'
use uo exclusive 
zap
append from gotov\uo
use in uo

* instr +++
wait window nowait 'Loading file instr'
use instr exclusive 
zap
append from gotov\instr
use in instr

* press +++
wait window nowait 'Loading file press'
use press exclusive 
zap
append from gotov\press
use in press

* ktu +++
wait window nowait 'Loading file ktu'
use ktu exclusive 
zap
append from gotov\ktu
use in ktu

* kto +++
wait window nowait 'Loading file kto'
use kto exclusive 
zap
append from gotov\kto
use in kto

* tto +++
wait window nowait 'Loading file tto'
use tto exclusive 
zap
append from gotov\tto
use in tto

* pt +++
wait window nowait 'Loading file pt'
use pt exclusive 
zap
append from gotov\pt
use in pt

* obor +++
wait window nowait 'Loading file obor'
use obor exclusive 
zap
append from gotov\obor
use in obor

* limit +++
wait window nowait 'Loading file limit'
use limit exclusive 
zap
append from gotov\limit
use in limit

* dvigen +++
*!*	wait window nowait 'Loading file dvigen'
*!*	use dvigen exclusive 
*!*	zap
*!*	append from gotov\dvigen
*!*	use in dvigen

* ras +++
*!*	wait window nowait 'Loading file ras'
*!*	use ras exclusive 
*!*	zap
*!*	append from gotov\ras
*!*	use in ras

* rast +++
*!*	wait window nowait 'Loading file rast'
*!*	use rast exclusive 
*!*	zap
*!*	append from gotov\rast
*!*	use in rast

* ostatok +++
*!*	wait window nowait 'Loading file ostatok'
*!*	use ostatok exclusive 
*!*	zap
*!*	append from gotov\ostatok
*!*	use in ostatok

* kta +++
wait window nowait 'Loading file kta'
use kta exclusive 
zap
append from gotov\kta
use in kta

* obmen +++
wait window nowait 'Loading file obmen'
use obmen exclusive 
zap
append from gotov\obmen
use in obmen

* ptt +++
wait window nowait 'Loading file ptt'
use ptt exclusive 
zap
append from gotov\ptt
use in ptt

* normmat1 +++
wait window nowait 'Loading file normmat1'
use normmat1 exclusive 
zap
append from gotov\normmat1
use in normmat1

* t1 +++
wait window nowait 'Loading file t1'
use t1 exclusive 
zap
append from gotov\t1
use in t1

* shwzimi +++
wait window nowait 'Loading file shwzimi'
use shwzimi exclusive 
zap
append from gotov\shwzimi
use in shwzimi

* mater +++
*!*	wait window nowait 'Loading file mater'
*!*	use mater exclusive 
*!*	zap
*!*	append from gotov\mater
*!*	use in mater

* obmen2 +++
wait window nowait 'Loading file obmen2'
use obmen2 exclusive 
zap
append from gotov\obmen2
use in obmen2

* sprav +++
wait window nowait 'Loading file sprav'
use sprav exclusive 
zap
append from gotov\sprav
use in sprav

* kadry +++
*!*	wait window nowait 'Loading file kadry'
*!*	use kadry exclusive 
*!*	zap
*!*	append from gotov\kadry
*!*	use in kadry

* normmat +++
wait window nowait 'Loading file normmat'
use normmat exclusive 
zap
append from gotov\normmat
use in normmat

* post +++
wait window nowait 'Loading file post'
use post exclusive 
zap
append from gotov\post
use in post

* rd +++
wait window nowait 'Loading file rd'
use rd exclusive 
zap
append from gotov\rd
use in rd

* tarif +++
wait window nowait 'Loading file tarif'
use tarif exclusive 
zap
append from gotov\tarif
use in tarif

* peo1 +++
wait window nowait 'Loading file peo1'
use peo1 exclusive 
zap
append from gotov\peo1
use in peo1

* peo2 +++
wait window nowait 'Loading file peo2'
use peo2 exclusive 
zap
append from gotov\peo2
use in peo2

* 555 +++
wait window nowait 'Loading file 555'
use 555 exclusive 
zap
append from gotov\555
use in 555

* mech +++
wait window nowait 'Loading file mech'
use mech exclusive 
zap
append from gotov\mech
use in mech

* peo +++
wait window nowait 'Loading file peo'
use peo exclusive 
zap
append from gotov\peo
use in peo

* porez +++
wait window nowait 'Loading file porez'
use porez exclusive 
zap
append from gotov\porez
use in porez

* porezzak +++
wait window nowait 'Loading file porezzak'
use porezzak exclusive 
zap
append from gotov\porezzak
use in porezzak

* pri +++
wait window nowait 'Loading file pri'
use pri exclusive 
zap
append from gotov\pri
use in pri

* prit +++
wait window nowait 'Loading file prit'
use prit exclusive 
zap
append from gotov\prit
use in prit

* saldo +++
wait window nowait 'Loading file saldo'
use saldo exclusive 
zap
append from gotov\saldo
use in saldo

* svi +++
wait window nowait 'Loading file svi'
use svi exclusive 
zap
append from gotov\svi
use in svi

* test +++
wait window nowait 'Loading file test'
use test exclusive 
zap
append from gotov\test
use in test

* tttm +++
wait window nowait 'Loading file tttm'
use tttm exclusive 
zap
append from gotov\tttm
use in tttm

* zatraty +++
wait window nowait 'Loading file zatraty'
use zatraty exclusive 
zap
append from gotov\zatraty
use in zatraty

* zatrsum +++
wait window nowait 'Loading file zatrsum'
use zatrsum exclusive 
zap
append from gotov\zatrsum
use in zatrsum

* a_kt +++
wait window nowait 'Loading file a_kt'
use a_kt exclusive 
zap
append from gotov\a_kt
use in a_kt

* a_nar +++
wait window nowait 'Loading file a_nar'
use a_nar exclusive 
zap
append from gotov\a_nar
use in a_nar

* a_ww +++
wait window nowait 'Loading file a_ww'
use a_ww exclusive 
zap
append from gotov\a_ww
use in a_ww

* koop +++
wait window nowait 'Loading file koop'
use koop exclusive 
zap
append from gotov\koop
use in koop

* ktmodi +++
wait window nowait 'Loading file ktmodi'
use ktmodi exclusive 
zap
append from gotov\ktmodi
use in ktmodi

* ktsvar +++
wait window nowait 'Loading file ktsvar'
use ktsvar exclusive 
zap
append from gotov\ktsvar
use in ktsvar

* ostatki +++
wait window nowait 'Loading file ostatki'
use ostatki exclusive 
zap
append from gotov\ostatki
use in ostatki

* ostatki1 +++
wait window nowait 'Loading file ostatki1'
use ostatki1 exclusive 
zap
append from gotov\ostatki1
use in ostatki1

* raschet +++
wait window nowait 'Loading file raschet'
use raschet exclusive 
zap
append from gotov\raschet
use in raschet

* raschet1 +++
wait window nowait 'Loading file raschet1'
use raschet1 exclusive 
zap
append from gotov\raschet1
use in raschet1

* temodi +++
wait window nowait 'Loading file temodi'
use temodi exclusive 
zap
append from gotov\temodi
use in temodi

* matrast +++
wait window nowait 'Loading file matrast'
use matrast exclusive 
zap
append from gotov\matrast
use in matrast

* techos +++
wait window nowait 'Loading file techos'
use techos exclusive 
zap
append from gotov\techos
use in techos

* temp +++
wait window nowait 'Loading file temp'
use temp exclusive 
zap
append from gotov\temp
use in temp

* tmp +++
wait window nowait 'Loading file tmp'
use tmp exclusive 
zap
append from gotov\tmp
use in tmp

* kt_1 +++
wait window nowait 'Loading file kt_1'
use kt_1 exclusive 
zap
append from gotov\kt_1
use in kt_1

* lang +++
wait window nowait 'Loading file lang'
use lang exclusive 
zap
append from gotov\lang
use in lang

* matras +++
wait window nowait 'Loading file matras'
use matras exclusive 
zap
append from gotov\matras
use in matras

* kpd +++
wait window nowait 'Loading file kpd'
use kpd exclusive 
zap
append from gotov\kpd
use in kpd

* brut +++
wait window nowait 'Loading file brut'
use brut exclusive 
zap
append from gotov\brut
use in brut

* kp +++
wait window nowait 'Loading file kp'
use kp exclusive 
zap
append from gotov\kp
use in kp

* mtto +++
wait window nowait 'Loading file mtto'
use mtto exclusive 
zap
append from gotov\mtto
use in mtto

* normtemp +++
wait window nowait 'Loading file normtemp'
use normtemp exclusive 
zap
append from gotov\normtemp
use in normtemp

* ttt +++
wait window nowait 'Loading file ttt'
use ttt exclusive 
zap
append from gotov\ttt
use in ttt

* ktupass +++
wait window nowait 'Loading file ktupass'
use ktupass exclusive 
zap
append from gotov\ktupass
use in ktupass

* pttorig +++
wait window nowait 'Loading file pttorig'
use pttorig exclusive 
zap
append from gotov\pttorig
use in pttorig

* imit +++
wait window nowait 'Loading file imit'
use imit exclusive 
zap
append from gotov\imit
use in imit

* tt +++
wait window nowait 'Loading file tt'
use tt exclusive 
zap
append from gotov\tt
use in tt

* загрузка log
wait window nowait 'Loading log file' 
delete from log 
select * from gotov\log into cursor c11
scan all
	waitproc(recno(),reccount(),'Loading log file')
	select c11
	scatter memvar 
	insert into log from memvar 
endscan 
use in c11

* все выгружено
wait window  'ВСЕ ВЫГРУЖЕНО! Нажмите любую клавишу...'
quit
 
