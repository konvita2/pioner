close all
open database db
select * from kt where shw=153 into cursor c100
scan all
	scatter memvar 
	release kod
	mark = .f.
	ipri = 2
	insert into ktmodi from memvar 
endscan
use in c100