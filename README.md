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
    - The power of ansible
    - Inventory File
    - Vars
    - PlayBooks
    - Modules && Plugins
    - Roles
    - Security
    - Conclusion
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
