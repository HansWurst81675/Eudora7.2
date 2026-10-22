//	HTML utilities culled from Eudora's copy of PGHTMIMP.CPP, PgEmbeddedImage.cpp,
//	and PgHLinks.cpp.


#include "stdafx.h"

#include "HTMLUtils.h"

#include "DebugNewHelpers.h"


/* resolve_URL copies the URL address from source_URL (of URL_size), decoding special chars
if necessary and outputing the address in target_URL. */

void resolve_URL (pg_char_ptr source_URL, pg_char_ptr target_URL, size_t nMaxLength)
{
   pg_char_ptr       output, input;
   size_t            output_size;

   // BEFUND E-111, zweiter Teil (22.10.2026): die entarteten Groessen.
   //
   // Die Schranke unten prueft ERST NACH dem Schreiben. Mit ">=" allein
   // bleibt deshalb nMaxLength 0 und 1 ungedeckt: der erste Durchlauf
   // schreibt target_URL[0], und das abschliessende "*output = 0" setzt
   // target_URL[1] - bei nMaxLength=1 ein Byte zu weit, bei nMaxLength=0
   // zwei. Hier abgefangen, damit die Schleife darunter unveraendert
   // bleiben kann.
   if (nMaxLength == 0)
      return;
   *target_URL = 0;
   if (nMaxLength == 1)
      return;

   // Start at 1 so that when we stop we still have room to NULL terminate
   output_size = 1;
   input = source_URL;
   output = target_URL;
   
   while (*input) {
      
//QUALCOMM Begin - Beckley
// Comment out this truncation of cgi parameters.  Why would you want to do this?
//      if (*input == '?')
//         break;
//QUALCOMM End - Beckley
      
      if (*input == '%') {
         
         ++input;
         
         if (!*input)
            break;

         *output = (pg_char)translate_hex(*input++);
         *output <<= 4;

         if (!*input)
            break;

         *output |= translate_hex(*input++);

         //
         // BEFUND E-110 (18.09.2026): HIER fehlte das Weiterruecken.
         //
         // Der else-Zweig darunter schreibt UND rueckt vor
         // ("*output++ = *input++"). Dieser Zweig schrieb nur - das
         // entschluesselte Zeichen landete an der richtigen Stelle und wurde
         // vom naechsten Zeichen sofort ueberschrieben. Es war also nicht
         // falsch, sondern WEG.
         //
         // Gemessen an Gregors Nachricht vom 18.09.2026:
         //   en%20aktuellen%20Verlust.png  ->  enaktuellenVerlust.png
         //   SVS%20NL%20FW%20(1).jpg       ->  SVSNLFW(1).jpg
         // Der Server antwortet darauf mit 404, Eudora legt die Fehlerseite
         // ab, erkennt sie richtigerweise nicht als Bild - und zeichnet einen
         // grauen Kasten. Zehn von zwanzig Bildern seiner Nachricht.
         //
         // Betroffen ist JEDE Prozent-Sequenz, nicht nur %20: auch Umlaute in
         // Dateinamen (%C3%BC), Klammern (%28), Schraegstriche (%2F).
         //
         // output_size++ unten zaehlt fuer beide Zweige richtig - nur der
         // Zeiger fehlte. Zwanzig Zeilen weiter unten steht uebrigens
         // unescape_url, das dasselbe tut und es richtig macht.
         //
         ++output;
      }
      else if (input[0] == '&' && input[1] == 'a' && input[2] == 'm' &&
               input[3] == 'p' && input[4] == ';') {
         //
         // BEFUND E-117 (13.10.2026): im src eines Bildes steht laut HTML
         // &amp; fuer &. Fuer Links uebersetzt Eudora das (PGHTMIMP.CPP,
         // Html2Text), fuer Bilder kam die Adresse bis hierher roh an -
         // gemessen an Gregors 1.0.86: "...&amp;imgWidth=448&amp;..." und
         // der Bilddienst lieferte ein 1x1-Pixel statt des Fotos.
         //
         *output++ = '&';
         input += 5;
      }
      else
         *output++ = *input++;

      output_size++;

      //
      // BEFUND E-111 (22.10.2026): hier stand "==" statt ">=".
      //
      // output_size startet bei 1 und zaehlt je Durchlauf um genau 1 hoch.
      // Bei nMaxLength 0 oder 1 wird "==" deshalb NIE wahr, und die
      // Schleife schreibt ueber das Zielfeld hinaus, bis die Quelle endet.
      //
      // Fuer jedes nMaxLength >= 2 verhaelt sich ">=" genau wie "==": die
      // Behebung aendert am heutigen Verhalten nichts und schliesst nur den
      // Fall, den der PRUEFER am 18.09.2026 beim Nachrechnen der
      // E-110-Spurmarke fand (Befunde/PRUEFER-18.md).
      //
      // Ausgeloest gesehen wurde es nie - alle heutigen Aufrufer uebergeben
      // sizeof() eines grossen Feldes (PGHTMIMP.CPP:2310,
      // PgEmbeddedImage.cpp:1415). Es ist eine Schranke, die haelt, solange
      // niemand sie braucht.
      //
      if (output_size >= nMaxLength)
         break;
   }
   
   *output = 0;
}


/* translate_hex translates a hax character to its value. */

pg_short_t translate_hex (pg_char hex_char)
{
   pg_short_t        result;
   
   result = (pg_short_t)hex_char;
   
   if (result > 'F')
      result -= 0x20;
   if (result > '9')
      result -= 7;
   
   return      static_cast<unsigned short>((result - 0x30));
}


// reduce any %xx escape sequences to the characters they represent
void unescape_url( char *url )
{
    int i,j;

    for( i=0, j=0; url[j]; ++i,++j ) {
        if( (url[i] = url[j]) == '%' ) {
            url[i] = x2c( &url[j + 1] ) ;
            j += 2 ;
        }
    }

    url[i] = '\0' ;
}


// convert a two-char hex string into the char it represents
char x2c( char *what )
{
   int digit;

   digit = (what[0] >= 'A' ? ((what[0] & 0xdf) - 'A')+10 : (what[0] - '0'));
   digit *= 16;
   digit += (what[1] >= 'A' ? ((what[1] & 0xdf) - 'A')+10 : (what[1] - '0'));

   return (char)digit;
}
