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
* [X] Role
* [X] Security
* [X] Conclusion
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

__`Modules`__ is a python script executed on the `remote machine`, next is example of how we can use module apt:


Example 1: Use apt module inside a `YAML` file, to install vim

```
- name: install vim
  apt:
    name: vim
    state: present 
```

Example 2: Use apt Module with `ad-hoc` to install vim 

```
ansible webservers -m apt -a "name:vim state: present"

``` 



The Module `apt` have various `argument`, you can check every Module what parameters takes, by clicking on the link below .
The Module transfered from `master node (my machine where you installed ansible)` to remote node using `SSH` and executed , and each module must return json fromat.
The Module return result `changed, failed, msg, and other detials`, There is a thousands of modules created by ansible and the community , 
You can check The list of Modules [HERE](https://docs.ansible.com/ansible/latest/collections/index_module.html)
You can write your own Module with any language that return json format and you can use `Modules` from other plate-form or customized them.

__`Plugins`__ is a python script also , most of plugins executed on the `master node (controler node)`, and just an information to know,
You can call `Module` as `plugin task or plugin library`, they also say that module is a `type` of plugins,
You can Create your own Module but you need to respect this rules:
- be written in Python
- raise errors
- return strings in unicode
- conform to Ansible’s configuration and documentation standards

There is different Types of Plugins , You can Check [HERE](https://docs.ansible.com/ansible/latest/plugins/plugins.html)

Just To Demonstrate the output you see , when you execute a playbook, the output is formatted by a `plugin` ,  and you can change the format 
of the output , you need to read about `ansible config file` if you want, I'll not talk about it , but you can check it [HERE](https://docs.ansible.com/ansible/latest/reference_appendices/config.html)  


## Role
`__Ansible Role__` is like a structured way to organize your playbooks. It helps you break down tasks into smaller, 
reusable pieces, making your automation cleaner, easier to manage, and shareable.

You can create your Role by use the next command:

```
ansible-galaxy init nameFolder
```

and you will git this structure:

```
├── nameFolder/
    ├── tasks/         # List of tasks to execute
    ├── vars/          # Variables specific to the role
    ├── defaults/      # Default variables (can be overridden)
    ├── handlers/      # Handlers for notifications (e.g., restarting services)
    ├── templates/     # Jinja2 templates (e.g., config files)
    ├── files/         # Static files to copy from your machine to the targeted machines.
    ├── meta/          # Metadata about the role (dependencies, author info)
```
You can define Your `Role` inside the playbook like this:

```
- name: Install Some Packages
  hosts: name_of_groups_of_hosts
  roles:
    - nameFolder
```

I think all The Folders inside the nameFolder have a clear meaning except `templates/` folder, This folder can take files of format `jinja2`,
we use it , when we have a dynamic data like in my case i had two machines , and The `IP` of these two machines is different,
i added all my static varialbes then i set `IP` variable with `{{ansible_host}}` .
Jinja2 will understand that `{{ansible_host}}` need to be revealed , and that's what happen when i transfer my files inside templates/ folder
to the remote machines , before transfer them, it reveal all the dynamic variables 

If you want to read more about jinja2 templating [Check_Here](https://jinja.palletsprojects.com/en/stable/templates/)

Example of what inside my file data.j2, beacuse now is encrypted you can't see it:

```
##### database informations #######
MY_ROOT=root123
MY_DATABASE=wordpress
MY_USER=imad
MY_PASS=imad123
MY_HOST=db
#Admin User
AD_USER=supervisor
AD_EMAIL=supervisor@gmail.com
AD_PASS=supervisor123
BLOG_TITLE=INCEPTION
# SIMPLE USER 
SP_USER=user
SP_EMAIL=user@gmail.com 
SP_PASS=user123
   
#### THIS IP OFTEST VM IS ######
IP={{ ansible_host }}              ## This variable will be set by the right IP of the machine , ansible_host is inside inventory file
```

If you want to know more about Roles [Check_Here](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_reuse_roles.html)

## Security

This section will help you to secure your private data, like in my case i have data.j2 file inside it important variables, i used them
to login to my DataBase, PHPMyAdmin and Wordpress , so i used the command `ansible-vault` to encrypt my file:

```
ansible-vault encrypt yourFile
```

The real data that i had is `The Example above under Role section`, then i encrypt the file with the above command, in my case i used
`ansible.cfg` to set automatically where ansible can search about my password file, instead of provide it each time i run the `ansible-playbook` command


There is more than one way to encrypt your sensible data, so you can read about it [HERE](https://docs.ansible.com/ansible/latest/vault_guide/index.html)

## Conclusion

I hope this `ReadMe` file helps and guides you on the right path to learning ansible, There are some conecpts i didn't meantion like
`ansible collection` , `ansible tower` and `...Others` , I believe now you're equipped to search for anything you want to learn about ansible.

Regarding `(42 network)`, The correction page emphasizes creating separate role for each service, This `Repo` currently uses a single Role 
so changing it to multiple roles would be a great practice to follow.

Now I can say thank you For Reading , See Yaaaaa .