* open file
local FN
FN = 'ostatki.chg'
local fh
fh = fcreate(FN,0)
* update records 
select * from ostatki order by ra,rb into cursor c100
scan all
 	
endscan
use in c100
* close file