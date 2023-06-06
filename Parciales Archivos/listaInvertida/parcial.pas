program parcial;

type
	persona= record
		dni:integer;
		nombre:string;
		apellido:string;
		sueldo:real;
	end;
	tArchivo = file of persona;
	
	
procedure crear(var arch: tArchivo; var info:text);
var dato:persona;
begin
	rewrite(arch);reset(info);
	
	while not eof(info) do begin
	
		with dato do begin //asumo que hay un dato por linea
			readln(info,dni);
			readln(info,nombre);
			readln(info,apellido);
			readln(info,sueldo);
		end;
		
		write(arch,dato);
	
	end;
	
	close(arch);close(info);
end;

procedure agregar(var arch:tArchivo; p:persona);
var cabecera:persona;
begin
	reset(arch);
	leer(arch,cabecera);
	
	if cabecera.dni=0 then begin//agrega al final (no hay borrados)
		seek(arch,filesize(arch));
		write(arch,p);
	end else begin //hay un registro libre para ser reutilizado
		//me posiciono para sobreescribir el registro
		seek(arch,filepos(cabecera.dni*-1));
		//leo el dato de esa pos -> va a pasar a ser cabecera
		leer(arch,cabecera);
		//inserto mi persona (vuelvo atras)
		seek(arch,filepos(arch)-1);
		write(arch,p);
		//actualizo cabecera con ultimo dato leido
		seek(arch,0);
		write(arch,cabecera);
	end;
	
	close(arch);
end;

procedure eliminar(var arch: tArchivo; dni:integer);
var cabecera,dato:persona;
begin
	reset(arch);
	leer(arch,cabecera);
	
	//localizo elemento a eliminar
	leer(arch,dato);
	while (dato.dni <> dni) and (dato.dni <> VA) do
		leer(arch,dato);
	
	if dato.dni=dni then begin //si encontre
		//vuelvo 1 atras
		seek(arch,filepos(arch)-1);
		//leo mi nueva cabecera
		leer(arch,cabecera);
		//modifico dni de la cabecera con su posicion*-1
		cabecera.dni:= (seek(arch,filepos(arch)-1))*-1
		//escribo nueva cabecera
		seek(arch,0);
		write(arch,cabecera);
	end else
		writeln('DNI no encontrado');
	
	close(arch);
end;
