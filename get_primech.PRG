* ================================================
* ������������� ���������
* ������ ������� ��� ��������� �� ����
lparameters parKodzag
local mres

mres = ''

select * from db!v_dosp56 where kod = parKodzag and kod <> 1 into cursor c108
if reccount()>0
	mres = c108.im
endif
use in c108

return mres


*!*	* ============================================
*!*	* ������������ ��� ����������
*!*	* ������� ����� '��.������' ���
*!*	* �������� ����� ��������� (��� ��������)
*!*	lparameters parKodzag
*!*	local mres

*!*	mres = ''

*!*	select * from db!v_dosp56 where kod = parKodzag into cursor cc11
*!*	if reccount()>0
*!*		if cc11.us = 1
*!*			mres = '��.������'
*!*		endif
*!*	endif
*!*	use in cc11

*!*	return mres


 