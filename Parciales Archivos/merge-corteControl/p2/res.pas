{Merge, corte de control
Una empresa de productos de limpieza posee un archivo conteniendo información 
* sobre los productos que tiene a la venta al público. De cada producto se registra: 
* código de producto, precio, stock actual y stock mínimo. Diariamente se efectúan 
* envíos a cada uno de las 2 sucursales que posee. 
* Para esto, cada sucursal envía un archivo con los pedidos de los productos 
* que necesita cada sucursal. Cada pedido contiene 
* código de producto, fecha y cantidad pedida. 
* Se pide realizar el proceso de actualización del archivo maestro 
* con los dos archivos detalle, obteniendo un informe en pantalla de 
* aquellos productos que quedaron debajo del stock mínimo y de aquellos pedidos 
* que no pudieron satisfacerse totalmente, informando: 
* la sucursal, el producto y la cantidad que no pudo ser enviada 
* (diferencia entre lo que pidió y lo que se tiene en stock) .

NOTA 1: Todos los archivos están ordenados por código de producto y el 
* archivo maestro debe ser recorrido sólo una vez y en forma simultánea con los detalle.

NOTA 2: En los archivos detalle puede no aparecer algún producto del maestro. 
* Además, tenga en cuenta que puede aparecer el mismo producto en varios detalles. 
* Sin embargo, en un mismo detalle cada producto aparece a lo sumo una vez.
* 
* }

program res;

const
	va = 9999;
	dimF = 2;

type
	st32 = string[32];
	producto = record
		cod: integer;
		precio: real;
		stockA: integer;
		stockMin: integer;
	end;
	maestro = file of producto;
	
	pedido = record
		cod: integer;
		fecha: st32;
		cant: integer;
	end;
	detalle = file of pedido;
	
	VDarchivo = array [1..dimF] of detalle;
	VDRegistro = array [1..dimF] of pedido;

procedure leer(var de:detalle;var dato:pedido);
begin
	if not eof(de) then
		read(de,dato)
	else
		dato.cod:=va;
end;

procedure minimo(var VDA:VDarchivo;var VDR:VDRegistro;var min:pedido;var suc:integer);
var i:integer;
begin
	min.cod:=va;
	for i:=1 to dimF do
		if vdr[i].cod<min.cod then begin
			min:=vdr[i];
			suc:=i;
		end;
	if min.cod<>va then
		leer(vda[suc],vdr[suc]);
end;

procedure merge(var ma:maestro;var vda:vdarchivo;var vdr:vdregistro);
var min:pedido; dato:producto; suc:integer;
begin
	reset(ma);
	
	
	minimo(vda,vdr,min,suc);
	
	while min.cod<>va do begin
		//busco codigo en ma
		read(ma,dato);
		while dato.cod<>min.cod do
			read(ma,dato);
		
		while dato.cod=min.cod do begin
			if dato.stockA<min.cant then begin
				writeln('Sucursal: ',suc);
				writeln('Producto: ',dato.cod);
				writeln('Cantidad que falto enviar: ',min.cant-dato.stockA);
				dato.stockA:=0;
			end else dato.stockA:=dato.stockA-min.cant;

			if dato.stockA<dato.stockMin then
				writeln('DEBAJO DE STOCK MINIMO: ',dato.cod);
			
			minimo(vda,vdr,min,suc);
		end;
		
		//actualizo archivo
		seek(ma,filepos(ma)-1);
		write(ma,dato);//unicamente se actualiza "cantD"
	end;
	
	close(ma);
end;
