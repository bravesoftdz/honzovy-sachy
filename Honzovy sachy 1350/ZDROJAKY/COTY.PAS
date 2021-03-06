unit CoTy; {CoTy znamen� Const Type}
{26.6. 1998 12:00 Vznik souboru (modifikac� zdrojov�ho k�du m�ho programu
                  v Turbo Pascalu)}
interface
const
 nic=0;{pr�zdn� pol��ko}
{b�l�}
 pesec=1;
 jezdec=2;
 strelec=3;
 vez=4;
 dama=5;
 kral=6;
{�ern� = - b�l�}
{Tyto konstanty slou�� pouze pro zp�ehledn�n�. Nen� mo�n� je modifikovat !!}
 type TSch=array[0..7,0..7] of shortint;{ve smyslu a..h, 1..8}
      TMoznosti=(mrb,vrb,mrc,vrc,hb);
{mrb = bude moci b�l� d�lat malou ro��du (tj. nepohnul v�� na a1 ani kr�lem
a nebyla v� na a1 sebran� ?)
vrb, mrc, vrc jsou analogie pro �ern�ho nebo/a velkou ro��du}
{hb = je b�l� na tahu}
      TStav=record
       b:set of Tmoznosti;
       mimoch:shortint;{na jak�m sloupci hr�l p�edt�m p�cem o 2 ?
       (kv�li bran� mimochodem)}
      end;
const ne_mimochodem=100; {norm�ln�ln� hodnota TStav.mimoch}
type  Tpozice=record
       sch:tsch;
       stav:tstav
      end;

TTah1=record{pam�ov� �sporn� verze tahu, neobsahuje dost informace
pro vr�cen� tahu => nejde pou��t p�i propo�tu,
pou��v�m p�i hled�n� tah�, tady je ka�d� u�et�en� byte dobr�}
       p1,p2:byte;{p1=odkud.x+16*odkud.y, p2=kam.x+kam.y*16}
       promena:shortint;{Obsahuje typ v�sledn� figury, tj. norm�ln� figuru,
       kterou se t�hlo, vyj�mka p�i prom�n� p�ce
       jin�mi slovy: co bude na poli p2 po proveden� tahu}
      end;
 {P��klad: e7-e8D
p1=odkud.x+16*odkud.y=4+6*16
p2=kam.x+16*kam.y=4+7*16
prom�na = b�l� d�ma = + dama = 5}
 TTah2=record {pou��v�n p�i vracen� tah�}
       p1,p2:byte;
       promena:shortint;
       bere:shortint;{=co bylo na p2 p�ed proveden�m tahu
    pozor, bran� mimochodem te�  nen� bran�
    (nebo� beroc� p�ec jde na pr�zdn� pol��ko)}
       stav:tstav;{stav pozice p�ed t�mto tahem}
      end;
{ tdejtah=function(pos:tpozice;var t:ttah1):byte;}
const maxtah=200; {kolik nejv�c tah� p�ipou�t�m z jedn� pozice}
type TTahy=record {struktura pro z�znam v�ce tah� z jedn� pozice}
      poctah: 0..maxtah; {kolik tah� tam je}
      t:array[1..maxtah] of ttah1; {tady jsou ulo�en�}
{      stav:tstav}
     end;
 const zakladni_postaveni:tpozice=

 (Sch:
 ((4,1,0,0,0,0,-1,-4),
  (2,1,0,0,0,0,-1,-2),
  (3,1,0,0,0,0,-1,-3),
  (5,1,0,0,0,0,-1,-5),
  (6,1,0,0,0,0,-1,-6),
  (3,1,0,0,0,0,-1,-3),
  (2,1,0,0,0,0,-1,-2),
  (4,1,0,0,0,0,-1,-4));
   stav:(b:[mrb,vrb,mrc,vrc,hb];mimoch:ne_mimochodem));
 Type
 ppartie=^tpartie;{obousm�rn� spoj�k tah�}
  tpartie=record
   l,r:ppartie;
   t2:ttah2;
  end;
 PJednoPartie=^TJednoPartie;
 TJednoPartie=record
  t2:ttah2;
  l:PJednoPartie
 end;
{Jednosm�rn� spoj�k partie z�kladn�_postaven�<-tah1 <- tah2 <- .... <- mat
 nem� (narozd�l od TPartie) nevyu�it� nejlev�j�� �len}
{N�sleduj� typ hojn� u��van� v heuristik�ch statick� ohodnocovac� funkce
mysl�c�ho algoritmu.}
thodnoty64=array[0..7,0..7] of integer;
Tcenyfigur=array[1..5] of integer;
TAlgCfg=record {Konfigurace statick� ohodnocovac� funkce}
 PouzitKnihovnu,
 MysletDopredu:Boolean;
 NormHorsiTahy,
 DoprHorsiTahy,
 Nedeterminismus,
 okno:integer;
 cenyfigur:tcenyfigur;
 NormalniPesciVePredu,
 VolniPesciVePredu,
 KrytiPesciVePredu,
 VolniAKrytiPesciVePredu:array[1..6] of integer;
 Dvojpech,Izolant,Volny,Kryty,VolnyAKryty,VedleKolegy,
 VezNaSloupci,DvojiceStrelcu, ZnicenaRosada, KralOdStredu,KralOdKrale,
 MaticiDama:integer;
 pesci, jezdci, strelci, kral:thodnoty64;
end;
const
DefAlgCfg:TAlgCfg=(
 PouzitKnihovnu:true;
 MysletDopredu:true;
 NormHorsiTahy:30;
 DoprHorsiTahy:100;
 Nedeterminismus:20;
 okno:250;
 cenyfigur:(1000,3200,3300,5500,9500);
 NormalniPesciVePredu:(-20,20,100,150,250,1500);
 VolniPesciVePredu:(-20,50,150,250,350,1500);
 KrytiPesciVePredu:(-20,50,100,200,270,1500);
 VolniAKrytiPesciVePredu:(-20,50,350,1000,1500,2500);
 Dvojpech:-200;
 Izolant:-100;
 Volny:100;
 Kryty:100;
 VolnyAKryty:250;
 VedleKolegy:80;
 VezNaSloupci:100;
 DvojiceStrelcu:300;
 ZnicenaRosada:-300;
 KralOdStredu:-100; {Z pozice mat�n�ho}
 KralOdKrale:60; {Z pozice mat�n�ho}
 MaticiDama:200; {Z pozice mat�c�ho}
 pesci:
((0   ,10  ,20  ,-200,-150,100 ,200 ,0   ),
 (0   ,20  ,10  ,-150,-100,100 ,200 ,0   ),
 (0   ,0   ,-50 ,200 ,150 ,100 ,200 ,0   ),
 (0   ,0   ,50  ,250 ,250 ,100 ,200 ,0   ),
 (0   ,0   ,50  ,250 ,250 ,100 ,200 ,0   ),
 (0   ,0   ,-300,0   ,0   ,100 ,200 ,0   ),
 (0   ,20  ,10  ,-250,-150,100 ,200 ,0   ),
 (0   ,10  ,20  ,-200,-100,100 ,200 ,0   )
 );
 jezdci:
((-300,-200,-100,-50 ,0   ,0   ,0   ,-150),
 (-100,-150,-50 ,0   ,120 ,120 ,0   ,0   ),
 (-150,50  ,100 ,80  ,150 ,150 ,150 ,0   ),
 (-50 ,0   ,70  ,200 ,250 ,250 ,250 ,50  ),
 (-50 ,0   ,70  ,200 ,250 ,250 ,250 ,50  ),
 (-150,50  ,100 ,80  ,150 ,150 ,150 ,0   ),
 (-100,-150,-50 ,0   ,120 ,120 ,0   ,0   ),
 (-300,-200,-100,-50 ,0   ,0   ,0   ,-150)
 );

 strelci:
((0   , 20  ,-20  ,50  ,50  ,20  ,-10 ,-30 ),
 (-20 , 200 ,-20  ,20  ,200 ,30  ,20  ,-30 ),
 (0   , -20 ,-20  ,200 ,50  ,50  ,40  ,-20 ),
 (-200, 100 ,-100 ,20  ,50  ,70  ,60  ,-20 ),
 (-200, 100 ,-100 ,20  ,50  ,70  ,60  ,-20 ),
 (0   , -20 ,-20  ,200 ,50  ,50  ,40  ,-20 ),
 (-20 , 200 ,-20  ,20  ,200 ,30  ,20  ,-30 ),
 (0   , 20  ,-20  ,50  ,50  ,20  ,-10 ,-30 )
 );

 kral:
((100 ,0   ,-500,-1000,-1000,-1000,-1000,-1000),
 (450 ,-200,-500,-1000,-1000,-1000,-1000,-1000),
 (400 ,-300,-500,-1000,-1000,-1000,-1000,-1000),
 (0   ,0   ,-500,-1000,-1000,-1000,-1000,-1000),
 (0   ,0   ,-500,-1000,-1000,-1000,-1000,-1000),
 (0   ,-300,-500,-1000,-1000,-1000,-1000,-1000),
 (500 ,-200,-500,-1000,-1000,-1000,-1000,-1000),
 (100 ,0   ,-500,-1000,-1000,-1000,-1000,-1000)
 )
 );
Type
string2=string[2];
string10=string[10];
string22=string[22];
string30=string[30];
string80=string[80];
const
 JS_BAlgCfg='BILYALG.CFG';
 JS_CAlgCfg='CERNYALG.CFG';
implementation
end.
