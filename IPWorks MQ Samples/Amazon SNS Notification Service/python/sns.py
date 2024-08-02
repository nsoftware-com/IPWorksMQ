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


sns = AmazonSNS()
buffer = ""

def print_menu():
    print("Menu options:")
    print("? - Show menu")
    print("lst - List topics")
    print("lss - List subscriptions")
    print("mk - Create topic")
    print("del - Delete topic")
    print("sub - Subscribe to topic")
    print("unsub - Unsubscribe from topic")
    print("pub - Publish message")
    print("q - Quit")

def subscription_list(amazon_sns_subscription_list_event: AmazonSNSSubscriptionListEventParams):
    print("topic ARN:", amazon_sns_subscription_list_event.topic_arn)
    print("subscription ARN:", amazon_sns_subscription_list_event.subscription_arn)
    print("endpoint:", amazon_sns_subscription_list_event.endpoint)
    print("owner:", amazon_sns_subscription_list_event.owner)
    
    if amazon_sns_subscription_list_event.protocol == 0:
        print("EndPoint protocol: email")
    elif amazon_sns_subscription_list_event.protocol == 1:
        print("EndPoint protocol: email-json")
    elif amazon_sns_subscription_list_event.protocol == 2:
        print("EndPoint protocol: http")
    elif amazon_sns_subscription_list_event.protocol == 3:
        print("EndPoint protocol: https")
    elif amazon_sns_subscription_list_event.protocol == 4:
        print("EndPoint protocol: SMS")
    elif amazon_sns_subscription_list_event.protocol == 5:
        print("EndPoint protocol: SQS")
    else:
        print("not known protocol")
    
    print("-----------------------------------------------------------------------------------------")

def topic_list(amazon_sns_topic_list_event: AmazonSNSTopicListEventParams):
    print(amazon_sns_topic_list_event.topic_arn)

sns.on_topic_list = topic_list
sns.on_subscription_list = subscription_list

try:
    sns.set_access_key(input("AWS Access Key: "))
    sns.set_secret_key(input("AWS Secret Key: "))

    print_menu()
    while True:
        print("Enter command: ")
        buffer = input().lower()

        try:
            if buffer == "?":
                print_menu()
            elif buffer == "lst":
                sns.list_topics()
                while sns.get_topic_marker() != "":
                    sns.list_topics()

            elif buffer == "lss":
                sns.list_subscriptions()
                while sns.get_subscription_marker() != "":
                    sns.list_subscriptions()

            elif buffer == "mk":
                print("Enter topic name: ")
                print("Topic ARN for new topic: " + sns.create_topic(input()))

            elif buffer == "del":
                sns.delete_topic(input("Enter topic ARN: "))
                print("success!")

            elif buffer == "sub":
                topic_arn = input("Enter a topic: ")
                endpoint = input("Enter an endpoint i.e email add, phone nr..: ")                
                endpoint_protocol = int(input("Choose a endpoint protocol: \n" +
                      "0 for email\n" +
                      "1 for email-json\n" +
                      "2 for http\n" +
                      "3 for https\n" +
                      "4 for sms\n" +
                      "5 for sqs\n"))
                
                print("Subscription ARN for new subscriber: " + sns.subscribe(topic_arn, endpoint, endpoint_protocol))

            elif buffer == "unsub":
                sns.unsubscribe(input("Subscription ARN: "))
                print("success!")

            elif buffer == "pub":
                topic_arn1 = input("Enter a topic: ")
                subject = input("Enter subject: ")
                message = input("Enter body: ")
                
                print("Message Id: " + sns.publish(topic_arn1, subject, message))

            elif buffer == "q":
                break

            else:
                print("not an option!")
                print_menu()

        except IPWorksMQError as e:
            print(e)

except Exception as e:
    print(e)

