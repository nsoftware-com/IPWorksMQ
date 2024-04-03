# 
# IPWorks MQ 2022 Python Edition - Sample Project
# 
# This sample project demonstrates the usage of IPWorks MQ in a 
# simple, straightforward way. It is not intended to be a complete 
# application. Error handling and other checks are simplified for clarity.
# 
# www.nsoftware.com/ipworksmq
# 
# This code is subject to the terms and conditions specified in the 
# corresponding product license agreement which outlines the authorized 
# usage and restrictions.
# 

import sys
import string
from ipworksmq import *

input = sys.hexversion<0x03000000 and raw_input or input

def ensureArg(args, prompt, index):
  if len(args) <= index:
    while len(args) <= index:
      args.append(None)
    args[index] = input(prompt)
  elif args[index] == None:
    args[index] = input(prompt)


print("*****************************************************************\n")
print("* This demo shows how to set up an Azure Relay Service listener *\n")
print("* to accept and communicate with clients                        *\n")
print("*****************************************************************\n")

azurerelayreceiver1 = AzureRelayReceiver()

def fireSSLServerAuthentication(e):
  e.accept = True

def fireConnectionDataIn(e):
  global azurerelayreceiver1
  print("Received a message from %s and the message is: %s" % (azurerelayreceiver1.get_azure_relay_connection_host(e.connection_id), e.text))
  print("Echoing the message back...")
  azurerelayreceiver1.send(e.connection_id, e.text)

def fireConnectionConnected(e):
  print(azurerelayreceiver1.get_azure_relay_connection_host(e.connection_id) + " has connected")
  
def fireConnectionStatus(e):
  print(e.connection_event)

def fireDisconnected(e):
  global azurerelayreceiver1
  print("Disconnected from %s" % azurerelayreceiver1.get_azure_relay_connection_host(e.connection_id))
  
try:
  azurerelayreceiver1.set_access_key(input("Set Access Key: "))
  azurerelayreceiver1.set_access_key_name(input("Set Access Key Name: "))
  azurerelayreceiver1.set_namespace_address(input("Set Namespace Address: "))
  azurerelayreceiver1.set_hybrid_connection("hc1")
  print("\n")

  azurerelayreceiver1.on_connection_status = fireConnectionStatus
  azurerelayreceiver1.on_connection_connected = fireConnectionConnected
  azurerelayreceiver1.on_disconnected = fireDisconnected
  azurerelayreceiver1.on_connection_data_in = fireConnectionDataIn
  azurerelayreceiver1.on_ssl_server_authentication = fireSSLServerAuthentication

  azurerelayreceiver1.set_listening(True)
  print("Azure Relay Receiver listening...")
  while True:
    azurerelayreceiver1.do_events()

except IPWorksMQError as e:
  print(e.code)
  print("ERROR: %s" % e.message)

except KeyboardInterrupt:
  print("Shutdown requested...exiting")
  azurerelayreceiver1.shutdown()

