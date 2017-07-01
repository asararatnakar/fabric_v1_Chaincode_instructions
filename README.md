# How to test hyperledger fabric V1.0 chaincode from CLI

#### How to test your chaincode from Vagrant :
You wrote some chaincode on Fabric V1.0 and now you wanted to test your chaincode with simple of steps of creating a __channel  configuration__ , __create channel__ and __join channel__ ...?

Follow are the instructions:

--------------------------------------------------------------------------------
#### Pre-requisites:
```
mkdir -p $GOPATH/src/github.com/hyperledger

cd $GOPATH/src/github.com/hyperledger

git clone https://github.com/hyperledger/fabric.git

rm -rf /var/hyperledger/*

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

`ORDERER_GENERAL_GENESISPROFILE=SampleSingleMSPSolo orderer`

--------------------------------------------------------------------------------

### Vagrant Terminal Tab 2: 

**Start the peer**

`peer node start`

--------------------------------------------------------------------------------

### Vagrant Terminal Tab 3:

This uses chaincode example program [example02](https://github.com/hyperledger/fabric/tree/master/examples/chaincode/go/chaincode_example02)
**Install chaincode on the peer**

`peer chaincode install -n mycc -v 1.0 -p github.com/hyperledger/fabric/examples/chaincode/go/chaincode_example02`

--------------------------------------------------------------------------------

**Generate channel configuration (transaction)**

`configtxgen -channelID myc -outputCreateChannelTx myc.tx -profile SampleSingleMSPChannel`

--------------------------------------------------------------------------------

**Create channel**

`peer channel create -o 127.0.0.1:7050 -c myc -f myc.tx -t 10`

--------------------------------------------------------------------------------

**Join channel**

`peer channel join -c myc -f myc.block`

--------------------------------------------------------------------------------

**Instantiate chaincode**

`
peer chaincode instantiate -o 127.0.0.1:7050 -C myc -n mycc -v 1.0 -c '{"Args":["init","a", "100", "b","200"]}'
`

After succesful chaincode instantiation, you would see chaincode container comes up.
`docker ps`

```
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
ba2746fd32bf        dev-jdoe-mycc-0    "chaincode -peer.a..."   6 seconds ago       Up 5 seconds                            dev-jdoe-mycc-0
```

--------------------------------------------------------------------------------

**Invoke**

Issue an invoke to move "10" from "a" to "b":

 `peer chaincode invoke -o 127.0.0.1:7050 -C myc -n mycc -c '{"Args":["invoke","a","b","10"]}'`

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
??

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
