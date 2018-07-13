*-MesWin---------------------------------------------------------------------*
* ����� ������ ��������� � ���� � �������� ������� ����� �������.
* ���������: tit - ��������� ���� ������;
             mes - ������ ���������.
Proc MesWin
  Para tit,mes
  set cursor off
  winlen=4+len(mes)
  If winlen<20
    winlen=20
  EndIf
  midlen=(winlen-(winlen%2))/2
  c=38-midlen
  defi wind MW from 7,c to 11,c+winlen-1 title tit shadow color n/w,w+/w,w+/w
  acti wind MW
  @ 1, 1 say mes
  Key=Inkey(0)
  Deactivate window MW
  Release window MW
retu
*-End of MesWin--------------------------------------------------------------*

*-ErrWin---------------------------------------------------------------------*
* ����� ������ ��������� �� ������ � ���� � �������� ������� ����� �������.
* ���������: tit - ��������� ���� ������;
             mes - ������ ���������.
Proc ErrWin
  Para tit,mes
  set color of Titles to w+/r
  set cursor off
  winlen=4+len(mes)
  If winlen<20
    winlen=20
  EndIf
  midlen=(winlen-(winlen%2))/2
  c=38-midlen
  defi wind EW from 7,c to 11,c+winlen-1 title tit shadow color gr+/r,w+/r,w+/r
  acti wind EW
  @ 1, 1 say mes
  Key=Inkey(0)
  Deactivate window EW
  Release window EW
  set color of Titles to w+/w
retu
*-End of ErrWin--------------------------------------------------------------*

*-GetTime--------------------------------------------------------------------*
Func GetTime
  Para Row,Col,StrTim
  Private S
  S=StrTim
  If IsTime(StrTim)
    On Escape S=StrTim
    @ Row,Col Say S Color w+/bg
    Do While .t.
      set cursor on
      @ Row,Col Get S Picture '99:99:99' Color w+/b
      Read
      If IsTime(S)
        Exit
      Else
        Do ErrWin With '������','�� ����� ������� �����.'
      EndIf
    EndDo
    set cursor off
    @ Row,Col Say S Color w+/bg
    On Escape
  Else
    Do ErrWin With '������','�� ����� ������� �����.'
  EndIf
Return S
*-End of GetTime-------------------------------------------------------------*

*-TimeSec--------------------------------------------------------------------*
* ���������� ����� S � ��������.
* S - ������ ������� � ������� hh:mm:ss
* �������� TimeSec('07:45:23') ��������� 27923,
* �.�. 7*3600+45*60+23=27923
Func TimeSec
  Para StrTim
  Private S
  S=AllTrim(StrTim)
  If IsTime(S)
    Return Val(Left(S,2))*3600+Val(SubStr(S,4,2))*60+Val(Right(S,2))
  Else
    Return 0
  EndIf
*-End of TimeSec-------------------------------------------------------------*

*-TimeMin--------------------------------------------------------------------*
* ���������� ����� S � �������.
* S - ������ ������� � ������� hh:mm:ss
* �������� TimeMin('07:45:23') ��������� 465.38,
* �.�. (7*3600+45*60+23)/60=465.38
Func TimeMin
  Para StrTim
  Private S
  S=AllTrim(StrTim)
  If IsTime(S)
    Return ((Val(Left(S,2))*3600+Val(SubStr(S,4,2))*60+Val(Right(S,2)))/60)
  Else
    Return 0
  EndIf
*-End of TimeMin-------------------------------------------------------------*

*-TimeHou--------------------------------------------------------------------*
* ���������� ����� S � �����.
* S - ������ ������� � ������� hh:mm:ss
* �������� TimeSec('07:45:23') ��������� 7.76,
* �.�. (7*3600+45*60+23)/3600=7.76
Func TimeHou
  Para StrTim
  Private S
  S=AllTrim(StrTim)
  If IsTime(S)
    Return ((Val(Left(S,2))*3600+Val(SubStr(S,4,2))*60+Val(Right(S,2)))/3600)
  Else
    Return 0
  EndIf
*-End of TimeHou-------------------------------------------------------------*

*-IsTime---------------------------------------------------------------------*
Func IsTime
  Para StrTim
  Private S
  S=Alltrim(StrTim)
  If (Substr(S,3,1)=':').And.(Substr(S,6,1)=':')
    If Len(S)=8
      Hou=Val(Left(S,2))
      Min=Val(Substr(S,4,2))
      Sec=Val(Right(S,2))
      If (Hou>=0).And.(Hou<=23).And.(Min>=0).And.(Min<=59).And.(Sec>=0).And.(Sec<=59)
        Return .T.
      Else
        Return .F.
      EndIf
    Else
      Return .F.
    EndIf
  Else
    Return .F.
  EndIf
*-End of IsTime--------------------------------------------------------------*

*-Rfix-----------------------------------------------------------------------*
* �������� ����� ������ (���������� ��� ���������) ������
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

*-Lfix-----------------------------------------------------------------------*
* �������� ����� ������ (���������� ��� ���������) �����
Func Lfix
  Para s,l
  s=Alltrim(s)
  If .Not. Empty(s)
    If len(s)>=l
      Return left(s,l)
    Else
      Return space(l-len(s))+s
    EndIf
  Else
    Return space(l)
  EndIf
*-End of Lfix----------------------------------------------------------------*

*-GetYesNo()-------------------------------------*
* ������� ��������� �� ��������� ������ "��" ��� "���"
Function GetYesNo
  Para tit,mes
  Pause=2000    && �������� ������� ������
  YesNo='No'
  winlen=4+len(mes)
  If winlen<20
    winlen=20
  EndIf
  midlen=(winlen-(winlen%2))/2
  c=38-midlen
  defi wind MW from 8,c to 14,c+winlen-1 title tit shadow color n/w,w+/w,w+/w,w+/w
  acti wind MW
  @ 1, 1 say mes
  @ 3, midlen-8  prompt ' �� '
  @ 3, midlen+1  prompt ' ��� '
  @ 3, midlen-4  say     '�'      colo n/w
  @ 4, midlen-8  say ' ����'      colo n/w
  @ 3, midlen+6  say      '�'     colo n/w
  @ 4, midlen+1  say ' �����'     colo n/w
  menu to OKout
  Do Case
    Case OKout=1
      @ 3,midlen-8 clear to 4,midlen-4
      iii=1
      do while iii<Pause
        @ 3, midlen-7 say ' �� '
        iii=iii+1
      enddo
      @ 3,midlen-8 clear to 4,midlen-4
      @ 3, midlen-4  say     '�'  colo n/w
      @ 4, midlen-8  say ' ����'  colo n/w
      do while iii<Pause*2
        @ 3, midlen-8 say ' �� '
        iii=iii+1
      enddo
      YesNo='Yes'
    Case OKout=2
      @ 3,midlen+1 clear to 4,midlen+6
      iii=1
      do while iii<Pause
        @ 3, midlen+2 say ' ��� '
        iii=iii+1
      enddo
      @ 3,midlen+1 clear to 4,midlen+6
      @ 3, midlen+6 say      '�'  colo n/w
      @ 4, midlen+1 say ' �����'  colo n/w
      do while iii<Pause*2
        @ 3, midlen+1 say ' ��� '
        iii=iii+1
      enddo
      YesNo='No'
  EndCase
  deac wind MW
  Release tit,mes,winlen,midlen
  Release window MW
retu YesNo
*-End of GetYesNo()------------------------------*

*-GetYesNoRed()----------------------------------*
* ������� ��������� �� ��������� ������ "��" ��� "���"
* �� ������� ����
Function GetYesNoRed
  Para tit,mes
  Pause=2000    && �������� ������� ������
  YesNo='No'
  winlen=4+len(mes)
  If winlen<20
    winlen=20
  EndIf
  midlen=(winlen-(winlen%2))/2
  c=38-midlen
  defi wind MW from 8,c to 14,c+winlen-1 title tit shadow color gr+/r,w+/w,w+/r,w+/r
  acti wind MW
  @ 1, 1 say mes
  @ 3, midlen-8  prompt ' �� '
  @ 3, midlen+1  prompt ' ��� '
  @ 3, midlen-4  say     '�'      colo n/r
  @ 4, midlen-8  say ' ����'      colo n/r
  @ 3, midlen+6  say      '�'     colo n/r
  @ 4, midlen+1  say ' �����'     colo n/r
  menu to OKout
  Do Case
    Case OKout=1
      @ 3,midlen-8 clear to 4,midlen-4
      iii=1
      do while iii<Pause
        @ 3, midlen-7 say ' �� '
        iii=iii+1
      enddo
      @ 3,midlen-8 clear to 4,midlen-4
      @ 3, midlen-4  say     '�'  colo n/r
      @ 4, midlen-8  say ' ����'  colo n/r
      do while iii<Pause*2
        @ 3, midlen-8 say ' �� '
        iii=iii+1
      enddo
      YesNo='Yes'
    Case OKout=2
      @ 3,midlen+1 clear to 4,midlen+6
      iii=1
      do while iii<Pause
        @ 3, midlen+2 say ' ��� '
        iii=iii+1
      enddo
      @ 3,midlen+1 clear to 4,midlen+6
      @ 3, midlen+6 say      '�'  colo n/r
      @ 4, midlen+1 say ' �����'  colo n/r
      do while iii<Pause*2
        @ 3, midlen+1 say ' ��� '
        iii=iii+1
      enddo
      YesNo='No'
  EndCase
  deac wind MW
  Release tit,mes,winlen,midlen
  Release window MW
retu YesNo
*-End of GetYesNoRed()---------------------------*

*-PutMes-----------------------------------------*
* ����� ��������� � ���� ��� ������ � ����������� row,col
* ��� ������������� ���������� � ������ ���������
* ����� ������� � ���� �� 1 �� 3 �����.
* ���� ����� < 3, �� ������ ������ ���� ���������� ('').
* �������� � ���� � ClearMes.
Proc PutMes
  Para row,col,wintag,tit,mes1,mes2,mes3  && ��� ���������� ���������; wintag - ����������.
  *  ���� ������ ������� 70 ��������, �� �������� �� ������ �� 70-� ������
  If len(mes1)>70
    mes1=left(mes1,70)
  EndIf
  If len(mes2)>70
    mes2=left(mes2,70)
  EndIf
  If len(mes3)>70
    mes3=left(mes3,70)
  EndIf
  * ���������� ����� ������� ������ �� ����
  If len(mes1)>len(mes2)
    length=len(mes1)
  Else
    length=len(mes2)
  EndIf
  If len(mes3)>length
    length=len(mes3)
  EndIf
  * ����������� ������ ����
  winlen=4+length
  If winlen<20
    winlen=20
  EndIf
  * ����������� ������ ����
  wr=row+4
  If .Not. Empty(Alltrim(mes2))
    wr=wr+1
  EndIf
  If .Not. Empty(Alltrim(mes3))
    wr=wr+1
  EndIf
  * ����������� ����
  defi wind &wintag from row,col to wr,col+winlen-1 title tit double shadow color n/w,gr+/b,w+/w,w+/w
  acti wind &wintag
  r=1
  * ����� ���������
  @ r, 1 say mes1
  If .Not. Empty(mes2)
    r=r+1
    @ r, 1 say mes2
  EndIf
  If .Not. Empty(mes3)
    r=r+1
    @ r, 1 say mes3
  EndIf
retu
*-End of PutMes----------------------------------*

*-PutMesCnt--------------------------------------*
* ����� ��������� � ���� ��� ������ �� ������ ������
* ��� ������������� ���������� � ������ ���������
* ����� ������� � ���� �� 1 �� 3 �����.
* ���� ����� < 3, �� ������ ������ ���� ���������� ('').
* �������� � ���� � ClearMes.
Proc PutMesCnt
  Para wintag,tit,mes1,mes2,mes3  && ��� ���������� ���������; wintag - ����������.
  *  ���� ������ ������� 70 ��������, �� �������� �� ������ �� 70-� ������
  If len(mes1)>70
    mes1=left(mes1,70)
  EndIf
  If len(mes2)>70
    mes2=left(mes2,70)
  EndIf
  If len(mes3)>70
    mes3=left(mes3,70)
  EndIf
  * ���������� ����� ������� ������ �� ����
  If len(mes1)>len(mes2)
    length=len(mes1)
  Else
    length=len(mes2)
  EndIf
  If len(mes3)>length
    length=len(mes3)
  EndIf
  * ����������� ������ ����
  winlen=4+length
  If winlen<20
    winlen=20
  EndIf
  midlen=(winlen-(winlen%2))/2
  * ����������� ������� ������ ���������
  c=38-midlen
  * ����������� ������ ����
  wr=12
  If .Not. Empty(Alltrim(mes2))
    wr=wr+1
  EndIf
  If .Not. Empty(Alltrim(mes3))
    wr=wr+1
  EndIf
  * ����������� ����
  defi wind &wintag from 8,c to wr,c+winlen-1 title tit double shadow color n/w,gr+/b,w+/w,w+/w
  acti wind &wintag
  r=1
  * ����� ���������
  @ r, 1 say mes1
  If .Not. Empty(mes2)
    r=r+1
    @ r, 1 say mes2
  EndIf
  If .Not. Empty(mes3)
    r=r+1
    @ r, 1 say mes3
  EndIf
retu
*-End of PutMesCnt-------------------------------*

*-ClearMes---------------------------------------*
* �������� ���� � ����������
* �������� � ���� � PutMes � PutMesCnt.
Proc ClearMes
  Para wintag       && ��������� ���������
  deac wind &wintag
  Release &wintag
retu
*-End of ClearMes--------------------------------*

*-RunAnswer------------------------------------------------------------------*
* ����������� ������ ����� ������ � ����� �������� ����,
* �������� ' ������ ',' �������� ',' ������ ' � ���������� �����
* ���������� ������ (�� Escape ������������� 0).
Function RunAnswer
  Para Row1,Prompt1,Prompt2,Prompt3
  Private Row1,Col1,Row2,Col2
  Row2=Row1+3
  Col1=38-Div(Len(Prompt1+Prompt2+Prompt3)+6,2)
  Col2=Col1+Len(Prompt1+Prompt2+Prompt3)+7+1
  Defi Wind RAW From Row1,Col1 To Row2,Col2 Shadow Close Colo w+/w,n/w
  Acti Wind RAW
  Do PromptButton With 0,1,Prompt1,'n/w'
  Do PromptButton With 0,Len(Prompt1)+3,Prompt2,'n/w'
  Do PromptButton With 0,Len(Prompt1)+3+Len(Prompt2)+2,Prompt3,'n/w'
  Menu To mRAW
  Do Case
    Case mRAW=1
      Do PushButton With 0,1,Prompt1,'n/g','n/w'
    Case mRAW=2
      Do PushButton With 0,Len(Prompt1)+3,Prompt2,'n/g','n/w'
    Case mRAW=3
      Do PushButton With 0,Len(Prompt1)+3+Len(Prompt2)+2,Prompt3,'n/g','n/w'
  EndCase
  Deac Wind RAW
Return mRAW
*-End of RunAnswer-----------------------------------------------------------*

*-PromptButton---------------------------------------------------------------*
* ��������� ������. �������� ����� ��� Prompt, �� �������������� ����
* � ���������� ������.
* Row,Col - ���������� ������ ������;
* PromptStr - ������ ������;
* Co - ���� ����.
Proc PromptButton
  Para R,C,PromptStr,Co
  @ R,C Prompt PromptStr
  @ R,C+Len(PromptStr) Say '�' Colo &Co
  @ R+1,C+1 Say Repl('�',Len(PromptStr)) Colo &Co
Return
*-End of PromptButton--------------------------------------------------------*

*-PushButton-----------------------------------------------------------------*
* ������� ������. �������� ���������� �� Prompt � ������ ���������
* ������� ������ (������ ������).
* Row,Col - ���������� ������ ������;
* PromptStr - ������ ������;
* Co1 - ���� ������;
* Co2 - ���� ����.
Proc PushButton
  Para Row,Col,PromptStr,Co1,Co2
  @ Row,Col Clear To Row+1,Col+Len(PromptStr)+1
  @ Row,Col+1 Say PromptStr Colo &Co1
  =InKey(0.05)
  @ Row,Col Clear To Row+1,Col+Len(PromptStr)+1
  @ Row,Col Say PromptStr Colo &Co1
  @ Row,Col+Len(PromptStr) Say '�' Colo &Co2
  @ Row+1,Col+1 Say Repl('�',Len(PromptStr)) Colo &Co2
  =InKey(0.2)
Return
*-End of PushButton----------------------------------------------------------*

*-MenuButton-----------------------------------------------------------------*
* ��������� ������. �������� ����� ��� Define Pad, �� �������������� ����
* � ���������� ������.
* Row,Col - ���������� ������ ������;
* PromptStr - ������ ������;
* Co - ���� ����.
Proc MenuButton
  Para MenuName,PadNo,PromptStr,R,C,Co
  Define Pad PadNo of &MenuName Prompt PromptStr At R,C
  @ R,C Say PromptStr
  @ R,C+Len(PromptStr) Say '�' Colo &Co
  @ R+1,C+1 Say Repl('�',Len(PromptStr)) Colo &Co
Return
*-End of MenuButton----------------------------------------------------------*

*-RunMenu--------------------------------------------------------------------*
* ��������� ���� � ���������� ����� ������
Func RunMenu
  Para MenuName
  Activate Menu &MenuName
Return Pad()
*-End of RunMenu-------------------------------------------------------------*

*-Div------------------------------------------------------------------------*
* ����� M �� N ������
* ��� � �������  M div N
Function Div
  Para M,N
Return (M-(M%N))/N
*-End of Div-----------------------------------------------------------------*

*-DecItem--------------------------------------------------------------------*
* ������������ ����� �� ���� �����/�������������
Proc DecItem
  previtem=item
  If (item<=1).And.(allitem>1)
    item=allitem-1
  Else
    If (item=allitem).And.(allitem>1)
      item=allitem-2
    Else
      item=item-2
    EndIf
  EndIf
  Keyboard '{Enter}'
Return
*-End of DecItem-------------------------------------------------------------*

*!*	*-VocValues------------------------------------------------------------------*
*!*	* ����� ���������� �������� �� ������� � ����������� ��
*!*	* � ������ �������, ������������� ����� ';'
*!*	* SS - �������������� ������ �����, �� ������ SS='12;09;27;14'
*!*	* L1 - ������������ ����� ������ SS (���� ����). ��� ���� ���� ��
*!*	* ������ ���� ������ �� 1 ��� ����� ���� ���� �������� � ';' .
*!*	* �.�. L1=Len('12;')+Len('09;')+Len('27;')+Len('14')+1
*!*	* L2 - ����� ������ ����� �� ������ SS (���� SS='27', �� L2=2).
*!*	* ���� Adding0=1, �� ������ �������� ����������� ����������� ������.
*!*	Func VocValues
*!*	  Para VocName,VocMode,Row,Col,SS,L1,L2,Adding0
*!*	  Dimension NN[100]
*!*	  For jj=1 To 100
*!*	    NN[jj]=0
*!*	  EndFor
*!*	  If .Not. Empty(SS)
*!*	    SS=SS+';'
*!*	    i=1
*!*	    q=0
*!*	    Do While At(';',SS,i)>0
*!*	      p=q+1
*!*	      q=At(';',SS,i)
*!*	      NN[i]=Val(Substr(SS,p,q-p+1))
*!*	      i=i+1
*!*	    EndDo
*!*	  EndIf
*!*	  If L1=L2
*!*	    Count=1
*!*	  Else
*!*	    Count=(L1-Mod(L1,(L2+1)))/(L2+1)
*!*	  EndIf
*!*	  SS=''
*!*	  ii=1
*!*	  Do While (ii<=Count)
*!*	    @  Row,Col+(L2+1)*(ii-1) Get NN[ii] Picture Repl('9',L2)
*!*	    Read
*!*	    If LastKey()<>27
*!*	      SS1=SS   && ���������� ������ (because Voc will crack her)
*!*	      NN[ii]=Voc(VocName,VocMode,Row,Col+(L2+1)*ii,NN[ii])
*!*	      SS=SS1   && �������������� ������
*!*	      If NN[ii]>0
*!*	        If Empty(SS)
*!*	          If Adding0=SetAdding0
*!*	            SS=Add0(Str(NN[ii],L2),L2)
*!*	          Else
*!*	            SS=Str(NN[ii],L2)
*!*	          EndIf
*!*	        Else
*!*	          If Adding0=1
*!*	            SS=SS+';'+Add0(Str(NN[ii],L2),L2)
*!*	          Else
*!*	            SS=SS+';'+Str(NN[ii],L2)
*!*	          EndIf
*!*	        EndIf
*!*	      EndIf
*!*	    EndIf
*!*	    @  Row,Col Say RFix(SS,L1)
*!*	    ii=ii+1
*!*	  EndDo
*!*	Return SS
*!*	*-End of VocValues-----------------------------------------------------------*

*!*	*-ByVoc----------------------------------------------------------------------*
*!*	* ������� ���������� ������ ReturnStr �� ����������, ��������������
*!*	* ����� ';' ('������;������;�������'), ���. �����. ����� ����������� VocName
*!*	* ���������� � ������ CodeStr ('07;12;39').
*!*	Func ByVoc
*!*	  Para VocName,CodeStr
*!*	  Private MaxVal,SS,Count,i,ii,jj,p,q,OldSelection
*!*	  MaxVal=100
*!*	  Dimension NN[MaxVal]
*!*	  ReturnStr=''
*!*	  If .Not. Empty(VocName)
*!*	    SS=CodeStr
*!*	    If .Not. Empty(SS)
*!*	      For jj=1 To MaxVal
*!*	        NN[jj]=0
*!*	      EndFor
*!*	      SS=SS+';'
*!*	      i=1
*!*	      q=0
*!*	      p=0
*!*	      Do While At(';',SS,i)>0
*!*	        p=q+1
*!*	        q=At(';',SS,i)
*!*	        NN[i]=Val(Substr(SS,p,q-p+1))
*!*	        i=i+1
*!*	      EndDo
*!*	      OldSelection=Select()
*!*	      Select 10
*!*	      Use &VocName
*!*	      If .Not. File(VocName+'.cdx')
*!*	        If Set('Device')='SCREEN'
*!*	          Do PutMesCnt With 'IndVW',' ����������� ',' �����. ���� �������������� �����������     ','',''
*!*	          @  1,40 Say '...' Colo n*/w
*!*	        EndIf
*!*	        Index On Num Tag Num
*!*	        Index On Nam Tag Nam
*!*	        * ���� ���������� ������
*!*	        If Left(Upper(AllTrim(VocName)),4)='SOBJ'
*!*	          For ii=1 To Fcount()
*!*	            If Left(Upper(AllTrim(Field(ii))),3)='SUB'
*!*	              Index On Str(Sub,Fsize('Sub'))+Nam Tag Sub_Nam
*!*	              Index On Str(Sub,Fsize('Sub'))+Str(Num,Fsize('Num')) Tag Sub_Num
*!*	              Exit
*!*	            EndIf
*!*	          EndFor
*!*	        EndIf
*!*	        If Set('Device')='SCREEN'
*!*	          Do ClearMes With 'IndVW'
*!*	        EndIf
*!*	      EndIf
*!*	      Set Order To Num
*!*	      Count=i-1
*!*	      For i=1 To Count
*!*	        Go Top
*!*	        Seek NN[i]
*!*	        If Found()
*!*	          If Empty(ReturnStr)
*!*	            ReturnStr=AllTrim(Nam)
*!*	          Else
*!*	            ReturnStr=ReturnStr+';'+AllTrim(Nam)
*!*	          EndIf
*!*	        EndIf
*!*	      EndFor
*!*	      Use
*!*	      Select Select(Alias(OldSelection))
*!*	    EndIf
*!*	  Else
*!*	    Do ErrWin With ' ������ ',' �� ������� ��� �����������... '
*!*	  EndIf
*!*	Return ReturnStr
*!*	*-End of ByVoc---------------------------------------------------------------*

*!*	*-ByVocCode------------------------------------------------------------------*
*!*	* ������� ���������� �� ����������� VocName �� ���� Code ���� �������� ReturnStr
*!*	* VocName -  ��� ����������� (��� ����������) - ���: C;
*!*	* VCode - ���, �� �������� ���������� �������� - ���: N.
*!*	* ������ ������ ��������� � ������ VocArr
*!*	Func ByVocCode
*!*	  Para VocName,VCode
*!*	  Private OldSelection,ii
*!*	  Scatter To VocArr Blank
*!*	  ReturnStr=''
*!*	  If .Not. Empty(VocName)
*!*	    OldSelection=Select()
*!*	    Select 10
*!*	    Use &VocName
*!*	    If .Not. File(VocName+'.cdx')
*!*	      If Set('Device')='SCREEN'
*!*	        Do PutMesCnt With 'IndVW',' ����������� ',' �����. ���� �������������� �����������     ','',''
*!*	        @  1,40 Say '...' Colo n*/w
*!*	      EndIf
*!*	      Index On Num Tag Num
*!*	      Index On Nam Tag Nam
*!*	      * ���� ���������� ������
*!*	      If Left(Upper(AllTrim(VocName)),4)='SOBJ'
*!*	        For ii=1 To Fcount()
*!*	          If Left(Upper(AllTrim(Field(ii))),3)='SUB'
*!*	            Index On Str(Sub,Fsize('Sub'))+Nam Tag Sub_Nam
*!*	            Index On Str(Sub,Fsize('Sub'))+Str(Num,Fsize('Num')) Tag Sub_Num
*!*	            Exit
*!*	          EndIf
*!*	        EndFor
*!*	      EndIf
*!*	      If Set('Device')='SCREEN'
*!*	        Do ClearMes With 'IndVW'
*!*	      EndIf
*!*	    EndIf
*!*	    Do OrderToNum
*!*	    Go Top
*!*	    If Left(Upper(AllTrim(VocName)),4)='SOBJ'
*!*	      For ii=1 To Fcount()
*!*	        If Left(Upper(AllTrim(Field(ii))),3)='SUB'
*!*	          Seek Str(Sub,Fsize('Sub'))+Str(VCode,Fsize('Num'))
*!*	          *Seek Str(GlobalSubNum,3)+Str(VCode,3)
*!*	          Exit
*!*	        EndIf
*!*	      EndFor
*!*	    Else
*!*	      Seek VCode
*!*	    EndIf
*!*	    If Found()
*!*	      ReturnStr=AllTrim(Nam)
*!*	      Scatter To VocArr
*!*	    EndIf
*!*	    Use
*!*	    Select Select(Alias(OldSelection))
*!*	  Else
*!*	    Do ErrWin With ' ������ ',' �� ������� ��� �����������... '
*!*	  EndIf
*!*	Return ReturnStr
*!*	*-End of ByVocCode-----------------------------------------------------------*

*-UpAll----------------------------------------------------------------------*
Func UpAll
  Para S
  If .Not. Empty(AllTrim(S))
    L=Len(S)
    SS=''
    For i=1 To L
      C=Asc(SubStr(S,i,1))
      If (C>=160).And.(C<=175)
        C=C-32
      Else
        If (C>=224).And.(C<=239)
          C=C-80
        Else
          If (C=241).Or.(C=243).Or.(C=245).Or.(C=247).Or.(C=249)
            C=C-1
          Else
            If (C>=97).And.(C<=122)
              C=C-32
            EndIf
          EndIf
        EndIf
      EndIf
      SS=SS+Chr(C)
    EndFor
    Return SS
  Else
    Return S
  EndIf
*-End of UpAll---------------------------------------------------------------*

*-MesWin---------------------------------------------------------------------*
* ����� ������ ��������� � ���� � �������� ������� ����� �������.
* ���������: tit - ��������� ���� ������;
             mes - ������ ���������.
Proc MesWin
  Para tit,mes
  set cursor off
  winlen=4+len(mes)
  If winlen<20
    winlen=20
  EndIf
  midlen=(winlen-(winlen%2))/2
  c=38-midlen
  defi wind MW from 7,c to 11,c+winlen-1 title tit shadow color n/w,w+/w,w+/w
  acti wind MW
  @ 1, 1 say mes
  =Inkey(0)
  Deactivate window MW
  Release window MW
retu
*-End of MesWin--------------------------------------------------------------*

*-ErrWin---------------------------------------------------------------------*
* ����� ������ ��������� �� ������ � ���� � �������� ������� ����� �������.
* ���������: tit - ��������� ���� ������;
             mes - ������ ���������.
Proc ErrWin
  Para tit,mes
  set color of Titles to w+/r
  set cursor off
  winlen=4+len(mes)
  If winlen<20
    winlen=20
  EndIf
  midlen=(winlen-(winlen%2))/2
  c=38-midlen
  defi wind EW from 7,c to 13,c+winlen-1 title tit shadow color gr+/r,w+/r,w+/r
  acti wind EW
  @  1, 1 say mes
  Do PromptButton With 3,midlen-5,'  Ok  ','n/r'
  Menu to mErr
  If (mErr=1).Or.(mErr=0)
    Do PushButton With 3,midlen-5,'  Ok  ','w+/b','n/r'
  EndIf
  Deactivate window EW
  Release window EW
  set color of Titles to w+/w
retu
*-End of ErrWin--------------------------------------------------------------*

*-Rfix-----------------------------------------------------------------------*
* �������� ����� ������ (���������� ��� ���������) ������
Function Rfix
  Para s,l
  If .Not. Empty(S)
    If len(s) >= l
      Return left(s,l)
    Else
      Return s+space(l-len(s))
    EndIf
  Else
    Return ''
  EndIf
*-End of Rfix----------------------------------------------------------------*

*-Lfix-----------------------------------------------------------------------*
* �������� ����� ������ (���������� ��� ���������) �����
Function Lfix
  Para s,l
  If len(s)>=l
    Return left(s,l)
  Else
    Return space(l-len(s))+s
  EndIf
*-End of Lfix----------------------------------------------------------------*

*-GetYesNo()-----------------------------------------------------------------*
* ������� ��������� �� ��������� ������ "��" ��� "���"
Function GetYesNo
  Para tit,mes
  YesNo='No'
  winlen=4+len(mes)
  If winlen<20
    winlen=20
  EndIf
  midlen=(winlen-(winlen%2))/2
  c=38-midlen
  defi wind MW from 8,c to 14,c+winlen-1 title tit shadow color n/w,w+/w,w+/w,w+/w
  acti wind MW
  @ 1, 1 say mes
  Do PromptButton With 3,midlen-8,' �� ','n/w'
  Do PromptButton With 3,midlen+1,' ��� ','n/w'
  menu to OKout
  Do Case
    Case OKout=1
      Do PushButton With 3,midlen-8,' �� ','w+/b','n/w'
      YesNo='Yes'
    Case OKout=2
      Do PushButton With 3,midlen+1,' ��� ','w+/b','n/w'
      YesNo='No'
  EndCase
  deac wind MW
  Release tit,mes,winlen,midlen
  Release window MW
Return YesNo
*-End of GetYesNo()----------------------------------------------------------*

*-GetYesNoRed()--------------------------------------------------------------*
* ������� ��������� �� ��������� ������ "��" ��� "���"
* �� ������� ����
Function GetYesNoRed
  Para tit,mes
  YesNo='No'
  winlen=4+len(mes)
  If winlen<20
    winlen=20
  EndIf
  midlen=(winlen-(winlen%2))/2
  c=38-midlen
  defi wind MW from 8,c to 14,c+winlen-1 title tit shadow color gr+/r,w+/w,w+/r,w+/r
  acti wind MW
  @ 1, 1 say mes
  Do PromptButton With 3,midlen-8,' �� ','n/r'
  Do PromptButton With 3,midlen+1,' ��� ','n/r'
  menu to OKout
  Do Case
    Case OKout=1
      Do PushButton With 3,midlen-8,' �� ','w+/b','n/r'
      YesNo='Yes'
    Case OKout=2
      Do PushButton With 3,midlen+1,' ��� ','w+/b','n/r'
      YesNo='No'
  EndCase
  deac wind MW
  Release tit,mes,winlen,midlen
  Release window MW
retu YesNo
*-End of GetYesNoRed()---------------------------*

*-PutMes-----------------------------------------*
* ����� ��������� � ���� ��� ������ � ����������� row,col
* ��� ������������� ���������� � ������ ���������
* ����� ������� � ���� �� 1 �� 3 �����.
* ���� ����� < 3, �� ������ ������ ���� ���������� ('').
* �������� � ���� � ClearMes.
Proc PutMes
  Para row,col,wintag,tit,mes1,mes2,mes3  && ��� ���������� ���������; wintag - ����������.
  *  ���� ������ ������� 70 ��������, �� �������� �� ������ �� 70-� ������
  If len(mes1)>70
    mes1=left(mes1,70)
  EndIf
  If len(mes2)>70
    mes2=left(mes2,70)
  EndIf
  If len(mes3)>70
    mes3=left(mes3,70)
  EndIf
  * ���������� ����� ������� ������ �� ����
  If len(mes1)>len(mes2)
    length=len(mes1)
  Else
    length=len(mes2)
  EndIf
  If len(mes3)>length
    length=len(mes3)
  EndIf
  * ����������� ������ ����
  winlen=4+length
  If winlen<20
    winlen=20
  EndIf
  * ����������� ������ ����
  wr=row+4
  If .Not. Empty(Alltrim(mes2))
    wr=wr+1
  EndIf
  If .Not. Empty(Alltrim(mes3))
    wr=wr+1
  EndIf
  * ����������� ����
  defi wind &wintag from row,col to wr,col+winlen-1 title tit shadow color n/w,gr+/b,w+/w,w+/w
  acti wind &wintag
  r=1
  * ����� ���������
  @ r, 1 say mes1
  If .Not. Empty(mes2)
    r=r+1
    @ r, 1 say mes2
  EndIf
  If .Not. Empty(mes3)
    r=r+1
    @ r, 1 say mes3
  EndIf
retu
*-End of PutMes----------------------------------*

*-PutMesCnt--------------------------------------*
* ����� ��������� � ���� ��� ������ �� ������ ������
* ��� ������������� ���������� � ������ ���������
* ����� ������� � ���� �� 1 �� 3 �����.
* ���� ����� < 3, �� ������ ������ ���� ���������� ('').
* �������� � ���� � ClearMes.
Proc PutMesCnt
  Para wintag,tit,mes1,mes2,mes3  && ��� ���������� ���������; wintag - ����������.
  *  ���� ������ ������� 70 ��������, �� �������� �� ������ �� 70-� ������
  If len(mes1)>70
    mes1=left(mes1,70)
  EndIf
  If len(mes2)>70
    mes2=left(mes2,70)
  EndIf
  If len(mes3)>70
    mes3=left(mes3,70)
  EndIf
  * ���������� ����� ������� ������ �� ����
  If len(mes1)>len(mes2)
    length=len(mes1)
  Else
    length=len(mes2)
  EndIf
  If len(mes3)>length
    length=len(mes3)
  EndIf
  * ����������� ������ ����
  winlen=4+length
  If winlen<20
    winlen=20
  EndIf
  midlen=(winlen-(winlen%2))/2
  * ����������� ������� ������ ���������
  c=38-midlen
  * ����������� ������ ����
  wr=12
  If .Not. Empty(Alltrim(mes2))
    wr=wr+1
  EndIf
  If .Not. Empty(Alltrim(mes3))
    wr=wr+1
  EndIf
  * ����������� ����
  defi wind &wintag from 8,c to wr,c+winlen-1 title tit shadow color n/w,gr+/b,w+/w,w+/w
  acti wind &wintag
  r=1
  * ����� ���������
  @ r, 1 say mes1
  If .Not. Empty(mes2)
    r=r+1
    @ r, 1 say mes2
  EndIf
  If .Not. Empty(mes3)
    r=r+1
    @ r, 1 say mes3
  EndIf
retu
*-End of PutMesCnt-------------------------------*

*-ClearMes---------------------------------------*
* �������� ���� � ����������
* �������� � ���� � PutMes ��� PutMesCnt.
Proc ClearMes
  Para wintag       && ��������� ���������
  deac wind &wintag
  Release &wintag
retu
*-End of ClearMes--------------------------------*

*-Add0-----------------------------------------------------------------------*
* ��������� ������ SSS ����������� ������ �� ����� L
Func Add0
  Para SSS,L
  If L>Len(Alltrim(SSS))
    SSS=Alltrim(SSS)
    Return Repl('0',L-Len(SSS))+SSS
  Else
    Return SSS
  EndIf
*-Add0-----------------------------------------------------------------------*

*-OrderToNam-----------------------------------------------------------------*
* ����������� Order'� (������������ ����������� Voc � ByVocCode)
Proc OrderToNam
  Private i,RangeLo,RangeHi
  * ���� ���������� Sobjxxx
  If Left(Upper(AllTrim(Alias())),4)='SOBJ'
    *Wait Window '�����'
    For i=1 To Fcount()
      If Left(Upper(AllTrim(Field(i))),3)='SUB'
        *Wait Window '����:'+Alias()+'; ������: '+AllTrim(Str(GlobalSubNum))
        Set Order To Sub_Nam
        * �������� ������� ��� ������ ������ Sub
        RangeLo=Str(GlobalSubNum,Fsize('Sub'))   &&+Space(Fsize('Nam'))
        RangeHi=Str(GlobalSubNum,Fsize('Sub'))+Repl(Chr(250),Fsize('Nam'))
        Set Key To Range RangeLo,RangeHi
        Go Top
        Exit
      EndIf
    EndFor
  Else
    *Wait Window '�� �����'
    Set Order To Nam
  EndIf
  Go Top
Return
*-End of OrderToNam----------------------------------------------------------*

*-OrderToNum-----------------------------------------------------------------*
* ����������� Order'� (������������ ����������� Voc � ByVocCode)
Proc OrderToNum
  Private i,RangeLo,RangeHi
  * ���� ���������� Sobjxxx
  If Left(Upper(AllTrim(Alias())),4)='SOBJ'
    *Wait Window '�����'
    For i=1 To Fcount()
      If Left(Upper(AllTrim(Field(i))),3)='SUB'
        *Wait Window '����:'+Alias()+'; ������: '+AllTrim(Str(GlobalSubNum))
        Set Order To Sub_Num
        * �������� ������� ��� ������ ������ Sub
        RangeLo=Str(GlobalSubNum,Fsize('Sub'))+Space(Fsize('Num'))
        RangeHi=Str(GlobalSubNum,Fsize('Sub'))+Repl('9',Fsize('Num'))
        Set Key To Range RangeLo,RangeHi
        Go Top
        Exit
      EndIf
    EndFor
  Else
    *Wait Window '�� �����'
    Set Order To Num
  EndIf
  Go Top
Return
*-End of OrderToNum----------------------------------------------------------*

*-MoneyToStr-----------------------------------------------------------------*
Func MoneyToStr
  Para MN,AA,BB
  Private S,MS
  Dimen Mon[4,9]
  **********
  Mon[1,1]='����'
  Mon[1,2]='��i'
  Mon[1,3]='���'
  Mon[1,4]='������'
  Mon[1,5]='�"���'
  Mon[1,6]='�i���'
  Mon[1,7]='�i�'
  Mon[1,8]='�i�i�'
  Mon[1,9]='���"���'
  **********
  Mon[2,1]='����������'
  Mon[2,2]='����������'
  Mon[2,3]='����������'
  Mon[2,4]='�����������'
  Mon[2,5]='�"���������'
  Mon[2,6]='�i���������'
  Mon[2,7]='�i��������'
  Mon[2,8]='�i�i��������'
  Mon[1,9]='���"���������'
  **********
  Mon[3,1]='������'
  Mon[3,2]='��������'
  Mon[3,3]='��������'
  Mon[3,4]='�����'
  Mon[3,5]='�"��������'
  Mon[3,6]='�i��������'
  Mon[3,7]='�i������'
  Mon[3,8]='�i�i������'
  Mon[3,9]='���"������'
  ********
  Mon[4,1]='���'
  Mon[4,2]='��i��i'
  Mon[4,3]='������'
  Mon[4,4]='���������'
  Mon[4,5]='�"������'
  Mon[4,6]='�i������'
  Mon[4,7]='�i����'
  Mon[4,8]='�i�i����'
  Mon[4,9]='���"������'
  ********
  MS=''
  S=Alltrim(Str(MN,AA,BB))         && S='12267886.22'
  If .Not. Empty(S)
    If At('.',S)>0
      MS=Substr(S,At('.',S)+1)+' ���.'    && MS='22 ���.'
      S=Left(S,At('.',S)-1)               && S='12267886'
    EndIf
    If .Not.Empty(S)
      MS='���. '+MS
      LL=Len(S)

      If (LL>=1).And.Val(Right(S,1))<>0
        If (LL>1).And.Val(Substr(S,LL-1,1))=1
          MS=Mon[2,Val(Alltrim(Right(S,1)))]+' '+MS    && ...�������
        Else
          If (LL>1).And.Val(Substr(S,LL-1,1))!=1
            MS=Mon[1,Val(Alltrim(Right(S,1)))]+' '+MS && ����...���"���
          EndIf
        EndIf
      EndIf

      If (LL>1).And.Val(Substr(S,LL-1,1))>1
        MS=Mon[3,Val(Alltrim(Substr(S,LL-1,1)))]+' '+MS  &&��������...
      Endif

      If (LL>2).And.Val(Alltrim(Substr(S,LL-2,1)))<>0
        MS=Mon[4,Val(Alltrim(Substr(S,LL-2,1)))]+' '+MS
      EndIf

      If (LL>3).And.Val(Alltrim(Substr(S,LL-3,1)))<>0
        MS=Mon[1,Val(Alltrim(Substr(S,LL-3,1)))]+' ���. '+MS
      EndIf

      If (LL>4).And.Val(Substr(S,LL-4,1))>1
        If Val(Alltrim(Substr(S,LL-3,1)))=0
          MS='���. '+MS
        EndIf
        MS=Mon[3,Val(Alltrim(Substr(S,LL-4,1)))]+' '+MS
      Else
        If (LL>4).And.Val(Substr(S,LL-4,1))=1
          MS=Mon[2,Val(Alltrim(Substr(S,LL-4,1)))]+' '+MS
        EndIf
      EndIf

    EndIf
  EndIf
Return MS
*-End of MoneyToStr----------------------------------------------------------*

*-DecItem--------------------------------------------------------------------*
* ������������ ����� �� ���� �����/�������������
Proc DecItem
  previtem=item
  If (item<=1).And.(allitem>1)
    item=allitem-1
  Else
    If (item=allitem).And.(allitem>1)
      item=allitem-2
    Else
      item=item-2
    EndIf
  EndIf
  Keyboard '{Enter}'
Return
*-End of DecItem-------------------------------------------------------------*


