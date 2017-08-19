# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  # Enable proxy
  if Vagrant.has_plugin?("vagrant-proxyconf")
    if ENV["HTTP_PROXY"] || ENV["HTTPS_PROXY"] || ENV["http_proxy"] || ENV["https_proxy"]
      config.proxy.http     = ENV["HTTP_PROXY"] || ENV["http_proxy"]
      config.proxy.https    = ENV["HTTPS_PROXY"] || ENV["https_proxy"]
      config.proxy.no_proxy = "localhost,127.0.0.1"
      if ENV["NO_PROXY"] || ENV["no_proxy"]
        config.proxy.no_proxy += "," + (ENV["NO_PROXY"] || ENV["no_proxy"])
      end
    end
  end

  config.vm.box = "centos/7"

  config.vm.provider :virtualbox do |vbox|
    #vbox.cpus = 2
    #vbox.memory = 1024
    vbox.customize [
      "modifyvm", :id,
      "--hwvirtex", "on",               # Enable hardware virtualization extensions
      "--nestedpaging", "on",           # Enable nested paging feature
      "--largepages", "on",             # Use large pages (for Intel VT-x only)
      "--ioapic", "on",                 # Enable I/O APIC
      "--pae", "on",                    # Enable PAE/NX
      "--paravirtprovider", "kvm",      # Enable paravirtualization
    ]
  end

  config.vm.hostname = "centos"

  config.vm.synced_folder ".", "/vagrant", type: "virtualbox"

  config.vm.provision "ansible_local" do |ansible|
    ansible.playbook = "provision/default.yml"
    #ansible.verbose = "-vvv"
  end

end
