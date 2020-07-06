#!c:/perl/bin/perl.exe
use DBI;
use CGI::Carp qw(fatalsToBrowser);
use CGI;

require("c:/inetpub/cgi-bin/common/stand.pl");
require("c:/inetpub/cgi-bin/common/format.pl");
require("c:/inetpub/cgi-bin/common/misc.pl");
require("c:/inetpub/cgi-bin/common/database.cfg");

$sql1 = "SELECT udexCategoryCode, udexCategoryName FROM udexcategory ORDER BY udexCategoryName";
$sql2 = "SELECT brand FROM brands ORDER BY brand";
$dbh = DBI->connect ($dsn, $duser, $dpass, { RaiseError => 1});
$sth1 = $dbh->prepare($sql1);
$sth1->execute();
$sth2 = $dbh->prepare($sql2);
$sth2->execute();



$user_id = auth_logged_in();
$query = new CGI;


print $query->header('text/html');

standard_header("eCommerce Portal");

##content
print "<form name='detailSearch' action='/cgi-bin/itemcat/result.pl' method='post'>
<table class='formTable' style='width:900'>
      <tr>
        <td class='formHeader' style='text-align:Left'>Select Search Criteria</td>
        <td class='tblInfoHeadLast' style='width=100'>
          <a href='/cgi-bin/itemcat/addEditItem.pl?act=new' class='lnkButton'>Add New Item</a>
        </td>
      </tr>

	  <tr style='height:25px'>
    		<td class='formColHeader' style='width:150px; text-align:right;'>UPC:</td>
      	<td class='formBody' style='width:675px'><input name='UPC' type='text' id='UPC' style='width:150px' value=''></td>
     </tr>  

	  <tr style='height:25px'>
    		<td class='formColHeader' style='width:150px; text-align:right;'>Brand:</td>
    		<td class='formBody' style='width:675px'>
      			<select name='brand' id='brand'>
					<option value='0'>No Brand Specified</option>
";
        		while ($hashref = $sth2->fetchrow_hashref){			
					print "<option value='$hashref->{brand}'>$hashref->{brand}</option>";
				}

print "		    </select>
    		</td>
       </tr>  

	  <tr style='height:25px'>
    	<td class='formColHeader' style='width:150px; text-align:right;'>Manufacturer's Code:</td>
    	<td class='formBody' style='width:675px'><input name='manufacturersCode' type='text' id='manufacturersCode' style='width:150px' value=''></td>
 	  </tr>  

	  <tr style='height:25px'>
    		<td class='formColHeader' style='width:150px; text-align:right;'>Bread/Cake Code:</td>
    		<td class='formBody' style='width:675px'>
      			<select name='breadCakeCode' id='breadCakeCode'>
        			<option value=0>No Code Specified</option>
					<option value=1>Bread</option>
        			<option value=2>Cake</option>
		      </select>
    		</td>
    </tr>  
	  <tr style='height:25px'>
    		<td class='formColHeader' style='width:150px; text-align:right;'>Private Label:</td>
    		<td class='formBody' style='width:675px'>
      			<select name='privateLabel' id='privateLable'>
					<option value=-1>Not Specified</option>
        			<option value=0>No</option>
        			<option value=1>Yes</option>
		      </select>
    		</td>
    </tr>  

	  <tr style='height:25px'>
    	<td class='formColHeader' style='width:150px; text-align:right;'>Product Classification Code:</td>
    	<td class='formBody' style='width:675px'><input name='prodClassCode' type='text' id='prodClassCode' style='width:75px' value='' onBlur=\"checkNumeric(this,'0','9999','','','');\"></td>
 	  </tr>  

	  <tr style='height:25px'>
    	<td class='formColHeader' style='width:150px; text-align:right;'>Label Weight:</td>
    	<td class='formBody' style='width:675px'><input name='labelWeight' type='text' id='labelWeight' style='width:75px' value='' onBlur=\"checkNumeric(this,0,5000,',','.','');\"></td>
 	  </tr>  

	  <tr style='height:25px'>
    	<td class='formColHeader' style='width:150px; text-align:right;'>Compressed UPC:</td>
    	<td class='formBody' style='width:675px'><input name='compressedUPC' type='text' id='compressedUPC' style='width:150px' value=''></td>
 	  </tr>  

	  <tr style='height:25px'>
    		<td class='formColHeader' style='width:150px; text-align:right;'>IBC Item:</td>
    		<td class='formBody' style='width:675px'>
      			<select name='ibcItem' id='ibcItem'>
					<option value=-1>Not Specified</option>
        			<option value=0>No</option>
        			<option value=1>Yes</option>
		      </select>
    		</td>
    </tr>  

	  <tr style='height:25px'>
    		<td class='formColHeader' style='width:150px; text-align:right;'>UDEX Category Code:</td>
    		<td class='formBody' style='width:675px'>
      			<select name='udexCategoryCode' id='udexCategoryCode'>
					<option value='0'>No Code Specified</option>
";
				while ($hashref = $sth1->fetchrow_hashref){
        			print "<option value='$hashref->{udexCategoryCode}'>$hashref->{udexCategoryName}</option>";
				}

print "  
		      </select>
    		</td>
    </tr>  

	  <tr style='height:25px'>
    	<td class='formColHeader' style='width:150px; text-align:right;'>Show Tray, Case & Pallet:</td>
    	<td class='formBody' style='width:675px'><input name='showTrayCasePallet' type='checkbox' value='1' id='showTrayCasePallet'></td>
 	  </tr>  

	  <tr style='height:25px'>
    	<td class='formColHeader' style='width:150px; text-align:right;'>Show Inactive Items:</td>
    	<td class='formBody' style='width:675px'><input name='showInactiveItems' type='checkbox' value='1' id='showInactiveItems'></td>
 	  </tr>  

		<tr>
        	<td class='formFooter' style='text-align:center' colspan=2>
				<input type='submit' value='Search' name='submit' class='formButton'>
			</td>
      	</tr>
</table>
</form>";
#end content

standard_footer();
#client side form checking
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