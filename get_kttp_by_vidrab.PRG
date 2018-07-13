* получить kttp по коду vidrab
lparameters parV
local res
res = ''

do	case
	case	parV = 1
		res = '06024.55241'
		
	case	parV = 2
		res = '06024.55290'
		
	case	parV = 3
		res = '06024.55273'	
		
	case	parV = 4
		res = '06024.01271'
		
	case	parV = 5
		res = '06024.55288'
		
	case	parV = 6
		res = '06024.55220'
		
	case	parV = 7
		res = '06024.55285'
		
	case	parV = 8
		res = '06024.55206'
	
	case	parV = 10
		res = '06024.55201'
	
	case	parV = 11
		res = '06024.55281'
	
	case	parV = 12
		res = '06024.55204'
	
	case	parV = 13
		res = '06024.55360'
	
	case	parV = 14
		res = '06024.55250'	
endcase 

return res
