resource "aws_glue_crawler" "datalake_crawler" {
  database_name = "${var.glue_db_name}"
  name          = "${var.crawler_name}"
  role          = "${aws_iam_role.glue.id}" 

  s3_target {
    path = "${var.data_source_path_1}"
  }

  s3_target {
    path = "${var.data_source_path_2}"
  }
}