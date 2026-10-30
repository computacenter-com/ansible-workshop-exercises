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

## What is AAP?

Red Hat Ansible Automation Platform is an integrated solution for operationalizing Ansible across your team, organization, and enterprise. The platform includes a controller with a web console and REST API, analytics, Execution Environments, and much more.
AAP gives you role-based access control, including control over the use of securely stored credentials for SSH and other services. You can sync your inventory with a wide variety of cloud sources, and powerful multi-playbook workflows allow you to model complex processes.
It logs all of your jobs, integrates well with LDAP, SAML, and other authentication sources.  

<div class="grid cards" markdown>
<!-- markdownlint-disable MD030 -->
*   **Automation administration**

    ---

    * Automation Controller
    * Automation Hub
    * Event-Driven Ansible
    * Automation orchestrator

*   **Automation creation**

    ---

    * Ansible plug-ins for Red Hat Developer Hub
    * Ansible development tools & workspaces
    * Automation execution environments
    * Certified Ansible Content Collections

*   **Business Tools & Analytics**

    ---

    * Automation dashboard and automation analytics
    * Red Hat Insights

*   **AI Features**

    ---

    * Automation coding assistant
    * Automation intelligent assistant
    * Red Hat Lightspeed for automation
    * MCP Server Integration
<!-- markdownlint-enable MD030 -->
</div>

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
