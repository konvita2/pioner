* parlzk - номер лзк
* parlzk1 - подномер лзк
* parkodm - технологический код материала
* parkart - номер складской карточки материала
lparameters parlzk,parlzk1,parkodm,parkart

local res
res = ''

res = str(parlzk,4) + str(parlzk1,2) + str(parkodm,4) + str(parkart,8)
res = strtran(res,' ','0')

return res
