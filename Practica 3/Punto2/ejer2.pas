program ejer2;
const
	valor_alto = 9999;
type
	asistente = record
		numero:integer;
		apellido:string[20];
		nombre:string[20];
		email:string[20];
		telefono:longint;
		dni:longint;
  end;
  archivo = file of asistente;

procedure leer(var a:archivo; var dato:asistente);
begin
	if(not eof(a)) then
  	read(a,dato)
  else
  	dato.numero:= valor_alto;
end;

procedure leer_asistente(var a:asistente);
begin
	writeln('Ingrese numero'); readln(a.numero);
  if(a.numero <> valor_alto) then begin
  	writeln('Ingrese nombre'); readln(a.nombre);
    writeln('Ingrese apellido'); readln(a.apellido);
  end;
end;

procedure crearArchivo(var a:archivo);
var
	asis:asistente;
  nombre:string[20];
begin
	writeln('Ingrese nombre del archivo a crear'); readln(nombre);
  assign(a,nombre);
  rewrite(a);
  leer_asistente(asis);
  while(asis.numero <> valor_alto) do begin
  	write(a,asis);
    leer_asistente(asis);
  end;
	writeln('Archivo creado con exito');
  close(a);
end;

procedure darBajaLogica(var a:archivo);
var
	asis:asistente;
begin
	reset(a);
  while(not eof(a)) do begin
  	leer(a,asis);
    if(asis.numero < 1000) then begin
    	asis.nombre := '@' + asis.nombre;
      seek(a,filepos(a) - 1);
      write(a,asis);
    end;
  end;
  close(a);
end;

procedure imprimirTodos(var a:archivo);
var
	asis:asistente;
begin
	reset(a);
  while(not eof(a)) do begin
  	leer(a,asis);
    writeln('Nombre: ', asis.nombre, ' Numero: ',asis.numero);
  end;
  close(a);
end;

var
	a:archivo;
begin
	crearArchivo(a);
  darBajaLogica(a);
  imprimirTodos(a);
end.
