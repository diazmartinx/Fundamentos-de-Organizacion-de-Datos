program ej5y6;

{celulares.txt disposicion:
cod precio marca 
stockDisp stockMin descripcion
nombre
* }

type
	st32 = string[32];
	producto = record
		cod: integer;
		stockMin: integer;
		stockDisp: integer;
		precio: real;
		nombre: st32;
		descripcion: st32;
		marca: st32;
	end;
	
	Aproductos = file of producto;
	
procedure ImprimeUno(celular:producto);
begin
	with celular do begin
		writeln(cod,' | ',
		precio:2:2,' | ',
		stockMin,' | ',
		stockDisp,' | ',
		nombre,' | ',
		descripcion,' | ',
		marca);
	end;
end;
	
procedure Alta(var productos:Aproductos);
var celulares:text; celular:producto;
begin
	assign(celulares,'celulares.txt');
	reset(celulares);
	rewrite(productos);
	
	while not eof(celulares) do begin
		with celular do begin
			readln(celulares,cod, precio, marca);
			readln(celulares,stockDisp,stockMin,descripcion);
			readln(celulares,nombre);
		end;
		write(productos,celular);
	end;
	
	close(celulares);
	close(productos);
end;

procedure ListaStockMinimo(var productos:Aproductos);
var celular:producto;
begin
	reset(productos);
	
	while not eof(productos) do begin
		read(productos,celular);
		if celular.stockDisp<celular.stockMin then
			ImprimeUno(celular);
	end;
	
	close(productos);
end;

procedure ListaCadena(var productos:Aproductos);
var celular:producto; cadena:st32; posi:integer;
begin

	writeln('Ingrese descripcion a buscar');
	readln(cadena);

	reset(productos);
	
	while not eof(productos) do begin
		read(productos,celular);
		
		posi:= Pos(cadena,celular.descripcion);
		
		if posi>0 then
			ImprimeUno(celular);
	end;
	
	close(productos);
end;

procedure Exporta(var productos:Aproductos);
var celular:producto; destino:text;
begin
	assign(destino,'celulares.txt');
	rewrite(destino);reset(productos);
	
	while not eof(productos) do begin
		read(productos,celular);
		with celular do begin
			writeln(destino,cod,precio,marca);
			writeln(destino,stockDisp,' ',stockMin,descripcion);
			writeln(destino,nombre);
		end;
	end;
	
	close(destino);close(productos);
end;

procedure AniadeUno(var productos:Aproductos);
var nuevo:producto;
begin
	reset(productos);
	
	seek(productos,filesize(productos));
	
	with nuevo do begin
		nombre:='nuevo';
		descripcion:=' nuevo';
		marca:=' nuevo';
		cod:=Random(500)+1;
		stockMin:=Random(500)+1;
		stockDisp:=Random(500)+1;
		precio:=150.00;
	end;
	
	write(productos,nuevo);
	
	close(productos);
end;

procedure ModificaStock(var productos:Aproductos; nombre:st32; stock:integer);
var aModificar:producto; encontre:boolean;
begin
	reset(productos); encontre:=false;
	
	while (not eof(productos)) and (not encontre) do begin
		read(productos,aModificar);
		if aModificar.nombre=nombre then begin
			aModificar.stockDisp:=stock;
			encontre:=true;
			seek(productos,filepos(productos)-1);
			write(productos,aModificar);
			writeln('Stock Modificado con exito');
		end;
	end;
	
	close(productos);
	
	if not encontre then
		writeln('El producto no se encontro');
end;

procedure SinStock(var productos:Aproductos);
var celular:producto; destino:text;
begin
	assign(destino,'SinStock.txt');
	reset(productos); rewrite(destino);
	
	while not eof(productos) do begin
		read(productos,celular);
		if celular.stockDisp=0 then
			with celular do begin
				writeln(destino,cod,precio,marca);
				writeln(destino,stockDisp,' ',stockMin,descripcion);
				writeln(destino,nombre);
			end;
	end;
	
	close(productos); close(destino);
end;
	
var
	productos:Aproductos;
	
begin
	Randomize;
	assign(productos,'productosEj5y6.dat');
	Alta(productos);
	//ListaStockMinimo(productos);
	//ListaCadena(productos);
	
	AniadeUno(productos);
	ModificaStock(productos,'NombreA',0);
	SinStock(productos);
	Exporta(productos);
end.
