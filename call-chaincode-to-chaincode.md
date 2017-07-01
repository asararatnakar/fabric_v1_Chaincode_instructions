# Calling chaincode to chaincode

#### From Vagrant :
Do you want to quickly verify calling chaincode functions from another chaincode ?

Follwing commands might help you, give a try 

#### Pre-requisites:
Refer [here](https://github.com/asararatnakar/fabric_v1_Chaincode_instructions/blob/master/README.md#pre-requisites)

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

#### Install chaincode [example02](https://github.com/hyperledger/fabric/tree/master/examples/chaincode/go/chaincode_example02) & [example05](https://github.com/hyperledger/fabric/tree/master/examples/chaincode/go/chaincode_example05)
Install chaincode example02 and example05 on the peer

`
peer chaincode install -n mycc02 -v 1.0 -p github.com/hyperledger/fabric/examples/chaincode/go/chaincode_example02
`

`
peer chaincode install -n mycc05 -v 1.0 -p github.com/hyperledger/fabric/examples/chaincode/go/chaincode_example05
`

--------------------------------------------------------------------------------

#### Instantiate
Instantiate both chaincode example02 and example05

`
peer chaincode instantiate -o 127.0.0.1:7050 -n mycc02 -v 1.0 -c '{"Args":["init","a", "100", "b","200"]}'
`
`
peer chaincode instantiate -o 127.0.0.1:7050 -n mycc05 -v 1.0 -c '{"Args":["init", "sum", "0"]}'
`

After succesful chaincode instantiation, you would see chaincode containers with the command `docker ps`
```
CONTAINER ID        IMAGE                 COMMAND                  CREATED             STATUS              PORTS               NAMES
54c222e6603e        dev-jdoe-mycc05-1.0   "chaincode -peer.a..."   19 seconds ago      Up 18 seconds                           dev-jdoe-mycc05-1.0
174c1678678f        dev-jdoe-mycc02-1.0   "chaincode -peer.a..."   32 seconds ago      Up 31 seconds                           dev-jdoe-mycc02-1.0
```
--------------------------------------------------------------------------------

#### Invoke

Issue an invoke on **example02** to move "10" from "a" to "b":

 `peer chaincode invoke -o 127.0.0.1:7050 -n mycc02 -c '{"Args":["invoke","a","b","10"]}'`

Wait a few seconds for the operation to complete

Issue an invoke on **example05** to get sum of the assets **A** and **B** from example02 chaincode:

 `peer chaincode invoke -o 127.0.0.1:7050 -n mycc05 -c '{"Args":["invoke","mycc02","sum"]}'`

Wait a few seconds for the operation to complete

--------------------------------------------------------------------------------

#### Query

**Query on example02**

Query for the value of **"a"**

`peer chaincode query -n mycc02 -c '{"Args":["query","a"]}'`

**OUTPUT**:
```
Query Result: 90
```

**Query on example05**

Query for sum of assets **"a"** and **"b"** from example02 chaincode

`peer chaincode query -n mycc05 -c '{"Args":["query","mycc02","sum"]}'`

**OUTPUT**:
```
Query Result: 300
```

#### cleanup
Refer [here](https://github.com/asararatnakar/fabric_v1_Chaincode_instructions/blob/master/README.md#cleanup)

#### Troubleshoot

Refer [here](https://github.com/asararatnakar/fabric_v1_Chaincode_instructions/blob/master/README.md#troubleshoot)

--------------------------------------------------------------------------------

