package spacelift

import rego.v1

# Attached with the autoattach:env/prod label, so it only governs production stacks.
approve if {
  count(input.reviews.current.approvals) >= 1
  count(input.reviews.current.rejections) == 0
}

reject if count(input.reviews.current.rejections) > 0
