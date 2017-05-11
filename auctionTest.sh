#!/bin/bash

#set -x
set -e

################# GLOBALS ###############
FUNC=$1
: ${FUNC:="all"}
CHAINCODE_NAME="mycc"
# This uses default channel 'testchainid'
CHAIN_NAME="testchainid"
ORDERER_IP=127.0.0.1:7050

################# GLOBALS ###############
printf "\n\n############################################################\n"
printf "################## START AUCTION E2E FLOW ##################"
printf "\n############################################################\n\n"

function wait(){
	printf "\nWait for $1 secs\n"
	sleep $1
}
function install() {
	printf "Install auction chaincode \n\n"
	peer chaincode install -n $CHAINCODE_NAME -p github.com/hyperledger/fabric/auction/art/artchaincode -c '{"Args":["init"]}' -v 1.0
}

function instantiate() {
	printf "\n\nInstantiate auction chaincode \n\n"
	peer chaincode instantiate -o $ORDERER_IP -C $CHAIN_NAME -n $CHAINCODE_NAME -p github.com/hyperledger/fabric/auction/art/artchaincode -c '{"Args":["init"]}' -v 1.0
	wait 10
}

function postUsers() {
	printf "\n-------- START POST USERS --------\n"
	peer chaincode invoke -o $ORDERER_IP -C $CHAIN_NAME -n $CHAINCODE_NAME -c  '{"Args":["iPostUser","100", "USER", "Ashley Hart", "TRD",  "Morrisville Parkway, #216, Morrisville, NC 27560", "9198063535", "ashley@itpeople.com", "SUNTRUST", "0001732345", "0234678", "2017-01-02 15:04:05"]}'
	peer chaincode invoke -o $ORDERER_IP -C $CHAIN_NAME  -n $CHAINCODE_NAME -c  '{"Args":["iPostUser","200", "USER", "Sotheby", "AH",  "One Picadally Circus , #216, London, UK ", "9198063535", "admin@sotheby.com", "Standard Chartered", "0001732345", "0234678", "2017-01-02 15:04:05"]}'
	peer chaincode invoke -o $ORDERER_IP -C $CHAIN_NAME  -n $CHAINCODE_NAME -c  '{"Args":["iPostUser","300", "USER", "Barry Smith", "TRD",  "155 Regency Parkway, #111, Cary, 27518 ", "9198063535", "barry@us.ibm.com", "RBC Centura", "0001732345", "0234678", "2017-01-02 15:04:05"]}'
	peer chaincode invoke -o $ORDERER_IP -C $CHAIN_NAME  -n $CHAINCODE_NAME -c  '{"Args":["iPostUser","400", "USER", "Cindy Patterson", "TRD",  "155 Sunset Blvd, Beverly Hills, CA, USA ", "9058063535", "cpatterson@hotmail.com", "RBC Centura", "0001732345", "0234678", "2017-01-02 15:04:05"]}'
	peer chaincode invoke -o $ORDERER_IP -C $CHAIN_NAME  -n $CHAINCODE_NAME -c  '{"Args":["iPostUser","500", "USER", "Tamara Haskins", "TRD",  "155 Sunset Blvd, Beverly Hills, CA, USA ", "9058063535", "tamara@yahoo.com", "RBC Centura", "0001732345", "0234678", "2017-01-02 15:04:05"]}'
	peer chaincode invoke -o $ORDERER_IP -C $CHAIN_NAME  -n $CHAINCODE_NAME -c  '{"Args":["iPostUser","600", "USER", "NY Life", "INS",  "155 Broadway, New York, NY, USA ", "9058063535", "barry@nyl.com", "RBC Centura", "0001732345", "0234678", "2017-01-02 15:04:05"]}'
	peer chaincode invoke -o $ORDERER_IP -C $CHAIN_NAME  -n $CHAINCODE_NAME -c  '{"Args":["iPostUser","700", "USER", "J B Hunt", "SHP",  "One Johnny Blvd, Rogers, AR, USA ", "9058063535", "jess@jbhunt.com", "RBC Centura", "0001732345", "0234678", "2017-01-02 15:04:05"]}'
 	peer chaincode invoke -o $ORDERER_IP -C $CHAIN_NAME -n $CHAINCODE_NAME -c  '{"Args":["iPostUser","800", "USER", "R&R Trading", "AH",  "155 Sunset Blvd, Beverly Hills, CA, USA ", "9058063535", "larry@rr.com", "RBC Centura", "0001732345", "0234678", "2017-01-02 15:04:05"]}'

	printf "\n-------- END POST USERS --------\n"
	wait 10
}


function getUsers() {
	printf "\n-------- START GET USERS --------\n"
	for id in {100..800..100}
	do
		OUTPUT=$(peer chaincode query -C $CHAIN_NAME -n $CHAINCODE_NAME -c "{\"Args\": [\"qGetUser\", \"$id\"]}")
		printf "\n########### Query Result for User $id: \n"
		echo $OUTPUT  | awk -F ': |\n' '{print $2}' | jq "."
	done
	printf "\n-------- END GET USERS --------\n"
}

function postItems() {
	printf "\n-------- START POST ITEMS --------\n"
	OUTPUT=$(peer chaincode invoke -o $ORDERER_IP -C $CHAIN_NAME -n $CHAINCODE_NAME -c  '{"Args":["iPostItem", "1000", "ARTINV", "Shadows by Asppen", "Asppen Messer", "20140202", "Original", "landscape", "Canvas", "15 x 15 in", "art1.png","600", "100", "2017-01-23 14:04:05"]}')
	 OUTPUT=$(peer chaincode invoke -o $ORDERER_IP -C $CHAIN_NAME -n $CHAINCODE_NAME -c  '{"Args":["iPostItem", "1100", "ARTINV", "modern Wall Painting", "Scott Palmer", "20140202", "Reprint", "landscape", "Acrylic", "10 x 10 in", "art2.png","2600", "300", "2017-01-23 14:04:05"]}')
	 OUTPUT=$(peer chaincode invoke -o $ORDERER_IP -C $CHAIN_NAME -n $CHAINCODE_NAME -c  '{"Args":["iPostItem", "1200", "ARTINV", "Splash of Color", "Jennifer Drew", "20160115", "Reprint", "modern", "Water Color", "15 x 15 in", "art3.png","1600", "100", "2017-01-23 14:04:05"]}')
	 OUTPUT=$(peer chaincode invoke -o $ORDERER_IP -C $CHAIN_NAME -n $CHAINCODE_NAME -c  '{"Args":["iPostItem", "1300", "ARTINV", "Female Water Color", "David Crest", "19900115", "Original", "modern", "Water Color", "12 x 17 in", "art4.png","9600", "100", "2017-01-23 14:04:05"]}')
	 OUTPUT=$(peer chaincode invoke -o $ORDERER_IP -C $CHAIN_NAME -n $CHAINCODE_NAME -c  '{"Args":["iPostItem", "1400", "ARTINV", "Nature", "James Thomas", "19900115", "Original", "modern", "Water Color", "12 x 17 in", "item-001.jpg","1800", "100", "2017-01-23 14:04:05"]}')
	 OUTPUT=$(peer chaincode invoke -o $ORDERER_IP -C $CHAIN_NAME -n $CHAINCODE_NAME -c  '{"Args":["iPostItem", "1500", "ARTINV", "Ladys Hair", "James Thomas", "19900115", "Original", "landscape", "Acrylic", "12 x 17 in", "item-002.jpg","1200", "300", "2017-01-23 14:04:05"]}')
	 OUTPUT=$(peer chaincode invoke -o $ORDERER_IP -C $CHAIN_NAME -n $CHAINCODE_NAME -c  '{"Args":["iPostItem", "1600", "ARTINV", "Flowers", "James Thomas", "19900115", "Original", "modern", "Acrylic", "12 x 17 in", "item-003.jpg","1000", "300", "2017-01-23 14:04:05"]}')
	 OUTPUT=$(peer chaincode invoke -o $ORDERER_IP -C $CHAIN_NAME -n $CHAINCODE_NAME -c  '{"Args":["iPostItem", "1700", "ARTINV", "Women at work", "James Thomas", "19900115", "Original", "modern", "Acrylic", "12 x 17 in", "item-004.jpg","1500", "400", "2017-01-23 14:04:05"]}')
	 OUTPUT=$(peer chaincode invoke -o $ORDERER_IP -C $CHAIN_NAME -n $CHAINCODE_NAME -c  '{"Args":["iPostItem", "1800", "ARTINV", "People", "James Thomas", "19900115", "Original", "modern", "Acrylic", "12 x 17 in", "people.gif","900", "400", "2017-01-23 14:04:05"]}')
	wait 15	
}

##TODO: Make a Generic query function for all
function getItems() {
	printf "\n-------- START GET ITEMS --------\n"
	for id in {1000..1800..100}
	do
		OUTPUT=$(peer chaincode query -C $CHAIN_NAME -n $CHAINCODE_NAME -c "{\"Args\": [\"qGetItem\", \"$id\"]}")
		printf "\n########### Query Result for Item $id: \n"
		AES_KEY=$(echo $OUTPUT  | awk -F ': |\n' '{print $2}' | jq ".AES_Key")
		printf "AES key is \"$AES_KEY\""
	done
	printf "\n-------- END GET ITEMS --------\n"
}

function postAuction() {
	printf "\n-------- START POST AUCTION --------\n"
	peer chaincode invoke -o $ORDERER_IP -C $CHAIN_NAME -n $CHAINCODE_NAME -c '{"Args":["iPostAuctionRequest", "1111", "AUCREQ", "1000", "200", "100", "04012016", "1200", "1800", "INIT", "2017-02-13 09:05:00","2017-02-13 09:05:00", "2017-02-13 09:10:00"]}'
	#peer chaincode invoke -o $ORDERER_IP -C $CHAIN_NAME -n $CHAINCODE_NAME -c '{"Args":["iPostAuctionRequest", "1112", "AUCREQ", "1100", "200", "300", "04012016", "1200", "1800", "INIT", "2017-02-13 09:05:00","2017-02-13 09:05:00", "2017-02-13 09:10:00"]}'
	printf "\n-------- END POST AUCTION --------\n"
	wait 10
}

function openAuctionRequestForBids(){
	printf "\n-------- START OPEN AUCTION FOR BIDS--------\n"
	peer chaincode invoke -o $ORDERER_IP -C $CHAIN_NAME -n $CHAINCODE_NAME  -c '{"Args":["iOpenAuctionForBids", "1111", "OPENAUC", "10", "2017-02-13 09:18:00"]}'
	printf "\n-------- END OPEN AUCTION FOR BIDS--------\n"
	wait 10
}

function submitBids() {
	printf "\n-------- START SUBMIT BIDS --------\n"
	let index=1
	for id in {300..700..100}
	do
		let price=$(shuf -i 1200-12000 -n 1)
		peer chaincode invoke -o $ORDERER_IP -C $CHAIN_NAME -n $CHAINCODE_NAME -c "{\"Args\":[\"iPostBid\", \"1111\", \"BID\", \"$index\", \"1000\", \"$id\", \"$price\", \"2017-02-13 09:19:0$index\"]}"
		index=` expr $index + 1 `
	done
	printf "\n-------- END SUBMIT BIDS --------\n"
	wait 10
}

function closeAuction(){
	printf "\n-------- START CLOSE AUCTION --------\n"
	peer chaincode invoke -o $ORDERER_IP -C $CHAIN_NAME -n $CHAINCODE_NAME -c '{"Args": ["iCloseOpenAuctions", "2016", "CLAUC", "2017-01-23 13:53:00.3 +0000 UTC"]}' &>logs.txt
	printf "\n-------- END CLOSE AUCTION --------\n"
	wait 5
	peer chaincode query -C $CHAIN_NAME -n $CHAINCODE_NAME -c "{\"Args\": [\"qGetItem\", \"1000\"]}" &>logs.txt
	printf "\n########### Query Result for Item 1000: \n"
	OUTPUT=$(cat logs.txt | awk -F ': |\n| 2017' '{print $2}')
	USER_ID=$(echo $OUTPUT  | jq ".CurrentOwnerID")
	AES_KEY=$(echo $OUTPUT  | jq ".AES_Key")
	OUTPUT=$(echo $OUTPUT | jq ".")
	echo $OUTPUT
	wait 10
}

function transferItem(){
	printf "\n-------- START TRANSFER ITEM--------\n"
	printf "\n USER ID : $USER_ID"
	printf "\n AES KEY : $AES_KEY\n"

	OUTPUT=$(peer chaincode invoke -o $ORDERER_IP -C $CHAIN_NAME -n $CHAINCODE_NAME -c "{\"Args\": [\"iTransferItem\", \"1000\", $USER_ID, $AES_KEY, \"800\", \"XFER\",\"2017-01-24 11:00:00\"]}")
	printf "\n-------- END TRANSFER ITEM--------\n"
	wait 5
	printf "\n-------- Query Item 1000 again --------\n"
	peer chaincode query -C $CHAIN_NAME -n $CHAINCODE_NAME -c '{"Args": ["qGetItem", "1000"]}'
	printf "\n Check Item 1000 is transferred from $USER_ID to 800\n"
}

function init(){
	case "$FUNC" in
	   "all") 
		  install
		  instantiate
		  postUsers
		  getUsers
		  postItems
		  getItems
		  postAuction
		  openAuctionRequestForBids
		  submitBids
		  closeAuction
		  transferItem
	   ;;

	   "install") install
	   ;;
	   "instantiate") instantiate
	   ;;
	   "postUsers") postUsers
	   ;;
	   "getUsers") getUsers
	   ;;
	   "postItems") postItems
	   ;;
	   "getItems") getItems
	   ;;
	   "postAuction") postAuction
	   ;;
	   "openAuction") openAuctionRequestForBids
	   ;;
	   "submitBids") submitBids
	   ;;
	   "closeAuction") closeAuction
	   ;;
	   "transferItem") transferItem
	   ;;
esac
}

init
printf "\n\n############################################################\n"
printf "################### END AUCTION E2E FLOW ###################"
printf "\n############################################################\n\n"
#set +x
