*-MesWin---------------------------------------------------------------------*
* Вывод строки сообщения в окне и ожидание нажатия любой клавиши.
* Параметры: tit - Заголовок окна вывода;
             mes - Строка сообщения.
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
* Вывод строки сообщения об ошибке в окне и ожидание нажатия любой клавиши.
* Параметры: tit - Заголовок окна вывода;
             mes - Строка сообщения.
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
        Do ErrWin With 'Ошибка','Не верно указано время.'
      EndIf
    EndDo
    set cursor off
    @ Row,Col Say S Color w+/bg
    On Escape
  Else
    Do ErrWin With 'Ошибка','Не верно указано время.'
  EndIf
Return S
*-End of GetTime-------------------------------------------------------------*

*-TimeSec--------------------------------------------------------------------*
* Возвращает время S в секундах.
* S - строка времени в формате hh:mm:ss
* Например TimeSec('07:45:23') возвратит 27923,
* т.е. 7*3600+45*60+23=27923
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
* Возвращает время S в минутах.
* S - строка времени в формате hh:mm:ss
* Например TimeMin('07:45:23') возвратит 465.38,
* т.е. (7*3600+45*60+23)/60=465.38
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
* Возвращает время S в часах.
* S - строка времени в формате hh:mm:ss
* Например TimeSec('07:45:23') возвратит 7.76,
* т.е. (7*3600+45*60+23)/3600=7.76
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
* Фиксация длины строки (дополнение или отсекание) справа
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
* Фиксация длины строки (дополнение или отсекание) слева
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
* Функция получения на сообщение ответа "Да" или "Нет"
Function GetYesNo
  Para tit,mes
  Pause=2000    && Задержка нажатия кнопки
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
  @ 3, midlen-8  prompt ' Да '
  @ 3, midlen+1  prompt ' Нет '
  @ 3, midlen-4  say     '•'      colo n/w
  @ 4, midlen-8  say ' ••••'      colo n/w
  @ 3, midlen+6  say      '•'     colo n/w
  @ 4, midlen+1  say ' •••••'     colo n/w
  menu to OKout
  Do Case
    Case OKout=1
      @ 3,midlen-8 clear to 4,midlen-4
      iii=1
      do while iii<Pause
        @ 3, midlen-7 say ' Да '
        iii=iii+1
      enddo
      @ 3,midlen-8 clear to 4,midlen-4
      @ 3, midlen-4  say     '•'  colo n/w
      @ 4, midlen-8  say ' ••••'  colo n/w
      do while iii<Pause*2
        @ 3, midlen-8 say ' Да '
        iii=iii+1
      enddo
      YesNo='Yes'
    Case OKout=2
      @ 3,midlen+1 clear to 4,midlen+6
      iii=1
      do while iii<Pause
        @ 3, midlen+2 say ' Нет '
        iii=iii+1
      enddo
      @ 3,midlen+1 clear to 4,midlen+6
      @ 3, midlen+6 say      '•'  colo n/w
      @ 4, midlen+1 say ' •••••'  colo n/w
      do while iii<Pause*2
        @ 3, midlen+1 say ' Нет '
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
* Функция получения на сообщение ответа "Да" или "Нет"
* на красном фоне
Function GetYesNoRed
  Para tit,mes
  Pause=2000    && Задержка нажатия кнопки
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
  @ 3, midlen-8  prompt ' Да '
  @ 3, midlen+1  prompt ' Нет '
  @ 3, midlen-4  say     '•'      colo n/r
  @ 4, midlen-8  say ' ••••'      colo n/r
  @ 3, midlen+6  say      '•'     colo n/r
  @ 4, midlen+1  say ' •••••'     colo n/r
  menu to OKout
  Do Case
    Case OKout=1
      @ 3,midlen-8 clear to 4,midlen-4
      iii=1
      do while iii<Pause
        @ 3, midlen-7 say ' Да '
        iii=iii+1
      enddo
      @ 3,midlen-8 clear to 4,midlen-4
      @ 3, midlen-4  say     '•'  colo n/r
      @ 4, midlen-8  say ' ••••'  colo n/r
      do while iii<Pause*2
        @ 3, midlen-8 say ' Да '
        iii=iii+1
      enddo
      YesNo='Yes'
    Case OKout=2
      @ 3,midlen+1 clear to 4,midlen+6
      iii=1
      do while iii<Pause
        @ 3, midlen+2 say ' Нет '
        iii=iii+1
      enddo
      @ 3,midlen+1 clear to 4,midlen+6
      @ 3, midlen+6 say      '•'  colo n/r
      @ 4, midlen+1 say ' •••••'  colo n/r
      do while iii<Pause*2
        @ 3, midlen+1 say ' Нет '
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
* Вывод сообщения в окне без кнопки в координатах row,col
* для промежуточной информации о работе программы
* Можно вывести в окне от 1 до 3 строк.
* Если строк < 3, то пустые должны быть обозначены ('').
* Работает в паре с ClearMes.
Proc PutMes
  Para row,col,wintag,tit,mes1,mes2,mes3  && Все переменные строковые; wintag - латинскими.
  *  Если строка длиннее 70 симвлолв, то обрезать ее справа по 70-й символ
  If len(mes1)>70
    mes1=left(mes1,70)
  EndIf
  If len(mes2)>70
    mes2=left(mes2,70)
  EndIf
  If len(mes3)>70
    mes3=left(mes3,70)
  EndIf
  * Вычисление самой длинной строки из трех
  If len(mes1)>len(mes2)
    length=len(mes1)
  Else
    length=len(mes2)
  EndIf
  If len(mes3)>length
    length=len(mes3)
  EndIf
  * Определение ширины окна
  winlen=4+length
  If winlen<20
    winlen=20
  EndIf
  * Определение высоты окна
  wr=row+4
  If .Not. Empty(Alltrim(mes2))
    wr=wr+1
  EndIf
  If .Not. Empty(Alltrim(mes3))
    wr=wr+1
  EndIf
  * Определение окна
  defi wind &wintag from row,col to wr,col+winlen-1 title tit double shadow color n/w,gr+/b,w+/w,w+/w
  acti wind &wintag
  r=1
  * Вывод сообщений
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
* Вывод сообщения в окне без кнопки по центру экрана
* для промежуточной информации о работе программы
* Можно вывести в окне от 1 до 3 строк.
* Если строк < 3, то пустые должны быть обозначены ('').
* Работает в паре с ClearMes.
Proc PutMesCnt
  Para wintag,tit,mes1,mes2,mes3  && Все переменные строковые; wintag - латинскими.
  *  Если строка длиннее 70 симвлолв, то обрезать ее справа по 70-й символ
  If len(mes1)>70
    mes1=left(mes1,70)
  EndIf
  If len(mes2)>70
    mes2=left(mes2,70)
  EndIf
  If len(mes3)>70
    mes3=left(mes3,70)
  EndIf
  * Вычисление самой длинной строки из трех
  If len(mes1)>len(mes2)
    length=len(mes1)
  Else
    length=len(mes2)
  EndIf
  If len(mes3)>length
    length=len(mes3)
  EndIf
  * Определение ширины окна
  winlen=4+length
  If winlen<20
    winlen=20
  EndIf
  midlen=(winlen-(winlen%2))/2
  * Определение столбца вывода сообщения
  c=38-midlen
  * Определение высоты окна
  wr=12
  If .Not. Empty(Alltrim(mes2))
    wr=wr+1
  EndIf
  If .Not. Empty(Alltrim(mes3))
    wr=wr+1
  EndIf
  * Определение окна
  defi wind &wintag from 8,c to wr,c+winlen-1 title tit double shadow color n/w,gr+/b,w+/w,w+/w
  acti wind &wintag
  r=1
  * Вывод сообщений
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
* Стирание окна с сообщением
* Работает в паре с PutMes и PutMesCnt.
Proc ClearMes
  Para wintag       && строковая латинская
  deac wind &wintag
  Release &wintag
retu
*-End of ClearMes--------------------------------*

*-RunAnswer------------------------------------------------------------------*
* Высвечивает окошко внизу экрана с тремя пунктами меню,
* например ' Ввести ',' Изменить ',' Отмена ' и возвращает номер
* выбранного пункта (по Escape возвразщается 0).
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
* Установка кнопки. Работает точно как Prompt, но дорисовывается тень
* и получается кнопка.
* Row,Col - Координаты вывода кнопки;
* PromptStr - строка текста;
* Co - цвет тени.
Proc PromptButton
  Para R,C,PromptStr,Co
  @ R,C Prompt PromptStr
  @ R,C+Len(PromptStr) Say '•' Colo &Co
  @ R+1,C+1 Say Repl('•',Len(PromptStr)) Colo &Co
Return
*-End of PromptButton--------------------------------------------------------*

*-PushButton-----------------------------------------------------------------*
* Нажатие кнопки. Работает независимо от Prompt и просто имитирует
* нажатие кнопки (строки текста).
* Row,Col - Координаты вывода кнопки;
* PromptStr - строка текста;
* Co1 - цвет кнопки;
* Co2 - цвет тени.
Proc PushButton
  Para Row,Col,PromptStr,Co1,Co2
  @ Row,Col Clear To Row+1,Col+Len(PromptStr)+1
  @ Row,Col+1 Say PromptStr Colo &Co1
  =InKey(0.05)
  @ Row,Col Clear To Row+1,Col+Len(PromptStr)+1
  @ Row,Col Say PromptStr Colo &Co1
  @ Row,Col+Len(PromptStr) Say '•' Colo &Co2
  @ Row+1,Col+1 Say Repl('•',Len(PromptStr)) Colo &Co2
  =InKey(0.2)
Return
*-End of PushButton----------------------------------------------------------*

*-MenuButton-----------------------------------------------------------------*
* Установка кнопки. Работает точно как Define Pad, но дорисовывается тень
* и получается кнопка.
* Row,Col - Координаты вывода кнопки;
* PromptStr - строка текста;
* Co - цвет тени.
Proc MenuButton
  Para MenuName,PadNo,PromptStr,R,C,Co
  Define Pad PadNo of &MenuName Prompt PromptStr At R,C
  @ R,C Say PromptStr
  @ R,C+Len(PromptStr) Say '•' Colo &Co
  @ R+1,C+1 Say Repl('•',Len(PromptStr)) Colo &Co
Return
*-End of MenuButton----------------------------------------------------------*

*-RunMenu--------------------------------------------------------------------*
* Запускает меню и возвращает номер пункта
Func RunMenu
  Para MenuName
  Activate Menu &MenuName
Return Pad()
*-End of RunMenu-------------------------------------------------------------*

*-Div------------------------------------------------------------------------*
* Делит M на N нацело
* Как в Паскале  M div N
Function Div
  Para M,N
Return (M-(M%N))/N
*-End of Div-----------------------------------------------------------------*

*-DecItem--------------------------------------------------------------------*
* Передвижение вверх по окну ввода/корректировки
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
*!*	* Выбор нескольких значений из словаря и превращение их
*!*	* в строку номеров, перечисленных через ';'
*!*	* SS - результирующая строка чисел, на пример SS='12;09;27;14'
*!*	* L1 - Максимальная длина строки SS (поля базы). При этом поле БД
*!*	* должно быть больше на 1 чем сумма длин всех значений с ';' .
*!*	* Т.е. L1=Len('12;')+Len('09;')+Len('27;')+Len('14')+1
*!*	* L2 - Длина одного числа из строки SS (Если SS='27', то L2=2).
*!*	* Если Adding0=1, то каждое значение дополняется лидирующими нулями.
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
*!*	      SS1=SS   && Сохранение строки (because Voc will crack her)
*!*	      NN[ii]=Voc(VocName,VocMode,Row,Col+(L2+1)*ii,NN[ii])
*!*	      SS=SS1   && Восстановление строки
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
*!*	* Функция возвращает строку ReturnStr со значениями, перечисленными
*!*	* через ';' ('ИВАНОВ;ПЕТРОВ;СИДОРОВ'), кот. соотв. кодам справочника VocName
*!*	* записанным в строке CodeStr ('07;12;39').
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
*!*	          Do PutMesCnt With 'IndVW',' Справочники ',' Ждите. Идет индексирование справочника     ','',''
*!*	          @  1,40 Say '...' Colo n*/w
*!*	        EndIf
*!*	        Index On Num Tag Num
*!*	        Index On Nam Tag Nam
*!*	        * Если справочник товара
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
*!*	    Do ErrWin With ' Ошибка ',' Не указано имя справочника... '
*!*	  EndIf
*!*	Return ReturnStr
*!*	*-End of ByVoc---------------------------------------------------------------*

*!*	*-ByVocCode------------------------------------------------------------------*
*!*	* Функция возвращает из справочника VocName по коду Code одно значение ReturnStr
*!*	* VocName -  имя справочника (без расширения) - тип: C;
*!*	* VCode - код, по которому выбирается значение - тип: N.
*!*	* Полная запись заносится в массив VocArr
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
*!*	        Do PutMesCnt With 'IndVW',' Справочники ',' Ждите. Идет индексирование справочника     ','',''
*!*	        @  1,40 Say '...' Colo n*/w
*!*	      EndIf
*!*	      Index On Num Tag Num
*!*	      Index On Nam Tag Nam
*!*	      * Если справочник товара
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
*!*	    Do ErrWin With ' Ошибка ',' Не указано имя справочника... '
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
* Вывод строки сообщения в окне и ожидание нажатия любой клавиши.
* Параметры: tit - Заголовок окна вывода;
             mes - Строка сообщения.
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
* Вывод строки сообщения об ошибке в окне и ожидание нажатия любой клавиши.
* Параметры: tit - Заголовок окна вывода;
             mes - Строка сообщения.
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
* Фиксация длины строки (дополнение или отсекание) справа
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
* Фиксация длины строки (дополнение или отсекание) слева
Function Lfix
  Para s,l
  If len(s)>=l
    Return left(s,l)
  Else
    Return space(l-len(s))+s
  EndIf
*-End of Lfix----------------------------------------------------------------*

*-GetYesNo()-----------------------------------------------------------------*
* Функция получения на сообщение ответа "Да" или "Нет"
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
  Do PromptButton With 3,midlen-8,' Да ','n/w'
  Do PromptButton With 3,midlen+1,' Нет ','n/w'
  menu to OKout
  Do Case
    Case OKout=1
      Do PushButton With 3,midlen-8,' Да ','w+/b','n/w'
      YesNo='Yes'
    Case OKout=2
      Do PushButton With 3,midlen+1,' Нет ','w+/b','n/w'
      YesNo='No'
  EndCase
  deac wind MW
  Release tit,mes,winlen,midlen
  Release window MW
Return YesNo
*-End of GetYesNo()----------------------------------------------------------*

*-GetYesNoRed()--------------------------------------------------------------*
* Функция получения на сообщение ответа "Да" или "Нет"
* на красном фоне
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
  Do PromptButton With 3,midlen-8,' Да ','n/r'
  Do PromptButton With 3,midlen+1,' Нет ','n/r'
  menu to OKout
  Do Case
    Case OKout=1
      Do PushButton With 3,midlen-8,' Да ','w+/b','n/r'
      YesNo='Yes'
    Case OKout=2
      Do PushButton With 3,midlen+1,' Нет ','w+/b','n/r'
      YesNo='No'
  EndCase
  deac wind MW
  Release tit,mes,winlen,midlen
  Release window MW
retu YesNo
*-End of GetYesNoRed()---------------------------*

*-PutMes-----------------------------------------*
* Вывод сообщения в окне без кнопки в координатах row,col
* для промежуточной информации о работе программы
* Можно вывести в окне от 1 до 3 строк.
* Если строк < 3, то пустые должны быть обозначены ('').
* Работает в паре с ClearMes.
Proc PutMes
  Para row,col,wintag,tit,mes1,mes2,mes3  && Все переменные строковые; wintag - латинскими.
  *  Если строка длиннее 70 симвлолв, то обрезать ее справа по 70-й символ
  If len(mes1)>70
    mes1=left(mes1,70)
  EndIf
  If len(mes2)>70
    mes2=left(mes2,70)
  EndIf
  If len(mes3)>70
    mes3=left(mes3,70)
  EndIf
  * Вычисление самой длинной строки из трех
  If len(mes1)>len(mes2)
    length=len(mes1)
  Else
    length=len(mes2)
  EndIf
  If len(mes3)>length
    length=len(mes3)
  EndIf
  * Определение ширины окна
  winlen=4+length
  If winlen<20
    winlen=20
  EndIf
  * Определение высоты окна
  wr=row+4
  If .Not. Empty(Alltrim(mes2))
    wr=wr+1
  EndIf
  If .Not. Empty(Alltrim(mes3))
    wr=wr+1
  EndIf
  * Определение окна
  defi wind &wintag from row,col to wr,col+winlen-1 title tit shadow color n/w,gr+/b,w+/w,w+/w
  acti wind &wintag
  r=1
  * Вывод сообщений
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
* Вывод сообщения в окне без кнопки по центру экрана
* для промежуточной информации о работе программы
* Можно вывести в окне от 1 до 3 строк.
* Если строк < 3, то пустые должны быть обозначены ('').
* Работает в паре с ClearMes.
Proc PutMesCnt
  Para wintag,tit,mes1,mes2,mes3  && Все переменные строковые; wintag - латинскими.
  *  Если строка длиннее 70 симвлолв, то обрезать ее справа по 70-й символ
  If len(mes1)>70
    mes1=left(mes1,70)
  EndIf
  If len(mes2)>70
    mes2=left(mes2,70)
  EndIf
  If len(mes3)>70
    mes3=left(mes3,70)
  EndIf
  * Вычисление самой длинной строки из трех
  If len(mes1)>len(mes2)
    length=len(mes1)
  Else
    length=len(mes2)
  EndIf
  If len(mes3)>length
    length=len(mes3)
  EndIf
  * Определение ширины окна
  winlen=4+length
  If winlen<20
    winlen=20
  EndIf
  midlen=(winlen-(winlen%2))/2
  * Определение столбца вывода сообщения
  c=38-midlen
  * Определение высоты окна
  wr=12
  If .Not. Empty(Alltrim(mes2))
    wr=wr+1
  EndIf
  If .Not. Empty(Alltrim(mes3))
    wr=wr+1
  EndIf
  * Определение окна
  defi wind &wintag from 8,c to wr,c+winlen-1 title tit shadow color n/w,gr+/b,w+/w,w+/w
  acti wind &wintag
  r=1
  * Вывод сообщений
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
* Стирание окна с сообщением
* Работает в паре с PutMes или PutMesCnt.
Proc ClearMes
  Para wintag       && строковая латинская
  deac wind &wintag
  Release &wintag
retu
*-End of ClearMes--------------------------------*

*-Add0-----------------------------------------------------------------------*
* Дополняет строку SSS лидирующими нулями до длины L
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
* Определение Order'а (Используется процедурами Voc и ByVocCode)
Proc OrderToNam
  Private i,RangeLo,RangeHi
  * Если справочник Sobjxxx
  If Left(Upper(AllTrim(Alias())),4)='SOBJ'
    *Wait Window 'Товар'
    For i=1 To Fcount()
      If Left(Upper(AllTrim(Field(i))),3)='SUB'
        *Wait Window 'База:'+Alias()+'; Группа: '+AllTrim(Str(GlobalSubNum))
        Set Order To Sub_Nam
        * Диапазон записей для данной группы Sub
        RangeLo=Str(GlobalSubNum,Fsize('Sub'))   &&+Space(Fsize('Nam'))
        RangeHi=Str(GlobalSubNum,Fsize('Sub'))+Repl(Chr(250),Fsize('Nam'))
        Set Key To Range RangeLo,RangeHi
        Go Top
        Exit
      EndIf
    EndFor
  Else
    *Wait Window 'Не Товар'
    Set Order To Nam
  EndIf
  Go Top
Return
*-End of OrderToNam----------------------------------------------------------*

*-OrderToNum-----------------------------------------------------------------*
* Определение Order'а (Используется процедурами Voc и ByVocCode)
Proc OrderToNum
  Private i,RangeLo,RangeHi
  * Если справочник Sobjxxx
  If Left(Upper(AllTrim(Alias())),4)='SOBJ'
    *Wait Window 'Товар'
    For i=1 To Fcount()
      If Left(Upper(AllTrim(Field(i))),3)='SUB'
        *Wait Window 'База:'+Alias()+'; Группа: '+AllTrim(Str(GlobalSubNum))
        Set Order To Sub_Num
        * Диапазон записей для данной группы Sub
        RangeLo=Str(GlobalSubNum,Fsize('Sub'))+Space(Fsize('Num'))
        RangeHi=Str(GlobalSubNum,Fsize('Sub'))+Repl('9',Fsize('Num'))
        Set Key To Range RangeLo,RangeHi
        Go Top
        Exit
      EndIf
    EndFor
  Else
    *Wait Window 'Не Товар'
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
  Mon[1,1]='одна'
  Mon[1,2]='двi'
  Mon[1,3]='три'
  Mon[1,4]='чотири'
  Mon[1,5]='п"ять'
  Mon[1,6]='шiсть'
  Mon[1,7]='сiм'
  Mon[1,8]='вiсiм'
  Mon[1,9]='дев"ять'
  **********
  Mon[2,1]='одинадцять'
  Mon[2,2]='дванадцять'
  Mon[2,3]='тринадцять'
  Mon[2,4]='чотрнадцять'
  Mon[2,5]='п"ятнадцять'
  Mon[2,6]='шiстнадцять'
  Mon[2,7]='сiмнадцять'
  Mon[2,8]='вiсiмнадцять'
  Mon[1,9]='дев"ятнадцять'
  **********
  Mon[3,1]='десять'
  Mon[3,2]='двадцять'
  Mon[3,3]='тридцять'
  Mon[3,4]='сорок'
  Mon[3,5]='п"ятьдесят'
  Mon[3,6]='шiстьдесят'
  Mon[3,7]='сiмдесят'
  Mon[3,8]='вiсiмдесят'
  Mon[3,9]='дев"яносто'
  ********
  Mon[4,1]='сто'
  Mon[4,2]='двiстi'
  Mon[4,3]='триста'
  Mon[4,4]='чотириста'
  Mon[4,5]='п"ятьсот'
  Mon[4,6]='шiстьсот'
  Mon[4,7]='сiмсот'
  Mon[4,8]='вiсiмсот'
  Mon[4,9]='дев"ятьсот'
  ********
  MS=''
  S=Alltrim(Str(MN,AA,BB))         && S='12267886.22'
  If .Not. Empty(S)
    If At('.',S)>0
      MS=Substr(S,At('.',S)+1)+' коп.'    && MS='22 коп.'
      S=Left(S,At('.',S)-1)               && S='12267886'
    EndIf
    If .Not.Empty(S)
      MS='грн. '+MS
      LL=Len(S)

      If (LL>=1).And.Val(Right(S,1))<>0
        If (LL>1).And.Val(Substr(S,LL-1,1))=1
          MS=Mon[2,Val(Alltrim(Right(S,1)))]+' '+MS    && ...надцять
        Else
          If (LL>1).And.Val(Substr(S,LL-1,1))!=1
            MS=Mon[1,Val(Alltrim(Right(S,1)))]+' '+MS && одна...дев"ять
          EndIf
        EndIf
      EndIf

      If (LL>1).And.Val(Substr(S,LL-1,1))>1
        MS=Mon[3,Val(Alltrim(Substr(S,LL-1,1)))]+' '+MS  &&двадцять...
      Endif

      If (LL>2).And.Val(Alltrim(Substr(S,LL-2,1)))<>0
        MS=Mon[4,Val(Alltrim(Substr(S,LL-2,1)))]+' '+MS
      EndIf

      If (LL>3).And.Val(Alltrim(Substr(S,LL-3,1)))<>0
        MS=Mon[1,Val(Alltrim(Substr(S,LL-3,1)))]+' тис. '+MS
      EndIf

      If (LL>4).And.Val(Substr(S,LL-4,1))>1
        If Val(Alltrim(Substr(S,LL-3,1)))=0
          MS='тис. '+MS
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
* Передвижение вверх по окну ввода/корректировки
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


