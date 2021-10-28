@echo off
:start
set currentDir=%~dp0
cd "%currentDir%"
echo Would you like to install Grafana on this system? (y)es or (n)o
set /p installGrafana=
if /I NOT %installGrafana% == y if /I NOT %installGrafana% == n GOTO:start

if /I %installGrafana% == y (goto:grafana) else (goto:plugin)

:grafana
echo Installing grafana and our plugins
echo What version of Grafana do you want to install? The default option is 8.2.2
set /p grafanaVersion=
IF NOT DEFINED grafanaVersion SET "grafanaVersion=8.2.2"

curl https://dl.grafana.com/oss/release/grafana-%grafanaVersion%.windows-amd64.msi --output grafana-%grafanaVersion%.msi
msiexec.exe /i grafana-%grafanaVersion%.msi /passive
set grafanaDir=C:\Program Files\GrafanaLabs\grafana
robocopy "novatec-sdg-panel" "%grafanaDir%\data\plugins\novatec-sdg-panel" /s
robocopy "servicenow-optimiz-plugin" "%grafanaDir%\data\plugins\servicenow-optimiz-plugin" /s
robocopy "dashboards" "%grafanaDir%\conf\provisioning\dashboards" "windows-SNOWdashboards.yaml"
mkdir "%grafanaDir%\conf\provisioning\dashboards\SNOWdashboards"
robocopy "dashboards" "%grafanaDir%\conf\provisioning\dashboards\SNOWdashboards" /s

powershell -Command "(gc '%grafanaDir%\conf\sample.ini') -replace ';allow_loading_unsigned_plugins =', 'allow_loading_unsigned_plugins = servicenow-optimiz-plugin,novatec-sdg-panel' | Out-File -encoding ASCII '%grafanaDir%\conf\custom.ini'"

sc stop grafana
timeout 3
sc start grafana
goto:end

:plugin
echo Installing plugins only
set grafanaDir=C:\Program Files\GrafanaLabs\grafana
robocopy "novatec-sdg-panel" "%grafanaDir%\data\plugins\novatec-sdg-panel" /s /purge
robocopy "servicenow-optimiz-plugin" "%grafanaDir%\data\plugins\servicenow-optimiz-plugin" /s /purge
robocopy "dashboards" "%grafanaDir%\conf\provisioning\dashboards" "windows-SNOWdashboards.yaml" /purge
rmdir "%grafanaDir%\conf\provisioning\dashboards\SNOWdashboards"
mkdir "%grafanaDir%\conf\provisioning\dashboards\SNOWdashboards"
robocopy "dashboards" "%grafanaDir%\conf\provisioning\dashboards\SNOWdashboards" /s /purge

powershell -Command "(gc '%grafanaDir%\conf\sample.ini') -replace ';allow_loading_unsigned_plugins =', 'allow_loading_unsigned_plugins = servicenow-optimiz-plugin,novatec-sdg-panel' | Out-File -encoding ASCII '%grafanaDir%\conf\custom.ini'"

sc stop grafana
timeout 3
sc start grafana
goto:end

:end
echo Process Complete!
PAUSE
