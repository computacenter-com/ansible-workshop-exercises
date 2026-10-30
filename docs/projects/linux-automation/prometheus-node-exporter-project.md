---
pdf: true
covers:
  front: ./docs/assets/pdf/ansible-projects-cover.html.j2
---

# Project - Linux automation

To further enhance your Ansible skills, let's **deploy the Prometheus Node exporter to all nodes in the demo environment**.  

**Prometheus is a systems and service monitoring system.** It collects metrics from configured targets at given intervals, evaluates rule expressions, displays the results, and can trigger alerts when specified conditions are observed.

<figure markdown>
  ![Prometheus Logo](prometheus-logo.png){ width=80% .off-glb }
  <figcaption></figcaption>
</figure>

Prometheus collects metrics from targets by scraping metrics HTTP endpoints. **Node Exporter is a specialized monitoring agent** designed for Prometheus that **collects and exposes detailed system-level metrics from host machines.**

## Guide

The overall goal of the project is:

* [X] Create an Ansible project *from scratch*
* [X] Find Ansible modules in the documentation and use them in a playbook
* [X] Download a binary archive from the internet to the managed nodes
* [X] Extract a binary from the archive to an executable location on Linux
* [X] Create a Linux service which runs the node exporter binary
* [X] Use Ansible roles

The playbook runs on your Ansible Control Node (*ansible-1*) and targets all managed nodes (*node1*, *node2* and *node3*). **Only the node exporter should be installed and running as a service**, the actual Prometheus server (where the node exporter would send its metrics to) is **not** part of the project.

```mermaid
flowchart LR
    prometheusServer["Prometheus Server<br><img src='https://raw.githubusercontent.com/prometheus/prometheus/b2e63376da7487c32ae4e2ec45434b0f4d8adb12/documentation/images/prometheus-logo.svg' /><br><b>Not part of project!</b>"]
    style prometheusServer fill:#bbf,stroke:#f66,stroke-width:2px,color:#fff,stroke-dasharray: 5 5
    controller["Ansible Control Node<br><img src='https://raw.githubusercontent.com/ansible/logos/628fad53cb2ca88c40e8c934b1cae146d71ffa09/community-marks/Ansible-Community-Mark-Black.svg' /><br>(ansible-1)"]
    nodeExporterNode1["Node Exporter Service"]
    nodeExporterNode2["Node Exporter Service"]
    nodeExporterNode3["Node Exporter Service"]

    controller -- installs --> nodeExporterNode1 -- sends metrics --> prometheusServer
    controller -- installs --> nodeExporterNode2 -- sends metrics --> prometheusServer
    controller -- installs --> nodeExporterNode3 -- sends metrics --> prometheusServer
    subgraph node1 [node1]
    nodeExporterNode1
    end
    subgraph node2 [node2]
    nodeExporterNode2
    end
    subgraph node3 [node3]
    nodeExporterNode3
    end
```

The Prometheus Node Exporter installation basically follows [this guide](https://prometheus.io/docs/guides/node-exporter/#installing-and-running-the-node-exporter){:target="_blank"}:

1. Download the Node Exporter tarball
2. Extract/unarchive the tarball
3. Copy `node_exporter` binary/executable to folder in `PATH`
4. Create user for Node Exporter
5. Create SystemD Service file for Node Exporter
6. Start and enable Node exporter service

---

### Step 1 - Prepare project

Create a new project folder in your home directory and change into the directory

``` { .console .no-copy }
[student@ansible-1 ~]$ mkdir prometheus_node_exporter
```

!!! tip "Tip"
    Open the folder in VScode to only show the necessary content in the VScode explorer view.

Create a **new inventory file**, it should define multiple groups, one for the *test environment*, one for all hosts in the *prod environment* and a *parent* group which targets all hosts.

| Group name                     | Parent group | Description                                                            |
| ------------------------------ | ------------ | ---------------------------------------------------------------------- |
| <nobr>`prometheus`</nobr>      |              | This group includes the groups `prometheus_test` and `prometheus_prod` |
| <nobr>`prometheus_test`</nobr> | `prometheus` | Holds `node1` only                                                     |
| <nobr>`prometheus_prod`</nobr> | `prometheus` | Holds `node2` **and** `node3`                                          |

Take a look at the [Ansible inventory documentation](https://docs.ansible.com/projects/ansible/latest/inventory_guide/intro_inventory.html#how-to-build-your-inventory){:target="_blank"}, especially on how to create [parent/child group relationships](https://docs.ansible.com/projects/ansible/latest/inventory_guide/intro_inventory.html#grouping-groups-parent-child-group-relationship){:target="_blank"}.

**Create a new Ansible configuration file** and instruct Ansible to always use the inventory you just created.

For example, you may check your inventory with the `ansible-inventory` CLI utility:

``` { .console .no-copy hl_lines='4 5 6 12' }
[student@ansible-1 ~]$ ansible-inventory --list --yaml
all:
  children:
    prometheus:
      children:
        prometheus_prod:
          hosts:
            node2:
              hostname: node2.example.com
            node3:
              hostname: node3.example.com
        prometheus_test:
          hosts:
            node1:
              hostname: node1.example.com
```

!!! info
    As you can see, no inventory was provided in the CLI call, but the correct inventory is used.

Now, create a **new playbook file**, it should include a *play* which targets the `prometheus_test` group.

!!! warning
    **Do not target the `prometheus` group** (yet).  
    Develop and test your automation against the *test environment* first, once everything is stable, you may target all nodes (**this is done in Step 5**).

Achieve the following tasks:

* [X] Inventory file created
* [X] Inventory contains all necessary groups and nodes in correct groups
* [X] Ansible Configuration file created which sets the correct inventory source
* [X] Playbook created which targets the *test environment* `prometheus_test`

---

### Step 2 - Download and extract

The latest Node Exporter release must be downloaded from the internet, **the download link can be obtained from the [Prometheus Download Page](https://prometheus.io/download/#node_exporter){:target="_blank"}**, right-click the tarball with `*linux-amd64.tar.gz` and choose copy link.

<figure markdown>
  ![Download Node Exporter tarball](prometheus-node-exporter-copy-link.png){ width=70% }
  <figcaption></figcaption>
</figure>

The content of the archive looks something like this (here the tarball was downloaded to `/tmp` and extracted):

```{ .yaml .no-copy }
$ ls -l /tmp/node_exporter-1.10.2.linux-amd64/
total 22400
-rw-r--r-- 1 node_exporter 1002    11357 Oct 25 20:10 LICENSE
-rw-r--r-- 1 node_exporter 1002      463 Oct 25 20:10 NOTICE
-rwxr-xr-x 1 node_exporter 1002 22919216 Oct 25 20:06 node_exporter # (1)!
```

1. This is the Node Exporter binary!

As you can see, the tarball was extracted into a folder with the basename of the archive (in the example `node_exporter-1.10.2.linux-amd64`), inside are three files, with the `node_exporter` binary as the most important one. **You will need this path later on.**

Achieve the following tasks:

* [X] Module(s) identified to download und unarchive tarball
* [X] Tarball is downloaded and unarchived on the managed node (via Ansible)

---

### Step 3 - Create user

The Node Exporter should run as a Linux **SystemD** service under the user `prometheus_metrics`. **The username value should be provided as a variable**, define the variable at a location of your choice.  

**Add a task that creates the user (using the variable)**, the user should not be able to login (shell should be set to `/sbin/nologin`), a home directory is also not necessary. Use the appropriate parameters of the module.

Achieve the following tasks:

* [X] User `prometheus_metrics` created **without** home directory and login shell

---

### Step 4 - Create service file

The following (**incomplete**) service file is missing the *user* and *group* (the same as the value for the *user*).
Use it as a *template* and add the missing variables. The service file **must** be present at `/etc/systemd/system/node-exporter.service` on the managed node, **add a task which uses an appropriate module to transfer the file/template to the managed node.**

```{ .ini hl_lines='7 8' }
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=
Group=
ExecStart=/usr/local/bin/node_exporter # (1)!

[Install]
WantedBy=multi-user.target
```

1. The binary which was inside the downloaded archive, copied to the path shown.

!!! tip "Tip"
    Managing/adjusting SystemD service files requires a *daemon-reload* every time a service unit file is changed!

The service file expects the binary at `/usr/local/bin/node_exporter` (see `ExecStart` parameter), **add another task which moves/copies the binary to the desired location. The binary must belong to the service user** (use the variable) **and be executable** (use `0755` permissions).  
Remember, the service file is already present on the managed node (you unarchived it earlier).

Achieve the following tasks:

* [X] Completed Service file transferred to managed node
* [X] Node Exporter binary present at correct location

---

### Step 5 - Start service

After transferring the service file and having the binary at the correct location, the systemd service itself must be started (and should be enabled at boot)! **Add an additional task to achieve this.** The Node Exporter service is called `node-exporter`.

!!! success "Test metrics export"

    The Node Exporter exposes the metrics on Port 9100, you can check this by cURLing the `/metrics` endpoint.  
    **Use the following *ad-hoc* command to check the successful export of metrics**:

    ```bash
    ansible prometheus_test -a "curl -s http://localhost:9100/metrics"
    ```

    If the Node Exporter was installed correctly and the service is running, you will receive output like the following:

    ```{ .console .no-copy }
    $ ansible prometheus_test -a "curl -s http://localhost:9100/metrics"
    node1 | CHANGED | rc=0 >>
    # HELP go_gc_duration_seconds A summary of the wall-time pause (stop-the-world) duration in garbage collection cycles.
    # TYPE go_gc_duration_seconds summary
    go_gc_duration_seconds{quantile="0"} 0
    go_gc_duration_seconds{quantile="0.25"} 0
    go_gc_duration_seconds{quantile="0.5"} 0
    go_gc_duration_seconds{quantile="0.75"} 0
    go_gc_duration_seconds{quantile="1"} 0
    go_gc_duration_seconds_sum 0
    go_gc_duration_seconds_count 0
    ...
    promhttp_metric_handler_requests_in_flight 1
    # HELP promhttp_metric_handler_requests_total Total number of scrapes by HTTP status code.
    # TYPE promhttp_metric_handler_requests_total counter
    promhttp_metric_handler_requests_total{code="200"} 0
    promhttp_metric_handler_requests_total{code="500"} 0
    promhttp_metric_handler_requests_total{code="503"} 0
    ```

    ??? failure "non-zero return code"

        A failed node exporter installation may look like this:

        ```bash
        $ ansible prometheus_test -a "curl -s http://localhost:9100/metrics"
        node1 | FAILED | rc=7 >>
        non-zero return code
        ```

        To troubleshooting/identify the problem, login to **node1** (the host in the `prometheus_test` group). The following commands may help you:

        ```bash title="User created?"
        getent passwd | grep prometheus_metrics
        ```

        ```bash title="Binary at the correct location? Permissions correct?"
        ls -l /usr/local/bin/node_exporter
        ```

        ```bash title="Binary at the correct location? Permissions correct?"
        stat -c '%F %a %n' /usr/local/bin/node_exporter
        ```

        Above command should show: `regular file 755 /usr/local/bin/node_exporter`

        ```bash title="Service File correct? User correct? No unnecessary whitespaces?"
        cat /etc/systemd/system/node-exporter.service
        ```

        ```bash title="Service state"
        sudo systemctl status node-exporter
        ```

        ```bash title="View service logs"
        sudo journalctl -xeu node-exporter
        ```

Achieve the following tasks:

* [X] Node Exporter service is running and enabled at boot
* [X] Metrics are exported

---

### Step 6 - Re-format project to role structure

All Ansible projects should use the role structure, if your project does not already uses it, now is the time to rearrange your content.  
Create a `roles` folder and an appropriately named sub-folder for the node exporter deployment with all necessary folder and files.  
Change your playbook to use your role.

Make sure everything works by executing your playbook again.

!!! tip
    **Your playbook should target the `prometheus` group now.**  
    If you created the tasks in *idempotent* manner, you should see green Ok states on node1 and yellow Changed states for node2 and node3.

As a nice to have, your role should use **multiple** tasks files, otherwise you'll only copy the playbook tasks into the tasks file of the role.  

!!! success
    Create two additional task files (next to the `main.yml`), one for the download and extraction tasks and another one which sets up and starts the node exporter service.  

The `main.yml` tasks file should only [import the two other task file](https://docs.ansible.com/projects/ansible/latest/collections/ansible/builtin/import_tasks_module.html){:target="_blank"}.

Achieve the following tasks:

* [X] Project uses Ansible role structure
* [X] Playbook references role and targets the `prometheus` group
* [X] Playbook runs successful

Optional, but recommended:

* [ ] Role uses multiple tasks files

---

### Step 7 - Optional: Upload project to Github

Create a new project in your personal Github account and commit your Ansible project.

---

### Step 8 - Optional: Run your project within AAP

Create a new project in AAP, reference your node exporter project from Github as the code source. Create a template and run your playbook.
