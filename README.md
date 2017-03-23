# How to test Fabric V1.0 Chaincode 

#### How to test your chaincode from Vagrant :
You wrote some chaincode on Fabric V1.0 and wondering on how to test the chaincode ?? 
Probably you are on the right page and below commands might help you  :)

```
git clone https://github.com/hyperledger/fabric.git 
```

This has been verified on the commit level 0ef35105

Pre-Req
```
cd fabric/devenv

vagrant up && vagrant ssh

cd $GOPATH/src/github.com/hyperledger/fabric/devenv
make native
```

### Vagrant window 1: Start the Orderer
`orderer`

### Vagrant window 2: Start the peer 
`peer node start -o 127.0.0.1:7050`

### Vagrant window 3: Issue commands
**Install chaincode on the peer**

`peer chaincode install -o 127.0.0.1:7050 -n mycc -v 1.0 -p github.com/hyperledger/fabric/examples/chaincode/go/chaincode_example02`

**Instantiate chaincode**

`peer chaincode instantiate -o 127.0.0.1:7050 -n mycc -v 1.0 -p github.com/hyperledger/fabric/examples/chaincode/go/chaincode_example02 -c '{"Args":["init","a", "100", "b","200"]}'`

**NOTE**: check [troubleshoot](https://github.com/asararatnakar/V1_Chaincode/blob/master/README.md#trooubleshoot)

**Invoke**

Issue an invoke to move "10" from "a" to "b":

peer chaincode invoke -o 127.0.0.1:7050 -n mycc -c '{"Args":["invoke","a","b","10"]}'

Wait a few seconds for the operation to complete


**Query**

Query for the value of **"a"**

`peer chaincode query -o 127.0.0.1:7050 -n mycc -c '{"Args":["query","a"]}'`


Don't forget to clear ledger and chaincode containers(optional) after each run!
```
rm -rf /var/hyperledger/*

docker rm -f $(docker ps -aq)

docker rmi -f $(docker images | grep "dev-jdoe" | awk '{print $3}')
```

#### Trooubleshoot

Are you seeing similar error ? You might have left chaincode executable left after go build. You must consider deleting that file or similar executable files.

peer chaincode install -o 127.0.0.1:7050 -n mycc1 -v 1 -p github.com/hyperledger/fabric/examples/chaincode/go/chaincode_example02
2017-03-23 04:14:23.729 UTC [golang-platform] writeGopathSrc -> INFO 001 rootDirectory = /opt/gopath/src
2017-03-23 04:14:23.729 UTC [container] WriteFolderToTarPackage -> INFO 002 rootDirectory = /opt/gopath/src
```
Error: Error endorsing chaincode: rpc error: code = 2 desc = Illegal file mode detected for file src/github.com/hyperledger/fabric/examples/chaincode/go/chaincode_example02/chaincode_example02: 100755
```



## Test Marble chaincode :

**Install**

```
peer chaincode install -o 127.0.0.1:7050 -n marbles -v 1 -p github.com/hyperledger/fabric/examples/chaincode/go/marbles02
```

**Instantiate**
```
peer chaincode instantiate -o 127.0.0.1:7050 -n marbles -v 1 -p github.com/hyperledger/fabric/examples/chaincode/go/marbles02 -c '{"Args":[""]}'
```

**Invoke**
```
peer chaincode invoke -o 127.0.0.1:7050 -n marbles -c '{"Args":["initMarble","marble1","blue","35","tom"]}' 
peer chaincode invoke -o 127.0.0.1:7050 -n marbles -c '{"Args":["initMarble","marble2","red","50","tom"]}'
peer chaincode invoke -o 127.0.0.1:7050 -n marbles -c '{"Args":["initMarble","marble3","blue","70","tom"]}'
```
```
peer chaincode invoke -o 127.0.0.1:7050 -n marbles -c '{"Args":["transferMarble","marble2","jerry"]}'
peer chaincode invoke -o 127.0.0.1:7050 -n marbles -c '{"Args":["transferMarblesBasedOnColor","blue","jerry"]}'
peer chaincode invoke -o 127.0.0.1:7050 -n marbles -c '{"Args":["delete","marble1"]}'
```

**Query**
```
peer chaincode query -o 127.0.0.1:7050 -n marbles -c '{"Args":["readMarble","marble1"]}'
peer chaincode query -o 127.0.0.1:7050 -n marbles -c '{"Args":["getMarblesByRange","marble1","marble3"]}'
peer chaincode query -o 127.0.0.1:7050 -n marbles -c '{"Args":["getHistoryForMarble","marble1"]}'
```
