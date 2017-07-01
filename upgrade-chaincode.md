# How to upgrade chaincode

#### From Vagrant :
Looking for chaincode upgrade instructions ?

Following instructions might help you

#### Pre-requisites:
Refer [here](https://github.com/asararatnakar/fabric_v1_Chaincode_instructions/blob/master/README.md#pre-requisites)

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

#### Install chaincode [example01](https://github.com/hyperledger/fabric/tree/master/examples/chaincode/go/chaincode_example01)
Install chaincode example01 on the peer

`
peer chaincode install -n mycc -v 1.0 -p github.com/hyperledger/fabric/examples/chaincode/go/chaincode_example01
`


**NOTE**: If there are any issues with chaincode installation , please check [troubleshoot](https://github.com/asararatnakar/fabric_v1_Chaincode_instructions/blob/master/README.md#troubleshoot)

--------------------------------------------------------------------------------

#### Instantiate
Instantiate chaincode example01

`
peer chaincode instantiate -o 127.0.0.1:7050 -n mycc -v 1.0 -c '{"Args":["init","a", "100", "b","200"]}'
`

After succesful chaincode instantiation, you would see chaincode containers with the command `docker ps`
```
CONTAINER ID        IMAGE                 COMMAND                  CREATED             STATUS              PORTS               NAMES
174c1678678f        dev-jdoe-mycc-1.0   "chaincode -peer.a..."   32 seconds ago      Up 31 seconds                           dev-jdoe-mycc-1.0
```
--------------------------------------------------------------------------------

#### Invoke

Issue an invoke on **example01** to move "10" from "a" to "b":

 `peer chaincode invoke -o 127.0.0.1:7050 -n mycc -c '{"Args":["invoke","10"]}'`

--------------------------------------------------------------------------------

#### Query

**Query on example01**

Query for the value of **"a"**

`peer chaincode query -n mycc -c '{"Args":["query","a"]}'`

**OUTPUT**:
```
Error: Error endorsing query: rpc error: code = 2 desc = Invalid invoke function name. Expecting "invoke"
```

query function not available ?

--------------------------------------------------------------------------------

## UPGRADE

You lately realized that there is no function called **query** available in your chaincode and you added the same in your new chaincode implementation (call it **example02**), and wanted to upgrade your chaincode with **new version**.

#### Install chaincode [example02](https://github.com/hyperledger/fabric/tree/master/examples/chaincode/go/chaincode_example02)
`
peer chaincode install -n mycc -v 2.0 -p github.com/hyperledger/fabric/examples/chaincode/go/chaincode_example02
`

**NOTE:**  Notice the change in the version number to **2.0** and the chaincode path to **example02**

#### Upgrade

`
peer chaincode upgrade -o 127.0.0.1:7050 -n mycc -v 2.0 -c '{"Args":["init","a", "100", "b","200"]}'
`

**NOTE** notice **upgrade** with the new version **2.0**

#### Invoke

Issue an invoke on **example02** to move "10" from "a" to "b":

 `peer chaincode invoke -o 127.0.0.1:7050 -n mycc -c '{"Args":["invoke","a","b","10"]}'`

#### Query

**Query on UPGRADED chaincode example02**

Query for the value of **"a"**

`peer chaincode query -n mycc -c '{"Args":["query","a"]}'`

**OUTPUT**:
```
Query Result: 90
```

Hurray , Updated chaincode succesfully.
