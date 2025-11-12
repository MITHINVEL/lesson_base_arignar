# Serverless Deployment Guide

## Prerequisites

1. **AWS CLI configured** with appropriate credentials:

   ```bash
   aws configure
   ```

2. **Environment variables set**:
   ```bash
   export API_KEY=your_actual_api_key_here
   ```
   Or create a `.env` file with your API key.

## Deployment Commands

### Deploy to Development

```bash
npm run deploy:dev
```

### Deploy to Production

```bash
npm run deploy:prod
```

### View Logs

```bash
npm run logs
```

### Remove Deployment

```bash
npm run remove
```

## What Gets Deployed

1. **Lambda Function**: Your Express API running on AWS Lambda
2. **API Gateway**: HTTP API endpoint for your Lambda function
3. **S3 Bucket**: Static files (HTML, JS, JSON) served from S3
4. **IAM Roles**: Automatically created execution roles

## Post-Deployment

After deployment, you'll get two URLs:

1. **API URL**: `https://xyz.execute-api.us-east-1.amazonaws.com/`

   - Use this for API calls: `/api/token?username=test`

2. **Static Files URL**: `http://bucket-name.s3-website-us-east-1.amazonaws.com/`
   - Your HTML files will be accessible here: `/sample.html`

## Environment Variables

Set these before deployment:

- `API_KEY`: Your API key for the tokens endpoint

## Cost Estimation

- **Lambda**: Free tier covers 1M requests/month
- **API Gateway**: $1 per million requests
- **S3**: ~$0.023 per GB storage + requests
- **Typical monthly cost for low traffic**: $0-5

## Troubleshooting

1. **Deployment fails**: Check AWS credentials and permissions
2. **CORS issues**: Update the `cors` configuration in `serverless.yml`
3. **Environment variables**: Ensure `API_KEY` is set before deployment
