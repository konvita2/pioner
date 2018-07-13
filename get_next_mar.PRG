* используется при формировании накладной для пдо
* pshwz 	- shwz для детали
* ppoznd 	- poznd для детали
* pmar 		- mar после которого надо искать следующий
lparameters pshwz,ppoznd,pmar
local res
res = 0

local hh,rr
hh = sqlconnect('sqldb','sa','111')
if hh > 0
	rr = sqlexec(hh,'select * from ww where rtrim(shwz) = rtrim(?m.pshwz) and '+;
			'rtrim(poznd) = rtrim(?m.ppoznd) order by nto')
	if rr = -1
		eodbc('get_next_mar selection')
	endif		

	sqldisconnect(hh)
else
	eodbc('get_next_mar connection')
endif

select * from sqlresult  into cursor cc300
	
locate for mar = pmar 

do while .t.
	do 	case
		case	eof('cc300')
			exit
		case	cc300.mar < 100 .or. cc300.mar = pmar
			skip
		case	cc300.mar <> pmar
			res = cc300.mar
			exit			
	endcase
enddo
	
use in cc300	 

return res