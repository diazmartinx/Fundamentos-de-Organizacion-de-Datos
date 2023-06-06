program ej3;
uses crt;
type
	st32 = string[32];
	empleado = record
		num: integer;
		apellido: st32;
		nombre: st32;
		edad: integer;
		dni: integer;
	end;
	
	archivo = file of empleado;
	
	
procedure Alta(var empleados: archivo);
var emp:empleado;
begin
	
	rewrite(empleados);
	writeln('Ingrese apellido: ');readln(emp.apellido);
	
	while emp.apellido <> 'fin' do begin
		writeln('DNI: ');readln(emp.dni);
		emp.num:=emp.dni;
		writeln('Nombre: ');readln(emp.nombre);
		writeln('Edad: ');readln(emp.edad);
		
		write(empleados,emp);
		
		writeln('Ingrese apellido: ');readln(emp.apellido);
	end;
	
	
	close(empleados);
end;

procedure ImprimeEmpleado( emp:empleado);
begin
	with emp do
			writeln(num,' | ',apellido,' | ',nombre,' | ',edad,' | ',dni);
end;

procedure Consulta(var empleados:archivo);
var emp:empleado;
begin 
	
	reset(empleados);
	
	while not eof(empleados) do begin
		read(empleados,emp);
		ImprimeEmpleado(emp);
	end;
	
	close(empleados);
end;


procedure ConsultaPorNombre(var empleados:archivo);
var emp:empleado; nombre:st32; encontro:boolean;
begin
	encontro:=false;
	reset(empleados);
		writeln('Ingrese nombre o apellido a buscar: ');readln(nombre);
		while not (eof(empleados)) and (not encontro) do begin
			read(empleados,emp);
			if (emp.nombre=nombre) or (emp.apellido=nombre) then begin
				ImprimeEmpleado(emp);
				encontro:=true;
			end;
		end;
		if not encontro then
			writeln ('No se encontro ningun empleado');
	close(empleados);
end;

procedure Mayores70(var empleados:archivo);
var emp:empleado; encontro:boolean;
begin
	encontro:=false;
	reset(empleados);
	while not eof(empleados) do begin
		read(empleados,emp);
		if emp.edad>70 then begin
			ImprimeEmpleado(emp);
			encontro:=true;
		end;
	end;
	close(empleados);
	if not encontro then
		writeln ('No se encontraron empleados mayores de 70 años');
end;

function ExisteEmpleado(var empleados:archivo; num:integer):boolean;
var emp:empleado;encontro:boolean;
begin
	encontro:=false;
	reset(empleados);
		while (not eof(empleados)) and (not encontro) do begin
			read(empleados,emp);
			if emp.num = num then
				encontro:=true;
		end;
	close(empleados);
	ExisteEmpleado := encontro;
end;


Procedure AnadeEmpleados(var empleados:archivo);
var empNuevo:empleado;
begin
	
	writeln('Ingrese numero de empleado:');
	readln(empNuevo.num);
	// Si el empleado existe = true, -> vuelve a preguntar por num
	while ExisteEmpleado(empleados,empNuevo.num) do begin
		writeln('Ya existe un empleado con ese numero');
		writeln('Ingrese numero de empleado unico:');
		readln(empNuevo.num);
	end;
	
	
	// Num no existe -> agrego empleado al final		
	empNuevo.dni := empNuevo.num;
	empNuevo.nombre := '0';
	empNuevo.apellido := '0';
	empNuevo.edad := empNuevo.num;
	reset(empleados);
	seek(empleados, fileSize(empleados)); // se ubica en la ultima pos
	write(empleados, empNuevo);
	writeln('Agregado con exito');
	close(empleados);
end;

Procedure ModificaEdad(var empleados:archivo);
var emp:empleado; num:integer; encontro:boolean;
begin
	encontro:=false;
	writeln('Ingrese numero de empleado a modificar');
	readln(num);
	reset(empleados);
	while (not eof(empleados)) and (not encontro) do begin
		read(empleados,emp);
		if emp.num=num then begin
			encontro:=true;
			seek(empleados,filepos(empleados)-1);
			writeln('Ingrese nueva edad:');
			read(emp.edad);
			write(empleados,emp);
		end;
	end;
	close(empleados);
	if not encontro then
		writeln('No existe empleado con ese numero');
end;

Procedure ExportaCompleto(var empleados:archivo);
var emp:empleado; destino:text;
begin
	assign(destino,'todos_empleados.txt');
	rewrite(destino);
	reset(empleados);
	
	while not eof(empleados) do begin
		read(empleados,emp);
		with emp do begin
			writeln(destino,num,' ',edad,' ',dni,' ',nombre);
			writeln(destino, apellido);
		end;
	end;
	writeln('Exportacion terminada');
	close(empleados);
	close(destino);
	
end;

procedure Eliminar(var empleados:archivo);
var emp,ultimo:empleado; num:integer; encontre:boolean;
begin
	reset(empleados);
	writeln('Ingrese codigo de empleado: ');
	readln(num);
	encontre:=false;
	
	//guardo el ultimo registro
	seek(empleados,filesize(empleados)-1);
	read(empleados,ultimo);
	
	//vuelvo al principio y leo
	reset(empleados);
	read(empleados,emp);
	
	//avanzo hasta mi empleado
	while (not eof(empleados)) and (not encontre) do begin
		if num=emp.num then begin//lo encontre
			encontre:=true;
			//vuelvo 1 atras y escribo
			seek(empleados,filepos(empleados)-1);
			write(empleados,ultimo);
			//voy al final -1 y trunco
			seek(empleados,filesize(empleados)-1);
			truncate(empleados);
		end;
		read(empleados,emp);
	end;
	
	if not encontre then begin
		writeln('No se encontro empleado');
		close(empleados);
	end;
	
	
end;

var
	empleados: archivo;
	opcion: integer;
	nombre: st32;
begin
	writeln('Ingrese nombre de archivo: ');readln(nombre);
	assign(empleados,nombre);
	
	opcion:=-1;
	while opcion<>0 do begin
		writeln('Ingrese opcion:');
		writeln('1 - Crear un archivo');
		writeln('2 - Listar en pantalla los datos de empleados que tengan un nombre o apellido determinado.');
		writeln('3 - Listar en pantalla los empleados de a uno por línea.');
		writeln('4 - Listar en pantalla empleados mayores de 70 años, próximos a jubilarse.');
		writeln('5 - Anadir uno o mas empleados');
		writeln('6 - Modificar edad a uno o mas empleados');
		writeln('7 - Exportar contenido a "todos_empleados.txt"');
		writeln('8 - Exportar empleados con DNI = 00 a "FaltaDNIEmpleado.txt"');
		writeln('9 - Eliminar un empleado.');
		readln(opcion);
		case opcion of
			1: Alta(empleados);
			2: ConsultaPorNombre(empleados);
			3: Consulta(empleados);
			4: Mayores70(empleados);
			5: AnadeEmpleados(empleados);
			6: ModificaEdad(empleados);
			7: ExportaCompleto(empleados);
			9: Eliminar(empleados);
		end;
	end;
end.
		
