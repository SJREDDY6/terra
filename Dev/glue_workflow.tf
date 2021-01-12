module "glue_workflow_simple" {
  source        = "../modules/glue-workflow"
  workflow_name = "etl-workflow-simple"
  security_name = "glueSecurityConfigSimple"
}

###################### Glue Triggers ########################################

resource "aws_glue_trigger" "start_raw" {
  name = "start_raw"
  type = "ON_DEMAND"
  workflow_name = module.glue_workflow_simple.workflow_name
  actions {
    job_name = module.ds1_raw_to_refined_job.job_name
  }
}

resource "aws_glue_trigger" "run_landing" {
  name = "run_landing"
  type = "CONDITIONAL"
  workflow_name = module.glue_workflow_simple.workflow_name
  actions {
    job_name = module.ds1_refined_to_curated_job.job_name
  }

  predicate {
    conditions {
      job_name = module.ds1_raw_to_refined_job.job_name
      state    = "SUCCEEDED"
    }
  }
}
