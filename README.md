# ansible-role-java

Installs and configures Java (JDK or JRE).

## Notes for Ubuntu 14.04

At this time of writing, JDK 1.8 is not in the official apt repository. The
role adds a ppa repository and installs `oracle-java8-installer`, i.e. no JRE
support.

# Requirements

None

# Role Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `java_packages` | list of Java package name to install | `{{ __java_packages }}` |

## Debian-8.6

| Variable | Default |
|----------|---------|
| `__java_packages` | `["openjdk-8-jdk"]` |


## FreeBSD

| Variable | Default |
|----------|---------|
| `__java_packages` | `["java/openjdk8"]` |

## OpenBSD

| Variable | Default |
|----------|---------|
| `__java_packages` | `["jdk-1.8.0.72p0v0"]` |

## RedHat

| Variable | Default |
|----------|---------|
| `__java_packages` | `["java-1.8.0-openjdk"]` |

## Ubuntu-14.04

| Variable | Default |
|----------|---------|
| `__java_packages` | `["oracle-java8-installer"]` |

## Ubuntu-16.04

| Variable | Default |
|----------|---------|
| `__java_packages` | `["openjdk-8-jdk"]` |

# Dependencies

None

# Example Playbook

```yaml
- hosts: localhost
  roles:
    - ansible-role-java
  pre_tasks:
    - name: Kill autoupdate
      # `unattended-upgrade` is enabled by default and holds a lock on apt,
      # which prevents `ansible` to run `apt`. you cannot disable the command
      # because the command is scheduled to run at boot.
      #
      # TODO disable `unattended-upgrade` in the box image
      # https://github.com/chef/bento/pull/612
      command: pkill --full /usr/bin/unattended-upgrade
      become: true
      register: kill_result
      failed_when: kill_result.rc != 0
      changed_when: false
      when:
        - ansible_distribution == 'Ubuntu'
        - ansible_distribution_version | version_compare('16.04', '>=')
  vars:
    java_packages: "{% if ansible_os_family == 'FreeBSD' %}[ 'java/openjdk7', 'java/openjdk8-jre' ]{% elif ansible_os_family == 'RedHat' %}[ 'java-1.7.0-openjdk' ]{% elif ansible_os_family == 'OpenBSD' %}[ 'jdk-1.7.0.80p1v0' ]{% elif ansible_distribution == 'Ubuntu' and ansible_distribution_version | version_compare('16.04', '<') %}[ 'oracle-java8-installer', 'openjdk-7-jdk' ]{% elif ansible_distribution == 'Ubuntu' and ansible_distribution_version | version_compare('16.04', '>=') %}[ 'openjdk-8-jdk' ]{% elif ansible_distribution == 'Debian' %}[ 'openjdk-8-jdk' ]{% endif %}"
    apt_repo_to_add: "{% if ansible_distribution == 'Ubuntu' and ansible_distribution_version | version_compare('16.04', '<') %}[ 'ppa:webupd8team/java' ]{% elif ansible_distribution == 'Debian' %}[ 'deb http://ftp.debian.org/debian jessie-backports main' ]{% else %}[]{% endif %}"
```

# License

```
Copyright (c) 2016 Tomoyuki Sakurai <tomoyukis@reallyenglish.com>

Permission to use, copy, modify, and distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
```

# Author Information

Tomoyuki Sakurai <tomoyukis@reallyenglish.com>

This README was created by [qansible](https://github.com/trombik/qansible)
