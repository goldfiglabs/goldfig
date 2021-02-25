-- migrate:up
ALTER TABLE aws_acm_certificate ADD COLUMN _tags JSONB;
ALTER TABLE aws_apigateway_restapi ADD COLUMN _tags JSONB;
ALTER TABLE aws_apigateway_stage ADD COLUMN _tags JSONB;
ALTER TABLE aws_apigatewayv2_api ADD COLUMN _tags JSONB;
ALTER TABLE aws_apigatewayv2_stage ADD COLUMN _tags JSONB;
ALTER TABLE aws_autoscaling_autoscalinggroup ADD COLUMN _tags JSONB;
ALTER TABLE aws_cloudfront_distribution ADD COLUMN _tags JSONB;
ALTER TABLE aws_cloudformation_stack ADD COLUMN _tags JSONB;
ALTER TABLE aws_dynamodb_table ADD COLUMN _tags JSONB;
ALTER TABLE aws_ec2_instance ADD COLUMN _tags JSONB;
ALTER TABLE aws_ec2_volume ADD COLUMN _tags JSONB;
ALTER TABLE aws_ec2_image ADD COLUMN _tags JSONB;
ALTER TABLE aws_ec2_securitygroup ADD COLUMN _tags JSONB;
ALTER TABLE aws_ec2_keypair ADD COLUMN _tags JSONB;
ALTER TABLE aws_ec2_vpc ADD COLUMN _tags JSONB;
ALTER TABLE aws_ec2_vpcpeeringconnection ADD COLUMN _tags JSONB;
ALTER TABLE aws_ec2_flowlog ADD COLUMN _tags JSONB;
ALTER TABLE aws_ec2_subnet ADD COLUMN _tags JSONB;
ALTER TABLE aws_ec2_routetable ADD COLUMN _tags JSONB;
ALTER TABLE aws_ec2_networkinterface ADD COLUMN _tags JSONB;
ALTER TABLE aws_ec2_snapshot ADD COLUMN _tags JSONB;
ALTER TABLE aws_ec2_address ADD COLUMN _tags JSONB;
ALTER TABLE aws_ecr_repository ADD COLUMN _tags JSONB;
ALTER TABLE aws_ecs_task ADD COLUMN _tags JSONB;
ALTER TABLE aws_ecs_cluster ADD COLUMN _tags JSONB;
ALTER TABLE aws_ecs_service ADD COLUMN _tags JSONB;
ALTER TABLE aws_ecs_taskdefinition ADD COLUMN _tags JSONB;
ALTER TABLE aws_eks_cluster ADD COLUMN _tags JSONB;
ALTER TABLE aws_eks_nodegroup ADD COLUMN _tags JSONB;
ALTER TABLE aws_elasticbeanstalk_application ADD COLUMN _tags JSONB;
ALTER TABLE aws_elasticbeanstalk_applicationversion ADD COLUMN _tags JSONB;
ALTER TABLE aws_elasticbeanstalk_environment ADD COLUMN _tags JSONB;
ALTER TABLE aws_elb_loadbalancer ADD COLUMN _tags JSONB;
ALTER TABLE aws_elbv2_loadbalancer ADD COLUMN _tags JSONB;
ALTER TABLE aws_elbv2_targetgroup ADD COLUMN _tags JSONB;
ALTER TABLE aws_es_domain ADD COLUMN _tags JSONB;
ALTER TABLE aws_iam_user ADD COLUMN _tags JSONB;
ALTER TABLE aws_iam_role ADD COLUMN _tags JSONB;
ALTER TABLE aws_kms_key ADD COLUMN _tags JSONB;
ALTER TABLE aws_lambda_function ADD COLUMN _tags JSONB;
ALTER TABLE aws_logs_loggroup ADD COLUMN _tags JSONB;
ALTER TABLE aws_organizations_account ADD COLUMN _tags JSONB;
ALTER TABLE aws_rds_dbinstance ADD COLUMN _tags JSONB;
ALTER TABLE aws_rds_dbcluster ADD COLUMN _tags JSONB;
ALTER TABLE aws_rds_dbsnapshot ADD COLUMN _tags JSONB;
ALTER TABLE aws_rds_dbclustersnapshot ADD COLUMN _tags JSONB;
ALTER TABLE aws_redshift_cluster ADD COLUMN _tags JSONB;
ALTER TABLE aws_route53_hostedzone ADD COLUMN _tags JSONB;
ALTER TABLE aws_s3_bucket ADD COLUMN _tags JSONB;
ALTER TABLE aws_ssm_parameter ADD COLUMN _tags JSONB;
ALTER TABLE aws_cloudtrail_trail ADD COLUMN _tags JSONB;
ALTER TABLE aws_cloudwatch_metricalarm ADD COLUMN _tags JSONB;
ALTER TABLE aws_cloudwatch_compositealarm ADD COLUMN _tags JSONB;
ALTER TABLE aws_sns_topic ADD COLUMN _tags JSONB;
ALTER TABLE aws_sqs_queue ADD COLUMN _tags JSONB;


-- migrate:down
ALTER TABLE aws_acm_certificate DROP COLUMN _tags;
ALTER TABLE aws_apigateway_restapi DROP COLUMN _tags;
ALTER TABLE aws_apigateway_stage DROP COLUMN _tags;
ALTER TABLE aws_apigatewayv2_api DROP COLUMN _tags;
ALTER TABLE aws_apigatewayv2_stage DROP COLUMN _tags;
ALTER TABLE aws_autoscaling_autoscalinggroup DROP COLUMN _tags;
ALTER TABLE aws_cloudfront_distribution DROP COLUMN _tags;
ALTER TABLE aws_cloudformation_stack DROP COLUMN _tags;
ALTER TABLE aws_dynamodb_table DROP COLUMN _tags;
ALTER TABLE aws_ec2_instance DROP COLUMN _tags;
ALTER TABLE aws_ec2_volume DROP COLUMN _tags;
ALTER TABLE aws_ec2_image DROP COLUMN _tags;
ALTER TABLE aws_ec2_securitygroup DROP COLUMN _tags;
ALTER TABLE aws_ec2_keypair DROP COLUMN _tags;
ALTER TABLE aws_ec2_vpc DROP COLUMN _tags;
ALTER TABLE aws_ec2_vpcpeeringconnection DROP COLUMN _tags;
ALTER TABLE aws_ec2_flowlog DROP COLUMN _tags;
ALTER TABLE aws_ec2_subnet DROP COLUMN _tags;
ALTER TABLE aws_ec2_routetable DROP COLUMN _tags;
ALTER TABLE aws_ec2_networkinterface DROP COLUMN _tags;
ALTER TABLE aws_ec2_snapshot DROP COLUMN _tags;
ALTER TABLE aws_ec2_address DROP COLUMN _tags;
ALTER TABLE aws_ecr_repository DROP COLUMN _tags;
ALTER TABLE aws_ecs_task DROP COLUMN _tags;
ALTER TABLE aws_ecs_cluster DROP COLUMN _tags;
ALTER TABLE aws_ecs_service DROP COLUMN _tags;
ALTER TABLE aws_ecs_taskdefinition DROP COLUMN _tags;
ALTER TABLE aws_eks_cluster DROP COLUMN _tags;
ALTER TABLE aws_eks_nodegroup DROP COLUMN _tags;
ALTER TABLE aws_elasticbeanstalk_application DROP COLUMN _tags;
ALTER TABLE aws_elasticbeanstalk_applicationversion DROP COLUMN _tags;
ALTER TABLE aws_elasticbeanstalk_environment DROP COLUMN _tags;
ALTER TABLE aws_elb_loadbalancer DROP COLUMN _tags;
ALTER TABLE aws_elbv2_loadbalancer DROP COLUMN _tags;
ALTER TABLE aws_elbv2_targetgroup DROP COLUMN _tags;
ALTER TABLE aws_es_domain DROP COLUMN _tags;
ALTER TABLE aws_iam_user DROP COLUMN _tags;
ALTER TABLE aws_iam_role DROP COLUMN _tags;
ALTER TABLE aws_kms_key DROP COLUMN _tags;
ALTER TABLE aws_lambda_function DROP COLUMN _tags;
ALTER TABLE aws_logs_loggroup DROP COLUMN _tags;
ALTER TABLE aws_organizations_account DROP COLUMN _tags;
ALTER TABLE aws_rds_dbinstance DROP COLUMN _tags;
ALTER TABLE aws_rds_dbcluster DROP COLUMN _tags;
ALTER TABLE aws_rds_dbsnapshot DROP COLUMN _tags;
ALTER TABLE aws_rds_dbclustersnapshot DROP COLUMN _tags;
ALTER TABLE aws_redshift_cluster DROP COLUMN _tags;
ALTER TABLE aws_route53_hostedzone DROP COLUMN _tags;
ALTER TABLE aws_s3_bucket DROP COLUMN _tags;
ALTER TABLE aws_ssm_parameter DROP COLUMN _tags;
ALTER TABLE aws_cloudtrail_trail DROP COLUMN _tags;
ALTER TABLE aws_cloudwatch_metricalarm DROP COLUMN _tags;
ALTER TABLE aws_cloudwatch_compositealarm DROP COLUMN _tags;
ALTER TABLE aws_sns_topic DROP COLUMN _tags;
ALTER TABLE aws_sqs_queue DROP COLUMN _tags;
