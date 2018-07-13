* процедура для расчета норм расхода материалов
* на деталь
* используется отдельно и из f_kt_vvod
* описание us (parMus)
*	us = 1 лист
*	us = 2  
*	us = 3 
*	us = 4 
*	us = 5 
*	us = 6 
*	us = 7  
*	us = 8  
*	us = 9  
*	us = 10 

lparameters parMode,parRozmA,parRozmB,parKodm,parMus,parNrmd,parMz

local nrmd,mz   	&& results
store 0 to nrmd,mz

local pi
pi = 3.1415

local rasch			&& вид расчета для текущего сортамента ('1' или '2') 
rasch = ''

select * from mater where kodm = parKodm into cursor c_mat
if reccount()>0
	
	select * from db!v_sort where kod = c_mat.sort into cursor c_sort
	if reccount()>0
		rasch = alltrim(c_sort.obor)		
		do	case
			case	rasch == '1'	&& расчет идет через диаметр
				* проверки
				do 	case
					case    parMus >= 3	
						*
						if c_mat.dm = 0
							wait window 'НЕ УКАЗАН ДИАМЕТР МАТЕРИАЛА' 
							return 
						endif
						*
						if c_mat.uv = 0
							wait window 'НЕ УКАЗАН УДЕЛЬНЫЙ ВЕС МАТЕРИАЛА '+str(parKodm) 	
							return 
						endif
				endcase 				
				* расчет
				do	case
					case	parMus = 2
						m.nrmd = 1.02 * pi * c_mat.dm * c_mat.dm * c_mat.uv * (parRozmA + 1.5)/4000000
						m.mz = pi * c_mat.dm * c_mat.dm * c_mat.uv * parRozmA / 4000000
					case	parMus = 3
						m.nrmd = 1.02 * pi * c_mat.dm * c_mat.dm * c_mat.uv * (parRozmA + 5)/4000000
						m.mz = pi * c_mat.dm * c_mat.dm * c_mat.uv * parRozmA / 4000000											
					case	parMus = 4
						m.nrmd = 1.02 * pi * c_mat.dm * c_mat.dm * c_mat.uv * parRozmA / 4000000
						m.mz = pi * c_mat.dm * c_mat.dm * c_mat.uv * parRozmA / 4000000
					case	parMus = 10						
						m.nrmd = 1.02 * pi * c_mat.dm * c_mat.dm * c_mat.uv * (parRozmA + 7)/4000000
						m.mz = pi * c_mat.dm * c_mat.dm * c_mat.uv * parRozmA / 4000000
				endcase 				
			case	rasch == '2'
				* проверки
				if c_mat.ps = 0
					wait window 'НЕ УКАЗАН ВЕС ПОГОННОГО МЕТРА' 	
					return 
				endif				
				* расчет
				do	case
					case	parMus = 2	
						m.nrmd = 1.02 * c_mat.ps * (parRozmA + 1.5)/1000000
						m.mz = c_mat.ps * parRozmA / 1000000												
					case	parMus = 3
						m.nrmd = 1.02 * c_mat.ps * (parRozmA + 5) / 1000000
						m.mz = c_mat.ps * parRozmA / 1000000					
					case	parMus = 4
						m.nrmd = 1.02 * c_mat.ps * parRozmA / 1000000
						m.mz = c_mat.ps * parRozmA / 1000000
					case	parMus = 10
						m.nrmd = 1.02 * c_mat.ps * (parRozmA + 7) / 1000000
						m.mz = c_mat.ps * parRozmA / 1000000
				endcase 
			otherwise
			    do 	case 
					case 	parMus = 1
						m.nrmd = parRozmA * parRozmB * c_mat.tm * c_mat.uv/1000000
						m.mz = parRozma * parRozmb * c_mat.tm * c_mat.uv / 1000000						
					case	parMus = 7
						m.nrmd = (parRozmA + 2*get_shr_by_tm(c_mat.tm)) * (parRozmB + 2*get_shr_by_tm(c_mat.tm)) * c_mat.tm * c_mat.uv/1000000
						m.mz = parRozma * parRozmb * c_mat.tm * c_mat.uv / 1000000	
					case 	parMus = 11
						m.nrmd = 1.02*parRozmA * parRozmB * c_mat.tm * c_mat.uv/1000000
						m.mz = parRozma * parRozmb * c_mat.tm * c_mat.uv / 1000000	
					case 	parMus = 15
						m.nrmd = 1.15 * c_mat.uv * parRozma * parRozmb * c_mat.tm / 10^6
					case	parMus = 16
						m.nrmd = 1.05 * parRozma * parRozmb  / 1000000					
					case	parMus = 17
						m.nrmd = 1.15 * parRozma * parRozmb * c_mat.tm / 10^9																			
				endcase	
		endcase 
	else
		wait window 'Не найден сортамент материала '+str(parKodm)+' '+get_mater(parKodm) 
	endif
	use in c_sort	
else
	wait window 'Не найден материал с кодом '+str(parKodm) 
endif
use in c_mat

parNrmd = m.nrmd
parMz = m.mz

return

* ====================================
* получить ширину реза для us = 7
* (технология КИРОВОГРАД)
function get_shr_by_tm(mtm)
local shr
    do case
        case mtm<10
            shr = 5
        case mtm>=10.and.mtm<16
            shr = 5
        case mtm>=16.and.mtm<20
            shr = 6
        case mtm>=20.and.mtm<30
            shr = 7
        case mtm>=30.and.mtm<40
            shr = 10
        case mtm>=40.and.mtm<50
            shr = 12
        case mtm>=50
            shr = 14
    endcase
    return shr
endfunc  
