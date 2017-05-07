# How to test hyperledger fabric V1.0 chaincode from CLI

#### How to test your chaincode from Vagrant :
You wrote some chaincode on Fabric V1.0 and now you wanted to quickly verify the functionality with default channel and with out any hassles of creating new channel etc ...?

Following are the instructions that might help you

--------------------------------------------------------------------------------
#### Pre-requisites:
```
mkdir -p $GOPATH/src/github.com/hyperledger

cd $GOPATH/src/github.com/hyperledger

git clone https://github.com/hyperledger/fabric.git 

```

Build native binaries
```
cd fabric/devenv

vagrant up && vagrant ssh

cd $GOPATH/src/github.com/hyperledger/fabric

make peer orderer
```
**_NOTE:_** If required do `make clean` and build the binaries

--------------------------------------------------------------------------------

### Vagrant Terminal Tab 1: 

**Start the Orderer**

`orderer`

--------------------------------------------------------------------------------

### Vagrant Terminal Tab 2: 

**Start the peer**

`peer node start -o 127.0.0.1:7050`

--------------------------------------------------------------------------------

### Vagrant Terminal Tab 3:

This uses chaincode example program [example02](https://github.com/hyperledger/fabric/tree/master/examples/chaincode/go/chaincode_example02)
**Install chaincode on the peer**

`
peer chaincode install -n mycc -v 1.0 -p github.com/hyperledger/fabric/examples/chaincode/go/chaincode_example02`

**NOTE**: If there are any issues with chaincode installation , please check [troubleshoot](https://github.com/asararatnakar/fabric_v1_Chaincode_instructions/blob/master/README.md#troubleshoot)

--------------------------------------------------------------------------------

**Instantiate chaincode**

`
peer chaincode instantiate -o 127.0.0.1:7050 -n mycc -v 1.0 -c '{"Args":["init","a", "100", "b","200"]}'
`

After succesful chaincode instantiation, you would see chaincode container comes up
```
CONTAINER ID        IMAGE                COMMAND                  CREATED             STATUS              PORTS               NAMES
c74a34f846f9     dev-jdoe-mycc-1.0    "chaincode -peer.a..."   1 second ago        Up 1 second       dev-jdoe-mycc-1.0
```

--------------------------------------------------------------------------------

**Invoke**

Issue an invoke to move "10" from "a" to "b":

 `peer chaincode invoke -o 127.0.0.1:7050 -n mycc -c '{"Args":["invoke","a","b","10"]}'`

Wait a few seconds for the operation to complete

--------------------------------------------------------------------------------

**Query**

Query for the value of **"a"**

`peer chaincode query -n mycc -c '{"Args":["query","a"]}'`

--------------------------------------------------------------------------------

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
--------------------------------------------------------------------------------

#### Troubleshoot

* Are you seeing **Illegal file mode detected** error ? 

  That means chaincode executable been left after building your chaincode with **go build**.You must consider deleting that file or revoke any executable permission for those files under GOPATH

```
peer chaincode install -o 127.0.0.1:7050 -n mycc1 -v 1 -p github.com/hyperledger/fabric/examples/chaincode/go/chaincode_example02
2017-03-23 04:14:23.729 UTC [golang-platform] writeGopathSrc -> INFO 001 rootDirectory = /opt/gopath/src
2017-03-23 04:14:23.729 UTC [container] WriteFolderToTarPackage -> INFO 002 rootDirectory = /opt/gopath/src

Error: Error endorsing chaincode: rpc error: code = 2 desc = Illegal file mode detected for file src/github.com/hyperledger/fabric/examples/chaincode/go/chaincode_example02/chaincode_example02: 100755
```
--------------------------------------------------------------------------------

#### few more samples:

* commands to create channel and test chaincode on the custom channel
  Instructions [here](https://github.com/asararatnakar/fabric_v1_Chaincode_instructions/blob/master/chaincode-with-custom-channel.md)
* commands to test **chaincode upgrade** functionality, instructions [here](https://github.com/asararatnakar/fabric_v1_Chaincode_instructions/blob/master/upgrade-chaincode.md)

* run chaincode in dev mode, instructions [here](https://github.com/hyperledger/fabric/blob/master/docs/source/peer-chaincode-devmode.rst)
* commands for **Calling chaincode to chaincode**, instructions below
 
 with [default channel](https://github.com/asararatnakar/fabric_v1_Chaincode_instructions/blob/master/call-chaincode-to-chaincode.md) 
 
 with [non-default channel](https://github.com/asararatnakar/fabric_v1_Chaincode_instructions/blob/master/call-chaincode-to-chaincode-nondefault-chain.md) 

* commands to test chaincode on **non-vagrant environment (ubuntu)** , details [here](https://github.com/asararatnakar/fabric_v1_Chaincode_instructions/blob/master/how-2-test-cc-non-vagrant.md)

* commands to test **marbles02 chaincode**, Instructions [here](https://github.com/asararatnakar/fabric_v1_Chaincode_instructions/blob/master/how-to-exec-marble-chaincode.md)
