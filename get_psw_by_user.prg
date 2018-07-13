 * получить пароль по имени пользователя
 lparameters parNam
 local mres
 mres = ''
 
 select * from t1 where alltrim(nam) == alltrim(parNam) into cursor cc33
 if reccount()>0
 	mres = alltrim(cc33.psw)
 endif
 use in cc33
 
 return mres
 