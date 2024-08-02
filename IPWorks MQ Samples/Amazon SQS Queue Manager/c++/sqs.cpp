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
#include "../../include/amazonsqs.h"
#define BUFF_SIZE 500

class MySQS : public AmazonSQS
{
public:
  virtual int FireQueue(AmazonSQSQueueEventParams* e)
  {
    printf("Queue ID: %s\nURL: %s\n\n", e->QueueId, e->URL);
    return 0;
  }

  virtual int FireMessage(AmazonSQSMessageEventParams* e)
  {
    printf("ID: %s\nData: %s\nReceipt handle: %s\n\n", e->MessageId, e->MessageData, e->ReceiptHandle);
    return 0;
  }

  virtual int FireError(AmazonSQSErrorEventParams* e)
  {
    printf("Error: %s\n\n", e->Description);
    return 0;
  }
};

void printMenu();

int main()
{
  MySQS queue;
  char buffer[BUFF_SIZE];
  char myQueueId[BUFF_SIZE] = "";
  int test;

  printf("AWS Access Key: ");
  scanf("%s", buffer);
  queue.SetAccessKey(buffer);

  printf("AWS Secret Key: ");
  scanf("%s", buffer);
  queue.SetSecretKey(buffer);

  printMenu();
  printf("\nAvailable queues:\n");
  queue.ListQueues();

  while (true)
  {
    int retCode = 0;
    printf("\nEnter command: ");
    scanf("%s", buffer);

    if (!strcmp(buffer, "cd"))
    {
      printf("Enter queue ID: ");
      scanf("%s", myQueueId);
    }
    else if (!strcmp(buffer, "del"))
    {
      printf("Delete queue with ID: ");
      scanf("%s", buffer);
      retCode = queue.DeleteQueue(buffer);
      if (retCode != 0)
      {
        printf("Error: [%i] %s\n\n", retCode, queue.GetLastError());
      }
    }
    else if (!strcmp(buffer, "mk"))
    {
      printf("Enter queue name: ");
      scanf("%s", buffer);
      printf("Queue created with ID: %s", queue.CreateQueue(buffer));
    }
    else if (!strcmp(buffer, "ls"))
    {
      retCode = queue.ListQueues();
      if (retCode != 0)
      {
        printf("Error: [%i] %s\n\n", retCode, queue.GetLastError());
      }
    }
    else if (!strcmp(buffer, "lsmsg"))
    {
      retCode = queue.ListMessages(myQueueId);
      if (retCode != 0)
      {
        printf("Error: [%i] %s\n\n", retCode, queue.GetLastError());
      }
    }
    else if (!strcmp(buffer, "delmsg"))
    {
      printf("Enter receipt handle: ");
      scanf("%s", buffer);
      retCode = queue.DeleteMessage(myQueueId, buffer);
      if (retCode != 0)
      {
        printf("Error: [%i] %s\n\n", retCode, queue.GetLastError());
      }
    }
    else if (!strcmp(buffer, "mkmsg"))
    {
      printf("Enter message data: ");
      scanf("%s", buffer);
      printf("Message created with ID: %s", queue.CreateMessage(myQueueId, buffer));
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
      printf("Command not recognized!");
      printMenu();
    }
  }
  return 0;
}

void printMenu()
{
  printf("\r\n?\t-\tHelp\n" \
    "cd\t-\tSelect Queue\n" \
    "del\t-\tDelete Queue\n" \
    "mk\t-\tCreate Queue\n" \
    "ls\t-\tList Queues\n" \
    "lsmsg\t-\tList Messages\n" \
    "delmsg\t-\tDelete Message\n" \
    "mkmsg\t-\tCreate Message\n" \
    "q\t-\tQuit\n");
}

