:: Name:     turbo_gdal_overviews.bat
:: Purpose:  Criar overviews com gdal de forma paralela, usando gdal_translate
:: Author:   dncarreira@gmail.com
:: Repo:     https://github.com/dncpax/Turbo_GDAL_Overviews
:: Revision: March 2020 - initial version

@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION

if [%1]==[] goto usage
if [%2]==[] goto usage
if [%3]==[] goto usage
if [%4]==[] goto usage
if NOT [%5]==[] goto usage

DIR %1 >NUL 2>&1 || (ECHO ERRO - ficheiro não encontrado "%1" && EXIT /B 1)


echo Inicio em: %TIME%

rem validar resolução é numérica
SET "var="&for /f "delims=0123456789." %%i in ("%2") do set var=%%i
if defined var (goto erroResolucao) 
SET "var="&for /f "delims=0123456789." %%i in ("%3") do set var=%%i
if defined var (goto erroResolucao) 
SET "var="&for /f "delims=0123456789." %%i in ("%4") do set var=%%i
if defined var (goto erroResolucao) 

rem fazemos 3 resamples, mais 1 gdaladdo
rem iniciar os resamples mais rápidos em background, e deixar só o 1º em foreground
rem o resample mais grosseiro é seguido de um gdaladdo
start /b cmd /c "gdal_translate -of gtiff -tr %4 %4 -r average --config GDAL_CACHEMAX 1024 -co photometric=ycbcr -co interleave=pixel -co tiled=yes -co compress=jpeg %1 %1.ovr.ovr.ovr && gdaladdo -r average -ro --config COMPRESS_OVERVIEW JPEG --config PHOTOMETRIC_OVERVIEW YCBCR --config INTERLEAVE_OVERVIEW PIXEL %1.ovr.ovr.ovr"
start /b cmd /c "gdal_translate -of gtiff -tr %3 %3 -r average --config GDAL_CACHEMAX 1024 -co photometric=ycbcr -co interleave=pixel -co tiled=yes -co compress=jpeg %1 %1.ovr.ovr"

rem resample do 1º nível em foreground
gdal_translate -of gtiff -tr %2 %2 -r average --config GDAL_CACHEMAX 1024 -co photometric=ycbcr -co interleave=pixel -co tiled=yes -co compress=jpeg %1 %1.ovr

rem se existe máscara, é necessário fazer um conjunto de renomeações para que seja utilizável
if exist %1.ovr.ovr.ovr.msk.ovr (ren %1.ovr.ovr.ovr.msk.ovr %1.msk.ovr.ovr.ovr.ovr)
if exist %1.ovr.ovr.ovr.msk (ren %1.ovr.ovr.ovr.msk %1.msk.ovr.ovr.ovr)
if exist %1.ovr.ovr.msk (ren %1.ovr.ovr.msk %1.msk.ovr.ovr)
if exist %1.ovr.msk (ren %1.ovr.msk %1.msk.ovr)

echo Fim em: %TIME%
goto :eof

:usage
@echo Sintaxe: %0 Raster.ext resolucao_numericax2 resolucao_numericax4 resolucao_numericax8
@echo NOTAS:
@echo    - o cmd só faz aritmética inteira, por isso é necessário indicar 3 resoluções de resample - original x2, x4 e x8)
@echo    - resoluções devem ser numéricas, e o GDAL só suporta o ponto como separador decimal.
@echo EXEMPLO: raster com resolução 0.3m/pixel -- %0 0.6 1.2 2.4
exit /B 1
:erroResolucao
echo %2 %3 %4 Resoluções devem ser numéricas, e o GDAL só suporta o ponto como separador decimal.
exit /B 1
