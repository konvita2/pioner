* ��������� ����������� ������������
local lbCont,lcFilter

* ������� ����� �������
do form f_ww_operplan to m.lcFilter

m.lbCont = .t.
* ����
do while m.lbCont
	* ������� ����� ��������� ���������������� ����
	if !empty(m.lcFilter)
		do form f_ww_prosm with 2,m.lcFilter		
		do form f_ww_operplan to m.lcFilter
	else
		m.lbCont = .f.	
	endif	
enddo