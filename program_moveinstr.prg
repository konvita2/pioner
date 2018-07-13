open database db

set procedure to procs

local mgr,msort,msp,msh,mkod,mkodm,mei,mnaim

select * from instr into cursor c100
scan all
	select c100
	scatter memvar
	
	do 	case
		case	c100.pri = 1
			mgr = 55
		case	c100.pri = 2
			mgr = 60
		case 	c100.pri = 3
			mgr = 56
	endcase 
	
	msort = 0
	msp = 0
	msh = 0
	
	mkod = fpr2(mgr,msort,msp,msh)
	
	select kodm from mater order by kodm into cursor c200
	if reccount()>0
		go bottom 
		mkodm = c200.kodm + 1
	else
		mkodm = 1
	endif
	use in c200
	
	mei = 'רע'
	
	mnaim = c100.im
	
	insert into mater ;
		(gr,sort,sp,sh,kod,kodm,ei,naim);
		values;
		(mgr,msort,msp,msh,mkod,mkodm,mei,mnaim)
		
endscan 
use in c100

close databases 