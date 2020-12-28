Param(
	[Parameter()]
	[String]
	$bucket = ".*"
)

scoop export | Select-String ("\[" + $bucket + "\]$") | % { $_ -Replace " .+$", "" }
