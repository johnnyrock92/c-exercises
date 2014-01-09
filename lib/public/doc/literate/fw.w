% --------------------------------------------------------------------
% This file is part of CWEB-NLS.
% It is distributed WITHOUT ANY WARRANTY, express or implied.
%
% Copyright (C) 2002 W{\l}odek Bzyl
% --------------------------------------------------------------------
\getCVSrevision$Revision: 1.1 $
\getCVSdate$Date: 2004/09/30 11:26:56 $
\getCVSsource$Source: /var/cvs/wyklady/JP1-L/80-ProgramowanieOpisowe/fw.w,v $
% --------------------------------------------------------------------

% Strona tytu�owa --

\def\title{FW}
\def\topofcontents{\null\vfill
  \centerline{\titlefont ZLICZANIE S��W}
  \vskip 15pt
  \centerline{(wersja \CVSrevision)}
  \vskip1in
  \vfill}
\def\botofcontents{\parskip=0pt \parindent=0pt
  \vskip 0pt plus 1filll
  Copyright \copyright\ 2002 W�odek Bzyl
  \bigskip
  Jest to wersja programu autorstwa R.~Haighta
  z~ksi��ki B.~W. Kernighana, D.~M. Ritchiego, {\it J�zyk ANSI C}.
  Program ten korzysta z~{\it locales}.
  Oznacza to, �e s�owa zostan� wypisane w~porz�dku alfabetycznym
  w�a�ciwym dla j�zyka ustalonego przez zmienn� �rodowiskow�
  {\tt LANG}.
  \bigskip
  \line{\tt\CVSsource\hfil\CVSdate}\par}

\secpagedepth=2 % sekcje `@@*1' nie b�d� zaczyna� si� od nowej strony

\begingroup \catcode`\!=\active
  \global\def!{\char`\| }
\endgroup
\def\commandline{\begingroup
  \catcode`\!=\active \catcode`\_=12
  \xcommandline}
\def\xcommandline #1{\medbreak
  \leftline{\hskip5em#1}\endgroup
  \medskip}

\def\FW/{{\tt fw\spacefactor1000}}
\def\GCC/{{\mc GCC\spacefactor1000}}
\def\Info/{{\mc INFO\spacefactor1000}}
\def\AnsiC/{{\mc ANSI C\spacefactor1000}}
\def\ASCII/{{\mc ASCII\spacefactor1000}}

% Polskie litery w nazwach zmiennych
\noatl % nie sk�adaj poni�szych linijek
@l b1 xa
@l e6 xc
@l ea xe
@l b3 xl
@l f1 xn
@l f3 xo
@l b6 xs
@l bc xx
@l bf xz
@l a1 xA
@l c6 xC
@l ca xE
@l a3 xL
@l d1 xN
@l d3 xO
@l a6 xS
@l ac xX
@l af xZ

\input epsf.tex

@* Wst�p.
   Przedstawiany tu program po wczytaniu tekstu ze standardowego
wej�cia wypisuje uporz�dkowan� alfabetycznie list� s��w wraz z~liczb�
ich wyst�pie� w~podanym tek�cie.  Przez {\it s�owo\/} rozumiemy ka�dy
napis z�o�ony z~liter oddzielony od innych napis�w znakiem nie b�d�cym
liter�. Wielkie i~ma�e litery nie b�d� rozr�niane.

Program \FW/ mo�na wykorzysta� do wyszukiwania najcz�ciej
wyst�puj�cych s��w. Wykonanie poni�szego polecenia spowoduje
wypisanie na ekranie monitora dziesi�ciu linii zawieraj�cych
najcz�ciej wyst�puj�ce s�owa w~tek�cie tego programu:
  \commandline{\tt fw < fw.w ! sort +0nr ! head -n10}
@.sort, {\rm program}@>
@.head, {\rm program}@>
@^s�owo, definicja@>
@^u�ycie {\tt fw}, przyk�ad@>

@ Program czyta tekst, po jednym wierszu, ze |stdin| przy pomocy
  funkcji |getline|. Funkcja ta nie nale�y do standardowej
biblioteki I/O (wej�cia/wyj�cia). Nale�y ona do biblioteki I/O
kompilatora \GCC/. U�ywam tej funkcji poniewa� umo�liwia ona
wczytywanie dowolnie d�ugich wierszy tekstu.

Napisy por�wnywane s� przez funkcj� |strcoll|. Funkcja ta,
por�wnuj�c napisy stosuje kolejno�� znak�w j�zyka
okre�lonego zmienn� �rodowiskow� {\tt LANG}. Aby program
\FW/ zaliczy� polskie znaki diakrytyczne do liter i~s�owa zosta�y
wypisane wed�ug porz�dku alfabetycznego obowi�zuj�cego w~Polsce,
wystarczy przed uruchomieniem tego programu ustawi� zmienn�
|LANG| tak, aby wskazywa�a j�zyk polski:
\commandline{\tt export LANG=pl_PL}
\noindent albo uruchamiamy program w~taki oto spos�b:
\commandline{\tt LANG=pl_PL \ cat \hbox{$\langle$\it nazwa pliku\/$\rangle$} ! fw}
W~programie korzystam z~kilkunastu funkcji, kt�rych
prototypy zawarte s� w~standardowych plikach nag��wkowych.

@.LANG, {\rm zmienna �rodowiskowa}@>

@d _GNU_SOURCE /* zdefiniuj |getline| */

@c
#include <stdio.h>
	 /* zawiera deklaracj� funkcji |getline| */
#include <stdlib.h> /* |malloc|, |EXIT_SUCCESS| */
#include <limits.h> /* |UCHAR_MAX| */
#include <locale.h> /* |setlocale| -- wp�ywa na dzia�anie
	    poni�szych funkcji */
#include <ctype.h>  /* |isupper|, |islower|, |tolower| */
#include <string.h> /* |strcoll|, |strtok| */

@* Drzewa binarne. \begingroup\hangindent=-2.5in \hangafter=3
   Wczytywane s�owa s� na bie��co wstawiane do drzewa
binarnego. Zanim powstanie wierzcho�ek z~nowo wczytanego s�owa
zostanie ono por�wnane ze s�owem uprzednio wstawionym
do~korzenia. Je�li nowe s�owo jest alfabetycznie mniejsze od
por�wnywanego s�owa, to operacja wstawiania zostanie zastosowana
rekurencyjnie do lewego poddrzewa. Je�li jest wi�ksze, to do prawego
poddrzewa. Je�li jest r�wne s�owu por�wnywanemu to licznik jego wyst�pie�
w~wczytywanym tek�cie zostanie zwi�kszony o~1.%
  \vadjust{\medskip}\hfil\break
  \indent Obok przedstawiono drzewo binarne zdania z~ksi��ki
  S.~J. Leca, {\it My�li nieuczesane\/}: ,,Chocia� krowie dasz
  kakao, nie wydoisz czekolady.''%
  \vadjust{\medskip}\hfil\break
  {\it Uwaga\/}: W~j�zyku \CEE/ nie dopuszcza si�, aby struktura by�a
definiowana rekurencyjnie inaczej ni� za pomoc� wska�nik�w do siebie
samej.
  \medskip
  \rightline{\smash{\epsffile{fw.1}}}
  \vskip-\bigskipamount
  \endgroup
\labsec{sec:drzewa_binarne}
@^Lec SJ@>

@c
struct wierzcho�ek
{
  char *s�owo;
  int liczba_wyst�pie�;
  struct wierzcho�ek *lewe_poddrzewo;
  struct wierzcho�ek *prawe_poddrzewo;
};

@ @<Zmienne lokalne funkcji main@>=
struct wierzcho�ek *korze� = NULL;

@*1 Utworzenie i inicjalizacja nowego wierzcho�ka.
    Je�li zabraknie pami�ci na nowy wierzcho�ek to program \FW/ ko�czy
dzia�anie. Je�li miejsce jest, to kopiujemy wczytane s�owo |s|
z~bufora w~nowe miejsce w~pami�ci. Gdyby�my tego nie zrobili, to
nast�pne wywo�anie funkcji |getline| umie�ci�oby w~buforze now� lini�,
zamazuj�c tym samym poprzedni� zawarto�� zawieraj�c� s�owo |s|.

@c
struct wierzcho�ek *nowy_wierzcho�ek(char *s)
{
  struct wierzcho�ek *w = malloc(sizeof(struct wierzcho�ek));

  if (w==NULL)
    @<Zako�cz dzia�anie komunikatem o braku pami�ci@>@;
  w->s�owo=strdup(s);
  if (w->s�owo==NULL)
    @<Zako�cz dzia�anie komunikatem o braku pami�ci@>@;
  w->liczba_wyst�pie�=1;
  w->lewe_poddrzewo=w->prawe_poddrzewo=NULL;

  return w;
}

@*1 Wstawianie wierzcho�k�w do drzewa.
    Funkcja |wstaw_wierzcho�ek| jest rekurencyjna. Je�li wczytywany
ci�g s��w jest ju� cz�ciowo uporz�dkowany, to budowane drzewo ma
ma�o rozga��zie� i~ro�nie w~d� bardzo nisko (tak rosn� drzewa
w~RAM). R�wnie� w~takiej sytuacji, drzewo ro�nie coraz wolniej,
poniewa� funkcja |wstaw_wierzcho�ek| b�dzie przegl�da� wi�kszo��
wierzcho�k�w drzewa zanim wstawi nowy wierzcho�ek.

@c
struct wierzcho�ek *wstaw_wierzcho�ek(struct wierzcho�ek *w, char *s)
{
  int wynik_por�wnania;

  if (w==NULL)
    w=nowy_wierzcho�ek(s);
  else if ((wynik_por�wnania=strcoll(s,w->s�owo))==0)
    w->liczba_wyst�pie�++;
  else if (wynik_por�wnania<0)
    w->lewe_poddrzewo=wstaw_wierzcho�ek(w->lewe_poddrzewo,s);
  else
    w->prawe_poddrzewo=wstaw_wierzcho�ek(w->prawe_poddrzewo,s);

  return w;
}

@*1 Drukowanie s��w wstawionych do drzewa w~porz�dku alfabetycznym.
   Funkcja rekurencyjna |inorder_print| wypisze s�owa wyst�puj�ce
w~wierzcho�kach w~porz�dku alfabetycznym okre�lonym przez
kolejno�� liter alfabetu j�zyka ustalonego przez zmienn� �rodowiskow�
{\tt LANG}. Jest tak, poniewa� dla ka�dego wierzcho�ka, s�owa
wyst�puj�ce w~jego lewym poddrzewie s� mniejsze alfabetycznie od s�owa
wyst�puj�cego w~wierzcho�ku, a~ono samo jest mniejsze od wszystkich
s��w wyst�puj�cych w~jego prawym poddrzewie
(zob. rysunek w~sekcji~\refsec{sec:drzewa_binarne}).
@.LANG, {\rm zmienna �rodowiskowa}@>

@c
void inorder_print(struct wierzcho�ek *w)
{
  if (w!=NULL) {
    inorder_print(w->lewe_poddrzewo);
    printf("%9d %s\n",w->liczba_wyst�pie�,w->s�owo);
    inorder_print(w->prawe_poddrzewo);
  }
}

@ Przed umieszczeniem s�owa w~drzewie zamieniamy wielkie litery na ma�e.

@c
char *lowercase(char *s)
{
  char *c = s;

  while (isupper(*c)) {
    *c=tolower(*c);
    c++;
  }
  return s;
}

@ Jest mo�liwe, by ten program zachowywa� si� sensowniej, ni� tylko
  ko�cz�c dzia�anie w~tym miejscu -- patrz dokumentacja \Info/ do
biblioteki {\tt libc} w�ze�: {\it Basic Allocation}.

@<Zako�cz dzia�anie komunikatem o braku pami�ci@>=
{
  fprintf(stderr, "! Virtual memory exhausted.\n");
  exit(1);
}

@* Funkcja g��wna.
   G��wna cz�� programu to p�tla |while|, w~kt�rej tekst ze
|stdin| wczytywany jest przez funkcj� |getline| do |bufora_p|.
Z~wczytanego wiersza kolejne s�owa oddzielane s� przez |strtok|
i~wstawiane na bie��co do drzewa binarnego przez funkcj�
|wstaw_wierzcho�ek|. Po wczytaniu ostatniego wiersza ze |stdin|,
funkcja |inorder_print| wypisze wszystkie przeczytane s�owa wraz
z~liczb� ich wyst�pie�.

@.LANG, {\rm zmienna �rodowiskowa}@>

@c
int main ()
{
  @<Zmienne lokalne funkcji main@>@;@#

  @<Ustal j�zyk na podstawie warto�ci zmiennej �rodowiskowej |LANG|@>@;
  @<Utw�rz |ogranicznik| dla funkcji |strtok|@>@;@#

  while (getline(&bufor_p,&d�ugo��_bufora,stdin)!=-1) {
    while ((nast�pne_s�owo=strtok(bufor_p,ogranicznik))!=NULL) {
      korze�=wstaw_wierzcho�ek(korze�,lowercase(nast�pne_s�owo));
      bufor_p=NULL; /* dlaczego |NULL| -- patrz strona
		       podr�cznika po�wi�cona |strtok| */
    }
  }

  inorder_print(korze�);

  return EXIT_SUCCESS;
}

@ Je�li przed wywo�aniem |getline| nadamy zmiennym |bufor_p|
  i~|d�ugo��_bufora| warto�� |0|, to funkcja sama przydzieli
sobie pami�� na bufor i~adres pocz�tku bufora umie�ci w~|bufor_p|.
Napotykaj�c koniec pliku |getline| zwraca warto�� $-1$.

@<Zmienne lokalne funkcji main@>=
char *bufor_p = 0;
size_t d�ugo��_bufora = 0;

@ Wywo�anie |setlocale| z drugim argumentem b�d�cym pustym
napisem spowoduje, �e funkcje: |isupper|, |islower|, |tolower|
i~|strcoll| b�d� korzysta� z~danych lokalnych ({\it locale data})
ustalonych przez zmienn� �rodowiskow� {\tt LANG}.
@.LANG, {\rm zmienna �rodowiskowa}@>

@<Ustal j�zyk na podstawie warto�ci zmiennej �rodowiskowej |LANG|@>=
setlocale(LC_CTYPE,""); /* wczytaj kody wielkich i ma�ych liter */
setlocale(LC_COLLATE,""); /* wczytaj dane dotycz�ce porz�dku alfabetycznego */

@ Kolejne wywo�ania |strtok| oddzielaj� od pocz�tku bufora |bufor_p|
  napisy rozdzielone znakami umieszczonymi w~tablicy |ogranicznik|.
Tablica ta zawiera tylko znaki nie b�d�ce znakami alfanumerycznymi.

@<Utw�rz |ogranicznik| dla funkcji |strtok|@>=
for (i=1,k=0; i<=UCHAR_MAX; i++)@+if (!isalnum(i)) ogranicznik[k++]=i;
ogranicznik[k]='\0';

@ Pozostaje jeszcze tylko zadeklarowa� kilka zmiennych i~program jest
  gotowy. ,,To by by�o na tyle'' jak mawia prof.~Stanis�awski.

@^Stanis�awski JT, profesor@>

@<Zmienne lokalne funkcji main@>=
unsigned int i,k; /* liczniki p�tli */
char ogranicznik[UCHAR_MAX]; /* argument |delim| w~|strtok| */
char *nast�pne_s�owo;

@* Skorowidz.
   Poni�ej znajdziesz list� identyfikator�w u�ytych w~programie
\.{hello.w}. Liczba wskazuje na numer sekcji, w~kt�rej u�yto identyfikatora,
a~liczba podkre�lona --- numer sekcji w~kt�rej zdefiniowano identyfikator.
