provider "aws" {
  region     = var.region
}

resource "null_resource" "import" {
  count = var.phase == "ONE" ? 1 : 0
  provisioner "local-exec" {
    command = "unset TF_LOG;export TF_VAR_region=${var.region} TF_VAR_iam_profile=${var.iam_profile} TF_VAR_instance_id=${var.instance_id};terraform import -allow-missing-config aws_instance.add_iam ${var.instance_id};terraform show -no-color | grep -v -e arn -e instance_state -e ' id ' -e volume_id -e public_dns -e primary_network_interface_id -e private_dns -e public_ip | sed -e '1d' -e '/availability_zone/i iam_instance_profile = \"${var.iam_profile}\"' > instance.tf;ls -l;cat instance.tf;export TF_VAR_phase=TWO;terraform apply -auto-approve -lock=false"
  }
}
