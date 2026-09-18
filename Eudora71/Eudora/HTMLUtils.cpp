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
      else
         *output++ = *input++;

      output_size++;

      if (output_size == nMaxLength)
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
