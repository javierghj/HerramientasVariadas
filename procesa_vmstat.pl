my $nomFich = $ARGV[0];
my $nuevoFich = $nomFich.".csv";

open (TEXTO, $nomFich) || die "No existe fichero de entrada.";
open (TEXTO2, "> $nuevoFich") || die "No se pudo crear fichero de salida.";

my $final = "";
my $hora = "";
my $swap = "";
my $mem = "";

print TEXTO2 "Hora;Swap;Memoria\n";

while (<TEXTO>)
{
  my $linea = $_;
	if (($linea !~ /^(\s+)(kthr)(.*)$/)	 and ($linea !~ /^(\s+)r b w(.*)$/))
	{
		if ($linea =~ /^(\w{3})\s+(\w{3})\s+(\d{2})\s+(\d{2}:\d{2}:\d{2})(.*)$/)
		{
			$hora = $4;
		}
		elsif ($linea =~ /^\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)(.*)$/)
		{
			$swap = $4;
			$mem = $5;
		}		
	}
	
	if (($hora ne "") and ($swap ne "") and ($mem ne ""))
	{
		print TEXTO2 $hora.";".$swap.";".$mem."\n";
		$hora = "";
		$swap = "";
		$mem = "";
	}
}

close (TEXTO);
close (TEXTO2);
