###################### Glue Jobs ########################################

module "ds1_raw_to_refined_job" {
  source = "../modules/glue-job/python_shell"

  name            = "ds1-raw-to-refined"
  role_arn        = module.glue_role.iam_role_arn
  script_location = "s3://${var.glue_bucket_name}/code"
  default_arguments = {
    "--extra-py-files"           = <<EOF
                                  s3://${var.glue_bucket_name}/code/ds1/raw_to_refined/dependencies/config.py,
                                  s3://${var.glue_bucket_name}/code/ds1/raw_to_refined/dependencies/glue_shared-0.0.1-py3-none-any.whl,
                              EOF
    "--job-bookmark-option"      = "job-bookmark-disable"
    "--APP_SETTINGS_ENVIRONMENT" = "dev"
    "--LOG_LEVEL"                = "DEBUG"
    "--S3_BUCKET" = var.glue_bucket_name
  }
  tags = var.tags
}

module "ds1_refined_to_curated_job" {
  source          = "../modules/glue-job/2.0"
  name            = "ds1-refined-to-curated"
  script_location = "s3://${var.glue_bucket_name}/code/ds1/refined_to_curated/refined_to_curated.py"
  role_arn        = module.glue_role.iam_role_arn
  default_arguments = {
    "--extra-py-files"           = "s3://${var.glue_bucket_name}/code/ds1/refined_to_curated/dependencies/refined_to_curated.zip"
    "--job-bookmark-option"      = "job-bookmark-disable"
    "--TempDir"                  = "s3://${var.glue_bucket_name}/glue-temp"
    "--job-language"             = "python"
    "--APP_SETTINGS_ENVIRONMENT" = "dev"
    "--LOG_LEVEL"                = "DEBUG"
    "--S3_BUCKET" = var.glue_bucket_name
  }
  number_of_workers = "2"
  tags              = var.tags
}
