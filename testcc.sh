#!/bin/bash +x

set -e

printf "\n\n********************** START ***********************\n\n"
printf "Installing chaincode example02\n\n"
peer chaincode install -n mycc -v 1.0 -p github.com/hyperledger/fabric/examples/chaincode/go/chaincode_example02
printf "\n\nInstantiate chaincode example02\n\n"
peer chaincode instantiate -o 127.0.0.1:7050 -n mycc -v 1.0 -c '{"Args":["init","a", "100", "b","200"]}'

printf "\nWait for 10 secs\n"
sleep 10

printf "\n\nInvoke on chaincode example02\n\n"
peer chaincode invoke -o 127.0.0.1:7050 -n mycc -c '{"Args":["invoke","a","b","10"]}'

printf "\n\nQuery on chaincode example02\n\n"
peer chaincode query -n mycc -c '{"Args":["query","a"]}'
printf "\n\n********************** END ***********************\n\n"
