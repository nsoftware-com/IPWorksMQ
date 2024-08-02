# 
# IPWorks MQ 2024 Python Edition - Sample Project
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
  elif args[index] is None:
    args[index] = input(prompt)


queue = AmazonSQS()
command = ""
myQueueId = ""

def handle_queue_event(event: AmazonSQSQueueEventParams):
  print("Queue ID: " + event.queue_id)
  print("URL: " + event.url)

def handle_message_event(event: AmazonSQSMessageEventParams):
  print("Message ID: " + event.message_id)
  print("Message data: " + event.message_data)
  print("Meceipt handle: " + event.receipt_handle)

def printMenu():
  print("\r\n?\t-\tHelp\n" +
    "cd\t-\tSelect Queue\n" +
    "del\t-\tDelete Queue\n" +
    "mk\t-\tCreate Queue\n" +
    "ls\t-\tList Queues\n" +
    "lsmsg\t-\tList Messages\n" +
    "delmsg\t-\tDelete Message\n" +
    "mkmsg\t-\tCreate Message\n" +
    "q\t-\tQuit\n")

queue.on_queue = handle_queue_event
queue.on_message = handle_message_event

queue.set_access_key(input("AWS Access Key: "))
queue.set_secret_key(input("AWS Secret Key: "))

printMenu()
print("\nAvailable queues:")
queue.list_queues()

while True:
  command = input("\nEnter command: ")
  try:
    if command == "cd":
      myQueueId = input("Enter queue ID: ")
    elif command == "del":
      queue.delete_queue(input("Delete queue with ID: "))
    elif command == "mk":
      print("Queue created with ID: " + queue.create_queue(input("Enter queue name: ")))
    elif command == "ls":
      queue.list_queues()
    elif command == "lsmsg":
      queue.list_messages(myQueueId)
    elif command == "delmsg":
      queue.delete_message(myQueueId, input("Enter receipt handle: "))
    elif command == "mkmsg":
      print("Message created with ID: " + queue.create_message(myQueueId, input("Enter message data: ")))
    elif command == "q":
      sys.exit(0)
    elif command == "?":
      printMenu()
    else:
      print("Command not recognized!")
      printMenu()
  except IPWorksMQError as e:
      print("Error: " + e.message)
  except Exception:
      print(e.message)
      sys.exit(1)

