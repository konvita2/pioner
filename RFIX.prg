*-Rfix-----------------------------------------------------------------------*
* ������ ����� ��ப� (���������� ��� ��ᥪ����) �ࠢ�
Func Rfix
  Para s,l
  s=Alltrim(s)
  If .Not. Empty(s)
    If len(s)>=l
      Return left(s,l)
    Else
      Return s+space(l-len(s))
    EndIf
  Else
    Return space(l)
  EndIf
*-End of Rfix----------------------------------------------------------------*

