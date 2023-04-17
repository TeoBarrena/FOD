program ejer3;
type
	cadena = string[20];
	novela = record
    	codigo:integer;
        genero:cadena;
        nombre:cadena;
        duracion:integer;
        director:cadena;
        precio:real;
    end;
  archivo = file of novela;
  
procedure leer(var a:archivo;var dato:novela);
begin
	if not eof(a) then
  	    read(a,dato)
    else
  	    dato.codigo:= 9999;
end;

procedure leerNovelaModificada(var n:novela);
begin
    writeln('Ingrese nombre de la novela'); readln(n.nombre);
    writeln('Ingrese precio de la novela'); readln(n.precio);
end;

procedure leerNovela(var n:novela);
begin
    writeln('Ingrese codigo de la novela, ingrese 9999 para finalizar'); readln(n.codigo);
    if(n.codigo <> 9999) then begin
  	    writeln('Ingrese nombre'); readln(n.nombre);
        writeln('Ingrese precio'); readln(n.precio);
    end;
end;

procedure crearArchivo(var a:archivo);
var
	nombre:cadena;
	n:novela;
begin
	writeln('Ingrese nombre del archivo'); readln(nombre);
    assign(a,nombre);
    rewrite(a);
    n.codigo:= 0;
    write(a,n);//cargo un primer registro con el codigo de novela en 0 como cabecera
    leerNovela(n);
     while(n.codigo <> 9999) do begin
  	    write(a,n);
        leerNovela(n);
    end;
end;

procedure darAltaNovela(var a:archivo);
var 
	reg,aux,n:novela;
begin
	reset(a);
	leerNovela(n);
    leer(a,aux);
    if(aux.codigo = 0) then begin //si no hay lugares disponibles agrega al final
  	    seek(a,filesize(a));
        write(a,n);
    end
    else begin
  	    seek(a,abs(aux.codigo));//te paras en el registro que estaba en la cabecera
        read(a,reg);//lees lo que esta ahi
        seek(a,0);//te posicionas en el registro cabecera
        write(a,reg);//y actualizas la cabecera con el registro que estaba en el indice de la cabecera que estaba antes
        seek(a,abs(aux.codigo));//te volves a parar en el registro que querias
        write(a,n);//sobreescribis en la posicion que estaba libre la nueva novela
  end;
    close(a);
end;

procedure modificarNovela(var a:archivo);
var 
    n:novela;
    cod:integer;
begin
    reset(a);
    writeln('Ingrese el codigo de la novela que quiere modificar');readln(cod);
    leer(a,n);
    while(not eof(a) and (n.codigo <> cod)) do 
        leer(a,n);
    if(n.codigo = cod) then begin
            leerNovelaModificada(n);
            seek(a,filepos(a)-1);
            write(a,n);
    end
    else    
      writeln('No se encontro el codigo de novela');
    close(a);
end;

procedure eliminarNovela(var a:archivo);
var
    pos,cod:integer;
    aux,n:novela;
begin
    reset(a);
    writeln('Ingrese el codigo de la novela que quiere eliminar'); readln(cod);
    leer(a,n);
    while(not eof(a) and (n.codigo <> cod)) do 
        leer(a,n);
    if(cod = n.codigo) then begin
        pos:= filepos(a)-1;//pos toma el valor de la posicion del registro 
        seek(a,0);
        read(a,aux);//cargo en aux el registro que estaba en cabecera
        seek(a,filepos(a)-1);//me paro de vuelta en el registro cabecera
        n.codigo:= n.codigo * (-1);//el codigo queda negativo
        write(a,n);//escribo en el registro cabecera el registro con el codigo negativo
        seek(a,pos);
        write(a,aux);//sobreescribo el registro
    end
    else 
      writeln('No se encontro el codigo de novela');
    close(a);
end;

procedure pasarATexto(var a:archivo);
var 
    txt:Text;
    n:novela;
begin
    reset(a);
    assign(txt,'novelas.txt');
    rewrite(txt);
    while(not eof(a)) do begin
        leer(a,n);
        writeln(txt,n.nombre);
        writeln(txt,n.codigo);
        writeln(txt,n.precio:0:2);
    end;
    close(a);
    close(txt);
end;

procedure menu(var a:archivo);
var
	letra:string[1];
	x:integer;
begin
	writeln('Ingrese A para crear archivo y cargarlo');
    writeln('Ingrese B para abrir el archivo y mantenerlo');
    writeln('Ingrese C para listar en archivo de texto todas las novelas');
    writeln('Ingrese Z para finalizar');
    readln(letra);
  while(letra <> 'Z') do begin
  	case letra of
  		'A': crearArchivo(a);
    
    	'B': begin
    			 writeln('Ingrese 1 para dar de alta una novela');
    			 writeln('Ingrese 2 para modificar datos de una novela');
      	         writeln('Ingrese 3 para eliminar una novela');
      	         readln(x);
      	    case x of
      	  	    1: darAltaNovela(a);
       	        2: modificarNovela(a);
       	        3: eliminarNovela(a);
       	    end;
       	 end;
    	'C': pasarATexto(a);
  	end;
    writeln('Ingrese A para crear archivo y cargarlo');
  	writeln('Ingrese B para abrir el archivo y mantenerlo');
  	writeln('Ingrese C para listar en archivo de texto todas las novelas');
  	writeln('Ingrese Z para finalizar');
  	readln(letra);
  end;  
end;

var
	a:archivo;
begin
	menu(a);
end.
