# @summary Role for app-tier VMs: Docker + nginx container.
class role::app_server {
  include profile::nginx_container
}