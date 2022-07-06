# proxmox-adoring_galileo
Proxmox related concepts

## proxmox-drs-bash

Provides VM Resource Scheduler. Global available score are available on CephFS in the cluster based on:
* Load Average
* Memory utilization

Generic flow of events:
* At both VM placement and migration, the host with the best fit (lowest score) receives another VM
* Last used host gets removed from the list of candidates until next scoring round

* Scores are updates every minute ( IDEA: Increase update freqency to seconds? )
