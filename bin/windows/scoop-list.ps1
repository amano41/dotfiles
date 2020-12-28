Param(
	[Parameter()]
	[String]
	$bucket = ".*"
)

scoop export | Select-String ("\[" + $bucket + "\]$") | ForEach-Object { $_ -Replace " .+$", "" }
