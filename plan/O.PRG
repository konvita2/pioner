***********************************************************
*                                                         *
*   ���� ��������� ����������    19.01.2002               *
*                                                         *
***********************************************************
close all
clear all
set date british
set talk off
set deleted on
set typeahead to 0
set console off
set status off
set notify on
set century on
set confirm on
set safety off
set device to screen
set color to
set bell off
set escape off
SET BLINK  OFF
set color to w/b
set proc to proc
set exclusive off
set message to 23,0
*set defa to c:\new_tpp
publ arra me[12]
me[1]='ﭢ���'
me[2]='䥢ࠫ�'
me[3]='����'
me[4]='��५�'
me[5]='���'
me[6]='���'
me[7]='���'
me[8]='������'
me[9]='ᥭ����'
me[10]='������'
me[11]='�����'
me[12]='�������'
box1='�Ŀ����� '
box2='�ͻ���Ⱥ '
box3='�ͻ���Ⱥ�'
box4='�ͻ���Ⱥ�'
box5='���������'
box6='���������'
box7='  ����   '
box9='         '
publ name_firm,dir_firm,gl_buh
publ datan,datak,data_na,data_ko,bmesm,bdata,bmes,bgod
PUBL NGR,MGR,MSORT,ISORT,MSP,NSP,MSH,NSH
publ mvb,nvb                                          && f1brak
publ mgr,msort,msp,msh,isort,nsp,nsh,mkodm                   && f1mat
publ mpozn,mim,mshw,mribf,mshwz,mpartz1,mpartz2,mdata_p,mdata_z  && f1izd
publ ikttp                                             && f1kttp
publ ikodo,mrps &&,m.rabc,m.gr,minvn                   && f1kodo
publ ikto                                              && f1kto
publ kodp,mkodp,ikodp,nkodp,mus                        && f1prof
publ npodr,mpodr                                       && f1podr
publ mtabn,bfio,zo,mvo                                 && f1tn
publ imvo,imv,m.vid,kodv                               && f1vo
publ ikku                                              && f1kku
publ ikkp                                              && f1kkp
publ ikko,mnf,mir,mp1,mp3                              && f1kko
publ imkod,ikodi,ikodim,ikodid,Miim,Mrez,Mfi,Mdi,Mzi,Mbi,Mli,Msi,Mmi              && f1kodi
PUBL mmar,mpu
publ zad
publ menu_dosp
zad='��� � �����������'
zir='-****-'
name_firm='O�O "������"'
dir_firm=''
gl_buh=''
publ good
defi wind avr from 5,40 to 9,76 double shad colo w+/r
defi wind good from 16,20 to 20,60 shad colo w+/bg
defi wind nak from 16,20 to 20,60 shad colo w+/r
*acti wind avr
*@ 1,1 say '������� ������ ��� ������� "���":'
*pass='125119'
*passw='      '
*set cursor on
*@ 2,1 get passw colo w+/r,r/r
*read
*dopusk=iif(passw=pass,1,0)
*deac wind avr
set cursor off
mess=mont(date())
dopusk=1
if dopusk=1
   set color to b/w
   @ 0,0,24,79 box box5
   set color to n/bg
   @ 0,0,0,79   box box9
   @ 0,1  say '��� ࠡo⭨�� ��� "������'
   set color to gr+/bg
   @ 0,30 say '�������������-����������,������������,��������'
   set colo to r/w
   @ 24,0,24,79 box box9
   @ 24,0 say 'Esc-'
   @ 24,10 say 'Enter-'
   set colo to n/w
   @ 24,4 say '��室 '
   @ 24,16 say '�롮� o�権 ����'
   save scre to scr1
   *USE KT        ������ �᫮��� �����
   *set filt to poznw='��.014.11.00.00'
   *go top
   *if eof()
   *   wait '���������� � ������O�����'wind
   *   clos data
   *   clea all
   *   quit
   *endif
   USE obor
   set filt to left(marka,7)='24�40��'.and.left(invn,7)='0000031'
   go top
   if eof()
      wait '���������� � ������O�����'wind
      clos data
      clea all
      quit
   endif
   USE dosp
   set filt to vid=2.and.kod=5
   go top
   if eof().or.left(im,20)#'������ ���⮪'
      wait '���������� � ������O�����'wind
      clos data
      clea all
      quit
   endif
   use izd
   set filt to kod=9.and.left(im,20)='����� �������������.'.and.left(ribf,18)='�� 1.5.02.00.00-06'
   go top
   if eof()
      quit
   endif
   use kadry
   set filt to tn=66.and.left(fio,10)='����� �.�.'
   go top
   if eof()
      quit
   endif
   use instr
   set filt to kodi=116.and.left(im,20)='������ ���-637'
   go top
   if eof()
      quit
   endif
   *if year(date())>(2000+3)
   *if year(date())>2003.and.mont(date())>3
   *   wait '���������� � ������O�����'wind
   *   clos data
   *   dele file uo.dbf
   *   dele file kt.dbf
   *   dele file dosp.dbf
   *   clea all
   *   quit
   *endif
   do About
   do Exist
   set colo to n/w
   @ 0,0,24,79 box box5
   @ 0,0,0,79  box box9
   set colo of sche  2 to G/W,N/W,W+/W,N/G,G/W,N/G,N/G,W/N,B/W,W/N,+
   set colo of sche  3 to N/G,N/W,W/N,W/N,w/N,N/G,N/G,N+/N,w/N,w/N,+
   set colo of sche  4 to N/G,w/n,W/W+,W/w+,w/N,N/G,N/G,N+/N,w/N,w/N,+
   set colo of sche  5 to N/w,n/g,W/w+,W/w+,w/N,N/w,N/w,N+/N,w/N,w/N,+
   *on key label Esc do tmenu with 0
   do while .t.
      define menu mmm color scheme 3
      define pad men1 of mmm PROMPT ' ����⨢��� ࠡ�� ' &&*message ' ����� � ���,�孮����-������. ������ � �ࠢ������ �ந�����⢠'
      define pad men2 of mmm PROMPT ' ��孮����� '         &&*message ' ����� �� �孮����� � �����६.��ନ஢����� ��㤮������ � �ᯮ���.���ਠ���'
      define pad men3 of mmm PROMPT ' ��央�㬥���� '    &&*message ' �������� ��室��� �� �� �孮���. �����⮢�� �ந�����⢠ � ��ᯥ��.�ࠢ�����'
      define pad men4 of mmm PROMPT ' ��ࠢ�筨�� '        &&*message ' ����祭�� ��ଠ⨢��-�ࠢ�筮� ���ଠ樨'
      define pad men5 of mmm PROMPT ' ��室 '              &&*message ' �������� ࠡ��� � ��⥬�� "@�����-�ந�����⢮"'

      on  pad men1  of mmm activate popup pop1
      on  pad men2  of mmm activate popup pop2
      on  pad men3  of mmm activate popup pop3
      on  pad men4  of mmm activate popup pop4
      on  pad men5  of mmm activate popup pop5

      define popup pop1 from 1,0 shadow
      define bar 1  of pop1 PROMPT ' ������� ��������� �������' && kt
      define bar 2  of pop1 PROMPT ' ����� � �ந��. �����   ' && ww
      define bar 3  of pop1 PROMPT ' ����� � ������. �����   ' && te
      define bar 4  of pop1 PROMPT ' ����� � �孮�. �����   ' && ek
      define bar 5  of pop1 PROMPT ' �����                   ' && nar
      define bar 6  of pop1 PROMPT ' ���ਠ��                ' && uza
      define bar 7  of pop1 PROMPT ' ��ࠢ����� ����⢮�     ' && ka
      define bar 8  of pop1 PROMPT ' �������୮� �����஢���� ' && kp
      on selection popup pop1 do tmenu WITH 10

      define popup pop2 from 1,12 shadow
      define bar 1  of pop2 PROMPT 'T���.�� ���.ࠡ���  '        && za
      define bar 2  of pop2 PROMPT 'T���.�� ��审ࠡ���'        && mo
      define bar 3  of pop2 PROMPT 'T���.�� 宫.�⠬�.ࠡ���'    && sh
      define bar 4  of pop2 PROMPT 'T���.�� ᢠ�.ࠡ���'         && sw
      define bar 5  of pop2 PROMPT 'T���.�� �����'             && okr
      define bar 6  of pop2 PROMPT 'T���.�� ᫥��� ࠡ���'    && sr
      define bar 7  of pop2 PROMPT '��⠫�� ��⠭���� ��⠫��  '  && uu
      define bar 8  of pop2 PROMPT '��⠫�� ���                '  && up
      define bar 9  of pop2 PROMPT '��⠫�� �孮�.�᫮��� ���.'  && usp
      define bar 10 of pop2 PROMPT '��⠫�� ��६�����         '  && uo
      on selection popup pop2 do tmenu WITH 20

      define popup pop3 from 1,33 shadow
      define bar 1  of pop3 PROMPT  ' ������� ��������� �������          ' && p_svi
      define bar 2  of pop3 PROMPT  ' ��������� ���客��               ' && wr
      define bar 3  of pop3 PROMPT  ' ��⠫쭮-ᯥ��. ���� ���ਠ���  ' && dsn
      define bar 4  of pop3 PROMPT  ' ����饭��� ��������� ���ਠ���    ' && owm
      define bar 5  of pop3 PROMPT  ' ���� �� �ࠪ�                     ' && ob
      define bar 6  of pop3 PROMPT  ' ��������� ��� �६��� � ��業��  ' && wnw
      define bar 7  of pop3 PROMPT  ' �������� ����                    ' && ml
      define bar 8  of pop3 PROMPT  ' ��������� �� ����� ��㤠          ' && wot
      define bar 9  of pop3 PROMPT  ' ����-������� �� ��१�� ����⮢��  ' && ppz
      define bar 10 of pop3 PROMPT  ' ����-������� �� �����            ' && pzr
      define bar 11 of pop3 PROMPT  ' ���� �ந�����⢠ �� ������    ' && ppp
      define bar 12 of pop3 PROMPT  ' ���� �ந�����⢠ �� ����㤮�����  ' && pzo
      define bar 13 of pop3 PROMPT  ' ���� �ந�����⢠ �� ���⪠�      ' && ppu
      define bar 14 of pop3 PROMPT  ' �������襭��� �ந��-�� (�����.)   ' && nzp
      define bar 15 of pop3 PROMPT  ' �������襭��� �ந��-�� (᢮�)     ' && nzps
      define bar 16 of pop3 PROMPT  ' ������� ��������� ���᫥���       ' && swn
      define bar 17 of pop3 PROMPT  ' ����� ������                 ' && pt
      define bar 18 of pop3 PROMPT  ' ������� ��㤮������� �� �������    ' && st
      define bar 19 of pop3 PROMPT  ' ���� ������       �� �������    ' && pz
      define bar 20 of pop3 PROMPT  ' ��ࠢ�� ���� ���ॡ�.����஫�஢' && kont
      define bar 21 of pop3 PROMPT  ' ������᪨� ���� ����⢠      ' && sto
      define bar 22 of pop3 PROMPT  ' ���ॡ����� �����㬥�� �� ������� ' && wpi
      define bar 23 of pop3 PROMPT  ' ���祭�� ���ᮭ��� ������        ' && ki
      define bar 24 of pop3 PROMPT  ' �����.���஢.�����-� � �᭠饭��' && wio
      define bar 25 of pop3 PROMPT  ' ��������� ���஢���� ����㤮�����' && wto
      define bar 26 of pop3 PROMPT  ' ��������� ��ᮮ⢥��⢨� ���       ' && wn
      *define bar 28 of pop3 PROMPT  '                                    '
      on selection popup pop3 do tmenu WITH 40

      define popup pop4 from 1,44 shadow
      define bar 1  of pop4 PROMPT ' �����                    '        && kadry
      define bar 2  of pop4 PROMPT ' ����㤮�����             '        && obor
      define bar 3  of pop4 PROMPT ' ���� ��䭨� �⮪      '        && 12
      define bar 4  of pop4 PROMPT ' ��������                '        && 5
      define bar 5  of pop4 PROMPT ' ������� ����७��        '        && 10
      define bar 6  of pop4 PROMPT ' ������ ࠡ�祣� �६���  '        && brut
      define bar 7  of pop4 PROMPT ' ���ࠧ�������            '        && 2
      define bar 8  of pop4 PROMPT ' ���� ����㤮�����        '        && 11
      define bar 9  of pop4 PROMPT ' ������ �������      '        && 9
      define bar 10 of pop4 PROMPT ' ���.��.�⠢��           '        && tarif
      define bar 11 of pop4 PROMPT ' �⠭����� �� 娬��⠢�  '        && 23
      define bar 12 of pop4 PROMPT ' �⠭����� �� ���⠢���   '        && 22
      define bar 13 of pop4 PROMPT ' ��㯯� ���ਠ���        '        && 26
      define bar 14 of pop4 PROMPT ' ����⠢���. �த���    '        && i
      define bar 15 of pop4 PROMPT ' ���� �孮�-�� ����権  '        && 7
      define bar 16 of pop4 PROMPT ' ��稭� ���-� ���㬥�⮢ '        && 4
      define bar 17 of pop4 PROMPT ' ���� ��⠬���          '        && 21
      define bar 18 of pop4 PROMPT ' ���ॡ�⥫� �த�樨    '        && potr
      define bar 19 of pop4 PROMPT ' ���� ��⠭����          '        && 30
      define bar 20 of pop4 PROMPT ' ���ᮡ ��⠭����         '        && 31
      define bar 21 of pop4 PROMPT ' ��ࠪ�� ��⠭����       '        && 32
      define bar 22 of pop4 PROMPT ' ��⮤ �஢�ન           '        && 33
      define bar 23 of pop4 PROMPT ' ���㯭� ����������訥   '        && km
      define bar 24 of pop4 PROMPT ' ��ࠡ��뢠�訩 �����㬥��'        && instr 1
      define bar 25 of pop4 PROMPT ' ��㯯�  �����㬥��      '        && 34
      define bar 26 of pop4 PROMPT ' ���⥫�� �����㬥���  '        && instr 2
      define bar 27 of pop4 PROMPT ' ��稩 �����㬥��        '        && instr 3
      define bar 28 of pop4 PROMPT ' ��ᯮᮡ�����           '        && 41
      define bar 29 of pop4 PROMPT ' ���.��室� �ᯮ���.���.'        && normmat
      define bar 30 of pop4 PROMPT ' �⠬�� � �������      '        && press
      define bar 31 of pop4 PROMPT ' ��孮���-� ���� ����権 '        && tto
      define bar 32 of pop4 PROMPT ' ��孮���-� �᫮��� � ��� '        && ktu
      define bar 33 of pop4 PROMPT ' ������� �孮�.�奬� ���.'        && kto
      define bar 34 of pop4 PROMPT ' ���⮢�� �����           '        && 40
      define bar 35 of pop4 PROMPT ' �����䨪��� ����� �ࠪ�'        && 51
      define bar 36 of pop4 PROMPT ' % ����஫�               '        && 52
      define bar 37 of pop4 PROMPT ' ����� ��⠫�� � ᡮப   '        && 53
      define bar 38 of pop4 PROMPT ' ������樨               '        && 44
      define bar 39 of pop4 PROMPT ' ��ࠢ�筨� ࠡ�祣� �६.'        &&
      on selection popup pop4 do tmenu WITH 70

      define popup pop5 from 1,58 shadow
      define bar 1 of pop5 PROMPT ' ��室 � FoxPro    '
      *define bar 4 of pop5 PROMPT ' ��२������� ���'
      define bar 2 of pop5 PROMPT ' ��室 � DOS       '
      *define bar 3 of pop5 PROMPT ' �த������ ࠡ��� '
      *define bar 4 of pop5 PROMPT ' ��������  ࠡ��� '
      on selection popup pop5 do tmenu WITH 110
      ACTIVATE MENU mmm
   enddo
   On Key
endif
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
PROC tmenu
PARA m1
Private OldSel
sf=m1+bar()
m1=iif(m1#0,m1+bar(),m1)
do case
   case m1=11
        do kt
   case m1=12
        do ww
   case m1=13
        do te
   case m1=14
        do ek
   case m1=15
        do nar
   case m1=16
        do uza
   case m1=17
        do ka
   case m1=18                            &&
        *do kp
        do kp7
   case m1=21                            &&
        do za
   case m1=22                            &&
        do mo
   case m1=23                            && �⠬�����
        do sh
   case m1=24                            && ᢠઠ
        do sw
   case m1=25                            && ���᪠
        do okr
   case m1=26                            && ᫥�ઠ
        do sr
   case m1=27
        do uu
   case m1=28                            &&
        do up
   case m1=29                            &&
        do usp
   case m1=30                            &&
        do uo
   case m1=41                            && ����� ���
        do p_svi
   case m1=42                           && ��������� ���客��
        do wr
   case m1=43                           && ��⠫쭮-ᯥ��. ���� ���ਠ���
        do dsn
   case m1=44                           && ����饭��� ��������� ���ਠ���
        do owm
   case m1=45                           && ���� �� �ࠪ�
        do ob
   case m1=46                           && ��������� ��� �६��� � ��業��
        do wnw
   case m1=47                           && �������� ����
        do ml
   case m1=48                           && ��������� �� ����� ��㤠
        do wot
   case m1=49                           && ����-������� �� ��१�� ����⮢��
        do ppz
   case m1=50                           && ����-������� �� ���������� ࠡ�� ࠡ�稬
        do pzr
   case m1=51                           && ���� �ந�����⢠ �� ������
        do ppp
   case m1=52                           && ���� ����㧪� ����㤮����� �� ��� (�����)
        do pzo
   case m1=53                           && ���� ����㧪� �� �����
        do ppu
   case m1=54                           &&
        do nzp
   case m1=55                           &&
        do nzps
   case m1=56                           &&
        do swn
   case m1=57                           && ����� ������
        do pt
   case m1=58                           && ᢮���� ��㤮������� �� �������
        do st
   case m1=59                           && ���� ������       �� �������
        do pz
   case m1=60                           &&
        do kont
   case m1=61                           &&
        do sto
   case m1=62                           &&
        do wpi
   case m1=63                           &&
        do ki
   case m1=64                           &&
        do wio
   case m1=65                           &&
        do wto
   case m1=66                           &&
        do wn
   case m1=71                           && �����
        do kadry
   case m1=72                           &&  ����㤮�����
        do obor
   case m1=73                           && ���� �⪨
        ij=0
        do dosp with 12
   case m1=74                           && �����䨪��� �������⥩
        ij=0
        do Dosp with 5
   case m1=75                           &&  �����䨪��� ��. ����७��
        ij=1
        do Dosp with 10
   case m1=76                           && ������ ࠡ�祣� �६���
        do brut
   case m1=77                           && �����䨪��� ���ࠧ�������
        ij=3
        do Dosp with 2
   case m1=78                           && ���� ����㤮�����
        ij=4
        do Dosp with 11
   case m1=79                           && ������ �������
        ij=3
        do Dosp with 9
   case m1=80                           && ���.��.�⠢��
        do tarif 
   case m1=81                           && �⠭����� �� 娬��⠢�
        ij=3
        do Dosp with 23
   case m1=82                           && �⠭����� �� ���⠢���
        ij=3
        do Dosp with 22
   case m1=83                           && ��㯯� ���ਠ���
        ij=3
        do Dosp with 26
   case m1=84                           && �������
        do izd
   case m1=85                           && ���� �孮�-�� ����権
        ij=3
        do Dosp with 7
   case m1=86                           && ��稭� ���-� ���㬥�⮢
        ij=3
        do Dosp with 4
   case m1=87                           && ���� ��⠬���
        ij=3
        do Dosp with 21
   case m1=88                           && ���ॡ�⥫� �த�樨
        do potr
   case m1=89                           && ���� ��⠭����
        ij=3
        do Dosp with 30
   case m1=90                           && ���ᮡ ��⠭����
        ij=3
        do Dosp with 31
   case m1=91                           && ��ࠪ�� ��⠭����
        ij=3
        do Dosp with 32
   case m1=92                           && ��⮤ �஢�ન
        ij=3
        do Dosp with 33
   case m1=93                           && ���㯭� ����������騥 � �����쭠� �த-��
        do km
   case m1=94                           && ���������� ��ࠡ��뢠�騩
        do INSTR with 1
   case m1=95                           && ��㯯� ��ࠡ. �����㬥��
        ij=3
        do dosp with 34
   case m1=96                           && ���⥫�� �����㬥���
        do instr with 2
   case m1=97                           && ��稩 �����㬥��
        do instr with 3
   *ase m1=98                           && ���客����
   *    ij=3
   *    do Dosp with 43
   case m1=98                           && ��ᯮᮡ�����
        ij=3
        do Dosp with 41
   case m1=99                           && ���.��室� �ᯮ���.����.
        do normmat
   case m1=100                          && �⠬�� � �������
        do press
   case m1=101                          && ��孮�����᪨� ���� ����権
        do tto
   case m1=102                          && ��孮�����᪨� �᫮��� � ���
        do ktu
   case m1=103                           && ������� �孮�����᪨� �奬 ��ࠡ�⪨
        do kto
   case m1=104                          && 梥�
        ij=3
        do Dosp with 40
   case m1=105                          && ���� �ࠪ�
        ij=3
        do Dosp with 51
   case m1=106                          && % ����஫�
        ij=3
        do Dosp with 52
   case m1=107                          && ⨯��
        ij=3
        do Dosp with 53
   case m1=108                          && ������樨
        ij=3
        do Dosp with 44
   case m1=109                          && ࠡ�稥 ���
        sele 55
        use rd
        brow fiel mes:H='�����',den:H='����',n_1:H='��砫� ᬥ��',n_2:H='����� ᬥ��'
        use
   case m1=111
        *WAIT '��室 � FoxPro  case m1=111' WIND
        On Key
        close data
        rele  all
        cancel
   case m1=112
        ON KEY
        close data
        rele all
        quit
*   case m1=114
*        ON KEY
*        close data
*        rele all
*use dosp
*zap
*use kt
*zap
*use obor
*zap
*use mater
*zap
*use te
*zap
*use kadry
*zap
*use brut
*zap
*use izd
*zap
*use press
*zap
*use tarif
*zap
*use ww
*zap
*use UU
*zap
*use UP
*zap
*use UO
*zap
*use potr
*zap
*use USP
*zap
*use INSTR
*zap
*use TIP
*zap
*use TTP
*zap
*use TTO
*zap
*use kTO
*zap
*use kTu
*zap
*use normmat
*zap
endcase

Return
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* About: ��o� ���oଠ樨 o ��⥬� ----------------------*
Proc About

@ 3,5 fill to 9,75 colo n+/n
set color to gr+/b
@ 2,3,8,8 box box9
SET COLO TO GR+/B
@ 3,4 say  '��ͻ '
@ 4,4 say  '�  � '
@ 5,4 say  '�    '
@ 6,4 say  '�  � '
@ 7,4 say  '��ͼ '

set color to gr+/bg
@ 2,8,8,13 box box9
SET COLO TO GR+/Bg
@ 3,9 say  '��ͻ'
@ 4,9 say  '�  �'
@ 5,9 say  '�  �'
@ 6,9 say  '�  �'
@ 7,9 say  '�  �'

set color to gr+/gr+
@ 2,13,8,18 box box9
SET COLO TO GR+/gr+
@ 3,14 say  '��ͻ '
@ 4,14 say  '�  � '
@ 5,14 say  '�͵  '
@ 6,14 say  '�  � '
@ 7,14 say  '��ͼ '
set color to gr+/r
@ 2,18,8,23 box box9
SET COLO TO GR+/r
@ 3,19 say  '�  �'
@ 4,19 say  '� / '
@ 5,19 say  '̵  '
@ 6,19 say  '� \ '
@ 7,19 say  '�  �'

set color to gr+/G
@ 2,23,8,28 box box9
SET COLO TO GR+/G

@ 3,23 say  '���͸'
@ 4,23 say  '  �  '
@ 5,23 say  '  �  '
@ 6,23 say  '  �  '
@ 7,23 say  '  �  '

set color to gr+/w+
@ 2,28,8,33 box box9
SET COLO TO GR+/w+

@ 3,29 say  '��ͻ'
@ 4,29 say  '�  �'
@ 5,29 say  '��ͼ'
@ 6,29 say  '�   '
@ 7,29 say  '�   '

set color to gr+/bR
@ 2,33,8,38 box box9
SET COLO TO GR+/bR
@ 3,34 say  '     '
@ 4,34 say  '     '
@ 5,34 say  '  ���'
@ 6,34 say  '     '
@ 7,34 say  '     '
set color to gr+/b
@ 2,38,8,43 box box9
set color to gr+/b
@ 3,38 say  '    '
@ 4,38 say  '    '
@ 5,38 say  '��� '
@ 6,38 say  '    '
@ 7,38 say  '    '

set color to gr+/bg
@ 2,43,8,48 box box9
SET COLO TO GR+/Bg
@ 3,44 say '   /'
@ 4,44 say '  � '
@ 5,44 say '  � '
@ 6,44 say '  ��'
@ 7,44 say '  � '

set color to gr+/gr+
@ 2,48,8,54 box box9
SET COLO TO GR+/gr+
@ 3,48 say 'ͻ   '
@ 4,48 say ' �   '
@ 5,48 say ' �   '
@ 6,48 say 'ͺ   '
@ 7,48 say ' �   '
set color to gr+/r
@ 2,53,8,58 box box9
SET COLO TO GR+/r
@ 3,54 say '  ��'
@ 4,54 say '    '
@ 5,54 say '    '
@ 6,54 say '    '
@ 7,54 say '    '

set color to gr+/G
@ 2,58,8,63 box box9
SET COLO TO GR+/G

@ 3,58 say '�͸  '
@ 4,58 say '�    '
@ 5,58 say '�    '
@ 6,58 say '�    '
@ 7,58 say '�    '

set color to gr+/w+
@ 2,63,8,68 box box9
SET COLO TO GR+/w+

@ 3,64 say '  ���'
@ 4,64 say '  �  '
@ 5,64 say '  �  '
@ 6,64 say '  �  '
@ 7,64 say '  �  '
set color to gr+/b
@ 2,68,8,73 box box9
SET COLO TO GR+/B
@ 3,68 say 'ͻ  '
@ 4,68 say ' �  '
@ 5,68 say ' �  '
@ 6,68 say ' �  '
@ 7,68 say ' �  '

set color to gr+/b
@ 2,4  say chr(7)
@ 8,4  say chr(7)
@ 2,72 say chr(7)
@ 8,72 say chr(7)

@ 12,20 fill to 29,62 colo n+/n
set colo to w+/w
@ 11,18,25,70 box box2
@ 11,33 say ' � �ணࠬ�� '
set colo to n/w,w+/g
@ 13,30 say '���o��⨧�஢����� ࠡ�祥 ����      '
@ 14,30 say '�孮����,��ᯥ���,���������       '
@ 15,30 say '   ��� ��� "� � � � � �"              '
@ 16,30 say '  "������������������  ��⥬�        '
@ 17,30 say '����������,������������,��������"     '
@ 18,30 say '  ��ࠨ�� , ��ઠ���, 66-15-74        '
@ 19,30 say '          2 0 0 2 �.                  '
@ 20,36 prompt         '  OK  '
@ 20,42 say '�'
@ 21,36 say ' ������'
menu to AboutOK
if AboutOK=1
   set colo to n/w
   @ 20,45,27,50 box box9
   set colo to w+/g
   iii=1
   do while iii<300
      @ 20,37 say '  OK  '
      iii=iii+1
   enddo
   set colo to n/w
   @ 20,36,21,42 box box9
   @ 20,42 say '�'
   @ 21,36 say ' ������'
   set colo to w+/g
   do while iii<1000
      @ 20,36 say '  OK  '
      iii=iii+1
   enddo
endif
set color to b/w
@ 2,0,23,79 box box5

* Exist: �஢�ઠ �������� ��--------------------------*
Proc Exist
sele 1
use dosp
if .not.file ('dosp.cdx')
   inde  on str(vid,4)+str(kod,4) tag ivk
   inde  on str(vid,4)+str(kod,4)+str(us,6,2) tag ivku
   inde  on str(vid,4)+im          tag ivi
   inde  on str(vid,4)+sim         tag ivs
   inde  on str(vid,4)+str(us,6,2) tag ivu
endif
if .not.file ('dosp.dbf')
  namfil='DOSP.dbf'
  do avar
endif
set filt to
sele 2
use kt
if .not.file ('kt.cdx')
   inde  on shw                    tag ishw
   inde  on POZNW+STR(D_u,1)+KORNW tag iPOZNW
   inde  on str(shw,6)+STR(PU,3)   tag iSP
   inde  on str(shw,6)+kornd       tag ikornd
   inde  on str(shw,6)+kornw+kornd tag ikn
   inde  on str(shw,6)+poznw+poznd tag ipoz
   inde  on str(shw,6)+poznw       tag iu
   inde  on str(shw,6)+poznd       tag ipoznd
   inde  on str(shw,6)+poznd+kornd       tag i7
   inde  on poznd                  tag i_d
   inde  on poznd+str(d_u,1)       tag i_du
   inde  on pozn+str(kodm,4)       tag ipm
   inde  on kodm                   tag ikodm
endif
SET ORDER TO IKN
if .not.file ('kt.dbf')
  namfil='KT.DBF'
  do avar
endif
sele 3
use obor
if .not.file ('obor.cdx')
   inde on STR(VID,4)+MARKA   tag iVID
   inde on naim  tag in
   inde on marka tag ikodo
   inde on invn  tag iinvn
   inde on podr  tag ipodr
   inde on str(podr,4)+marka tag ipm
endif
if .not.file ('obor.dbf')
   namfil='obor.dbf'
   do avar
endif
sele 4
use mater
if .not.file ('mater.cdx')
   inde on kodm tag ikodm
   inde on naim tag inaim
   inde on str(sort,2)+naim tag isn
   inde on naim+dtoc(data_p) tag inada
endif
if .not.file ('mater.dbf')
   namfil='MATER.dbf'
   do avar
endif
set filt to
sele 5
use te
if .not.file ('te.cdx')
   inde on poznd+str(nto,4)+str(ntp,2) tag ito
   inde on poznd+str(mar,4)            tag idm
   inde on poznd+str(mar,4)+str(nto,4) tag inar
   inde on poznd                       tag ipoznd
   inde on kodo                        tag ikodo
   inde on kodp                        tag ikodp
   inde on kodi                        tag ikodi
   inde on kodid                       tag ikodid
   inde on kodim                       tag ikodim
   inde on osn                         tag iosn
endif
if .not.file ('te.dbf')
   namfil='te.DBF'
   do avar
endif
sele 6
use kadry
if .not.file ('kadry.cdx')
   inde  on podr            tag ipodr
   inde  on str(podr,4)+fio tag ipf
   inde  on tn              tag itn
   inde  on fio             tag ifio
   inde  on prof            tag iprof
endif
if .not.file ('kadry.dbf')
   namfil='KADRY.DBF'
   do avar
endif
set filt to

sele 7
use nar
if .not.file ('nar.cdx')
   inde on str(tabn,5)+dtoc(data_b) tag itd
   inde on shwz                     tag ishwz
   inde on shwz+kornd+str(mar,4)+str(nto,4)     tag ikzr
   inde on shwz+kornd+str(mar,4)                tag iskm
endif
if .not.file ('nar.dbf')
   namfil='nar.DBF'
   do avar
endif

sele 8
use izd
if .not.file ('izd.cdx')
   inde  on KOD  tag iKOD
   inde  on ribf tag ir
   inde  on im   tag iim
   inde  on shwz tag ishwz
   inde on str(year(data_p),4)+str(mont(data_p),2)+str(day(data_p),2) tag idata_p
endif
if .not.file ('izd.dbf')
   namfil='IZD.DBF'
   do avar
endif
set filt to
sele 9
use press
if .not.file ('press.cdx')
   inde  on kod tag iosn
endif
if .not.file ('press.dbf')
   namfil='press.DBF'
   do avar
endif
sele 10
use tarif
if .not.file ('tarif.cdx')
   inde  on str(vidts,2)+str(rr,1) tag vidts
endif
if .not.file ('tarif.dbf')
   namfil='TARIF.DBF'
   do avar
endif
sele 11
use ww
if .not.file ('ww.cdx')
   inde on data_z                   tag itd
   inde on shwz                     tag ishwz
   inde on kornw                    tag ikornw
   inde on shwz+poznd               tag isp
   inde on shwz+kornd               tag isk
   inde on shwz+poznd+str(mar,4)    tag ispm
   inde on shwz+str(mar,4)          tag ism
   inde on str(shw,6)+poznd+str(nto,4)+kodo tag i7
   inde on str(shw,6)+str(kodm,4)+str(mar,4)+str(kto,5) tag ippz
   inde on shwz+poznd+str(mar,4)+str(nto,4)     tag ipzr
   inde on shwz+kornd+str(mar,4)+str(nto,4)     tag ikzr
   inde on shwz+kornd+str(mar,4)+kodo           tag inar
   inde on shwz+kornd+str(nto,4)                tag iskn
   inde on shwz+kornd+str(mar,4)                tag iskm
   inde on shwz+str(kodp,4)+str(mar,4)          tag ippz
   inde on kodm                                 tag ikodm
   inde on kodp                                 tag ikodp
   inde on poznd+kttp+str(nto,4)                tag ipks
   inde on kodo+str(vo,5,2)                     tag ikv
   inde on invn+str(data_n,2)+str(vn,5,2)       tag ikdn
   inde on invn+str(data_nd,2)+str(vnd,5,2)     tag ikdnd
endif
if .not.file ('ww.dbf')
   namfil='ww.DBF'
   do avar
endif
sele 12
use UU
if .not.file ('UU.cdx')
   inde  on vid+kk+wes_n tag iwes
endif
if .not.file ('UU.dbf')
   namfil='UU.DBF'
   do avar
endif
sele 14
use UP
if .not.file ('UP.cdx')
   inde  on vid+kk+gr+us tag ius
endif
if .not.file ('UP.dbf')
   namfil='UP.DBF'
   do avar
endif
sele 15
use UO
if .not.file ('UO.cdx')
   *inde  on vid+kod+gr+rez+dzy+ld+ds+gl+d tag idi
   inde  on STR(vid)+STR(kod)+STR(gr)+STR(rez)+STR(dzy)+STR(ld)+STR(ds)+STR(gl)+STR(d) tag idiTI
endif
if .not.file ('UO.dbf')
   namfil='UO.DBF'
   do avar
endif
sele 17
use USP
if .not.file ('USP.cdx')
   Inde  on im tag iim
endif
if .not.file ('USP.dbf')
   namfil='USP.DBF'
   do avar
endif
sele 18
use INSTR
if .not.file ('INSTR.cdx')
   Inde  on str(pri,1)+str(kodi,3)  tag ikodi
   Inde  on str(pri,1)+im           tag ipi
   Inde  on im    tag iim
endif
if .not.file ('INSTR.dbf')
   namfil='INSTR.DBF'
   do avar
endif
*sele 19
*use TIP
*if .not.file ('TIP.cdx')
*   *Inde  on str(tabn)+dtoc(data_b) tag itd
*endif
*if .not.file ('TIP.dbf')
*   namfil='TIP.DBF'
*   do avar
*endif
sele 20
use TTP
if .not.file ('TTP.cdx')
   *Inde  on str(tabn)+dtoc(data_b) tag itd
endif
if .not.file ('TTP.dbf')
   namfil='TTP.DBF'
   do avar
endif
sele 21
use TTO
if .not.file ('TTO.cdx')
   Inde  on ttp+str(nfm) tag ito
endif
if .not.file ('TTO.dbf')
   namfil='TTO.DBF'
   do avar
endif
sele 22
use kTO
if .not.file ('kTO.cdx')
   *Inde  on str(tabn)+dtoc(data_b) tag itd
endif
if .not.file ('kTO.dbf')
   namfil='kTO.DBF'
   do avar
endif
sele 23
use kTu
if .not.file ('kTu.cdx')
   Inde  on ttp+im tag iim
   *Inde  on ttp, tag iim
endif
if .not.file ('kTu.dbf')
   namfil='kTu.DBF'
   do avar
endif
set order to iim
*sele 24
*use normmat
*if .not.file ('normmat.cdx')
*   *Inde  on str(tabn)+dtoc(data_b) tag itd
*endif
*if .not.file ('normmat.dbf')
*   namfil='normmat.DBF'
*   do avar
*endif
sele 25
use roba
if .not.file ('roba.cdx')
   *Inde  on str(tabn)+dtoc(data_b) tag itd
endif
if .not.file ('roba.dbf')
   namfil='roba.DBF'
   do avar
endif
sele 26
use twer
if .not.file ('twer.cdx')
   *Inde  on str(tabn)+dtoc(data_b) tag itd
endif
if .not.file ('twer.dbf')
   namfil='twer.DBF'
   do avar
endif
*sele 27
*use pereb
*if .not.file ('pereb.cdx')
*   Inde  on vid+pri+df+gl tag itd
*   Inde  on vid+pri+df+ds tag ifs
*endif
*if .not.file ('pereb.dbf')
*   namfil='pereb.DBF'
*   do avar
*endif
sele 28
use wm
if .not.file ('wm.cdx')
   inde on kodm tag ikodm
endif
if .not.file ('wm.dbf')
   namfil='WM.DBF'
   do avar
endif
set filt to
sele 29
use km
if .not.file ('km.cdx')
   inde on kodm tag ikodm
   inde on naim tag inaim
endif
if .not.file ('km.dbf')
   namfil='KM.DBF'
   do avar
endif
set filt to
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc brut
use brut
brow
USE
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc Dosp
para a
on key
sele 1
ok=0
do while .t.
   do menuu with ij
   do case
      case menu_dosp=1
           do V_dosp with 1
      case menu_dosp=2
           on key
           do V_dosp with 2
      case menu_dosp=3
           on key
           sele 1
           set filt to Vid=a.and.Kod=0
           go top
           ttl=im
           fl='d'+allt(str(vid,4))+'.txt '
           acti wind good
           @ 0,1 say '���� '+fl+' ��� ���� �ନ�����'
           @ 1,1 say '����...'
           SET CURSOR OFF
           set print to &fl
           set device to print
           @prow()+1,5 say ttl
           @prow()+1,5 say '�� ���ﭨ� �� '+dtoc(date())
           @prow()+1,0 say' ���������������������������������������������������� '
           @prow()+1,0 say' ��� H�����������                   ����.������������ '
           @prow()+1,0 say' �����������������������������������������������������'
           set order to ivi
           set filt to Vid=a.and.Kod#0
           go top
           do while .not. eof()
              @prow()+1,0 say str(kod,4)+' '+im+' '+sim+' '+iif(us#0,str(us,6,2),space(6))+' '+obor
              skip
           enddo
           set print on
           set device to screen
           do pech
           deac wind good
           sele 1
           set filt to
      case menu_dosp=4.or.menu_dosp=0
           exit
   endcase &&
enddo
on key
return
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc menuu
para ij
   save scre to scrspr
   *set color to w/n
   *@  9+ij,41 fill to 14+ij,70 colo n+/n
   @  9+ij,21 fill to 14+ij,48 colo sche  5
   *set color to w+/w
   @  8+ij,20,13+ij,46 box box1  colo sche  10
   *set color to n/w,n/g
   @  9+ij,22  prompt ' ��ᬮ�� �ࠢ�筨�� '
   @ 10+ij,22  prompt ' ���ᥭ�� ���������   '
   @ 11+ij,22  prompt ' �����               '
   @ 12+ij,22  prompt ' ��室                '
   menu to menu_dosp
   rest scre from scrspr
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
Proc V_dosp                              && �롮� �ࠢ-��
para opc
sele 1
set order to ivi
set filt to vid=a.and.kod=0
go top
ttl=im
define window w1 from 2,9 to 22,76 title ttl double close colo sche 10
set filt to Vid=a .and. Kod # 0
go top
acti wind w1
if opc=1                && ��������
   brow fiel kod:H='���',im:H='H�����������',sim:H='����.����.',us,obor noedit
   rele wind w1
else                    && �������������
   SET CURSOR ON
   on key label Enter do Ins_dosp with 1,13
   on key label Del do Del_dosp
   on key label Ins do Ins_dosp with 1,22
   brow fiel kod:H='���',im:H='H�����������',sim:H='����.����.',us,obor  noedit
   rele wind w1
   on key
endif
on key
sele 1
set filt to
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc Ins_dosp
para ii,keykl
a=iif(ii=2,2,a)
*deac wind w3
do while .t.
   on key
   if keykl=13
      defi wind w31 from 16,5 to 21,75 double shad colo gr+/b  title '���४�஢��'
   else
      defi wind w31 from 16,5 to 21,75 double shad colo gr+/b title '���� ����� �����'
   endif
   acti wind w31
   @ 0,1 say ' ���     H�����������                     ����.����.       ���.��.'
   @ 2,1 say ' '
   set cursor on
   if keykl=13           && ���४�஢��
      scat memv
   else              && ��� ����� �����
      sele 1
      set order to ivk
      set key to
      go bott
      maxkod=kod
      scat memv blan
      set order to ivi
      m.kod=maxkod+1
   endif
   @ 1,0  get m.kod pict '9999'
   @ 1,5  get m.im
   @ 1,36 get m.sim
   @ 1,60 get m.us pict '999.99'
   @ 2,1  get m.obor
   read
   if last()=27
           if ii=1
              on key label Ins do Ins_dosp with 1,22
              on key label Del do Del_dosp
              on key label Enter do Ins_dosp with 1,13
           else
              on key label F7 do Find with 4
              on key label Ins do Ins_dosp with 2,22
              on key label Enter do ppp
           endif
      exit
   endif
   *set color to gr+/b,gr+/g
   @ 3,2  prom '����� � ����       '
   @ 3,24 prom '������ �� ���������'
   @ 3,46 prom '��室               '
   menu to m
   if last()=27
           if ii=1
              on key label Ins do Ins_dosp with 1,22
              on key label Del do Del_dosp
              on key label Enter do Ins_dosp with 1,13
           else
              on key label F7 do Find with 4
              on key label Ins do Ins_dosp with 2,22
              on key label Enter do ppp
           endif
      exit
   endif
   do case
      case m=1                       && ����� � ����
           if keykl<>13
              append blank
           endif
           m.vid=a
           gath memv
           if ii=1
              on key label Ins do Ins_dosp with 1,22
              on key label Del do Del_dosp
              on key label Enter do Ins_dosp with 1,13
           else
              on key label F7 do Find with 4
              on key label Ins do Ins_dosp with 2,22
              on key label Enter do ppp
           endif
           exit
      case m=2                      && ������ �� ���४�஢��
           gath memv
           if ii=1
              on key label Ins do Ins_dosp with 1,22
              on key label Del do Del_dosp
              on key label Enter do Ins_dosp with 1,13
           else
               on key label F7 do Find with 4
               on key label Ins do Ins_dosp with 2,22
               on key label Enter do ppp
           endif
      case m=3                       && �⬥��
           if ii=1
              on key label Ins do Ins_dosp with 1,22
              on key label Del do Del_dosp
              on key label Enter do Ins_dosp with 1,13
           else
              on key label F7 do Find with 4
              on key label Ins do Ins_dosp with 2,22
              on key label Enter do ppp
           endif
           exit
   endcase
enddo
set cursor off
rele wind w31
*on key
return
*---End of Ins_dosp --------------------------------------------*
Proc Del_dosp
on key
dl=0
r=recno()
defi wind w3 from 18,5 to 21,75 double shad colo gr+/b
acti wind w3
@ 0,1 say' ���     H�����������                   ����.����.'
@ 1,0   say  kod
@ 1,10  say  im
@ 1,41  say  sim
defi wind del from 13,19 to 16,45 in screen double colo gr+/b
acti wind del
@ 0,1 say '������ �㤥� 㤠����'
*set color to gr+/r,gr+/b
@ 1,2 prompt '  ��   '
@ 1,16 prompt' H��   '
menu to ss
do case
   case ss=2
        delete
        on key label Del do Del_dosp
        on key label Ins do Ins_dosp with 1,22
        on key label Enter do Ins_dosp with 1,13
        dl=1
   case ss=1
        on key label Ins do Ins_dosp with 1,22
        on key label Del do Del_dosp
        on key label Enter do Ins_dosp with 1,13
endcase
deac wind del,w3
return
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc avar
acti wind avr
@ 0,1 say  'H�� �ࠢ�筨�� '+namfil
@ 1,1  say '������� ���������� ! ! !    '
@ 2,1  say 'H����� ���� �������...     '
k=inkey(0)
deac wind avr
cancel
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
