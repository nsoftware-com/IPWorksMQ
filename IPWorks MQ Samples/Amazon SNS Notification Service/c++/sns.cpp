/*
 * IPWorks MQ 2024 C++ Edition - Sample Project
 *
 * This sample project demonstrates the usage of IPWorks MQ in a 
 * simple, straightforward way. It is not intended to be a complete 
 * application. Error handling and other checks are simplified for clarity.
 *
 * www.nsoftware.com/ipworksmq
 *
 * This code is subject to the terms and conditions specified in the 
 * corresponding product license agreement which outlines the authorized 
 * usage and restrictions.
 */

#include <stdio.h>
#include <string>
#include <stdlib.h>
#include "../../include/amazonsns.h"
#define MAX_LEN 500

class MySNS : public AmazonSNS
{
public:
  virtual int FireTopicList(AmazonSNSTopicListEventParams* e)
  {
    printf("%s\n", e->TopicArn);
    return 0;
  }

  virtual int FireSubscriptionList(AmazonSNSSubscriptionListEventParams* e)
  {
    printf("topic ARN: %s\n", e->TopicArn);
    printf("subscription ARN: %s\n", e->SubscriptionArn);
    printf("endpoint: %s\n", e->Endpoint);
    printf("owner: %s\n", e->Owner);

    switch (e->Protocol) {
    case 0:
      printf("EndPoint protocol: email\n");
      break;
    case 1:
      printf("EndPoint protocol: email-json\n");
      break;
    case 2:
      printf("EndPoint protocol: http\n");
      break;
    case 3:
      printf("EndPoint protocol: https\n");
      break;
    case 4:
      printf("EndPoint protocol: SMS\n");
      break;
    case 5:
      printf("EndPoint protocol: SQS\n");
      break;
    default:
      printf("not known protocol\n");
      break;
    }

    printf("-----------------------------------------------------------------------------------------\n");

    return 0;
  }

  virtual int FireError(AmazonSNSErrorEventParams* e)
  {
    printf("Error: %s\n\n", e->Description);
    return 0;
  }
};

void printMenu();

int main()
{
  MySNS sns;
  char buffer[MAX_LEN];

  printf("AWS Access Key: ");
  scanf("%s", buffer);
  sns.SetAccessKey(buffer);

  printf("AWS Secret Key: ");
  scanf("%s", buffer);
  sns.SetSecretKey(buffer);

  printMenu();

  while (true)
  {
    int retCode = 0;
    printf("\nEnter command: ");
    scanf("%s", buffer);

    if (!strcmp(buffer, "lst"))
    {
      do sns.ListTopics();
      while (strlen(sns.GetTopicMarker()) != 0);
    }
    else if (!strcmp(buffer, "lss"))
    {
      do sns.ListSubscriptions();
      while (strlen(sns.GetSubscriptionMarker()) != 0);
    }
    else if (!strcmp(buffer, "mk"))
    {
      char* topicArn;
      printf("Enter topic name: ");
      scanf("%s", buffer);

      topicArn = sns.CreateTopic(buffer);
      if (strlen(topicArn) == 0)
      {
        printf("Something went wrong!");
        continue;
      }
      printf("Topic ARN for new topic: %s\n", topicArn);
    }
    else if (!strcmp(buffer, "del"))
    {
      printf("Enter topic ARN: ");
      scanf("%s", buffer);
      retCode = sns.DeleteTopic(buffer);
      if (retCode != 0)
      {
        printf("Error: [%i] %s\n\n", retCode, sns.GetLastError());
      }
    }
    else if (!strcmp(buffer, "sub"))
    {
      char topicArn[MAX_LEN];
      char endpoint[MAX_LEN];
      char* subArn;
      int endpointProtocol;
            
      printf("Enter a topic: ");
      scanf("%s", topicArn);

      printf("Enter an endpoint i.e email add, phone nr..: ");
      scanf("%s", endpoint);
            
      printf("Choose a endpoint protocol: \n" \
        "0 for email\n" \
        "1 for email-json\n" \
        "2 for http\n" \
        "3 for https\n" \
        "4 for sms\n" \
        "5 for sqs\n");
            
      scanf("%d", &endpointProtocol);

      subArn = sns.Subscribe(topicArn, endpoint, endpointProtocol);
      if (strlen(subArn) == 0)
      {
        printf("Something went wrong!");
        continue;
      }
      printf("Subscription ARN for new subscriber: %s\n", subArn);
    }
    else if (!strcmp(buffer, "unsub"))
    {
      printf("Subscription ARN: ");
      scanf("%s", buffer);
      retCode = sns.Unsubscribe(buffer);
      if (retCode != 0)
      {
        printf("Error: [%i] %s\n\n", retCode, sns.GetLastError());
      }
    }
    else if (!strcmp(buffer, "pub"))
    {
      char topicArn[MAX_LEN];
      char subject[MAX_LEN];
      char message[MAX_LEN];
      char* msgId;

      printf("Enter a topic: ");
      scanf("%s", topicArn);

      printf("Enter subject: ");
      scanf("%s", subject);

      printf("Enter body: ");
      scanf("%s", message);

      msgId = sns.Publish(topicArn, subject, message);
      if (strlen(msgId) == 0)
      {
        printf("Something went wrong!");
        continue;
      }
      printf("Message Id: %s", msgId);
    }
    else if (!strcmp(buffer, "q"))
    {
      return 0;
    }
    else if (!strcmp(buffer, "?"))
    {
      printMenu();
    }
    else
    {
      printf("not an option!");
      printMenu();
    }
  }
    return 0;
}

void printMenu()
{
  printf("\r\n?\t-\tHelp\n" \
    "lst\t-\tList Topics\n" \
    "lss\t-\tList Subscriptions\n" \
    "mk\t-\tCreate Topic\n" \
    "del\t-\tDelete Topic\n" \
    "sub\t-\tSubscribe\n" \
    "unsub\t-\tUnSubscribe\n" \
    "pub\t-\tPublish\n" \
    "q\t-\tQuit\n");
}

