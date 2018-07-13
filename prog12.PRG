select * from ww into cursor cc
scan all
	
	select * from nar where alltrim(poznd) == alltrim(cc.poznd) into cursor cc10
	if reccount()=0
		update ww set nozap = -1 where nozap = cc.nozap	
	
	endif
	use in cc10

endscan
use in cc