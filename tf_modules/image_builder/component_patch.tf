

resource "aws_imagebuilder_component" "patch_component" {
  name     = "${var.resource_prefix}-patch"
  platform = "Linux"
  version  = "0.1.0"

  data = yamlencode({
    schemaVersion = 1.0
    phases = [{
      name = "build"
      steps = [{
        action = "ExecuteBash"
        inputs = {
          commands = ["dnf update", "dnf upgrade -y"]
        }
        name      = "Patch-DNF"
        onFailure = "Continue"
      }]
    }]
  })

  tags = {
    "KMH:Name" = "patch-component"
  }
}
