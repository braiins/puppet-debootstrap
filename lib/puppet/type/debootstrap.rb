# vim: tabstop=2 shiftwidth=2 softtabstop=2

# Module: 'debootstrap'
# Author: Morphlabs - Aimon Bustardo <abustardo at morphlabs dot com>
# Descr:  Puppet Module for managing Chrooted apps via 'debootstrap'

Puppet::Type.newtype(:debootstrap) do
  @doc = "Puppet interface to debootstrab binary. Manages chroot environments on Ubuntu"

  ensurable

  newparam(:name, :namevar => :true) do
     desc "The name of the chroot to create."
     newvalues(/^([a-z0-9][a-z0-9_.-]+)$/i)
  end 

  newproperty(:target) do
     desc "The fully qualified path of the chroot base"
     newvalues(/^(.*?\/|.*?\\)?([^\.\/|^\.\\]+)(?:\.([^\\]*)|)$/i)
  end 
  
  newproperty(:suite) do
    desc "Ubuntu release name. Example: precise"
    defaultto('precise')
    newvalues(/^((precise)|(lucid)|(jaunty)|(hardy)|(feisty))$/i)
  end

  newproperty(:arch) do
    desc "Chroot OS architecture. This does not have to match the host OS, but ensure the processor support 64 bit if it chosen. Valid values: 'amd64' or 'i386'"
    newvalues(/^((i386)|(amd64))$/) 
  end

  newproperty(:variant) do
    desc "Use variant X of the bootstrap scripts. (currently supported variants: buildd, fakechroot, scratchbox, minbase)"
    defaultto('buildd')
    newvalues(/^((buildd)|(fakechroot)|(minbase)|(scratchbox))$/) 
  end
 
  newproperty(:includes) do
    desc "Adds specified names to the list of base packages"
    defaultto(false)
  end
  
  newproperty(:exclude) do
    desc "Removes specified names to the list of base packages"
    defaultto(false)
  end
  
  newproperty(:components) do
    desc "use packages from the listed components of the archive"
    defaultto(false)
  end

  newproperty(:mirror) do
    desc "Ubuntu HTTP mirror."
    validate do |pth|
      unless pth.match(/^((http(s)?:\/\/).*)/i)
        raise ArgumentError, "Unsupported protocol: #{pth} (expected 'http:' or 'https' )"
      end
    end
  end 
  
end
