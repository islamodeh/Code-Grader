require 'docker'

namespace :os do
  task prepare_c_vm: :environment do
    prepare_c_vm
  end
end

def get_ubuntu_image
  image_id = 'ubuntu@sha256:bec5a2727be7fff3d308193cfde3491f8fba1a2ba392b7546b43a051853a341d'
  if  Docker::Image.exist?(image_id)
    puts "Ubuntu Image already exist"
    Docker::Image.get(image_id)
  else
    puts "Creating new ubuntu image using #{image_id}"
    image = Docker::Image.create({ 'fromImage' => image_id })
  end
end

def prepare_c_vm
  existing_images = Docker::Image.all.map(&:info).map{ |h| h["RepoTags"] }.flatten.compact
  image_tag = "c_vm"

  if existing_images.any? { |e| e.include? image_tag }
    puts "Image #{image_tag} already exist"
    return
  end

  begin
    image = get_ubuntu_image

    puts 'Starting container'
    vm_container = Docker::Container.create({ 'Image' => image.id, 'tty' => true })
    vm_container.start
    update_vm_command = 'apt-get update -y; apt-get upgrade -y; apt-get install htop gcc g++ -y;'
    puts "running command #{update_vm_command}"
    puts vm_container.exec(['bash', '-c', update_vm_command])
    puts "puts commiting to c_vm"
    vm_container.commit({ repo: "c_vm" })
    puts "Deleting container"
    vm_container.delete(force: true)
  rescue StandardError => e
    puts "ERROR: #{e}"
  end  
end