* ============================================
* сформировать строку дл€ указани€ размера в
* виде 2000 (-0.01) x 3000 (-0.11)
* 	   parRa parTa    parRb parTb
* ============================================
lparameters parRa,parRb,parTa,parTb
local mres

mres = ''

if parRa=0 .and. parRb=0
	mres = ''
endif

if parRa<>0 .and. parRb=0
	if parTa = 0 
		mres = alltrim(str(parRa))
	else
		mres = alltrim(str(parRa))+' (-'+alltrim(str(parTa,4,2))+')'
	endif	
endif

if parRa<>0 .and. parRb<>0
	if parTa=0 .and. parTb=0
		mres = alltrim(str(parRa))+' x '+alltrim(str(parRb))
	endif
	
	if parTa<>0 .and. parTb=0
		mres = alltrim(str(parRa))+' (-'+alltrim(str(parTa,4,2))+') x '+alltrim(str(parRb))
	endif
	
	if parTa=0 .and. parTb<>0
		mres = alltrim(str(parRa)) + ' x ' + alltrim(str(parRb)) + ' (-' + alltrim(str(parTb,4,2))+')'
	endif
	
	if parTa<>0 .and. parTb<>0
		mres = alltrim(str(parRa))+' (-'+alltrim(str(parTb,4,2))+') x  '+alltrim(str(parRb))+' (-'+alltrim(str(parTb,4,2))+')'
	endif
endif

return mres 

