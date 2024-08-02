<?php
/*
 * IPWorks MQ 2024 PHP Edition - Sample Project
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
require_once('../include/ipworksmq_amazonsqs.php');
require_once('../include/ipworksmq_const.php');
?>
<?php
class myAmazonSQS extends IPWorksMQ_AmazonSQS 
{
  function fireQueue($param) 
  {
    echo "Queue ID: " . $param['queueid'] . "\n";
    echo "URL " . $param['url'] . "\n";
  }
    
  function fireMessage($param) 
  {
    echo "Message ID: " . $param['message_id'] . "\n";
    echo "Message data: " . $param['messagedata'] . "\n";
    echo "receipt handle: " . $param['receipthandle'] . "\n";
  }
} 

function printMenu() 
{
  echo "\n?\t-\tHelp\n" .
    "cd\t-\tSelect Queue\n" .
    "del\t-\tDelete Queue\n" .
    "mk\t-\tCreate Queue\n" .
    "ls\t-\tList Queues\n" .
    "lsmsg\t-\tList Messages\n" .
    "delmsg\t-\tDelete Message\n" .
    "mkmsg\t-\tCreate Message\n" .
    "q\t-\tQuit\n";
}

$queue = new myAmazonSQS();
$command = "";
$myQueueId = "";

echo "AWS Access Key: ";
$queue->setAccessKey(trim(fgets(STDIN)));
echo "AWS Secret Key: ";
$queue->setSecretKey(trim(fgets(STDIN)));

printMenu();
echo "\nAvailable queues:\n";
$queue->doListQueues();

while (true) 
{
  echo "\nEnter command: ";
  $command = trim(fgets(STDIN));
    
  try {
    if ($command == "cd") 
    {
      echo "Enter queue ID: ";
      $myQueueId = trim(fgets(STDIN));
    }
    elseif ($command == "del") 
    {
      echo "Delete queue with ID: ";
      $queue->doDeleteQueue(trim(fgets(STDIN)));
    } 
    elseif ($command == "mk") 
    {
      echo "Enter queue name: ";
      echo "Queue created with ID: " . $queue->doCreateQueue(trim(fgets(STDIN))) . "\n";
    } 
    elseif ($command == "ls") 
    {
      $queue->doListQueues();
    } 
    elseif ($command == "lsmsg")
    {
      $queue->doListMessages($myQueueId);
    } 
    elseif ($command == "delmsg") 
    {
      echo "Enter receipt handle: ";
      $queue->doDeleteMessage($myQueueId, trim(fgets(STDIN)));
    } 
    elseif ($command == "mkmsg") 
    {
      echo "Enter message data: ";
      echo "Message created with ID: " . $queue->doCreateMessage($myQueueId, trim(fgets(STDIN))) . "\n";
    } 
    elseif ($command == "q")
    {
      exit(0);
    } 
    elseif ($command == "?") 
    {
      printMenu();
    } 
    else 
    {
      echo "Command not recognized!\n";
      printMenu();
    }
  } 
  catch (Exception $e) 
  {
    echo $e->getMessage() . "\n";
    exit(1);
  }
}
