@echo off

cd /d %~dp0

setlocal

choco upgrade all --except="'git.install,git'" -y
choco upgrade git.install git --parameters="'/GitOnlyOnPath /NoAutoCrlf /NoShellIntegration'" -y
