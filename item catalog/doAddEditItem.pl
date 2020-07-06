#!c:/perl/bin/perl.exe
use DBI;
use CGI::Carp qw(fatalsToBrowser);
use CGI;
use Switch;
use CGI::Session;
use Date::Manip;


require("c:/inetpub/cgi-bin/common/database.cfg");
require("c:/inetpub/cgi-bin/common/stand.pl");

$dbh = DBI->connect ($dsn, $duser, $dpass, { RaiseError => 1});
$query = new CGI;
%form = $query->Vars;
#$user_id = auth_logged_in();
$session = new CGI::Session();
$wholeUPC = $form{upc1} . $form{upc2} . $form{upc3} . $form{upc4};
$wholeCompressedUPC = $form{compressedUPC1} . $form{compressedUPC2} . $form{compressedUPC3};
&Date_Init("TZ=-0000");	
$iuserid = get_cookie('userid');
$now = UnixDate("today","%Y%m%d%H%M%S");
print $query->header('text/html');

sub cleanForm{
my $retErr = 0;
	
  if ($wholeUPC eq '') {
  	$retErr = 1;
  }
  if (!$form{flavor}) {
  	$retErr = 1;
  }
  if (!$form{description}) {
  	$retErr = 1;
  }
   if (!$form{publishedDescription}) {
  	$retErr = 1;
  }
   if (!$form{labelWeight}) {
  	$retErr = 1;
  }
   if (!$form{pieceCount}) {
  	$retErr = 1;
  }
   if ($wholeCompressedUPC eq '') {
  	$retErr = 1;
  }
   if (!$form{productClass}) {
  	$retErr = 1;
  }
  if (!$form{length}) {
  	$retErr = 1;
  }
  if (!$form{width}) {
  	$retErr = 1;
  }
  if (!$form{height}) {
  	$retErr = 1;
  }
  if ($retErr != 0) {
  	print $query->redirect("addEditCat.pl?error=1");
  }
}

#possible errors:
# 1 = missing field
# 2 = UPC exist
# 3 = no error

switch ($act){
	case "new" {
	#cleanForm();
	$sql1 = "SELECT upc, brand, flavor, description FROM itemCatalog WHERE UPC = '$wholeUPC'";
	$sth1 = $dbh->prepare($sql1);
	$sth1->execute();
	$recordCount = $sth1-> rows;
		if ($recordCount > 0){
			while ($hashref = $sth1->fetchrow_hashref){
				$session->param('sessionMessage', 'UPC $hashref->{upc} - $hashref->{brand} $hashref->{flavor} $hashref->{description} already exist.');
			}
			print $query->redirect("addEditCat.pl?error=2");
		}
		else{
			$sql2 = "Insert INTO itemCatalog(UPC, description, GTIN, manufacturersCode, brand, flavor, itemName, publishedDescription, pieceCount, labelWeight, privateLabel, compressedUPC, ibcItem, length, width, height, prodClassCode, breadCakeCode, status, comStatus, extractTimestamp, changedBy, changedOn) VALUES ('$wholeUPC', '$form{description}', '$form{GTIN}', '$form{manufacturersCode}', '$form{brand}', '$form{flavor}', '$form{itemName}', '$form{publishedDescription}', '$form{pieceCount}', '$form{labelWeight}', '$form{privateLabel}', '$form{compressedUPC}', '$form{ibcItem}', '$form{length}', '$form{width}', '$form{height}', '$form{prodClassCode}', '$form{breadCakeCode}', 'A','', '', '$iuserid', now())";
			
			$sql3 = "Insert INTO itemCatalogHistory(UPC, description, GTIN, manufacturersCode, brand, flavor, itemName, publishedDescription, pieceCount, labelWeight, privateLabel, compressedUPC, ibcItem, length, width, height, prodClassCode, breadCakeCode, status, comStatus, extractTimestamp, changedBy, changedOn, action) VALUES ('$wholeUPC', '$form{description}', '$form{GTIN}', '$form{manufacturersCode}', '$form{brand}', '$form{flavor}', '$form{itemName}', '$form{publishedDescription}', '$form{pieceCount}', '$form{labelWeight}', '$form{privateLabel}', '$form{compressedUPC}', '$form{ibcItem}', '$form{length}', '$form{width}', '$form{height}', '$form{prodClassCode}', '$form{breadCakeCode}', 'A', '', '', '$iuserid', now(), 'A')";
			$sth2 = $dbh->prepare($sql2);
			$sth2->execute();
			
			$sth3 = $dbh->prepare($sql3);
			$sth3->execute();
			
			$session->param('sessionMessage', 'UPC $wholeUPC - $form{brand} $form{flavor} $form{description} was successfully added.');
			print $query->redirect("addEditItem.pl?error=3");
		}		
	}
	
	case "edit" {
		cleanForm();
		$sql4 = "UPDATE itemCatalog SET ";
		$sql4 .= "UPC = '$wholeUPC', ";
		$sql4 .= "description = '$form{description}', ";
		$sql4 .= "GTIN = '$form{GTIN}', ";
		$sql4 .= "manufacturersCode = '$form{manufacturersCode}', ";
		$sql4 .= "brand = '$form{brand}', ";
		$sql4 .= "flavor = '$form{flavor}', ";
		$sql4 .= "itemName = '$form{itemName}', ";
		$sql4 .= "publishedDescription = '$form{publishedDescription}', ";
		$sql4 .= "pieceCount = '$form{pieceCount}', ";
		$sql4 .= "labelWeight = '$form{labelWeight}', ";
		$sql4 .= "privateLabel = '$form{privateLabel}', ";
		$sql4 .= "compressedUPC = '$form{compressedUPC}', ";
		$sql4 .= "ibcItem = '$form{ibcItem}', ";
		$sql4 .= "length = '$form{length}', ";
		$sql4 .= "width = '$form{width}', ";
		$sql4 .= "height = '$form{height}', ";
		$sql4 .= "prodClassCode = '$form{prodClassCode}', ";
		$sql4 .= "breadCakeCode = '$form{breadCakeCode}', ";
		$sql4 .= "comStatus = 'A', ";
		$sql4 .= "extractTimestamp = '', ";
		$sql4 .= "changedBy = '$iuserid', ";
		$sql4 .= "changedOn = now() ";
		$sql4 .= "WHERE UPC = '$wholeUPC' ";
	
		$sql5 = "Insert INTO itemCatalogHistory(UPC, description, GTIN, manufacturersCode, brand, flavor, itemName, publishedDescription, pieceCount, labelWeight, privateLabel, compressedUPC, ibcItem, length, width, height, prodClassCode, breadCakeCode, status, comStatus, extractTimestamp, changedBy, changedOn, action) VALUES ('$wholeUPC', '$form{description}', '$form{GTIN}', '$form{manufacturersCode}', '$form{brand}', '$form{flavor}', '$form{itemName}', '$form{publishedDescription}', '$form{pieceCount}', '$form{labelWeight}', '$form{privateLabel}', '$form{compressedUPC}', '$form{ibcItem}', '$form{length}', '$form{width}', '$form{height}', '$form{prodClassCode}', '$form{breadCakeCode}', 'A', '', '', '$iuserid', now(), 'C')";
	
		$sth4 = $dbh->prepare($sql4);
		$sth4->execute();
			
		$sth5 = $dbh->prepare($sql5);
		$sth5->execute();
	
		$session->param('sessionMessage', 'UPC $wholeUPC - $form{brand} $form{flavor} $form{description} was successfully modified.');
		print $query->redirect("addEditItem.pl?error=3&act=edit");	
	}
	
	case "delete" {
		$sql6 = "DELETE FROM itemCatalog WHERE UPC = '$wholeUPC'";
	
		$sql7 = "Insert INTO itemCatalog(UPC, description, GTIN, manufacturersCode, brand, flavor, itemName, publishedDescription, pieceCount, labelWeight, privateLabel, compressedUPC, ibcItem, length, width, height, prodClassCode, breadCakeCode, status, comStatus, extractTimestamp, changedBy, changedOn, action) VALUES ('$wholeUPC', $form{description}, $form{GTIN}, $form{manufacturersCode}, $form{brand}, $form{flavor}, $form{itemName}, $form{publishedDescription}, $form{pieceCount}, $form{labelWeight}, $form{privateLabel}, $form{compressedUPC}, $form{ibcItem}, $form{length}, $form{width}, $form{height}, $form{prodClassCode}, $form{breadCakeCode}, 'D', '', $iuserid, $now, 'D')";
	
		$sth6 = $dbh->prepare($sql6);
		$sth6->execute();
	
		$sth7 = $dbh->prepare($sql7);
		$sth7->execute();
	
	$session->param('sessionMessage', 'UPC $wholeUPC - $form{brand} $form{flavor} $form{description} was successfully modified.');
	
	}
}
exit;


