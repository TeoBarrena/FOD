program ejer4;
type
    reg_flor = record
        nombre: String[45];
        codigo:integer;
    end;
    archivo = file of reg_flor;

procedure crearArchivo(var a:archivo);
var
    r:reg_flor;
begin
    assign(a,'archivo_flores');
    rewrite(a);
    r.nombre:= 'reg cabecera';
    r.codigo:= 0;
    write(a,r);
    close(a);
end;

procedure agregarFlor(var a:archivo;nombre:string;codigo:integer);
var 
    reg,aux,r:reg_flor;
begin
    reset(a);
    r.nombre:= nombre;
    r.codigo:= codigo;
    read(a,aux);
    if(aux.codigo = 0) then begin
        seek(a,filesize(a));
        write(a,r);
    end
    else begin
        seek(a,abs(aux.codigo));
        read(a,reg);
        seek(a,0);
        write(a,reg);
        seek(a,abs(aux.codigo));
        write(a,r);
    end;
    close(a);
end;

procedure listarDatos(var a:archivo);
var 
    r:reg_flor;
begin
    reset(a);
    while(not eof(a)) do begin
        read(a,r);
        if(r.codigo > 0) then 
            writeln('Numero: ',r.nombre, ' codigo: ',r.codigo);
    end;
    close(a);
end;

procedure eliminarFlor(var a:archivo;flor:reg_flor);
var 
    aux,f:reg_flor;
    pos:integer;
begin
    reset(a);
    read(a,f);
    while(not eof(a) and (flor.codigo <> f.codigo)) do    
        read(a,f);
    //aca encontraste la flor
    pos:= filepos(a)-1; //tomo el valor de la posicion de la flor que quiero eliminar
    seek(a,0);
    read(a,aux); //tomo el registro cabecera
    seek(a,filepos(a)-1);//me paro de nuevo en la cabecera
    flor.codigo:= flor.codigo * (-1);//pongo el codigo en negativo de la flor que elimino
    write(a,flor);//lo escribo en el registro cabecera
    seek(a,pos); //voy a la posicion en la que estaba la flor
    write(a,aux);//sobreescribo esa posicion con el contenido que estaba antes en cabecera
    close(a);
end;

var 
    r:reg_flor;
    a:archivo;
    codigo,x:integer;
    nombre:string;
begin
    crearArchivo(a);
    writeln('1.Agregar flor');
    writeln('2.Eliminar flor');
    writeln('3.Listar datos');
    writeln('4.Finalizar');
    readln(x);
    while(x <> 4) do begin
        case x of
            1: begin
                writeln('Ingrese nombre'); readln(nombre);
                writeln('Ingrese codigo'); readln(codigo);
                agregarFlor(a,nombre,codigo);    
            end;
            2: begin
                writeln('Ingrese nombre'); readln(r.nombre);
                writeln('Ingrese codigo'); readln(r.codigo);
                eliminarFlor(a,r);
            end;    
            3: 
                listarDatos(a); 
        end;
        writeln('1.Agregar flor');
        writeln('2.Eliminar flor');
        writeln('3.Listar datos');
        writeln('4.Finalizar');
        readln(x);
    end;
end.
