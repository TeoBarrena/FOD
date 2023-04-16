{4. Agregar al menú del programa del ejercicio 3, opciones para:
a. Añadir una o más empleados al final del archivo con sus datos ingresados por
teclado.
b. Modificar edad a una o más empleados.
c. Exportar el contenido del archivo a un archivo de texto llamado
“todos_empleados.txt”.
d. Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, los empleados
que no tengan cargado el DNI (DNI en 00).
NOTA: Las búsquedas deben realizarse por número de empleado.}

program ej4;
type
	cadena20 = string[20];
	empleado = record
  	numero:integer;
    apellido:cadena20;
    nombre:cadena20;
    edad:integer;
    dni:longint;
  end;
	archivo = file of empleado;

procedure leerEmpleado(var e:empleado);
begin
	writeln('Ingrese apellido');
  readln(e.apellido);
  if (e.apellido <> 'fin') then begin
  	writeln('Ingrese nombre');
  	readln(e.nombre);
    writeln('Ingrese numero');
  	readln(e.numero);
    writeln('Ingrese edad');
 	  readln(e.edad);
    writeln('Ingrese dni');
  	readln(e.dni);
  end;
end;

procedure crearArchivo(var a:archivo);
var
  e:empleado;
	nombreArc:string[20];
begin
	writeln('Ingrese nombre del archivo');
	readln(nombreArc);
  assign(a,nombreArc); {se asigna el nombre al archivo}
  rewrite(a);{se crea el archivo}
  leerEmpleado(e);
  while(e.apellido <> 'fin') do begin
  	write(a,e);
    writeln('Ingrese otro empleado');
    leerEmpleado(e);
  end;
  close(a);
end;

procedure leer(var a:archivo; var dato:empleado);
begin
	if(not eof(a)) then
  	read(a,dato)
  else
  	dato.numero:= 9999;
end;

Procedure recorridoTotal(var a: archivo );
var 
	e: empleado; { para leer elemento del archivo}
begin
	reset(a); {archivo ya creado, para operar debe abrirse como de lect/escr}
	while not eof(a) do begin
		read(a,e);
		writeln('apellido:', e.apellido); 
		writeln('nombre: ', e.nombre);
    writeln('edad:', e.edad);
	end;
	close(a);
end;	

procedure mostrarDatos(e:empleado);
begin
	writeln('apellido: ', e.apellido, ' nombre: ', e.nombre);
end;

procedure NombreDet(var a:archivo);
var
 e:empleado;
 nombre:cadena20;
begin
  reset(a);
  writeln('Ingrese apellido o nombre de los empleados que quiere buscar con cierto nombre o apellido');
  readln(nombre);
  while not eof (a) do begin
  	read(a,e);
    if(e.apellido = nombre) or (e.nombre = nombre) then
    	mostrarDatos(e);
  end;
  close(a);
end;

procedure mayor70(var a:archivo);
var 
	e:empleado;
begin
	reset(a);
	while not eof (a) do begin
  	read(a,e);
    if(e.edad > 70) then 
    	mostrarDatos(e);
  end;
  close(a);
end;

procedure aniadirEmpleado(var a:archivo);
var
	x:integer;
	e:empleado;
  seguir:boolean;
begin
	reset(a);
	seguir:= true;
	leerEmpleado(e);
  while(e.apellido <> 'fin') and (seguir) do begin
  	seek(a,filesize(a));
    write(a,e);
    writeln('1 para aniadir otro empleado');
    writeln('2 para finalizar este proceso');
    readln(x);
    if (x = 2) then
    	seguir:= false
    else
    	leerEmpleado(e);
  end;
  close(a);
end;

procedure modificarEdad(var a:archivo);
var
	cant,edad,num:integer;
  e:empleado;
begin
	cant:= 0;
	reset(a);
	writeln('Ingrese num de empleado al que se modificara la edad');
  readln(num);
  repeat
  	read(a,e);
    cant:= cant + 1;
  until(eof (a)) or (e.numero = num);
  if(e.numero = num) then begin
  	writeln('Empleado encontrado');
    writeln('Ingrese la nueva edad');
    readln(edad);
  	e.edad:= edad;
    seek(a,filepos(a)-1);
    write(a,e);
  end
  else
  	writeln('No se encontro el empleado');
  seek(a,filepos(a)-cant); {me paro en el inicio del archivo}
  close(a);
end;

procedure exportarArc(var a:archivo);
var
	txt:Text;
  e:empleado;
begin
	assign(txt,'todos_empleados.txt');
  rewrite(txt); {creas el archivo txt}
  reset(a);
  while not eof (a) do begin
  	read(a,e);
    write(txt,' ', e.apellido, ' ',e.nombre , ' ', e.dni, ' ', e.edad, ' ', e.numero);
  end;
  writeln('Exportado');
  close(a);
  close(txt);
end;

procedure exportarArcTex(var a:archivo);
var
	txt: Text;
  e:empleado;
begin
	assign(txt,'faltaDNIEmpleado.txt');
  rewrite(txt);
  reset(a);
  while not eof (a) do begin
  	read(a,e);
    if(e.dni = 00) then
    	write(txt,' ', e.apellido, ' ',e.nombre , ' ', e.dni, ' ', e.edad, ' ', e.numero);
  end;  	
	close(a);
  close(txt);
end;

procedure darBaja(var a:archivo);
var
	pos,cod:integer;
  e:empleado;
begin
	writeln('Ingrese el codigo del empleado que quiere eliminar'); readln(cod);
  reset(a);
  leer(a,e);
  while(not eof(a) and (cod <> e.numero)) do 
  	leer(a,e);
  if(cod = e.numero) then begin
  	pos:= filepos(a)-1;//copio el numero de la posicion
    seek(a,filesize(a)-1);//vas a la posicion del ultimo registro en filesize(a) esta el eof
    if(pos = filesize(a)-1) then begin//verifica para borrar el de la ultima posicion xq sino no lo borraba
		seek(a,pos);
		truncate(a);
	end
	else begin
		read(a,e);//leo el ultimo registro
		seek(a,filepos(a)-1);//voy una pos. atras para truncarlo
		truncate(a);//borra todo lo que esta despues de esa posicion y establece el eof
		seek(a,pos);//voy a la posicion del que quiero borrar
		write(a,e);//lo sobreescribo
	end;
  end
  else
  	writeln('El empleado con ese numero de codigo no existe');
	close(a);
end;
	

procedure menu(var a:archivo);
var
	x:integer;
begin
	  writeln('---------------MENU---------------');
		writeln('abrir el archivo para: ');
    writeln('1: Listar en pantalla los empleados de a uno por linea.');
    writeln('2: Listar en pantalla los datos de empleados que tengan un nombre o apellido determinado.');
    writeln('3: Listar en pantalla empleados mayores de 70 anios, proximos a jubilarse.');
    writeln('4: Aniadir una o más empleados al final del archivo con sus datos ingresados por teclado.');
    writeln('5: Modificar edad a una o más empleados.');
    writeln('6: Exportar el contenido del archivo a un archivo de texto llamado “todos_empleados.txt”.');
    writeln('7: Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, los empleados que no tengan cargado el DNI (DNI en 00).');
    writeln('8: Dar de baja a un empleado');
    writeln('9: finalizar');
		readln(x);
    while(x <> 9) do begin
      case x of
        1: 
            recorridoTotal(a);

        2: 
            NombreDet(a);

        3: 
            mayor70(a);
        4: 
            aniadirEmpleado(a);
        5:
        	  modificarEdad(a);
        6: 
        	  exportarArc(a);
        7:
        	  exportarArcTex(a);
        8: 
        		darBaja(a);
      end;
      writeln('---------------MENU---------------');
      writeln('abrir el archivo para: ');
      writeln('1: Listar en pantalla los empleados de a uno por linea.');
      writeln('2: Listar en pantalla los datos de empleados que tengan un nombre o apellido determinado.');
      writeln('3: Listar en pantalla empleados mayores de 70 anios, proximos a jubilarse.');
      writeln('4: Aniadir una o más empleados al final del archivo con sus datos ingresados por teclado.');
      writeln('5: Modificar edad a una o más empleados.');
      writeln('6: Exportar el contenido del archivo a un archivo de texto llamado “todos_empleados.txt”.');
      writeln('7: Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, los empleados que no tengan cargado el DNI (DNI en 00).');
      writeln('8: Dar de baja a un empleado');
      writeln('9: Finalizar');
      readln(x);
    end;	
end;

var
	a:archivo;
begin
  crearArchivo(a);
  menu(a);
  recorridoTotal(a);
end.
