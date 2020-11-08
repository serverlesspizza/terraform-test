const AWS = require('aws-sdk');

const sqs = new AWS.SQS({apiVersion: '2012-11-05'});
const queueName = 'serverlesspizza-' + process.env.ENVIRONMENT + '-pre-signup-lambda';
const accountId = process.env.ACCOUNT_ID;
const region = process.env.REGION;
const queueUrl = `https://sqs.${region}.amazonaws.com/${accountId}/${queueName}`;

AWS.config.update({region: region});

exports.handler = (event, context, callback) => {
	event.response.autoConfirmUser = true;

	const params = {
		MessageBody: JSON.stringify({
			email: event.request.userAttributes.email
		}),
		QueueUrl: queueUrl
	};

	sqs.sendMessage(params, (err, data) => {
		if (err) {
			console.log("Failed to send new user message to queue.", err);
		} else {
			console.log("Successfully added message", data.MessageId);
		}
	});

	// Return to Amazon Cognito
	callback(null, event);
};
