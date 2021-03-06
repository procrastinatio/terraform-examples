#!/bin/bash


JOB_QUEUE=aws_demo_batch_job-queue
JOB_DFN_ARN=arn:aws:batch:eu-west-1:050475232797:job-definition/aws_batch_demo_job:1


JOB_NAME=$(date +%Y%m%d-%H%M%S)


aws batch --profile mom_aws-admin-test1  submit-job \
    --job-name ${JOB_NAME} \
    --job-definition ${JOB_DFN_ARN} \
--job-queue  ${JOB_QUEUE} \
--container-overrides "vcpus=1,memory=256,command=myjob.sh,environment=[{name=JOB_NAME,value=${JOB_NAME},}{name=BATCH_FILE_TYPE,value=script},{name=BATCH_FILE_S3_URL,value=s3://ltmom-aws-batch-test/mapjob.sh}]"
