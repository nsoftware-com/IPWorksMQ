/*
 * IPWorks MQ 2024 JavaScript Edition - Sample Project
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
 
const readline = require("readline");
const ipworksmq = require("@nsoftware/ipworksmq");

if(!ipworksmq) {
  console.error("Cannot find ipworksmq.");
  process.exit(1);
}
let rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});



const promt = (query) => new Promise((resolve) => rl.question(query, resolve));

var queue = new ipworksmq.amazonsqs();
var myQueueId = "";

queue.on('Queue', function(e)
{
  console.log("Queue ID: " + e.queueId);
  console.log("URL" + e.URL);
});

queue.on("Message", function(e) 
{
  console.log("Message ID: " + e.messageId);
  console.log("Message data: " + e.messageData);
  console.log("Receipt handle: " + e.receiptHandle);
});

main();

function printMenu()
{
  console.log('\r\n?\t-\tHelp\n' +
    'cd\t-\tSelect Queue\n' +
    'del\t-\tDelete Queue\n' +
    'mk\t-\tCreate Queue\n' +
    'ls\t-\tList Queues\n' +
    'lsmsg\t-\tList Messages\n' +
    'delmsg\t-\tDelete Message\n' +
    'mkmsg\t-\tCreate Message\n' +
    'q\t-\tQuit\n');
}

async function main() {
  queue.setAccessKey(await promt("AWS Access Key: "));
  queue.setSecretKey(await promt("AWS Secret Key: "));
  
  printMenu();
  console.log("\nAvailable queues:");
  queue.listQueues();

  setTimeout(function () 
  {
    process.stdout.write("\nEnter command: ");
  }, 1000);

  rl.on("line", async function (line)
  {
    switch (line.toLowerCase())
    {
      case "cd":
        myQueueId = await promt("Enter queue ID: ");
        break;
          
      case "del":
        await queue.deleteQueue(await promt("Delete queue with ID: ")).catch(function (e)
          {
            console.log(e.message);
          });
        break;
    
      case "mk":
        console.log("Queue created with Id: " + await queue.createQueue(await promt("Enter queue name: ")).catch(function (e)
          {
            console.log(e.message);
          }));
        break;
      
      case "ls":
        await queue.listQueues().catch(function (e)
          {
            console.log(e.message);
          });
        break;
      
      case "lsmsg":
        await queue.listMessages(myQueueId).catch(function (e)
          {
            console.log(e.message);
          });
        break;
      
      case "delmsg":
        await queue.deleteMessage(myQueueId, await promt("Enter receipt handle: ").catch(function (e)
          {
            console.log(e.message);
          }));
        break;
      
      case "mkmsg":
        console.log("Message created with ID: " + await queue.createMessage(myQueueId, await promt("Enter message data: ")).catch(function (e)
          {
            console.log(e.message);
          }));
        break;

      case "?":
        printMenu();
        break;

      case "q":
        process.exit(0);

      default:
        console.log("Command not recognized!");
        break;
    }
    process.stdout.write("\nEnter command: ");
  });
}

function prompt(promptName, label, punctuation, defaultVal)
{
  lastPrompt = promptName;
  lastDefault = defaultVal;
  process.stdout.write(`${label} [${defaultVal}] ${punctuation} `);
}
