aws-bus
===============

Sends a message to an SQS queue and send a notification to an SNS topic

Why?
----

I want to process low frequency items in an SQS Queue, but I'd rather not poll every 20 seconds.
I also want the option of having my queue processor deployed as a Lambda function which can be configured with an SNS topic as an event source (but not an SQS Queue).
I could configure my SNS topic to publish to my SQS Queue, but the lambda function gets notified simultaneously and processes before the queue is populated.

How?
----

This aws-bus first sends a message to an SQS queue, and then publishes a notification to an SNS topic.

Any processor (such as a Lambda function, or a long running process with an http notification endpoint) can subscribe to the SNS topic and receive a notification when there is a new item added to the processing queue.

The payload is sent to the queue only.  SNS receives an empty notification, as it's main purpose is just to trigger the handler to check the queue.   Using the queue as the primary delivery mechanism ensures a bit more reliability in terms of making sure every message is processed at least once.

I tend to create the queue and the topic with the same name and in the same region to make it easier to understand.

Usage
-----

Not currently in npm.  Use the git url to add to package.json.

Sometime before you use it (i.e. during your application start up):

```javascript
var awsbus = require('aws-bus');
awsbus.configure(queueUrl, topicArn, region);
```

To use it, simply call the send message, passing your payload:

```javascript
awsbus.send(message, function(err) {
   // Handle error
   console.log("Message Sent");
});
```

If your AWS credentials are not provided through an IAM Role or similar, you should require the `aws-sdk` and configure the credentials before you configure the awsbus.

There is an optional fourth parameter you can pass to the configure method: an instance of a `winston` logger.  If this is present, the component will log some debug messages and any errors it encounters.  Useful during debugging.  Any other logger that has `error` and `debug` methods would also work.
   
   
Licence
-------

GPLv2
