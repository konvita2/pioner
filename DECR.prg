* pr_psw 	- 	input-output �������� 
*				���� ������������� ������, ���������� ����������
* pr_type	- 	output ��������, ���������� ��� ������������	
* ��������� ������� �������� ������ ����� do ... with
LPARAMETERS pr_psw,pr_type
LOCAL ar1[11],ln1,lc1,lc2,lnLen,lcType

STORE '' TO ar1
m.lnLen = LEN(m.pr_psw)

* ��������� ������ � ������
FOR m.ln1=1 TO m.lnLen
	ar1[m.ln1] = SUBSTR(m.pr_psw,m.ln1,1)
ENDFOR 

* �������������� ������� (��������� ������ ������ �� ����� ������)
FOR m.ln1=1 TO m.lnLen
	ar1[m.ln1] = CHR(ASC(ar1[m.ln1]) - m.lnLen)
ENDFOR 

* �������� � ������� ������ �������, �������� ��� ������������
m.lcType = ar1[1]
FOR m.ln1 = 1 TO m.lnLen-1
	ar1[m.ln1] = ar1[m.ln1+1]
ENDFOR 
m.lnLen = m.lnLen-1

* ����������� �������
FOR m.ln1 = 1 TO 2*INT(m.lnLen / 2) STEP 2
	m.lc1 = ar1[m.ln1] 
	ar1[m.ln1] = ar1[m.ln1+1]
	ar1[m.ln1+1] = m.lc1
ENDFOR 

* ��������� ������ � ������
m.lc2 = ''
FOR m.ln1=1 TO m.lnLen
	m.lc2 = m.lc2 + ar1[m.ln1]
ENDFOR 

* ������� ���������
m.pr_psw = m.lc2
m.pr_type = m.lcType

RETURN 





