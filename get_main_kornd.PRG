* название не совсем точно отображает что делает эта ф-я
* но нет фантазии
* из кор. № где есть 2 точки вырезает то что до 2-й точки
* из кор. № где нет 2-й точки просто выбирает кор. № (тримнутый)
lparameters parKornd
local mres,mk,mn

mk = parKornd

mn = at('.',mk,2)

if mn <> 0
	mres = left(mk,mn-1)
else
	mres = alltrim(mk)
endif 

return mres