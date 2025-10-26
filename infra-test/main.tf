/*
    Entrypoint for "enterprise" foundational infrastructure.
*/

module "vpc" {
  source   = "../tf_modules/vpc"
  vpc_name = "KMH-Lab"
}
