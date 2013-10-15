<?php

error_reporting(E_ALL ^ E_NOTICE);

// /tools/partitioning-sql-generator.php?partitions=12

########################################################
## set vars
########################################################
    $table_names = array("sample", "aggregate", "cpu", "disk", "disk_total", "esx3_workload", "fscap", "lpar_workload", "network", "nrm", "psinfo", "vxvol", "who", "int_data", "decimal_data", "string_data", "ranged_object_value");
	if (isset($_GET["partitions"])) {
		$num_of_partitions = $_GET["partitions"];
		// should not have less than 2 partitions
		if ($num_of_partitions < 2) {
			$num_of_partitions = 12;
		}
	}
	else {
		$num_of_partitions = 12;
	}
    $title = "up.time - SQL Server Function/Scheme Generator for Table Partitioning";


########################################################
## build the string of values for the partition stmts 
########################################################
    $startOffset = $num_of_partitions - 3;
    $firstDate = strtotime(date("Y-m") . "-01 $startOffset months ago"); 

    $values = array();
    for ($i=0; $i<$num_of_partitions; $i++) {
        $newStamp = strtotime(date("Y-m-d", $firstDate) . " $i months");
        $values[] = "N'" . date("Y-m-d", $newStamp) . "'";
    }
    $valuesString = join(", ", $values);

?><html><head>
<title><?php echo $title; ?></title>
<link rel="stylesheet" type="text/css" href="/styles/default/stylesheets/styles-1.3.css" />
</head>

<body>

<h2><?php print $title; ?></h2>

<p>
Current Date/Time: <?php print date("Y-m-d h:m:s", time()); ?><br />
Number of Partitions selected: <?php print $num_of_partitions; ?><br /><br />
Change number of partitions: <form>
<select name='partitions'>
<?php
$selected = '';
for ($i=2; $i <= 36; $i++) {
	if ($i == $num_of_partitions) {
		$selected = ' selected';
	}
	echo "<option{$selected}>{$i}</option>\n";
	$selected = '';
}
?>
</select>
<input type='submit' value='Update'></form>
</p>

<textarea cols='120' rows='40'>
USE [uptime]
GO

BEGIN TRANSACTION

<?php foreach ($table_names as $table) { ?>
IF EXISTS (SELECT name FROM sys.PARTITION_SCHEMES WHERE name = 'scheme_<?php print $table; ?>')
   DROP PARTITION SCHEME scheme_<?php print $table; ?>

GO
IF EXISTS (SELECT name FROM SYS.PARTITION_FUNCTIONS WHERE name = 'function_<?php print $table; ?>')
   DROP PARTITION FUNCTION function_<?php print $table; ?>

GO


<?php } ?>
<?php foreach ($table_names as $table) { ?>
CREATE PARTITION FUNCTION [function_<?php print $table; ?>](datetime) AS RANGE RIGHT FOR VALUES (<?php echo $valuesString; ?>)
CREATE PARTITION SCHEME [scheme_<?php print $table; ?>] AS PARTITION [function_<?php print $table; ?>] ALL TO ([PRIMARY])

<?php 
}
?>
COMMIT TRANSACTION
</textarea>
</body></html>
