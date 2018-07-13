 * получить доп инф по имени пользователя
 lparameters parNam
 local mres
 mres = ''
 
 select * from t1 where alltrim(nam) == alltrim(parNam) into cursor cc33
 if reccount()>0
 	mres = alltrim(cc33.plus)
 endif
 use in cc33
 
 return mres