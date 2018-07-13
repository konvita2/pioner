local pvid,pim,psim,pus,pobor,ppkod
local hh

ppkod = -1

pvid = 21
pim = 'test'
psim = 'sim test'
pus = 34
pobor = 'testobor'

hh = sqlconnect('sqldb','sa','111')
sqlexec(hh,'exec my_add_dosp ?pvid,?pim,?psim,?pus,?pobor,?@ppkod')

? ppkod

sqldisconnect(hh)