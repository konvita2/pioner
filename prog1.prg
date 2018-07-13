select * from ww into cursor c_ww
scan all
	select * from obor where alltrim(marka) == alltrim(c_ww.kodo) into cursor c100
	if reccount()>0
		update ww set ;
			invn = c100.invn ;
			where nozap = c_ww.nozap
	endif
	use in c100
endscan
use in c_ww