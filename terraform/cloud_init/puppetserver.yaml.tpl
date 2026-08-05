#cloud-config
hostname: ${hostname}
fqdn: ${hostname}.internal

package_update: true

runcmd:
  - curl -O https://apt.puppet.com/puppet8-release-$(lsb_release -cs).deb
  - dpkg -i puppet8-release-$(lsb_release -cs).deb
  - apt-get update
  - apt-get install -y puppetserver
  - sed -i 's/JAVA_ARGS="-Xms2g -Xmx2g/JAVA_ARGS="-Xms512m -Xmx512m/' /etc/default/puppetserver
  - systemctl enable puppetserver
  - systemctl start puppetserver

write_files:
  - path: /etc/puppetlabs/puppet/puppet.conf
    append: true
    content: |
      [main]
      certname = ${hostname}
      dns_alt_names = ${hostname},puppet