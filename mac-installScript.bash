#!/bin/bash
which -s brew
if [[ $? != 0 ]]
then
    # Install Homebrew
    echo "Homebrew was now found on your system. Proceeding to install it for you..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "ITx Jedis - this may take a few minutes. Be patient and get your lightsabers ready ...."
    brew update -v
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
        echo "Installing Grafana"
        brew install grafana
        brew link grafana
        brew services start grafana
        mkdir -p /usr/local/Cellar/grafana/8.2.1/data/plugins
        cp -r novatec-sdg-panel /usr/local/Cellar/grafana/8.2.1/data/plugins/
        cp -r servicenow-optimiz-plugin /usr/local/Cellar/grafana/8.2.1/data/plugins/
        cp dashboards/mac-SNOWdashboards.yaml /usr/local/Cellar/grafana/8.2.1/conf/provisioning/dashboards/
        mkdir -p /usr/local/Cellar/grafana/8.2.1/conf/provisioning/dashboards/SNOWdashboards
        cp -r dashboards/* /usr/local/Cellar/grafana/8.2.1/conf/provisioning/dashboards/SNOWdashboards/
        echo "Restarting Grafana"
        brew services restart grafana
else
        mkdir -p /usr/local/Cellar/grafana/8.2.1/data/plugins
        rm -rf /usr/local/Cellar/grafana/8.2.1/data/plugins/novatec-sdg-panel
        cp -r novatec-sdg-panel /usr/local/Cellar/grafana/8.2.1/data/plugins/
        rm -rf /usr/local/Cellar/grafana/8.2.1/data/plugins/servicenow-optimiz-plugin
        cp -r servicenow-optimiz-plugin /usr/local/Cellar/grafana/8.2.1/data/plugins/
        rm -rf /usr/local/Cellar/grafana/8.2.1/conf/provisioning/dashboards/mac-SNOWdashboards.yaml
        cp dashboards/mac-SNOWdashboards.yaml /usr/local/Cellar/grafana/8.2.1/conf/provisioning/dashboards/
        rm -rf /usr/local/Cellar/grafana/8.2.1/conf/provisioning/dashboards/SNOWdashboards
        mkdir -p /usr/local/Cellar/grafana/8.2.1/conf/provisioning/dashboards/SNOWdashboards
        cp -r dashboards/* /usr/local/Cellar/grafana/8.2.1/conf/provisioning/dashboards/SNOWdashboards/
        echo "Restarting Grafana"
        brew services restart grafana
fi
grafanaDir=$(brew info grafana | grep /usr/local/)
echo $grafanaDir
