AWS = require('aws-sdk')

class AwsBus

   configure: (@sqsUrl, @snsArn, @region, @logger) ->
      throw new Error("No SQS queue url provided") if not @sqsUrl?
      throw new Error("No SNS topic arn provided") if not @snsArn?
      throw new Error("No region provided") if not @region?
      @sqs = new AWS.SQS( { region: @region } )
      @sns = new AWS.SNS( { region: @region } )


   send: (message, done) ->

      sqsMessage =
         MessageBody : JSON.stringify(message)
         QueueUrl: @sqsUrl

      @logger.debug "AwsBus: About to send to SQS" if @logger?

      @sqs.sendMessage sqsMessage, (err) =>
         if err
            @logger.error "AwsBus: SQS ERROR" if @logger?
            @logger.error err if @logger?
            return done(err)

         @logger.debug "AwsBus: Sent to SQS" if @logger?

         snsMessage =
            Message: 'Notification'
            TopicArn: @snsArn

         @logger.debug "AwsBus: About to publish to SNS" if @logger?

         @sns.publish snsMessage, (err) =>
            if err
               @logger.error "AwsBus: SNS ERROR" if @logger?
               @logger.error err if @logger?
               return done(err)

            @logger.debug "AwsBus: Published to SNS" if @logger?
            done(null)

module.exports = new AwsBus()
