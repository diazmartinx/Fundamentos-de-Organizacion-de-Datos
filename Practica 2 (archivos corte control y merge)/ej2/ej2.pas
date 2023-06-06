program ej2;
const valoralto=9999;

type
	st32 = string[32];
	alumno = record
		cod: integer;
		nombre: st32;
		apellido: st32;
		sinFinal: integer;
		conFinal: integer;
	end;
	
	Rdetalle = record
		cod: integer;
		nombreMateria: st32;
		aFinal: char;
		aCursada: char;
	end;
	
	Tmaestro = file of alumno;
	
procedure generaMaestro(var ma:Tmaestro);
var dato:alumno; maestrotxt:text;
begin
	rewrite(ma);
	assign(maestrotxt,'alumnos.txt');
	reset(maestrotxt);
	
	while (not eof(maestrotxt)) do begin
		with dato do begin
			readln(maestrotxt,cod);
			readln(maestrotxt,nombre);
			readln(maestrotxt,apellido);
			readln(maestrotxt,conFinal);
			readln(maestrotxt,sinFinal);
		end;
		write(ma,dato);
	end;
	
	close(ma);close(maestrotxt);
end;
	
procedure leer (var detalle:text; var dato:Rdetalle);
	begin
		if (not eof(detalle)) then
			with dato do begin
				readln(detalle,cod,nombreMateria);
				readln(detalle,aFinal);
				readln(detalle,aCursada);
			end
		else 
			dato.cod:= valoralto;
end;

	
var
	maestro:Tmaestro;
	detalle:text;
	datoAlumno:alumno;
	datoDetalle:Rdetalle;
	codActual,totalConF,totalSinF:integer;
	masde4:text;
begin
	assign(maestro,'maestro');generaMaestro(maestro);
	assign(detalle,'detalle.txt');
	assign(masde4,'masde4.txt');rewrite(masde4);
	
	reset(maestro);reset(detalle);
	
	read(maestro,datoAlumno);
	leer(detalle,datoDetalle);
	while datoDetalle.cod <> valoralto do begin
			
		codActual:=datoDetalle.cod;
		totalConf:=0;
		totalSinF:=0;
		while datoDetalle.cod = codActual do begin
			
			if datoDetalle.aFinal='A' then
				totalConf:=totalConf+1
			else totalSinF:=totalSinF+1;
			
			leer(detalle,datoDetalle);
		end;
			
		while datoAlumno.cod<>codActual do
			read(maestro,datoAlumno);
		
		datoAlumno.conFinal:=datoAlumno.conFinal+totalConF;
		datoAlumno.sinFinal:=datoAlumno.sinFinal+totalSinF;
			
		seek(maestro,filepos(maestro)-1);
		
		write(maestro,datoAlumno);
		
		with datoAlumno do
			writeln(cod,' | ', nombre,' | ',apellido,' | ',conFinal,' | ',sinFinal);
			
		if datoAlumno.sinFinal>4 then begin
			with datoAlumno do begin
				writeln(masde4,cod);
				writeln(masde4,nombre);
				writeln(masde4,apellido);
				writeln(masde4,conFinal);
				writeln(masde4,sinFinal);
			end;
		end;
			
		if not eof(maestro) then
			read(maestro,datoAlumno);
	end;
	
	close(maestro);
	close(detalle);
	close(masde4);

end.
