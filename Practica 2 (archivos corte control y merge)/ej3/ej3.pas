program ej3;

const valoralto=9999;
	sucursales=30;
	cantProductos = 10;
	
type
	st32 = string[32];
	producto = record
		cod: integer;
		nombre: st32;
		descripcion: st32;
		stockD: integer;
		stockMin: integer;
		precio: real;
	end;
	
	ingreso = record
		cod: integer;
		cant: integer;
	end;
	
	maestro = file of producto;
	detalle = file of ingreso;
	
	Vdetalle = array[1..sucursales] of detalle;
	VUltimoLeido = array[1..sucursales] of ingreso;
	
procedure generaMaestro(var ma:maestro);
var dato:producto; i:integer; resultado:string;
begin
	rewrite(ma);
	for i:=1 to cantProductos do begin
		with dato do begin
			Str(i,resultado);
			cod:=i;
			nombre:='Producto ' +  resultado;
			descripcion:='Descripcion ' + resultado;
			stockD:=Random(100);
			stockMin:=Random(100);
			precio:=Random(100);
		end;
		write(ma,dato);
		//with dato do
			//writeln(cod,'|',nombre,'|',stockD,'|',stockMin);
	end;
	close(ma);
end;

procedure generaDetalle(var de:detalle; pos:integer);
var dato:ingreso; i:integer; 
begin
	
	rewrite(de);
	if pos<>2 then // aca vienen 0
		for i:=1 to cantProductos do begin
			if (i<>0) and (i mod 2 = 0) then begin
				dato.cod:=i;
				dato.cant:=Random(1000);
				write(de,dato);
			end;
			
		end;
	
	close(de);
end;

procedure leer(var de:detalle; var dato:ingreso);
begin
	if (not eof(de)) then
		read(de,dato)
	else
		dato.cod:=valoralto;
end;

procedure minimo(var vde:Vdetalle; var min:ingreso);
var i:integer; dato:ingreso;
begin
	min.cod:=valoralto;
	for i:=1 to sucursales do begin
		leer(vde[i],dato);
		if dato.cod<min.cod then begin
			min:=dato;			
		end else if dato.cod <> valoralto then// si leyo y no cumpio, vuelvo atras
			seek(vde[i],filepos(vde[i])-1);
	end;
end;
	
var
	ma:maestro;
	VDE:Vdetalle;
	i:integer;
	num:string;
	rma:producto;
	rde,min:ingreso;
begin
	Randomize;
	assign(ma,'maestro');
	generaMaestro(ma);
	for i:=1 to sucursales do begin
		Str(i,num);
		//writeln('Sucursal: '+num);
		assign(vde[i],'detalle'+num);
		generaDetalle(VDE[i],i);
		reset(VDE[i]);
	end;
	
	reset(ma);
	
	read(ma,rma);
	minimo(VDE,min);
	
	while min.cod < valoralto do begin
		//totaliza
		rde.cant:=0;
		rde.cod:=min.cod;
		while min.cod = rde.cod do begin
			rde.cant:=rde.cant+min.cant;
			minimo(vde,min);
		end;
		
		//busco el maestro con mismo cod
		while rma.cod<>rde.cod do
			read(ma,rma);
			
		//modifico cantidad
		rma.stockD:=rma.stockD-rde.cant;
		
		//reubico puntero en el maestro
		seek(ma,filepos(ma)-1);
		
		//actualizo
		write(ma,rma);
		with rma do
			writeln(cod,' | ',stockD);
		
		//avanzo en el maestro
		if not eof(ma) then
			read(ma,rma);
		
	end;
	
	close(ma);
	for i:=1 to sucursales do
		close(VDE[i]);
end.
