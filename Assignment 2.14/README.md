Does SNS guarantee exactly once delivery to subscribers?

Amazon SNS does not guarantee exactly-once delivery for standard topics. For standard topics, it offers "at least once" delivery, meaning a message might be delivered more than once to a subscriber due to retries or transient network issues.

However, Amazon SNS FIFO topics (First-In, First-Out) do support exactly-once message delivery and processing when messages are delivered to Amazon SQS FIFO queues as subscribers. This requires certain conditions to be met, such as the SQS FIFO queue existing with correct permissions, the consumer processing and deleting the message before its visibility timeout expires, and no message filtering configured on the SNS subscription.

What is the purpose of the Dead-letter Queue (DLQ)? This is a feature available to SQS/SNS/EventBridge.

DLQs provide a mechanism to isolate and store messages that have failed processing after a certain number of retry attempts. This prevents these "poison messages" from endlessly looping and blocking the main queue/delivery mechanism. Developers can then inspect the messages in the DLQ to understand why they failed (e.g., malformed data, downstream service errors, missing permissions) and debug the issue.

Without a DLQ, messages that consistently fail delivery might be dropped or lost. A DLQ ensures that these undelivered messages are retained, allowing for later analysis, manual intervention, or re-processing once the underlying issue is resolved.

How would you enable a notification to your email when messages are added to the DLQ?

You can enable email notifications when messages are added to a DLQ using a combination of Amazon CloudWatch Alarms and Amazon SNS.

Configure CloudWatch Alarms

1. Go to the CloudWatch console.
2. Navigate to "Alarms" and then "Create alarm."
3. Select "SQS" as the service.
4. Choose a metric for this SQS (DLQ) that needs notification enabled
5. Select the DLQ you want to monitor.
6. Configure the Threshold . This ensures there is a trigger to the alarm when the threshold value is reached (no.of  
   messages)
7. Configure the Period (e.g., 1 minute, 5 minutes) and Evaluation Periods (how many consecutive periods the threshold
   must be breached to trigger the alarm).

Configure an SNS Topic for Notifications:

8. In the CloudWatch alarm setup, for the "Notification" action, select an existing SNS topic or create a new one.
9. Add an email subscription to this SNS topic.
   Confirm to the subscription email received to continue receiving notifications.
