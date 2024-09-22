# Creating the ssh keys

To create the needed ssh keys run the following commands:

```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/onemarc_rsa -C "onemarc_pub_key"
```

This will create to files: `~/.ssh/onemarc_rsa` and `~/.ssh/onemarc_rsa.pub`

and

```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/support_rsa -C "support_pub_key"
```

This will create to files: `~/.ssh/support_rsa` and `~/.ssh/support_rsa.pub`

The key `onemarc_rsa.pub` will be used for `root` access and the key `support_rsa.pub` will be used for scripting, mainly, with Ansible.

Connect using the `PRIVATE KEY`:

```bash
ssh -i ~/.ssh/onemarc_rsa ubuntu@192.168.8.111
```

Or add it to the host and connect without specifying the private key:

```bash
ssh-add ~/.ssh/onemarc_rsa
```

and ...

```bash
ssh ubuntu@192.168.8.111
```
