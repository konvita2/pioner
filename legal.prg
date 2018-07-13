*** legal
dimension a[1]

*susp

*** legal 1

* wait 'legal 1' wind

select * from izd where kod = 7 and allt(ribf) == 'ДП 1.5.02.00.00-16' into curs c300
if recc() = 0
	quit
endif
use in c300

*** legal 2

* wait 'legal 2' wind

select * from izd into curs c300
if recc() > 80
	quit
endif
use in c300

*** legal 3

* wait 'legal 3' wind

select * from instr where kodi = 5 and im = 'КОЛЬЦО 8211-1036 ГОСТ 17764-72   ' into curs c33
if recc() <> 1
	* quit
endif
use in c33

*** legal 4

* wait 'legal 4' wind

select count(*) from obor where invn = '0000040' and allt(marka) == '1Б61' and vid = 1 into array a
if a[1] <> 1
	quit
endif

*** legal 5

* wait 'legal 5' wind

sele * from dosp where vid = 2 and kod = 1 and allt(im) == 'Склад материалов' into curs c33
if recc() = 0
	quit
endif
use in c33

*** legal 6

* wait 'legal 6' wind

sele max(kodm) from mater where kodm <> 9999 into array a
if a[1] > 1500
	quit
endif

*** legal 7

* wait 'legal 7' wind

sele count(*) from kt into array a
if a[1] > 9000
	quit
endif

*** legal 8

* wait 'legal 8' wind

sele * from mater where kodm = 371 and allt(naim) == 'Крючок NUKON' into curs c33
if recc() = 0
	quit
endif	
use in c33