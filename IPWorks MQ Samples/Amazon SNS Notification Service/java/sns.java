/*
 * IPWorks MQ 2024 Java Edition - Sample Project
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

import java.io.*;
import ipworksmq.*;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

public class sns
{
    public static void main(String[] args)
    {
        AmazonSNS sns = new AmazonSNS();
        String buffer = "";

        try
        {
            sns.addAmazonSNSEventListener(new SnsEvents());
            System.out.print("AWS Access Key: ");
            sns.setAccessKey(input());

            System.out.print("AWS Secret Key: ");
            sns.setSecretKey(input());

            printMenu();
            while (true)
            {
                System.out.println("Enter command: ");
                buffer = input().toLowerCase();

                try
                {
                    switch (buffer)
                    {
                        case "?":
                            printMenu();
                            break;
                        case "lst":
                            do sns.listTopics();
                            while (!sns.getTopicMarker().isEmpty());
                            break;
                        case "lss":
                            do sns.listSubscriptions();
                            while (!sns.getSubscriptionMarker().isEmpty());
                            break;
                        case "mk":
                            System.out.println("Enter topic name: ");
                            System.out.println("Topic ARN for new topic: " + sns.createTopic(input()));
                            break;
                        case "del":
                            System.out.println("Enter topic ARN: ");
                            sns.deleteTopic(input());
                            System.out.println("success!");
                            break;
                        case "sub":
                            String topicArn;
                            String endpoint;
                            int endpointProtocol;

                            System.out.println("Enter a topic: ");
                            topicArn = input();
                            System.out.println("Enter an endpoint i.e email add, phone nr..: ");
                            endpoint = input();
                            System.out.println("Choose a endpoint protocol: \n" +
                                    "0 for email\n" +
                                    "1 for email-json\n" +
                                    "2 for http\n" +
                                    "3 for https\n" +
                                    "4 for sms\n" +
                                    "5 for sqs\n");

                            endpointProtocol = Integer.parseInt(input());

                            System.out.println("Subscription ARN for new subscriber: " + sns.subscribe(topicArn, endpoint, endpointProtocol));
                            break;
                        case "unsub":
                            System.out.println("Subscription ARN: ");
                            sns.unsubscribe(input());
                            System.out.println("success!");
                            break;
                        case "pub":
                            String topicArn1;
                            String subject;
                            String message;

                            System.out.println("Enter a topic: ");
                            topicArn1 = input();
                            System.out.println("Enter subject: ");
                            subject = input();
                            System.out.println("Enter body: ");
                            message = input();

                            System.out.println("Message Id: " + sns.publish(topicArn1, subject, message));
                            break;
                        case "q":
                            System.exit(0);
                        default:
                            System.out.println("not an option!");
                            printMenu();
                    }
                }
                catch (IPWorksMQException e)
                {
                    System.err.println(e);
                }
            }
        }
        catch (Exception e)
        {
            System.err.println(e);
        }
    }

    private static void printMenu()
    {
        System.out.println("\r\n?\t-\tHelp\n" +
                "lst\t-\tList Topics\n" +
                "lss\t-\tList Subscriptions\n" +
                "mk\t-\tCreate Topic\n" +
                "del\t-\tDelete Topic\n" +
                "sub\t-\tSubscribe\n" +
                "unsub\t-\tUnSubscribe\n" +
                "pub\t-\tPublish\n" +
                "q\t-\tQuit\n");
    }

    private static String input() throws IOException
    {
        BufferedReader bf = new BufferedReader(new InputStreamReader(System.in));
        return bf.readLine();
    }
}

class SnsEvents implements AmazonSNSEventListener {
    @Override
    public void error(AmazonSNSErrorEvent amazonSNSErrorEvent) { }

    @Override
    public void log(AmazonSNSLogEvent amazonSNSLogEvent) { }

    @Override
    public void SSLServerAuthentication(AmazonSNSSSLServerAuthenticationEvent amazonSNSSSLServerAuthenticationEvent) { }

    @Override
    public void SSLStatus(AmazonSNSSSLStatusEvent amazonSNSSSLStatusEvent) { }

    @Override
    public void subscriptionList(AmazonSNSSubscriptionListEvent amazonSNSSubscriptionListEvent)
    {
        System.out.println("topic ARN: " + amazonSNSSubscriptionListEvent.topicArn);
        System.out.println("subscription ARN: " + amazonSNSSubscriptionListEvent.subscriptionArn);
        System.out.println("endpoint: " + amazonSNSSubscriptionListEvent.endpoint);
        System.out.println("owner: " + amazonSNSSubscriptionListEvent.owner);
        switch (amazonSNSSubscriptionListEvent.protocol)
        {
            case 0:
                System.out.println("EndPoint protocol: email");
                break;
            case 1:
                System.out.println("EndPoint protocol: email-json");
                break;
            case 2:
                System.out.println("EndPoint protocol: http");
                break;
            case 3:
                System.out.println("EndPoint protocol: https");
                break;
            case 4:
                System.out.println("EndPoint protocol: SMS");
                break;
            case 5:
                System.out.println("EndPoint protocol: SQS");
                break;
            default:
                System.out.println("not known protocol");
        }
        System.out.println("-----------------------------------------------------------------------------------------");
    }

    @Override
    public void topicList(AmazonSNSTopicListEvent amazonSNSTopicListEvent)
    {
        System.out.println(amazonSNSTopicListEvent.topicArn);
    }
}
class ConsoleDemo {
  private static BufferedReader bf = new BufferedReader(new InputStreamReader(System.in));

  static String input() {
    try {
      return bf.readLine();
    } catch (IOException ioe) {
      return "";
    }
  }
  static char read() {
    return input().charAt(0);
  }

  static String prompt(String label) {
    return prompt(label, ":");
  }
  static String prompt(String label, String punctuation) {
    System.out.print(label + punctuation + " ");
    return input();
  }
  static String prompt(String label, String punctuation, String defaultVal) {
      System.out.print(label + " [" + defaultVal + "]" + punctuation + " ");
      String response = input();
      if (response.equals(""))
        return defaultVal;
      else
        return response;
  }

  static char ask(String label) {
    return ask(label, "?");
  }
  static char ask(String label, String punctuation) {
    return ask(label, punctuation, "(y/n)");
  }
  static char ask(String label, String punctuation, String answers) {
    System.out.print(label + punctuation + " " + answers + " ");
    return Character.toLowerCase(read());
  }

  static void displayError(Exception e) {
    System.out.print("Error");
    if (e instanceof IPWorksMQException) {
      System.out.print(" (" + ((IPWorksMQException) e).getCode() + ")");
    }
    System.out.println(": " + e.getMessage());
    e.printStackTrace();
  }

  /**
   * Takes a list of switch arguments or name-value arguments and turns it into a map.
   */
  static java.util.Map<String, String> parseArgs(String[] args) {
    java.util.Map<String, String> map = new java.util.HashMap<String, String>();
    
    for (int i = 0; i < args.length; i++) {
      // Add a key to the map for each argument.
      if (args[i].startsWith("-")) {
        // If the next argument does NOT start with a "-" then it is a value.
        if (i + 1 < args.length && !args[i + 1].startsWith("-")) {
          // Save the value and skip the next entry in the list of arguments.
          map.put(args[i].toLowerCase().replaceFirst("^-+", ""), args[i + 1]);
          i++;
        } else {
          // If the next argument starts with a "-", then we assume the current one is a switch.
          map.put(args[i].toLowerCase().replaceFirst("^-+", ""), "");
        }
      } else {
        // If the argument does not start with a "-", store the argument based on the index.
        map.put(Integer.toString(i), args[i].toLowerCase());
      }
    }
    return map;
  }
}



