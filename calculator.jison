/* description: Parses end executes mathematical expressions. */

/* lexical grammar */
%lex

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

/lex

/* operator associations and precedence */
%right '='
%left '+' '-'
%left '*' '/'
%left '^'
%right '!'
%right '%'
%left UMINUS

%start expressions

%% /* language grammar */

expressions
    : e ';' expressions 
    | ';' expressions
    | ';' EOF
    | e ';' EOF
    | e EOF
        { typeof console !== 'undefined' ? console.log($1) : print($1);
          return JSON.stringify(ids); }
    ;

e
    : ID '=' e
      { ids[$1] = $3;
      console.log(ids); }
    | e '+' e
        {$$ = $1+$3;}
    | e '-' e
        {$$ = $1-$3;}
    | e '*' e
        {$$ = $1*$3;}
    | e '/' e
        {
          if($3 == 0) {
            throw new Error ('No se puede dividir por cero.');
          }
          $$ = $1/$3;
        }
    | e '^' e
        {$$ = Math.pow($1, $3);}
    | e '!'
        {{
          $$ = (function fact (n) { return n==0 ? 1 : fact(n-1) * n })($1);
        }}
    | e '%'
        {$$ = $1/100;}
    | '-' e %prec UMINUS
        {$$ = -$2;}
    | '(' e ')'
        {$$ = $2;}
    | NUMBER
        {$$ = Number(yytext);}
    | E
        {$$ = Math.E;}
    | E '=' e
        {
          throw new Error ('No se puede modificar la constante E.\n');
        }
    | PI
        {$$ = Math.PI;}
    | PI '=' e
        {
          throw new Error ('No se puede modificar la constante Pi.\n');
        }
    | ID
        { 
          if( ids[$1] == null) {
            throw new Error ('No se ha inicializado la variable ' + $1);
          }
          $$ = ids[$1];
          
        }
    ;
    
%%

var ids = { }
