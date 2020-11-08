echo "Creating a DynamoDB table to store Terraform state locks"
aws dynamodb create-table \
  --table-name "serverlesspizza-tf-locks" \
  --billing-mode PAY_PER_REQUEST \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --profile serverlesspizza-tf-prod
