program ej1;
const valAlto=9999;

type
	st32 = string[32];
	comision = record
		cod: integer;
		nombre: st32;
		monto: real;
	end;
	
	archivo = file of comision;
	

	
procedure leer(var detalle:text; var dato:comision; var codigo:integer);
begin
	if (not eof(detalle)) then begin
		readln(detalle,dato.cod);
		readln(detalle,dato.nombre);
		readln(detalle,dato.monto);
	end else 
		codigo := valAlto;
end;
	
var
	maestro:archivo;
	detalle:text;
	Rcomision,actual:comision;
	codEmp:integer;
begin
	assign(maestro,'maestro');
	assign(detalle,'empleados.txt');
	rewrite(maestro);reset(detalle);
	
	leer(detalle,Rcomision,codEmp);
	
	while Rcomision.cod <> valAlto do begin
		actual:=Rcomision;
		actual.monto:=0;
		codEmp:=Rcomision.cod;
		while codEmp=Rcomision.cod do begin
			actual.monto:=actual.monto+Rcomision.monto;
			leer(detalle,Rcomision,codEmp);
		end;
		write(maestro,actual);
		with actual do
			writeln(cod,' | ',nombre,' | ',monto:2:2);
	end;
	
	close(maestro);close(detalle);

end.
