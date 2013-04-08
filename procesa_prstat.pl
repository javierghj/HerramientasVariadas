my $nomFich = $ARGV[0];
my $fichCpuTotal = $nomFich."_cpu_total.csv";
my $fichPsiPss = $nomFich."_psi_pss.csv";
my $fich504 = $nomFich."_504_proc_men.csv";
my $fichProcmen = $nomFich."_psi_procmen.csv";
my $fich503 = $nomFich."_503_ges_config.csv";
my $fichRx = $nomFich."_com_rx.csv";
my $fichTx = $nomFich."_com_tx.csv";

open (TEXTO, $nomFich) || die "No existe fichero de entrada.";
open (CPU_TOTAL, "> $fichCpuTotal") || die "No se pudo crear fichero de salida.".$fichCpuTotal;
open (PSS, "> $fichPsiPss") || die "No se pudo crear fichero de salida.".$fichPsiPss;
open (_504_, "> $fich504") || die "No se pudo crear fichero de salida.".$fich504;
open (MEN, "> $fichProcmen") || die "No se pudo crear fichero de salida.".$fichProcmen;
open (_503_, "> $fich503") || die "No se pudo crear fichero de salida.".$fich503;
open (RX, "> $fichRx") || die "No se pudo crear fichero de salida.".$fichRx;
open (TX, "> $fichTx") || die "No se pudo crear fichero de salida.".$fichTx;

my $final = "";
my $mem_proc = "";
my $cpu_proc = "";
my $nom_proc = "";
my $nom_usr = "";
my $multi = "";
my $cpu_total = "";
my $num_lect_cpu = 1;
my $num_lect_pss = 1;
my $num_lect_504 = 1;
my $num_lect_men = 1;
my $num_lect_503 = 1;
my $num_lect_rx = 1;
my $num_lect_tx = 1;

print CPU_TOTAL "#;Uso de CPU\n";
print PSS "#;Memoria usada;CPU usada\n";
print _504_ "#;Memoria usada;CPU usada\n";
print MEN "#;Memoria usada;CPU usada\n";
print _503_ "#;Memoria usada;CPU usada\n";
print RX "#;Memoria usada;CPU usada\n";
print TX "#;Memoria usada;CPU usada\n";
while (<TEXTO>)
{
  my $linea = $_;
#  Línea del tipo "Info de proceso":
#                      1PID    2USERN  3SZ  4MUL   5RSS      6STATE  7PRI    8NICE   9TIME             10CPU           11NOM_PROC
	if (($linea =~ /\s+(\d+)\s+(\w+)\s+(\d+)(\w)\s+(\d+\w)\s+(\w+)\s+(\d+)\s+(\d+)\s+(\d+\:\d+\:\d+)\s+(\d+\.*\d+)\%\s+(.*)/) or
	    ($linea =~ /\s+(\d+)\s+(\w+)\s+(\d+)(\w)\s+(\d+\w)\s+(\w+)\s+(\d+)\s+(\d+)\s+(\d+\:\d+\.\d+)\s+(\d+\.*\d+)\%\s+(.*)/))
	{
		$mem_proc = $3;
		$multi = $4;
		$nom_proc = $11;
		$cpu_proc = $10;
		$cpu_proc =~ s/\./\,/;
		if (($nom_proc =~ /m_psi_pss_sun/) or ($nom_proc =~ /m_504_proc_men/) or
		    ($nom_proc =~ /m_psi_procmen/) or ($nom_proc =~ /m_com_rx_sun/) or
			($nom_proc =~ /m_com_tx_sun/) or ($nom_proc =~ /m_503_ges_confi/))
		{
			if ($multi =~ /K/)
			{
				$mem_proc = $mem_proc."000";
			}
			elsif ($multi =~ /M/)
			{
				$mem_proc = $mem_proc."000000";
			}
			
			$final = $mem_proc.";".$cpu_proc."\n";
			if ($nom_proc =~ /m_psi_pss_sun/)
			{
				print PSS $num_lect_pss.";".$final;
				$num_lect_pss++;
			}
			elsif ($nom_proc =~ /m_504_proc_men/)
			{
				print _504_ $num_lect_504.";".$final;
				$num_lect_504++;
			}
			elsif ($nom_proc =~ /m_psi_procmen/)
			{
				print MEN $num_lect_men.";".$final;
				$num_lect_men++;
			}
			elsif ($nom_proc =~ /m_com_rx_sun/)
			{
				print RX $num_lect_rx.";".$final;
				$num_lect_rx++;
			}
			elsif ($nom_proc =~ /m_com_tx_sun/)
			{
				print TX $num_lect_tx.";".$final;
				$num_lect_tx++;
			}
			else # elsif ($nom_proc =~ /m_503_ges_confi/)
			{
				print _503_ $num_lect_503.";".$final;
				$num_lect_503++;
			}
			
			$final = "";
			$nom_proc = "";
			$mem_proc = "";
			$cpu_proc = "";
		}
	}
#  Línea del tipo "Info general":
#                         1NPROC  2USER   3SWA 4MULT  5RSS 6MULT  7MEMORY         8TIME             9CPU
	elsif (($linea =~ /\s+(\d+)\s+(\w+)\s+(\d+)(\w)\s+(\d+)(\w)\s+(\d+\.*\d+)\%\s+(\d+\:\d+\:\d+)\s+(\d+\.*\d+)\%(.*)/) or
	       ($linea =~ /\s+(\d+)\s+(\w+)\s+(\d+)(\w)\s+(\d+)(\w)\s+(\d+\.*\d+)\%\s+(\d+\:\d+\.\d+)\s+(\d+\.*\d+)\%(.*)/))
	{
		$nom_usr = $2;
		$cpu_total = $9;
		$cpu_total =~ s/\./\,/;
		if ($nom_usr =~ /root/)
		{
			print CPU_TOTAL $num_lect_cpu.";".$cpu_total."\n";
			$cpu_total = "";
			$nom_usr = "";
			$num_lect_cpu++;
		}
	}
}

close (TEXTO);
close (CPU_TOTAL);
close (PSS);
close (_504_);
close (MEN);
close (_503_);
close (RX);
close (TX);
