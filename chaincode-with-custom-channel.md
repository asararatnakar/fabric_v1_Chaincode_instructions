# How to test chaincode on a channel

#### From Vagrant Environment:

#### Pre-requisites:
Refer [here](https://github.com/asararatnakar/fabric_v1_Chaincode_instructions/blob/master/README.md#pre-requisites)

Also build the configtx tool, which is used to create two artifacts: 
  - orderer bootstrap block 
  - fabric channel configuration transaction

`make configtxgen`

Generate genesis block
```
configtxgen -profile SampleSingleMSPSolo -outputBlock orderer.block
```

Generate channel configuration transaction
```
configtxgen -profile SampleSingleMSPSolo -outputCreateChannelTx channel.tx -channelID mychannel
```

Here `orderer.block` is the genesis block for the ordering service, where as the channel transaction file `channel.tx` is broadcast to the orderer at channel creation time.

--------------------------------------------------------------------------------

### Vagrant Terminal Tab 1: 

**Start the Orderer service**

`cd $GOPATH/src/github.com/hyperledger/fabric`

`ORDERER_GENERAL_LOGLEVEL=debug ORDERER_GENERAL_GENESISPROFILE=SampleSingleMSPSolo orderer`

--------------------------------------------------------------------------------

### Vagrant Terminal Tab 2: 

**Start the peer**

```
peer node start
```

--------------------------------------------------------------------------------

### Vagrant Terminal Tab 3:

Run commands from fabric folder

`cd $GOPATH/src/github.com/hyperledger/fabric`

#### Create channel

`peer channel create -o 127.0.0.1:7050 -c mychannel -f channel.tx `

#### Join channel

`peer channel join -b mychannel.block`


#### Install chaincode [example02](https://github.com/hyperledger/fabric/tree/master/examples/chaincode/go/chaincode_example02)

Install chaincode example02 on the peer

`
peer chaincode install -n mycc -v 1.0 -p github.com/hyperledger/fabric/examples/chaincode/go/chaincode_example02
`


**NOTE**: If there are any issues with chaincode installation , please check [troubleshoot](https://github.com/asararatnakar/fabric_v1_Chaincode_instructions/blob/master/README.md#troubleshoot)

--------------------------------------------------------------------------------

#### Instantiate

Instantiate chaincode example02

`
peer chaincode instantiate -o 127.0.0.1:7050 -C mychannel -n mycc -v 1.0  -c '{"Args":["init","a", "100", "b","200"]}' 
`

After succesful chaincode instantiation, you would see chaincode containers with the command `docker ps`

```
CONTAINER ID        IMAGE                 COMMAND                  CREATED             STATUS              PORTS               NAMES
174c1678678f        dev-jdoe-mycc-1.0   "chaincode -peer.a..."   32 seconds ago      Up 31 seconds                           dev-jdoe-mycc-1.0
```
--------------------------------------------------------------------------------

#### Invoke

Issue an invoke on chaincode **example02** to move "10" from "a" to "b":

 `peer chaincode invoke -o 127.0.0.1:7050 -C mychannel -n mycc -c '{"Args":["invoke","a","b","10"]}'`

--------------------------------------------------------------------------------

#### Query

Query for the value of **"a"**

`peer chaincode query -C mychannel -n mycc -c '{"Args":["query","a"]}'`


**OUTPUT**:
```
Query Result: 90
```
