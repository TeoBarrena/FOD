program ej1;
type
	archivo = file of integer;

procedure cargarArchivo(var a:archivo);
var
	x:integer;
	nombreArc:string[20];
begin
	writeln('Ingrese nombre del archivo');
	readln(nombreArc);
  assign(a,nombreArc); {se asigna el nombre al archivo}
  rewrite(a);{se crea el archivo}
  writeln('Ingrese un numero');
  readln(x);
  while(x <> 30000) do begin
  	write(a,x);
    writeln('Ingrese otro numero');
    readln(x);
  end;
  close(a);
end;

Procedure Recorrido(var a: archivo );
var nro: integer; { para leer elemento del archivo}
begin
	reset( a ); {archivo ya creado, para operar debe abrirse como de lect/escr}
	while not eof( a) do begin
		read( a, nro ); {se obtiene elemento desde archivo }
		writeln('numero:', nro ); {se presenta cada valor en pantalla}
	end;
	close(a);
end;	


var
	a:archivo;
begin
	cargarArchivo(a);
	Recorrido(a);  
end.
