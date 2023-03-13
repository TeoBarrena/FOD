{Realizar un algoritmo, que utilizando el archivo de números enteros no ordenados
creados en el ejercicio 1, informe por pantalla cantidad de números menores a 1500 y
el promedio de los números ingresados. El nombre del archivo a procesar debe ser
proporcionado por el usuario una única vez. Además, el algoritmo deberá listar el
contenido del archivo en pantalla.}
program ej2;
type
	archivo = file of integer;

procedure cargarArchivo(var a:archivo);
var
	prom:real;
	cantNum,x,cantMenor,total:integer;
	nombreArc:string[20];
begin
	cantNum:= 0;
	total:= 0;
	cantMenor:= 0;
	writeln('Ingrese nombre del archivo');
	readln(nombreArc);
  assign(a,nombreArc); {se asigna el nombre al archivo}
  rewrite(a);{se crea el archivo}
  writeln('Ingrese un numero');
  readln(x);
  while(x <> 30000) do begin
  	write(a,x);
    if (x < 1500) then
    	cantMenor:= cantMenor + 1;
    total:= total + x;
    cantNum:= cantNum +1;
    writeln('Ingrese otro numero');
    readln(x);
  end;
  close(a);
  prom:= total/cantNum;
  writeln('La cant de numeros menor a 1500 es de ', cantMenor);
  writeln('El prom de los num es: ', prom:0:2);
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
