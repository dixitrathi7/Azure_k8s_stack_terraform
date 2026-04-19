locals {
  common_tags = {

    project = "${var.rg_name}"
    Application = "${var.app_name}"
    ENV = "${var.env_name}"
    Created-by = "${var.user_name}"
    STACK = "${var.stack_name}"
  }
}