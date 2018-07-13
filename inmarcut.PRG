* по коду записи в kt находим запись
* проверяем наличие участка в маршруте этой записи (отдельный случай - узлы)
* на берем во внимание участки находящиеся после 0
* возвращает .t. or .f.
lparameters parKod,parMar
local mres,mm

mm = parMar
mres = .f.

*select * from kt where kod = parKod into cursor cc55
local hh,rr
hh = sqlconnect('sqldb','sa','111')
if hh > 0
	rr = sqlexec(hh,'select * from kt where kod=?parkod','cc55')
	if rr = -1
		eodbc('inmarcut sele')
	endif
	sqldisconnect(hh)
else
	eodbc('inmarcur conn')
endif
release hh,rr

if reccount()>0
	if cc55.mar1 = mm
		mres = .t.
	else
		if cc55.mar1 <> 0
			if cc55.mar2 = mm
				mres = .t.				
			else
				if cc55.mar2 <> 0
					if cc55.mar3 = mm
						mres = .t.
					else
						if cc55.mar3 <> 0
							if cc55.mar4 = mm
								mres = .t.
							else
								if cc55.mar4 <> 0
									if cc55.mar5 = mm
										mres = .t.
									else
										if cc55.mar5 <> 0
											if cc55.mar6 = mm										
												mres = .t.
											else
												if cc55.mar6 <> 0
													if cc55.mar7 = mm
														mres = .t.
													else
														if cc55.mar7 <> 0
															if cc55.mar8 = mm
																mres = .t.
															else
																if cc55.mar8 <> 0
																	if cc55.mar9 = mm
																		mres = .t.	
																	else
																		if cc55.mar9 <> 0
																			if cc55.mar10 = mm
																				mres = .t.
																			else
																				if cc55.mar10 <> 0
																					if cc55.mar11 = mm
																						mres = .t.	
																					else
																						if cc55.mar11 <> 0
																							if cc55.mar12 = mm
																								mres = .t.
																							else	
																								if cc55.mar12 <> 0
																									if cc55.mar13 = mm
																										mres = .t.
																									else
																										if cc55.mar13 <> 0
																											if cc55.mar14 = mm
																												mres = .t.
																											else	
																												if cc55.mar14 <> 0
																													if cc55.mar15 = mm
																														mres = .t.
																													else
																														if cc55.mar15 <> 0
																															if cc55.mar16 = mm																														
																																mres = .t.						
																															else
																																if cc55.mar16 <> 0
																																	if cc55.mar17 = mm
																																		mres = .t.
																																	else
																																		if cc55.mar17 <> 0
																																			if cc55.mar18 = mm
																																				mres = .t.
																																			else
																																				if cc55.mar18 <> 0
																																					if cc55.mar19 = mm
																																						mres = .t.
																																					else
																																						if cc55.mar19 <> 0
																																							if cc55.mar20 = mm
																																								mres = .t.
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
	endif
endif

use in cc55
return mres
  