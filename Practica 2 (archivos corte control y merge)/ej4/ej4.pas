program ej4;

const valoralto=9999; dimF=5; muyalto=99999999;

type
	log = record
		cod_usuario: integer;
		fecha:integer;
		tiempo:integer;
	end;
	
	detalle = file of log;
	maestro = file of log;
	
	vde = array [1..dimF] of detalle;
	
procedure leer(var de:detalle; var dato:log);
begin
	if not eof(de) then
		read(de,dato)
	else
		dato.cod_usuario:=valoralto;
end;

//dispongo de V
procedure minimo(var v:vde; var min:log);
var i:integer; dato:log;
begin
	min.cod:=valoralto;
	min.fecha:=muyalto;
	for i:=1 to dimF do begin
		leer(v[i],dato);
		if dato.cod_usuario<min.cod_usuario then
			if dato.fecha<min.fecha then
				min:=dato
		else
			if dato.cod_usuario<>valoralto then
				seek(v[i],filsepos(v[i])-1);
	end;
end;

var
	rma,rde,min,acum:log;
	ma:maestro;
	de:detalle;
	v:vde;
	
begin
	assign(ma,'maestro');
	rewrite(maestro);
	
	minimo(v,min);
	
	while min.cod_usuario<>valoralto do begin
		//CODIGO USUARIO
		acum.cod_usuario:=min.cod_usuario;
		while min.cod_usuario=acum.cod_usuario do begin
			// FECHA
			acum.tiempo:=0;
			acum.fecha:=min.fecha;
			while (min.cod_usuario=rde.cod_usuario) and (min.fecha=acum.fecha) do begin
				//TIEMPO (unico)
				acum.tiempo:=rde.tiempo+min.tiempo;
				minimo(v,min);
			end;
			write(ma,acum);
		end;	
	end;
	
	
	close(maestro);
end;
