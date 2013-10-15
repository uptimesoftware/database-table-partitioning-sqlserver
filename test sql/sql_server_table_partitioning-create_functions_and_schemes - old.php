<?
$table_names = array("sample", "aggregate", "cpu", "disk", "esx3_workload", "fscap", "lpar_workload", "network", "nrm", "psinfo", "vxvol", "who", "int_data", "decimal_data", "string_data", "ranged_object_value");
$num_of_partitions = $_GET["partitions"];
$title = "up.time - SQL Server Dynamic Function/Scheme Generator for Table Partitioning";

// http://.../sql_server_table_partitioning-create_functions_and_schemes.php?partitions=12

// You should not have less than 4 partitions
if ($num_of_partitions < 4) {
	$num_of_partitions = 12;
}

// Date functions
function get_month($d) {
	return date("m", $d);
}
function get_year($d) {
	return date("Y", $d);
}
function add_months($cur_date, $months_to_add) {
	$cur_month = get_month($cur_date);
	$cur_year = get_year($cur_date);

	$cur_month += $months_to_add;
	while ($cur_month > 12) {
		$cur_month -= 12;
		$cur_year++;
	}
	while ($cur_month <= 0) {
		$cur_month += 12;
		$cur_year--;
	}
	return strtotime("$cur_year-$cur_month");
}
function sub_months($cur_date, $months_to_sub) {
	return add_months($cur_date, ($months_to_sub * -1));
}


/*
// Testing date functions :)
$cur_time = time();
print date("Y-m-d", $cur_time) . "<br>";
print "adding months: " . date("Y-m-d", add_months($cur_time, 20)) . "<br>";
print "subbing months: " . date("Y-m-d", sub_months($cur_time, 24)) . "<br>";
*/
?>

<html><head>
<title><? print $title; ?></title>
<link rel="stylesheet" type="text/css" href="http://support.uptimesoftware.com/styles/default/stylesheets/styles-1.3.css" />
</head><body>
<h2><? print $title; ?></h2>
Current Date/Time: <? print date("Y-m-d h:m:s", time()); ?><br>
Number of Partitions selected: <? print $num_of_partitions; ?><br><br>
<textarea cols='120' rows='40'>
USE [uptime]
GO

BEGIN TRANSACTION

<?
foreach ($table_names as $table)
{
?>
IF EXISTS (SELECT name FROM sys.PARTITION_SCHEMES WHERE name = 'scheme_<? print $table; ?>')
   DROP PARTITION SCHEME scheme_<? print $table; ?>

GO
IF EXISTS (SELECT name FROM SYS.PARTITION_FUNCTIONS WHERE name = 'function_<? print $table; ?>')
   DROP PARTITION FUNCTION function_<? print $table; ?>

GO

<?
}
print "\n\n";
foreach ($table_names as $table)
{
// The output should look like:
//CREATE PARTITION FUNCTION [function_sample](datetime OR date) AS RANGE RIGHT FOR VALUES (
?>
CREATE PARTITION FUNCTION [function_<? print $table; ?>](datetime) AS RANGE RIGHT FOR VALUES (<?
// The output should look like:
// N'2009-01-01', N'2009-02-01', N'2009-03-01', N'2009-04-01', N'2009-05-01', N'2009-06-01', N'2009-07-01', N'2009-08-01', N'2009-09-01', N'2009-10-01', N'2009-11-01', N'2009-12-01', N'2010-01-01'

// Setup the end partition to be 3 months ahead of the current month
$cur_time = time();
$first_date = sub_months(add_months($cur_time, 3), $num_of_partitions);
for ($i = 0; $i < $num_of_partitions; $i++) {
	if ($i > 0) {
		print ", ";
	}
	print "N'" . date("Y-m-d", add_months($first_date, $i)) . "'";
}
?>)
CREATE PARTITION SCHEME [scheme_<? print $table; ?>] AS PARTITION [function_<? print $table; ?>] ALL TO ([PRIMARY])

<?
}
?>
COMMIT TRANSACTION
</textarea>
</body></html>