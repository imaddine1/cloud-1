# Ansible Automation Project

## Introduction to Ansible

Ansible is an open-source automation tool used for IT tasks such as:

- Provisioning: Setting up servers, storage, and networking resources.

- Configuration Management: Managing system configurations automatically.

- Application Deployment: Deploying and managing software applications.

- Network Automation: Automating network devices and operations.

## Project Overview

This project builds on the recent "Inception" project by extending its functionality with a custom PHPMyAdmin service. The key improvements include:

Custom Docker Image for PHPMyAdmin:

A new Docker image was created specifically for PHPMyAdmin.

Nginx was reconfigured to forward PHP requests to the appropriate PHPMyAdmin container.

## Ansible Setup

Three main Ansible components were used:

### 1. Inventory

The Inventory is where you define the hosts that Ansible connects to and manages. These hosts are referred to as remote nodes or managed nodes in the Ansible world.

By leveraging these features, the project ensures a clean, modular, and scalable deployment proces

### 2. Playbook

The Ansible Playbook was employed to define tasks and manage the execution of automation scripts on remote nodes.

### 2. Ansible Roles

Roles in Ansible help organize tasks and files. While roles create multiple folders by default, only the following were used:

tasks/: This folder contains the automation tasks or plays that Ansible runs on the target nodes.

files/: This folder holds files to be copied to remote nodes as part of the automation process.
