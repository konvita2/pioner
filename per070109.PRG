* прогрмма переноса справочников дл€ версии от 09-01-07
set deleted on
set exclusive off
open database db

* uo
use uo
delete all
append from z:\34\uo
use in uo

* dosp 31
delete from dosp where vid=31
select * from z:\34\dosp where vid=31 into cursor c100
scan all
	select c100
	scatter memvar 
	m.nozap = get_newkod('dosp')
	insert into dosp from memvar 
endscan 
use in c100

* dosp 30
delete from dosp where vid=30
select * from z:\34\dosp where vid=30 into cursor c100
scan all
	select c100
	scatter memvar 
	m.nozap = get_newkod('dosp')
	insert into dosp from memvar 
endscan 
use in c100

* dosp 34
delete from dosp where vid=34
select * from z:\34\dosp where vid=34 into cursor c100
scan all
	select c100
	scatter memvar 
	m.nozap = get_newkod('dosp')
	insert into dosp from memvar 
endscan 
use in c100

* usp 
use usp
delete all
append from z:\34\usp
use in usp

* instr
use instr
delete all
append from z:\34\instr
use in instr

* uu
use uu
delete all
append from z:\34\uu
use in uu

* oot
use oot
delete all
append from z:\34\oot
use in oot