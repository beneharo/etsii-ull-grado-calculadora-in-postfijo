/* lexical grammar */

%%

\s+                   /* skip whitespace */
";"                   return yytext
[0-9]+("."[0-9]+)?\b  return 'NUMBER'
\b[A-Za-z_]\w*\b      return idORrw(yytext)
"="                   return '='
"*"                   return '*'
"/"                   return '/'
"-"                   return '-'
"+"                   return '+'
"^"                   return '^'
"!"                   return '!'
"%"                   return '%'
"("                   return '('
")"                   return ')'
"PI"                  return 'PI'
"E"                   return 'E'
<<EOF>>               return 'EOF'
.                     return 'INVALID'

%%


var reserved_words = {PI : 'PI', E : 'E'};
function idORrw(x) {
  return ((x.toUpperCase() in reserved_words) ? x.toUpperCase() : 'ID');
}


