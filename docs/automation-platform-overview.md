# Overview

Day 2 of the Ansible Workshop is all about the Ansible Automation Platform and usage of the Ansible Automation Controller.

<figure markdown>
  ![Ansible Automation Platform Logo](assets/images/rh-ansible-automation-platform.png "http://github.com/ansible/logos"){ loading=lazy }
  <figcaption></figcaption>
</figure>

You will complete the following exercises today:

* [Exercise 1 - Introduction][aap-intro]
* [Exercise 2 - Inventories, credentials and ad hoc commands][aap-inventory]
* [Exercise 3 - Projects & Job Templates][aap-projects]
* [Exercise 4 - Surveys][aap-surveys]
* [Exercise 5 - Role-based access control][aap-rbac]
* [Exercise 6 - Workflows][aap-workflows]
* [Exercise 7 - AAP Wrap up][aap-wrapup]

Here are some additional information of the the Ansible Automation Platform:

## What's New in Ansible automation controller 4.0

Ansible Automation Platform 2 is the next evolution in automation from Red Hat’s trusted enterprise technology experts. The Ansible Automation Platform 2 release includes automation controller 4.0, the improved and renamed Ansible Tower.

Controller continues to provide a standardized way to define, operate, and delegate automation across the enterprise. It introduces new technologies and an enhanced architecture that enables automation teams to scale and deliver automation rapidly.

### Why was Ansible Tower renamed to automation controller?

As Ansible Automation Platform 2 continues to evolve, certain functionality has been decoupled (and will continue to be decoupled in future releases) from what was formerly known as Ansible Tower. It made sense to introduce the naming change that better reflects these enhancements and the overall position within the Ansible Automation Platform suite.

### Who is automation controller for?

All automation team members interact with or rely on automation controller, either directly or indirectly.

* Automation creators develop Ansible playbooks, roles, and modules.
* Automation architects elevate automation across teams to align with IT processes and streamline adoption.
* Automation operators ensure the automation platform and framework are operational.

These roles are not necessarily dedicated to a person or team. Many organizations assign multiple roles to people or outsource specific automation tasks based on their needs.

Automation operators are typically the primary individuals who interact directly with the automation controller, based on their responsibilities.

### Automation mesh

Automation mesh is an overlay network intended to ease the distribution of work across a large and dispersed collection of workers. Mesh nodes establish peer-to-peer connections with each other across your existing networks bringing automation closer to the endpoints that need it.

<figure markdown>
  ![Automation mesh](assets/images/mesh_logical.png){ width="400" .off-glb loading=lazy }
  <figcaption></figcaption>
</figure>
