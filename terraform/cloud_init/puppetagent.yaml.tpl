#cloud-config
hostname: ${agent_hostname}
fqdn: ${agent_hostname}.internal

manage_etc_hosts: true

write_files:
  - path: /etc/hosts
    append: true
    content: |
      ${server_ip} puppet-server puppet

runcmd:
  - curl -O https://apt.puppet.com/puppet8-release-$(lsb_release -cs).deb
  - dpkg -i puppet8-release-$(lsb_release -cs).deb
  - apt-get update
  - apt-get install -y puppet-agent
  - /opt/puppetlabs/bin/puppet config set server puppet-server --section main
  - /opt/puppetlabs/bin/puppet config set certname ${agent_hostname} --section main
  - systemctl enable puppet
  - systemctl start puppet
  - /opt/puppetlabs/bin/puppet agent -t --waitforcert 60 || true