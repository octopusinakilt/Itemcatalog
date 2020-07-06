#!c:/perl/bin/perl.exe
use DBI;
use CGI::Carp qw(fatalsToBrowser);
use CGI;


sub table_header {
  print "      <table cellpadding='0' cellspacing='0' border='0' class='tblInfoTable' style='width:900px'>
        <tr> \n";
  print "<td class='tblInfoHeadFirst' style='width:200px;'>&nbsp;</td>\n";
  print "<td class='tblInfoHeadMiddle'>Display Product Categories</td> \n";
  print "<td class='tblInfoHeadLast' style='width:200px;'>
          <a href='/cgi-bin/itemcat/addeditcat.pl?act=ADD' class='lnkButton'>Add New Category</a>
        </td>\n";
  print "      </tr>
      </table> \n";
}

sub col_header {
  print "      <table cellpadding='0' cellspacing='0' border='0' style='width:900px'>
        <tr> \n";
  print "<td class='tblInfoColFirst' style='width:100px;'>From Class</td>
         <td class='tblInfoCol' style='width:100px;'>To Class</td>
         <td class='tblInfoCol' style='width:100px;'>Bread/Cake</td>
         <td class='tblInfoCol' style='width:450px;'>Name</td>
         <td class='tblInfoCol' style='width:150px;'>Last Update</td>
       </tr> \n"

}

sub display_row {
	if ($cnt % 2 == 0) {
		$class = "tblInfoDataRowLight";
	} else {
		$class = "tblInfoDataRowDark";
	}
	
  $stamp = substr($pCatRecord->{changedOn},0,10) . ' @ ' . substr($pCatRecord->{changedOn},11,8);
  if ($pCatRecord->{breadCakeCode} == 1) {
  	$bc = 'Bread';
  } else {
  	$bc = 'Cake';
  }

 	print "<tr class='$class' onmouseover='className=\"tblInfoDataRowHiLight\"' onmouseout='className=\"$class\"'> \n";
  print "<td class='tblInfoDataFirst'>$pCatRecord->{fromClassCode}</td>\n";
  print "<td class='tblInfoData' >$pCatRecord->{toClassCode}</td>\n";
  print "<td class='tblInfoData' >$bc</td>\n";
  print "<td class='tblInfoData' ><a href='/cgi-bin/itemcat/addeditcat.pl?act=EDT&catID=$pCatRecord->{prodCategoryID}'>$pCatRecord->{prodCategoryName}</a></td>\n";
  print "<td class='tblInfoData' >$stamp</td>\n";
  print "</tr> \n";
}

sub select_data {

	$sql = "select * from productCategory ";
	$sql .= "order by breadCakeCode, fromClassCode ";
	
  $sth = $dbh->prepare($sql);
  $sth->execute() or die "Could not execute statement: " . $sth->errstr;
  
  $cnt = 0;
  
  $save_tp = '';
  
  while ($pCatRecord = $sth->fetchrow_hashref()) {
  	$cnt++;
  	display_row();
  }
  
  $sth->{finish};
}

#############################################################################
#                 Script Main                                               #
#############################################################################

require("c:/inetpub/cgi-bin/common/stand.pl");
require("c:/inetpub/cgi-bin/common/format.pl");
require("c:/inetpub/cgi-bin/common/database.cfg");

require("c:/inetpub/cgi-bin/itemcat/itemcat.cfg");

$dbh = DBI->connect ($dsn, $duser, $dpass, { RaiseError => 1});

$user_id = auth_logged_in();

$query = new CGI;

print $query->header('text/html');

standard_header("eCommerce Portal");

table_header;
col_header;
select_data;

print "</table>";

standard_footer();

$dbh->disconnect;

exit;
