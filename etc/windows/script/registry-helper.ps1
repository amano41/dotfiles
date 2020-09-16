##################################################
##  レジストリ操作用のヘルパー関数
##################################################


## レジストリに書き込む
function Set-Registry($path, $key, $value) {
	if (!(Test-Path $path)) {
		New-Item -Path $path -Force | Out-Null
	}
	Set-ItemProperty -Path $path -Name $key -Value $value
}
