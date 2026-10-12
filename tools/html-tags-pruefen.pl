#!/usr/bin/perl
# html-tags-pruefen.pl - haelt die HTML-Tag-Tabelle gegen ihre Aufzaehlung.
#
#   perl tools/html-tags-pruefen.pl
#   perl tools/html-tags-pruefen.pl --behalten   # erzeugten C++-Quelltext lassen
#
# WARUM ES DIESES WERKZEUG GIBT
#
# Paiges HTML-Einleser erkennt einen Tag so: table_command() laeuft die
# Zeichenkette control_commands (PGHTMDEF.C) durch und gibt die POSITION des
# Treffers zurueck. Diese Position ist der Befehlswert - und die Aufzaehlung in
# PGHTMDEF.H vergibt dieselben Werte noch einmal, von Hand.
#
# Zwei Fallen stecken darin, und beide sind stumm:
#
#   1. Verschiebt sich die Liste gegen die Aufzaehlung, heisst <title> ploetzlich
#      <ul>. Kein Uebersetzer meldet das.
#   2. table_command bricht ab, sobald der erste Buchstabe eines Listeneintrags
#      GROESSER ist als der gesuchte (PGHTMIMP.CPP:3502). Die Liste muss also
#      nach dem ersten Buchstaben sortiert sein. Ein hinten angehaengter Tag
#      wird nie gefunden - ebenfalls ohne eine einzige Meldung.
#
# Beides ist beim Einbau von <script> (Befund AN-2) beinahe passiert.
#
# Das Werkzeug zieht table_command und die Tabelle WOERTLICH aus dem Baum,
# nimmt die Aufzaehlung aus dem Kopf und prueft jedes Paar gegen die
# erwartete Zuordnung, die unten im Klartext steht. rc=0, wenn alles stimmt.

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

my $dirE = "$wurzel/Eudora71/Eudora";
sub lies {
  my $p = shift;
  open my $f, '<', $p or die "$p: $!\n";
  binmode $f;
  local $/; my $t = <$f>; close $f;
  $t =~ s/\r//g;
  return $t;
}

my $def_c = lies("$dirE/PGHTMDEF.C");
my $def_h = lies("$dirE/PGHTMDEF.H");
my $imp   = lies("$dirE/PGHTMIMP.CPP");

# --- Die Tabelle ---------------------------------------------------------
my ($tabelle) = $def_c =~ /control_commands\[\]\s*=\s*\{.*?^\t"([^"]*)"/ms
  or die "PGHTMDEF.C: control_commands nicht gefunden\n";

# --- Die Aufzaehlung -----------------------------------------------------
my ($enumtext) = $def_h =~ /extern pg_char PG_FAR control_commands\[\];\s*enum\s*\{(.*?)\}/s
  or die "PGHTMDEF.H: Aufzaehlung zu control_commands nicht gefunden\n";
my @namen;
for my $z (split /\n/, $enumtext) {
  $z =~ s{//.*}{};
  $z =~ s/\s+//g;
  next unless length $z;
  for my $e (split /,/, $z) {
    next unless length $e;
    $e =~ s/=.*//;
    push @namen, $e;
  }
}

# --- table_command woertlich --------------------------------------------
# Die DEFINITION, nicht die Vorwaertsdeklaration: die endet auf ';', also
# darf zwischen Klammer und '{' kein Semikolon stehen.
my ($tc) = $imp =~ /(static long table_command \(pg_char_ptr table[^;]*?\)\s*\n\{.*?\n\})/s
  or die "PGHTMIMP.CPP: table_command nicht gefunden\n";

my @t = grep { $_ ne '\\0' } split ' ', $tabelle;
printf "Tabelle:     %d Tag(s)\n", scalar @t;
printf "Aufzaehlung: %d Namen\n", scalar @namen;

# --- Die erwartete Zuordnung. VON HAND, das ist der Pruefmassstab. -------
#     Links der Tag, wie er in der Nachricht steht; rechts der Name, unter
#     dem der Einleser ihn behandelt. Wer hier etwas aendert, muss wissen,
#     was er tut: diese Liste ist das Soll, nicht das Ist.
my @soll = (
  [ 'base'     => 'base_url_command'       ],
  [ 'basefont' => 'basefont_command'       ],
  [ 'body'     => 'body_command'           ],
  [ 'br'       => 'linebreak_command'      ],
  [ 'dir'      => 'directory_command'      ],
  [ 'div'      => 'div_command'            ],
  [ 'dl'       => 'deflist_command'        ],
  [ 'head'     => 'heading_command'        ],
  [ 'hr'       => 'linerule_command'       ],
  [ 'html'     => 'html_command'           ],
  [ 'li'       => 'listing_command'        ],
  [ 'listing'  => 'code_listing_command'   ],
  [ 'menu'     => 'menu_command'           ],
  [ 'ol'       => 'ordered_list_command'   ],
  [ 'p'        => 'parbreak_command'       ],
  [ 'script'   => 'script_command'         ],
  [ 'style'    => 'style_command'          ],
  [ 'title'    => 'title_command'          ],
  [ 'ul'       => 'unordered_list_command' ],
  [ 'wbr'      => 'wordbreak_command'      ],
  [ 'x-tab'    => 'x_tab_command'          ],
  [ 'x-sigsep' => 'x_signature_command'    ],
);

# Tags, die hier NICHT stehen duerfen - sie gehoeren in html_style_commands.
my @nicht = qw(blink blockquote b i font h1 em strong);

my $faelle = join '', map {
  sprintf qq{\tpruef("%s", %s);\n}, $_->[0], $_->[1]
} @soll;
my $nichtfaelle = join '', map {
  sprintf qq{\tnichtDrin("%s");\n}, $_
} @nicht;

my $cpp = <<"KOPF" . $tc . <<"TREIBER";
// ERZEUGT von tools/html-tags-pruefen.pl - nicht von Hand aendern.
//
// table_command stammt WOERTLICH aus Eudora71/Eudora/PGHTMIMP.CPP, die
// Tabelle aus PGHTMDEF.C, die Aufzaehlung aus PGHTMDEF.H.
#include <stdio.h>
#include <string.h>

typedef char            pg_char;
typedef char*           pg_char_ptr;
typedef short           pg_short_t;
typedef int             pg_boolean;
#define PG_FAR
#define FALSE 0
#define TRUE  1

pg_char PG_FAR control_commands[] = { "$tabelle" };

enum {
$enumtext
};

KOPF

static int fehler = 0;
static int faelle = 0;

static void pruef(const char* tag, long soll)
{
	long ist = table_command(control_commands, (pg_char_ptr)tag, (pg_short_t)strlen(tag));
	int ok = (ist == soll);
	faelle++;
	if (!ok) fehler++;
	printf("%-5s <%-9s> -> %2ld   soll %2ld\\n", ok? "ok" : "FEHL", tag, ist, soll);
}

static void nichtDrin(const char* tag)
{
	long ist = table_command(control_commands, (pg_char_ptr)tag, (pg_short_t)strlen(tag));
	int ok = (ist == 0);
	faelle++;
	if (!ok) fehler++;
	printf("%-5s <%-9s> -> %2ld   soll  0 (gehoert nicht in diese Liste)\\n",
		   ok? "ok" : "FEHL", tag, ist);
}

int main()
{
	printf("\\nJeder Tag muss den Wert seines Namens aus der Aufzaehlung treffen\\n");
$faelle
	printf("\\nUnd diese duerfen hier NICHT gefunden werden\\n");
$nichtfaelle
	printf("\\n%d Faelle, %d Abweichung(en)\\n", faelle, fehler);
	return fehler? 1 : 0;
}
TREIBER

my $dir = "$wurzel/tools/.htmltags";
mkdir $dir unless -d $dir;
my $datei = "$dir/htmltags.cpp";
open my $fh, '>', $datei or die "$datei: $!\n";
print $fh $cpp;
close $fh;

sub pfad { my $p = shift; return $^O eq 'MSWin32' ? qq{"$p"} : "'" . $p . "'" }

my $exe = "$dir/htmltags";
my $bau;
if ($^O ne 'MSWin32' && system("g++ --version >/dev/null 2>&1") == 0) {
  $bau = "g++ -w -o " . pfad($exe) . " " . pfad($datei);
} elsif (system("cl >nul 2>&1") == 0 || $^O eq 'MSWin32') {
  $exe = "$dir/htmltags.exe";
  $bau = "cl /nologo /w /Fe:\"$exe\" \"$datei\" /Fo:\"$dir/\"";
} else {
  die "weder g++ noch cl gefunden - ohne Uebersetzer geht es nicht\n";
}

print "baue: $bau\n";
die "Uebersetzen fehlgeschlagen. Der Quelltext liegt in $datei\n"
  if system($bau) != 0;

my $rc = system(pfad($exe));
$rc = $rc >> 8 if $rc > 255;

unless ($behalten) {
  unlink $datei, $exe, "$dir/htmltags.obj";
  rmdir $dir;
}

exit($rc ? 1 : 0);
