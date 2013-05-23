# vim: tabstop=2 shiftwidth=2 softtabstop=2

# Module: 'debootstrap'
# Author: Morphlabs - Aimon Bustardo <abustardo at morphlabs dot com>
# Descr:  Puppet Module for managing Chrooted apps via 'debootstrap'

Puppet::Type.type(:debootstrap).provide(:debootstrap) do
  desc "Puppet inerface to debootstrap binary. Manages chroot envs on Ubuntu"

  commands :debootstrap => "/usr/sbin/debootstrap", :mount => "/bin/mount", :umount => "/bin/umount", :rm => "/bin/rm", :schroot => "/usr/bin/schroot"
  

  def name
    resource[:name]
  end

  def target
    resource[:target]
  end

  def suite
    resource[:suite]
  end
  
  def arch
    resource[:arch]
  end
  
  def variant
    resource[:variant]
  end

  def includes
    resource[:includes]
  end

  def exclude
    resource[:exclude]
  end

  def components
    resource[:components]
  end

  def mirror
    resource[:mirror]
  end

  def create
    # Build opts
    opts=Array.new
    opts << '--include' << includes if not includes.empty?
    opts << '--exclude' << exclude if not exclude.empty?
    opts << '--components' << components if not components.empty?
    opts << '--variant' << variant << '--arch' << arch << suite << target << mirror
    # Directories, mounts and fstab are created in wrapper function for this provider
    Dir.mkdir(target) unless File.directory?(target)
    debootstrap(*opts)
  end

  def destroy
    # Directories, mounts, confs and fstab are created in wrapper function for this provider
    # Destroy chroot
    begin
      schroot('-e', '-c', "sess_#{name.gsub('_', '-')}")
    rescue
      #Already stopped
    end
    rm('-rf', '--one-file-system', target)
  end
 
  def exists?
    if File.directory?(target)
      if File.exist?("#{target}/etc/init.d/urandom")
        return true
      end
    end
    return false
  end
end
