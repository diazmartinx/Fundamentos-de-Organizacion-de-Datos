program ej3;

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
var emp:empleado; nombre:st32;
begin
	reset(empleados);
		writeln('Ingrese nombre o apellido a buscar: ');readln(nombre);
		while not eof(empleados) do begin
			read(empleados,emp);
			if (emp.nombre=nombre) or (emp.apellido=nombre) then
				ImprimeEmpleado(emp);
		end;
	close(empleados);
end;

procedure Mayores70(var empleados:archivo);
var emp:empleado; 
begin
	reset(empleados);
	while not eof(empleados) do begin
		read(empleados,emp);
		if emp.edad>70 then
			ImprimeEmpleado(emp);
	end;
	close(empleados);
end;

var
	empleados: archivo;
	opcion: integer;
	nombre: st32;
begin
	writeln('Ingrese nombre de archivo: ');readln(nombre);
	assign(empleados,nombre);
	
	opcion:=0;
	while opcion<>9 do begin
		writeln('Ingrese opcion:');
		writeln('1 - Crear un archivo');
		writeln('2 - Listar en pantalla los datos de empleados que tengan un nombre o apellido determinado.');
		writeln('3 - Listar en pantalla los empleados de a uno por línea.');
		writeln('4 - Listar en pantalla empleados mayores de 70 años, próximos a jubilarse.');
		writeln('9 - Finalizar.');
		readln(opcion);
		case opcion of
			1: Alta(empleados);
			2: ConsultaPorNombre(empleados);
			3: Consulta(empleados);
			4: Mayores70(empleados);
		end;
	end;
end.
		
