## How to test chaincode on native machine (Non -vagrant environment)

**Do you want to test on your chaincode on native machine ?**

This demonstrates for Linux Mahcine Ubuntu 16.04

#### Pre-requisites:
* Ensure you have installed Docker engine/machine on your native machine.

* To build the native binaries, you would need to install some platform dependent tools For example on Ubuntu mahcine I install 
**libltdl-dev**
```
sudo apt-get install libltdl-dev
```

* Build the native binaries **peer** and **orderer** with make command
```
cd $GOPATH/src/github.com/hyperledger/fabric

make peer orderer
```

### Terminal window Tab 1: 

**Start the orderer**

`./build/bin/orderer`

### Terminal window Tab 2: 

**Start the peer**

Create a directory for ledger 
`mkdir -p hyperledger/production`

```
CORE_PEER_FILESYSTEMPATH=hyperledger/production ./build/bin/peer node start -o 127.0.0.1:7050
```

### Terminal window Tab 2: 
Sample chaincode [example02](https://github.com/hyperledger/fabric/tree/master/examples/chaincode/go/chaincode_example02) 
**Install chaincode on the peer**

`
./build/bin/peer chaincode install -o 127.0.0.1:7050 -n mycc -v 1.0 -p github.com/hyperledger/fabric/examples/chaincode/go/chaincode_example02`

**NOTE**: If there are any issues with chaincode installation , please check [troubleshoot](https://github.com/asararatnakar/fabric_v1_Chaincode_instructions/blob/master/README.md#troubleshoot)

**Instantiate chaincode**

`
./build/bin/peer chaincode instantiate -o 127.0.0.1:7050 -n mycc -v 1.0 -p github.com/hyperledger/fabric/examples/chaincode/go/chaincode_example02 -c '{"Args":["init","a", "100", "b","200"]}'
`

After succesful chaincode instantiation, you would see chaincode container comes up
```
CONTAINER ID        IMAGE                COMMAND                  CREATED             STATUS              PORTS               NAMES
c74a34f846f9     dev-jdoe-mycc-1.0    "chaincode -peer.a..."   1 second ago        Up 1 second       dev-jdoe-mycc-1.0
```

**Invoke**

Issue an invoke to move "10" from "a" to "b":

 `./build/bin/peer chaincode invoke -o 127.0.0.1:7050 -n mycc -c '{"Args":["invoke","a","b","10"]}'`

Wait a few seconds for the operation to complete


**Query**

Query for the value of **"a"**

`./build/bin/peer chaincode query -o 127.0.0.1:7050 -n mycc -c '{"Args":["query","a"]}'`
