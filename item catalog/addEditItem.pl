#!c:/perl/bin/perl.exe
use DBI;
use CGI::Carp qw(fatalsToBrowser);
use CGI;
use CGI::Session;
    


require("c:/inetpub/cgi-bin/common/stand.pl");
require("c:/inetpub/cgi-bin/common/format.pl");
require("c:/inetpub/cgi-bin/common/misc.pl");
require("c:/inetpub/cgi-bin/common/database.cfg");


$dbh = DBI->connect ($dsn, $duser, $dpass, { RaiseError => 1});
$query = new CGI;
%form = $query->Vars;
$session = new CGI::Session();
$user_id = auth_logged_in();

$sql0 = "SELECT prodClassCode, breadCakeCode, prodClassName FROM productClass";
$sth0 = $dbh->prepare($sql0);
$sth0->execute();

$sql1 = "SELECT trayUPC, trayID, GTIN, pack, weight, weightUOM, length, height, width, length * width * height AS volume FROM trays
WHERE (UPC = '$form{upc}')";

$sql2 = "SELECT caseID, trayID, caseUPC, UPC, GTIN, pack, weight, length, width, weightUOM, height, length * width * height AS volume FROM cases WHERE (UPC = '$form{upc}')";

$sql3 = "SELECT cases.caseID, pallets.casesPerLayer, pallets.layersPerPallet, pallets.GTIN FROM pallets INNER JOIN cases ON pallets.caseID = cases.caseID WHERE (cases.UPC = '$form{upc}')";


$sth1 = $dbh->prepare($sql1);
$sth1->execute();

$sth2 = $dbh->prepare($sql2);
$sth2->execute();

$sth3 = $dbh->prepare($sql3);
$sth3->execute();


$x = 0;
$y = 0;
$z = 0;
#populate arrays needed for crazy tray case pallet output
while ($hashref = $sth1->fetchrow_hashref){
	$trays[$x][0] = $hashref->{trayID};
	$trays[$x][1] = $hashref->{trayUPC};
	$trays[$x][2] = $hashref->{GTIN};
	$trays[$x][3] = $hashref->{pack};
	$trays[$x][4] = $hashref->{weight};
	$trays[$x][5] = $hashref->{weightUOM};
	$trays[$x][6] = $hashref->{length};
	$trays[$x][7] = $hashref->{height};
	$trays[$x][8] = $hashref->{width};
	$trays[$x][9] = $hashref->{volume};
	$x++
}

while ($hashref = $sth2->fetchrow_hashref){
	$cases[$y][0] = $hashref->{caseID};
	$cases[$y][1] = $hashref->{trayID};
	$cases[$y][2] = $hashref->{caseUPC};
	$cases[$y][3] = $hashref->{UPC};
	$cases[$y][4] = $hashref->{GTIN};
	$cases[$y][5] = $hashref->{pack};
	$cases[$y][6] = $hashref->{weight};
	$cases[$y][7] = $hashref->{length};
	$cases[$y][8] = $hashref->{width};
	$cases[$y][9] = $hashref->{weightUOM};
	$cases[$y][10] = $hashref->{height};
	$cases[$y][11] = $hashref->{volume};
	$y++
}

while ($hashref = $sth3->fetchrow_hashref){
	$pallets[$z][0] = $hashref->{caseID};
	$pallets[$z][1] = $hashref->{casesPerLayer};
	$pallets[$z][2] = $hashref->{layersPerPallet};
	$pallets[$z][3] = $hashref->{GTIN};
	$z++
}

#get the information to populate the form for edit
if ($form{act} eq 'edit'){
	$sql4 = "SELECT substring(upc,1,1) AS upc1, substring(upc,2,5) AS upc2, substring(upc,7,5) AS upc3, substring(upc,12,1) AS upc4, brand, flavor, description, publishedDescription, labelWeight, pieceCount, compressedUPC, privateLabel, ibcItem, prodClassCode, length, width, height, breadCakeCode ";
    $sql4 .= "FROM itemcatalog ";
	$sql4 .= "WHERE UPC = '$form{upc}'";
	$sth4 = $dbh->prepare($sql4);
	$sth4->execute();
#orginally  i was going to wrap this around the code for the edit page but that would have involved putting a fetshrow in a fetchrow. I don't know if you can do that and don't have the patients to experiment with it.
	while ($hashref = $sth4->fetchrow_hashref){
		$upc1 = $hashref->{upc1};
		$upc2 = $hashref->{upc2};
		$upc3 = $hashref->{upc3};
		$upc4 = $hashref->{upc4};
		$wholeUPC = $hashref->{upc1} . $hashref->{upc2} . $hashref->{upc3} . $hashref->{upc4};
		$brand = $hashref->{brand};
		$flavor = $hashref->{flavor};
		$description = $hashref->{description};
		$publishedDescription = $hashref->{publishedDescription};
		$labelWeight = $hashref->{labelWeight};
		$pieceCount = $hashref->{pieceCount};
		$compressedUPC = $hashref->{compressedUPC};
		$privateLabel = $hashref->{privateLabel};
		$ibcItem = $hashref->{ibcItem};
		$prodClassCode = $hashref->{prodClassCode};
		$length = $hashref->{length};
		$width = $hashref->{width};
		$height = $hashref->{height};
		$breadCakeCode = $hashref->{breadCakeCode};
	}
}

print $query->header('text/html');

standard_header("eCommerce Portal");

if ($form{act} eq 'new' || $form{act} eq ''){
#add form
print "  
  <div id='content'> <form name='detailSearch' action='/cgi-bin/itemcat/test.pl' method='post'>
<table class='formTable' style='width:900'>
      <tr>
        <td class='formHeader' style='text-align:Left'> Add a New Item </td>
        <td class='tblInfoHeadLast' style='width=100'>&nbsp;
          
        </td>
      </tr>

	  <tr style='height:25px'>
    		<td class='formColHeader' style='width:150px; text-align:right;'>UPC:</td>
    		<td class='formBody' style='width:675px'>
    	     <input name='upc1' type='text' id='upc1' style='width:25px' maxlength='1'>
    	     <input name='upc2' type='text' id='upc2' style='width:50px' maxlength='5'>
    	     <input name='upc3' type='text' id='upc3' style='width:50px' maxlength='5'>
    	     <input name='upc4' type='text' id='upc4' style='width:25px' maxlength='1'>
    		</td>
    </tr>  
	  <tr style='height:25px'>
    		<td class='formColHeader' style='width:150px; text-align:right;'>Brand:</td>
    		<td class='formBody' style='width:675px'>
      			<select name='brand' id='brand' style='width:75px'>
        			<option value=1>Bread</option>
        			<option value=2>Cake</option>
		      </select>
    		</td>
    </tr>  

	  <tr style='height:25px'>
    	<td class='formColHeader' style='width:150px; text-align:right;'>Flavor:</td>
    	<td class='formBody' style='width:675px'><input name='flavor' type='text' id='flavor' style='width:150px' value='$flavor'></td>
 	  </tr>  
	  <tr style='height:25px'>
    	<td class='formColHeader' style='width:150px; text-align:right;'>Description:</td>
    	<td class='formBody' style='width:675px'><input name='description' type='text' id='description' style='width:150px' value='$description'></td>
 	  </tr>  
	  <tr style='height:25px'>
    	<td class='formColHeader' style='width:150px; text-align:right;'>Published Description:</td>
    	<td class='formBody' style='width:675px'><input name='publishedDescription' type='text' id='publishedDescription' style='width:150px' value='$publishedDescription'></td>
 	  </tr>  
	  <tr style='height:25px'>
    	<td class='formColHeader' style='width:150px; text-align:right;'>&nbsp;</td>
    	<td class='formBody' style='width:675px'>Retailers request Brand, Flavor, Description, Label Weight, and Piece Countto be included in the Published Description</td>
 	  </tr>  

	  <tr style='height:25px'>
    	<td class='formColHeader' style='width:150px; text-align:right;'>Label Weight:</td>
    	<td class='formBody' style='width:675px'><input name='labelWeight' type='text' id='labelWeight' style='width:150px' value='$labelWeight'> 
    	in ounces</td>
 	  </tr>  
	  <tr style='height:25px'>
    	<td class='formColHeader' style='width:150px; text-align:right;'>Piece Count:</td>
    	<td class='formBody' style='width:675px'><input name='pieceCount' type='text' id='pieceCount' style='width:150px' value='$pieceCount'></td>
 	  </tr>  
	  <tr style='height:25px'>
    		<td class='formColHeader' style='width:150px; text-align:right;'>Compressed UPC:</td>
    		<td class='formBody' style='width:675px'>
    	     <input name='compressedUPC1' type='text' id='compressedUPC1' style='width:25px' value=''>
    	     <input name='compressedUPC2' type='text' id='compressedUPC2' style='width:50px' value=''>
    	     <input name='compressedUPC3' type='text' id='compressedUPC3' style='width:25px' value=''>
    		</td>
    </tr>  
	  <tr style='height:25px'>
    		<td class='formColHeader' style='width:150px; text-align:right;'>Private Label:</td>
    		<td class='formBody' style='width:675px'>
      			<select name='privateLabel' id='privateLabel' style='width:75px'>
        			<option value=0>No
        			<option value=1>Yes
		      	</select>
    		</td>
    </tr>  
	  <tr style='height:25px'>
    		<td class='formColHeader' style='width:150px; text-align:right;'>IBC Item:</td>
    		<td class='formBody' style='width:675px'>
      			<select name='ibcItem' id='ibcItem' style='width:75px'>
        			<option value=0>No
        			<option value=1>Yes
		      </select>
    		</td>
    </tr>  
	  <tr style='height:25px'>
    	<td class='formColHeader' style='width:150px; text-align:right;'>Product Class:</td>
    	<td class='formBody' style='width:675px'>
			<select name='productClass'>";
				while ($hashref = $sth0->fetchrow_hashref){
				if ($hashref->{breadCakeCode} == 1) {$breadOrCake = 'Bread';}
				else {$breadOrCake = 'Cake';}
				print "<option value='$hashref->{prodClassCode}'>$hashref->{prodClassName} $breadOrCake</option>";
				}
print "     </select>  
		<td>
 	  </tr>  
	  <tr style='height:25px'>
    	<td class='formColHeader' style='width:150px; text-align:right;'>Length:</td>
    	<td class='formBody' style='width:675px'><input name='length' type='text' id='length' style='width:75px' value='$lenght'>  
    	in inches</td>
 	  </tr>  
	  <tr style='height:25px'>
    	<td class='formColHeader' style='width:150px; text-align:right;'>Width:</td>
    	<td class='formBody' style='width:675px'><input name='width' type='text' id='width' style='width:75px' value='$width'>  
    	in inches</td>
 	  </tr>  
	  <tr style='height:25px'>
    	<td class='formColHeader' style='width:150px; text-align:right;'>Height:</td>
    	<td class='formBody' style='width:675px'><input name='height' type='text' id='height' style='width:75px' value='$height'>  
    	in inches</td>
 	  </tr>  



		<tr>
     	<td class='formFooter' style='text-align:center' colspan=2>
				<input type='submit' value='Add Item' name='submit' class='formButton'>
			</td>
   	</tr>
</table>  <br class='clear' />  </div>"
}
else{
#edit form

print "
  <div id='content'> <form name='detailSearch' action='/cgi-bin/itemcat/test.pl' method='post'>
<table class='formTable' style='width:900'>
      <tr>
        <td class='formHeader' style='text-align:Left'>Modify an Existing Item </td>
        <td class='tblInfoHeadLast' style='width=100'><a href='history.pl?upc=$wholeUPC' class='lnkButton'>Item History</a></td>
      </tr>
	  <tr style='height:25px'>
    		<td class='formColHeader' style='width:150px; text-align:right;'>UPC:</td>
    		<td class='formBody' style='width:675px'>
    	     <input name='upc1' type='text' id='upc1' style='width:25px' value='$upc1'>
    	     <input name='upc2' type='text' id='upc2' style='width:50px' value='$upc2'>
    	     <input name='upc3' type='text' id='upc3' style='width:50px' value='$upc3'>
    	     <input name='upc4' type='text' id='upc4' style='width:25px' value='$upc4'>
    		</td>
     </tr>  
	  <tr style='height:25px'>
    		<td class='formColHeader' style='width:150px; text-align:right;'>Bread/Cake Code:</td>
    		<td class='formBody' style='width:675px'>
      			<select name='breadCakeCode' id='brand' style='width:75px'>";
				if($breadCakeCode == 1){
					print "
					<option value=1 selected>Bread</option>
        			<option value=2>Cake</option>";
				}
				else{
				print "
					<option value=1>Bread</option>
        			<option value=2 selected>Cake</option>";
				}
print "
		      </select>
    		</td>
    </tr>  
	  <tr style='height:25px'>
    	<td class='formColHeader' style='width:150px; text-align:right;'>Brand:</td>
    	<td class='formBody' style='width:675px'><input name='brand' type='text' id='brand' style='width:150px' value='$brand'></td>
 	  </tr>  
	  <tr style='height:25px'>
    	<td class='formColHeader' style='width:150px; text-align:right;'>Flavor:</td>
    	<td class='formBody' style='width:675px'><input name='flavor' type='text' id='flavor' style='width:150px' value='$flavor'></td>
 	  </tr>  
	  <tr style='height:25px'>
    	<td class='formColHeader' style='width:150px; text-align:right;'>Description:</td>
    	<td class='formBody' style='width:675px'><input name='description' type='text' id='description' style='width:150px' value='$description'></td>
 	  </tr>  
	  <tr style='height:25px'>
    	<td class='formColHeader' style='width:150px; text-align:right;'>Published Description:</td>
    	<td class='formBody' style='width:675px'><input name='publishedDescription' type='text' id='publishedDescription' style='width:150px' value='$publishedDescription'></td>
 	  </tr>  
	  <tr style='height:25px'>
    	<td class='formColHeader' style='width:150px; text-align:right;'>&nbsp;</td>
    	<td class='formBody' style='width:675px'>Retailers request Brand, Flavor, Description, Label Weight, and Piece Count to be included in the Published Description</td>
 	  </tr>   
	  <tr style='height:25px'>
    	<td class='formColHeader' style='width:150px; text-align:right;'>Label Weight:</td>
    	<td class='formBody' style='width:675px'><input name='labelWeight' type='text' id='labelWeight' style='width:150px' value='$labelWeight'> 
    	in ounces</td>
 	  </tr>  
	  <tr style='height:25px'>
    	<td class='formColHeader' style='width:150px; text-align:right;'>Piece Count:</td>
    	<td class='formBody' style='width:675px'><input name='pieceCount' type='text' id='pieceCount' style='width:150px' value='$pieceCount'></td>
 	  </tr>  
	  <tr style='height:25px'>
    		<td class='formColHeader' style='width:150px; text-align:right;'>Compressed UPC:</td>
    		<td class='formBody' style='width:675px'>
    	     <input name='compressedUPC1' type='text' id='compressedUPC1' style='width:25px' value=''>
    	     <input name='compressedUPC2' type='text' id='compressedUPC2' style='width:50px' value=''>
    	     <input name='compressedUPC3' type='text' id='compressedUPC3' style='width:25px' value=''>
    		</td>
      </tr>  
	  <tr style='height:25px'>
    		<td class='formColHeader' style='width:150px; text-align:right;'>Private Label:</td>
    		<td class='formBody' style='width:675px'>
      			<select name='privateLabel' id='privateLabel' style='width:75px'>";
        			if ($privateLabel == 0){
						print"
        				<option value=0 selected>No</option>
        				<option value=1>Yes</option>";
					}
					else{
						print"
						<option value=0>No</option>
        				<option value=1 selected>Yes</option>";
					}
print"
		      </select>
    		</td>
    </tr>  
	  <tr style='height:25px'>
    		<td class='formColHeader' style='width:150px; text-align:right;'>IBC Item:</td>
    		<td class='formBody' style='width:675px'>
      			<select name='ibcItem' id='ibcItem' style='width:75px'>";
					if ($ibcItem == 0){
						print"
        				<option value=0 selected>No</option>
        				<option value=1>Yes</option>";
					}
					else{
						print"
						<option value=0>No</option>
        				<option value=1 selected>Yes</option>";
					}
print"
		      </select>
    		</td>
    </tr>  
	  <tr style='height:25px'>
    	<td class='formColHeader' style='width:150px; text-align:right;'>Product Class:</td>
    	<td class='formBody' style='width:675px'>
		<select name='productClass'>";
				while ($hashref = $sth0->fetchrow_hashref){
					if ($hashref->{breadCakeCode} == 1) {$breadOrCake = 'Bread';}
					else {$breadOrCake = 'Cake';}
					if ($prodClassCode == $hashref->{prodClassCode}){
						print "<option value='$hashref->{prodClassCode}' selected>$hashref->{prodClassName} $breadOrCake</option>";
					}
					else{
				 		print "<option value='$hashref->{prodClassCode}'>$hashref->{prodClassName} $breadOrCake</option>";
					}
				}
print "     </select>  		
		</td>
 	  </tr>  
	  <tr style='height:25px'>
    	<td class='formColHeader' style='width:150px; text-align:right;'>Length:</td>
    	<td class='formBody' style='width:675px'><input name='length' type='text' id='length' style='width:75px' value='$length'>  
    	in inches</td>
 	  </tr>  
	  <tr style='height:25px'>
    	<td class='formColHeader' style='width:150px; text-align:right;'>Width:</td>
    	<td class='formBody' style='width:675px'><input name='width' type='text' id='width' style='width:75px' value='$width'>  
    	in inches</td>
 	  </tr>  
	  <tr style='height:25px'>
    	<td class='formColHeader' style='width:150px; text-align:right;'>Height:</td>
    	<td class='formBody' style='width:675px'><input name='height' type='text' id='height' style='width:75px' value='$height'>  
    	in inches</td>
 	  </tr>  
		<tr>
     		<td class='formFooter' style='text-align:center' colspan=2><input type='submit' value='Edit Item' name='submit' class='formButton'></td>
   		</tr>
</table>  <br class='clear' />  

<table class='formTable' style='width:900'>
      <tr>
        <td class='formHeader' style='text-align:Left'> Tray, Case & Pallet Attributes</td>
        <td class='tblInfoHeadLast' style='width=300'>
          <a href='trays.pl?upc=$form{upc}' class='lnkButton'>Maintain Trays</a>
          <a href='case.pl?upc=$form{upc}' class='lnkButton'>Maintain Cases</a>
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
    <td class='tblInfoCol' style='text-align:center;width:50px;'>Weight</td>
    <td class='tblInfoCol' style='text-align:center;width:50px;'>Length</td>
    <td class='tblInfoCol' style='text-align:center;width:50px;'>Height</td>
    <td class='tblInfoCol' style='text-align:center;width:50px;'>Width</td>
    <td class='tblInfoCol' style='text-align:center;width:50px;'>Volume</td>
  </tr> 
";
for $i(0..$#trays){
	print "
	<tr class='tblInfoDataRowLight' onmouseover='className=\"tblInfoDataRowHiLight\"' onmouseout='className=\"tblInfoDataRowLight\"'> 
		<td class='tblInfoDataFirst' style='border-bottom: 0px;border-right: 0px;' colspan='3'><b>Tray:</b> $trays[$i][1]</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>$trays[$i][2]</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>$trays[$i][3]</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>$trays[$i][4] $trays[$i][5]</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>$trays[$i][6]</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>$trays[$i][7]</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>$trays[$i][8]</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;'>$trays[$i][9]</td>
	</tr> 
";
	for $j(0..$#cases){
		if ($trays[$i][0] == $cases[$j][1]){
			print "
			<tr class='tblInfoDataRowLight' onmouseover='className=\"tblInfoDataRowHiLight\"' onmouseout='className=\"tblInfoDataRowLight\"'> 
				<td class='tblInfoDataFirst' style='width: 100px;border-bottom: 0px;border-right: 0px;'>&nbsp;</td>
				<td class='tblInfoData' colspan='2' style='width: 250px;border-bottom: 0px;border-right: 0px;'><b>Case:</b> $cases[$j][2]</td>
				<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>$cases[$j][4]</td>
				<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>$cases[$j][1]</td>
				<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>$cases[$j][6] $cases[$j][9]</td>
				<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>$cases[$j][7]</td>
				<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>$cases[$j][10]</td>
				<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>$cases[$j][8]</td>
				<td class='tblInfoData' style='text-align:center;border-bottom: 0px;'>$cases[$j][11]</td>
			</tr> 
";
			for $k(0..$#pallets){
				if ($pallets[$k][0] == $cases[$j][0]){
					print "
					<tr class='tblInfoDataRowLight' onmouseover='className=\"tblInfoDataRowHiLight\"' onmouseout='className=\"tblInfoDataRowLight\"'> 
						<td class='tblInfoDataFirst' colspan='2' style='width: 250px;border-bottom: 0px;border-right: 0px;'>&nbsp;</td>
						<td class='tblInfoData' style='width: 100px;text-align:right;border-bottom: 0px;border-right: 0px;'><b>Pallet:</b></td>
						<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>$pallets[$k][3]</td>
						<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;' colspan=2>$pallets[$k][1] Casses/Layer</td>
						<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>&nbsp;</td>
						<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;' colspan=2>$pallets[$k][2] Layers/Pallet</td>
						<td class='tblInfoData' style='text-align:center;border-bottom: 0px;'>&nbsp;</td>
					</tr> 
";
				}
			}
		}
	}
print "
<tr class='tblInfoDataRowLight' style='height:3px;'>
	  <td colspan='10' style='font-size: 2px; height: 3px; border: 1px solid black; border-top: 0px;'>&nbsp;</td> 
</tr>
";
}
##for situation where a case has no pallet
for $l(0..$#cases){
		if ($cases[$l][1] eq ''){
			print "
			<tr class='tblInfoDataRowLight' onmouseover='className=\"tblInfoDataRowHiLight\"' onmouseout='className=\"tblInfoDataRowLight\"'> 
				<td class='tblInfoDataFirst' style='width: 100px;border-bottom: 0px;border-right: 0px;'>&nbsp;</td>
				<td class='tblInfoData' colspan='2' style='width: 250px;border-bottom: 0px;border-right: 0px;'><b>Case:</b> $cases[$l][2]</td>
				<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>$cases[$l][4]</td>
				<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>$cases[$l][1]</td>
				<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>$cases[$l][6] $cases[$j][9]</td>
				<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>$cases[$l][7]</td>
				<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>$cases[$l][10]</td>
				<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>$cases[$l][8]</td>
				<td class='tblInfoData' style='text-align:center;border-bottom: 0px;'>$cases[$l][11]</td>
			</tr> 
";
			for $m(0..$#pallets){
				if ($pallets[$m][0] == $cases[$l][0]){
					print "
					<tr class='tblInfoDataRowLight' onmouseover='className=\"tblInfoDataRowHiLight\"' onmouseout='className=\"tblInfoDataRowLight\"'> 
						<td class='tblInfoDataFirst' colspan='2' style='width: 250px;border-bottom: 0px;border-right: 0px;'>&nbsp;</td>
						<td class='tblInfoData' style='width: 100px;text-align:right;border-bottom: 0px;border-right: 0px;'><b>Pallet:</b></td>
						<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>$pallets[$m][3]</td>
						<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;' colspan=2>$pallets[$m][1] Casses/Layer</td>
						<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>&nbsp;</td>
						<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;' colspan=2>$pallets[$m][2] Layers/Pallet</td>
						<td class='tblInfoData' style='text-align:center;border-bottom: 0px;'>&nbsp;</td>
					</tr> 
";
				}
			}
		print "
			<tr class='tblInfoDataRowLight' style='height:3px;'>
	  			<td colspan='10' style='font-size: 2px; height: 3px; border: 1px solid black; border-top: 0px;'>&nbsp;</td> 
			</tr>
"
		
		}
		
}		

print "</table>"
}

standard_footer();

print "
<SCRIPT LANGUAGE=\"JavaScript\">


function checkNumeric(objName,minval, maxval,comma,period,hyphen)
{
	var numberfield = objName;
	if (chkNumeric(objName,minval,maxval,comma,period,hyphen) == false)
	{
		numberfield.select();
		numberfield.focus();
		return false;
	}
	else
	{
		return true;
	}
}

function chkNumeric(objName,minval,maxval,comma,period,hyphen)
{
// only allow 0-9 be entered, plus any values passed
// (can be in any order, and don't have to be comma, period, or hyphen)
// if all numbers allow commas, periods, hyphens or whatever,
// just hard code it here and take out the passed parameters
var checkOK = \"0123456789\" + comma + period + hyphen;
var checkStr = objName;
var allValid = true;
var decPoints = 0;
var allNum = \"\";

for (i = 0;  i < checkStr.value.length;  i++)
{
ch = checkStr.value.charAt(i);
for (j = 0;  j < checkOK.length;  j++)
if (ch == checkOK.charAt(j))
break;
if (j == checkOK.length)
{
allValid = false;
break;
}
if (ch != \",\")
allNum += ch;
}
if (!allValid)
{	
alertsay = 'Please enter only these values '
alertsay = alertsay + checkOK + ' in the ' + checkStr.name +  ' field.'
alert(alertsay);
return (false);
}

// set the minimum and maximum
var chkVal = allNum;
var prsVal = parseInt(allNum);
if (chkVal != '' && !(prsVal >= minval && prsVal <= maxval))
{
alertsay = 'Please enter a value greater than or '
alertsay = alertsay + 'equal to' + minval +  'and less than or '
alertsay = alertsay + 'equal to' + maxval + 'in the' + checkStr.name + 'field.'
alert(alertsay);
return (false);
}
}
</script>";

$dbh->disconnect;
exit;