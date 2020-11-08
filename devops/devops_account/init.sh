echo "Creating a S3 bucket to store Terraform state"

export BUCKET="serverlesspizza-tf-state"
export DEVOPS_PROFILE="serverlesspizza-tf-devops"

aws s3 mb s3://$BUCKET --region eu-west-1 --profile $DEVOPS_PROFILE
aws s3api put-bucket-versioning --bucket $BUCKET --versioning-configuration Status=Enabled  --profile $DEVOPS_PROFILE
aws s3api put-bucket-encryption \
    --bucket $BUCKET \
    --server-side-encryption-configuration '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}' \
    --profile $DEVOPS_PROFILE
aws s3api put-bucket-policy \
    --bucket $BUCKET \
    --policy file://s3-state-bucket-policy.json \
    --profile $DEVOPS_PROFILE
aws s3api put-public-access-block \
    --bucket $BUCKET \
    --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"

echo "Creating a DynamoDB table to store Terraform state locks"
aws dynamodb create-table \
  --table-name "serverlesspizza-tf-locks" \
  --billing-mode PAY_PER_REQUEST \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --profile $DEVOPS_PROFILE
