* определить является ли участок для данной детали
* последним
lparameters parMar,parPoznd
local mres,mm
mres = .f.
mm = parMar

select * from kt where alltrim(poznd) == alltrim(parPoznd) and !empty(poznd);
	into cursor c99
if reccount()>0
	do	case
		case	c99.mar20 = mm
			mres = .t.
		case	c99.mar20 = 0 .and. c99.mar19 = mm
			mres = .t.
		case	c99.mar19 = 0 .and. c99.mar18 = mm
			mres = .t.
		case	c99.mar18 = 0 .and. c99.mar17 = mm
			mres = .t.
		case	c99.mar17 = 0 .and. c99.mar16 = mm
			mres = .t.
		case	c99.mar16 = 0 .and. c99.mar15 = mm
			mres = .t.
		case	c99.mar15 = 0 .and. c99.mar14 = mm
			mres = .t.
		case	c99.mar14 = 0 .and. c99.mar13 = mm
			mres = .t.
		case	c99.mar13 = 0 .and. c99.mar12 = mm
			mres = .t.
		case	c99.mar12 = 0 .and. c99.mar11 = mm
			mres = .t.
		case	c99.mar11 = 0 .and. c99.mar10 = mm
			mres = .t.
		case	c99.mar10 = 0 .and. c99.mar9  = mm
			mres = .t.
		case	c99.mar9 = 0 .and. c99.mar8  = mm
			mres = .t.
		case	c99.mar8  = 0 .and. c99.mar7 = mm
			mres = .t.
		case	c99.mar7  = 0 .and. c99.mar6  = mm
			mres = .t.
		case	c99.mar6  = 0 .and. c99.mar5  = mm
			mres = .t.
		case	c99.mar5  = 0 .and. c99.mar4  = mm
			mres = .t.
		case	c99.mar4  = 0 .and. c99.mar3  = mm
			mres = .t.
		case	c99.mar3  = 0 .and. c99.mar2  = mm
			mres = .t.
		case	c99.mar2  = 0 .and. c99.mar1  = mm
			mres = .t.		
	endcase 
endif	
use in c99	

return mres