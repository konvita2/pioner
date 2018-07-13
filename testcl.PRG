set escape on 
set classlib to main_toolbar
local aa as cl_ww
aa = createobject('cl_ww')
*!*	aa.fillbyshwz('750.628.399.061.08')

*!*	aa.buildtree()

local mmm

*!*	aa.selectitems()
*!*	do while aa.getitem()=1
*!*		mmm = aa.seleitem.printkids()
*!*		? aa.seleitem.shwz + ' ' + ;
*!*				aa.seleitem.poznd + ' papa:' + alltrim(aa.seleitem.papa) + ' ' + mmm
*!*				
*!*	enddo

*!*	wait window nowait 'ScanTree' 
*!*	aa.scantree()

local bb as cl_ww_item
bb = createobject('cl_ww_item')
bb.setbykod('1.0','750.628.399.061.08')
bb.selectworks()
do while bb.getwork()=1
	? str(bb.selework.isplanned()) + ' ' + bb.kornd + ' ' + str(bb.selework.nto) 
enddo

? 'For all ' + str(bb.isplanned())

? 0 
? 0
? 0

bb.setsummat()
? 'sum '+str(bb.summat)

? 0
? 0

