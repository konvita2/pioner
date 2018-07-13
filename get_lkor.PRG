* получить левую часть короткого номера
* нр: 13.3.1 - .3.1
*     14.5 - .5
lparameters pars
local res,pos

res = ''
pos = at('.',pars)
res = substr(pars,pos)

return res