# Default: nodes that don't match anything below get nothing applied.
node default { }

# App VMs — matches nginx-dev-vm01, nginx-dev-vm02, nginx-dev-vm03, etc.
node /^nginx-dev-vm\d+$/ {
  include role::app_server
}