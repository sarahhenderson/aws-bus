
class AwsBus

   configure: (AWS, @sqsUrl, @snsArn, @logger) ->
      throw new Error("No AWS object provided") if not AWS?
      throw new Error("No SQS queue url provided") if not @sqsUrl?
      throw new Error("No SNS topic arn provided") if not @snsArn?
      @sqs = new AWS.SQS()
      @sns = new AWS.SNS()


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

instance = new AwsBus()

module.exports = instance
