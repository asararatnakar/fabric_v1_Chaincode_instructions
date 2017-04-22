# How to set Loglevel on Peer container

### suppress certain log modules within the peer docker containers
1. connect to the CLI container

     `docker exec -it cli bash`
2. run the **setlevel** command with the **CORE_PEER_ADDRESS** environment variable provided to specify which peer you'd like to run the command against and the module name you would like to update: 

      **CORE_PEER_ADDRESS=IP:PORT peer logging setlevel <modeule-name> <log-level>**

for example,
```
CORE_PEER_ADDRESS=peer1:7051 peer logging setlevel gossip/discovery#peer1:7051 warning
```

At the time of this writing I used the below commands to suppress GOSSIP log module

```
peer logging setlevel gossip/comm#-1 error

peer logging setlevel cauthdsl error

peer logging setlevel peer/gossip/mcs error

peer logging setlevel gossip/discovery#peer0:7051 error

peer logging setlevel gossip/pull#peer0:7051 error

peer logging setlevel gossip/gossip#peer0:7051 error

peer logging setlevel gossip/election error
```
