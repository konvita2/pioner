* проверить можно ли редактировать или удалять ЛИМ1 pId
* возвращает 1 или 0
lparameters pId
local hh,rr,sq
local res

res = 0

hh = sqlcn()
if hh > 0
	sq = 'select * from limone where id = ?pId'
	rr = sqlexec(hh,sq,'csq')
	if rr = -1
		eodbc('test_limone')
	else
		select csq
		go top
		if csq.status = 0
			res = 1	
		endif	
	endif	
	sqldisconnect(hh)
else
	eodbc('test_limone conn')
endif

return res