terraform {
  backend "remote" {
    organization = "Relaycorp"

    workspaces {
      name = "letro-server"
    }
  }
}
