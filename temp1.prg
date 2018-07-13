select te.* from te, kt where te.poznd == kt.poznd and !empty(kt.poznd) and kt.shw = 22 into cursor c100
scan all
	select c100 
	scatter memvar 
	insert into temodi from memvar 	
endscan
use in c100


