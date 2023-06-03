program ej1;

type
	archivo = file of integer;
	

procedure LeerArchivo(var A:archivo);
var num: integer; nombre:string;
begin
	writeln('Ingrese nombre del archivo:');
	readln(nombre);
	
	assign(A,nombre);
	rewrite(A);
	
	writeln('Numero: ');readln(num);
	while num <> 30000 do begin
		write(A,num);
		writeln('Numero: ');readln(num);
	end;
	
	close(A);
end;
	
var
	A:archivo;
begin
	LeerArchivo(A);
end.
