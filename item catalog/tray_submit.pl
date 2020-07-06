#!c:/perl/bin/perl.exe
use DBI;
use CGI::Carp qw(fatalsToBrowser);
use CGI;

require("c:/inetpub/cgi-bin/common/stand.pl");
require("c:/inetpub/cgi-bin/common/format.pl");
require("c:/inetpub/cgi-bin/common/misc.pl");
require("c:/inetpub/cgi-bin/common/database.cfg");

$query = new CGI;
#%form = $query->Vars;

$dbh = DBI->connect ($dsn, $duser, $dpass, { RaiseError => 1});
$userID = auth_logged_in();

$dbh->disconnect;

# Objectives:
# 1) detect and run updates to old pallets
# 2) Detect and create new pallets

#loop through the 

sub update_tray()
{
	$sql = "UPDATE trays SET ".
			"pack = ". $query->param('pack_'.$2) .", ".
			"weight = ". $query->param('weight_'.$2) .", ".
			"weightUOM = '".  $query->param('weightUOM_'.$2) ."', ".
			"length = ". $query->param('length_'.$2) .", ".
			"height = ". $query->param('height_'.$2) ." ,".
			"width = ". $query->param('width_'.$2) .", ".
			"changedBy = ". $userID .", ".
			"changedOn = NOW() ".
		   "WHERE trayID = $2";
	print "sql = $sql<br><br>";

}

sub add_tray()
{
	$fullTrayUPC = $query->param('newUPC1') . $query->param('newUPC2') . $query->param('newUPC3') . $query->param('newUPC4');
	$GTIN = "NULL";
	$sql = "INSERT INTO trays (trayUPC, UPC, GTIN, pack, weight, weightUOM, length, height, width, changedBy, changedOn) ".
			"VALUES (".
			$fullTrayUPC .", ".
			$query->param('prodUPC') .", ".
			$GTIN .", ".
			$query->param('pack_'.$2) .", ".
			$query->param('weight_'.$2) .", ".
			$query->param('weightUOM_'.$2) ."', ".
			$query->param('length_'.$2) .", ".
			$query->param('height_'.$2) ." ,".
			$query->param('width_'.$2) .", ".
			$userID .", ".
			"NOW()";
		   
	print "sql = $sql<br><br>";
}

sub check_for_changes()
{
	print "product UPC = ". $query->param('prodUPC'). "<br><br>";
	foreach $name ($query->param) 
	{
		# if $name regex = /pack_\d*/
		if ($name =~ /^(pack_)(\d+)/)
		{
			if (
				($query->param('pack_'.$2)      != $query->param('old_pack_'.$2)     ) or 
				($query->param('weight_'.$2)    != $query->param('old_weight_'.$2)   ) or 
				($query->param('weightUOM_'.$2) ne $query->param('old_weightUOM_'.$2)) or 
				($query->param('length_'.$2)    != $query->param('old_length_'.$2)   ) or 
				($query->param('height_'.$2)    != $query->param('old_height_'.$2)   ) or 
				($query->param('width_'.$2)     != $query->param('old_width_'.$2))   )
			{
				print "<b>changed</b>";
				print "<table>".
				"	<tr><td>new</td><td>old</td></tr>".
				"	<tr><td>". $query->param('pack_'.$2)       ."</td><td>". $query->param('old_pack_'.$2)      ."</td></tr>".
				"	<tr><td>". $query->param('weight_'.$2)     ."</td><td>". $query->param('old_weight_'.$2)    ."</td></tr>".
				"	<tr><td>". $query->param('weightUOM_'.$2)  ."</td><td>". $query->param('old_weightUOM_'.$2) ."</td></tr>".
				"	<tr><td>". $query->param('length_'.$2)     ."</td><td>". $query->param('old_length_'.$2)    ."</td></tr>".
				"	<tr><td>". $query->param('height_'.$2)     ."</td><td>". $query->param('old_height_'.$2)    ."</td></tr>".
				"	<tr><td>". $query->param('width_'.$2)      ."</td><td>". $query->param('old_width_'.$2)    ."</td></tr>".
				"	<tr><td>".
				"</table>";
				update_tray()
			}
			else 
			{
				print "unchanged trayID = $2<br>";
				print "<table>".
				"	<tr><td>new</td><td>old</td></tr>".
				"	<tr><td>". $query->param('pack_'.$2)       ."</td><td>". $query->param('old_pack_'.$2)      ."</td></tr>".
				"	<tr><td>". $query->param('weight_'.$2)     ."</td><td>". $query->param('old_weight_'.$2)    ."</td></tr>".
				"	<tr><td>". $query->param('weightUOM_'.$2)  ."</td><td>". $query->param('old_weightUOM_'.$2) ."</td></tr>".
				"	<tr><td>". $query->param('length_'.$2)     ."</td><td>". $query->param('old_length_'.$2)    ."</td></tr>".
				"	<tr><td>". $query->param('height_'.$2)     ."</td><td>". $query->param('old_height_'.$2)    ."</td></tr>".
				"	<tr><td>". $query->param('width_'.$2)      ."</td><td>". $query->param('old_width_'.$2)    ."</td></tr>".
				"	<tr><td>".
				"</table>";
			}
		}
	}
}

sub check_for_new();
{
	my $fieldcount = 0;
	if 	($query->param('newUPC1') ne "") $fieldcount++;
	if 	($query->param('newUPC2') ne "") $fieldcount++;
	if	($query->param('newUPC3') ne "") $fieldcount++;
	if	($query->param('newUPC4') ne "") $fieldcount++;
	if	($query->param('pack_NewTray') ne "")   $fieldcount++;
	if	($query->param('weight_NewTray') ne "") $fieldcount++;
	if	($query->param('length_NewTray') ne "") $fieldcount++;
	if	($query->param('height_NewTray') ne "") $fieldcount++;
	if	($query->param('width_NewTray') ne "")  $fieldcount++;
	
	if ($fieldcount>0)
	{
		if ($fieldcount==9)
		{	add_tray();	}
		else
		{	
			$message = "";
			if 	($query->param('newUPC1') ne "") $message . "MISSING: New Tray UPC section 1.<br>";
			if 	($query->param('newUPC2') ne "") $message . "MISSING: New Tray UPC section 2.<br>";
			if	($query->param('newUPC3') ne "") $message . "MISSING: New Tray UPC section 3.<br>";
			if	($query->param('newUPC4') ne "") $message . "MISSING: New Tray UPC section 4.<br>";
			if	($query->param('pack_NewTray') ne "")   $message . "MISSING: New Tray pack count.<br>";
			if	($query->param('weight_NewTray') ne "") $message . "MISSING: New Tray weight.<br>";
			if	($query->param('length_NewTray') ne "") $message . "MISSING: New Tray length.<br>";
			if	($query->param('height_NewTray') ne "") $message . "MISSING: New Tray height.<br>";
			if	($query->param('width_NewTray') ne "")  $message . "MISSING: New Tray width.<br>";
			print "$message";
		}
		
	}
	
		
}

#******************** MAIN ********************
print $query->header('text/html');

#check_for_new();
check_for_changes();


