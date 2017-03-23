# How to test Fabric V1.0 Chaincode 

#### How to test your chaincode from Vagrant :
You wrote some chaincode on Fabric V1.0 and wanted to test the same on default channel with out any hassles ?

Probably you are on the right page and following commands might help you  :)

```
git clone https://github.com/hyperledger/fabric.git 
```

This has been verified as of fabric commit level **0ef35105**

```
cd fabric/devenv

vagrant up && vagrant ssh

cd $GOPATH/src/github.com/hyperledger/fabric
make native
```

### Vagrant Terminal Tab 1: 

**Start the Orderer**

`orderer`

### Vagrant Terminal Tab 2: 

**Start the peer**

`peer node start -o 127.0.0.1:7050`

### Vagrant Terminal Tab 3:

#### Execution 1 : Sample chaincode [example02](https://github.com/hyperledger/fabric/tree/master/examples/chaincode/go/chaincode_example02)
**Install chaincode on the peer**

`
peer chaincode install -o 127.0.0.1:7050 -n mycc -v 1.0 -p github.com/hyperledger/fabric/examples/chaincode/go/chaincode_example02`

**NOTE**: If there are any issues with chaincode installation , please check [troubleshoot](https://github.com/asararatnakar/V1_Chaincode/blob/master/README.md#trooubleshoot)

**Instantiate chaincode**

`
peer chaincode instantiate -o 127.0.0.1:7050 -n mycc -v 1.0 -p github.com/hyperledger/fabric/examples/chaincode/go/chaincode_example02 -c '{"Args":["init","a", "100", "b","200"]}'
`

After succesful chaincode instantiation, you would see chaincode container comes up
```
CONTAINER ID        IMAGE                COMMAND                  CREATED             STATUS              PORTS               NAMES
c74a34f846f9     dev-jdoe-mycc-1.0    "chaincode -peer.a..."   1 second ago        Up 1 second       dev-jdoe-mycc-1.0
```

**Invoke**

Issue an invoke to move "10" from "a" to "b":

 `peer chaincode invoke -o 127.0.0.1:7050 -n mycc -c '{"Args":["invoke","a","b","10"]}'`

Wait a few seconds for the operation to complete


**Query**

Query for the value of **"a"**

`peer chaincode query -o 127.0.0.1:7050 -n mycc -c '{"Args":["query","a"]}'`

#### cleanup
Don't forget to clear ledger after each run!
```
rm -rf /var/hyperledger/*
```
And may be chaincode containers(*optional*)

```
docker rm -f $(docker ps -aq)

docker rmi -f $(docker images | grep "dev-jdoe" | awk '{print $3}')
```

#### Troubleshoot

* Are you seeing **Illegal file mode detected** error ? 

  That means chaincode executable been left after building your chaincode with **go build**.You must consider deleting that file or revoke any executable permission for those files under GOPATH

```
peer chaincode install -o 127.0.0.1:7050 -n mycc1 -v 1 -p github.com/hyperledger/fabric/examples/chaincode/go/chaincode_example02
2017-03-23 04:14:23.729 UTC [golang-platform] writeGopathSrc -> INFO 001 rootDirectory = /opt/gopath/src
2017-03-23 04:14:23.729 UTC [container] WriteFolderToTarPackage -> INFO 002 rootDirectory = /opt/gopath/src

Error: Error endorsing chaincode: rpc error: code = 2 desc = Illegal file mode detected for file src/github.com/hyperledger/fabric/examples/chaincode/go/chaincode_example02/chaincode_example02: 100755
```
## MISC
**Test chaincode on Non-vagrant **

  1. Ensure you have Docker engine/machine setup on your machine.

  2. To build the native binaries, you would need to install some platform dependent tools
     For example on Ubuntu mahcine you would need to install **libltdl-dev**
     
     `sudo apt-get install libltdl-dev`

  3. You might need to prepend **./build/bin/** for the **orderer** and **peer** commands.
      For example: Start the orderer and peer with following command
  
     **./build/bin/orderer**
  
     **./build/bin/peer node start -o 127.0.0.1:7050**

     More details [here](https://github.com/asararatnakar/V1_Chaincode/blob/master/how-2-test-cc-non-vagrant.md)
     
--------------------------------------------------------------------------------

#### Execution 2 : How to [test](https://github.com/asararatnakar/V1_Chaincode/blob/master/how-to-exec-marble-cc.MD#how-to-execute-marbles02-sample-chaincode-from-vagrant-environment) marbles02 chaincode

