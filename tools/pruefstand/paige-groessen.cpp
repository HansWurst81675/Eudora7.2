// paige-groessen.cpp - zieht die Paige-Strukturen in eine eigene PDB,
// damit sich ihr Aufbau unter VS2022 mit dem Aufbau der 2005 gebauten
// Paige32.dll vergleichen laesst (Befund E-31).
//
// Die Datei rechnet nichts aus. Sie legt nur je eine Variable jeder
// Struktur an, damit der Uebersetzer den vollstaendigen Typ in die
// Fehlersuchdaten schreibt. Verglichen wird danach mit
//   pdb-felder <meine.pdb>   gegen   pdb-felder <Paige32.pdb>
//
// Die Liste unten ist NICHT von Hand gewaehlt: es sind alle Strukturen,
// die sowohl in der Paige32.pdb von 2005 stehen als auch in
// Eudora71/PaigeDLL/PGHEADER definiert sind (74 Stueck), abzueglich
// derjenigen, die sich ohne die privaten Paige-Quellen nicht uebersetzen
// lassen. Damit wird die Behauptung "time_t war der einzige Typ, dessen
// Breite sich geaendert hat" an ALLEN gemeinsamen Strukturen gemessen,
// nicht nur an den vier, die im Befund stehen.
//
// Bauen (32 Bit):
//   cl /nologo /Zi /MD /DWIN32 /D_WINDOWS /DWIN32_COMPILE /DNDEBUG
//      /I<PGHEADER> paige-groessen.cpp
//
// PG_ALT_TIME_T stellt pg_time_t versuchsweise auf time_t zurueck und
// laesst damit den Zustand VOR der Behebung von E-31 nachmessen.

#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <time.h>

#ifdef PG_ALT_TIME_T
#define pg_time_t pg_time_t_ausgeschaltet
#endif

#include "paige.h"
#include "pgtables.h"
#include "pghdrftr.h"
#include "pgembed.h"
#include "pgtxtwid.h"
#include "pglists.h"
#include "pgshapes.h"
#include "pgtxr.h"
#include "pghtmdef.h"
#include "pgexceps.h"   /* pg_fail_info - der jmp_buf-Fall, siehe Bericht */

// Je eine Variable - sonst landet der Typ nicht in der PDB.
#define ZIEHE(T)   T pruefstand_##T;

ZIEHE(_cpinfo)
ZIEHE(char_widths)
ZIEHE(co_ordinate)
ZIEHE(color_value)
ZIEHE(draw_points)
ZIEHE(font_append_t)
ZIEHE(font_info)
ZIEHE(graf_device)
ZIEHE(mem_rec)
ZIEHE(metafile_struct)
ZIEHE(named_stylesheet)
ZIEHE(out_tag_attribute)
ZIEHE(pack_walk)
ZIEHE(paige_rec)
ZIEHE(par_append_t)
ZIEHE(par_info)
ZIEHE(pg_bitmap_rec)
ZIEHE(pg_clip_info)
ZIEHE(pg_col_info)
ZIEHE(pg_date)
ZIEHE(pg_doc_info)
ZIEHE(pg_embed_activate)
ZIEHE(pg_embed_click)
ZIEHE(pg_embed_measure)
ZIEHE(pg_embed_rec)
ZIEHE(pg_errlog_rec)
ZIEHE(pg_globals)
ZIEHE(pg_handler)
ZIEHE(pg_hooks)
ZIEHE(pg_horiz_line)
ZIEHE(pg_hyperlink)
ZIEHE(pg_import_rec)
ZIEHE(pg_indents)
ZIEHE(pg_kb_data)
ZIEHE(pg_list_rec)
ZIEHE(pg_measure)
ZIEHE(pg_par_hooks)
ZIEHE(pg_pic_embed)
ZIEHE(pg_poly_rec)
ZIEHE(pg_scale_factor)
ZIEHE(pg_style_hooks)
ZIEHE(pg_table)
ZIEHE(pg_time)
ZIEHE(pg_translator)
ZIEHE(pg_undo)
ZIEHE(pg_url_image)
ZIEHE(pgm_globals)
ZIEHE(picture_header)
ZIEHE(picture_op_rec)
ZIEHE(point_start)
ZIEHE(port_append_t)
ZIEHE(rectangle)
ZIEHE(select_pair)
ZIEHE(shape_section)
ZIEHE(smart_update)
ZIEHE(style_append_t)
ZIEHE(style_info)
ZIEHE(style_run)
ZIEHE(style_table)
ZIEHE(style_table_entry)
ZIEHE(style_walk)
ZIEHE(t_select)
ZIEHE(tab_stop)
ZIEHE(tag_attribute)
ZIEHE(tb_append_t)
ZIEHE(text_block)

ZIEHE(pg_fail_info)
int main(void) { return 0; }
