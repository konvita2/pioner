lparameters parShw,parKornd,parPoznd
local mres
mres = 0

select kttp,d_u from kt ;
	where ;
		shw = parShw and;
		kornd = parKornd and;
		poznd = parPoznd;
	into cursor cc11
if reccount()>0
	do 	case
		case	cc11.d_u = 1
			mres = 1
		case	cc11.d_u <> 1 .and. !empty(cc11.kttp) .and. substr(kttp,1,12) = '06024.01290.'  
			mres = 2
		case	cc11.d_u <> 1 .and. !empty(cc11.kttp) .and. substr(kttp,1,12) = '06024.01273.'  
			mres = 3
		case	cc11.d_u <> 1 .and. !empty(cc11.kttp) .and. substr(kttp,1,12) = '06024.01273.'  
			mres = 4
		case	cc11.d_u <> 1 .and. !empty(cc11.kttp) .and. substr(kttp,1,12) = '06024.01900.'  
			mres = 5
		case	cc11.d_u <> 1 .and. !empty(cc11.kttp) .and. substr(kttp,1,12) = '06024.01220.'  
			mres = 6
		case	cc11.d_u <> 1 .and. !empty(cc11.kttp) .and. substr(kttp,1,12) = '06024.01230.'  
			mres = 7
		case	cc11.d_u <> 1 .and. !empty(cc11.kttp) .and. substr(kttp,1,12) = '06024.01260.'  
			mres = 8
	endcase 
endif	
use in cc11		

return mres
