close all
open database db
select * from te ;
	where between(kod,17581,17596) or between(kod,17439,17535) ;
	into cursor c100
scan all
	scatter memvar 
	release kod
	insert into temodi from memvar 
endscan	
use in c100	