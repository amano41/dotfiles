Write-Host "Configuring Privacy Settings..."


try {
	Get-Command -Name "Set-Registry" -ErrorAction Stop | Out-Null
}
catch {
	. (Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) "registry-helper.ps1")
}


####################  設定 → プライバシー → Windows のアクセス許可  ####################

## 広告識別子の使用をアプリに許可する
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" "Enabled" 0

## Windows 追跡アプリの起動を許可する　※個人用設定 → スタート → よく使うアプリ　と同じレジストリエントリ
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Start_TrackProgs" 0

## 設定アプリでおすすめのコンテンツを表示する
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-338393Enabled" 0
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-353694Enabled" 0
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-353696Enabled" 0

## 音声認識
Set-Registry "HKCU:\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy" "HasAccepted" 0

## 手描き入力
Set-Registry "HKCU:\Software\Microsoft\Personalization\Settings" "AcceptedPrivacyPolicy" 0

## フィードバックの間隔
Set-Registry "HKCU:\Software\Microsoft\Siuf\Rules" "PeriodInNanoSeconds" 0
Set-Registry "HKCU:\Software\Microsoft\Siuf\Rules" "NumberOfSIUFInPeriod" 0


####################  設定 → プライバシー → アプリのアクセス許可  ####################

## 位置情報
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" "Value" "Deny"
Set-Registry "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Sensor\Permissions\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" "SensorPermissionState" 0

## カメラ
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{E5323777-F976-4f5b-9B55-B94699C46E44}" "Value" "Deny"

## マイク
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{2EEF81BE-33FA-4800-9670-1CD474972C3F}" "Value" "Deny"

## 通知
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{52079E78-A92B-413F-B213-E8FE35712E72}" "Value" "Deny"

## アカウント情報
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{C1D23ACC-752B-43E5-8448-8D0E519CD6D6}" "Value" "Deny"

## 連絡先
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{7D7E8402-7C54-4821-A34E-AEEFD62DED93}" "Value" "Deny"

## カレンダー
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{D89823BA-7180-4B81-B50C-7E471E6121A3}" "Value" "Deny"

## 通話履歴
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{8BC668CF-7728-45BD-93F8-CF2B3B41D7AB}" "Value" "Deny"

## メール
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{9231CB4C-BF57-4AF3-8C55-FDA7BFCC04C5}" "Value" "Deny"

## タスク
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{E390DF20-07DF-446D-B962-F5C953062741}" "Value" "Deny"

## メッセージング
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{992AFA70-6F47-4148-B3E9-3003349C1548}" "Value" "Deny"

## 無線
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{A8804298-2D5F-42E3-9531-9C8C39EB29CE}" "Value" "Deny"

## 他のデバイス（ペアリングされていないデバイスとの通信）
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\LooselyCoupled" "Value" "Deny"

## バックグラウンドアプリ（アプリのバックグランド実行）
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" "GlobalUserDisabled" 1

## アプリの診断
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{2297E4E2-5DBE-466D-A12B-0F8286F0D9CA}" "Value" "Deny"

## ドキュメント
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\documentsLibrary" "Value" "Deny"

## ピクチャ
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\picturesLibrary" "Value" "Deny"

## ビデオ
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\videosLibrary" "Value" "Deny"

## ファイルシステム
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\broadFileSystemAccess" "Value" "Deny"
