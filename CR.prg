LPARAMETERS pr_in,pr_type
LOCAL lnLen,res,ln1,lc1,ar1[11]

m.res = ''

* �������� ����� ������
m.lnLen = LEN(m.pr_in)

* ��������� ������
FOR ln1 = 1 TO m.lnLen 
	ar1[m.ln1] = SUBSTR(m.pr_in,m.ln1,1) 
ENDFOR 

* ����������� ������� ������� (�������� �� ��������)
FOR m.ln1 = 1 TO 2*INT(m.lnLen / 2) STEP 2
	m.lc1 = ar1[m.ln1]
	ar1[m.ln1] = ar1[m.ln1+1]
	ar1[m.ln1+1] = m.lc1	
ENDFOR 

* �������� ������ �������� ��� ����� ��� ���� ������������
FOR m.ln1 = m.lnLen+1 TO 2 STEP -1
	ar1[m.ln1] = ar1[m.ln1-1]
ENDFOR 
m.lnLen = m.lnLen+1
ar1[1] = chr(m.pr_type + ASC('0'))

* ��������� ������ ������ �� ����� ������
FOR m.ln1 = 1 TO m.lnLen
	ar1[m.ln1] = CHR(ASC(ar1[m.ln1])+m.lnLen)
ENDFOR  

* ��������� ������ � ������
m.res = ''
FOR m.ln1=1 TO m.lnLen 
	m.res = m.res + ar1[m.ln1]
ENDFOR 

RETURN m.res
 