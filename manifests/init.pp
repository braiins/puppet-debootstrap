# vim: tabstop=2 shiftwidth=2 softtabstop=2

# Module: 'debootstrap'
# Author: Morphlabs - Aimon Bustardo <abustardo at morphlabs dot com>
# Descr:  Puppet Module for managing Chrooted apps via 'debootstrap'

class debootstrap(){
  include debootstrap::packages

  define debootstrap::chroot(
    $vensure,
    $vtarget,
    $vusers,
    $vname=$title,
    $suite='precise',
    $arch='amd64',
    $variant='buildd',
    $includes=False,
    $exclude=False,
    $components=False,
    $mirror,
  ){
    # Directories
    exec{"/bin/mkdir -p ${vtarget}":
      creates =>  $vtarget,
    }
    # debootstrap
    debootstrap{$vname:
      ensure      =>  $vensure,
      target      =>  $vtarget,
      suite       =>  $suite,
      arch        =>  $arch,
      variant     =>  $variant,
      includes    =>  $includes,
      exclude     =>  $exclude,
      components  =>  $components,
      mirror      =>  $mirror,
      require     =>  [Exec["/bin/mkdir -p ${vtarget}"], Class[debootstrap::packages]],
    }
    # Schroot Confs
    file{"/etc/schroot/chroot.d/${vname}.conf":
      content =>  template("debootstrap/schroot.d.conf.erb"),
      mode    =>  '0660',
      owner   =>  root,
      group   =>  root,
      ensure  =>  $vensure,
      require =>  Debootstrap[$vname],
    }
  }
}
