#!c:/perl/bin/perl.exe
use DBI;
use CGI::Carp qw(fatalsToBrowser);
use CGI;
use Switch;

sub getInput {
  %form = $query->Vars;
}

sub performUpdate {
  my $name = $dbh->quote($form{name});

  my $sql = "update productCategory set ";
  $sql .= "prodCategoryName = $name, fromClassCode = $form{fromClassCode}, toClassCode = $form{toClassCode}, breadCakeCode = $form{bc}, changedBy = $userID, changedOn = NOW() ";
  $sql .= "where prodCategoryID = $form{catID} ";

  $dbh->do($sql);
}

sub performInsert {
  my $name = $dbh->quote($form{name});

  my $sql = "insert into productCategory (prodCategoryName, fromClassCode, toClassCode, breadCakeCode, changedBy, changedOn) ";
  $sql .= " values ($name, $form{fromClassCode}, $form{toClassCode}, $form{bc}, $userID, NOW()) ";
  
  $dbh->do($sql);
}

sub validateEntry {
###########################
# Possible Errors....
#  1 = All Fields Required
#  2 = Class Code Overlap (not implemented yet)
#  3 = From Class Code not Numeric 
#  4 = To Class Code not Numeric 
###########################
# SELECT * FROM ecommerce.productcategory p where (120 <= fromClassCode and 300 >= fromClassCode) or (120 <= toClassCode and 120 >=fromClassCode)

	my $retErr = 0;
	
  if (!$form{name}) {
  	$retErr = 1;
  }
  if (!$form{fromClassCode}) {
  	$retErr = 1;
  }
  if (!$form{toClassCode}) {
  	$retErr = 1;
  }
  
  if (!$retErr) {
  	if (!($form{fromClassCode} =~ m/^[0-9]+$/)) {
  		$retErr = 3;
  	}
  }

  if (!$retErr) {
  	if (!($form{toClassCode} =~ m/^[0-9]+$/)) {
  		$retErr = 4;
  	}
  }

  return $retErr;
}

sub handleEntry {
	my $err = (validateEntry());

  if ($err) {
  	my $msg;
  	if ($err == 1) {
  		$msg = 'Please fill in all Required Fields'; 
  	} elsif ($err == 3) {
  		$msg = 'From Class Code can only contain numeric digits';
  	} elsif ($err == 4) {
  		$msg = 'To Class Code can only contain numeric digits';
  	}
   	display_message("<b>$msg</b>", "#FF0000", 1, 900);
  	if ($form{act} eq "INS") {
     	$form{act} = "ADD";
    } else {
    	$form{act} = "EDT";
    }
  } else {
  	if ($form{act} eq "INS") {
  	  performInsert();
     	display_message("Product Category was Added Successfully", "#0000FF", 3, 900);
     	undef %form;
     	$form{act} = "ADD";	 
  	} else {
  		performUpdate();
     	display_message("Product Category was Updated Successfully", "#0000FF", 3, 900);
     	$scatID = $form{catID};
     	undef %form;
     	$form{act} = "EDT";	 
     	$form{catID} = $scatID;
  	}
  }
}

###########################################
# ADD and Edit Entry                     #
#########################################
sub displayForm {

  my $nAct;
  my $fTitle;
  
  if ($form{act} eq 'EDT') {
  	$nAct = 'UPD';
  	$fTitle = 'Edit Product Category';
  } else {
  	$nAct = 'INS';
  	$fTitle = 'Add New Product Category';
  }

	print "<form name='editUser' action='/cgi-bin/itemcat/addeditcat.pl' method='post'>
         <input type=hidden name=act value='$nAct'>
         <input type=hidden name=catID value='$form{catID}'>
         <input type=hidden name=lDate value='$form{lDate}'>
         <input type=hidden name=lTime value='$form{lTime}'>
         <input type=hidden name=lUser value='$form{lUser}'>
        ";

	print"  <table class='formTable' style='width:900'>
      <tr>
        <td class='formHeader' style='text-align:Left'> $fTitle </td>
        <td class='formHeader' style='text-align:right'>
           <a href='/cgi-bin/itemcat/listcat.pl' class='lnkButton'>Return List Categories</a>
        </td>
      </tr>";
      
  print "  <tr style='height:25px'>
    <td class='formColHeader' style='width:150px; text-align:right;'>
      Category Name:
    </td>
    <td class='formBody' style='width:675px'>
      <input type='text' name='name' style='width:200px' value='$form{name}'>
    </td>
  </tr>";

  print "  <tr style='height:25px'>
    <td class='formColHeader' style='width:150px; text-align:right;'>
      From Prod Class Code:
    </td>
    <td class='formBody' style='width:675px'>
      <input type='text' name='fromClassCode' style='width:50px' value='$form{fromClassCode}' maxlength='4'>
    </td>
  </tr>";

  print "  <tr style='height:25px'>
    <td class='formColHeader' style='width:150px; text-align:right;'>
      To Prod Class Code:
    </td>
    <td class='formBody' style='width:675px'>
      <input type='text' name='toClassCode' style='width:50px' value='$form{toClassCode}' maxlength='4'>
    </td>
  </tr>";

  print "  <tr style='height:25px'>
    <td class='formColHeader' style='width:150px; text-align:right;'>
      Bread/Cake Code:
    </td>
    <td class='formBody' style='width:675px'>
      <select name='bc' style='width:100px'>";
      
  if ($form{bc} == 2) {
  	print "<option value='1'>Bread <option value='2' selected>Cake";
  } else {
  	print "<option value='1' selected>Bread <option value='2'>Cake";
  }
  
  print "</select>
    </td>
  </tr>";

  if ($form{act} eq 'EDT') {
    print "  <tr style='height:25px'>
      <td class='formColHeader' style='width:150px; text-align:right;'>
        Last Update:
      </td>
      <td class='formBody' style='width:675px'>
         $form{lUser} on $form{lDate} at $form{lTime}
      </td>
    </tr>";
  }
  
  print "<tr>
        <td class='formFooter' style='text-align:center' colspan=2> ";
  
  if ($form{act} eq 'ADD') {
    print "<input type='submit' value='Add Category' name='save' class='formButton'>";
  } else {
    print "<input type='submit' value='Update Category' name='save' class='formButton'>";
  }
  print "&nbsp;<input type='submit' value='Cancel' name='cancel' class='formButton'>
        </td>
      </tr>
    </table>";
}

sub getData {
# if there is a value in $form{save} then this is a redisplay either with an error or sucessful update
# so I don't want to read the database so the users entered values are redisplayed
	if (!$form{save}) {
    # if it is the first time through here then grab the database entry and move the values to the
    # fields used in the form
  	$sql = "select prodCategoryName, fromClassCode, toClassCode, breadCakeCode, changedBy, changedOn ";
  	$sql .= "from productcategory ";
  	$sql .= "where prodCategoryID = $form{catID} ";
  	
  	my $sth = $dbh->prepare($sql);
  	$sth->execute();
  	
  	($form{name}, $form{fromClassCode}, $form{toClassCode}, $form{bc}, $lUser, $lDate) = $sth->fetchrow_array;
  	$form{lUser} = ml_userName($lUser, "FL");
  	$form{lTime} = substr($lDate,11,8);
  	$form{lDate} = substr($lDate,0,10);
  	$sth->finish;
  }
	
	displayForm();
}


#############################################################################
#                 Script Main                                               #
#############################################################################

require("c:/inetpub/cgi-bin/common/stand.pl");
require("c:/inetpub/cgi-bin/common/database.cfg");
require("c:/inetpub/cgi-bin/common/html_select.pl");
require("c:/inetpub/cgi-bin/common/misc.pl");
require('c:/inetpub/cgi-bin/common/cookie.pl');
require('c:/inetpub/cgi-bin/common/master_lookup.pl');

require("c:/inetpub/cgi-bin/itemcat/itemcat.cfg");

$dbh = DBI->connect ($dsn, $duser, $dpass, { RaiseError => 1});

$userID = auth_logged_in();

$query = new CGI;

getInput();

print $query->header('text/html');

standard_header();

# Possible values for the "act" variable are
#    ADD = Display form to add a new entry 
#    EDT = Display form to edie an existing entry
#    UPD = Upadte entry with values entered by user (from edit)
#    INS = Insert new entry with values from user (from add)

if ($form{cancel}) { # Cancel Button Pressed
	if ($form{act} eq 'INS') {
     	undef %form;
     	$form{act} = "ADD";	 
  } else {
     	$scatID = $form{catID};
     	undef %form;
     	$form{act} = "EDT";	 
     	$form{catID} = $scatID;
  }
} else {
  if ($form{act} eq "INS" || $form{act} eq "UPD") { # Insert or Update user....
	  handleEntry();
	}
}

# the reason for the seperate if's in a row is becuase the INS and UPD 
# functions reset the "act" variable to determine what to display after 
# the database routines complete
if ($form{act} eq 'ADD') {
	displayForm();
} elsif ($form{act} eq 'EDT') {
	getData();
}
	
standard_footer();

$dbh->disconnect;

exit;
