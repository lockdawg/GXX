#GXX
Use this shell script to install a [GXX Masternode](https://www.gravitycoin.io/) on a Linux server running Ubuntu 16.04.  
This will require a VPS, I use [Vultr](https://www.vultr.com/?ref=7310394).  I recommend using a $5 server.
This script will install **GXX Core v4.0.6.6 **.
***

## Installation:
Log into the server using ssh (Putty for windows or terminal for Mac users) and run the following commands:
```
wget -q https://raw.githubusercontent.com/lockdawg/GXX/master/gxx_install.sh
bash gxx_install.sh
```
***

## Desktop wallet setup

After the MN is up and running, you need to configure the desktop wallet accordingly. Here are the steps for Windows/Mac Wallet:
1. Open the GXX Core Wallet.
2. Go to RECEIVE and create a New Address: **MN1**
3. Send **10000** **GXX** to **MN1**.
4. Wait for ~15 confirmations before starting the node.
5. Go to **Help -> "Debug window - Console"**
6. Type the following command: **xnode outputs**
7. Type the following command: **xnode genkey**
8. Open masternode.conf from the following folder %appdata%\GravityCoin (windows) or ~/Library/Application Support/ (hidden folder for Mac users)
9. Add the following entry:
```
Alias Address Genkey TxHash Output_index
```
* Alias: **MN1**
* Address: **VPS_IP:29100**
* Genkey: **Masternode GenKey**
* TxHash: **First value from Step 6** 
* Output index:  **Second value from Step 6** It can be **0** or **1**
10. Click OK and exit the Wallet.
11. Open BCZ Core Wallet, go to **Masternode Tab**.
12. Click **Update status** to see your node. If it is not shown, close the wallet and start it again.
13. Click **Start All** or **Start Alias**
12. If you are not able to see your **Masternode**, try to close and open your desktop wallet.
***

## Usage:
```
GravityCoin-cli getinfo
GravityCoin-cli xnode status
```
Also, if you want to check/start/stop **GXX** , run one of the following commands as **root**:
```
systemctl status GXX #To check the service is running.
systemctl start GXX #To start GXX service.
systemctl stop GXX #To stop GXX service.
systemctl is-enabled GXX #To check whether GXX service is enabled on boot or not.
```
***

## Updating GXX
The first line (rm gxx_update.sh) is not required the very first time you update the node and will return an error if you run it.  This is fine, continue with the update script.
```
rm gxx_update.sh*
wget -q https://raw.githubusercontent.com/lockdawg/GXX/master/gxx_update.sh
bash gxx_update.sh
```
***

## Donations:  

**GXX**: H9NjHd7Hr7Qht8bK1kaiUTrjqnAaXgnMs5  
**BTC**: 33mkLq6fmwfCz5dfK54giowZYygtBxypXr  
**ETH**: 0x1CCa2B182516a2bdC6989606F52E28407751A9D3  
**LTC**: MTkeGVv99gTeoyGnGppPCVDQ2Xz9sF6UVn
