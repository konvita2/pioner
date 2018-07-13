lparameters parPoznd
local svWA,res,lenn
res = ''
lenn=2

svWA = select(0)
 
select * from kt where alltrim(poznd)==alltrim(parPoznd) ;
	into cursor c500
scan all
	if c500.mar1 > 0 .or. c500.mar1 = 0 .and. c500.mar2 > 0 
		res = get_short_mar1(c500.mar1)
		if c500.mar2<>0 .or. c500.mar2=0 .and. c500.mar3>0
			res = res + space(lenn) + get_short_mar1(c500.mar2)
			if c500.mar3<>0 .or. c500.mar3=0 .and. c500.mar4>0
				res = res + space(lenn) + get_short_mar1(c500.mar3)
				if c500.mar4<>0 .or. c500.mar4=0 .and. c500.mar5>0
					res = res + space(lenn) + get_short_mar1(c500.mar4)
					if c500.mar5<>0 .or. c500.mar5=0 .and. c500.mar6>0
						res = res + space(lenn) + get_short_mar1(c500.mar5)
						if c500.mar6<>0 .or. c500.mar6=0 .and. c500.mar7>0
							res = res + space(lenn) + get_short_mar1(c500.mar6)
							if c500.mar7<>0 .or. c500.mar7=0 .and. c500.mar8>0
								res = res + space(lenn) + get_short_mar1(c500.mar7)
								if c500.mar8<>0 .or. c500.mar8=0 .and. c500.mar9>0
									res = res + space(lenn) + get_short_mar1(c500.mar8)
									if c500.mar9<>0 .or. c500.mar9=0 .and. c500.mar10>0
										res = res + space(lenn) + get_short_mar1(c500.mar9)
										if c500.mar10<>0
											res = res + space(lenn) + get_short_mar1(c500.mar10)
										endif
									endif
								endif
							endif
						endif
					endif
				endif
			endif
		endif
		exit
	endif
endscan 	
use in c500	

select (svWA)

return res