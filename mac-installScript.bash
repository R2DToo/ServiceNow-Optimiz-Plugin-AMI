#!/bin/bash
grafanaDir=$(echo $HOME)"/grafana"
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



if [ "$installGrafana" == "y" ] || [ "$installGrafana" == "Y" ]
then
        echo "What version of Grafana do you want to install? The default option is 8.2.2"
        read grafanaVersion
        grafanaVersion=${grafanaVersion:-8.2.2}
        echo "Installing Grafana to $grafanaDir/grafana-$grafanaVersion"
        mkdir -p $grafanaDir
        curl -O https://dl.grafana.com/oss/release/grafana-$grafanaVersion.darwin-amd64.tar.gz
        tar -zxvf grafana-$grafanaVersion.darwin-amd64.tar.gz
        rm -rf grafana-$grafanaVersion.darwin-amd64.tar.gz
        mv grafana-$grafanaVersion $grafanaDir/
        grafanaDir=$grafanaDir/grafana-$grafanaVersion
        mkdir -p $grafanaDir/data/plugins
        cp -R novatec-sdg-panel $grafanaDir/data/plugins/
        cp -R servicenow-optimiz-plugin $grafanaDir/data/plugins/
        echo "allow_loading_unsigned_plugins = servicenow-optimiz-plugin, novatec-sdg-panel" >> $grafanaDir/conf/defaults.ini
        mkdir -p $grafanaDir/conf/provisioning/dashboards/SNOWdashboards
        cp dashboards/mac-SNOWdashboards.yaml $grafanaDir/conf/provisioning/dashboards/
        echo "      path: $grafanaDir/conf/provisioning/dashboards/SNOWdashboards" >> $grafanaDir/conf/provisioning/dashboards/mac-SNOWdashboards.yaml
        cp -R dashboards/* $grafanaDir/conf/provisioning/dashboards/SNOWdashboards/
        echo "Restarting Grafana"
        $grafanaDir/bin/grafana-server web
else
        echo "What version of Grafana are you using? The default option is 8.2.2"
        read grafanaVersion
        grafanaVersion=${grafanaVersion:-8.2.2}\
        grafanaDir=$grafanaDir/grafana-$grafanaVersion
        mkdir -p $grafanaDir/data/plugins
        rm -rf $grafanaDir/data/plugins/novatec-sdg-panel
        cp -R novatec-sdg-panel $grafanaDir/data/plugins/
        rm -rf $grafanaDir/data/plugins/servicenow-optimiz-plugin
        cp -R servicenow-optimiz-plugin $grafanaDir/data/plugins/
        rm -rf $grafanaDir/conf/provisioning/dashboards/SNOWdashboards
        mkdir -p $grafanaDir/conf/provisioning/dashboards/SNOWdashboards
        rm -f $grafanaDir/conf/provisioning/dashboards/mac-SNOWdashboards.yaml
        cp dashboards/mac-SNOWdashboards.yaml $grafanaDir/conf/provisioning/dashboards/
        cp -R dashboards/* $grafanaDir/conf/provisioning/dashboards/SNOWdashboards/
        echo "Restarting Grafana"
        $grafanaDir/bin/grafana-server web
fi
