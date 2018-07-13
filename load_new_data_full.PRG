close tables all

* made 06-12-07

create cursor cc (nam c(40))

insert into cc (nam) values ('kt')
insert into cc (nam) values ('ww')
insert into cc (nam) values ('nar')
insert into cc (nam) values ('pzt')
insert into cc (nam) values ('newkod')

insert into cc (nam) values ('a_izd')
insert into cc (nam) values ('izd')
insert into cc (nam) values ('nastr')
insert into cc (nam) values ('plancalc')

insert into cc (nam) values ('shwzras')
insert into cc (nam) values ('shwzras02')
insert into cc (nam) values ('dosp')
insert into cc (nam) values ('pz')

insert into cc (nam) values ('wwlim')
insert into cc (nam) values ('te')
insert into cc (nam) values ('usp')
insert into cc (nam) values ('uo')
insert into cc (nam) values ('instr')
insert into cc (nam) values ('press')

insert into cc (nam) values ('ktu')
insert into cc (nam) values ('kto')
insert into cc (nam) values ('tto')
insert into cc (nam) values ('pt')
insert into cc (nam) values ('obor')
insert into cc (nam) values ('limit')

insert into cc (nam) values ('dvigen')
insert into cc (nam) values ('ras')
insert into cc (nam) values ('rast')
insert into cc (nam) values ('ostatok')
insert into cc (nam) values ('kta')

insert into cc (nam) values ('obmen')
insert into cc (nam) values ('ptt')
insert into cc (nam) values ('normmat1')
insert into cc (nam) values ('t1')

insert into cc (nam) values ('shwzimi')
insert into cc (nam) values ('mater')
insert into cc (nam) values ('obmen2')
insert into cc (nam) values ('sprav')

insert into cc (nam) values ('kadry')
insert into cc (nam) values ('normmat')
insert into cc (nam) values ('post')
insert into cc (nam) values ('rd')
insert into cc (nam) values ('tarif')

insert into cc (nam) values ('peo1')
insert into cc (nam) values ('peo2')
insert into cc (nam) values ('555')
insert into cc (nam) values ('mech')
insert into cc (nam) values ('peo')
insert into cc (nam) values ('porez')

insert into cc (nam) values ('porezzak')
insert into cc (nam) values ('pri')
insert into cc (nam) values ('prit')
insert into cc (nam) values ('saldo')
insert into cc (nam) values ('svi')

insert into cc (nam) values ('test')
insert into cc (nam) values ('tttm')
insert into cc (nam) values ('zatraty')
insert into cc (nam) values ('zatrsum')

insert into cc (nam) values ('a_kt')
insert into cc (nam) values ('a_nar')
insert into cc (nam) values ('a_ww')
insert into cc (nam) values ('koop')
insert into cc (nam) values ('ktmodi')

insert into cc (nam) values ('ktsvar')
insert into cc (nam) values ('ostatki')
insert into cc (nam) values ('ostatki1')
insert into cc (nam) values ('raschet1')
insert into cc (nam) values ('raschet')

insert into cc (nam) values ('temodi')
insert into cc (nam) values ('matrast')
insert into cc (nam) values ('techos')
insert into cc (nam) values ('temp')
insert into cc (nam) values ('tmp')

insert into cc (nam) values ('kt_1')
insert into cc (nam) values ('lang')
insert into cc (nam) values ('matras')
insert into cc (nam) values ('kpd')
insert into cc (nam) values ('brut')
insert into cc (nam) values ('kp')

insert into cc (nam) values ('mtto')
insert into cc (nam) values ('normtemp')
insert into cc (nam) values ('ttt')

insert into cc (nam) values ('ktupass')
insert into cc (nam) values ('pttorig')
insert into cc (nam) values ('imit')
insert into cc (nam) values ('tt')

local aa,ind
dimension rr[200]
ind = 1
select cc
scan all
	rr[ind] = alltrim(cc.nam)
	ind = ind+1
endscan

local maxind
maxind = ind-1


for ind=1 to maxind
	aa = rr[ind]

	wait window nowait 'Loading '+aa

	use &aa exclusive in 0
	zap
	aaa = 'z:\gotov\'+aa
	append from &aaa
	use in &aa

endfor

wait window 'ÂÑÅ ÇÀÊÀ×ÀÍÎ!'

use in cc

quit