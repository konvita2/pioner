select * from kt where at('��',kt.poznd) = 0 and d_u >1 into cursor c250
brow



select c250
scan all
	wait str(c250.kod) wind nowait
	update kt set poznd = alltrim(poznd)+' ��' where kod = c250.kod	 
endscan
use in c250
