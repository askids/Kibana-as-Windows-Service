# Kibana-as-Windows-Service
Script to install/upgrade Kibana as Windows Service using NSSM

Currently, Kibana for Windows does not have an inbuilt installer or an option to run it as windows service. Elastic provides Kibana for windows as a zip file which needs to be unzipped to a folder. To start Kibana, we need to run bin\Kibana.bat. Internally that runs the node.js server. This approach is fine for POCs, one of testing, where you would control and would start/kill Kibana as needed.

But when you need to run this as builtin process or in production, this is no longer an option. You have couple of other alternatives - one of them being to define a windows service manually using the "sc create" command. However, since Kibana.bat is not a true windows service executable, it does not respond like a windows service. When the windows service starts, it will throw an error that the service could not be started. But in reality, node.js would be running successfully and Kibana would be up! So unless you see the process list in task manager, then there is no way to know really know that Kibana process is running. The same challenge is presented, when you have to shutdown Kibana. Since the windows service would be in STOPPED status as service start was not successful in the first place, if order for you to stop the service, you will need to kill the node.js process.

The other alternative is to run it via task scheduler as task scheduler. This again poses similar challenge. When you stop the task, from the task library, node.js could still be running. So only way to stop it would be to kill the process. Neither of these options looks okay for a production box.

I came across NSSM - the Non-Sucking Service Manager (https://nssm.cc/) as a possible alternative. NSSM allows you to run any executable as a windows service and has many advantages over using the inbuilt SC command. So I created the script to install/upgrade Kibana using NSSM. This script has been tested on Windows 8.1. So if any corrections are needed to support other Windows OS variants, feel free to add on.

## Usage Instructions:

By default, if you dont give any input parameters, it will assume the version to be 5.5.2, along with some defaults for Install folder path, Log folder path, NSSM executable path(x64). It accepts the following parameters

- KIBANAVER
- KIBANALOGDIR
- KIBANAINSTALLDIR
- NSSMDIR

### Sample
- KIBANAVER#5.5.2
- KIBANALOGDIR#D:\MyLogs\Kibana
- KIBANAINSTALLDIR#"D:\Program Files\kibana-5.5.2-windows-x86"
- NSSMDIR#D:\apps\nssm-2.24\win64

### Sample:
When using all defaults, simply run in command prompt as admin.
KIBANAWS.BAT

### Using all custom values
KIBANAWS.bat KIBANAVER#5.5.2 KIBANALOGDIR#D:\MyLogs\Kibana KIBANAINSTALLDIR#"D:\Program Files\kibana-5.5.2-windows-x86" NSSMDIR#D:\apps\nssm-2.24\win64

Thanks to @LeeDr (https://github.com/LeeDr) for his suggestions to use NSSM.
