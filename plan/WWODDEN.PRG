* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc wwodden
bdata=day(date())
defi wind w_m from 10,29 to 12,62 double shad colo sche 10
acti wind w_m
*set color to w+/w
set color to n/w,n/g
@ 0,0 say  'Введите число :'
@ 0,17 get bdata
read
rele wind w_m
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
