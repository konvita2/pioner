* pr_psw 	- 	input-output параметр 
*				даем зашифрованный пароль, возвращаем нормальный
* pr_type	- 	output параметр, возвращает тип пользователя	
* процедуру следует вызывать только через do ... with
LPARAMETERS pr_psw,pr_type
LOCAL ar1[11],ln1,lc1,lc2,lnLen,lcType

STORE '' TO ar1
m.lnLen = LEN(m.pr_psw)

* перегнать строку в массив
FOR m.ln1=1 TO m.lnLen
	ar1[m.ln1] = SUBSTR(m.pr_psw,m.ln1,1)
ENDFOR 

* перекодировать символы (уменьшить каждый символ на длину пароля)
FOR m.ln1=1 TO m.lnLen
	ar1[m.ln1] = CHR(ASC(ar1[m.ln1]) - m.lnLen)
ENDFOR 

* выделить и удалить первый элемент, получить тип пользователя
m.lcType = ar1[1]
FOR m.ln1 = 1 TO m.lnLen-1
	ar1[m.ln1] = ar1[m.ln1+1]
ENDFOR 
m.lnLen = m.lnLen-1

* переставить символы
FOR m.ln1 = 1 TO 2*INT(m.lnLen / 2) STEP 2
	m.lc1 = ar1[m.ln1] 
	ar1[m.ln1] = ar1[m.ln1+1]
	ar1[m.ln1+1] = m.lc1
ENDFOR 

* перегнать массив в строку
m.lc2 = ''
FOR m.ln1=1 TO m.lnLen
	m.lc2 = m.lc2 + ar1[m.ln1]
ENDFOR 

* вернуть параметры
m.pr_psw = m.lc2
m.pr_type = m.lcType

RETURN 





