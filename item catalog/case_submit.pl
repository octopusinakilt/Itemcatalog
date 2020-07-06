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
$dbh->disconnect;

print $query->header('text/html');

print "<table border=1> \n";

foreach $name ($query->param) {
	print "<tr><td>$name</td>\n";
	foreach $value ($query->param($name)){
		print "  <td>$value</td>\n";
	}
	print "</tr>";
}

print "</table>";

# Objectives:
# 1) detect and run updates to old pallets
# 2) Detect and create new pallets

#loop through the 
