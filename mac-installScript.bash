#!/bin/bash
which -s brew
if [[ $? != 0 ]]
then
    # Install Homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    brew update
fi

installGrafana="blank"
while [ "$installGrafana" != "n" ] && [ "$installGrafana" != "y" ] && [ "$installGrafana" != "N" ] && [ "$installGrafana" != "Y" ]
do
    if [ "$installGrafana" != "blank" ]
    then
        echo $installGrafana was not a valid option
    fi
    echo Would you like to install Grafana on this system? \(y\)es or \(n\)o
    read installGrafana
done

if [ "$installGrafana" == "y" ] || ["$installGrafana" == "Y"]
then
	brew install grafana@8.2.1
	brew services start grafana
	mkdir -p /usr/local/Cellar/grafana/8.2.1/data/plugins
	mv novatec-sdg-panel /usr/local/Cellar/grafana/8.2.1/data/plugins/novatec-sdg-panel
	mv servicenow-optimiz-plugin /usr/local/Cellar/grafana/8.2.1/data/plugins/servicenow-optimiz-plugin
	mv dashboards/mac-SNOWdashboards.yaml /usr/local/Cellar/grafana/8.2.1/conf/provisioning/dashboards/mac-SNOWdashboards.yaml
	mkdir -p /usr/local/Cellar/grafana/8.2.1/conf/provisioning/dashboards/SNOWdashboards
	mv dashboards/* /usr/local/Cellar/grafana/8.2.1/conf/provisioning/dashboards/SNOWdashboards/
	brew services restart grafana
else
	mkdir -p /usr/local/Cellar/grafana/8.2.1/data/plugins
	rm -rf /usr/local/Cellar/grafana/8.2.1/data/plugins/novatec-sdg-panel
	mv novatec-sdg-panel /usr/local/Cellar/grafana/8.2.1/data/plugins/novatec-sdg-panel
	rm -rf /usr/local/Cellar/grafana/8.2.1/data/plugins/servicenow-optimiz-plugin
	mv servicenow-optimiz-plugin /usr/local/Cellar/grafana/8.2.1/data/plugins/servicenow-optimiz-plugin
	rm -rf /usr/local/Cellar/grafana/8.2.1/conf/provisioning/dashboards/mac-SNOWdashboards.yaml
	mv dashboards/mac-SNOWdashboards.yaml /usr/local/Cellar/grafana/8.2.1/conf/provisioning/dashboards/mac-SNOWdashboards.yaml
	rm -rf /usr/local/Cellar/grafana/8.2.1/conf/provisioning/dashboards/SNOWdashboards
	mkdir -p /usr/local/Cellar/grafana/8.2.1/conf/provisioning/dashboards/SNOWdashboards
	mv dashboards/* /usr/local/Cellar/grafana/8.2.1/conf/provisioning/dashboards/SNOWdashboards/
	brew services restart grafana
fi