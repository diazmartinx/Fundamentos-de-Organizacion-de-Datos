program ej2;

type
	archivo = file of integer;
	
procedure Consulta(var A:archivo);
var num, cantMenor, total, cant: integer;
begin
	reset(A);total:=0;cantMenor:=0;cant:=0;
	
	while not eof(A) do begin
		read(A,num);
		total:= total + num;
		cant:= cant + 1;
		if num<1500 then cantMenor:=cantMenor+1;
	end;
	
	writeln('Cantidad de numeros menor a 1500: ', cantMenor);
	writeln('Promedio: ',total/cant:2:2);
	close(A);
end;
	
var
	A:archivo; nombre:string;
begin
	writeln('Ingrese nombre del archivo a procesar: ');
	readln(nombre);
	assign(A,nombre);
	Consulta(A);
end.
