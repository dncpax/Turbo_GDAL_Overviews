:: Purpose:  Cronometrar comandos DOS.
:: Author:   dncarreira@gmail.com
:: Repo:     https://github.com/dncpax/Turbo_GDAL_Overviews
:: Usage:    timing "comando par1 par2 blabla"
@echo off
setlocal EnableDelayedExpansion
echo %TIME%
echo a executar o comando indicado: %1
cmd /c %1
echo %TIME%