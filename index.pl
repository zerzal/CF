#!/afs/isis/pkg/perl/bin/perl
# Script by Dwayne Ayers
use warnings;
#use strict;
$cgiurl = "http://wohelp-dcayers.cloudapps.unc.edu";
$ver = "1.5";

# Get the input
########################
read(STDIN, $buffer, $ENV{'CONTENT_LENGTH'});

#if no form data go to system start
   if (!$buffer) { 
         &entry;
   }

# Split the name-value pairs
@pairs = split(/&/, $buffer);

foreach $pair (@pairs) {
   ($name, $value) = split(/=/, $pair);

# Un-Webify plus signs and %-encoding
   $value =~ tr/+/ /;
   $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
   $value =~ s/<!--(.|\n)*-->//g;

   $FORM{$name} = $value;  
}
#chomp $value;
$find = $value;

if ($FORM{'des'}) {
open FILE, "<PS.txt";
@lines = <FILE>;
&lookup;
}
if ($FORM{'bldg'}) {
open FILE, "<PP.txt";
@lines = <FILE>;
&bldg;
}
if ($FORM{'cfs'}) {
open FILE, "<CFS.txt";
@lines = <FILE>;
&cfs;
}
sub entry {
print "Content-type: text/html\n\n";
print "<html><head><title>LS WORK ORDER CREATION AID</title></head><body>\n";
print "<FONT SIZE = 5><b>LS WORK ORDER CREATION AID</b></FONT><FONT SIZE = 2 color = red>\&nbsp\;\&nbsp\;<b>$ver</b></font><br><font color = blue><i>Assets List Updated 5-26-2021</i></font><br><br><br>\n";
print "<form method=POST action=$cgiurl>\n";
print "<FONT SIZE = 5><b>Lookup Organization Number By Department Description</b></FONT><br><br>\n";
print "<i>Type Dept Discription\:\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;<input type=text name=des size=25>\n";
print " \&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;(example: \"Life Safety\" or \"Carpentry\")</i><br><br>\n";
print "<input type=submit> * <input type=reset></form><br>\n";
print "<br>\n";

print "<form method=POST action=$cgiurl>\n";
print "<FONT SIZE = 5><b>Lookup System Asset Numbers By Building</b></FONT><br><br>\n";
print "<i>Type Partial Building Name</i>\:\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;<input type=text name=bldg size=25>\n";
print "<br><br><input type=submit> * <input type=reset></form><br>\n";
print "</body></html>\n";
print "<br>\n";

print "<form method=POST action=$cgiurl>\n";
print "<FONT SIZE = 5><b>Lookup Chartfield String Info By Department Description</b></FONT><br><br>\n";
print "<i>Type Dept Discription</i>\:\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;<input type=text name=cfs size=25>\n";
print " \&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;(example: \"Life Safety\" or \"Carpentry\")</i><br><br>\n";
print "<input type=submit> * <input type=reset></form><br>\n";
print "<br><br><br>\n";


exit;
}
sub lookup {
print "Content-type: text/html\n\n";
print "<html><head><title>DESCRIPTION RESULT</title></head><body>\n";
print "<FONT SIZE = 6><b>RESULT</b></FONT><FONT SIZE = 4> <i>(New Dept Id in Bold)</i></FONT><BR><BR>\n";
for (@lines) {
    
	   ($ps, $descr, $long) = split (/,/,$_);
#print "$long<br>\n";
	 if ($long =~  m/$find/i) {  
	 print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;Short Description: <i>$descr</i><br>\n";
	 print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;Long Description: <i>$long</i><br>\n";
	 print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;Number to use: <b>$ps</b><br><br>\n";
	
    }
 }
}
 
 print "Return to the <a href=\"$cgiurl\">Entry Screen</a>.";
 print "</FONT>\n";
 print "</body></html>\n";
 exit;
 
 sub bldg {
print "Content-type: text/html\n\n";
print "<html><head><title>ASSET NUMBER RESULT</title></head><body>\n";
print "<FONT SIZE = 6><b>ASSET NUMBER(S)</b></FONT><FONT SIZE = 4> <i>(Asset number in Bold)</i></FONT><BR><BR>\n";
for (@lines) {    
	($bno, $building, $shop, $group, $asset, $adesc, $loc, $make, $model) = split (/,/,$_);
	 if ($building =~  m/$find/i) {  
	 print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;Building Number: <i>$bno</i><br>\n";
	 print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;Building: <i>$building</i><br>\n";
	 print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;Asset Number: <b>$asset</b><br>\n";
	 print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;Shop: $shop<br>\n";
	 print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;Asset: $group - <b>$adesc</b><br>\n";
	 print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;Location: $loc<br>\n";
	 print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;Make\/Model: $make - $model<br><br>\n";	 
	 }
 }
 print "<br>Return to the <a href=\"$cgiurl\">Entry Screen</a>.\n";
 print "<br><br></body></html>\n";
 exit;
}
sub cfs {
print "Content-type: text/html\n\n";
print "<html><head><title>CHARTFIELD STRING RESULT</title></head><body>\n";
print "<FONT SIZE = 5><b>CHARTFIELD STRING RESULT</b></FONT><BR><BR>\n";
for (@lines) {    
	($cfrs, $cbu, $cfund, $cdept, $cclass, $cpid, $cpcbu, $cact, $cpro, $ccc1, $ccc2, $ccc3, $cdes1, $cdes2) = split (/,/,$_);
	 if ($cdes1 =~  m/$find/i) {  
	 print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;Description-1: <b>$cdes1</b><br>\n";
	 print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;Description-2: $cdes2<br>\n";
	 print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;Old FRS: $cfrs<br>\n";
	 print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;Business Unit: $cbu<br>\n";
	 print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;Fund Code: $cfund<br>\n";
	 print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;Dept ID: $cdept<br>\n";
	 print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;Class: $cclass<br>\n";
	 print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;Project ID: $cpid<br>\n";
	 print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;PCBU: $cpcbu<br>\n";
	 print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;Activity: $cact<br>\n";
	 print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;Program: $cpro<br>\n";
	 print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;CC1: $ccc1<br>\n";
	 print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;CC2: $ccc2<br>\n";
	 print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;CC3: $ccc3<br>\n";
	 print "<br>\n";
	 }
 }
 print "<br>Return to the <a href=\"$cgiurl\">Entry Screen</a>.\n";
 print "<br><br></body></html>\n";
 exit;
}





	
