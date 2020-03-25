$body = ''
choco list -lo -r | % { $_ -split '\|' | select -first 1 } | % { $body += "`n`t<package id=""$_"" />" }
Set-Content packages.config "<?xml version=`"1.0`" encoding=`"utf-8`"?>`n<packages>$body`n</packages>"
