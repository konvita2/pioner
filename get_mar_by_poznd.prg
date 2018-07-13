lparameters parPoznd
local svWA,res
res = ''

svWA = select(0)

select * from kt where alltrim(poznd)==alltrim(parPoznd) ;
	into cursor c500
scan all
	if c500.mar1 > 0 .or. c500.mar1 = 0 .and. c500.mar2 <> 0
		res = alltrim(str(c500.mar1))
		if c500.mar2<>0 .or. c500.mar2 = 0 .and. c500.mar3 <> 0
			res = res + '-' + alltrim(str(c500.mar2))
			if c500.mar3<>0 .or. c500.mar3 = 0 .and. c500.mar4 <> 0
				res = res + '-' + alltrim(str(c500.mar3))
				if c500.mar4<>0 .or. c500.mar4 = 0 .and. c500.mar5 <> 0
					res = res + '-' + alltrim(str(c500.mar4))
					if c500.mar5<>0 .or. c500.mar5 = 0 .and. c500.mar6 <> 0
						res = res + '-' + alltrim(str(c500.mar5))
						if c500.mar6<>0 .or. c500.mar6 = 0 .and. c500.mar7 <> 0
							res = res + '-' + alltrim(str(c500.mar6))
							if c500.mar7<>0 .or. c500.mar7 = 0 .and. c500.mar8 <> 0
								res = res + '-' + alltrim(str(c500.mar7))
								if c500.mar8<>0 .or. c500.mar8 = 0 .and. c500.mar9 <> 0
									res = res + '-' + alltrim(str(c500.mar8))
									if c500.mar9<>0 .or. c500.mar9 = 0 .and. c500.mar10 <> 0
										res = res + '-' + alltrim(str(c500.mar9))
										if c500.mar10<>0 .or. c500.mar10=0 .and. c500.mar11 <> 0
											res = res + '-' + alltrim(str(c500.mar10))			
											if c500.mar11 <> 0 .or. c500.mar11 = 0 .and. c500.mar12 <> 0
												res = res + '-' +alltrim(str(c500.mar11))
												if c500.mar12<>0 .or. c500.mar12=0 .and. c500.mar13<>0
													res = res + '-' + alltrim(str(c500.mar12))
													if c500.mar13<>0 .or. c500.mar13=0 .and. c500.mar14<>0
														res = res + '-' + alltrim(str(c500.mar13))
														if c500.mar14<>0 .or. c500.mar14=0 .and. c500.mar15<>0
															res = res + '-' + alltrim(str(c500.mar14))
															if c500.mar15<>0 .or. c500.mar15=0 .and. c500.mar16 <> 0 
																res = res + '-' + alltrim(str(c500.mar15))
																if c500.mar16<>0 .or. c500.mar16=0 .and. c500.mar17<>0
																	res = res + '-' + alltrim(str(c500.mar16))
																	if c500.mar17<>0 .or. c500.mar17=0 .and. c500.mar18<>0
																		res = res + '-' + alltrim(str(c500.mar17))
																		if c500.mar18<>0 .or. c500.mar18=0 .and. c500.mar19<>0
																			res = res + '-' + alltrim(str(c500.mar18))
																			if c500.mar19<>0 .or. c500.mar19=0 .and. c500.mar20<>0
																				res = res + '-' + alltrim(str(c500.mar19))
																				if c500.mar20<>0
																					res = res + '-' + alltrim(str(c500.mar20))
																				endif
																			endif																			
																		endif																		
																	endif																	
																endif																															
															endif
														endif	
													endif
												endif
											endif								
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