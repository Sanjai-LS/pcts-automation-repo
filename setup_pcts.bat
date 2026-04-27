@echo off
echo ===== PCTS Automation Setup Started =====

:: Step 1 - Check Git
where git >nul 2>nul
IF %ERRORLEVEL% NEQ 0 (
    echo Git is NOT installed. Please install Git manually first.
    pause
    exit
) ELSE (
    echo Git is already installed
)

:: Step 2 - Git Config
echo Configuring Git...

git config --global core.longpaths true
git config --global core.autocrlf false

set /p username=Enter your Gerrit username: 
set /p email=Enter your email: 

git config --global user.name "%username%"
git config --global user.email "%email%"

:: Step 3 - SSH Setup
echo Creating .ssh folder...

mkdir %USERPROFILE%\.ssh 2>nul

echo Host gerrit1.harman.com > %USERPROFILE%\.ssh\config
echo Port 29418 >> %USERPROFILE%\.ssh\config
echo User %username% >> %USERPROFILE%\.ssh\config

:: Step 4 - Generate SSH Key
echo Generating SSH key...

ssh-keygen -t rsa -b 4096 -C "%email%" -f %USERPROFILE%\.ssh\id_rsa -N ""

:: Step 5 - Start SSH Agent
echo Starting SSH agent...

powershell -Command "Start-Service ssh-agent"
ssh-add %USERPROFILE%\.ssh\id_rsa

:: Step 6 - Show Public Key
echo ===== COPY THIS SSH KEY TO GERRIT =====
type %USERPROFILE%\.ssh\id_rsa.pub

pause

:: Step 7 - Clone Repo (EDIT THIS)
echo Cloning repository...

git clone ssh://%username%@gerrit1.harman.com:29418/https://github.com/Sanjai-LS/pcts-automation-repo.git

echo ===== Setup Completed =====
pause