local hh
hh = sqlconnect('sqldb','sa','111')

local ps,pd
ps = 0
pd = dtot(date(2007,12,8))

res = sqlexec(hh,'exec my_get_full_ostatok ?ps,?pd')
? res
select sqlresult
browse