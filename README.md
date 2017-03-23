# How to test Fabric V1.0 Chaincode 

#### How to test your chaincode from Vagrant :
You wrote some chaincode on Fabric V1.0 and wondering on how to test the chaincode ?? 
Probably you are on the right page and below commands might help you  :)

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

Are you seeing similar error ? You might have chaincode executable left after go build. You must consider deleting that file or any executable files in GOPATH

```
peer chaincode install -o 127.0.0.1:7050 -n mycc1 -v 1 -p github.com/hyperledger/fabric/examples/chaincode/go/chaincode_example02
2017-03-23 04:14:23.729 UTC [golang-platform] writeGopathSrc -> INFO 001 rootDirectory = /opt/gopath/src
2017-03-23 04:14:23.729 UTC [container] WriteFolderToTarPackage -> INFO 002 rootDirectory = /opt/gopath/src

Error: Error endorsing chaincode: rpc error: code = 2 desc = Illegal file mode detected for file src/github.com/hyperledger/fabric/examples/chaincode/go/chaincode_example02/chaincode_example02: 100755
```

--------------------------------------------------------------------------------

## Test Marble chaincode :

**Install**

```
peer chaincode install -o 127.0.0.1:7050 -n marbles -v 1 -p github.com/hyperledger/fabric/examples/chaincode/go/marbles02
```

**Instantiate**
```
peer chaincode instantiate -o 127.0.0.1:7050 -n marbles -v 1 -p github.com/hyperledger/fabric/examples/chaincode/go/marbles02 -c '{"Args":[""]}'
```
After succesful chaincode instantiation , you would see a chaincode container coming up
```
CONTAINER ID        IMAGE                COMMAND                  CREATED             STATUS              PORTS               NAMES
63fb81f6849e        dev-jdoe-marbles-1  "chaincode -peer.a..."   1 second ago        Up 1 second    dev-jdoe-marbles-1
```

**Invoke**

* Create 3 marbles
```
peer chaincode invoke -o 127.0.0.1:7050 -n marbles -c '{"Args":["initMarble","marble1","blue","35","tom"]}' 
peer chaincode invoke -o 127.0.0.1:7050 -n marbles -c '{"Args":["initMarble","marble2","red","50","tom"]}'
peer chaincode invoke -o 127.0.0.1:7050 -n marbles -c '{"Args":["initMarble","marble3","blue","70","tom"]}'
```

* Transfer **marble2** from tom to **Jerry**
```
peer chaincode invoke -o 127.0.0.1:7050 -n marbles -c '{"Args":["transferMarble","marble2","jerry"]}'
```
* Transfer **blue color** marble to **Jerry**
```
peer chaincode invoke -o 127.0.0.1:7050 -n marbles -c '{"Args":["transferMarblesBasedOnColor","blue","jerry"]}'
```
* Delete **marble1**
```
peer chaincode invoke -o 127.0.0.1:7050 -n marbles -c '{"Args":["delete","marble1"]}'
```

**Query**
```
peer chaincode query -o 127.0.0.1:7050 -n marbles -c '{"Args":["readMarble","marble1"]}'
peer chaincode query -o 127.0.0.1:7050 -n marbles -c '{"Args":["getMarblesByRange","marble1","marble3"]}'
peer chaincode query -o 127.0.0.1:7050 -n marbles -c '{"Args":["getHistoryForMarble","marble1"]}'
```
