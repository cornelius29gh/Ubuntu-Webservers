# Ubuntu-Webservers
#Contains linux shells to deploy specific Apache and Apache-Tomcat Webservers for Ubuntu

#commands sudo su (or login as root) are recommended and you must give execute permissions to the shell created
#shell can be either created with vim in Ubuntu and the contents of it copy pasted or uploaded via ftp (ex: Winscp, filezilla) to your Ubuntu machine

#Does not work with Ubuntu created with Hypervisor VM (TO DO in the future)

#works with EC2 Ubuntu instances created in AWS
NOTE! - security group inbound rule needs to permit port communication on port 8080 (setting from AWS)

can be accesed in browser at 

Apache
http://<ip_of_ec2_instance>/
http://<host_machine_where_you_execute_scripts>/

Apache-Tomcat
http://<ip_of_ec2_instance>:8080/
http://<host_machine_where_you_execute_scripts>:8080/
