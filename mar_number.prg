parameters parPoznd,parMar

local res,svwa
res = 0

svwa = select()

select * from kt where !empty(poznd) and alltrim(poznd) == alltrim(parPoznd);
	 into cursor c_kt
if reccount()>0
	if kt.d_u = 1 
		do	case
			case	c_kt.mar1 = parMar
				res = 1 
			case	c_kt.mar2 = parMar
				res = 2
			case	c_kt.mar3 = parMar
				res = 3				
			case	c_kt.mar4 = parMar
				res = 4
			case	c_kt.mar5 = parMar
				res = 5
			case	c_kt.mar6 = parMar
				res = 6
			case	c_kt.mar7 = parMar
				res = 7						
			case	c_kt.mar8 = parMar
				res = 8
			case	c_kt.mar9 = parMar
				res = 9
			case	c_kt.mar10 = parMar
				res = 10
			otherwise
				res = 1000	
		endcase
	else
		res = 1000
		select c_kt
		scan all
			if c_kt.mar1 <> 0
				do	case
					case	c_kt.mar1 = parMar
						res = 1 
					case	c_kt.mar2 = parMar
						res = 2
					case	c_kt.mar3 = parMar
						res = 3				
					case	c_kt.mar4 = parMar
						res = 4
					case	c_kt.mar5 = parMar
						res = 5
					case	c_kt.mar6 = parMar
						res = 6
					case	c_kt.mar7 = parMar
						res = 7						
					case	c_kt.mar8 = parMar
						res = 8
					case	c_kt.mar9 = parMar
						res = 9
					case	c_kt.mar10 = parMar
						res = 10
					otherwise
						res = 1000	
				endcase
				exit
			endif			
		endscan
	endif
else
	res = 1000
endif	 

select (svwa)

return res