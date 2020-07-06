#!c:/perl/bin/perl.exe
use DBI;
use CGI::Carp qw(fatalsToBrowser);
use CGI;

require("c:/inetpub/cgi-bin/common/stand.pl");
require("c:/inetpub/cgi-bin/common/format.pl");
require("c:/inetpub/cgi-bin/common/misc.pl");
require("c:/inetpub/cgi-bin/common/database.cfg");

$countx = 0;

sub display_pallet() {
print"

<table class='formTable' style='width:900'>
      <tr>
        <td class='formHeader' style='text-align:Left'> Tray, Case & Pallet Attributes</td>
        <td class='tblInfoHeadLast' style='width=300'>
		  <a href='trays.pl?upc=$form{upc}' class='lnkButton'>Maintain Trays</a>
          <a href='pallet.pl?upc=$form{upc}' class='lnkButton'>Maintain Pallets</a>
        </td>
      </tr>
</table>	
<table cellpadding='0' cellspacing='0' border='0' style='width:900px'>
  <tr> 
    <td class='tblInfoColFirst' style='text-align:center;width:150px;border-right: 0px;'>&nbsp;</td> 
    <td class='tblInfoCol' style='text-align:center;width:100px;border-right: 0px;'>UPC</td>
    <td class='tblInfoCol' style='text-align:center;width:100px;'>&nbsp;</td>
    <td class='tblInfoCol' style='text-align:center;width:250px;'>GTIN</td>
    <td class='tblInfoCol' style='text-align:center;width:50px;'>Pack</td>
    <td class='tblInfoCol' style='text-align:center;width:100px;'>Weight</td>
    <td class='tblInfoCol' style='text-align:center;width:50px;'>Length</td>
    <td class='tblInfoCol' style='text-align:center;width:50px;'>Height</td>
    <td class='tblInfoCol' style='text-align:center;width:50px;'>Width</td>
    <td class='tblInfoCol' style='text-align:center;width:50px;'>Volume</td>
  </tr> 
";
display_pallets_with_trays();
display_pallets_without_trays();

print "

 <tr>
   	<td class='formFooter' style='text-align:center;height:25px; border-right: 1px solid #000000;border-bottom: 1px solid #000000;border-left: 1px solid #000000;' colspan='10'>
			<input type='submit' value='Add/Update Trays' name='submit' class='formButton'>
		</td>
  </tr>
";
print "</table></form>";
}


sub display_pallets_with_trays () {
	while ($tray = $sth1->fetchrow_hashref)
	{
	print "                                                                                                                               
		<tr class='tblInfoDataRowLight' onmouseover='className=\"tblInfoDataRowHiLight\"' onmouseout='className=\"tblInfoDataRowLight\"'> 
			<td class='tblInfoDataFirst' style='border-bottom: 0px;border-right: 0px;' colspan='3'><b>Tray:</b> $tray->{trayUPC}</td>        
			<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>$tray->{GTIN}</td>                    
			<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>$tray->{pack}</td>                    
			<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>$tray->{weight} $tray->{weightUOM}</td>      
			<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>$tray->{length}</td>                    
			<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>$tray->{height}</td>                    
			<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>$tray->{width}</td>                    
			<td class='tblInfoData' style='text-align:center;border-bottom: 0px;'>$tray->{volume}</td>                                      
		</tr>\n";                                                                                                                         		

#		print "case_count = $case_count<br>";
		foreach $caseID (keys (%{$case_hash}))
		{
#			print "CASE: $tray->{trayID} == $case_hash->{$i}->{trayID}, i=$i<br>";
			if ($tray->{trayID} == $case_hash->{$caseID}->{trayID})
			{
			print "
				<tr class='tblInfoDataRowLight' onmouseover='className=\"tblInfoDataRowHiLight\"' onmouseout='className=\"tblInfoDataRowLight\"'> 
					<td class='tblInfoDataFirst' style='width: 100px;border-bottom: 0px;border-right: 0px;'>&nbsp;</td>
					<td class='tblInfoData' colspan='2' style='width: 250px;border-bottom: 0px;border-right: 0px;'><b>Case:</b> $case_hash->{$caseID}->{caseUPC}</td>
					<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>$case_hash->{$caseID}->{GTIN}</td>
					<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>".
						"<input name='pack_$case_hash->{$caseID}->{caseID}' type='text' style='width:45px' value='$case_hash->{$caseID}->{pack}'>
						<input name='old_pack_$case_hash->{$caseID}->{caseID}' type='hidden' value='$case_hash->{$caseID}->{pack}'>
						<input name='old_weight_$case_hash->{$caseID}->{caseID}' type='hidden' value='$case_hash->{$caseID}->{weight}'>
						</td>
					<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>
						<input name='weight_$case_hash->{$caseID}->{caseID}' type='text' style='width:40px' value='$case_hash->{$caseID}->{weight}'>".
						"<select name='weightUOM_$case_hash->{$caseID}->{caseID}' style='width:45px'>";
					if ($case_hash->{$caseID}->{weightUOM} eq 'oz'){
						print "<option value=1 selected>oz</option>
					   	<option value=2>lbs</option>";
					}
					else{
						
						print "<option value=1>oz</option>
					   	<option value=2 selected>lbs</option>";
					}
			print "</select></td>
				<input name='old_weightUOM_$case_hash->{$caseID}->{caseID}' type='hidden' value='$case_hash->{$caseID}->{weightUOM}'>
				<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>".
					"<input name='length_$case_hash->{$caseID}->{caseID}' type='text' style='width:45px' value='$case_hash->{$caseID}->{length}'>
					<input name='old_length_$case_hash->{$caseID}->{caseID}' type='hidden' value='$case_hash->{$caseID}->{length}'>
					</td>
				<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>
					<input name='height_$case_hash->{$caseID}->{caseID}' type='text' style='width:45px' value='$case_hash->{$caseID}->{height}'>
					<input name='old_height_$case_hash->{$caseID}->{caseID}' type='hidden' value='$case_hash->{$caseID}->{height}'>
					</td>
				<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>".
					"<input name='width_$case_hash->{$caseID}->{caseID}' type='text' style='width:45px' value='$case_hash->{$caseID}->{width}'>
					<input name='old_width_$case_hash->{$caseID}->{caseID}' type='hidden' value='$case_hash->{$caseID}->{width}'>
					</td>
				<td class='tblInfoData' style='text-align:center;border-bottom: 0px;'>$case_hash->{$caseID}->{volume}</td>
				</tr> 
				";

				foreach $palletID (keys (%{$pallet_hash}))
				{
#					print "$pallet_count=pallet_count<br>";
#					print "<b>PALLET: $case_hash->{$caseID}->{caseID} == $pallet_hash->{$palletID}->{caseID}, caseID=$caseID, palletID=$palletID</b><br>";
#					print "<i>&nbsp;&nbsp;&nbsp;&nbsp;PALLET: $pallet_hash->{$palletID}->{caseID} , ".
#							"$pallet_hash->{$palletID}->{casesPerLayer} , ".
#							"$pallet_hash->{$palletID}->{layersPerPallet} , ".
#							"$pallet_hash->{$palletID}->{GTIN} , ".
#							"</i><br>";
					if ($case_hash->{$caseID}->{caseID} == $pallet_hash->{$palletID}->{caseID})
					{
						print "
						<tr class='tblInfoDataRowHiLight' style='height:30px;'>
							<td class='tblInfoDataFirst' colspan='2' style='width: 250px;border-bottom: 0px;border-right: 0px;'>&nbsp;</td>
							<td class='tblInfoData' style='width: 100px;text-align:right;border-bottom: 0px;border-right: 0px;'><b>Pallet:</b></td>
							<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>$pallet_hash->{$palletID}->{GTIN}</td>
							<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;' colspan=2>".
								"$pallet_hash->{$palletID}->{casesPerLayer} Casses/Layer</td>
							<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>&nbsp;</td>
							<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;' colspan=2>".
								"$pallet_hash->{$palletID}->{layersPerPallet} Layers/Pallet</td>
							<td class='tblInfoData' style='text-align:center;border-bottom: 0px;'>&nbsp;</td>
						</tr>";
					}
				}
			print "
				<tr class='tblInfoDataRowHiLight' style='height:30px;'>
					<td class='tblInfoDataFirst' style='border-bottom: 0px;border-right: 0px;' colspan='3'>
					   <b>New Case:</b>
						<input name='newUPC1_$tray->{trayID}' type='text' style='width:25px' value=''>
			 	    	<input name='newUPC2_$tray->{trayID}' type='text' style='width:50px' value=''>
			 	     	<input name='newUPC3_$tray->{trayID}' type='text' style='width:50px' value=''>
			 	     	<input name='newUPC4_$tray->{trayID}' type='text' style='width:25px' value=''>
					</td>
					<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>&nbsp;</td>
					<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>
						<input name='newPack_$tray->{trayID}' type='text' id='invID' style='width:45px' value=''>
					</td>
					<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>
						<input name='newWeight_$tray->{trayID}' type='text' id='invID' style='width:40px' value=''>
						<select name='newWeightUOM_$tray->{trayID}' id='dunsID' style='width:45px'>
			   				<option value=1>oz
			   				<option value=2>lbs
						</select>
					</td>
					<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>
						<input name='newLength_$tray->{trayID}' type='text' id='invID' style='width:45px' value=''>
					</td>
					<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>
						<input name='newHeight_$tray->{trayID}' type='text' id='invID' style='width:45px' value=''>
					</td>
					<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>
						<input name='newWidth_$tray->{trayID}' type='text' id='invID' style='width:45px' value=''>
					</td>
					<td class='tblInfoData' style='text-align:center;border-bottom: 0px;'>&nbsp;</td>
				</tr>";
			}
		}
	print "
	<tr class='tblInfoDataRowLight' style='height:3px;'>
		  <td colspan='10' style='font-size: 2px; height: 3px; border: 1px solid black; border-top: 0px;'>&nbsp;</td> 
	</tr>
	";
	}
}

sub display_pallets_without_trays() {
	#a good bit of unnessisary duplication exists in this code.  clean up as time permits - AJM
	foreach $caseID (keys (%{$case_hash}))
	{
		if ($case_hash->{$caseID}->{trayID} eq '')
		{
			print "
				<tr class='tblInfoDataRowLight' onmouseover='className=\"tblInfoDataRowHiLight\"' onmouseout='className=\"tblInfoDataRowLight\"'> 
					<td class='tblInfoDataFirst' style='width: 100px;border-bottom: 0px;border-right: 0px;'>&nbsp;</td>
					<td class='tblInfoData' colspan='2' style='width: 250px;border-bottom: 0px;border-right: 0px;'><b>Case:</b> $case_hash->{$caseID}->{caseUPC}</td>
					<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>$case_hash->{$caseID}->{GTIN}</td>
					<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>".
						"<input name='pack_$case_hash->{$caseID}->{caseID}' type='text' style='width:45px' value='$case_hash->{$caseID}->{pack}'>
						<input name='old_pack_$case_hash->{$caseID}->{caseID}' type='hidden' value='$case_hash->{$caseID}->{pack}'>
						</td>
					<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>".
						"<input name='weight_$case_hash->{$caseID}->{caseID}' type='text' style='width:40px' value='$case_hash->{$caseID}->{weight}'> 
						<input name='old_weight_$case_hash->{$caseID}->{caseID}' type='hidden' value='$case_hash->{$caseID}->{weight}'> 
						".
						"<select name='weightUOM_$case_hash->{$caseID}->{caseID}' style='width:45px'>";
					if ($case_hash->{$caseID}->{weightUOM} eq 'oz'){
						print "<option value=1 selected>oz</option>
					   	<option value=2>lbs</option>";
					}
					else{
						
						print "<option value=1>oz</option>
					   	<option value=2 selected>lbs</option>";
					}
			print "
		      </select>
		      	<input name='old_weightUOM_$case_hash->{$caseID}->{caseID}' value='$case_hash->{$caseID}->{weightUOM}'> 
				</td>
				<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>".
					"<input name='length_$case_hash->{$caseID}->{caseID}' type='text' style='width:45px' value='$case_hash->{$caseID}->{length}'>
					<input name='old_length_$case_hash->{$caseID}->{caseID}' type='hidden' value='$case_hash->{$caseID}->{length}'>
					
					</td>
				<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>".
					"<input name='height_$case_hash->{$caseID}->{caseID}' type='text' style='width:45px' value='$case_hash->{$caseID}->{height}'>
					<input name='old_height_$case_hash->{$caseID}->{caseID}' type='hidden' value='$case_hash->{$caseID}->{height}'>
					
					</td>
				<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>".
					"<input name='width_$case_hash->{$caseID}->{caseID}' type='text' style='width:45px' value='$case_hash->{$caseID}->{width}'>
					<input name='old_width_$case_hash->{$caseID}->{caseID}' type='hidden' value='$case_hash->{$caseID}->{width}'>
					
					</td>
				<td class='tblInfoData' style='text-align:center;border-bottom: 0px;'>$case_hash->{$caseID}->{volume}</td>
				</tr> 
				";

				foreach $palletID (keys (%{$pallet_hash}))
				{
					if ($case_hash->{$caseID}->{caseID} == $pallet_hash->{$palletID}->{caseID})
					{
						print "
						<tr class='tblInfoDataRowHiLight' style='height:30px;'>
							<td class='tblInfoDataFirst' colspan='2' style='width: 250px;border-bottom: 0px;border-right: 0px;'>&nbsp;</td>
							<td class='tblInfoData' style='width: 100px;text-align:right;border-bottom: 0px;border-right: 0px;'><b>Pallet:</b></td>
							<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>$pallet_hash->{$palletID}->{GTIN}</td>
							<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;' colspan=2>".
								"$pallet_hash->{$palletID}->{casesPerLayer} Casses/Layer</td>
							<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>&nbsp;</td>
							<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;' colspan=2>".
								"$pallet_hash->{$palletID}->{layersPerPallet} Layers/Pallet</td>
							<td class='tblInfoData' style='text-align:center;border-bottom: 0px;'>&nbsp;</td>
						</tr>";
					}
				}
			print "
				<tr class='tblInfoDataRowLight' style='height:3px;'>
		  			<td colspan='10' style='font-size: 2px; height: 3px; border: 1px solid black; border-top: 0px;'>&nbsp;</td> 
				</tr>
	"
			
			}
			
	}
	
	print "
		<tr class='tblInfoDataRowHiLight' style='height:30px;'> 
		<td class='tblInfoDataFirst' style='border-bottom: 0px;border-right: 0px;' colspan='3'>
			<b>New Independant Case:</b>
			<input name='newUPC1' type='text' style='width:25px' value=''>
			<input name='newUPC2' type='text' style='width:50px' value=''>
			<input name='newUPC3' type='text' style='width:50px' value=''>
			<input name='newUPC4' type='text' style='width:25px' value=''>
		</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>&nbsp;</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>
			<input name='newPack' type='text' id='invID' style='width:45px' value=''>
		</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>
			<input name='newWeight' type='text' id='invID' style='width:40px' value=''>
			<select name='newWeightUOM' id='dunsID' style='width:45px'>
			<option value=1>oz
			<option value=2>lbs
			</select>
		</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>
			<input name='newLength' type='text' id='invID' style='width:45px' value=''>
		</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>
			<input name='newHeight' type='text' id='invID' style='width:45px' value=''>
		</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>
			<input name='newWidth' type='text' id='invID' style='width:45px' value=''>
		</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;'>&nbsp;</td>
		</tr>";
}

#  "Main"
$dbh = DBI->connect ($dsn, $duser, $dpass, { RaiseError => 1});
$dbh->disconnect;

$user_id = auth_logged_in();

$query = new CGI;
%form = $query->Vars;

$sql0 =  "SELECT CONCAT(SUBSTRING(UPC, 1, 1), '-', SUBSTRING(UPC, 2, 5), '-', SUBSTRING(UPC, 7, 5), '-', SUBSTRING(UPC, 12, 1)) AS UPC, CONCAT(SUBSTRING(GTIN, 1, 2), '-', SUBSTRING(GTIN, 3, 1), '-', SUBSTRING(GTIN, 4, 6), '-', SUBSTRING(GTIN, 10, 5), '-', SUBSTRING(GTIN, 15, 1)) AS GTIN, itemcatalog.brand, itemcatalog.flavor, itemcatalog.itemName, itemcatalog.labelWeight, itemcatalog.pieceCount, itemcatalog.breadCakeCode, itemcatalog.privateLabel, itemcatalog.prodClassCode, productclass.prodClassName, udexcategory.udexCategoryName, itemcatalog.ibcItem, itemcatalog.changedOn, users.firstName, users.lastName, itemcatalog.description, itemcatalog.publishedDescription, itemcatalog.extractTimestamp, itemcatalog.compressedUPC, itemcatalog.length, itemcatalog.width, itemcatalog.height, itemcatalog.length * itemcatalog.width * itemcatalog.height AS volume, productcategory.prodCategoryName,  itemcatalog.comStatus ";
$sql0 .= "FROM itemcatalog ";
$sql0 .= "INNER JOIN productclass "; 
$sql0 .= "ON itemcatalog.prodClassCode = productclass.prodClassCode ";
$sql0 .= "AND itemcatalog.breadCakeCode = productclass.breadCakeCode ";
$sql0 .= "INNER JOIN udexcategory ";
$sql0 .= "ON productclass.prodClassCode = udexcategory.prodClassCode ";
$sql0 .= "AND productclass.breadCakeCode = udexcategory.breadCakeCode ";
$sql0 .= "INNER JOIN users ";
$sql0 .= "ON itemcatalog.changedBy = users.userID ";
$sql0 .= "INNER JOIN productcategory ";
$sql0 .= "ON productclass.breadCakeCode = productcategory.breadCakeCode ";
$sql0 .= "AND productclass.prodClassCode >= productcategory.fromClassCode ";
$sql0 .= "AND productclass.prodClassCode <= productcategory.toClassCode ";
$sql0 .= "WHERE     (upc = '$form{upc}') ";
$sql0 .= "ORDER BY itemcatalog.changedOn";


$sth0 = $dbh->prepare($sql0);
$sth0->execute();

$sql1 = "SELECT trayUPC, trayID, GTIN, pack, weight, weightUOM, length, height, width, length * width * height AS volume, trayID FROM trays ".
		"WHERE (UPC = '$form{upc}')";
#				0		1		2		 3	  4		5	  6		  7		  8		 9			10                                 11
$sql2 = "SELECT caseID, trayID, caseUPC, UPC, GTIN, pack, weight, length, width, weightUOM, height, length * width * height AS volume ".
		"FROM cases WHERE (UPC = '$form{upc}')";

$sql3 = "SELECT cases.caseID, pallets.casesPerLayer, pallets.layersPerPallet, pallets.GTIN, pallets.palletID ".
		"FROM pallets INNER JOIN cases ON pallets.caseID = cases.caseID WHERE (cases.UPC = '$form{upc}')";


$sth1 = $dbh->prepare($sql1);
$sth1->execute();

$sth2 = $dbh->prepare($sql2);
$sth2->execute();
$case_hash = $sth2->fetchall_hashref("caseID");
$case_count = $sth2->rows;

$sth3 = $dbh->prepare($sql3);
$sth3->execute();
$pallet_hash = $sth3->fetchall_hashref("palletID");
$pallet_count = $sth3->rows;


sub bitToString {
	($theBit, $breadCakeCode) = @_;
	if ($breadCakeCode){
		if ($theBit == 1){$returnValue = "Bread"}
		else {$returnValue = "Cake"}
	}
	else{
		if ($theBit == 1){$returnValue = "Yes"}
		else {$returnValue = "No"}
	}
	return ($returnValue)
}


print $query->header('text/html');
standard_header("eCommerce Portal");

##content

while ($hashref = $sth0->fetchrow_hashref){

$ibcItem = bitToString($hashref->{ibcItem}, 0);
$privateLabel = bitToString($hashref->{privateLabel}, 0);
$breadCakeCode = bitToString($hashref->{breadCakeCode}, 1);

print " 
  <div id='content'> <form name='Pallet_Data' action='/cgi-bin/itemcat/case_submit.pl' method='post'>
  <table class='formTable' style='width:900'>
      <tr>
        <td class='formHeader' style='text-align:Left' colspan='3'>Item History for UPC $hashref->{UPC} GTIN $hashref->{GTIN}</td>
        <td class='formHeader' style='width=200; text-align: right;'>
          <a href='addEditItem.pl?act=edit&upc=$form{upc}' class='lnkButton'>Return to Modify Item</a>
        </td>
      </tr>

	  <tr style='height:20px'>
    		<td class='formColHeader' style='width:150px; text-align:right;'>Brand:</td>
    		<td class='formBody' style='width:425px'>$hashref->{brand}</td>
    		<td class='formColHeader' style='width:150px; text-align:right;'>IBC Item:</td>
    		<td class='formBody' style='width:100px'>$ibcItem</td>
      </tr>  
	  <tr style='height:20px'>
    		<td class='formColHeader' style='width:150px; text-align:right;'>Flavor:</td>
    		<td class='formBody' style='width:425px'>$hashref->{flavor}</td>
    		<td class='formColHeader' style='width:150px; text-align:right;'>Compressed UPC:</td>
    		<td class='formBody' style='width:100px'>$hashref->{compressedUPC}</td>
    </tr>  
	  <tr style='height:20px'>
    		<td class='formColHeader' style='width:150px; text-align:right;'>Description:</td>
    		<td class='formBody' style='width:425px'>$hashref->{itemName}</td>
    		<td class='formColHeader' style='width:150px; text-align:right;'>Label Weight:</td>
    		<td class='formBody' style='width:100px'>$hashref->{labelWeight}</td>
    </tr>  
	  <tr style='height:20px'>
    		<td class='formColHeader' style='width:150px; text-align:right;'>Published Description:</td>
    		<td class='formBody' style='width:425px'>$hashref->{publishedDescription}</td>
    		<td class='formColHeader' style='width:150px; text-align:right;'>Piece Count:</td>
    		<td class='formBody' style='width:100px'>$hashref->{pieceCount}</td>
    </tr>  
	  <tr style='height:20px'>
    		<td class='formColHeader' style='width:150px; text-align:right;'>Bread/Cake Code:</td>
    		<td class='formBody' style='width:425px'>$breadCakeCode</td>
    		<td class='formColHeader' style='width:150px; text-align:right;'>&nbsp;</td>
    		<td class='formBody' style='width:100px'>&nbsp;</td>
      </tr>  
	  <tr style='height:20px'>
    		<td class='formColHeader' style='width:150px; text-align:right;'>Private Label:</td>
    		<td class='formBody' style='width:425px'>$privateLabel</td>
    		<td class='formColHeader' style='width:150px; text-align:right;'>Length:</td>
    		<td class='formBody' style='width:100px'>$hashref->{length}</td>
    </tr>  
	  <tr style='height:20px'>
    		<td class='formColHeader' style='width:150px; text-align:right;'>Product Classification:</td>
    		<td class='formBody' style='width:425px'>$hashref->{prodClassName}</td>
    		<td class='formColHeader' style='width:150px; text-align:right;'>Width:</td>
    		<td class='formBody' style='width:100px'>$hashref->{width}</td>
      </tr>  
	  <tr style='height:20px'>
    		<td class='formColHeader' style='width:150px; text-align:right;'>Product Category:</td>
    		<td class='formBody' style='width:425px'>$hashref->{prodCategoryName}</td>
    		<td class='formColHeader' style='width:150px; text-align:right;'>Height:</td>
    		<td class='formBody' style='width:100px'>$hashref->{height}</td>
      </tr>  
	  <tr style='height:20px'>
    		<td class='formColHeader' style='width:150px; text-align:right;'>UDEX Category:</td>
    		<td class='formBody' style='width:425px'>$hashref->{udexCategoryName}</td>
    		<td class='formColHeader' style='width:150px; text-align:right;'>Volume:</td>
    		<td class='formBody' style='width:100px'>$hashref->{volume} cu. in.</td>
      </tr>  
	  <tr style='height:20px'>
    		<td class='formColHeader' style='width:150px; text-align:right;border-top: 1px solid black;'>Last Modified:</td>
    		<td class='formBody' style='width:675px;border-top: 1px solid black;' colspan='3'>by $hashref->{firstName} $hashref->{lastName} on $hashref->{changedOn}</td>
    </tr>  
	  <tr style='height:20px'>
    		<td class='formColHeader' style='width:150px; text-align:right;'>COM-STATUS:</td>
    		<td class='formBody' style='width:675px;' colspan='3'>$hashref->{comStatus}</td>
    </tr>  
	  <tr style='height:20px'>
    		<td class='formColHeader' style='width:150px; text-align:right;'>Last Extracted:</td>
    		<td class='formBody' style='width:675px;' colspan='3'>$hashref->{extractTimestamp}</td>
    </tr>  


	  <tr style='height:20px'>
    		<td class='formBody'  colspan='4' style='border-top: 1px solid black; border-bottom: 1px solid black; background-color: #999999;'>&nbsp;</td>
    </tr>    

	   

  </table>

<br class='clear' />
"
}

display_pallet();

#end content

standard_footer();
exit;