# How to test Auction chaincode (V1.0) from CLI

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

make native release-all
```
**_NOTE:_** If required do `make clean` and build the binaries

Clone auction chaincode

```
cd $GOPATH/src/github.com/hyperledger/fabric

git clone https://github.com/ITPeople-Blockchain/auction

```
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

** Execute auction application using a shellscript **

```
cd $GOPATH/src/github.com/hyperledger/fabric

wget https://raw.githubusercontent.com/asararatnakar/fabric_v1_Chaincode_instructions/master/auctionTest.sh

chmod +x auctionTest.sh

./auctionTest.sh
```

#### Cleanup

After each execution make sure delete db and other production data 

 `rm -rf /var/hyperledger/*`


