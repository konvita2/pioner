* ��������� ��� ��������� ����� parent � kt
* ��������� ��� ������� (shw) � ���� model = 1
lparam lprShw
* ������� ��������� ����������
public pgl_level, pgl_porad
local lcMsg,svParent

* ������� ���� ���������
set device to print
set print to result_tree.txt
@ prow(),0 say "�������� ������������ ������ � kt"

* �������� �������
update kt set porad = 0 where shw = m.lprShw 

* �������������� ��������� ����������
m.pgl_level = 0
m.pgl_porad = 1

* ���� ������ � kt
select * from kt where kod_model = 1 and d_u = 4 into cursor c_706
if recc() = 1
	m.lcMsg = '������    ' + c_706.poznd + '  ' + c_706.naimd
	@ prow(),0 say m.lcMsg
	update kt set parent = 0, porad = m.pgl_porad where kod = c_706.kod
	m.pgl_porad = m.pgl_porad + 1
	m.svParent = c_706.kod
else
	if recc() = 0
		wait "������! � kt �� ������� ������ ������" nowait wind
		use in c_706
		return
	else
		wait "������! � kt ������� ��� ������ � �������. ����� �����?" nowait wind
		use in c_706
		return
	endif	
endif
use in c_706

* ���� ������� � kt
m.pgl_level = m.pgl_level + 1
select * from kt where d_u = 3 and shw = m.lprShw into cursor c_706
if recc() > 0
	m.lcMsg = '�������   ' + c_706.poznd + '  ' + c_706.naimd
	@ prow(),4*m.pgl_level say m.lcMsg
	update kt set parent = m.svParent, porad = m.lprShw*1000000+m.pgl_porad where kod = c_706.kod
	m.pgl_porad = m.pgl_porad+1
	m.svParent = c_706.kod
	do open_node with m.svParent, m.lprShw
else
	wait "������! �� ������� ������� ��� ������ = 1" wind 
	use in c_706
	return
endif
use in c_706

* ������� ���� ��������� �� �����
set print to
set device to screen
modi file result_tree.txt

* ������� ��������� ���������� (?) 
release pgl_level, pgl_porad

***********************************************
***********************************************
* ��������� ��������� ����
procedure open_node
lparam lprKod, lprShw
local lcCursName,svPoznw,svParent,lcMsg,svKod

	* ���������� �������
	m.pgl_level = m.pgl_level + 1
		
	* ������� ��� �������
	m.lcCursName = 'cct'+alltrim(str(m.pgl_level))
	
	* debug
	wait 'Level '+allt(str(m.pgl_level)) + '  ' + m.lcCursName nowait wind
		
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
	select * from kt where d_u = 1 and kt.shw = m.lprShw and kt.poznw = m.svPoznw into cursor c_707
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