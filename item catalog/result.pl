#!c:/perl/bin/perl.exe
use DBI;
use CGI::Carp qw(fatalsToBrowser);
use CGI;
use Switch;
use CGI::Session;

require("c:/inetpub/cgi-bin/common/stand.pl");
require("c:/inetpub/cgi-bin/common/format.pl");
require("c:/inetpub/cgi-bin/common/misc.pl");
require("c:/inetpub/cgi-bin/common/database.cfg");

$dbh = DBI->connect($dsn, $duser, $dpass, { RaiseError => 1});


$query = new CGI;
%form = $query->Vars;



if($form{showInactiveItems} eq ""){
 	$whereClause = "WHERE itemCatalog.status = 'A'";
}
else{
	$whereClause = "WHERE itemCatalog.status = 'A' AND itemCatalog.status = 'D'";
}
if($form{brand} != 0){$whereClause .= " AND itemCatalog.brand = '$form{brand}'"};
if($form{breadCakeCode} != 0){$whereClause .= " AND itemCatalog.breadCakeCode = $form{breadCakeCode}"};
if($form{privateLabel} != -1){$whereClause .= " AND itemCatalog.privateLabel = '$form{privateLabel}'"};
if($form{ibcItem} != -1){$whereClause .= " AND itemCatalog.ibcItem = $form{ibcItem}"};
if($form{udexCategoryCode} != 0){$whereClause .= " AND udexCategory.udexCategoryCode = '$form{udexCategoryCode}'"};
if($form{UPC} ne ""){$whereClause .= " AND itemCatalog.UPC = '$form{UPC}'"};
if($form{manufacturersCode} ne ""){$whereClause .= " AND itemCatalog.manufacturersCode = '$form{manufacturersCode}'"};
if($form{prodClassCode} ne ""){$whereClause .= " AND itemCatalog.prodClassCode = $form{prodClassCode}"};
if($form{labelWeight} ne ""){$whereClause .= " AND itemCatalog.labelWeight = $form{labelWeight}"};
if($form{compressedUPC} ne ""){$whereClause .= " AND itemCatalog.compressedUPC = '$form{compressedUPC}'"};

$sql1 =  "SELECT itemcatalog.UPC, itemcatalog.brand, itemcatalog.flavor, itemcatalog.itemName, itemcatalog.labelWeight, itemcatalog.pieceCount, itemcatalog.breadCakeCode, itemcatalog.privateLabel, itemcatalog.prodClassCode, itemcatalog.status, productclass.prodClassName ";
$sql1 .= "FROM itemcatalog ";
$sql1 .= "INNER JOIN productClass ";
$sql1 .= "ON itemcatalog.prodClassCode = productclass.prodClassCode ";
$sql1 .= "AND itemcatalog.breadCakeCode = productclass.breadCakeCode ";
$sql1 .= "INNER JOIN udexCategory ";
$sql1 .= "ON productclass.prodClassCode = udexcategory.prodClassCode ";
$sql1 .= "AND productclass.breadCakeCode = udexcategory.breadCakeCode ";
$sql1 .= "$whereClause";

#$session->param('searchSQL', $sql1);
	
$sth1 = $dbh->prepare($sql1);
$sth1->execute();
$recordCount = $sth1-> rows;
$user_id = auth_logged_in();

switch ($recordCount) {
	case 0 {$resultStatement = "No items found"}
	case 1 {$resultStatement = "1 item found"}
	else {$resultStatement = $recordCount . " items found"}
}



print $query->header('text/html');

standard_header("eCommerce Portal");

##content
print "<table cellpadding='0' cellspacing='0' border='0' class='tblInfoTable' style='width:900px'>
	<tr>
		<td class='tblInfoHeadFirst' style='width:100px;'>&nbsp;</td> 
		<td class='tblInfoHeadMiddle'>Item Catalog Search Results<br>$resultStatement</td>
		<td class='tblInfoHeadLast' style='width:100px;'><a href='#' class='lnkButton'>Export To Excel</a></td> 
    </tr>
</table> 
<table cellpadding='0' cellspacing='0' border='0' style='width:900px'>
<tr> 
	<td class='tblInfoColFirst' style='text-align:center;width:10px;border-right:0px;'>&nbsp;</td> 
	<td class='tblInfoCol' style='text-align:center;width:10px;border-right:0px;'>&nbsp;</td> 
	<td class='tblInfoCol' style='text-align:center;width:100px;'>UPC</td> 
	<td class='tblInfoCol' style='text-align:center;'>Brand</td>
	<td class='tblInfoCol' style='text-align:center;'>Flavor</td>
	<td class='tblInfoCol' style='text-align:center;'>Item<br>Name</td>
	<td class='tblInfoCol' style='text-align:center;'>Label<br>Weight</td>
	<td class='tblInfoCol' style='text-align:center;'>Piece<br>Count</td>
	<td class='tblInfoCol' style='text-align:center;'>Bread<br>Cake</td>
	<td class='tblInfoCol' style='text-align:center;'>Private<br>Label</td>
	<td class='tblInfoCol' style='text-align:center;'>Prod Class<br>Code</td>
	<td class='tblInfoCol' style='text-align:center;'>Prod Class Description</td>
	<td class='tblInfoCol' style='text-align:center;'>Status</td>
</tr>";

while ($hashref = $sth1->fetchrow_hashref){
print "
<tr class='tblInfoDataRowLight' onmouseover='className=\"tblInfoDataRowHiLight\"' onmouseout='className=\"tblInfoDataRowLight\"'>
	<td class='tblInfoDataFirst' colspan='3' style='text-align:left;'><a href='addEditItem.pl?act=edit&upc=$hashref->{UPC}' style='text-decoration:none;'>$hashref->{UPC}</a></td>
	<td class='tblInfoData' style='text-align:left;'>$hashref->{brand}</td>
	<td class='tblInfoData' style='text-align:left;'>$hashref->{flavor}</td>
	<td class='tblInfoData' style='text-align:left;'>$hashref->{itemName}</td>
	<td class='tblInfoData' style='text-align:left;'>$hashref->{labelWeight}</td>
	<td class='tblInfoData' style='text-align:left;'>$hashref->{pieceCount}</td>
	<td class='tblInfoData' style='text-align:left;'>$hashref->{breadCakeCode}</td>
	<td class='tblInfoData' style='text-align:left;'>$hashref->{privateLabel}</td>
	<td class='tblInfoData' style='text-align:left;'>$hashref->{prodClassCode}</td>
	<td class='tblInfoData' style='text-align:left;'>$hashref->{prodClassName}</td>
	<td class='tblInfoData' style='text-align:left;'>$hashref->{status}</td>
</tr>"
}

print "</table>";
#end content
print "<br>$sql1";

standard_footer();
$dbh->disconnect;
exit;