program ej9;

{
* contabilizar votos por
* provincia y localidad
* 
* }

const va=9999;
type
	mesa = record
		codProv: integer;
		codLoc: integer;
		mesa: integer;
		cant: integer;
	end;
	maestro = file of mesa;
	
procedure leer(var a:maestro;var dato:mesa);
begin
	if not eof(a) then
		read(a,dato)
	else
		dato.codProv:=va;
end;

var
	a:maestro;
	dato,actual:mesa;
	totLoc,totProv,totGeneral:integer;
begin
	assign(a,'maestro');reset(a);
	leer(a,dato);
	
	totGeneral:=0;
	while dato.codProv<>va do begin
		writeln('CODIGO PROVINCIA: ',dato.codProv);
		actual.codProv:=actual.codProv;
		totProv:=0;
		while (dato.codProv=actual.codProv) do begin
			writeln('CODIGO LOCALIDAD: ',dato.codLoc);
			actual.codLoc:=dato.codLoc;
			totLoc:=0;
			while (dato.codProv=actual.codProv) and (dato.codLoc=actual.codLoc) do begin
				totLoc:=totLoc+dato.cant;
				leer(a,dato);
			end;
			writeln('VOTOS: ',totLoc);
			totProv:=totProv+totLoc;
		end;
		writeln('Total de votos Provincia: ',totProv);
		totGeneral:=totGeneral+totProv;
	end;
	writeln('TotalGeneral de votos: ',totGeneral);
	close(a);
end.
