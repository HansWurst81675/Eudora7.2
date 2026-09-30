use strict; use warnings;
#
# Faehrt Lex822State::Lex822() ausserhalb von Eudora und zeigt, was beim
# Empfang aus einem Dateinamen im Anhang wird - ohne Visual Studio, ohne MFC.
#
#   perl tools/kopfzeile-pruefen.pl             # alle Faelle, Kurzfassung
#   perl tools/kopfzeile-pruefen.pl --lang      # zusaetzlich jede einzelne Marke
#   perl tools/kopfzeile-pruefen.pl --vorschlag # mit der vorgeschlagenen Behebung
#   perl tools/kopfzeile-pruefen.pl --behalten  # den erzeugten Quelltext liegen lassen
#
# WARUM ES DIESES WERKZEUG GIBT
#
# Gemeldet war: lange Dateinamen im Anhang kommen abgeschnitten an, und die
# Endung (.pdf) fehlt ganz. Der Weg dorthin ist
#
#   HeaderDesc::Read            header.cpp:77     Zustandsautomat der Kopfzeile
#     Lex822State::Lex822       lex822.cpp:153    zerlegt in Marken (Token)
#   GenericReader::ReadIt       mime.cpp:1634     holt Attribut "filename"
#   OpenAttachFile              mime.cpp:1275     macht daraus einen Dateinamen
#
# Der Fehler sitzt in Lex822(): eine Zeichenkette in Anfuehrungszeichen wird
# am Zeilenumbruch beendet, auch wenn der Umbruch nur eine Faltung ist
# (RFC 5322 2.2.3: CRLF gefolgt von Leerzeichen oder Tabulator gehoert noch
# zur selben Kopfzeile). Alles hinter der Faltung geht verloren - und da steht
# in aller Regel die Endung. Siehe BEFUNDE.md, Befund AN-1.
#
# WIE ES ARBEITET
#
# Die Aufzaehlungen aus lex822.h und die Tabellen samt Lex822() aus lex822.cpp
# werden WOERTLICH in eine Datei uebernommen. Ersetzt sind nur zwei Stuecke:
#   LexFill()          liest aus einer Zeichenkette statt aus dem Netz
#   WriteHeaderToken() schreibt nichts
# Dazu kommt ein Treiber, der die Zustaende aus HeaderDesc::Read nachbildet,
# soweit Content-Disposition sie braucht. Uebersetzt wird mit g++ oder cl.
#
# Weil der Quelltext bei jedem Lauf frisch aus dem Baum geholt wird, kann er
# nicht veralten: wer Lex822() aendert, prueft hier sofort die Wirkung.
#
# DER VORSCHLAG (--vorschlag)
#
# Mit --vorschlag wird die Behebung aus tools/patches/anhangnamen-faltung.md
# VOR dem Uebersetzen in den ausgelesenen Text eingesetzt - der Baum selbst
# bleibt unberuehrt. So laesst sich die Wirkung messen, bevor jemand mit
# Visual Studio sie uebersetzt. Passt der Suchtext nicht mehr, bricht das
# Werkzeug ab statt still das Alte zu messen; das ist der Fall, sobald die
# Behebung wirklich im Baum steht - dann ist --vorschlag ueberfluessig.
#
# MITGEMESSEN WIRD DER RUECKSCHRIEB
#
# WriteHeaderToken (lex822.cpp:402) schreibt jede Marke in die Mailbox-Datei,
# eine QText-Marke dabei in Anfuehrungszeichen. Eine Aenderung am Zerleger
# aendert also nicht nur den Dateinamen, sondern auch, was in der Mailbox
# landet. Das Werkzeug bildet diesen Rueckschrieb nach und vergleicht ihn mit
# dem, was auf der Leitung ankam. "Rueckschrieb byteidentisch" heisst: die
# Aenderung fasst die gespeicherte Nachricht nicht an.
#
# GRENZEN, damit niemand die Ausgabe fuer mehr nimmt als sie ist
#   * Geprueft wird der Weg bis zum Attributwert. Was OpenAttachFile,
#     DeMacifyName32 und MIMEMap::SetExtension danach noch tun, steht hier
#     nicht drin - dafuer siehe BEFUNDE.md AN-1.
#   * Fix2047 laeuft nicht mit. Wer RFC-2047-Woerter prueft, muss das wissen.
#   * Der Treiber kennt nur Content-Disposition, nicht alle Kopfzeilen.
#
# SOLL/IST
#
# Jeder Fall traegt zwei Angaben: was richtig waere (soll), und was der
# Baum HEUTE liefert (stand). Rueckgabe 1, sobald ein Fall anders ausgeht als
# unter "stand" verzeichnet - das meldet eine Behebung genauso wie einen
# neuen Schaden. Solange AN-1 offen ist, ist rc=0 der erwartete Ausgang.
#
# Bewusst ohne Escape-Sequenzen fuer Steuerzeichen geschrieben.

my ($lang, $behalten, $vorschlag);
for my $a (@ARGV) {
  if    ($a eq '--lang')      { $lang = 1 }
  elsif ($a eq '--behalten')  { $behalten = 1 }
  elsif ($a eq '--vorschlag') { $vorschlag = 1 }
  else                        { die "unbekannte Option: $a\n" }
}

my $wurzel = `git rev-parse --show-toplevel`;
die "nicht in einem git-Baum\n" if $?;
chomp $wurzel;

my $H = "$wurzel/Eudora71/Eudora/lex822.h";
my $C = "$wurzel/Eudora71/Eudora/lex822.cpp";
-f $H && -f $C or die "lex822.h/.cpp nicht gefunden unter $wurzel/Eudora71/Eudora\n";

# ---------------------------------------------------------------------------
# Woertlich uebernehmen. Angesteuert wird ueber Textmarken, nicht ueber
# Zeilennummern - sonst rutscht das Werkzeug bei der ersten Aenderung daneben.
# ---------------------------------------------------------------------------
sub lies { local (@ARGV) = @_; local $/; my $t = <>; $t =~ s/\r//g; return $t }

my $htext = lies($H);
my $ctext = lies($C);

my ($enums) = $htext =~ /(typedef enum.*?\} Char822Enum;)/s
  or die "lex822.h: Aufzaehlungen nicht gefunden\n";
my ($tabellen) = $ctext =~ /(const char LineTable.*?const BYTE State2Token\[\] =.*?\n\};)/s
  or die "lex822.cpp: Tabellen nicht gefunden\n";
my ($lexer) = $ctext =~ /(Token822Enum Lex822State::Lex822\(\).*?\n\})/s
  or die "lex822.cpp: Lex822() nicht gefunden\n";

printf "uebernommen: %d Zeilen Aufzaehlungen, %d Zeilen Tabellen, %d Zeilen Lex822()\n",
       ($enums =~ tr/\n//), ($tabellen =~ tr/\n//), ($lexer =~ tr/\n//);

# ---------------------------------------------------------------------------
# Der Vorschlag. Suchtext und Ersatztext stehen hier im Klartext, damit
# tools/patches/anhangnamen-faltung.patch und dieses Werkzeug nicht
# auseinanderlaufen koennen: passt der Suchtext nicht mehr, bricht es ab.
# ---------------------------------------------------------------------------
my $SUCHE = <<'ALT';
						case CR822:
							returnToken = QText;
							State = CollectLine;
							break;
						
						default:
							ADD(*Spot++);
							break;
					}
				break;
ALT

my $ERSATZ = <<'NEU';
						case CR822:
							//	Eine Faltung beendet die Zeichenkette NICHT: nach RFC 5322
							//	2.2.3 gehoert CRLF gefolgt von Leerzeichen oder Tabulator
							//	noch zur selben Kopfzeile. Ob eine folgt, ist am CR noch
							//	nicht zu sehen - das dritte Zeichen liegt erst nach dem
							//	naechsten LexFill im Puffer. Also wird das CR mitgenommen
							//	(so haelt es CollectText seit jeher) und am LF entschieden.
							//	Die Pruefung auf CR822 ist noetig, weil QUOTE822 hierher
							//	durchfaellt.
							if (charClass == CR822 && InStructure && nextClass == LF822)
							{
								ADD(*Spot++);
								break;
							}
							returnToken = QText;
							State = CollectLine;
							break;
						
						case LF822:
							//	Hierher kommt nur ein Umbruch, den die Faltungsregel
							//	oben NICHT zu SPACE822 gemacht hat: die Zeichenkette ist
							//	unbeendet (kaputte Kopfzeile). Abbrechen wie bisher.
							//	Das CR von oben bleibt in der Marke stehen;
							//	WriteHeaderToken setzt es hinter das schliessende
							//	Anfuehrungszeichen, und AddAttribute schneidet es vom
							//	Wert ab. So bleibt der Rueckschrieb byteidentisch.
							returnToken = QText;
							State = CollectLine;
							break;
						
						default:
							ADD(*Spot++);
							break;
					}
				break;
NEU

if ($vorschlag) {
  my $n = ($lexer =~ s/\Q$SUCHE\E/$ERSATZ/);
  die "--vorschlag: der Suchtext passt nicht mehr auf lex822.cpp.\n"
    . "Entweder steht die Behebung schon im Baum (dann ist --vorschlag ueberfluessig),\n"
    . "oder CollectQText ist anders geaendert worden. Nachsehen, nicht raten.\n"
    unless $n == 1;
  print "VORSCHLAG eingesetzt (tools/patches/anhangnamen-faltung.patch)\n";
}

# ---------------------------------------------------------------------------
# Faelle. soll = der Name, den der Absender gemeint hat.
#        stand = was dieser Baum heute daraus macht ("" heisst: kein Attribut).
# ---------------------------------------------------------------------------
my $LANG = 'A' x 300;
my @faelle = (
  { name => 'ungefaltet, kurz',
    kopf => qq{Content-Disposition: attachment; filename="Rechnung.pdf"\r\n\r\n},
    soll  => 'Rechnung.pdf',
    stand => 'Rechnung.pdf',
    wort  => 'so verschickt Eudora selbst, sendmail.cpp:2392',
    gr    => 'TRUE',
    rs    => 'gleich' },

  { name => 'gefaltet innerhalb der Anfuehrungszeichen',
    kopf => qq{Content-Disposition: attachment;\r\n}
          . qq{\tfilename="Angebot Nr 4711 fuer die Stadtwerke Musterstadt\r\n}
          . qq{ Abrechnungszeitraum 2025.pdf"\r\n\r\n},
    soll  => 'Angebot Nr 4711 fuer die Stadtwerke Musterstadt Abrechnungszeitraum 2025.pdf',
    stand => 'Angebot Nr 4711 fuer die Stadtwerke Musterstadt',
    wort  => 'Befund AN-1, erster Teil: CR beendet die Zeichenkette',
    gr    => 'FALSE',
    rs    => 'anders' },

  { name => 'derselbe Name, ungefaltet',
    kopf => qq{Content-Disposition: attachment;\r\n}
          . qq{\tfilename="Angebot Nr 4711 fuer die Stadtwerke Musterstadt Abrechnungszeitraum 2025.pdf"\r\n\r\n},
    soll  => 'Angebot Nr 4711 fuer die Stadtwerke Musterstadt Abrechnungszeitraum 2025.pdf',
    stand => 'Angebot Nr 4711 fuer die Stadtwerke Musterstadt Abrechnungszeitraum 2025.pdf',
    wort  => 'Gegenprobe: an der Laenge liegt es nicht',
    gr    => 'TRUE',
    rs    => 'gleich' },

  { name => '300 Zeichen, ungefaltet',
    kopf => qq{Content-Disposition: attachment; filename="$LANG.pdf"\r\n\r\n},
    soll  => "$LANG.pdf",
    stand => 'A' x 254,
    wort  => 'Befund AN-1, zweiter Teil: Token[256] laeuft voll',
    gr    => 'FALSE',
    rs    => 'anders' },

  { name => 'RFC 2231, auf zwei Teile verteilt',
    kopf => qq{Content-Disposition: attachment;\r\n}
          . qq{\tfilename*0="Angebot Nr 4711 fuer die Stadtwerke";\r\n}
          . qq{\tfilename*1=" Musterstadt 2025.pdf"\r\n\r\n},
    soll  => 'Angebot Nr 4711 fuer die Stadtwerke Musterstadt 2025.pdf',
    stand => '',
    wort  => 'Befund AN-1, dritter Teil: RFC 2231 kennt der Baum nicht',
    gr    => 'TRUE',
    rs    => 'gleich' },

  # --- Rueckfallproben: was durch eine Aenderung an CollectQText kaputtgehen
  #     koennte. Sie tragen kein filename, geprueft werden grokked und der
  #     Rueckschrieb. Wer die Behebung einbaut, muss diese fuenf gruen halten.

  { name => 'R1 Anfuehrungszeichen, danach eine weitere Kopfzeile',
    kopf => qq{Content-Type: text/plain; charset="iso-8859-1"\r\n}
          . qq{Content-Transfer-Encoding: base64\r\n\r\n},
    soll => '', stand => '', gr => 'FALSE',
    wort => 'die naechste Kopfzeile darf nicht verschluckt werden (grokked FALSE, weil der Treiber nur Content-Disposition kennt)',
    rs    => 'gleich' },

  { name => 'R2 unbeendete Zeichenkette',
    kopf => qq{Content-Disposition: attachment; filename="ohne Ende\r\n}
          . qq{Content-Transfer-Encoding: base64\r\n\r\n},
    soll => 'ohne Ende', stand => 'ohne Ende', gr => 'TRUE',
    wort => 'kaputte Eingabe: der Umbruch MUSS die Zeichenkette beenden, sonst frisst sie die naechste Kopfzeile',
    rs    => 'anders' },

  { name => 'R3 Faltung AUSSERHALB der Anfuehrungszeichen',
    kopf => qq{Content-Disposition: attachment;\r\n}
          . qq{ filename="Rechnung.pdf"\r\n\r\n},
    soll => 'Rechnung.pdf', stand => 'Rechnung.pdf', gr => 'TRUE',
    wort => 'die gewoehnliche Faltung - ging schon immer und muss weiter gehen',
    rs    => 'gleich' },

  { name => 'R4 Faltung mit Tabulator statt Leerzeichen',
    kopf => qq{Content-Disposition: attachment;\r\n}
          . qq{\tfilename="Angebot Nr 4711 fuer die Stadtwerke\r\n}
          . qq{\tMusterstadt 2025.pdf"\r\n\r\n},
    soll  => 'Angebot Nr 4711 fuer die Stadtwerke Musterstadt 2025.pdf',
    stand => 'Angebot Nr 4711 fuer die Stadtwerke',
    gr    => 'FALSE',
    wort  => 'derselbe Fehler, gefaltet mit Tabulator - RFC 5322 erlaubt beides',
    rs    => 'anders' },

  { name => 'R5 leeres Anfuehrungszeichenpaar',
    kopf => qq{Content-Disposition: attachment; filename=""\r\n\r\n},
    soll => '', stand => '=', gr => 'TRUE',
    wort => 'Befund AN-1, vierter Teil: die leere Marke traegt das Byte der VORIGEN Marke - filename="" wird zu =',
    rs    => 'gleich' },
);

# ---------------------------------------------------------------------------
# Quelltext bauen
# ---------------------------------------------------------------------------
sub cstring {
  my $s = shift;
  $s =~ s/\\/\\\\/g; $s =~ s/"/\\"/g;
  $s =~ s/\r/\\r/g;  $s =~ s/\n/\\n/g;
  return qq{"$s"};
}

my $faelle_c = join "\n", map {
  sprintf qq{\tLauf(%s, %s, %s, %s, %s, %s, %s);},
          cstring($_->{name}), cstring($_->{kopf}),
          cstring($_->{soll}), cstring($_->{stand}),
          cstring($_->{wort}), cstring($_->{gr}), cstring($_->{rs})
} @faelle;

my $treiber = <<'TREIBER';

// ---------------------------------------------------------------------------
// Treiber: bildet HeaderDesc::Read (header.cpp:120-430) nach, soweit
// Content-Disposition es braucht. Zustandsnamen aus header.h:14-27.
// ---------------------------------------------------------------------------
static int g_lang = 0;
static int g_abweichungen = 0;

static const char* Marke(Token822Enum t)
{
	switch (t) {
	case LinearWhite: return "LinearWhite"; case Atom: return "Atom";
	case QText: return "QText"; case RegText: return "RegText";
	case DomainLit: return "DomainLit"; case Comment: return "Comment";
	case Special: return "Special"; case EndOfHeader: return "EndOfHeader";
	case EndOfMessage: return "EndOfMessage"; case ErrorToken: return "ErrorToken";
	default: return "?";
	}
}

enum { ExpectHeaderName, ExpectColon, ExpectText, ExpectSem,
	   ExpectAttribute, ExpectEqual, ExpectValue };

static void Kurz(const char* s)
{
	int n = (int)strlen(s);
	if (n <= 60) { printf("\"%s\"", s); return; }
	printf("\"%.30s\"...%d Zeichen...\"%s\"", s, n, s + n - 12);
}

// Bildet WriteHeaderToken (lex822.cpp:402) nach: was landet in der
// Mailbox-Datei? Eine QText-Marke wird dort in Anfuehrungszeichen geschrieben.
static char g_zurueck[8192];
static int  g_zlen;

static void Zurueck(const char* p, int n)
{
	int i;
	for (i = 0; i < n && g_zlen < (int)sizeof(g_zurueck) - 1; ++i)
		g_zurueck[g_zlen++] = p[i];
	g_zurueck[g_zlen] = 0;
}

static void Rueckschrieb(Token822Enum t, const char* pToken, int nLen)
{
	switch (t)
	{
	case EndOfMessage:  Zurueck("\r\n\r\n", 4); break;
	case EndOfHeader:
		//	Lex822 hat die Marke selbst schon ueber WriteHeaderToken(Special)
		//	geschrieben (lex822.cpp:346), danach kommt noch ein CRLF dazu -
		//	daher beides.
		Zurueck(pToken, nLen); Zurueck("\r\n", 2); break;
	case ErrorToken:                               break;
	case QText:
#ifdef VORSCHLAG
		//	Zweiter Teil des Vorschlags, lex822.cpp:432: ein CR am Ende der
		//	Marke stammt aus einer unbeendeten Zeichenkette und gehoert
		//	HINTER das schliessende Anfuehrungszeichen.
		if (nLen && pToken[nLen - 1] == '\r')
		{
			Zurueck("\"", 1); Zurueck(pToken, nLen - 1); Zurueck("\"", 1);
			Zurueck("\r", 1);
			break;
		}
#endif
		Zurueck("\"", 1); Zurueck(pToken, nLen); Zurueck("\"", 1); break;
	default:            Zurueck(pToken, nLen);     break;
	}
}

// Zweiter Teil des Vorschlags: HeaderDesc::AddAttribute (header.cpp:477) macht
// aus einer Faltung im Attributwert ein einzelnes Leerzeichen (RFC 5322 3.2.2).
// Der Rueckschrieb ist da schon passiert - die Mailbox-Datei bleibt unberuehrt.
static void Entfalten(char* s)
{
	char* d = s;
	{
		//	Dritter Teil des Vorschlags: ein CR am Ende stammt aus einer
		//	unbeendeten Zeichenkette und gehoert nicht in den Wert.
		int n = (int)strlen(s);
		if (n && s[n - 1] == '\r') s[n - 1] = 0;
	}
	while (*s)
	{
		if (s[0] == '\r' && s[1] == '\n' && (s[2] == ' ' || s[2] == '\t'))
		{
			s += 2;
			while (*s == ' ' || *s == '\t') ++s;
			*d++ = ' ';
			continue;
		}
		*d++ = *s++;
	}
	*d = 0;
}

static void Lauf(const char* szWas, const char* szKopf,
				 const char* szSoll, const char* szStand, const char* szWort,
				 const char* szGrokked, const char* szRueck)
{
	Lex822State l(szKopf);
	char attributeName[32];
	char filename[1024];
	int  state = ExpectHeaderName;
	int  grokked = TRUE;
	int  i;

	attributeName[0] = 0;
	filename[0] = 0;
	g_zurueck[0] = 0;
	g_zlen = 0;

	if (g_lang)
	{
		printf("\n--- %s\n", szWas);
		fputs(szKopf, stdout);
	}

	for (i = 0; i < 4000; ++i)
	{
		Token822Enum t = l.Lex822();
		Rueckschrieb(t, (char*)l.Token, l.TokenSpot);
		t = l.WriteHeaderToken(t);
		if (t == Comment) t = LinearWhite;
		if (t == EndOfHeader || t == EndOfMessage || t == ErrorToken) break;

		if (g_lang)
		{
			printf("    %-12s ", Marke(t));
			Kurz((char*)l.Token);
			printf("\n");
		}

		// header.cpp:140-156
		if (t == Special && l.Token[0] == '\r') continue;
		if (t == Special && l.Token[0] == '\n')
		{
			if (state != ExpectText && state != ExpectSem) grokked = FALSE;
			state = ExpectHeaderName;
			continue;
		}

		switch (state)
		{
		case ExpectHeaderName:
			if (t == LinearWhite) break;
			if (t == Atom) state = ExpectColon;
			else { grokked = FALSE; l.State = CollectText; state = ExpectText; }
			break;

		case ExpectColon:
			if (t == LinearWhite) break;
			if (t == Special && l.Token[0] == ':') { state = ExpectValue; attributeName[0] = 0; }
			else { grokked = FALSE; l.State = CollectText; state = ExpectText; }
			break;

		case ExpectText:
			break;

		case ExpectSem:
			if (t == LinearWhite) break;
			if (t == Special && l.Token[0] == ';') { state = ExpectAttribute; break; }
			grokked = FALSE; l.State = CollectText; state = ExpectText;
			break;

		case ExpectAttribute:
			if (t == LinearWhite) break;
			if (t == Atom)
			{
				strncpy(attributeName, (char*)l.Token, sizeof(attributeName) - 1);
				attributeName[sizeof(attributeName) - 1] = 0;
				state = ExpectEqual;
			}
			else { grokked = FALSE; l.State = CollectText; state = ExpectText; }
			break;

		case ExpectEqual:
			if (t == LinearWhite) break;
			if (t == Special && l.Token[0] == '=') { state = ExpectValue; break; }
			grokked = FALSE; l.State = CollectText; state = ExpectText;
			break;

		case ExpectValue:
			if (t == LinearWhite) break;
			if (t == Atom || t == QText)
			{
				// GetAttribute vergleicht den ganzen Namen, header.cpp:502
				if (strcmp(attributeName, "filename") == 0 && filename[0] == 0)
				{
					strncpy(filename, (char*)l.Token, sizeof(filename) - 1);
					filename[sizeof(filename) - 1] = 0;
				}
				state = ExpectSem;
			}
			else { grokked = FALSE; l.State = CollectText; state = ExpectText; }
			break;
		}
	}

	Entfalten(filename);

	{
		const char* punkt = strrchr(filename, '.');
		int nKopf = (int)strlen(szKopf);
		int gleich = (g_zlen == nKopf && memcmp(g_zurueck, szKopf, (size_t)nKopf) == 0);
		int wie_stand = (strcmp(filename, szStand) == 0);
		int heil      = (strcmp(filename, szSoll)  == 0);

		printf("\n%s\n  (%s)\n", szWas, szWort);
		printf("  soll   "); Kurz(szSoll);   printf("  (%d Zeichen)\n", (int)strlen(szSoll));
		printf("  ist    "); Kurz(filename); printf("  (%d Zeichen), Endung %s, grokked=%s\n",
			   (int)strlen(filename), punkt ? punkt : "FEHLT", grokked ? "TRUE" : "FALSE");

		if (strcmp(grokked ? "TRUE" : "FALSE", szGrokked) != 0)
		{
			printf("  -> ABWEICHUNG bei grokked: verzeichnet war %s\n", szGrokked);
			g_abweichungen++;
		}
		if (!gleich && g_lang)
		{
			int i;
			printf("  zurueck  ist: ");
			for (i = 0; i < g_zlen; ++i)
				putchar(g_zurueck[i] >= 32 ? g_zurueck[i] : '.');
			printf("\n  zurueck soll: ");
			for (i = 0; i < nKopf; ++i)
				putchar(szKopf[i] >= 32 ? szKopf[i] : '.');
			printf("\n");
		}
		printf("  zurueck %s (%d von %d Byte)%s\n",
			   gleich ? "byteidentisch" : "abweichend", g_zlen, nKopf,
			   gleich ? "" : "  <- so ist es heute");
		if (strcmp(gleich ? "gleich" : "anders", szRueck) != 0)
		{
			printf("  -> ABWEICHUNG beim Rueckschrieb: verzeichnet war %s\n", szRueck);
			g_abweichungen++;
		}

		if (heil)            printf("  -> heil\n");
		else if (wie_stand)  printf("  -> kaputt, wie verzeichnet\n");
		if (!wie_stand)
		{
			printf("  -> ABWEICHUNG vom verzeichneten Stand: erwartet war ");
			Kurz(szStand); printf("\n");
			g_abweichungen++;
		}
	}
}

int main(int argc, char** argv)
{
	int i;
	for (i = 1; i < argc; ++i)
		if (strcmp(argv[i], "--lang") == 0) g_lang = 1;

FAELLE

	printf("\n%d Faelle, %d Abweichung(en) vom verzeichneten Stand\n",
		   ANZAHL, g_abweichungen);
	return g_abweichungen ? 1 : 0;
}
TREIBER

$treiber =~ s/^FAELLE$/$faelle_c/m;
$treiber =~ s/ANZAHL/scalar(@faelle)/e;

# Steht die Behebung schon im Baum, muss auch das Rueckschrieb-Modell die
# geaenderte Fassung nachbilden - sonst misst das Werkzeug gegen ein
# WriteHeaderToken, das es so nicht mehr gibt. Erkannt am Markierungssatz aus
# dem Patch; er steht in lex822.cpp und in ImapLex822.cpp.
my $schon_drin = ($lexer =~ /Eine Faltung beendet die Zeichenkette NICHT/);
print "Die Behebung steht bereits im Baum - das Rueckschrieb-Modell folgt ihr.\n"
  if $schon_drin && !$vorschlag;
my $schalter = ($vorschlag || $schon_drin) ? "#define VORSCHLAG 1"
                                           : "// (ohne --vorschlag)";
my $quelle = <<'KOPF' . $enums . "\n\n" . $tabellen . "\n" . <<'KLASSE' . $lexer . "\n" . $treiber;
// ERZEUGT von tools/kopfzeile-pruefen.pl - nicht von Hand aendern.
//
// Aufzaehlungen aus Eudora71/Eudora/lex822.h, Tabellen und Lex822() aus
// Eudora71/Eudora/lex822.cpp, beides woertlich. Ersetzt sind nur LexFill()
// und WriteHeaderToken().
//
#include <stdio.h>
#include <string.h>
typedef unsigned char BYTE;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
SCHALTER

KOPF

class Lex822State
{
public:
	Lex822State(const char* pText) : m_Text(pText), m_Pos(0) { State = Init822; }
	Token822Enum Lex822();
	Token822Enum WriteHeaderToken(Token822Enum t) { return t; }
	Char822Enum LexFill();
	State822Enum State;
	BYTE Token[256];
	void ADD(BYTE c) { Token[TokenSpot++] = c; Token[TokenSpot] = 0; }
	int TokenSpot;
	BYTE Buffer[2048];
	BYTE* Spot;
	BYTE* End;
	short InStructure;
	short ReinitToken;
	BOOL UhOh;
	BOOL Has2047;
	const char* m_Text;
	int m_Pos;
};

// Stellvertreter fuer LexFill (lex822.cpp:721): gibt Zeile fuer Zeile aus
// m_Text heraus, mit CRLF, so wie LineReader::ReadLine es tut. Fix2047
// laeuft bewusst nicht mit.
Char822Enum Lex822State::LexFill()
{
	BYTE* readHere;
	int size;
	if (State == ReceiveError) return CR822;
	if (Spot < End) { *Buffer = *Spot; Spot = Buffer; readHere = Spot + 1; }
	else readHere = Spot = Buffer;

	{
		const char* p = m_Text + m_Pos;
		const char* nl = strchr(p, '\n');
		if (!*p) { strcpy((char*)readHere, ".\r\n"); size = 3; }
		else
		{
			size = nl ? (int)(nl - p + 1) : (int)strlen(p);
			memcpy(readHere, p, (size_t)size);
			readHere[size] = 0;
			m_Pos += size;
		}
	}
	End = readHere + size;
	return (Char822Enum)Class822[*readHere];
}

KLASSE

# ---------------------------------------------------------------------------
# Uebersetzen und laufen lassen
# ---------------------------------------------------------------------------
my $dir = "$wurzel/tools/.kopfzeile";
mkdir $dir unless -d $dir;
my $cpp = "$dir/kopfzeile.cpp";
$quelle =~ s/^SCHALTER$/$schalter/m;

open my $fh, '>', $cpp or die "$cpp: $!\n";
print $fh $quelle;
close $fh;

my $exe = "$dir/kopfzeile";
my $bau;
# Pfade fuer die Kommandozeile einpacken. Unter Windows sind nur
# Anfuehrungszeichen richtig, sonst stolpert die Shell ueber Leerzeichen.
sub pfad { my $p = shift; return $^O eq 'MSWin32' ? qq{"$p"} : "'" . $p . "'" }

if ($^O ne 'MSWin32' && system("g++ --version >/dev/null 2>&1") == 0) {
  $bau = "g++ -w -o " . pfad($exe) . " " . pfad($cpp);
} elsif (system("cl >nul 2>&1") == 0 || $^O eq 'MSWin32') {
  $exe = "$dir/kopfzeile.exe";
  $bau = "cl /nologo /w /Fe:\"$exe\" \"$cpp\" /Fo:\"$dir/\"";
} else {
  die "weder g++ noch cl gefunden - ohne Uebersetzer geht es nicht\n";
}

print "baue: $bau\n";
if (system($bau) != 0) {
  die "Uebersetzen fehlgeschlagen. Der Quelltext liegt in $cpp\n";
}

my $rc = system(pfad($exe) . ($lang ? ' --lang' : ''));
$rc = $rc >> 8;

unless ($behalten) {
  unlink $cpp, $exe, "$dir/kopfzeile.obj";
  rmdir $dir;
}

exit $rc;
