program resolucion;

const
	VA = 9999;
	dimF = 5;
	
type
	rango = 1..dimF;
	st32 = string[32];
	corredor = record
		dni:integer;
		apellido:st32;
		nombre:st32;
		kms:integer;
		gano:integer;
	end;
	
	detalle = file of corredor;
	VecRegde = array [rango] of corredor; //Vector de registros
	VecArchDe = array [rango] of detalle; //Vector de archivos DETALLE
	maestro = file of corredor;
	
procedure leer(var a:detalle; var dato:corredor);
begin
	if (not eof(a)) then
		read(a,dato)
	else
		dato.dni:=VA;
end;

procedure minimo(var VAD:vecarchde;var v:vecregde;var min:corredor);
var i,minI:integer;
begin

	min.dni:=VA;
	for i:=1 to dimF do 
		if v[i].dni<min.dni then begin
			min:=v[i];
			minI:=i;
		end;
	
	if min.dni<>VA  then //AVANZO EN EL MINIMO
		leer(vad[minI],v[minI]); //avanza en el archivo y actualiza el array

end;

//Asumo que maestro se asigna en programa principal
//Asumo que vac y ved ya vienen inicializados desde el pp
procedure merge(var ma:maestro; var VAD:vecarchde; var VRD: vecregde);
var nuevo,min:corredor;
begin
	rewrite(ma);
	
	minimo(VAD,VRD,min);
	
	while min.dni<>VA do begin
		nuevo:=min; //copio dni nombre apellido
		nuevo.gano:=0;
		nuevo.kms:=0;
		while min.dni=nuevo.dni do begin
			if min.gano=1 then
				nuevo.gano:=nuevo.gano+min.gano;
			nuevo.kms:=nuevo.kms+min.kms;
			minimo(VAD,VRD,min);
		end;
		write(ma,nuevo);	
	end;
	
	close(ma);
end;

var
	ma:maestro;
	vad:vecarchde;
	vrd:vecregde;
	i:integer;
	pos:string;
begin
	assign(ma,'maestro');
	for i:=1 to dimF do begin
		str(i,pos);
		assign(vad[i],'detalle'+pos);
		reset(vad[i]);
		leer(vad[i],vrd[i]);
	end;
	merge(ma,vad,vrd);
	for i:=1 to dimF do
		close(vad[i]);
end.
