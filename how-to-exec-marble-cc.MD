## How to test marbles02 sample chaincode from vagrant environment

#### Execution 2 : Sample chaincode [marbles02](https://github.com/hyperledger/fabric/tree/master/examples/chaincode/go/marbles02)

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

**NOTE**: For troubleshoot check [here](https://github.com/asararatnakar/V1_Chaincode#troubleshoot)
