#!/usr/bin/perl
# rfc2231-pruefen.pl - misst den RFC-2231-Zerleger aus AN-1, Teil 5.
#
#   perl tools/rfc2231-pruefen.pl
#   perl tools/rfc2231-pruefen.pl --behalten   # den erzeugten C++-Quelltext lassen
#
# Warum es dieses Werkzeug gibt: RFC2231Entschluesseln und
# RFC2231Zusammensetzen entscheiden, ob ein Anhang seinen vollen Namen und
# seine Endung behaelt. Beides steckt in QCUtils.dll und ist damit nur an
# einem Windows-Rechner mit Visual Studio messbar - ausser so.
#
# Das Werkzeug zieht die beiden Funktionen WOERTLICH aus
# Eudora71/QCUtils/src/rfc2231.cpp heraus, per Textanker und nicht per
# Zeilennummer, haengt eigene Prueffaelle an und uebersetzt das Ganze mit
# g++ (oder cl). Gemessen wird also der ausgelieferte Code, keine Abschrift.
#
# Nicht gemessen: RFC2231ZeichensatzUmsetzen. Das ruft MultiByteToWideChar
# und gehoert damit an Gregors Rechner.
#
# rc=0, wenn alle Faelle stimmen. Sonst rc=1.

use strict;
use warnings;

my ($behalten);
for my $a (@ARGV) {
  if    ($a eq '--behalten') { $behalten = 1 }
  else  { die "unbekannter Schalter: $a\n" }
}

my $wurzel = $0;
$wurzel =~ s{[\\/]tools[\\/][^\\/]+$}{};
$wurzel = '.' if $wurzel eq $0 || $wurzel eq '';

my $quelldatei = "$wurzel/Eudora71/QCUtils/src/rfc2231.cpp";
open my $qh, '<', $quelldatei or die "$quelldatei: $!\n";
my $quelle = do { local $/; <$qh> };
close $qh;

# ---------------------------------------------------------------------------
# Herausziehen, per Anker. Bricht ab, wenn ein Anker fehlt - dann hat sich
# der Quelltext bewegt und das Werkzeug darf NICHT stumm durchlaufen.
# ---------------------------------------------------------------------------
sub stueck {
  my ($von, $bis, $was) = @_;
  my $i = index($quelle, $von);
  die "Anker fehlt in $quelldatei: '$was' ($von)\n" if $i < 0;
  my $j = index($quelle, $bis, $i);
  die "Ende fehlt in $quelldatei: '$was' ($bis)\n" if $j < 0;
  return substr($quelle, $i, $j - $i);
}

# Der Typ des Suchers kommt aus dem Kopf, damit er nicht auseinanderlaeuft.
my $kopfdatei = "$wurzel/Eudora71/QCUtils/public/inc/rfc2231.h";
open my $kh, '<', $kopfdatei or die "$kopfdatei: $!\n";
my $kopfquelle = do { local $/; <$kh> };
close $kh;
my ($typdef) = $kopfquelle =~ /^(typedef const char\* \(\*RFC2231Sucher\).*;)$/m;
die "typedef RFC2231Sucher nicht in $kopfdatei gefunden\n" unless $typdef;

my $hex   = stueck("static int RFC2231Hex(const char* s)",
                   "//\tLoest ein einzelnes Stueck", 'RFC2231Hex');
my $entsch= stueck("int RFC2231Entschluesseln(const char* pWert",
                   "//\tSetzt alle Stuecke zusammen", 'RFC2231Entschluesseln');
my $zus   = stueck("int RFC2231Zusammensetzen(const char* pName",
                   "//\tSetzt einen UTF-8-Namen", 'RFC2231Zusammensetzen');

printf "uebernommen: %d Zeilen RFC2231Hex, %d Zeilen Entschluesseln, %d Zeilen Zusammensetzen\n",
  scalar(split /\n/, $hex), scalar(split /\n/, $entsch), scalar(split /\n/, $zus);

# ---------------------------------------------------------------------------
# Die Prueffaelle
# ---------------------------------------------------------------------------
my $treiber = <<'TREIBER';

// ---------------------------------------------------------------------------
// Prueffaelle. soll = was herauskommen MUSS.
// ---------------------------------------------------------------------------
static int fehler = 0;
static int faelle = 0;

static void zeigeSichtbar(const char* s)
{
	for (; *s; ++s)
	{
		unsigned char c = (unsigned char)*s;
		if (c < 32 || c > 126) printf("<%02X>", c);
		else                   putchar((char)c);
	}
}

static void einStueck(const char* was, const char* wert, BOOL kodiert,
					  const char* soll, const char* sollZS)
{
	char ziel[256], zs[32];
	int n = RFC2231Entschluesseln(wert, kodiert, ziel, sizeof(ziel), zs, sizeof(zs));
	int ok = (n >= 0) && strcmp(ziel, soll) == 0 && strcmp(zs, sollZS) == 0;
	faelle++;
	if (!ok) fehler++;
	printf("%-5s %-34s -> [", ok? "ok" : "FEHL", was);
	zeigeSichtbar(ziel);
	printf("] zs=[%s] n=%d\n", zs, n);
	if (!ok) printf("      soll [%s] zs=[%s]\n", soll, sollZS);
}

// Eine kleine Parameterliste als Attrappe fuer den Sucher.
struct Paar { const char* name; const char* wert; };
static const char* ausTabelle(void* pZusatz, const char* pName)
{
	const Paar* p = (const Paar*)pZusatz;
	for (; p->name; ++p)
		if (stricmp(p->name, pName) == 0)
			return p->wert;
	return 0;
}

static void ganz(const char* was, const Paar* tabelle, const char* gesucht,
				 const char* soll, const char* sollZS)
{
	char ziel[256], zs[32];
	int n = RFC2231Zusammensetzen(gesucht, ausTabelle, (void*)tabelle,
								  ziel, sizeof(ziel), zs, sizeof(zs));
	int ok;
	if (!*soll)
		ok = (n < 0);				// soll leer heisst: darf nichts finden
	else
		ok = (n > 0) && strcmp(ziel, soll) == 0 && strcmp(zs, sollZS) == 0;
	faelle++;
	if (!ok) fehler++;
	printf("%-5s %-34s -> [", ok? "ok" : "FEHL", was);
	if (n >= 0) zeigeSichtbar(ziel);
	printf("] zs=[%s] n=%d\n", n >= 0? zs : "", n);
	if (!ok) printf("      soll [%s] zs=[%s]\n", soll, sollZS);
}

int main()
{
	printf("\nEin Stueck (RFC2231Entschluesseln)\n");
	einStueck("einfach kodiert", "UTF-8''Angebot%20Nr%204711.pdf", TRUE,
			  "Angebot Nr 4711.pdf", "UTF-8");
	einStueck("mit Sprachangabe", "iso-8859-1'de'Gr%FC%DF" "e.pdf", TRUE,
			  "Gr\xFC\xDF" "e.pdf", "iso-8859-1");
	einStueck("Folgestueck ohne Vorspann", "Nr%204711.pdf", TRUE,
			  "Nr 4711.pdf", "");
	einStueck("ohne * bleibt woertlich", "Angebot%20Nr.pdf", FALSE,
			  "Angebot%20Nr.pdf", "");
	einStueck("leerer Zeichensatz", "''Angebot.pdf", TRUE, "Angebot.pdf", "");
	einStueck("Prozent am Ende", "Preis%", TRUE, "Preis%", "");
	einStueck("Prozent ohne Hexpaar", "100%ig.pdf", TRUE, "100%ig.pdf", "");
	einStueck("leerer Wert", "", TRUE, "", "");
	einStueck("nur die Endung", "UTF-8''%2Epdf", TRUE, ".pdf", "UTF-8");

	{
		char ziel[8], zs[32];
		int n = RFC2231Entschluesseln("UTF-8''viel%20zu%20lang", TRUE,
									  ziel, sizeof(ziel), zs, sizeof(zs));
		faelle++;
		if (n != -1) fehler++;
		printf("%-5s %-34s -> n=%d\n", n == -1? "ok" : "FEHL",
			   "zu lang gibt -1", n);

		n = RFC2231Entschluesseln(0, TRUE, ziel, sizeof(ziel), zs, sizeof(zs));
		faelle++;
		if (n != -1) fehler++;
		printf("%-5s %-34s -> n=%d\n", n == -1? "ok" : "FEHL",
			   "NULL gibt -1", n);
	}

	printf("\nZusammengesetzt (RFC2231Zusammensetzen)\n");

	//	Der gemeldete Fall: langer Name, verteilt und kodiert.
	static const Paar verteiltKodiert[] = {
		{ "filename*0*", "UTF-8''Angebot%20Nr%204711%20" },
		{ "filename*1*", "fuer%20die%20Stadtwerke%20Musterstadt%202025.pdf" },
		{ 0, 0 }
	};
	ganz("AN-1: verteilt und kodiert", verteiltKodiert, "filename",
		 "Angebot Nr 4711 fuer die Stadtwerke Musterstadt 2025.pdf", "UTF-8");

	//	Verteilt, aber nicht kodiert - dann bleiben %XX stehen.
	static const Paar verteilt[] = {
		{ "filename*0", "Angebot Nr 4711 " },
		{ "filename*1", "fuer die Stadtwerke.pdf" },
		{ 0, 0 }
	};
	ganz("verteilt, unkodiert", verteilt, "filename",
		 "Angebot Nr 4711 fuer die Stadtwerke.pdf", "");

	//	Ein Stueck mit Stern.
	static const Paar einStern[] = {
		{ "filename*", "UTF-8''Rechnung%202025.pdf" },
		{ 0, 0 }
	};
	ganz("ein Stueck mit Stern", einStern, "filename", "Rechnung 2025.pdf", "UTF-8");

	//	Gemischt: erstes Stueck kodiert, zweites nicht. Kommt vor.
	static const Paar gemischt[] = {
		{ "filename*0*", "UTF-8''Gr%FC%DF" "e%20" },
		{ "filename*1",  "vom Chef.pdf" },
		{ 0, 0 }
	};
	ganz("gemischt kodiert/unkodiert", gemischt, "filename",
		 "Gr\xFC\xDF" "e vom Chef.pdf", "UTF-8");

	//	Luecke: *0 und *2, aber kein *1 - dann ist nach *0 Schluss.
	static const Paar luecke[] = {
		{ "filename*0", "Anfang" },
		{ "filename*2", "Ende.pdf" },
		{ 0, 0 }
	};
	ganz("Luecke bricht ab", luecke, "filename", "Anfang", "");

	//	Faengt bei 1 an statt bei 0 - nach RFC 2231 falsch, also nichts.
	static const Paar abEins[] = {
		{ "filename*1", "Ende.pdf" },
		{ 0, 0 }
	};
	ganz("faengt bei 1 an: nichts", abEins, "filename", "", "");

	//	Gar nichts da.
	static const Paar leer[] = { { "charset", "utf-8" }, { 0, 0 } };
	ganz("kein filename: nichts", leer, "filename", "", "");

	//	Das schlichte filename= interessiert diese Funktion NICHT - das
	//	findet GetAttribute selbst, bevor es hierherkommt.
	static const Paar schlicht[] = { { "filename", "Rechnung.pdf" }, { 0, 0 } };
	ganz("schlichtes filename: nichts", schlicht, "filename", "", "");

	//	Name steht statt filename (Content-Type).
	static const Paar nameStatt[] = {
		{ "name*0*", "UTF-8''Bild%20vom%20Urlaub.jpg" },
		{ 0, 0 }
	};
	ganz("name statt filename", nameStatt, "name", "Bild vom Urlaub.jpg", "UTF-8");

	printf("\n%d Faelle, %d Abweichung(en)\n", faelle, fehler);
	return fehler? 1 : 0;
}
TREIBER

my $kopf = <<'KOPF';
// ERZEUGT von tools/rfc2231-pruefen.pl - nicht von Hand aendern.
//
// RFC2231Hex, RFC2231Entschluesseln und RFC2231Zusammensetzen stammen
// WOERTLICH aus Eudora71/QCUtils/src/rfc2231.cpp. Nur die Attrappen
// darunter sind von diesem Werkzeug.
//
#include <stdio.h>
#include <string.h>

typedef int BOOL;
#define TRUE 1
#define FALSE 0

#if !defined(_WIN32)
#define _snprintf snprintf
#define stricmp strcasecmp
#endif

TYPDEF

KOPF

my $dir = "$wurzel/tools/.rfc2231";
mkdir $dir unless -d $dir;
my $cpp = "$dir/rfc2231.cpp";
open my $fh, '>', $cpp or die "$cpp: $!\n";
$kopf =~ s/^TYPDEF$/$typdef/m or die "TYPDEF-Platzhalter verschwunden\n";
print $fh $kopf, $hex, $entsch, $zus, $treiber;
close $fh;

sub pfad { my $p = shift; return $^O eq 'MSWin32' ? qq{"$p"} : "'" . $p . "'" }

my $exe = "$dir/rfc2231";
my $bau;
if ($^O ne 'MSWin32' && system("g++ --version >/dev/null 2>&1") == 0) {
  $bau = "g++ -w -o " . pfad($exe) . " " . pfad($cpp);
} elsif (system("cl >nul 2>&1") == 0 || $^O eq 'MSWin32') {
  $exe = "$dir/rfc2231.exe";
  $bau = "cl /nologo /w /Fe:\"$exe\" \"$cpp\" /Fo:\"$dir/\"";
} else {
  die "weder g++ noch cl gefunden - ohne Uebersetzer geht es nicht\n";
}

print "baue: $bau\n";
if (system($bau) != 0) {
  die "Uebersetzen fehlgeschlagen. Der Quelltext liegt in $cpp\n";
}

my $rc = system(pfad($exe));
$rc = $rc >> 8 if $rc > 255;

unless ($behalten) {
  unlink $cpp, $exe, "$dir/rfc2231.obj";
  rmdir $dir;
}

exit($rc ? 1 : 0);
