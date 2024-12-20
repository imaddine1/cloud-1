# Deploy An Application using Ansible && cloud provider (DigitalOcean)

## Introduction to Ansible

Ansible is an open-source automation tool used for IT tasks such as:
- Provisioning: Setting up servers, storage, and networking resources.
- Configuration Management: Managing system configurations automatically.
- Application Deployment: Deploying and managing software applications.
- Network Automation: Automating network devices and operations.

## Playground: Experiment with Ansible Using a Local VM

This [repo](https://github.com/imaddine1/virtualBox-automated) has a similar setup to this project. I created it to help you explore different Ansible concepts without connecting to a real cloud VM. This way, you can apply your ideas with ease and peace of mind

## Project Overview

This project builds on the recent "Inception" project by extending its functionality with a custom PHPMyAdmin service. The key improvements include:
Custom Docker Image for PHPMyAdmin:
A new Docker image was created specifically for PHPMyAdmin.
Nginx was reconfigured to forward PHP requests to the appropriate PHPMyAdmin container.
You can use already made images from DockerHub.

## What You need to learn in ansible to satisfy the requirement of the subject

These concepts that I will cover, you will use them, so pay attention to each headline and try to understand it before moving to the next one. They may seem separate and meaningless at first glance, but after we combine them, they will make sense.

<details>
    <summary>The Concepts that I will cover</summary>

* [X] The power of ansible
* [X] Inventory File
* [X] Vars
* [X] PlayBooks
* [X] Modules && Plugins
* [ ] Roles
* [ ] Security
* [ ] Conclusion
</details>


## The Power Of Ansible

Ansible's `agentless` nature means it does not require installing any software or agent on the managed systems (remote VMs)
Its ease of use comes from its human-readable syntax, which leverages `YAML files` called playbooks. 
`Idempotency` ensures that tasks in Ansible only apply changes when necessary. This means if a system is already in the desired state, Ansible will not make any modifications, preventing unnecessary actions and maintaining consistent environments.
There is others things about it , but knowing these powers is enough for now.

## Inventory File

An Ansible inventory file lists the hosts or servers to be managed. It organizes systems into groups and defines connection details, enabling Ansible to target specific machines for tasks. The file can be static `(INI, YAML)` or dynamic, supporting scalable infrastructure automation.

Example of inventory.ini File

```
mail.example.com

[webservers]
foo.example.com
bar.example.com

[dbservers]
one.example.com
two.example.com
three.example.com

```

So this example uses two groups `(webservers, dbservers)` and one host. When we discuss `playbooks`, you will understand why we use groups. They combine a set of hosts, and when you want to call them, you use the name of the group.
The inventory file i used in my project is slightly different, because i use the `variables` but it serve the same concept.
I used the variables there to give Ansible enough data to connect to my remote VMs.

`` As you can see, this file helps Ansible identify the names of remote virtual machines to connect to them  ``

[For_More_Things_About_Inventory_CLick_Me](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html)

## Vars

In Ansible, variables store values like file paths, usernames, or configurations, making playbooks more dynamic and reusable. Variables follow a `precedence order`, with values from `command-line arguments or extra-vars` having the highest priority. You can define variables in `inventory files`(like i did in the inventory.ini above), playbooks, role: (defaults, host_vars, group_vars), and Ansible Vault for secure storage.

You may not again know all this stuff but be patient, just knowing we are using Variables is more than enough.

[You_Can_Learn_More_About_Variables_Here](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html)

## PlayBooks

Now, we are on the most important section, where you'll interact with it a lot, and it is the core of Ansible. This part is responsible for communicating with your remote VMs using `YAML syntax` and giving them all the instructions to install what you need on those remote VMs

Example Of a Playbook:

```
---

#------------------------------------------ First Plays ------------------ #
- name: Update web servers                                
  hosts: webservers                                         
  remote_user: root                                               
    
  tasks:                                                     
  - name: Ensure apache is at the latest version              
    ansible.builtin.apt:                                     
      name: httpd                                          
      state: latest

  - name: Write the apache config file                        
    ansible.builtin.template:                              
      src: /srv/httpd.j2                                     
      dest: /etc/httpd.conf                                 
# ---------------------------------------Second Plays ----------------#
- name: Update db servers
  hosts: databases
  remote_user: root

  tasks:
  - name: Ensure postgresql is at the latest version
    ansible.builtin.yum:
      name: postgresql
      state: latest

  - name: Ensure that postgresql is started
    ansible.builtin.service:
      name: postgresql
      state: started

```

- the keyword start wiht `- name` is like a `comment` describing what y'll do 
- the keyword `hosts` can take name of group from `inventory file`
- The PlayBook can have multiple `plays` means connect to a specific host or hosts and apply to them what inside `tasks`
- The `tasks` keywords udner it `- name` under it the name of the `module` like `ansible.builtin.yum`, those modules have some arguments,
    and that module executed inside the remote Vms

There is a bunch of differents `attributes` you can use, and thousands of built-in `modules` , we'll talk about them later

You can ran the playbook by using this command `` ansible-playbook -i inventory.ini playbook.yml ``

## Modules && Plugins

`Modules` is a python script executed on the `remote machine`, so when i type inside my playbook :
```
- name: install vim
  apt:
    name: vim
    state: present 
```

I can call `Module` using ansible `ad-hoc (command line interface)` like:

```
ansible webservers -m apt -a "name:vim state: present"
``` 

The Module `apt` with `argument`, you can know every Module what parameters takes, by clicking on `HERE` below .
The Module transfered from `master node (my machine where you installed ansible)` to remote node using `SSH` and executed , and each module must return json fromat.
The Module return result `changed, failed, msg, and other detials`, There is a thousands of modules created by ansible and the community , You can check The list of Modules [HERE](https://docs.ansible.com/ansible/latest/collections/index_module.html)
You can write your own Module with any language that return json format and you can use `Modules` from other plate-form or customized them.

`Plugins` is a python script also , most of plugins executed on the `master node (controler node)`, and just an information to know,
You can call `Module` as `plugin task or plugin library`, they also say that module is a `type` of plugins,
You can Create your own Module but you need to respect this rules:
- be written in Python
- raise errors
- return strings in unicode
- conform to Ansible’s configuration and documentation standards

There is different Types of Plugins , You can Check [HERE](https://docs.ansible.com/ansible/latest/plugins/plugins.html)

Just To Demonstrate the output you see , when you execute a playbook, the output is is formatted by a `plugin` ,  and you can change the format 
of the output , you need to read about `ansible config file` if you want, I'll not talk about it , but you can check it [HERE](https://docs.ansible.com/ansible/latest/reference_appendices/config.html)  





