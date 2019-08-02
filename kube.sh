#!/bin/bash
cluster_name="two-node-cluster"  
zone_name="us-central1-b"
echo "please select one of the below choices
 		d   - For default Cluster
 		c   - For Custom Cluster
 		u   - For Updating the existing Cluster
		del - To delete a deployed cluster
 		q   - To quit
 "


while :
do
  read INPUT_STRING
  case $INPUT_STRING in
	d)
		echo "Setting up default cluster, your cluster will be setup in few minutes!"
		cd $HOME/working_project/poc_cluster
		gcloud deployment-manager deployments create default-cluster --config default-cluster.yaml
        	echo "------------------------------Summary of the deployment---------------------------------"
		gcloud deployment-manager deployments describe default-cluster
        	gcloud container clusters get-credentials default-cluster --zone $zone_name	#This will fetch the credentials for running the containers
		break
		;;

	c)
		echo "Setting up your custom cluster , cluster creation in process it will take few minutes!"
		cd $HOME/working_project/poc_cluster
		gcloud deployment-manager deployments create $cluster_name --config deploy.yaml
        	echo "------------------------------Summary of the deployment---------------------------------"
		gcloud deployment-manager deployments describe $cluster_name
        	gcloud container clusters get-credentials $cluster_name --zone $zone_name		#This will fetch the credentials for running the containers
		break
		;;

	u)
		echo "Cluster update in process, it will be ready in few minutes"
		echo "Below are the list of Deployments already present, please note down the deployed cluster you want to update"
		gcloud deployment-manager deployments list
		read -p "Please entre the name for this cluster deployment you want to update  : " update_cluster
		read -p "Please enter the yaml file required for executing/building  the cluster: " cluster_config_file
		gcloud deployment-manager deployments update $update_cluster --config $cluster_config_file
        	echo "------------------------------Summary of the deployment---------------------------------"
        	gcloud deployment-manager deployments describe $update_cluster
		break
		;;

	q)	echo "See you again , quitting the process now"
		break
	
		;;
	del)	echo "BE CAUTIOUS YOU ARE ABOUT TO DELETE A RUNNING CLUSTER!!!, IF YOU ARE SURE PLEASE PROCEED OR PRESS CRTL+C TO EXIT THIS PROCESS:  "
		gcloud deployment-manager deployments list
		read -p "Please enter the deployment name which you want to delete from the list mentioned above : " cleanup
		gcloud deployment-manager deployments delete $cleanup
		break
		;;


	*) 	echo "Unknown choice selected, Please select one of the choices as mentioned below :
		 		d - For default Cluster
 		 		c - For Custom Cluster
 		 		u - For Updating the existing Cluster
				del - To delete a deployed cluster
		 		q - To quit
				"
		;;
	
  esac
done

