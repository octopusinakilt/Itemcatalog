#!c:/perl/bin/perl.exe
use DBI;
use CGI::Carp qw(fatalsToBrowser);
use CGI;

require("c:/inetpub/cgi-bin/common/stand.pl");
require("c:/inetpub/cgi-bin/common/format.pl");
require("c:/inetpub/cgi-bin/common/misc.pl");
require("c:/inetpub/cgi-bin/common/html_select.pl");
require("c:/inetpub/cgi-bin/common/database.cfg");



$dbh = DBI->connect ($dsn, $duser, $dpass, { RaiseError => 1});
$dbh->disconnect;

$user_id = auth_logged_in();

$query = new CGI;
$duns_list = hs_duns('006927180', 'NAON', 0, 0);



print $query->header('text/html');

standard_header("eCommerce Portal");

##content
print "<form name='detailSearch' action='/cgi-bin/adjust/result.pl' method='post'>
<table class='formTable' style='width:900'>
      <tr>
        <td class='formHeader' style='text-align:Left'> Modify an Existing Item </td>
        <td class='tblInfoHeadLast' style='width=300'>
          <a href='#' class='lnkButton'>Return to Results</a>
          <a href='javascript:checkDelete()\;' class='lnkButton'>Delete Item</a>
          <a href='/cgi-bin/itemcat/history.pl' class='lnkButton'>Item History</a>
        </td>
      </tr>

	  <tr style='height:25px'>
    		<td class='formColHeader' style='width:150px; text-align:right;'>UPC:</td>
    		<td class='formBody' style='width:675px'>0-45000-12345-3</td>
      </tr>  
	  <tr style='height:25px'>
    		<td class='formColHeader' style='width:150px; text-align:right;'>Brand:</td>
    		<td class='formBody' style='width:675px'>
      			<select name='dunsID' id='dunsID' style='width:75px'>
        			<option value=1>Bread
        			<option value=2>Cake
			    </select>
    		</td>
    </tr>  
	  <tr style='height:25px'>
    		<td class='formColHeader' style='width:150px; text-align:right;'>Status:</td>
    		<td class='formBody' style='width:675px'>
      			<select name='dunsID' id='dunsID' style='width:75px'>
        			<option value=1>Active
        			<option value=2>Inactive
			    </select>
    		</td>
    </tr>  

	  <tr style='height:25px'>
    	<td class='formColHeader' style='width:150px; text-align:right;'>Flavor:</td>
    	<td class='formBody' style='width:675px'><input name='invID' type='text' id='invID' style='width:150px' value=''></td>
 	  </tr>  
	  <tr style='height:25px'>
    	<td class='formColHeader' style='width:150px; text-align:right;'>Description:</td>
    	<td class='formBody' style='width:675px'><input name='invID' type='text' id='invID' style='width:150px' value=''></td>
 	  </tr>  
	  <tr style='height:25px'>
    	<td class='formColHeader' style='width:150px; text-align:right;'>Published Description:</td>
    	<td class='formBody' style='width:675px'><input name='invID' type='text' id='invID' style='width:150px' value=''></td>
 	  </tr>  
	  <tr style='height:25px'>
    	<td class='formColHeader' style='width:150px; text-align:right;'>&nbsp;</td>
    	<td class='formBody' style='width:675px'>Retailers request Brand, Flavor, Description, Label Weight, and Piece Countto be included in the Published Description</td>
 	  </tr>  

	  <tr style='height:25px'>
    	<td class='formColHeader' style='width:150px; text-align:right;'>Label Weight:</td>
    	<td class='formBody' style='width:675px'><input name='invID' type='text' id='invID' style='width:150px' value=''>&nbsp;in ounces</td>
 	  </tr>  
	  <tr style='height:25px'>
    	<td class='formColHeader' style='width:150px; text-align:right;'>Piece Count:</td>
    	<td class='formBody' style='width:675px'><input name='invID' type='text' id='invID' style='width:150px' value=''></td>
 	  </tr>  
	  <tr style='height:25px'>
    		<td class='formColHeader' style='width:150px; text-align:right;'>Compressed UPC:</td>
    		<td class='formBody' style='width:675px'>
    	     <input name='invID' type='text' id='invID' style='width:25px' value=''>
    	     <input name='invID' type='text' id='invID' style='width:50px' value=''>
    	     <input name='invID' type='text' id='invID' style='width:25px' value=''>
    		</td>
    </tr>  
	  <tr style='height:25px'>
    		<td class='formColHeader' style='width:150px; text-align:right;'>Private Label:</td>
    		<td class='formBody' style='width:675px'>
      			<select name='dunsID' id='dunsID' style='width:75px'>
        			<option value=0>No
        			<option value=1>Yes
			    </select>
    		</td>
    </tr>  
	  <tr style='height:25px'>
    		<td class='formColHeader' style='width:150px; text-align:right;'>IBC Item:</td>
    		<td class='formBody' style='width:675px'>
      			<select name='dunsID' id='dunsID' style='width:75px'>
        			<option value=0>No
        			<option value=1>Yes
			    </select>
    		</td>
    </tr>  
	  <tr style='height:25px'>
    	<td class='formColHeader' style='width:150px; text-align:right;'>Product Class:</td>
    	<td class='formBody' style='width:675px'><input name='invID' type='text' id='invID' style='width:75px' value=''></td>
 	  </tr>  

	  <tr style='height:25px'>
    	<td class='formColHeader' style='width:150px; text-align:right;'>Bread Cake Code:</td>
    	<td class='formBody' style='width:675px'>Cake</td>
 	  </tr>  
	  <tr style='height:25px'>
    	<td class='formColHeader' style='width:150px; text-align:right;'>Produuct Classification:</td>
    	<td class='formBody' style='width:675px'>Classification Description</td>
 	  </tr>  
	  <tr style='height:25px'>
    	<td class='formColHeader' style='width:150px; text-align:right;'>Product Category:</td>
    	<td class='formBody' style='width:675px'>Category Description</td>
 	  </tr>  
	  <tr style='height:25px'>
    	<td class='formColHeader' style='width:150px; text-align:right;'>UDEX Category:</td>
    	<td class='formBody' style='width:675px'>12-12324-12323 With some Description</td>
 	  </tr>  

	  <tr style='height:25px'>
    	<td class='formColHeader' style='width:150px; text-align:right;'>Length:</td>
    	<td class='formBody' style='width:675px'><input name='invID' type='text' id='invID' style='width:75px' value=''>&nbsp in inches</td>
 	  </tr>  
	  <tr style='height:25px'>
    	<td class='formColHeader' style='width:150px; text-align:right;'>Width:</td>
    	<td class='formBody' style='width:675px'><input name='invID' type='text' id='invID' style='width:75px' value=''>&nbsp in inches</td>
 	  </tr>  
	  <tr style='height:25px'>
    	<td class='formColHeader' style='width:150px; text-align:right;'>Height:</td>
    	<td class='formBody' style='width:675px'><input name='invID' type='text' id='invID' style='width:75px' value=''>&nbsp in inches</td>
 	  </tr>  
	  <tr style='height:25px'>
    	<td class='formColHeader' style='width:150px; text-align:right;'>Volume:</td>
    	<td class='formBody' style='width:675px'>100&nbsp in cubic inches</td>
 	  </tr>  
	  <tr style='height:25px'>
    	<td class='formColHeader' style='width:150px; text-align:right;'>Com Status:</td>
    	<td class='formBody' style='width:675px'>Loaded</td>
 	  </tr>  
	  <tr style='height:25px'>
    	<td class='formColHeader' style='width:150px; text-align:right;'>Last Modified by:</td>
    	<td class='formBody' style='width:675px'>Mickey Doyle on 2006-05-01 at 12:32pm</td>
 	  </tr>  
	  <tr style='height:25px'>
    	<td class='formColHeader' style='width:150px; text-align:right;'>Last Extracted:</td>
    	<td class='formBody' style='width:675px'>2006-05-01 at 06:32pm</td>
 	  </tr>  
		<tr>
     	<td class='formFooter' style='text-align:center' colspan=2>
				<input type='submit' value='Update Item' name='submit' class='formButton'>
			</td>
   	</tr>
</table>
</form>
</table>  

<table class='formTable' style='width:900'>
      <tr>
        <td class='formHeader' style='text-align:Left'> Tray, Case & Pallet Attributes</td>
        <td class='tblInfoHeadLast' style='width=300'>
          <a href='#' class='lnkButton'>Maintain Trays</a>
          <a href='#' class='lnkButton'>Maintain Cases</a>
          <a href='#' class='lnkButton'>Maintain Pallets</a>
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
	<tr class='tblInfoDataRowLight' onmouseover='className=\"tblInfoDataRowHiLight\"' onmouseout='className=\"tblInfoDataRowLight\"'> 
		<td class='tblInfoDataFirst' style='border-bottom: 0px;border-right: 0px;' colspan='3'><b>Tray:</b> 0-45000-12345-4</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>XX-X-XXXXX-XXXXX-X</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>##</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>##.# lbs</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>##.#</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>##.#</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>##.#</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;'>##.#</td>
	</tr> 
	<tr class='tblInfoDataRowLight' onmouseover='className=\"tblInfoDataRowHiLight\"' onmouseout='className=\"tblInfoDataRowLight\"'> 
		<td class='tblInfoDataFirst' style='width: 100px;border-bottom: 0px;border-right: 0px;'>&nbsp;</td>
		<td class='tblInfoData' colspan='2' style='width: 250px;border-bottom: 0px;border-right: 0px;'><b>Case:</b> 0-45000-12345-4</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>XX-X-XXXXX-XXXXX-X</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>##</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>##.# lbs</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>##.#</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>##.#</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>##.#</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;'>##.#</td>
	</tr> 
	<tr class='tblInfoDataRowLight' onmouseover='className=\"tblInfoDataRowHiLight\"' onmouseout='className=\"tblInfoDataRowLight\"'> 
		<td class='tblInfoDataFirst' colspan='2' style='width: 250px;border-bottom: 0px;border-right: 0px;'>&nbsp;</td>
		<td class='tblInfoData' style='width: 100px;text-align:right;border-bottom: 0px;border-right: 0px;'><b>Pallet:</b></td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>XX-X-XXXXX-XXXXX-X</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;' colspan=2>12 Casses/Layer</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>&nbsp;</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;' colspan=2>6 Layers/Pallet</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;'>&nbsp;</td>
	</tr> 
	<tr class='tblInfoDataRowLight' onmouseover='className=\"tblInfoDataRowHiLight\"' onmouseout='className=\"tblInfoDataRowLight\"'> 
		<td class='tblInfoDataFirst' colspan='2' style='width: 250px;border-bottom: 0px;border-right: 0px;'>&nbsp;</td>
		<td class='tblInfoData' style='width: 100px;text-align:right;border-bottom: 0px;border-right: 0px;'><b>Pallet:</b></td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>XX-X-XXXXX-XXXXX-X</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;' colspan=2>12 Casses/Layer</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>&nbsp;</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;' colspan=2>6 Layers/Pallet</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;'>&nbsp;</td>
	</tr> 
	<tr class='tblInfoDataRowLight' style='height:3px;'>
	  <td colspan='10' style='font-size: 2px; height: 3px; border: 1px solid black; border-top: 0px;'>&nbsp;</td> 
	</tr>
	<tr class='tblInfoDataRowLight' onmouseover='className=\"tblInfoDataRowHiLight\"' onmouseout='className=\"tblInfoDataRowLight\"'> 
		<td class='tblInfoDataFirst' style='border-bottom: 0px;border-right: 0px;' colspan='3'><b>Tray:</b> 0-45000-12345-4</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>XX-X-XXXXX-XXXXX-X</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>##</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>##.# lbs</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>##.#</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>##.#</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>##.#</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;'>##.#</td>
	</tr> 
	<tr class='tblInfoDataRowLight' style='height:3px;'>
	  <td colspan='10' style='font-size: 2px; height: 3px; border: 1px solid black; border-top: 0px;'>&nbsp;</td> 
	</tr>
	<tr class='tblInfoDataRowLight' onmouseover='className=\"tblInfoDataRowHiLight\"' onmouseout='className=\"tblInfoDataRowLight\"'> 
		<td class='tblInfoDataFirst' style='border-bottom: 0px;border-right: 0px;' colspan='3'><b>Tray:</b> 0-45000-12345-4</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>XX-X-XXXXX-XXXXX-X</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>##</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>##.# lbs</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>##.#</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>##.#</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>##.#</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;'>##.#</td>
	</tr> 
	<tr class='tblInfoDataRowLight' onmouseover='className=\"tblInfoDataRowHiLight\"' onmouseout='className=\"tblInfoDataRowLight\"'> 
		<td class='tblInfoDataFirst' style='width: 100px;border-bottom: 0px;border-right: 0px;'>&nbsp;</td>
		<td class='tblInfoData' colspan='2' style='width: 250px;border-bottom: 0px;border-right: 0px;'><b>Case:</b> 0-45000-12345-4</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>XX-X-XXXXX-XXXXX-X</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>##</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>##.# lbs</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>##.#</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>##.#</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>##.#</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;'>##.#</td>
	</tr> 
	<tr class='tblInfoDataRowLight' onmouseover='className=\"tblInfoDataRowHiLight\"' onmouseout='className=\"tblInfoDataRowLight\"'> 
		<td class='tblInfoDataFirst' style='width: 100px;border-bottom: 0px;border-right: 0px;'>&nbsp;</td>
		<td class='tblInfoData' colspan='2' style='width: 250px;border-bottom: 0px;border-right: 0px;'><b>Case:</b> 0-45000-12345-4</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>XX-X-XXXXX-XXXXX-X</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>##</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>##.# lbs</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>##.#</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>##.#</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;border-right: 0px;'>##.#</td>
		<td class='tblInfoData' style='text-align:center;border-bottom: 0px;'>##.#</td>
	</tr>
	<tr class='tblInfoDataRowLight' style='height:3px;'>
	  <td colspan='10' style='font-size: 2px; height: 3px; border: 1px solid black; border-top: 0px;'>&nbsp;</td> 
	</tr>
</table>
<br class='clear' />";
#end content
print "
<script language='JavaScript'>
function checkDelete(){
	if (confirm('man you gotta be smoking some serious crack right now!')){
		alert('oh you are so screwed')\;
		}
	else{
		alert('whew!')\;
		}
}
</script>";
standard_footer();
exit;