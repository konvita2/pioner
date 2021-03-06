* ���������� ��� ���� ������� KT ���� parent

public pgl_level,pgl_porad
local lcMsg,svParent

* ������� ��������
do warn_open with 'preptree.log'
do warn with '�������� ������������ ������ KT'
do warn with '*****************************************'

* �������� ��� �������
select dist kod from izd where kod=23 into cursor cc_izd
scan all
	*wait '��� ������� = '+alltrim(str(cc_izd.kod)) nowait window 
	do warn with '������� ���='+alltrim(str(cc_izd.kod)) 
	
	* ���� ������� � kt
	select * from kt where d_u = 3 and shw = cc_izd.kod into cursor cc_kt
	if reccount()=1
		* �������������� ����������
		m.pgl_level = 0
		m.pgl_porad = 1
		* ����� ������ ������� � kt
		do warn with '�������   ' + cc_kt.poznd + '   ' + cc_kt.naimd 
		update kt set parent = cc_izd.kod*1000000, porad = cc_izd.kod*1000000+m.pgl_porad ;
			where kod = cc_kt.kod		
		m.pgl_porad = m.pgl_porad + 1
		m.svParent = cc_kt.kod
		do open_node with m.svParent, cc_izd.kod		
	else
		if reccount()>1
			do warn with '������! � KT ��� ������ ������� � ����� '+alltrim(str(cc_izd.kod))+' ������� ����� 1 ������ � d_u = 3!'
		else
			do warn with '������! � KT ��� ������� � ����� '+alltrim(str(cc_izd.kod))+' �� ������� �� ����� ������ � d_u = 3!'		
		endif		
	endif 
	use in cc_kt

endscan
use in cc_izd

wait window nowait '������������ ������ ��� ���������.' 

do warn_close
MODIFY command preptree.log

***********************************************
* ��������� ��������� ����
procedure open_node
lparam lprKod, lprShw
local lcCursName,svPoznw,svParent,lcMsg,svKod

	* ���������� �������
	m.pgl_level = m.pgl_level + 1
	
	* �������� ������
	* wait window '��������. ������� ���� �������� 100!'
		
	* ������� ��� �������
	m.lcCursName = 'cct'+alltrim(str(m.pgl_level))
	
	* debug
	* wait '������� '+str(m.lprShw)+'   Level '+allt(str(m.pgl_level)) + '  ' + m.lcCursName nowait wind
	
	* ������� ��� ������
	lcRabota = alltrim(str(100*recno('cc_izd')/reccount('cc_izd')))+'%'
	wait window nowait '����������� ���������������� ������ ���. ��������� '+lcRabota 
		
	* �������� ����������� ����
	select * from kt where kt.kod = m.lprKod into cursor c_707
	if recc() > 0
		m.svPoznw = c_707.poznd
	else
		m.svPoznw = ''		
	endif 
	use in c_707
	
	* ��������� ������������ ���������� ������
	if empty(m.svPoznw)
		wait '������! ��������� ������� �� ������ � ������ ������������ ���� ��� ������ � ��������� ����� �� �������!' wind		
		return to master
	endif
	
	* ���������� ������
	select * from kt where (d_u = 1) and kt.shw = m.lprShw and kt.poznw = m.svPoznw into cursor c_707
	scan all
		* �������� � ��������
		m.lcMsg = '������    ' + c_707.poznd + '  ' + c_707.naimd
		@ prow(),4*m.pgl_level say m.lcMsg
		* �������� � ����		
		update kt set parent = m.lprKod, porad = m.lprShw*1000000+m.pgl_porad where kod = c_707.kod		
		m.pgl_porad = m.pgl_porad+1
	endscan
	use in c_707
	
	* ���������� ����
	select * from kt ;
		where d_u = 2 and kt.shw = m.lprShw and kt.poznw = m.svPoznw and kt.kornw <> kt.kornd ;
		into cursor (m.lcCursName)
	scan all
		scatter memvar
		m.svKod = m.kod
		* �������� � ��������
		m.lcMsg = '�����     ' + m.poznd + '  ' + m.naimd
		@ prow(),4*m.pgl_level say m.lcMsg
		* �������� � ����
		update kt set parent = m.lprKod, porad = m.lprShw*1000000+m.pgl_porad where kod = m.kod
		m.pgl_porad = m.pgl_porad+1
		* �������� ������� ����
		do open_node with m.svKod,m.lprShw		
	endscan	
	use in (m.lcCursName)	
	
	* ��������� �������
	m.pgl_level = m.pgl_level - 1
		
	* (����� ������ �����!)
	return
endproc