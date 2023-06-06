program ej7;

type
	st32 = string[32];
	novela = record
		cod: integer;
		precio: real;
		genero: st32;
		nombre: st32;
	end;
	
	Anovelas = file of novela;
	
	
procedure Alta(var novelas:Anovelas);
var elemento:novela; data:text;
begin
	assign(data,'novelas.txt');
	rewrite(novelas);reset(data);
	while not eof(data) do begin
		with elemento do begin
			readln(data,cod,precio,genero);
			readln(data,nombre);
		end;
		write(novelas,elemento);
	end;
	close(novelas);
	close(data);
end;

procedure Agrega(var novelas:Anovelas);
var nuevo:novela; cod:integer; existe:boolean;
begin
	reset(novelas); existe:=false;
	
	writeln('Ingrese codigo de novela:');
	readln(cod);
	
	while (not eof(novelas)) and (not existe) do begin
		read(novelas,nuevo);
		if (nuevo.cod=cod) then begin
			writeln('El codigo ya existe');
			existe:=true;
		end;
	end;
	
	if not existe then begin
		writeln('Precio: ');readln(nuevo.precio);
		writeln('Genero: ');readln(nuevo.genero);
		writeln('Nombre: ');readln(nuevo.nombre);
		nuevo.cod:=cod;
		seek(novelas,filesize(novelas)); //agrega al final
		write(novelas,nuevo);
		writeln('Operacion de escritura exitosa');
	end;
	
	close(novelas);
end;

procedure Actualiza(var novelas:Anovelas);
var nuevo:novela; cod:integer; existe:boolean;
begin
	reset(novelas); existe:=false;
	
	writeln('Ingrese codigo de novela:');
	readln(cod);
	
	while (not eof(novelas)) and (not existe) do begin
		read(novelas,nuevo);
		if (nuevo.cod=cod) then begin
			existe:=true;
			writeln('Precio: ');readln(nuevo.precio);
			writeln('Genero: ');readln(nuevo.genero);
			writeln('Nombre: ');readln(nuevo.nombre);
			seek(novelas,filesize(novelas)-1);
			write(novelas,nuevo);
			writeln('Operacion de actualizado exitosa');
		end;
	end;
	
	if not existe then
		writeln('No se encontro novela');
	
	close(novelas);
end;

procedure Imprime(var novelas:Anovelas);
var nuevo:novela;
begin
	reset(novelas);
	
	
	while (not eof(novelas)) do begin
		read(novelas,nuevo);
		with nuevo do
			writeln(cod,' | ',precio:2:2,' | ',genero,' | ',nombre);
	end;
	
	close(novelas);
end;

var
	novelas:Anovelas;
begin
	assign(novelas,'novelas.dat');
	//Alta(novelas);
	Agrega(novelas);
	Actualiza(novelas);
	Imprime(novelas);
end.
	
