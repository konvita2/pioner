* �������� �� ������ ����� ���������� ��� ������ ��� �-�
* �� ��� ��������
* �� ���. � ��� ���� 2 ����� �������� �� ��� �� 2-� �����
* �� ���. � ��� ��� 2-� ����� ������ �������� ���. � (���������)
lparameters parKornd
local mres,mk,mn

mk = parKornd

mn = at('.',mk,2)

if mn <> 0
	mres = left(mk,mn-1)
else
	mres = alltrim(mk)
endif 

return mres