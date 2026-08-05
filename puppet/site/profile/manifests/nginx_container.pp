# @summary Runs the default nginx image as a Docker container.
class profile::nginx_container (
  String $image = lookup('profile::nginx_container::image', String, 'first', 'nginx:latest'),
) {
  include profile::docker

  docker::run { 'nginx':
    image           => $image,
    ports           => ['80:80'],
    restart_service => true,
    require         => Class['profile::docker'],
  }
}