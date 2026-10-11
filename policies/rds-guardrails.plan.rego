package spacelift

import rego.v1

allowed_classes := {"db.t4g.medium", "db.r7g.large", "db.r7g.2xlarge"}

# Creates, updates and replacements; plain deletes have no "after" state.
db_changes contains rc if {
  some rc in input.terraform.resource_changes
  rc.type == "aws_db_instance"
  some action in rc.change.actions
  action in {"create", "update"}
}

deny contains sprintf("%s: public access is not allowed", [rc.change.after.identifier]) if {
  some rc in db_changes
  rc.change.after.publicly_accessible
}

deny contains sprintf("%s: storage must be encrypted", [rc.change.after.identifier]) if {
  some rc in db_changes
  not rc.change.after.storage_encrypted
}

deny contains sprintf("%s: instance class %s is not approved", [rc.change.after.identifier, rc.change.after.instance_class]) if {
  some rc in db_changes
  not rc.change.after.instance_class in allowed_classes
}

deny contains sprintf("%s: missing Owner tag", [rc.change.after.identifier]) if {
  some rc in db_changes
  not rc.change.after.tags.Owner
}
