
local cc

cc = inputbox('Введите марку оборудования:','ПОИСК')

if !empty(cc)
	select v_oborspr
	locate for at(upper(alltrim(cc)),upper(v_oborspr.marka))<>0
	
endif
deactivate popup pp

 